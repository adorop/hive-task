#HIVE TASK



[src](src) folder contains source of UDTF to parse User Agent string

[scripts](scripts) folder contains:
* [tables definitions](scripts/ddl) SQLs
* [query](scripts/query/default.sql) to find most popular device, OS and browser for each city
* [init scripts](scripts/init) that enable configurations required for running particular DDL/query and memory configurations to avoid OutOfMemoryError on containers

[performance-comparison.sh](performance_comparison.sh) runs _query_ against different tables with different configurations and saves time taken into file.
[Here's](result.csv) the example of such file.

[create_and_query_default.sh](create_and_query_default.sh) can be used to build, add and create temporary UDTF and run query with default configuration