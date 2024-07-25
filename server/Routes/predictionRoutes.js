const express = require('express');
const { predictHeartDisease } = require('../Controllers/predictionController');

const router = express.Router();

// Define the route for prediction
router.post('/hpredict',  predictHeartDisease);

module.exports = router;
