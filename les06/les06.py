#!/usr/local/bin/python3.7

import subprocess



# код ниже выполняем один раз для создания бд и таблицы на сервере
# создаем базу данных
create database if not exists student41_45;

hdfs dfs -chmod 777 t1
# создаем таблицу в бд
use student41_45;
drop table if exists t1;
    create table t1 (
        `id` int,
        `create_at` date,
        `name` string
    )
stored as TEXTFILE
location '/user/student41_45/t1/';

def run_bash_cmd(cmd: str):

    proc = subprocess.Popen(
        cmd,
        shell=True,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    try:
        outs, errs = proc.communicate()
        return outs.decode('utf-8')
    except Exception as E:
        print(E)

# создаем папки даем на них права 777
run_bash_cmd('hdfs dfs -mkdir les06 && hdfs dfs -chmod -R 777 les06 && hdfs dfs -mkdir t1 && hdfs dfs -chmod -R 777 t1')

# скуп
q1 = '''
    sqoop import --connect jdbc:postgresql://10.0.0.7/lesson5 \
    --username exporter --password exporter_pass --table student41_45 \
    --hive-import --hive-overwrite \
    --hive-database student41_45 --hive-table les06 \
    -m 1 \
    --fields-terminated-by "|"  \
    --target-dir 'les06' \
    --delete-target-dir
    '''

run_bash_cmd(q1)

# обработка данных через sqp
q2 = """
    drop table if exists student41_45.les06;
    create temporary external table les06 (
        `id` int,
        `create_at` date,
        `name` string
    )
    row format delimited fields terminated by '|'
    stored as TEXTFILE
    location "/user/student41_45/les06";

    insert into t1
    select 
        les06.`id` as `id`, 
        les06.`create_at` as `create_at`, 
        les06.`name` as `name`
    from les06
    left join t1
    on t1.`id` = les06.`id`
    where t1.`id` is NULL
    ;
"""

file_name = 'q2.sql'

# команду в файл, так как другого способа автомотизации вызова из баша более удобного не нашел
with open(file_name,'w') as f:
    f.write(q2)

# вызов файл из прошлого шага
run_bash_cmd(f'hive -f {file_name}')

# удаление всех действий на сервере
run_bash_cmd(f'rm -r {file_name} && rm -r student41_45.java')