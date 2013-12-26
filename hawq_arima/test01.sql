select madlib.arima_train('?');

\timing

drop table if exists arima_out, arima_out_summary, arima_out_residual;
select madlib.arima_train('tseries', 'arima_out', 'tstamp', 'tval', NULL, True, array[2,0,1]);

select * from arima_out;

set optimizer = on;
