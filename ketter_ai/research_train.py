import pandas as pd
import numpy as np
import random
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, accuracy_score, recall_score, f1_score, classification_report
import m2cgen as m2c
import matplotlib.pyplot as plt
import seaborn as sns
import os

def simulate_data():
    """Generates a synthetic hybrid dataset for sepsis prediction."""
    np.random.seed(42)
    random.seed(42)

    # Class 0: Healthy / Fitbit Data
    healthy_hr = np.random.normal(75, 10, 1000)
    healthy_steps = np.random.randint(0, 121, 1000)
    healthy_temp = np.random.uniform(36.5, 37.0, 1000)

    healthy_status = []
    for hr in healthy_hr:
        if hr > 100 and random.random() < 0.3: # High HR due to exercise
            healthy_status.append(1) # Poor status momentarily
        else:
            healthy_status.append(0) # Good status

    df_healthy = pd.DataFrame({
        'HeartRate': healthy_hr,
        'Steps': healthy_steps,
        'Temperature': healthy_temp,
        'UserStatus': healthy_status,
        'Label': 0
    })

    # Class 1: Sepsis / Clinical Deterioration
    sepsis_hr = np.random.normal(110, 15, 1000)
    sepsis_steps = np.random.randint(0, 11, 1000) # Mostly bedridden
    sepsis_temp = np.random.uniform(38.0, 39.5, 1000)
    sepsis_status = np.random.choice([1, 2], 1000, p=[0.4, 0.6]) # Poor or Terrible

    df_sepsis = pd.DataFrame({
        'HeartRate': sepsis_hr,
        'Steps': sepsis_steps,
        'Temperature': sepsis_temp,
        'UserStatus': sepsis_status,
        'Label': 1
    })

    # Combine and shuffle
    df = pd.concat([df_healthy, df_sepsis], ignore_index=True)
    df = df.sample(frac=1, random_state=42).reset_index(drop=True)

    return df

def train_and_validate(df):
    """Trains Random Forest and validates performance."""
    X = df.drop('Label', axis=1)
    y = df['Label']

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Lightweight Random Forest for mobile export
    model = RandomForestClassifier(n_estimators=10, max_depth=5, random_state=42)
    model.fit(X_train, y_train)

    # Predictions
    y_pred = model.predict(X_test)

    # Metrics
    cm = confusion_matrix(y_test, y_pred)
    acc = accuracy_score(y_test, y_pred)
    sens = recall_score(y_test, y_pred) # Sensitivity

    # Specificity = TN / (TN + FP)
    tn, fp, fn, tp = cm.ravel()
    spec = tn / (tn + fp)

    f1 = f1_score(y_test, y_pred)

    print("--- Validation Metrics ---")
    print(f"Confusion Matrix:\n{cm}")
    print(f"Accuracy: {acc:.4f}")
    print(f"Sensitivity (Recall): {sens:.4f} (CRITICAL)")
    print(f"Specificity: {spec:.4f}")
    print(f"F1-Score: {f1:.4f}")
    print("\nClassification Report:\n", classification_report(y_test, y_pred))

    return model, X.columns

def export_to_dart(model):
    """Converts the trained model to native Dart code."""
    code = m2c.export_to_dart(model)
    output_path = "ketter_ai/sepsis_model.dart"
    with open(output_path, "w") as f:
        f.write(code)
    print(f"--- Export ---")
    print(f"Native Dart model saved to {output_path}")

def visualize_importance(model, feature_names):
    """Generates Feature Importance plot."""
    importances = model.feature_importances_
    feat_df = pd.DataFrame({'Feature': feature_names, 'Importance': importances})
    feat_df = feat_df.sort_values(by='Importance', ascending=False)

    plt.figure(figsize=(10, 6))
    sns.barplot(x='Importance', y='Feature', data=feat_df, palette='viridis')
    plt.title('Feature Importance for Sepsis Prediction')
    plt.tight_layout()
    plt.savefig('ketter_ai/feature_importance.png')
    print("--- Visualization ---")
    print("Feature importance plot saved to ketter_ai/feature_importance.png")

if __name__ == "__main__":
    print("Starting Research Sepsis Model Pipeline...")
    data = simulate_data()
    model, features = train_and_validate(data)
    export_to_dart(model)
    visualize_importance(model, features)
    print("Pipeline Complete.")
