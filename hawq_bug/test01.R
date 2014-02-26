library(PivotalR)
db.connect(port = 18526, dbname = "madlib")

dat <- as.db.data.frame(abalone, "abalone")

db.q("drop table if exists abalone1_all_null;
CREATE TABLE abalone1_all_null (
    id integer,
    sex text,
    length double precision,
    diameter double precision,
    height double precision,
    whole double precision,
    shucked double precision,
    viscera double precision,
    shell double precision,
    rings integer
)")

db.q("INSERT INTO abalone1_all_null VALUES
(552, 'M', 1, 0.36499999999999999, 0.095000000000000001, 0.51400000000000001, 0.22450000000000001, 0.10100000000000001, 0.14999999999999999, 15),
(553, 'M', 0.44, 1., 0.125, 0.51600000000000001, 0.2155, 0.114, 0.155, 10),
(554, 'F', 0.53000000000000003, 0.41999999999999998, 1., 0.67700000000000005, 0.25650000000000001, 0.14149999999999999, 0.20999999999999999, 9),
(555, 'M', 0.34999999999999998, 0.26500000000000001, 0.089999999999999997, 1, 0.099500000000000005, 0.048500000000000001, 0.070000000000000007, 1.),
(556, 'M', 0.34999999999999998, 0.26500000000000001, 0.089999999999999997, 1., 0.099500000000000005, 0.048500000000000001, 0.070000000000000007, 7)")


db.q("INSERT INTO abalone1_all_null VALUES
(552, 'M', NULL, 0.36499999999999999, 0.095000000000000001, 0.51400000000000001, 0.22450000000000001, 0.10100000000000001, 0.14999999999999999, 15),
(553, 'M', 0.44, NULL, 0.125, 0.51600000000000001, 0.2155, 0.114, 0.155, 10),
(554, 'F', 0.53000000000000003, 0.41999999999999998, NULL, 0.67700000000000005, 0.25650000000000001, 0.14149999999999999, 0.20999999999999999, 9),
(555, 'M', 0.34999999999999998, 0.26500000000000001, 0.089999999999999997, 1, 0.099500000000000005, 0.048500000000000001, 0.070000000000000007, NULL),
(556, 'M', 0.34999999999999998, 0.26500000000000001, 0.089999999999999997, NULL, 0.099500000000000005, 0.048500000000000001, 0.070000000000000007, 7)")


db.q("
drop table if exists abalone2_all_null;
CREATE TABLE abalone2_all_null (
    id integer,
    sex text,
    length double precision,
    diameter double precision,
    height double precision,
    whole double precision,
    shucked double precision,
    viscera double precision,
    shell double precision,
    rings integer
)")

db.q("INSERT INTO abalone2_all_null SELECT * FROM abalone1_all_null")
