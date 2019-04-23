#!/usr/bin/env bash

if [[ $# -ne 4 ]];then
    echo "Usage: ./run.sh <ddl init script> <ddl script> <query init script> <query script>"
    exit 1
fi

ddl_init_script=$1
ddl_script=$2

query_init_script=$3
query_script=$4

mvn clean package

jar="$( pwd )/target/$( ls -l target/ | grep -oPm 1 'hive\-task.+\.jar' )"

hive -i ${ddl_init_script} -f ${ddl_script}
hive -d parseUserAgentJar=${jar} -i ${query_init_script} -f ${query_script}
