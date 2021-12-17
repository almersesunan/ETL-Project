CREATE TABLE IF NOT EXISTS dim_province (
    province_id text,
    province_name text);

CREATE TABLE IF NOT EXISTS dim_district (
    district_id text,
    province_id text,
    district_name text);

CREATE TABLE IF NOT EXISTS dim_case (
    id SERIAL,
    status_name text,
    status_detail text);

CREATE TABLE IF NOT EXISTS fact_province_daily (
    id SERIAL,
    province_id text,
    case_id int,
    date text,
    total bigint);

CREATE TABLE IF NOT EXISTS fact_province_monthly (
    id SERIAL,
    province_id text,
    case_id int,
    month text,
    total bigint);

CREATE TABLE IF NOT EXISTS fact_province_yearly (
    id SERIAL,
    province_id text,
    case_id int,
    year text,
    total bigint);

CREATE TABLE IF NOT EXISTS fact_district_monthly (
    id SERIAL,
    district_id text,
    case_id int,
    month text,
    total bigint);

CREATE TABLE IF NOT EXISTS fact_district_yearly (
    id SERIAL,
    district_id text,
    case_id int,
    year text,
    total bigint);

CREATE TABLE IF NOT EXISTS temp_fact (
    province_id text,
    district_id text,
    date date,
    "case" text,
    total bigint);