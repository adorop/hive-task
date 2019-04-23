CREATE VIEW IF NOT EXISTS CITY_USERAGENT_${hivevar:tbl} AS
SELECT city_id, device, os, browser
FROM ${hivevar:tbl}
LATERAL VIEW parseUserAgent(usr_agent) pua
AS device, os, browser;

CREATE VIEW IF NOT EXISTS TOP_DEVICE_${hivevar:tbl} AS
SELECT city_dev_cnt.city_id, device
FROM (
    SELECT city_id, device, count('*') cnt
    FROM CITY_USERAGENT_${hivevar:tbl}
    GROUP BY city_id, device
) city_dev_cnt
JOIN (
    SELECT city_id, max(cnt) max_cnt
    FROM (
        SELECT city_id, device, count('*') cnt
        FROM CITY_USERAGENT_${hivevar:tbl}
        GROUP BY city_id, device
    ) cn
    GROUP BY city_id
) city_dev_max_cnt
ON city_dev_cnt.city_id = city_dev_max_cnt.city_id
    AND city_dev_cnt.cnt = city_dev_max_cnt.max_cnt;

CREATE VIEW IF NOT EXISTS TOP_OS_${hivevar:tbl} AS
SELECT city_os_cnt.city_id, os
FROM (
    SELECT city_id, os, count('*') cnt
    FROM CITY_USERAGENT_${hivevar:tbl}
    GROUP BY city_id, os
) city_os_cnt
JOIN (
    SELECT city_id, max(cnt) max_cnt
    FROM (
        SELECT city_id, os, count('*') cnt
        FROM CITY_USERAGENT_${hivevar:tbl}
        GROUP BY city_id, os
    ) cn
    GROUP BY city_id
) city_os_max_cnt
ON city_os_cnt.city_id = city_os_max_cnt.city_id
    AND city_os_cnt.cnt = city_os_max_cnt.max_cnt;

CREATE VIEW IF NOT EXISTS TOP_BROWSER_${hivevar:tbl} AS
SELECT city_browser_cnt.city_id, browser
FROM (
    SELECT city_id, browser, count('*') cnt
    FROM CITY_USERAGENT_${hivevar:tbl}
    GROUP BY city_id, browser
) city_browser_cnt
JOIN (
    SELECT city_id, max(cnt) max_cnt
    FROM (
        SELECT city_id, browser, count('*') cnt
        FROM CITY_USERAGENT_${hivevar:tbl}
        GROUP BY city_id, browser
    ) cn
    GROUP BY city_id
) AS city_browser_max_cnt
ON city_browser_cnt.city_id = city_browser_max_cnt.city_id
    AND city_browser_cnt.cnt = city_browser_max_cnt.max_cnt;

SELECT c.name, device, os, browser
FROM CITY c
JOIN TOP_DEVICE_${hivevar:tbl}
    ON c.id = TOP_DEVICE_${hivevar:tbl}.city_id
JOIN TOP_OS_${hivevar:tbl}
    ON c.id = TOP_OS_${hivevar:tbl}.city_id
JOIN TOP_BROWSER_${hivevar:tbl}
    ON c.id = TOP_BROWSER_${hivevar:tbl}.city_id;