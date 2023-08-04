"""Скрипт для заполнения данными таблиц в БД Postgres."""

import psycopg2
import os
import csv

pg_password = os.getenv('PG_PASSWORD')


def get_data_from_csv(file_name: str) -> list:
    """
    Получает имя csv-файла, возвращает список кортежей с данными из файла
    """
    with open(file_name, encoding='utf-8') as file:
        reader = csv.reader(file, delimiter=',')
        data = []
        for row in reader:
            if count > 0:
                data.append(tuple(row))
    return data[1:]


try:
    with psycopg2.connect(host='localhost', database='north', user='postgres', password=pg_password) as conn:
        with conn.cursor() as cur:
            cur.executemany('INSERT INTO customers VALUES (%s, %s, %s)',
                            get_data_from_csv('north_data/customers_data.csv'))
            cur.executemany('INSERT INTO employees VALUES (%s, %s, %s, %s, %s, %s)',
                            get_data_from_csv('north_data/employees_data.csv'))
            cur.executemany('INSERT INTO orders VALUES (%s, %s, %s, %s, %s)',
                            get_data_from_csv('north_data/orders_data.csv'))
finally:
    conn.close()



