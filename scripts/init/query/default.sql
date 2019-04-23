ADD JAR ${hivevar:parseUserAgentJar};

CREATE TEMPORARY FUNCTION parseUserAgent
AS 'com.aliaksei.darapiyevich.GenericUDTFParseUserAgent';

SET hivevar:tbl=BID_DEFAULT;

SET hive.cli.print.header=true;

SET tez.am.resource.memory.mb=250;
SET hive.tez.container.size=650;
