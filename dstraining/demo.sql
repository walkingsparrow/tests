-- dca1-mdw1.dan.dh.greenplum.com, gpadmin, changeme, dstraining

------------------------------------------------------------------------
-- Linear regression
------------------------------------------------------------------------

\df madlib.linregr_train

select * from madlibtestdata.dt_abalone order by id limit 10;

drop table if exists lin_res;
select madlib.linregr_train('madlibtestdata.dt_abalone', 'lin_res', 'rings', 'array[1, length, diameter, height, whole, shucked, viscera, shell]', 'sex', False);

\x on
select * from lin_res;

-- sandwich estimator
drop table if exists lin_res;
select madlib.robust_variance_linregr('madlibtestdata.dt_abalone', 'lin_res', 'rings', 'array[1, length, diameter, height, whole, shucked, viscera, shell]', 'sex');

\x on
select * from lin_res;

-- prediction
\x off
select rings, madlib.linregr_predict(coef, array[1, length, diameter, height, whole, shucked, viscera, shell])
from madlibtestdata.dt_abalone, lin_res limit 10;

------------------------------------------------------------------------
-- Logistic regression
------------------------------------------------------------------------

\df madlib.logregr_train

select median(rings) from madlibtestdata.dt_abalone;

drop table if exists log_res;
select madlib.logregr_train('madlibtestdata.dt_abalone', 'log_res', 'rings < 10', 'array[1, length, diameter, height, whole, shucked, viscera, shell]', 'sex');

\x on
select * from log_res;

-- sandwich estimator
drop table if exists log_res;
select madlib.robust_variance_logregr('madlibtestdata.dt_abalone', 'log_res', 'rings < 10', 'array[1, length, diameter, height, whole, shucked, viscera, shell]', 'sex');

\x on
select * from log_res;

-- prediction
\x off
select rings < 10 as real_value, madlib.logregr_predict(coef, array[1, length, diameter, height, whole, shucked, viscera, shell])
from madlibtestdata.dt_abalone, log_res limit 10;

------------------------------------------------------------------------
-- k-means clustering
------------------------------------------------------------------------

select * from madlibtestdata.km_abalone order by pid limit 10;

-- kmeans returns a composite data type
\x on
select (f).* from (
    select madlib.kmeanspp('madlibtestdata.km_abalone', 'position', 3, 'madlib.squared_dist_norm2', 'madlib.avg', 40, 0.001) as f
) s;
