SET client_min_messages TO WARNING;DROP TABLE IF EXISTS madlibtestdata.rf_golf; CREATE TABLE madlibtestdata.rf_golf(id SERIAL , outlook text, temperature float8, humidity float8, windy text, class text ) ; COPY madlibtestdata.rf_golf (outlook, temperature, humidity, windy, class) FROM stdin DELIMITER ',' NULL '?' ;
sunny, 85, 85, false, Don't Play
sunny, 80, 90, true, Don't Play
overcast, 83, 78, false, Play
rain, 70, 96, false, Play
rain, 68, 80, false, Play
rain, 65, 70, true, Don't Play
overcast, 64, 65, true, Play
sunny, 72, 95, false, Don't Play
sunny, 69, 70, false, Play
rain, 75, 80, false, Play
sunny, 75, 70, true, Play
overcast, 72, 90, true, Play
overcast, 81, 75, false, Play
rain, 71, 80, true, Don't Play
\.
ALTER TABLE madlibtestdata.rf_golf OWNER TO madlibtester;
