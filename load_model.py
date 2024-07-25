import pickle
import base64
import json
import logging
import os

# Configure logging
logging.basicConfig(level=logging.INFO)

def serialize_object(obj):
    # Serialize using pickle
    serialized = pickle.dumps(obj)
    return base64.b64encode(serialized).decode('utf-8')

def load_model_and_scaler():
    model_path = 'heart_disease_model.pkl'
    scaler_path = 'scaler.pkl'
    
    if not (os.path.exists(model_path) and os.path.exists(scaler_path)):
        raise FileNotFoundError(f"Model or scaler file not found at {model_path} or {scaler_path}")

    with open(model_path, 'rb') as file:
        model = pickle.load(file)

    with open(scaler_path, 'rb') as file:
        scaler = pickle.load(file)

    return model, scaler

if __name__ == "__main__":
    try:
        model, scaler = load_model_and_scaler()
        data = {
            'model': serialize_object(model),
            'scaler': serialize_object(scaler)
        }
        print(json.dumps(data))
    except Exception as e:
        logging.error(f"An error occurred: {e}")
        print(json.dumps({"error": str(e)}))
