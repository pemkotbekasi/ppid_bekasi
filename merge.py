import os
import json

folder_path = 'data'
merged_data = []

for root, dirs, files in os.walk(folder_path):
    for file in files:
        file_path = os.path.join(root, file)
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                if isinstance(data, list):
                    merged_data.extend(data)
                else:
                    merged_data.append(data)
            print(f"Berhasil merge: {file_path}")
        except Exception as e:
            print(f"File {file_path} gagal dibaca sebagai JSON: {e}")

with open('merged.json', 'w', encoding='utf-8') as f_out:
    json.dump(merged_data, f_out, ensure_ascii=False, indent=2)

print("Merge selesai. Hasil di merged.json")
