CREATE EXTERNAL TABLE IF NOT EXISTS BID_CITY_PARTITIONED (
    bid_id STRING,
    tstmp BIGINT,
    ipinyou_id STRING,
    usr_agent STRING,
    ip STRING,
    region_id INT,
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
PARTITIONED BY (city_id INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/user/aliaksei/data/partitioned_bid';

INSERT OVERWRITE TABLE BID_CITY_PARTITIONED
PARTITION (city_id)
SELECT bid_id,
           tstmp,
           ipinyou_id,
           usr_agent,
           ip,
           region_id,
           ad_exchange,
           domain,
           url,
           anonymous_url,
           ad_slot_id,
           ad_slot_width,
           ad_slot_height,
           ad_slot_visibility,
           ad_slot_format,
           ad_slot_floor_price,
           creative_id,
           bidding_price,
           advertiser_id,
           usr_profile_id,
           city_id
FROM BID_DEFAULT;