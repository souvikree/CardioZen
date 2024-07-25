const mongoose = require('mongoose');

// Define schema for user input data
const userInputSchema = new mongoose.Schema({
    age: { 
        type: String, 
        required: true 
    },
    sex: { 
        type: String, 
        required: true 
    },
    chestPainType: { 
        type: String, 
        required: true 
    },
    bp: { 
        type: String, 
        required: true 
    },
    cholesterol: { 
        type: String, 
        required: true 
    },
    fbsOver120: { 
        type: String, 
        required: true 
    },
    ekgResults: { 
        type: String, 
        required: true 
    },
    maxHr: { 
        type: String, 
        required: true 
    },
    exerciseAngina: { 
        type: String, 
        required: true 
    },
    stDepression: { 
        type: String, 
        required: true 
    },
    slopeOfSt: { 
        type: String, 
        required: true 
    },
    numberOfVesselsFluro: { 
        type: String, 
        required: true 
    },
    thallium: { 
        type: String, 
        required: true 
    },
    heartDisease: {
        type: String,
        enum: ['presence', 'absence'], // Restrict values to 'presence' or 'absence'
        required: true // Make this field required
    },
}, { timestamps: true });

// Create and export UserInput model based on the schema
const UserInput = mongoose.model('UserInput', userInputSchema);

module.exports = UserInput;
