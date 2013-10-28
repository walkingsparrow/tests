
drop table if exists bladder2_out;
drop table if exists bladder2_out_summary;
select madlib.coxph_train('bladder2', 'bladder2_out', 'stop', 'array[rx, number, size]', 'TRUE', NULL, NULL);

\x on
select * from bladder2_out;
\x off

drop table if exists bladder2_cluster;
select madlib.clustered_variance_coxph('bladder2_out', 'bladder2_cluster', 'cl');

\x on
select * from bladder2_cluster;
\x off

----------------------------------------------------------------------

drop table if exists bladder2_out;
drop table if exists bladder2_out_summary;
select madlib.coxph_train('bladder2', 'bladder2_out', 'stop', 'array[rx, number, size]', 'TRUE', NULL, NULL);

\x on
select * from bladder2_out;
\x off

drop table if exists bladder2_cluster;
select madlib.clustered_variance_coxph('bladder2_out', 'bladder2_cluster', 'cl');

\x on
select * from bladder2_cluster;
\x off

----------------------------------------------------------------------

drop table if exists bladder2_out;
drop table if exists bladder2_out_summary;
select madlib.coxph_train('bladder2', 'bladder2_out', 'stop', 'array[rx, number, size]', 'event>0', 'enum', NULL);

\x on
select * from bladder2_out;
\x off

drop table if exists bladder2_cluster;
select madlib.clustered_variance_coxph('bladder2_out', 'bladder2_cluster', 'cl1');

\x on
select * from bladder2_cluster;
\x off

----------------------------------------------------------------------

select madlib.clustered_variance_coxph();

select madlib.clustered_variance_coxph('?');

----------------------------------------------------------------------

-- NULL values

drop table if exists rossi_out;
drop table if exists rossi_out_summary;
select madlib.coxph_train('madlibtestdata.cox_rossi_strata_null', 'rossi_out', 'week', 'array[fin, prio]', 'arrest', NULL, NULL);

\x on
select * from rossi_out;
\x off

drop table if exists rossi_cluster;
select madlib.clustered_variance_coxph('rossi_out', 'rossi_cluster', 'race');

\x on
select * from rossi_cluster;
\x off

----------------------------------------------------------------------

-- NULL values

drop table if exists rossi_out;
drop table if exists rossi_out_summary;
select madlib.coxph_train('madlibtestdata.pbc', 'rossi_out', 'time', 'array[trt, log(bili), log(protime), age, platelet]', 'TRUE', NULL, NULL);

\x on
select * from rossi_out;
\x off

drop table if exists rossi_cluster;
select madlib.clustered_variance_coxph('rossi_out', 'rossi_cluster', 'stage');

\x on
select * from rossi_cluster;
\x off

----------------------------------------------------------------------

drop table if exists lung_cl_out;
drop table if exists lung_out;
drop table if exists lung_out_summary;
select madlib.coxph_train('madlibtestdata.lung', 'lung_out', 'time', 'array[age, "ph.ecog"]', 'TRUE', 'inst', NULL);
select madlib.clustered_variance_coxph('lung_out', 'lung_cl_out', '"ph.karno"');

\x on
select * from lung_cl_out;
\x off
