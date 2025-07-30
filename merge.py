import os
import json
from collections import defaultdict

input_folder = 'data'
output_folder = 'output'

os.makedirs(output_folder, exist_ok=True)

# Gabungkan semua data dari file apapun di folder
all_data = []
for root, dirs, files in os.walk(input_folder):
    for file in files:
        file_path = os.path.join(root, file)
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                if isinstance(data, list):
                    all_data.extend(data)
                else:
                    all_data.append(data)
        except Exception as e:
            print(f"File {file_path} gagal dibaca sebagai JSON: {e}")

# Kelompokkan berdasarkan dokumen_kategori
kategori_groups = defaultdict(list)
for item in all_data:
    kategori = item.get('dokumen_kategori', 'LAINNYA')
    kategori_groups[kategori].append(item)

# Simpan per dokumen_kategori
for kategori, items in kategori_groups.items():
    safe_filename = f"{kategori.replace(' ', '_').replace('/', '_')}.json"
    output_path = os.path.join(output_folder, safe_filename)
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(items, f, ensure_ascii=False, indent=2)
    print(f"Export: {output_path} ({len(items)} item)")

print("Selesai export per dokumen_kategori ke folder output/")
