##Map Reduce 

Shows the worst result. Comparing to _Tez_:
* writes inter-stages results to HDFS
* cannot have multiple _Reduce_ phases without _Map_ ones between them

## "Default" schema vs Partitioned by city

Since the most frequently used field in _joins_ and _aggregations_ is _city_id_ we can see improvement in performance when partitioning by this field.


_City_ table isn't large(<400 records), thus, we can expect that after distribution of _bids_ by _city_id_ we won't have big amount of small files.

Hive engine can avoid additional shuffling, since location of a particular key is already known.

## CSV vs ORC

ORC file format with its default _ZLIB_ compression brings significant performance boost.
* ORC doesn't read entire record: only required fields
* compression reduces I/O(which is usually bottleneck) at the cost of additional CPU usage

## Vectorization

Improves performance slightly. I think, with ORC and number of fields retrieved by the query, serialization overhead is not significant comparing to _Text_ file formats
 