
drop table if exists cox_out;
drop table if exists cox_out_summary;
select madlib.coxph('pbc_nonull', 'cox_out', 'time', 'array[log(bili), log(protime), age]', 'status>0', 'sex');

select * from cox_out;
