const express = require('express');
const router = express.Router();
const predictionController = require('../Controllers/predictionController');

// Route to handle prediction requests
router.post('/predict', predictionController.predict);

module.exports = router;
