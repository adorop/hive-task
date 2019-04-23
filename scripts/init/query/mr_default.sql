ADD JAR ${hivevar:parseUserAgentJar};

CREATE TEMPORARY FUNCTION parseUserAgent
AS 'com.aliaksei.darapiyevich.GenericUDTFParseUserAgent';

SET hive.execution.engine=mr;

SET mapreduce.map.memory.mb=650;
SET mapreduce.reduce.memory.mb=650;
SET mapreduce.map.java.opts=-Xmx520m;
SET mapreduce.reduce.java.opts=-Xmx520m;