# Use official lightweight Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies if any (none needed for standard ML)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements or directly install
# Users usually prefer a requirements.txt but task asked for pip install commands
RUN pip install --no-cache-dir \
    flask \
    flask-cors \
    pandas \
    scikit-learn \
    numpy \
    joblib

# Copy application code
COPY app.py .

# Expose port
EXPOSE 5000

# Set environment variables
ENV FLASK_APP=app.py

# Run application
CMD ["python", "app.py"]
