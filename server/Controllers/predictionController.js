const { exec } = require('child_process');
const path = require('path');

// Function to run the Python script and get predictions
function getPrediction(inputData, callback) {
    const pythonScriptPath = path.join(__dirname, '../predict.py');
    const inputJson = JSON.stringify(inputData);

    exec(`python ${pythonScriptPath}`, { input: inputJson }, (error, stdout, stderr) => {
        if (error) {
            console.error(`Error executing Python script: ${error}`);
            return callback(error, null);
        }
        if (stderr) {
            console.error(`Python script stderr: ${stderr}`);
            return callback(stderr, null);
        }

        // Parse the JSON output
        const result = JSON.parse(stdout);
        callback(null, result);
    });
}

// Controller function to handle prediction requests
exports.predict = (req, res, next) => {
    const inputData = req.body;  // Expecting JSON input from the request body

    getPrediction(inputData, (error, result) => {
        if (error) {
            return next(error);
        }
        res.json(result);
    });
};
