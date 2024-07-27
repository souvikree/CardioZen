// server/Models/Prediction.js

const mongoose = require('mongoose');

const predictionSchema = new mongoose.Schema({
    age: Number,
    sex: Number,
    chestPainType: Number,
    bp: Number,
    cholesterol: Number,
    fbsOver120: Number,
    ekgResults: Number,
    maxHr: Number,
    exerciseAngina: Number,
    stDepression: Number,
    slopeOfSt: Number,
    numberOfVesselsFluro: Number,
    thallium: Number,
    heartDisease: String,
    date: { type: Date, default: Date.now }
});

const Prediction = mongoose.model('Prediction', predictionSchema);

module.exports = Prediction;
