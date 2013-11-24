
select madlib.margins_mlogregr('?');

select * from madlibtestdata.mlogr_test_wi limit 10;

drop table if exists mout;
drop table if exists mout_summary;
select madlib.mlogregr_train('madlibtestdata.mlogr_test_wi', 'mout', 'y', 'x');

\x on
select * from mout;
\x off

drop table if exists mout;
drop table if exists mout_summary;
select madlib.margins_mlogregr('madlibtestdata.mlogr_test_wi', 'mout', 'y', 'x');

\x on
select * from mout;
select * from mout_summary;
\x off

----------------------------------------------------------------------

drop table if exists mo;
drop table if exists mo_summary;
select madlib.mlogregr_train('madlibtestdata.mlogr_isis_wi', 'mo', 'y', 'x');

\x on
select * from mo;
\x off

drop table if exists mout;
drop table if exists mout_summary;
select madlib.margins_mlogregr('madlibtestdata.mlogr_isis_wi', 'mout', 'y', 'x', 0, NULL, NULL);

\x on
select * from mout;
select * from mout_summary;
\x off

----------------------------------------------------------------------

drop table if exists mout;
drop table if exists mout_summary;
select madlib.margins_mlogregr('madlibtestdata.mlogr_isis_wi', 'mout', 'y', 'x', 0, NULL, NULL, 1000, 'irls', 1e-8);

\x on
select * from mout;
\x off

\x on
select (f).* from (
select madlib.marginal_mlogregr(y, 3, 0, x, (select madlib.matrix_agg(coef order by category) from mo)) as f from madlibtestdata.mlogr_isis_wi) s;
\x off
