// const axios = require('axios');
// const UserInput = require('../Models/userInputModel');

// // Function to save data to the database
// async function saveDataToDatabase(data) {
//     try {
//         const response = await axios.post('http://192.168.0.129:8000/api/predict/save', data);
//         return response.data;
//     } catch (error) {
//         throw new Error(`Error saving data to the database: ${error.message}`);
//     }
// }

// // Function to forward request to Flask API
// async function forwardRequestToFlask(inputData) {
//     try {
//         const response = await axios.post('http://192.168.0.129:8000/api/predict/hpredict', inputData);
//         return response.data;
//     } catch (error) {
//         throw new Error(`Error forwarding request to Flask API: ${error.message}`);
//     }
// }

// // Handle prediction requests
// exports.handlePredictionRequest = async (req, res, next) => {
//     try {
//         // Receive input data from the client
//         const inputData = req.body;
//         console.log('Received input data:', inputData);

//         // Forward the request to the Flask API to get the prediction result
//         const predictionResponse = await forwardRequestToFlask(inputData);
//         console.log('Prediction response from Flask:', predictionResponse);

//         // Extract heartDisease status from the response
//         const heartDiseaseStatus = predictionResponse.inputData.heartDisease;

//         // Prepare data to save, including input data and prediction result
//         const dataToSave = {
//             ...predictionResponse.inputData,
//             heartDisease: heartDiseaseStatus
//         };

//         // Save the data to the database
//         await saveDataToDatabase(dataToSave);
//         console.log('Data saved successfully');

//         // Send a success response with the saved data
//         res.status(201).json({
//             success: true,
//             message: 'Data successfully saved to the database',
//             heartDisease: heartDiseaseStatus,
//             data: dataToSave
//         });
        
//     } catch (error) {
//         console.error('Error handling prediction request:', error);
//         // Send an error response with details
//         res.status(500).json({
//             success: false,
//             message: 'Failed to handle prediction request',
//             error: error.message
//         });
//     }
// };



// Controllers/predictionController.js

const axios = require('axios');
const Prediction = require('../Models/Prediction'); // Import the Mongoose model

// Define the base URL of your Flask API
const FLASK_API_URL = 'http://192.168.0.129:8000/api/predict/hpredict';

// Function to send prediction request to the Flask API and save the result
const getPrediction = async (inputData) => {
    try {
        // Make a POST request to the Flask API with the input data
        const response = await axios.post(FLASK_API_URL, inputData);

        // Extract the data from the response
        const responseData = response.data;

        // Save the response data to the database
        const prediction = new Prediction({
            inputData: responseData.inputData,
            heartDisease: responseData.inputData.heartDisease
        });

        await prediction.save();

        // Return the response data
        return responseData;
    } catch (error) {
        console.error('Error making prediction request:', error.message);
        throw error;
    }
};

module.exports = {
    getPrediction
};
