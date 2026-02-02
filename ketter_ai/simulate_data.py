import csv
import random
import datetime
import os

def generate_patient_history(patient_id, onset_hour=None, total_hours=48):
    records = []
    start_time = datetime.datetime.now() - datetime.timedelta(hours=total_hours)

    for hour in range(total_hours):
        is_pre_sepsis = False
        is_sepsis = False

        if onset_hour is not None:
            if onset_hour - 6 <= hour < onset_hour:
                is_pre_sepsis = True
            elif hour >= onset_hour:
                is_sepsis = True

        # Base values
        hr = random.uniform(70, 90)
        o2 = random.uniform(96, 99)
        temp = random.uniform(36.6, 37.2)
        sbp = random.uniform(110, 130)
        dbp = random.uniform(70, 85)
        resp = random.uniform(14, 18)
        etco2 = random.uniform(38, 42)

        # Apply shifts for pre-sepsis and sepsis
        if is_pre_sepsis:
            hr += random.uniform(5, 15)
            o2 -= random.uniform(1, 3)
            temp += random.uniform(0.3, 0.8)
            sbp -= random.uniform(5, 10)
            resp += random.uniform(2, 4)
            etco2 -= random.uniform(1, 3)
        elif is_sepsis:
            hr += random.uniform(20, 40)
            o2 -= random.uniform(4, 8)
            temp += random.uniform(1.0, 2.5)
            sbp -= random.uniform(15, 30)
            dbp -= random.uniform(10, 20)
            resp += random.uniform(6, 12)
            etco2 -= random.uniform(5, 10)

        map_val = (sbp + 2 * dbp) / 3
        timestamp = start_time + datetime.timedelta(hours=hour)

        records.append({
            "patient_id": patient_id,
            "timestamp": timestamp.isoformat(),
            "HR": round(hr, 1),
            "O2Sat": round(o2, 1),
            "Temp": round(temp, 1),
            "SBP": round(sbp, 1),
            "MAP": round(map_val, 1),
            "DBP": round(dbp, 1),
            "Resp": round(resp, 1),
            "EtCO2": round(etco2, 1),
            "sepsis_onset": 1 if is_sepsis else 0,
            "sepsis_in_6h": 1 if is_pre_sepsis else 0
        })
    return records

def simulate_sepsis_dataset(num_patients=100):
    all_records = []
    for i in range(num_patients):
        patient_id = f"PAT-{1000 + i}"
        has_sepsis = random.random() < 0.25
        onset_hour = random.randint(20, 40) if has_sepsis else None
        all_records.extend(generate_patient_history(patient_id, onset_hour))
    return all_records

def save_to_csv(records, filename="ketter_ai/sepsis_vitals_data.csv"):
    keys = records[0].keys()
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, 'w', newline='') as output_file:
        dict_writer = csv.DictWriter(output_file, fieldnames=keys)
        dict_writer.writeheader()
        dict_writer.writerows(records)

if __name__ == "__main__":
    print("Simulating high-fidelity vital sign dataset for 100 patients...")
    data = simulate_sepsis_dataset(100)
    save_to_csv(data)
    print(f"Dataset generated with {len(data)} hourly records.")
