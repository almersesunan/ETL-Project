from airflow.models import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dummy_operator import DummyOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

from scripts import func

default_arguments = {
    "owner": "almer",
    "email": "almer.sesunan@gmail.com",
    "start_date": datetime(2021, 12, 15)
}

with DAG(
    dag_id="etl_covid_case",
    schedule_interval="@daily",
    default_args=default_arguments
) as dag:

    start = DummyOperator(
        task_id="start",
    )

    api_to_mysql_task = PythonOperator(
    task_id="api_to_mysql_task",
    python_callable=func.api_to_mysql,
    op_kwargs={"url": 'https://covid19-public.digitalservice.id/api/v1/rekapitulasi_v2/jabar/harian?level=kab'}
    )

    mysql_to_postgres_task = PythonOperator(
    task_id="mysql_to_postgres_task",
    python_callable=func.mysql_to_postgres
    )

    create_table_task = PostgresOperator(
    task_id="create_table_task",
    postgres_conn_id='postgres_almer',
    sql='./sql/create_table.sql'
    )

    populate_dim_table_task = PostgresOperator(
    task_id="populate_dim_table_task",
    postgres_conn_id='postgres_almer',
    sql='./sql/populate_dim_table.sql'
    )

    dim_case_task = PythonOperator(
    task_id="dim_case_task",
    python_callable=func.dim_case_table
    )

    populate_fact_table_task = PostgresOperator(
    task_id="populate_fact_table_task",
    postgres_conn_id='postgres_almer',
    sql='./sql/populate_fact_table.sql'
    )

start >> api_to_mysql_task >> mysql_to_postgres_task >> create_table_task >> populate_dim_table_task >> dim_case_task >> populate_fact_table_task