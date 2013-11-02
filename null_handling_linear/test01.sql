
drop table if exists mpg_out;
drop table if exists mpg_out_summary;
select madlib.clustered_variance_linregr('madlibtestdata.lin_auto_mpg_wi', 'mpg_out', 'y', 'x', 'y', NULL);

\x on
select * from mpg_out;
select * from mpg_out_summary;
\x off

drop table if exists mpg_out;
drop table if exists mpg_out_summary;
select madlib.clustered_variance_logregr('madlibtestdata.lin_auto_mpg_wi', 'mpg_out', 'y<20', 'x', 'y', NULL);

\x on
select * from mpg_out;
select * from mpg_out_summary;
\x off

----------------------------------------------------------------------

drop table if exists mpg_out;
drop table if exists mpg_out_summary;
select madlib.robust_variance_linregr('madlibtestdata.lin_auto_mpg_wi', 'mpg_out', 'y', 'x');

\x on
select * from mpg_out;
select * from mpg_out_summary;
\x off

drop table if exists mpg_out;
drop table if exists mpg_out_summary;
select madlib.robust_variance_logregr('madlibtestdata.lin_auto_mpg_wi', 'mpg_out', 'y<20', 'x');

\x on
select * from mpg_out;
select * from mpg_out_summary;
\x off

----------------------------------------------------------------------


