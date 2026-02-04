import pandas as pd
import numpy as np

# Mock Kaggle Clinical Sepsis Data
# Columns: HR, Temp, SepsisLabel
clinical_rows = 5000
df_clinical = pd.DataFrame({
    'HR': np.random.normal(110, 15, clinical_rows),
    'Temp': np.random.uniform(37.5, 40.0, clinical_rows),
    'SepsisLabel': np.random.choice([0, 1], clinical_rows, p=[0.2, 0.8]) # Mostly sepsis
})
df_clinical.to_csv('ketter_ai/Dataset.csv', index=False)

# Mock Kaggle Fitbit Data
# Columns: Value (HR)
fitbit_rows = 10000
df_fitbit = pd.DataFrame({
    'Value': np.random.normal(72, 10, fitbit_rows),
    'Time': pd.date_range(start='2026-01-01', periods=fitbit_rows, freq='S')
})
df_fitbit.to_csv('ketter_ai/heartrate_seconds_merged.csv', index=False)

print("Generated mock research data files in ketter_ai/")
