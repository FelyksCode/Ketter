# Ketter Mobile - Oncology Personal Health Record

Ketter (derived from Old English "cetter" meaning "to care") is a privacy-first mobile application for oncology patients. It integrates wearable data with FHIR standards and features an Edge AI Early Warning System (EWS) for sepsis detection.

## Key Features

### 1. Nurturing Dashboard
- **Calming Design**: Built with Material 3 using a Sage Green and Warm Teal palette to reduce patient stress.
- **Health Status**: Uses the **NEWS2 (National Early Warning Score)** clinical standard to assess deterioration risk.
- **Vitals Trends**: Real-time visualization of Heart Rate and other metrics using `fl_chart`.

### 2. Sepsis Guard (Monitoring Service)
- **Background Monitoring**: Silently analyzes incoming Fitbit streams for critical patterns (e.g., sustained High HR + Low Steps).
- **FHIR Alerting**: Automatically generates HL7 FHIR R4 `RiskAssessment` resources when a risk is detected.
- **Supportive Notifications**: Gentle local notifications prompting users for a symptom check-in, with a 1-hour cooldown to prevent fatigue.

### 3. Edge AI Inference
- **Privacy-First**: AI prediction runs locally on the device using a dedicated **Dart Isolate** to ensure UI responsiveness.
- **Multi-modal**: Supports both rule-based heuristics and TFLite-based machine learning for early (6h) sepsis prediction.

### 4. FHIR Interoperability
- **Standardized Data**: Converts raw metrics and symptoms to FHIR R4 Observations and Conditions.
- **LOINC/SNOMED Integration**: Uses standard clinical coding for heart rate, temperature, SpO2, and oncology-specific symptoms.

## Getting Started

### Prerequisites
- Flutter SDK (^3.10.7)
- Android Emulator or physical device

### Installation
1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Generate models (Freezed/JSON Serializable):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### Running the App
```bash
flutter run
```

### Testing
```bash
flutter test
```

## Project Structure
- `lib/models/`: FHIR and app-specific data structures.
- `lib/services/`: Core logic for FHIR conversion, NEWS2 scoring, and AI inference.
- `lib/main.dart`: Dashboard UI and app entry point.
- `assets/`: Contains the `sepsis_model.tflite` model.
