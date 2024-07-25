import joblib
import base64
import json
import io

def deserialize_object(encoded_str):
    # Decode the base64 string and load the object using joblib
    decoded = base64.b64decode(encoded_str)
    buffer = io.BytesIO(decoded)
    return joblib.load(buffer)

if __name__ == "__main__":
    # Read JSON data from the file
    with open('model_data.json', 'r') as json_file:
        json_data = json_file.read()
        
    data = json.loads(json_data)

    model = deserialize_object(data['model'])
    scaler = deserialize_object(data['scaler'])

    # Now you can use model and scaler for predictions or other purposes
    print("Model and scaler deserialized successfully")
