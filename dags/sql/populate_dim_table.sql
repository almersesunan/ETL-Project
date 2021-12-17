TRUNCATE dim_province;
INSERT INTO dim_province
    select distinct kode_prov, nama_prov from warehouse_table;

TRUNCATE dim_district;
INSERT INTO dim_district
    select distinct kode_kab, kode_prov, nama_kab from warehouse_table
    order by kode_kab asc;