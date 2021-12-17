TRUNCATE temp_fact RESTART IDENTITY;
INSERT INTO temp_fact
    SELECT kode_prov, kode_kab, tanggal::date,
	    UNNEST(array ['suspect_diisolasi', 'suspect_discarded', 'closecontact_dikarantina', 'closecontact_discarded', 'probable_diisolasi', 'probable_discarded', 'confirmation_sembuh', 'confirmation_meninggal', 'suspect_meninggal', 'closecontact_meninggal', 'probable_meninggal']) as "case", 
	    UNNEST(array [suspect_diisolasi, suspect_discarded, closecontact_dikarantina, closecontact_discarded, probable_diisolasi, probable_discarded, confirmation_sembuh, confirmation_meninggal, suspect_meninggal, closecontact_meninggal, probable_meninggal]) as "count"
    FROM warehouse_table;

TRUNCATE fact_province_daily RESTART IDENTITY;
INSERT INTO fact_province_daily(province_id,case_id,date,total)
    select province_id, dc.id as case_id, "date", Sum(total) as total 
    from temp_fact tf inner join dim_case dc on CONCAT(dc.status_name ,'_',dc.status_detail) = tf.case
    group by province_id, case_id, "date"
    order by province_id, case_id, "date" asc;

TRUNCATE fact_province_monthly RESTART IDENTITY;
INSERT INTO fact_province_monthly(province_id,case_id,month,total)
    select province_id, dc.id as case_id, to_char(date, 'YYYY-MM') as month, Sum(total) as total 
    from temp_fact tf inner join dim_case dc on CONCAT(dc.status_name ,'_',dc.status_detail) = tf.case
    group by province_id, case_id, month
    order by province_id, case_id, month asc;

TRUNCATE fact_province_yearly RESTART IDENTITY;
INSERT INTO fact_province_yearly(province_id,case_id,year,total)
    select province_id, dc.id as case_id, extract(year from date) as year, Sum(total) as total 
    from temp_fact tf inner join dim_case dc on CONCAT(dc.status_name ,'_',dc.status_detail) = tf.case
    group by province_id, case_id, year
    order by province_id, case_id, year asc;

TRUNCATE fact_district_monthly RESTART IDENTITY;
INSERT INTO fact_district_monthly(district_id,case_id,month,total)
    select district_id , dc.id as case_id, to_char(date, 'YYYY-MM') as month, Sum(total) as total 
    from temp_fact tf inner join dim_case dc on CONCAT(dc.status_name ,'_',dc.status_detail) = tf.case
    group by district_id, case_id, month
    order by district_id, case_id, month asc;

TRUNCATE fact_district_yearly RESTART IDENTITY;
INSERT INTO fact_district_yearly(district_id,case_id,year,total)
    select district_id, dc.id as case_id, extract(year from date) as year, Sum(total) as total 
    from temp_fact tf inner join dim_case dc on CONCAT(dc.status_name ,'_',dc.status_detail) = tf.case
    group by district_id, case_id, year
    order by district_id, case_id, year asc;

DROP TABLE temp_fact, warehouse_table;