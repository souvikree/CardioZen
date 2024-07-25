import json
from flask import Flask, request, jsonify
import joblib
import base64
import io
import numpy as np

app = Flask(__name__)

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

@app.route('/api/predict/hpredict', methods=['POST'])
def predict():
    try:
        input_json = request.json
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
        input_features = [input_json[key] for key in feature_mapping.keys()]
        input_array = np.array(input_features).reshape(1, -1)
        scaled_data = scaler.transform(input_array)
        prediction = model.predict(scaled_data)
        heart_disease_status = 'presence' if prediction[0] == 1 else 'absence'
        return jsonify({"heartDisease": heart_disease_status})
    except Exception as e:
        return jsonify({"error": "An error occurred during prediction", "details": str(e)})

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8000, debug=True)
