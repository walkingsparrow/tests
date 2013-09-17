drop table if exists tsa_output;
drop table if exists tsa_output_summary;
drop table if exists tsa_output_residual;
select madlib.arima_train(
        'tseries',
        'tsa_output',
        'tid',
        'tval',
        NULL,
        True,
        ARRAY[2, 0, 1]
        );

select * from tsa_output;

select * from tsa_output_summary;

select * from tsa_output_residual where tstamp > 990 order by tstamp;
