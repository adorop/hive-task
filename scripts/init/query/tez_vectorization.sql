ADD JAR ${hivevar:parseUserAgentJar};

CREATE TEMPORARY FUNCTION parseUserAgent
AS 'com.aliaksei.darapiyevich.GenericUDTFParseUserAgent';

SET hive.execution.engine=tez;

SET tez.am.resource.memory.mb=250;
SET hive.tez.container.size=650;

SET hive.vectorized.execution.enabled=true;