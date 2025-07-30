import os
import json

folder_path = 'data'  # Ganti jika lokasi folder berbeda
merged_data = []

for filename in os.listdir(folder_path):
    file_path = os.path.join(folder_path, filename)
    if os.path.isfile(file_path):
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                if isinstance(data, list):
                    merged_data.extend(data)
                else:
                    merged_data.append(data)
        except Exception as e:
            print(f"File {filename} gagal dibaca: {e}")

with open('merged.json', 'w', encoding='utf-8') as f_out:
    json.dump(merged_data, f_out, ensure_ascii=False, indent=2)
