DROP TABLE IF EXISTS weather_data;

CREATE TABLE weather_data (
    event_timestamp DateTime,
    city String,
    temperature Float64,
    apparent_temperature Float64,
    wind_speed Float64,
    wind_direction UInt16,
    precipitation UInt16,
    sunrise DateTime,
    sunset DateTime,
    daylight_duration Float64,
    is_day UInt8  -- 0 (ночь) или 1 (день)
) ENGINE = MergeTree()
ORDER BY (city, event_timestamp);
