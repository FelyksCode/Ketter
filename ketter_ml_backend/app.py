from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd
import numpy as np
import random
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import os

app = Flask(__name__)
CORS(app)  # Enable CORS for all origins (Crucial for Flutter Web)

# Global model variable
model = None

def generate_noisy_epro(label):
    """
    Simulates real-world patient reporting variability (ePRO) for sepsis.
    - Sepsis (1): 60% Terrible (2), 30% Poor (1), 10% Fine (0)
    - Healthy (0): 80% Fine (0), 15% Poor (1), 5% Terrible (2)
    """
    if label == 1:
        return np.random.choice([2, 1, 0], p=[0.60, 0.30, 0.10])
    else:
        return np.random.choice([0, 1, 2], p=[0.80, 0.15, 0.05])

def train_model_on_startup():
    global model
    print("Initializing Data and Training Model...")

    # 1. Load or Generate Data
    # In a real scenario, we'd load Kaggle datasets here.
    # For this microservice, we simulate if files are missing.
    sepsis_path = 'sepsis_clinical.csv'
    fitbit_path = 'fitbit_healthy.csv'

    if os.path.exists(sepsis_path) and os.path.exists(fitbit_path):
        df_sepsis = pd.read_csv(sepsis_path)
        df_fitbit = pd.read_csv(fitbit_path)
    else:
        # Create dummy data if files missing
        print("Source files not found. Generating dummy training data...")
        df_sepsis = pd.DataFrame({
            'HR': np.random.normal(110, 15, 1000),
            'Temp': np.random.uniform(38.0, 40.0, 1000),
            'SepsisLabel': [1] * 1000
        })
        df_fitbit = pd.DataFrame({
            'HeartRate': np.random.normal(70, 10, 1000),
            'Steps': np.random.randint(50, 150, 1000),
            'SepsisLabel': [0] * 1000
        })

    # Renaming and Imputation (The Frankenstein Step)
    df_fitbit = df_fitbit.rename(columns={'HeartRate': 'HR'})
    df_sepsis['Steps'] = np.random.randint(0, 51, size=len(df_sepsis)) # Bedridden
    df_fitbit['Temp'] = np.random.uniform(36.0, 37.5, size=len(df_fitbit)) # Normal

    # Synthetic ePRO Injection
    df_sepsis['User_Score'] = df_sepsis['SepsisLabel'].apply(generate_noisy_epro)
    df_fitbit['User_Score'] = df_fitbit['SepsisLabel'].apply(generate_noisy_epro)

    # Combine
    df = pd.concat([df_sepsis, df_fitbit], ignore_index=True)
    df = df.sample(frac=1).reset_index(drop=True)

    # Training
    features = ['HR', 'Temp', 'Steps', 'User_Score']
    X = df[features]
    y = df['SepsisLabel']

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    model = RandomForestClassifier(n_estimators=100, random_state=42)
    model.fit(X_train, y_train)
    print("Model Training Complete.")

@app.route('/predict', methods=['POST'])
def predict():
    if model is None:
        return jsonify({'error': 'Model not trained'}), 500

    data = request.get_json()
    try:
        hr = float(data['hr'])
        temp = float(data['temp'])
        steps = float(data['steps'])
        user_score = int(data['user_score'])

        # Prepare feature vector
        features = np.array([[hr, temp, steps, user_score]])

        # Inference
        prediction = model.predict(features)[0]
        probability = model.predict_proba(features)[0][1]

        return jsonify({
            'sepsis_detected': bool(prediction == 1),
            'risk_probability': round(float(probability), 4),
            'status': 'success'
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy', 'model_loaded': model is not None})

if __name__ == '__main__':
    train_model_on_startup()
    app.run(host='0.0.0.0', port=5000)
