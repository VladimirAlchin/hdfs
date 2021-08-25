#!/bin/bash

NUM_REDUCERS=2

hdfs dfs -rm -r -skipTrash $2

yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar \
    -D mapred.job.name="my_wordcout_example" \
    -D mapreduce.job.reduces=$NUM_REDUCERS \
    -D mapred.text.key.comparator.options=-k2,2nr \
    -D mapred.text.key.partitioner.options=-k1 \
    -files mapper.py,reducer.py \
    -mapper mapper.py \
    -reducer reducer.py \
    -input $1 \
    -output $2

for num in `seq 0 $(($NUM_REDUCERS - 1))`
do
    echo "PART$(($num+1)):"
    hdfs dfs -head $2/part-0000$num | head -2
    echo '####################'
done