
select madlib.elastic_net_train('usage');

select madlib.elastic_net_train('fista');

drop table if exists abalone5;
create table abalone5 as
    select * from abalone
distributed by (id);

drop table if exists tbl_o5;
select madlib.elastic_net_train('abalone', 'tbl_o5', 'rings', 'array[shell, viscera, shucked, whole, height, diameter, length]', 'gaussian', 1, 0.3, True, NULL, 'FISTA', 'max_stepsize=1, random_stepsize=t', NULL, 1000, 1e-6);

select * from tbl_o5;

drop table if exists tbl_o6;
select madlib.linregr_train('abalone5', 'tbl_o6', 'rings', 'array[1, shell, viscera, shucked, whole, height, diameter, length]');

select * from tbl_o6;

drop table if exists tbl_o7;
select madlib.clustered_variance_linregr('abalone5', 'tbl_o7', 'rings', 'array[1, shell, viscera, shucked, whole, height, diameter, length]', 'sex');

\x on
select * from tbl_o7;


drop table if exists tbl_o8;
select madlib.robust_variance('abalone5', 'tbl_o8', 'linear', 'rings', 'array[1, shell, viscera, shucked, whole, height, diameter, length]');

select * from tbl_o8;

------------------------------------------------------------------------
explain ANALYZE
select sum(meatvec) from (
select (g).*, numRows from (
select
    sum(coef) as coef,
    madlib.__clustered_err_lin_step(rings,
        array[1, shell, viscera, shucked, whole, height, diameter],
        coef) as g,
    count(rings) as numRows
from (
    select u.coef as coef, v.*
    from
        tbl_o6 u, abalone v) s) t) p;

------------------------------------------------------------------------

select sum(meatvec) from (
select (g).*, numRows from (
select
    coef as coef,
    madlib.__clustered_err_lin_step(rings,
        array[1, shell, viscera, shucked, whole, height, diameter],
        coef) as g,
    count(rings) as numRows
from (
    select u.coef as coef, v.*
    from
        tbl_o6 u, abalone v) s
    group by coef
        ) t) p;

