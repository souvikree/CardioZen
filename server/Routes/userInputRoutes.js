const express = require('express');
const {
    
    

    saveUserInputWithPrediction,
    getAllPredictions
} = require('../Controllers/userInputController');
const authMiddleware = require('../Middlewares/authMiddleware');

const router = express.Router();

// Define routes for user input
router.post('/save',authMiddleware, saveUserInputWithPrediction);
router.get('/all', authMiddleware,getAllPredictions );

module.exports = router;
