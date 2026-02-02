# Running Ketter

This project consists of three main components. Follow the instructions below to run each part.

## 1. Ketter Mobile App (Flutter)
The mobile app is located in the `ketter_app` directory.

**Prerequisites:**
- Flutter SDK installed.
- An Android/iOS emulator or a physical device connected.

**Steps:**
1. Navigate to the app directory:
   ```bash
   cd ketter_app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate required code (for FHIR models):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Run the application:
   ```bash
   flutter run
   ```
5. To run unit tests:
   ```bash
   flutter test
   ```

## 2. Ketter Backend (HAPI FHIR)
The backend is a Spring Boot application using HAPI FHIR, located in `ketter_backend`.

**Prerequisites:**
- JDK 21 installed.
- Maven installed.

**Steps:**
1. Navigate to the backend directory:
   ```bash
   cd ketter_backend
   ```
2. Run the server using Maven:
   ```bash
   mvn spring-boot:run
   ```
The FHIR server will be available at `http://localhost:8080/fhir/`.

### Running with Docker
You can also run the backend using Docker:
1. Build the image:
   ```bash
   cd ketter_backend
   docker build -t ketter-backend .
   ```
2. Run the container:
   ```bash
   docker run -p 8080:8080 ketter-backend
   ```

## 3. Ketter AI (Data Simulation)
The AI simulation scripts are located in `ketter_ai`.

**Prerequisites:**
- Python 3.x installed.

**Steps:**
1. Navigate to the AI directory:
   ```bash
   cd ketter_ai
   ```
2. Run the simulation script to generate oncology-specific sepsis data:
   ```bash
   python3 simulate_data.py
   ```
This will generate a `simulated_sepsis_data.csv` file in the same directory.
