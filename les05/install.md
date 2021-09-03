Докер: https://www.docker.com/products/docker-desktop
WSL для Windows (если нет) https://docs.microsoft.com/ru-ru/windows/wsl/install-win10#step-4---download-the-linux-kernel-update-package
Хайв для докера: https://github.com/big-data-europe/docker-hive
SQL-клиент (для всех платформ): https://dbeaver.io/download/
Данные для теста форматов: https://www.kaggle.com/fivethirtyeight/uber-pickups-in-new-york-city
Данные для парсинга: https://www.kaggle.com/gpreda/reddit-vaccine-myths?select=reddit_vm.csv
Для отладки регулярного выражения: https://regexr.com/



Всем привет!
В качестве 5го дз вам будет нужно повторить экперимент, проведенный на лекции:
1. Развернуть кластер через Docker (или выполнить ДЗ на учебном клстере, удалив файлы потом)
2. Загрузить в наш развернутый hdfs самый большой файл из датасета и сделать external table (образец с лекции тут )
3. Далее создать таблицы с разными форматами как в local_hive.sql и попробовать пописать различные запросы, засечь и сравнить время.
4. Повторить эксперимент с паркетом и orc добавив 2 различных сжатия (GZIP/SNAPPY) и сравнить получившийся размер файлов с изначальным, 
а так же время выполнения запросов.

Пример сжатия:

Паркет:
set parquet.compression=SNAPPY;
CREATE TABLE testsnappy_pq
STORED AS PARQUET
AS SELECT * FROM sourcetable;

ORC:
CREATE TABLE testsnappy_orc
STORED AS ORC
TBLPROPERTIES("orc.compress"="gzip")
AS SELECT * FROM sourcetable;