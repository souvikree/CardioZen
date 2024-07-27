const express = require('express');
const {  getPrediction, getAllPredictions } = require('../Controllers/predictionController');
const authMiddleware = require('../Middlewares/authMiddleware');

const router = express.Router();

// Define the route for prediction
// router.post('/hpredict',  handlePredictionRequest);
router.post('/sav', authMiddleware, async (req, res) => {
    try {
        const inputData = req.body; // Get input data from the request body

        // Ensure inputData is valid before processing (optional)
        if (!inputData || typeof inputData !== 'object') {
            return res.status(400).json({ error: 'Invalid input data' });
        }

        const prediction = await getPrediction(inputData); // Call the controller function

        res.json(prediction); // Return the prediction response
    } catch (error) {
        res.status(500).json({ error: 'Failed to get prediction' });
    }
});

router.get('/predictions', authMiddleware, getAllPredictions)


module.exports = router;
