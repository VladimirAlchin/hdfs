#!/bin/bash
# echo Hello, > test_file_1
# echo hdfs > test_file_2
# echo ! > test_file_3
# # локальное исполнение без удаления
# mkdir task2
# for file in test*
# do
#     cat $file >> log.txt
#     mv -f -t task2 $file
# done
# ls -l | awk '{print $5}' >> log.txt
#
#
# для hdfs
echo Hello, > test_file_1
echo hdfs > test_file_2
echo ! > test_file_3

hdfs dfs -rm -r -skipTrash task2
hdfs dfs -mkdir task2

for file in test*
do
    hdfs dfs -put $file task2
    hdfs dfs -setrep 3 task2/$file
    hdfs dfs -cat task2/$file >> log.txt
    rm -f $file
done


# удаление всех объектов
hdfs dfs -rm -r -skipTrash task2
hdfs dfs -rm -r -skipTrash log.txt
