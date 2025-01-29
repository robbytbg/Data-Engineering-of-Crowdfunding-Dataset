# Data Engineering(ETL) - 2

1. **Pilih Database:**
  - Saya memastikan untuk memilih database dari mana saya ingin mengimpor informasi. Menggunakan panel "Navigator", saya menyelesaikan langkah ini.

2. Dengan menggunakan Quick Database Diagram, **Buka Skrip SQL dari**
  - Saya menggunakan perintah `CREATE TABLE` dan hubungan foreign key yang terdapat dalam skrip SQL yang dibuat oleh Quick Database Diagram.

![alt text](https://github.com/robbytbg/Port2/blob/main/Data%20Engineering(ETL)/Etl.PNG)

3. **Jalankan Skrip SQL:**
  - Untuk membuat tabel dan hubungan yang diperlukan di database pilihan saya, saya menjalankan skrip SQL ini di MySQL Workbench.

```
-- Diekspor dari QuickDBD: https://www.quickdatabasediagrams.com/
-- Tautan ke skema: https://app.quickdatabasediagrams.com/#/d/NqTsR5
-- CATATAN! Jika Anda telah menggunakan tipe data non-SQL dalam desain Anda, Anda harus menggantinya di sini.

CREATE TABLE `Campaign` (
    `cf_id` INTEGER  NOT NULL ,
    `contact_id` INTEGER  NOT NULL ,
    `company_name` VARCHAR(50)  NOT NULL ,
    `blurb` VARCHAR(255)  NOT NULL ,
    `goal` INTEGER  NOT NULL ,
    `pledged` INTEGER  NOT NULL ,
    `outcome` VARCHAR(50)  NOT NULL ,
    `backers_count` INTEGER  NOT NULL ,
    `country` VARCHAR(50)  NOT NULL ,
    `currency` VARCHAR(50)  NOT NULL ,
    `launched_at` DATE  NOT NULL ,
    `deadline` DATE  NOT NULL ,
    `category_id` INTEGER  NOT NULL ,
    `sub_category_id` INTEGER  NOT NULL ,
    PRIMARY KEY (
        `cf_id`
    )
);

CREATE TABLE `Sub_category` (
    `sub_category` VARCHAR(50)  NOT NULL ,
    `sub_category_id` INTEGER  NOT NULL ,
    PRIMARY KEY (
        `sub_category_id`
    )
);

CREATE TABLE `Category` (
    `category` VARCHAR(50)  NOT NULL ,
    `category_id` INTEGER  NOT NULL ,
    PRIMARY KEY (
        `category_id`
    )
);

CREATE TABLE `Contact` (
    `contact_id` INTEGER  NOT NULL ,
    `email` VARCHAR(100)  NOT NULL ,
    `first_name` VARCHAR(100)  NOT NULL ,
    `last_name` VARCHAR(100)  NOT NULL ,
    PRIMARY KEY (
        `contact_id`
    )
);

ALTER TABLE `Campaign` ADD CONSTRAINT `fk_Campaign_contact_id` FOREIGN KEY(`contact_id`)
REFERENCES `Contact` (`contact_id`);

ALTER TABLE `Campaign` ADD CONSTRAINT `fk_Campaign_category_id` FOREIGN KEY(`category_id`)
REFERENCES `Category` (`category_id`);

ALTER TABLE `Campaign` ADD CONSTRAINT `fk_Campaign_sub_category_id` FOREIGN KEY(`sub_category_id`)
REFERENCES `Sub_category` (`sub_category_id`);
```

4. Klik untuk meluncurkan Wizard Impor Data Tabel:
  - Saya menuju ke database tertentu di mana saya ingin mengimpor data menggunakan panel "Navigator".
  - Saya membuat tabel baru atau melakukan klik kanan pada tabel di mana saya ingin mengimpor data.
  - Saya memilih "Table Data Import Wizard."

5. **Pilih File CSV:**
  - Saya memilih opsi "Import from File" dalam "Table Data Import Wizard."
  - Saya memilih file CSV yang berisi data.

6. **Kolom pada Peta:**
  - Wizard mencoba secara otomatis menerjemahkan kolom file CSV saya ke kolom tabel MySQL saya. Saya memeriksa untuk memastikan pemetaan tersebut akurat.

7. **Pengujiannya:**

  - Saring Data untuk Campaign yang Diluncurkan Setelah Tanggal Tertentu:
    
      -Mengambil kampanye yang diluncurkan setelah 1 Januari 2023.
    
        ```
        SELECT * FROM porto.campaign WHERE launched_at > '2021-01-01' LIMIT 5;
        ```
    
      ![alt text](https://github.com/robbytbg/Port2/blob/main/Data%20Engineering(ETL)/Others/DB_OP.PNG)

  - Fungsi Agregat untuk Mendapatkan Wawasan:
    
    - Temukan rata-rata jumlah tujuan dan terkumpul untuk semua kampanye.
      
        ```
        SELECT
        AVG(goal) AS avg_goal,
        AVG(pledged) AS avg_pledged
        FROM porto.campaign;

        ```

        ![alt text](https://github.com/robbytbg/Port2/blob/main/Data%20Engineering(ETL)/Others/DB_OP2.PNG)


  - Gabungkan Tabel untuk Mendapatkan Informasi Detail:
    
    - Ambil informasi kampanye beserta nama kategori dan sub-kategori terkait.
   
      ```
      SELECT
      c.cf_id,
      c.company_name,
      c.blurb,
      c.goal,
      c.pledged,
      c.outcome,
      c.backers_count,
      c.country,
      c.currency,
      c.launched_at,
      c.deadline,
      ct.category,
      sct.sub_category
      FROM porto.campaign c
      JOIN porto.category ct ON c.category_id = ct.category_id
      JOIN porto.sub_category sct ON c.sub_category_id = sct.sub_category_id
      LIMIT 5;

      ```

      ![alt text](https://github.com/robbytbg/Port2/blob/main/Data%20Engineering(ETL)/Others/DB_OP3.PNG)
