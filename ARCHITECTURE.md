# Ketter Architecture

## Overview
Ketter is a privacy-first Personal Health Record (PHR) app for oncology patients, featuring an Edge AI Early Warning System (EWS) for sepsis detection.

## Key Components

### 1. Ketter Mobile App (Flutter)
- **FHIR Client**: Handles HL7 FHIR R4 communication with the backend.
- **Fitbit Connector**: Synchronizes wearable data (Heart Rate, Sleep, Activity).
- **Edge AI Engine**: TFLite-based inference for real-time sepsis risk assessment.
- **UI/UX**: Supportive and calming interface using Material 3.

### 2. Ketter Backend (HAPI FHIR)
- **FHIR Server**: Standard-compliant storage for patient records.
- **Interoperability Layer**: Support for R4 standards.

### 3. Ketter AI (Python/TensorFlow)
- **Data Simulation**: Generating synthetic oncology/sepsis datasets for training.
- **Model Training**: LSTM or Random Forest models for deterioration prediction.
- **Quantization**: Converting models to TFLite for edge deployment.

## Data Flow: Sepsis Alert
1. **Data Acquisition**: Fitbit (HR) + Patient Input (Temp/Symptoms) -> FHIR Observation resources.
2. **Local Processing**: Flutter app extracts features from recent Observations.
3. **Inference**: TFLite model runs locally on device.
4. **Alerting**: If risk > threshold, trigger "Sepsis Alert" UI and notify care team via FHIR Communication resource.
5. **Persistence**: Sync vital signs and alerts to HAPI FHIR backend.
