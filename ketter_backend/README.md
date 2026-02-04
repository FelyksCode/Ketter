# Ketter Backend - HAPI FHIR Server

This is the interoperability layer for the Ketter PHR system. It implements an HL7 FHIR R4-compliant server using the HAPI FHIR framework and Spring Boot.

## Features

- **FHIR R4 Standard**: Full support for R4 resource types.
- **Resource Providers**: In-memory implementations for `Patient`, `Observation`, and `Condition` resources.
- **Spring Boot Integration**: Modern, container-ready Java application architecture.
- **Docker Support**: Pre-configured Dockerfile for consistent deployment across environments.

## Prerequisites

- Java 21 (JDK)
- Maven 3.x

## Getting Started

### Running Locally (Maven)
1. Navigate to the directory:
   ```bash
   cd ketter_backend
   ```
2. Start the server:
   ```bash
   mvn spring-boot:run
   ```
The server will be available at `http://localhost:8080/fhir/`.

### Running with Docker
1. Build the image:
   ```bash
   docker build -t ketter-backend .
   ```
2. Run the container:
   ```bash
   docker run -p 8080:8080 ketter-backend
   ```

## Configuration
- `src/main/resources/application.properties`: Standard Spring Boot configuration.
- `FhirRestfulServer.java`: Entry point for HAPI FHIR servlet registration.
