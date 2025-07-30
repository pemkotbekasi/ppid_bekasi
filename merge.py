import os
import json

input_folder = 'data'
output_folder = 'output'

os.makedirs(output_folder, exist_ok=True)

for root, dirs, files in os.walk(input_folder):
    for file in files:
        file_path = os.path.join(root, file)
        output_file_name = os.path.splitext(file)[0] + '.json'
        output_path = os.path.join(output_folder, output_file_name)
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            with open(output_path, 'w', encoding='utf-8') as out_f:
                json.dump(data, out_f, ensure_ascii=False, indent=2)
            print(f"Berhasil export {file_path} ke {output_path}")
        except Exception as e:
            print(f"File {file_path} gagal dibaca sebagai JSON: {e}")

print("Proses export selesai.")
