
drop table if exists tsa_output;
drop table if exists tsa_output_summary;
drop table if exists tsa_output_residual;
select madlib.arima_train(
        'tseries',
        'tsa_output',
        'tstamp',
        'tval',
        NULL,
        True,
        ARRAY[2, 0, 1]
        );

select * from tsa_output;

select * from tsa_output_summary;

select * from tsa_output_residual where tstamp > 990 order by tstamp;

----------------------------------------------------------------------

select * from madlibtestdata.tsa_beer_time order by id limit 10;

drop table if exists tsa_output;
drop table if exists tsa_output_summary;
drop table if exists tsa_output_residual;
select madlib.arima_train(
        'madlibtestdata.tsa_beer_time',
        'tsa_output',
        'id',
        'val',
        NULL,
        True,
        ARRAY[1, 0, 1]
        );

select * from tsa_output;

select residual_variance, log_likelihood from tsa_output_summary;

select * from tsa_output_residual order by id limit 10;

----------------------------------------------------------------------

drop table if exists test1;

drop table if exists test2;

create table test1 as
    select generate_series(1,10) as idx;

insert into test1 values (NULL);
    
select * from test1;

create table test2 as
    select array_agg(idx order by idx) as val from test1;

select * from test2;

select generate_series(1,10) as idx, unnest(val) from test2;

select unnest(s.v), unnest(val) from test2, (select array_agg(idx order by idx) as v from test1 where idx is not NULL) s;
