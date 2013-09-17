
select madlib.arima_train();

select madlib.arima_train('usage');

select * from tseries order by tid limit 10;

select count(*) from tseries;

drop table if exists arima_out;
drop table if exists arima_out_summary;
drop table if exists arima_out_residual;
select madlib.arima_train('tseries', 'arima_out', 'tid', 'tval', NULL, True, array[2,0,1]);

select * from arima_out;

select * from arima_out_summary;

select * from arima_out_residual order by tid limit 10;

----------------------------------------------------------------------

select madlib.arima_forecast();

select madlib.arima_forecast('usage');

drop table if exists arima_forecast;
select madlib.arima_forecast('arima_out', 'arima_forecast', 20);

select * from arima_forecast order by steps_ahead;

