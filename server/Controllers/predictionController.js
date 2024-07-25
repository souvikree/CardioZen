const { spawn } = require('child_process');
const path = require('path');
const UserInput = require('../Models/userInputModel'); // Import the model
const picklejs = require('picklejs'); // Ensure this is installed via npm

let model, scaler;

function deserializeObject(base64String) {
    const buffer = Buffer.from(base64String, 'base64');
    return picklejs.load(buffer);
}

async function loadModel() {
    try {
        const pythonScriptPath = path.join(__dirname, '../../load_model.py');
        const pythonProcess = spawn('python', [pythonScriptPath]);

        return new Promise((resolve, reject) => {
            let data = '';
            let error = '';

            pythonProcess.stdout.on('data', (chunk) => {
                data += chunk;
            });

            pythonProcess.stderr.on('data', (chunk) => {
                error += chunk;
            });

            pythonProcess.on('close', (code) => {
                if (code !== 0) {
                    reject(new Error(`Python process exited with code ${code}: ${error}`));
                }
                try {
                    const { model: serializedModel, scaler: serializedScaler } = JSON.parse(data);
                    model = deserializeObject(serializedModel);
                    scaler = deserializeObject(serializedScaler);
                    resolve();
                } catch (error) {
                    reject(new Error('Failed to parse model or scaler data'));
                }
            });
        });
    } catch (error) {
        console.error('Error loading model or scaler:', error);
        throw error;
    }
}

exports.predictHeartDisease = async (req, res, next) => {
    try {
        if (!model || !scaler) {
            await loadModel();
        }

        const inputData = req.body;

        const pythonProcess = spawn('python', [path.join(__dirname, '../../predict.py')]);

        pythonProcess.stdin.write(JSON.stringify(inputData));
        pythonProcess.stdin.end();

        let data = '';
        let error = '';

        pythonProcess.stdout.on('data', (chunk) => {
            data += chunk;
        });

        pythonProcess.stderr.on('data', (chunk) => {
            error += chunk;
        });

        pythonProcess.on('close', async (code) => {
            if (code !== 0) {
                return res.status(500).json({ error: `Prediction process failed: ${error}` });
            }
            try {
                if (!data) {
                    throw new Error('No data received from Python script');
                }
                const prediction = JSON.parse(data);

                // Save user input and prediction to the database
                const userInput = new UserInput({
                    ...inputData,
                    heartDisease: prediction.prediction // Adjust field name to match Python output
                });

                await userInput.save();
                res.status(200).json({
                    success: true,
                    prediction: prediction.prediction, // Return prediction result
                    data: userInput
                });
            } catch (error) {
                next(error);
            }
        });
    } catch (error) {
        next(error);
    }
};
