import pandas as pd
import numpy as np

# Mock Kaggle Clinical Sepsis Data
# Columns: HR, Temp, SepsisLabel
clinical_rows = 1000
df_clinical = pd.DataFrame({
    'HR': np.random.normal(110, 15, clinical_rows),
    'Temp': np.random.uniform(37.5, 40.0, clinical_rows),
    'SepsisLabel': [1] * clinical_rows
})
df_clinical.to_csv('ketter_ai/Dataset.csv', index=False)

# Mock Kaggle Fitbit Data
# Columns: Value (HR)
fitbit_rows = 2000
df_fitbit = pd.DataFrame({
    'Value': np.random.normal(72, 10, fitbit_rows),
})
df_fitbit.to_csv('ketter_ai/heartrate_seconds_merged.csv', index=False)

print("Source files generated successfully.")
