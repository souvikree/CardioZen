const express = require('express');
const { handlePredictionRequest } = require('../Controllers/predictionController');

const router = express.Router();

// Define the route for prediction
router.post('/hpredict',  handlePredictionRequest);

module.exports = router;
