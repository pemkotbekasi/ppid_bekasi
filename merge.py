import os
import json

input_folder = 'data'
output_folder = 'output'

# Buat folder output jika belum ada
os.makedirs(output_folder, exist_ok=True)

for root, dirs, files in os.walk(input_folder):
    for file in files:
        # Nama file tanpa ekstensi, untuk penamaan output
        file_base = os.path.splitext(file)[0]
        output_file = os.path.join(output_folder, f"{file_base}.json")
        file_path = os.path.join(root, file)
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            with open(output_file, 'w', encoding='utf-8') as out_f:
                json.dump(data, out_f, ensure_ascii=False, indent=2)
            print(f"Berhasil export: {file_path} -> {output_file}")
        except Exception as e:
            print(f"Gagal membaca {file_path} sebagai JSON: {e}")

print("Proses export selesai.")
