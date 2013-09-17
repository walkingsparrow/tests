DROP TABLE IF EXISTS houses;
CREATE TABLE houses (id INT, tax INT, bedroom INT, bath FLOAT, price INT,
            size INT, lot INT);
COPY houses FROM STDIN WITH DELIMITER '|';
  1 |  590 |       2 |    1 |  50000 |  770 | 22100
  2 | 1050 |       3 |    2 |  85000 | 1410 | 12000
  3 |   20 |       3 |    1 |  22500 | 1060 |  3500
  4 |  870 |       2 |    2 |  90000 | 1300 | 17500
  5 | 1320 |       3 |    2 | 133000 | 1500 | 30000
  6 | 1350 |       2 |    1 |  90500 |  820 | 25700
  7 | 2790 |       3 |  2.5 | 260000 | 2130 | 25000
  8 |  680 |       2 |    1 | 142500 | 1170 | 22000
  9 | 1840 |       3 |    2 | 160000 | 1500 | 19000
 10 | 3680 |       4 |    2 | 240000 | 2790 | 20000
 11 | 1660 |       3 |    1 |  87000 | 1030 | 17500
 12 | 1620 |       3 |    2 | 118600 | 1250 | 20000
 13 | 3100 |       3 |    2 | 140000 | 1760 | 38000
 14 | 2070 |       2 |    3 | 148000 | 1550 | 14000
 15 |  650 |       3 |  1.5 |  65000 | 1450 | 12000
\.

DROP TABLE IF EXISTS houses_en;
SELECT madlib.elastic_net_train(
    'houses', 
    'houses_en', 
    'price', 
    'array[tax, bath, size]',
    'gaussian', 
    1, 
    10, 
    TRUE, 
    NULL, 
    'fista',
    '',
    NULL, 
    1000, 
    1e-6);

select * from houses_en;

drop table if exists house_en;
select madlib.elastic_net_train(
        'madlibtestdata.lin_housing_wi',
        'house_en',
        'y',
        'x',
        'gaussian',
        1,
        0.4,
        True,
        NULL,
        'fista',
        '{eta = 2, max_stepsize = 0.5, use_active_set = f}',
        NULL,
        2000,
        1e-6
    );

select * from house_en;

drop table if exists en_predict;
create table en_predict as
    SELECT 
        r.*,
        madlib.elastic_net_predict(
            'gaussian', 
            m.coef_nonzero, 
            m.intercept, 
            x
        ) as predict
    FROM madlibtestdata.lin_housing_wi r, house_en m;
