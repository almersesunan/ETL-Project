import pandas as pd
import requests
from sqlalchemy import create_engine
import mysql.connector


def api_to_mysql(url):
    mysql_engine = create_engine(f"mysql+mysqlconnector://user:password@35.224.124.193:3310/db")
    response = requests.get(url)
    data = response.json()
    df = pd.DataFrame(data['data']['content']) 
    # df.columns = map(str.lower, df.columns)
    df.to_sql(name='staging_table', con=mysql_engine, if_exists="replace", index=False)

def mysql_to_postgres():
    postgres_engine = create_engine(f"postgresql+psycopg2://unicorn_user:magical_password@35.224.124.193:5440/rainbow_database")
    mysql_engine = create_engine(f"mysql+mysqlconnector://user:password@35.224.124.193:3310/db")
    df = pd.read_sql(sql='staging_table', con=mysql_engine)
    df.to_sql(name='warehouse_table', con=postgres_engine, if_exists="replace", index=False)

def dim_case_table():
    postgres_engine = create_engine(f"postgresql+psycopg2://unicorn_user:magical_password@35.224.124.193:5440/rainbow_database")
    df = pd.read_sql(sql='warehouse_table', con=postgres_engine)
    temp = df.columns
    status_name = []
    status_detail = []
    for column in temp:
      if column.isupper():
        status_name.append(column)
      else:
        status_detail.append(column)
    merge = []
    id = 0
    for word in status_name:
      for sentence in status_detail:
        split = sentence.split("_")
        if word.lower() in split:
          id = id + 1
          merge.append([id,split[0].lower(),split[1]])
    dim_case = pd.DataFrame(merge, columns=['id','status_name','status_detail'])
    dim_case.to_sql(name='dim_case', con=postgres_engine, if_exists="replace", index=False)