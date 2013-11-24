drop table if exists __madlib_temp_37630069_1384891451_1798790__;
drop table if exists __madlib_temp_37630069_1384891451_1798790___summary;
select madlib.margins_mlogregr(
    'madlibtestdata.mlogr_test_wi',
    '__madlib_temp_37630069_1384891451_1798790__',
    'y',
    'x',
    0,
    NULL,
    NULL,
    'max_iter=50,optimizer=irls,tolerance=1e-5'
    );

\x on
select * from __madlib_temp_37630069_1384891451_1798790__;
\x off
