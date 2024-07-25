// models/Prediction.js
const mongoose = require('mongoose');

const PredictionSchema = new mongoose.Schema({
    inputData: {
        type: Object,
        required: true
    },
    heartDisease: {
        type: String,
        required: true
    }
});

module.exports = mongoose.model('Prediction', PredictionSchema);
