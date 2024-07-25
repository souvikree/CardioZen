import json
from flask import Flask, request, jsonify
import joblib
import base64
import io
import numpy as np
from flask_pymongo import PyMongo
from functools import wraps
from bson.objectid import ObjectId

app = Flask(__name__)

# Configure the MongoDB database
app.config["MONGO_URI"] = "mongodb+srv://swooshyboi003:soureeksta@cluster0.estzco3.mongodb.net/CardioZen?retryWrites=true&w=majority&appName=Cluster0"
mongo = PyMongo(app)

def deserialize_object(encoded_str):
    decoded = base64.b64decode(encoded_str)
    buffer = io.BytesIO(decoded)
    return joblib.load(buffer)

def load_model_and_scaler():
    with open('model_data.json', 'r') as json_file:
        json_data = json_file.read()
    data = json.loads(json_data)
    model = deserialize_object(data['model'])
    scaler = deserialize_object(data['scaler'])
    return model, scaler

model, scaler = load_model_and_scaler()

# Authorization check decorator
def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        if 'Authorization' in request.headers:
            token = request.headers['Authorization'].split(" ")[1]
        if not token:
            return jsonify({'message': 'Token is missing!'}), 401
        # Here you can add logic to validate the token
        # if not valid_token(token):
        #     return jsonify({'message': 'Token is invalid!'}), 401
        return f(*args, **kwargs)
    return decorated

@app.route('/api/predict/hpredict', methods=['POST'])
@token_required
def predict():
    try:
        # Get the input data from the request
        input_json = request.json
        
        # Define feature mapping
        feature_mapping = {
            'age': 'Age',
            'sex': 'Sex',
            'chestPainType': 'Chest pain type',
            'bp': 'BP',
            'cholesterol': 'Cholesterol',
            'fbsOver120': 'FBS over 120',
            'ekgResults': 'EKG results',
            'maxHr': 'Max HR',
            'exerciseAngina': 'Exercise angina',
            'stDepression': 'ST depression',
            'slopeOfSt': 'Slope of ST',
            'numberOfVesselsFluro': 'Number of vessels fluro',
            'thallium': 'Thallium'
        }

        # Extract input features from the request
        input_features = [input_json.get(key) for key in feature_mapping.keys()]
        input_array = np.array(input_features).reshape(1, -1)

        # Scale the input data
        scaled_data = scaler.transform(input_array)

        # Make a prediction
        prediction = model.predict(scaled_data)
        heart_disease_status = 'presence' if prediction[0] == 1 else 'absence'
        
        # Add heart disease status to input data
        input_json['heartDisease'] = heart_disease_status

        # Store the prediction data in MongoDB
        result = mongo.db.predictions.insert_one(input_json)

        # Convert ObjectId to string for JSON serialization
        input_json['_id'] = str(result.inserted_id)

        # Return the modified input data with a success message
        response_data = {
            "message": "Prediction data saved successfully",
            "inputData": input_json
        }
        return jsonify(response_data), 201

    except Exception as e:
        return jsonify({"error": "An error occurred during prediction", "details": str(e)}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8000, debug=True)
