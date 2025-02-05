import sys
import numpy as np
import json
import logging
import joblib
import base64
import io

# Configure logging
logging.basicConfig(level=logging.INFO)

def deserialize_object(encoded_str):
    # Decode the base64 string and load the object using joblib
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

if __name__ == "__main__":
    try:
        # Load the trained model and scaler
        model, scaler = load_model_and_scaler()
        logging.info("Model and scaler loaded successfully")

        # Read input data from stdin
        input_data = sys.stdin.read()
        
        if not input_data:
            raise ValueError("No input data provided")

        input_json = json.loads(input_data)
        
        # Mapping input data to model feature columns
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
        
        # Make a prediction
        prediction = model.predict(scaled_data)
        logging.info("Prediction made successfully")
        
        # Output the prediction as JSON with 'heartDisease' key
        heart_disease_status = 'presence' if prediction[0] == 1 else 'absence'
        print(json.dumps({"heartDisease": heart_disease_status}))
    
    except Exception as e:
        logging.error(f"An error occurred: {e}")
        # Output an error message as JSON
        print(json.dumps({"error": "An error occurred during prediction", "details": str(e)}))
