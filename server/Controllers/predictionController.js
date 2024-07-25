const { PythonShell } = require('python-shell');
const path = require('path');
const UserInput = require('../Models/userInputModel');  // Adjust the path as needed

// Load model and scaler (if needed, based on your use case)
async function loadModel() {
    try {
        // Note: Loading model is not used in this case
        console.log("Loading model is not needed here");
    } catch (error) {
        console.error('Error loading model:', error);
        throw error;
    }
}

// Predict heart disease based on input data
async function predictHeartDisease(inputData) {
    const options = {
        mode: 'text',
        pythonOptions: ['-u'],
        scriptPath: path.join(__dirname, '../../'),
        args: [JSON.stringify(inputData)]
    };

    return new Promise((resolve, reject) => {
        PythonShell.run('predict.py', options, (err, result) => {
            if (err) {
                reject(err);
            } else {
                try {
                    const prediction = JSON.parse(result[0]);
                    resolve(prediction);
                } catch (parseError) {
                    reject(new Error('Failed to parse prediction result'));
                }
            }
        });
    });
}

// Handle prediction requests
exports.handlePredictionRequest = async (req, res, next) => {
    try {
        // Ensure model is loaded if necessary
        // await loadModel(); // Commented out since model loading is not needed here

        const inputData = req.body;
        const prediction = await predictHeartDisease(inputData);

        // Update to use 'heartDisease' directly from prediction result
        const heartDiseaseStatus = prediction.heartDisease;

        // Save user input and prediction to the database
        const userInput = new UserInput({
            ...inputData,
            heartDisease: heartDiseaseStatus
        });

        await userInput.save();
        res.status(200).json({
            success: true,
            prediction: heartDiseaseStatus,
            data: userInput
        });
    } catch (error) {
        console.error('Error handling prediction request:', error);
        next(error);
    }
};
