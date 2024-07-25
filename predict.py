import numpy as np
import joblib
import sys
import json
import logging
import os  # Add this import statement

# Configure logging
logging.basicConfig(level=logging.INFO)

def main():
    try:
        # Load the trained model and scaler
        model = joblib.load('heart_disease_model.pkl')
        scaler = joblib.load('scaler.pkl')
        logging.info("Model and scaler loaded successfully")

        # Read input data from stdin
        input_data = sys.stdin.read()
        input_json = json.loads(input_data)
        
        # Prepare the input for the model
        input_array = np.array(input_json).reshape(1, -1)
        scaled_data = scaler.transform(input_array)
        
        # Make a prediction
        prediction = model.predict(scaled_data)
        logging.info("Prediction made successfully")
        
        # Output the prediction as JSON
        print(json.dumps({"prediction": int(prediction[0])}))
    
    except Exception as e:
        logging.error(f"An error occurred: {e}")
        # Output an error message as JSON
        print(json.dumps({"error": "An error occurred during prediction"}))

if __name__ == "__main__":
    main()
