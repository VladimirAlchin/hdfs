create database if not exists les05;
use les05;
--task2
create external table uber_data_ex (
	Dispatching_base_num string,
	Pickup_date timestamp,
	Affiliated_base_num string,
	locationID int
)
row format delimited fields terminated by ','
stored as TEXTFILE
location "/uber"
tblproperties ("skip.header.line.count"="1");

SELECT * from uber_data_ex limit 10;

--task3

SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;

--TEXTFILE
drop table if exists uber_data_ex_txt_2;
create table uber_data_ex_txt_2 (
    Dispatching_base_num string,
	Pickup_date timestamp,
	locationID int
)
partitioned by (Affiliated_base_num string)
stored as TEXTFILE
location '/les05/txt/'
;

insert overwrite table uber_data_ex_txt_2 partition(Affiliated_base_num)
select
     Dispatching_base_num, Pickup_date, locationID, Affiliated_base_num
from uber_data_ex
tablesample (1000 rows);

select * from uber_data_ex_txt_2 ;
select sum(locationID) from uber_data_ex_txt_2 ;

--тестим sequencefile
drop table if exists uber_data_ex_sq_2;
create table uber_data_ex_sq_2 (
    Dispatching_base_num string,
	Pickup_date timestamp,
	locationID int
)
partitioned by (Affiliated_base_num string)
stored as sequencefile
location '/les05/sq/'
;

insert overwrite table uber_data_ex_sq_2 partition(Affiliated_base_num)
select
     Dispatching_base_num, Pickup_date, locationID, Affiliated_base_num
from uber_data_ex
tablesample (1000 rows);

select * from uber_data_ex_sq_2;
select sum(locationID) from uber_data_ex_sq_2 ;

--parquet
drop table if exists uber_data_ex_pq_2;
create table uber_data_ex_pq_2 (
    Dispatching_base_num string,
	Pickup_date timestamp,
	locationID int
)
partitioned by (Affiliated_base_num string)
stored as parquet
location '/les05/pq/'
;

insert overwrite table uber_data_ex_pq_2 partition(Affiliated_base_num)
select
     Dispatching_base_num, Pickup_date, locationID, Affiliated_base_num
from uber_data_ex
tablesample (1000 rows);

select * from uber_data_ex_pq_2 ;
select sum(locationID) from uber_data_ex_pq_2 ;

--orc
drop table if exists uber_data_ex_orc_2;
create table uber_data_ex_orc_2 (
    Dispatching_base_num string,
	Pickup_date timestamp,
	locationID int
)
partitioned by (Affiliated_base_num string)
stored as parquet
location '/les05/orc/'
;

insert overwrite table uber_data_ex_orc_2 partition(Affiliated_base_num)
select
     Dispatching_base_num, Pickup_date, locationID, Affiliated_base_num
from uber_data_ex
tablesample (1000 rows);

select * from uber_data_ex_orc_2 ;
select sum(locationID) from uber_data_ex_orc_2 ;

--паркет на запись самый быстрый. разница до 10-15 раз.
--чтение примерно одинаковое
