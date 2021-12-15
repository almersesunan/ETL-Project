# ETL-Project
### Digital Skola Final Project

This final project is about Dockerize ETL Pipeline using ETL tools Airflow that extract
Public API data from https://pikobar.jabarprov.go.id/, then load into MySQL (Staging Area) and finally
aggregate the data and save into PostgreSQL.

## A. ETL Architecture Diagram and Integration Design Diagram
![image](https://user-images.githubusercontent.com/80158731/146135360-5261f681-a973-48bd-b9a0-3821dce05e64.png)

## B. API Specifications
![image](https://user-images.githubusercontent.com/80158731/146136884-0aa6176a-cb54-478d-a5b3-ce6d04b726cc.png)

## C. API Request Example
curl -X GET "https://covid19-public.digitalservice.id/api/v1/rekapitulasi_v2/jabar/harian?level=kab" -H "accept: application/json"

## D. API Response Example
![image](https://user-images.githubusercontent.com/80158731/146137091-6e7eff55-9699-4684-bf1f-65b717538c6d.png)

## E. Project Steps
1. Create Docker (MySQL, Airflow and PostgreSQL) in your local computer
2. Create Database in MySQL and PostgreSQL
3. Create Connection from Airflow to MySQL and PostgreSQL
4. Create DAG
    - Create DDL in MySQL
    - Get data from Public API covid19 and load data to MySQL
    - Create DDL in PostgreSQL for Fact table and Dimension table
    - Get data from MySQL table to create aggregate table
    - Create aggregate Province Daily save to Province Daily Table
    - Create aggregate Province Monthly save to Province Monthly Table
    - Create aggregate Province Yearly save to Province Yearly
    - Create aggregate District Monthly save to District Monthly
    - Create aggregate District Yearly save to District Yearly
5. Schedule the DAG daily.

## F. Table Specification
### Dimension table
1. Province table
    - province_id
    - province_name
2. District table
    - district_id
    - province_id
    - district_name
3. Case table
    - id
    - status_name (suspect, closecontact, probable, confirmation)
    - status_detail

### Fact table
1. Province Daily Table
    - id (auto generate)
    - province_id
    - case_id
    - date
    - total
2. Province Monthly Table
    - id (auto generate)
    - province_id
    - case_id
    - month
    - total
3. Province Yearly Table
    - id (auto generate)
    - province_id
    - case_id
    - year
    - total
4. District Monthly Table
    - id (auto generate)
    - district_id
    - case_id
    - month
    - total
5. District Yearly Table
    - id (auto generate)
    - district_id
    - case_id
    - year
    - total

## G. Mounting Docker Path
1. Airflow dag path
    - ./dags:/opt/bitnami/airflow/dags
3. MySQL data path
    - my-db:/var/lib/mysql
5. PostgreSQL data path
    - database-data:/var/lib/postgresql/data/
    
## H. File Structure
![image](https://user-images.githubusercontent.com/80158731/146139828-d3d97738-ad5a-47f2-95db-aa558d053db2.png)

## Informations
- Based on Airflow (2.2.2) Image docker.io/bitnami/airflow:2.2.2-debian-10-r8, docker.io/bitnami/airflow-scheduler:2.2.2-debian-10-r9, docker.io/bitnami/airflow-worker:2.2.2-debian-10-r9 and uses the official Postgres as backend and Redis as queue
- Based on MySQL (5.7) official Image mysql:5.7
- Based on PostgreSQL (10) official Image postgres:10
