# Ketter AI - Sepsis Prediction & Data Simulation

This directory contains the AI/Machine Learning component of the Ketter Personal Health Record (PHR) system. It focuses on early sepsis detection for oncology patients using a combination of clinical data and wearable metrics.

## Features

### 1. Data Simulation
- **`simulate_data.py`**: Generates high-fidelity, hourly vital sign records (HR, O2Sat, Temp, SBP, MAP, DBP, Resp, EtCO2) for oncology patients. It simulates clinical deterioration trends 6 hours prior to sepsis onset.
- **`research_train.py`**: Includes a hybrid data generator that mimics Fitbit streams (normal ranges with occasional exercise spikes) vs clinical sepsis cases.

### 2. Model Training & Export
- **`train_model.py`**: Trains a Keras/TensorFlow model for sepsis prediction and exports it as `sepsis_model.tflite` for on-device inference in the mobile app.
- **`research_train.py`**: Trains a Random Forest classifier and uses the `m2cgen` library to export the model as a native Dart function (`sepsis_model.dart`) for dependency-free deployment.
- **`clinical_fitbit_fusion.py`**: A specialized pipeline that merges clinical datasets with Fitbit wearable data, performing imputation for missing values (e.g., bedridden steps) and injecting synthetic ePRO (User_Score) logic.

## Prerequisites

- Python 3.x
- Required libraries:
  ```bash
  pip install pandas numpy scikit-learn tensorflow m2cgen matplotlib seaborn joblib
  ```

## How to Run

### Generate Simulated Data
```bash
python3 simulate_data.py
```

### Train and Export TFLite Model
```bash
python3 train_model.py
```

### Run Research Training Pipeline (Dart Export)
```bash
python3 research_train.py
```

### Run Data Fusion Pipeline
```bash
python3 clinical_fitbit_fusion.py
```

## Outputs
- `sepsis_vitals_data.csv`: Hourly vital sign dataset.
- `sepsis_model.tflite`: Quantized model for Flutter.
- `sepsis_model.dart`: Native Dart implementation of the Random Forest model.
- `feature_importance.png`: Visualization of the most critical health indicators.
