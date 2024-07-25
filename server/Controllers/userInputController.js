const { predictHeartDisease } = require('./predictionController'); // Adjust the path as necessary
const UserInput = require('../Models/userInputModel'); // Adjust path as necessary

exports.saveUserInputWithPrediction = async (req, res, next) => {
    try {
        const userInputData = req.body;

        // Create a mock request and response object for the prediction function
        const mockReq = {
            body: userInputData
        };

        const mockRes = {
            status: (_statusCode) => {
                return {
                    json: (data) => {
                        // Store the prediction result in the `prediction` variable
                        this.prediction = data;
                    }
                };
            }
        };

        // Call the prediction function with a callback
        predictHeartDisease(mockReq, mockRes, (error) => {
            if (error) {
                return next(error);
            }

            // Get the prediction result from the mock response
            const predictionResult = mockRes.prediction;

            // Create a new UserInput document with the prediction result
            const userInputWithPrediction = new UserInput({
                ...userInputData,
                heartDisease: predictionResult // Add the prediction result
            });

            // Save the input data to the database
            userInputWithPrediction.save()
                .then(() => {
                    res.status(201).json({
                        success: true,
                        message: 'User input data with prediction saved successfully',
                        data: userInputWithPrediction
                    });
                })
                .catch((error) => {
                    next(error);
                });
        });
    } catch (error) {
        next(error);
    }
};
exports.getAllPredictions = async (req, res, next) => {
    try {
        // Fetch all records from the UserInput collection
        const predictions = await UserInput.find({});

        // Respond with the fetched predictions
        res.status(200).json({
            success: true,
            data: predictions
        });
    } catch (error) {
        next(error);
    }
};