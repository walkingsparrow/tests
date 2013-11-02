
select madlib.clustered_variance_coxph();

select madlib.clustered_variance_coxph('usage');

----------------------------------------------------------------------

-- CoxPH train
drop table if exists bladder2_out;
drop table if exists bladder2_out_summary;
select madlib.coxph_train('bladder2', 'bladder2_out', 'stop', 'array[rx, number, size]', 'event>0', 'enum', NULL);

\x on
select * from bladder2_out;
\x off

-- CLustered variance
drop table if exists bladder2_cluster;
select madlib.clustered_variance_coxph('bladder2_out', 'bladder2_cluster', 'cl');

\x on
select * from bladder2_cluster;
\x off

------------------------------------------------------------------------

drop table if exists lung_cl_out;
drop table if exists lung_out;
drop table if exists lung_out_summary;
select madlib.coxph_train('madlibtestdata.lung', 'lung_out', 'time', 'array[age, "ph.ecog"]', 'TRUE', NULL, NULL);
select madlib.clustered_variance_coxph('lung_out', 'lung_cl_out', '"ph.karno"');

\x on
select * from lung_cl_out;
\x off
