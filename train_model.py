import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier
import pickle

def train_model():
    print("Starting model training...")
    
    # Load dataset
    try:
        data = pd.read_csv('Heart_Disease_Prediction.csv')
        print("Dataset loaded successfully.")
    except Exception as e:
        print(f"Error loading dataset: {e}")
        return

    # Print column names to verify
    print("Column names in dataset:", data.columns)

    # Separate features and target variable
    try:
        # Update column name here
        X = data.drop('Heart Disease', axis=1)  # Features
        y = data['Heart Disease']  # Target variable
        print("Features and target variable separated.")
    except KeyError as e:
        print(f"Error in column names: {e}")
        return

    # Split data into training and test sets
    try:
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
        print("Data split into training and test sets.")
    except Exception as e:
        print(f"Error splitting data: {e}")
        return

    # Initialize and train the model
    try:
        scaler = StandardScaler()
        X_train_scaled = scaler.fit_transform(X_train)
        X_test_scaled = scaler.transform(X_test)

        model = RandomForestClassifier(n_estimators=100, random_state=42)
        model.fit(X_train_scaled, y_train)
        print("Model trained successfully.")
    except Exception as e:
        print(f"Error training model: {e}")
        return

    # Save the model and scaler
    try:
        with open('heart_disease_model.pkl', 'wb') as model_file:
            pickle.dump(model, model_file)
        
        with open('scaler.pkl', 'wb') as scaler_file:
            pickle.dump(scaler, scaler_file)
        print("Model and scaler saved successfully.")
    except Exception as e:
        print(f"Error saving model or scaler: {e}")

if __name__ == "__main__":
    train_model()
