
const Prediction = require('../Models/Prediction');



exports.getAllPredictions = async (req, res) => {
    try {
        const userId = req.user.id; 
        const predictions = await Prediction.find({ userId });
        res.status(200).json(predictions);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};


