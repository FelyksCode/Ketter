import pandas as pd
import numpy as np
import random
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, classification_report
import joblib
import os

def run_pipeline():
    # 1. Data Fusion (The Frankenstein Step)
    print("Loading datasets...")
    df_clinical = pd.read_csv('ketter_ai/sepsis_clinical.csv')
    df_fitbit = pd.read_csv('ketter_ai/fitbit_healthy.csv')

    # Rename columns to match
    df_fitbit = df_fitbit.rename(columns={'HeartRate': 'HR'})

    # Impute Missing Vitals
    print("Imputing missing values...")
    # Clinical lacks Steps
    df_clinical['Steps'] = np.random.randint(0, 51, size=len(df_clinical))
    # Fitbit lacks Temp
    df_fitbit['Temp'] = np.random.uniform(36.5, 37.5, size=len(df_fitbit))

    # 2. Synthetic ePRO Injection
    print("Injecting synthetic ePRO data...")
    def generate_user_score(label):
        if label == 1:
            # 90% chance of Poor/Terrible (2,3), 10% noise as Good/Okay (0,1)
            if random.random() < 0.9:
                return random.choice([2, 3])
            else:
                return random.choice([0, 1])
        else:
            # Always Good/Okay for healthy
            return random.choice([0, 1])

    df_clinical['User_Score'] = df_clinical['SepsisLabel'].apply(generate_user_score)
    df_fitbit['User_Score'] = df_fitbit['SepsisLabel'].apply(generate_user_score)

    # Combine
    df = pd.concat([df_clinical, df_fitbit], ignore_index=True)
    df = df.sample(frac=1, random_state=42).reset_index(drop=True)

    # 3. Model Training
    print("Training model...")
    features = ['HR', 'Temp', 'Steps', 'User_Score']
    X = df[features]
    y = df['SepsisLabel']

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    model = RandomForestClassifier(n_estimators=100, random_state=42)
    model.fit(X_train, y_train)

    # 4. Validation (The "Proof")
    print("\n--- Validation Results ---")
    y_pred = model.predict(X_test)
    print("Confusion Matrix:")
    print(confusion_matrix(y_test, y_pred))
    print("\nClassification Report (Sensitivity/Recall is priority):")
    print(classification_report(y_test, y_pred))

    # 5. Export for App
    print("\nExporting model...")
    joblib.dump(model, 'ketter_ai/sepsis_model.pkl')
    print("Model saved to ketter_ai/sepsis_model.pkl")

    # Generate prediction function snippet
    print("\n--- Copy-Pasteable Prediction Function ---")
    prediction_func = """
def predict_sepsis(hr, temp, steps, user_score):
    \"\"\"
    Predicts sepsis risk based on input vitals and user score.
    Features: HR, Temp, Steps, User_Score
    \"\"\"
    import joblib
    import numpy as np

    # Load model (ensure the path is correct for your environment)
    model = joblib.load('sepsis_model.pkl')

    # Prepare input
    features = np.array([[hr, temp, steps, user_score]])

    # Predict
    prediction = model.predict(features)[0]
    probability = model.predict_proba(features)[0][1]

    return {
        'sepsis_detected': bool(prediction),
        'probability': float(probability)
    }
"""
    print(prediction_func)

if __name__ == "__main__":
    run_pipeline()
