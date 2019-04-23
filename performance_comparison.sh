#!/usr/bin/env bash

if [[ $# -ne 3 ]];then
    echo "Usage ./performance_comparison.sh <udtf location> <bid location> <city location>"
    exit 1
fi

udtf_location=$1
bid_location=$2
city_location=$3

logs_dir=/var/percomp/logs

mkdir -p ${logs_dir}

hive -d bidlocation=${bid_location} -d citylocation=${city_location} -f scripts/ddl/default.sql
hive -i scripts/init/ddl/city_partitioned.sql -f scripts/ddl/city_partitioned.sql
hive -i scripts/init/ddl/orc.sql -f scripts/ddl/orc.sql

function run() {
    query_type=$1
    config_script=$2
    table_name=$3
    times=$4

    for (( i=0; i < ${times}; ++i ))
    do
        log="${logs_dir}/${query_type}_${i}"
        hive -d parseUserAgentJar=${udtf_location} -d tbl=${table_name} -i ${config_script} -f scripts/query/default.sql &> ${log}
        taken=$( tail -n1 ${log} | grep -oP "[0-9]+\.[0-9]+" )
        echo "${query_type},${taken}" >> /var/percomp/result.csv
    done
}

run "tez_default_schema" "scripts/init/query/tez.sql" "BID_DEFAULT" 5
run "tez_partitioned_schema" "scripts/init/query/tez.sql" "BID_CITY_PARTITIONED" 5
run "tez_orc" "scripts/init/query/tez.sql" "BID_ORC" 5
run "tez_vectorization" "scripts/init/query/tez_vectorization.sql" "BID_ORC" 5
run "mr_default_schema" "scripts/init/query/mr_default.sql" "BID_DEFAULT" 2

