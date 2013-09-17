-- run tests

drop table if exists test;
create table test as
    select i as idx, i::double precision as val
    from generate_series(1,20) i;

drop table if exists test1;
create table test1 (idx integer, val double precision);
insert into test1 values
    (1, 2),
    (2, 5),
    (3, 1),
    (4, 7),
    (5, 2),
    (6, 2),
    (7, 8),
    (8, 3),
    (9, 3),
    (10, 12);

select * from test order by idx;

select sum(val) over (w), madlib.try_window_agg(val) over (w) from test window w as (order by idx rows 2 preceding);

select madlib.__arima_diff_agg(val, 1) over (w) from test window w as (order by idx rows 1 preceding);

select * from test1 order by idx;

select sum(val) over (w), madlib.try_window_agg(val) over (w) from test1 window w as (order by idx rows 2 preceding);

select idx - 2 as idx, diff from (
    select idx, madlib.__arima_diff_agg(idx, val, 2) over (w) as diff
    from test1 window w as (order by idx rows 2 preceding)) s
where idx > 2;

----------------------------------------------------------------------

select idx, madlib.array_agg(val) over (w) from test1 window w as (order by idx rows 0 preceding);

----------------------------------------------------------------------

select i as tid, array[0,0,0,0] as prevz from generate_series(1,5) i;

----------------------------------------------------------------------

select madlib.arima_train();

select madlib.arima_train('usage');

select * from tseries order by  tid;

\x on

drop table if exists arima_out;
drop table if exists arima_out_summary;
drop table if exists arima_out_residual;
select madlib.arima_train('tseries', 'arima_out', 'tid', 'tval', NULL, True, array[2,0,1], 'chunk_size=10000');

select * from arima_out;
select * from arima_out_summary;

select * from arima_out_residual order by tid limit 20;

select generate_series(1, array_upper(residuals, 1)) + tid - 1 as tid, unnest(residuals) as residual from arima_out_residual;

----------------------------------------------------------------------

select * from __madlib_temp_28273481_1377821456_4256088__diff_tbl__ order by distid;

select array_upper(tvals, 1) from __madlib_temp_28273481_1377821456_4256088__diff_tbl__ order by distid;

select array_upper(residuals, 1) from arima_out_residual order by tid;

select count(*) from tseries;

----------------------------------------------------------------------

drop table if exists arima_out;
drop table if exists arima_out_summary;
drop table if exists arima_out_residual;
select madlib.arima_train('madlibtestdata.tsa_beer', 'arima_out', 'id', 'val', NULL, True, array[1,2,1], 'chunk_size=1000');
select * from arima_out;

select * from arima_out_summary;

select * from arima_out_residual order by tid limit 10;


select count(*) from tseries;


drop table if exists arima_out;
drop table if exists arima_out_summary;
drop table if exists arima_out_residual;
select madlib.arima_train('tseries', 'arima_out', 'tid', 'tval', NULL, False, array[2,1,1], 'chunk_size=100, anneal=0., anneal_kc=20, anneal_decay=10');
select * from arima_out;
select * from arima_out_summary;

select * from arima_out_residual order by tid limit 20;

----------------------------------------------------------------------

drop table if exists arima_out;
drop table if exists arima_out_summary;
drop table if exists arima_out_residual;
select madlib.arima_train('tseries', 'arima_out', 'tid', 'tval', NULL, True, array[2,1,1], 'chunk_size=10000');

select * from arima_out;
select * from arima_out_summary;

select * from arima_out_residual order by tid limit 20;
