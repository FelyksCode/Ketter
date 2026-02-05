import pandas as pd
import numpy as np

def generate_noisy_epro(row):
    """
    Simulates real-world patient reporting variability (ePRO) for sepsis.
    Logic:
    - Sick (SepsisLabel=1): 60% reports 2, 30% reports 1, 10% reports 0 (False Negative).
    - Healthy (SepsisLabel=0): 80% reports 0, 15% reports 1, 5% reports 2 (False Positive).
    """
    if row['SepsisLabel'] == 1:
        # Sepsis case: 60% Terrible (2), 30% Poor (1), 10% Fine (0)
        return np.random.choice([2, 1, 0], p=[0.60, 0.30, 0.10])
    else:
        # Healthy case: 80% Fine (0), 15% Poor (1), 5% Terrible (2)
        return np.random.choice([0, 1, 2], p=[0.80, 0.15, 0.05])

def main():
    # 1. Prepare dummy data for validation
    print("Preparing scientific medical dataset simulation...")
    data = {
        'PatientID': range(10000),
        'SepsisLabel': [1] * 5000 + [0] * 5000  # 50/50 split for clear stats
    }
    df = pd.DataFrame(data)

    # 2. Apply the noisy ePRO generation
    print("Generating noisy User_Score (ePRO) column...")
    df['User_Score'] = df.apply(generate_noisy_epro, axis=1)

    # 3. Print crosstab to verify distribution percentages
    print("\n--- Verification Crosstab: SepsisLabel vs User_Score ---")
    ct = pd.crosstab(df['SepsisLabel'], df['User_Score'], normalize='index')
    print(ct)

    print("\nPercentage breakdown check (Expected vs Actual):")
    for label in [0, 1]:
        print(f"\nFor SepsisLabel = {label}:")
        for score in [0, 1, 2]:
            actual = ct.loc[label, score] * 100
            print(f"  Score {score}: {actual:.2f}%")

if __name__ == "__main__":
    main()
