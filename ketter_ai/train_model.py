import pandas as pd
import numpy as np
import tensorflow as tf
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
import os

def train_and_export():
    # Load simulated data
    data_path = "ketter_ai/sepsis_vitals_data.csv"
    if not os.path.exists(data_path):
        print("Data not found. Running simulation first...")
        from simulate_data import simulate_sepsis_dataset, save_to_csv
        save_to_csv(simulate_sepsis_dataset(200))

    df = pd.read_csv(data_path)

    # Select features and target
    features = ["HR", "O2Sat", "Temp", "SBP", "MAP", "DBP", "Resp", "EtCO2"]
    target = "sepsis_in_6h"

    X = df[features].values
    y = df[target].values

    # Scale features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    # Split data
    X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42)

    # Build a simple Keras model
    model = tf.keras.Sequential([
        tf.keras.layers.Dense(16, activation='relu', input_shape=(len(features),)),
        tf.keras.layers.Dense(8, activation='relu'),
        tf.keras.layers.Dense(1, activation='sigmoid')
    ])

    model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])

    # Train
    print("Training Sepsis Early Warning Model...")
    model.fit(X_train, y_train, epochs=10, batch_size=32, verbose=1, validation_data=(X_test, y_test))

    # Convert to TFLite
    print("Converting model to TFLite format...")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    tflite_model = converter.convert()

    # Save model
    model_path = "ketter_ai/sepsis_model.tflite"
    with open(model_path, "wb") as f:
        f.write(tflite_model)

    print(f"Model successfully saved to {model_path}")

    # Save scaling parameters for the app to use
    print(f"Mean: {scaler.mean_}")
    print(f"Scale: {scaler.scale_}")

if __name__ == "__main__":
    train_and_export()
