\timing

----------------------------------------------------------------------

drop table if exists coxph_out;
drop table if exists coxph_out_summary;
select madlib.coxph('rossi', 'coxph_out', 'week', 'ARRAY[fin, prio]', 'arrest', NULL, 'max_iter=100, tolerance=1e-8');

select * from coxph_out;


drop table if exists coxph_out;
drop table if exists coxph_out_summary;
select madlib.coxph('rossi', 'coxph_out', 'week', 'ARRAY[fin, prio]', 'arrest', 'age_cat', 'max_iter=100, tolerance=1e-8');

select * from coxph_out;

----------------------------------------------------------------------

drop table if exists zph_out;
select madlib.zph('coxph_out', 'zph_out');

select * from zph_out_stat;
