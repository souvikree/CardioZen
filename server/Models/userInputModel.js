const mongoose = require('mongoose');

// Define schema for user input data
const userInputSchema = new mongoose.Schema({
    age: String,
    sex: String,
    chestPainType: String,
    bp: String,
    cholesterol: String,
    fbsOver120: String,
    ekgResults: String,
    maxHr: String,
    exerciseAngina: String,
    stDepression: String,
    slopeOfSt: String,
    numberOfVesselsFluro: String,
    thallium: String,
    heartDisease: String,  // Presence or Absence
}, { timestamps: true });

// Create and export UserInput model based on the schema
const UserInput = mongoose.model('UserInput', userInputSchema);

module.exports = UserInput;
