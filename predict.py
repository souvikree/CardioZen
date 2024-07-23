# predict.py
import numpy as np
import joblib
import sys
import json

# Load the trained model and scaler
model = joblib.load('heart_disease_model.pkl')  # Ensure this file is in the same directory
scaler = joblib.load('scaler.pkl')  # Ensure this file is in the same directory

# Read input data from stdin
input_data = sys.stdin.read()
input_json = json.loads(input_data)

# Prepare the input for the model
input_array = np.array(input_json).reshape(1, -1)
scaled_data = scaler.transform(input_array)

# Make a prediction
prediction = model.predict(scaled_data)

# Output the prediction as JSON
print(json.dumps({"prediction": int(prediction[0])}))
