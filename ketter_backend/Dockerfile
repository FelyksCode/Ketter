# Build stage
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY src ./src
RUN mvn package -DskipTests -B

# Run stage
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/ketter-backend-1.0-SNAPSHOT.jar app.jar

# Expose the FHIR server port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
