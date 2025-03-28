DROP TABLE IF EXISTS weather_data;

CREATE TABLE weather_data (
    id SERIAL PRIMARY KEY,
	event_timestamp TIMESTAMP,
	city TEXT NOT NULL,
    temperature DOUBLE PRECISION,
    apparent_temperature DOUBLE PRECISION,
    wind_speed DOUBLE PRECISION,
    wind_direction INT,
    precipitation INT,
    sunrise TIMESTAMP,
	sunset TIMESTAMP,
	daylight_duration  DOUBLE PRECISION,
	is_day BOOLEAN
);
