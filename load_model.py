import joblib
import base64
import json
import logging
import os
import io

logging.basicConfig(level=logging.INFO)

def serialize_object(obj):
    # Serialize using joblib
    buffer = io.BytesIO()
    joblib.dump(obj, buffer)
    buffer.seek(0)
    return base64.b64encode(buffer.read()).decode('utf-8')

def load_model_and_scaler():
    model_path = 'heart_disease_model.pkl'
    scaler_path = 'scaler.pkl'

    if not (os.path.exists(model_path) and os.path.exists(scaler_path)):
        raise FileNotFoundError(f"Model or scaler file not found at {model_path} or {scaler_path}")

    # Use joblib to load the model and scaler
    model = joblib.load(model_path)
    scaler = joblib.load(scaler_path)

    return model, scaler

if __name__ == "__main__":
    try:
        model, scaler = load_model_and_scaler()
        data = {
            'model': serialize_object(model),
            'scaler': serialize_object(scaler)
        }
        json_data = json.dumps(data)
        
        # Save JSON data to a file
        with open('model_data.json', 'w') as json_file:
            json_file.write(json_data)
        
        print("Model and scaler data saved to model_data.json")
    except Exception as e:
        logging.error(f"An error occurred: {e}")
        print(json.dumps({"error": str(e)}))