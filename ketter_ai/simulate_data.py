import csv
import random
import datetime
import os

def generate_sepsis_data(num_records=100):
    """
    Simulates vital signs for oncology patients, some showing signs of sepsis.
    Normal ranges:
    - HR: 60-100
    - Temp: 36.5-37.5
    - RR: 12-20
    - Systolic BP: 110-130
    - SpO2: 95-100
    """
    records = []
    start_time = datetime.datetime.now()

    for i in range(num_records):
        patient_id = f"PAT-{random.randint(1000, 9999)}"
        # 20% chance of being "deteriorating" (sepsis risk)
        is_sepsis = random.random() < 0.2

        if is_sepsis:
            hr = random.uniform(101, 140)
            temp = random.uniform(38.0, 40.0) if random.random() > 0.5 else random.uniform(35.0, 36.0)
            rr = random.uniform(22, 30)
            sbp = random.uniform(80, 100)
            spo2 = random.uniform(88, 93)
        else:
            hr = random.uniform(60, 100)
            temp = random.uniform(36.5, 37.5)
            rr = random.uniform(12, 20)
            sbp = random.uniform(110, 130)
            spo2 = random.uniform(96, 100)

        timestamp = start_time - datetime.timedelta(minutes=i*15)

        records.append({
            "patient_id": patient_id,
            "timestamp": timestamp.isoformat(),
            "heart_rate": round(hr, 1),
            "temperature": round(temp, 1),
            "respiratory_rate": round(rr, 1),
            "systolic_bp": round(sbp, 1),
            "spo2": round(spo2, 1),
            "is_sepsis_label": 1 if is_sepsis else 0
        })

    return records

def save_to_csv(records, filename="ketter_ai/simulated_sepsis_data.csv"):
    keys = records[0].keys()
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, 'w', newline='') as output_file:
        dict_writer = csv.DictWriter(output_file, fieldnames=keys)
        dict_writer.writeheader()
        dict_writer.writerows(records)

if __name__ == "__main__":
    print("Generating simulated sepsis data for oncology patients...")
    data = generate_sepsis_data(500)
    save_to_csv(data)
    print(f"Successfully saved 500 records to ketter_ai/simulated_sepsis_data.csv")
