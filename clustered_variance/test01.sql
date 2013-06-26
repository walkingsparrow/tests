

drop table tbl_aba;
select madlib.linregr_train('abalone', 'tbl_aba', 'rings', 'array[1, length, height, diameter]');

drop table tbl_aba;
select madlib.robust_variance_linear('abalone', 'tbl_aba', 'rings', '*', NULL);

drop table tbl_aba;
select madlib.robust_variance_logistic('abalone', 'tbl_aba', 'rings < 10', '*', NULL);

select * from tbl_aba;

drop table if exists tbl_cl;
select madlib.clustered_variance_linregr('abalone', 'tbl_cl', 'rings', 'array[1, length, height, diameter]', 'sex', NULL::TEXT);

select * from tbl_cl;

explain
select (madlib.__clustered_compute_lin_stats(coef, meatvec, breadvec, mcluster::integer, num_rows::integer)).* from s;

ANALYZE
select (madlib.__clustered_compute_lin_stats(coef, meatvec, breadvec, mcluster::integer, num_rows::integer)).*
from (
    select
        sum(meatvec) as meatvec,
        sum(breadvec) as breadvec,
        sum(numRows) as num_rows,
        max(coef) as coef,
        count(*) as mcluster
    from (
        select
            (madlib.__clustered_err_lin_step(rings,
                array[1, length, height, diameter], __madlib_temp_48856613_1371778732_14119069__)).*,
            max(__madlib_temp_48856613_1371778732_14119069__) as coef,
            count(rings) as numRows
        from (
            select u.coef as __madlib_temp_48856613_1371778732_14119069__, v.*
            from
                tbl_aba u, abalone v
        ) s
        group by sex) t) w;


create or replace function mylog (x double precision) returns double precision as $$
BEGIN
    raise info 'OK';
    return log(x);
end;
$$ language plpgsql;

select mylog(1.2);

    select
        sum(meatvec) as meatvec,
        sum(breadvec) as breadvec,
        sum(numRows) as num_rows,
        max(coef) as coef,
        count(*) as mcluster
    from (
        select
            (madlib.__clustered_err_lin_step(rings,
                array[1, length, height, diameter], __madlib_temp_48856613_1371778732_14119069__)).*,
            max(__madlib_temp_48856613_1371778732_14119069__) as coef,
            count(rings) as numRows
        from (
            select u.coef as __madlib_temp_48856613_1371778732_14119069__, v.*
            from
                tbl_aba u, abalone v
        ) s
        group by sex) t;

\timing

select (f).* from (
select madlib.__clustered_compute_lin_stats(
'{2.83647907011095,-11.932681229322,20.3582340140695,25.7661475283167}'::double precision[],
'{558899.732415593,214849.064203288,49526.9906922626,166218.76391272,214849.064203288,83052.9546513536,18906.6534543463,64302.5971186304,49526.9906922626,18906.6534543463,4426.69741064491,14613.3527604984,166218.76391272,64302.5971186304,14613.3527604984,49790.4313398041}'::double precision[],
'{4177,2188.715,582.76,1703.72,2188.715,1207.096925,322.7209,941.849024999999,582.76,322.7209,88.6105000000005,252.148125,1703.72,941.849024999999,252.148125,736.042999999999}'::double precision[],
3,
4177) as f) q;

create table tty as
            select (f).* from (
                select madlib.__clustered_compute_lin_stats(
                    max(coef), sum(meatvec), sum(breadvec),
                    count(coef)::integer, (sum(numRows))::integer) as f
                from (
                    select
                        (madlib.__clustered_err_lin_step(rings,
                            array[1, length, height, diameter], __madlib_temp_4412488_1371781717_67794830__)).*,
                        max(__madlib_temp_4412488_1371781717_67794830__) as coef,
                        count(rings) as numRows
                    from (
                        select u.coef as __madlib_temp_4412488_1371781717_67794830__, v.*
                        from
                            tbl_aba u, abalone v
                    ) s
                    group by sex) t) q;
