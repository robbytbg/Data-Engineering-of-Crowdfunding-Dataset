# Data Engineering(ETL) - 1

1. Menambahkan Data untuk Crowdfunding:

  - Untuk memulai, aplikasi mengimpor pustaka yang diperlukan, termasuk Pandas.
  - Data dimuat ke dalam DataFrame Pandas yang disebut df dari file Excel bernama "crowdfunding.xlsx."

```python
df = pd.read_excel('/content/crowdfunding.xlsx')
```

2. Pembagian Data:

  - Menggunakan pembagi '/', kolom 'category & sub-category' dibagi menjadi kolom 'category' dan 'sub_category'.
  - Setelah itu, kolom asli "category & sub-category" DataFrame dihapus.

```python
df[['category', 'sub_category']] = df['category & sub-category'].str.split('/', expand=True)

df = df.drop(columns=['category & sub-category'])
```

3. Menghasilkan Data untuk Subkategori:

  - Subkategori yang berbeda satu sama lain ditemukan dan ditambahkan ke DataFrame yang disebut sub_category_data.
  - Setiap subkategori diberikan identifikasi yang unik ('sub_category_id').

```python
distinct_sub_categories = df['sub_category'].unique()

sub_category_data = pd.DataFrame({'sub_category': distinct_sub_categories})
sub_category_data['sub_category_id'] = range(1, len(distinct_sub_categories) + 1)
```

4. Cara Membuat Data Kategori:

  - Setelah mengidentifikasi kategori-kategori unik, sebuah DataFrame yang disebut category_data dibuat dari kategori-kategori ini.
  - Setiap kategori memiliki identifikasi yang unik ('category_id') yang diberikan.

```python
distinct_categories = df['category'].unique()

category_data = pd.DataFrame({'category': distinct_categories})
category_data['category_id'] = range(1, len(distinct_categories) + 1)
```

5. Memformat Tanggal:

  - Fungsi pd.to_datetime digunakan untuk mengonversi kolom 'launched_at' dan 'deadline' dari format timestamp Unix ke format tanggal yang dapat dibaca oleh manusia.

```python
from datetime import datetime as dt
df["launched_at"] = pd.to_datetime(df["launched_at"], unit='s').dt.strftime('%Y-%m-%d') 
df["deadline"] = pd.to_datetime(df["deadline"], unit='s').dt.strftime('%Y-%m-%d')
```

6. Informasi Kontak Dimuat:

  - Selanjutnya, aplikasi memuat informasi kontak ke dalam DataFrame yang bernama contact dari file Excel yang bernama "contacts.xlsx."

```python
contact = pd.read_excel('/content/contacts.xlsx', header=3)
```

7. Mengambil Data JSON:

  - Data berformat JSON dalam kolom 'contact_info' diekstrak menggunakan loop dan diubah menjadi kumpulan kamus.

```python
import json
dict_values = []

for i, baris in contact.iterrows():
    contact_dict = json.loads(baris['contact_info'])
    nilai_baris = [v for k, v in contact_dict.items()]
    dict_values.append(nilai_baris)
```

12. Membuat DataFrame Baru untuk Kontak:

  - Dari data JSON yang terkumpul, dibuatlah DataFrame baru (new_contact) dengan kolom "contact_id," "name," dan "email."

```python
new_contact = pd.DataFrame(dict_values, columns=['contact_id', 'name', 'email'])
```

13. Membagi Nama Menjadi Digit Pertama dan Terakhir:

  - Kolom asli 'name' dihapus dan dibagi menjadi 'first_name' dan 'last_name'.

```python
new_contact[['first_name', 'last_name']] = new_contact['name'].str.split(' ', 1, expand=True)

new_contact = new_contact.drop(columns=['name'])
```
