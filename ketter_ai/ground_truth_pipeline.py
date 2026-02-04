import pandas as pd
import numpy as np
import random
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, classification_report
import joblib
import os

def run_research_pipeline():
    # Step 1: Data Loading & Balancing
    print("Loading Kaggle datasets...")

    # Positive Class (Sepsis)
    df_sepsis = pd.read_csv('ketter_ai/Dataset.csv')
    df_sepsis = df_sepsis[df_sepsis['SepsisLabel'] == 1]
    df_sepsis = df_sepsis[['HR', 'Temp']]
    df_sepsis['SepsisLabel'] = 1

    # Negative Class (Healthy Fitbit)
    df_fitbit = pd.read_csv('ketter_ai/heartrate_seconds_merged.csv')
    df_fitbit = df_fitbit.rename(columns={'Value': 'HR'})

    # Balancing (Randomly sample the same number of rows as Sepsis data)
    num_sepsis = len(df_sepsis)
    print(f"Detected {num_sepsis} sepsis records. Balancing classes...")
    df_fitbit = df_fitbit.sample(n=num_sepsis, random_state=42)
    df_fitbit['SepsisLabel'] = 0

    # Step 2: Feature Injection (The "Frankenstein" Step)
    print("Performing feature injection...")

    # For Sepsis Data
    # Steps: 0-100 (Inactivity)
    df_sepsis['Steps'] = np.random.randint(0, 101, size=len(df_sepsis))
    # User_Score: 2 or 3 (Poor/Terrible) with 10% noise as 1 (Okay)
    def sepsis_user_score():
        if random.random() < 0.9:
            return random.choice([2, 3])
        else:
            return 1
    df_sepsis['User_Score'] = [sepsis_user_score() for _ in range(len(df_sepsis))]

    # For Fitbit Data
    # Temp: 36.0 - 37.2 (Normal)
    df_fitbit['Temp'] = np.random.uniform(36.0, 37.2, size=len(df_fitbit))
    # Steps: 500 - 2000 (Active)
    df_fitbit['Steps'] = np.random.randint(500, 2001, size=len(df_fitbit))
    # User_Score: 0 or 1 (Good/Okay) with 10% noise as 2 (Poor)
    def fitbit_user_score():
        if random.random() < 0.9:
            return random.choice([0, 1])
        else:
            return 2
    df_fitbit['User_Score'] = [fitbit_user_score() for _ in range(len(df_fitbit))]

    # Step 3: Merge
    print("Merging datasets...")
    df = pd.concat([df_sepsis, df_fitbit], ignore_index=True)
    df = df.sample(frac=1, random_state=42).reset_index(drop=True)

    # Save ground truth dataset
    df.to_csv('ketter_ai/ground_truth_dataset.csv', index=False)
    print("Ground truth dataset saved to ketter_ai/ground_truth_dataset.csv")

    # Step 4: Train & Validate
    print("Training Random Forest model...")
    features = ['HR', 'Temp', 'Steps', 'User_Score']
    X = df[features]
    y = df['SepsisLabel']

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    model = RandomForestClassifier(n_estimators=100, random_state=42)
    model.fit(X_train, y_train)

    y_pred = model.predict(X_test)

    print("\n--- Clinical Metrics Report ---")
    print("Confusion Matrix:")
    print(confusion_matrix(y_test, y_pred))
    print("\nClassification Report (Focus on Recall/Sensitivity):")
    print(classification_report(y_test, y_pred))

    # Export Model
    joblib.dump(model, 'ketter_ai/sepsis_model.pkl')
    print("\nModel saved to ketter_ai/sepsis_model.pkl")

    # Export decision logic as function text
    print("\n--- Decision Logic Function ---")
    logic_snippet = """
def predict_sepsis_risk(hr, temp, steps, user_score):
    \"\"\"
    Clinical Decision Logic for Sepsis Alerting.
    Input Features:
    - hr: Heart Rate (bpm)
    - temp: Temperature (Celsius)
    - steps: Steps count
    - user_score: ePRO (0-3 scale)
    \"\"\"
    import joblib
    import numpy as np

    # Load model
    model = joblib.load('sepsis_model.pkl')

    # Inference
    data = np.array([[hr, temp, steps, user_score]])
    prediction = model.predict(data)[0]
    probability = model.predict_proba(data)[0][1]

    return {
        'risk_detected': bool(prediction == 1),
        'confidence': float(probability)
    }
"""
    print(logic_snippet)

if __name__ == "__main__":
    run_research_pipeline()
