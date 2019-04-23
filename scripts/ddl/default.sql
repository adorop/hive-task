CREATE EXTERNAL TABLE IF NOT EXISTS BID_DEFAULT (
    bid_id STRING,
    tstmp BIGINT,
    ipinyou_id STRING,
    usr_agent STRING,
    ip STRING,
    region_id INT,
    city_id INT,
    ad_exchange INT,
    domain STRING,
    url STRING,
    anonymous_url STRING,
    ad_slot_id INT,
    ad_slot_width ARRAY<INT>,
    ad_slot_height ARRAY<INT>,
    ad_slot_visibility INT,
    ad_slot_format INT,
    ad_slot_floor_price INT,
    creative_id STRING,
    bidding_price STRING,
    advertiser_id STRING,
    usr_profile_id STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '${hivevar:bidlocation}';

CREATE EXTERNAL TABLE IF NOT EXISTS CITY (
    id INT,
    name STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '${hivevar:citylocation}';