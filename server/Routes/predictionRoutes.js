const express = require('express');
const {  getAllPredictions } = require('../Controllers/predictionController');
const authMiddleware = require('../Middlewares/authMiddleware');

const router = express.Router();


router.get('/predictions', authMiddleware, getAllPredictions)


module.exports = router;
