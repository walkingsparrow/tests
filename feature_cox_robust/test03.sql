DROP TABLE IF EXISTS sample_data;
CREATE TABLE sample_data (
    id INTEGER NOT NULL,
    grp DOUBLE PRECISION,
    wbc DOUBLE PRECISION,
    timedeath INTEGER,
    status BOOLEAN
);
COPY sample_data FROM STDIN DELIMITER '|';
  0 |   0 | 1.45 |        35 | t
  1 |   0 | 1.47 |        34 | t
  3 |   0 |  2.2 |        32 | t
  4 |   0 | 1.78 |        25 | t
  5 |   0 | 2.57 |        23 | t
  6 |   0 | 2.32 |        22 | t
  7 |   0 | 2.01 |        20 | t
  8 |   0 | 2.05 |        19 | t
  9 |   0 | 2.16 |        17 | t
 10 |   0 |  3.6 |        16 | t
 11 |   1 |  2.3 |        15 | t
 12 |   0 | 2.88 |        13 | t
 13 |   1 |  1.5 |        12 | t
 14 |   0 |  2.6 |        11 | t
 15 |   0 |  2.7 |        10 | t
 16 |   0 |  2.8 |         9 | t
 17 |   1 | 2.32 |         8 | t
 18 |   0 | 4.43 |         7 | t
 19 |   0 | 2.31 |         6 | t
 20 |   1 | 3.49 |         5 | t
 21 |   1 | 2.42 |         4 | t
 22 |   1 | 4.01 |         3 | t
 23 |   1 | 4.91 |         2 | t
 24 |   1 |    5 |         1 | t
\.

SELECT madlib.coxph_train( 'sample_data',
                           'sample_cox',
                           'timedeath',
                           'ARRAY[grp,wbc]',
                           'status'
                         );

SELECT madlib.robust_variance_coxph( 'sample_cox',
                           'sample_robust_cox'
                         );

\x on
SELECT * FROM sample_robust_cox;
