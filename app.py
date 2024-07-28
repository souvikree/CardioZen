import json
from flask import Flask, request, jsonify
import joblib
import base64
import io
import numpy as np
from flask_pymongo import PyMongo
from functools import wraps
from bson.objectid import ObjectId
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)

# Configure the MongoDB database using environment variable
app.config["MONGO_URI"] = os.getenv("MONGO_URI")
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

def map_descriptions_to_values(input_json):
    mapping = {
        "Typical Angina (1)": 1,
        "Atypical Angina (2)": 2,
        "Non-anginal Pain (3)": 3,
        "Asymptomatic (4)": 4,
        "Normal (0)": 0,
        "ST-T wave abnormality (1)": 1,
        "Left ventricular hypertrophy (2)": 2,
        "Upsloping (1)": 1,
        "Flat (2)": 2,
        "Downsloping (3)": 3,
        "Normal (3)": 3,
        "Fixed defect (6)": 6,
        "Reversible defect (7)": 7
    }

    fields_to_map = [
        "chestPainType",
        "ekgResults",
        "slopeOfSt",
        "thallium"
    ]

    for field in fields_to_map:
        if field in input_json:
            input_json[field] = mapping.get(input_json[field], input_json[field])

    return input_json

@app.route('/api/predict/hpredict', methods=['POST'])
@token_required
def predict():
    try:
        # Get the input data from the request
        input_json = request.json

        # Map 'male' to 1, 'female' and 'others' to 0 for the 'sex' field
        if 'sex' in input_json:
            sex = input_json['sex'].lower()
            if sex == 'male':
                input_json['sex'] = 1
            else:
                input_json['sex'] = 0
        
        # Map 'yes' to 1, 'no' to 0 for 'fbsOver120' and 'exerciseAngina' fields
        if 'fbsOver120' in input_json:
            input_json['fbsOver120'] = 1 if input_json['fbsOver120'].lower() == 'yes' else 0
        if 'exerciseAngina' in input_json:
            input_json['exerciseAngina'] = 1 if input_json['exerciseAngina'].lower() == 'yes' else 0
        
        # Map descriptive strings to their corresponding numeric values
        input_json = map_descriptions_to_values(input_json)

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
    app.run(host='0.0.0.0', port=8080, debug=True)