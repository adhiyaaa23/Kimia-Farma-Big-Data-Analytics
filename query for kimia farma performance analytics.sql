/*
Project  : Kimia Farma Performance Analytics from 2020-2023
Purpose  : Build analytical table and Dashboard Visualization for Performance analysis
Author   : Muhammad Ad'hiya Hartono
Database : Google BigQuery
*/
-- Membuat CTE dengan nama data_analisa yang nanti akan digunakan untuk penyusunan dashboard

WITH data_analisa AS (
  -- Memilih semua kolom yang dibutuhkan dari tabel final_Transaction (ft), Kantor Cabang (kc), dan Product (p) untuk dimasukkan ke dalam tabel data_analisa. Query yang digunakan yaitu SELECT__FROM dan JOIN 
    SELECT
        ft.transaction_id,
        ft.date,
        ft.branch_id,
        kc.branch_name,
        kc.kota,
        kc.provinsi,
        kc.rating AS rating_cabang,
        ft.customer_name,
        p.product_id,
        p.product_name,
        p.price AS actual_price,
        ft.discount_percentage,
        ft.rating AS rating_transaksi,
-- Penyusunan query untuk membuat kolom aggregat, yaitu persentase_gross_laba menggunakan query case when
        CASE
            WHEN p.price <= 50000 THEN 0.10
            WHEN p.price <= 100000 THEN 0.15
            WHEN p.price <= 300000 THEN 0.20
            WHEN p.price <= 500000 THEN 0.25
            ELSE 0.30
        END AS persentase_gross_laba,
-- Penyusunan query untuk membuat kolom aggregat, yaitu nett_sales
        p.price * (1 - ft.discount_percentage / 100.0) AS nett_sales,
-- Penyusunan query untuk membuat kolom aggregat, yaitu nett_profit
        (p.price * (1 - ft.discount_percentage / 100.0)) *
        CASE
            WHEN p.price <= 50000 THEN 0.10
            WHEN p.price <= 100000 THEN 0.15
            WHEN p.price <= 300000 THEN 0.20
            WHEN p.price <= 500000 THEN 0.25
            ELSE 0.30
        END AS nett_profit

    FROM `Kimia_Farma.Final_Transaction` ft
    JOIN `Kimia_Farma.Kantor_Cabang` kc
        ON ft.branch_id = kc.branch_id
    JOIN `Kimia_Farma.Product` p
        ON ft.product_id = p.product_id
)
-- Mengambil seluruh data dari tabel data_analisa yang disusun sebelumnya
SELECT *
FROM data_analisa;