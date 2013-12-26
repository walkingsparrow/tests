select madlib.clustered_variance_linregr();

select madlib.clustered_variance_linregr('usage');

\x

select * from abalone limit 10;

drop table if exists tbl_o6;
select madlib.linregr_train('abalone', 'tbl_o6', 'rings', 'array[1, shell, viscera, shucked, whole, height, diameter, length]');

select * from tbl_o6;

drop table if exists tbl_o7;
select madlib.clustered_variance_linregr('abalone', 'tbl_o7', 'rings', 'array[1, shell, viscera, shucked, whole, height, diameter, length]', 'sex');

select * from tbl_o7;

------------------------------------------------------------------------

select madlib.clustered_variance_logregr();

select madlib.clustered_variance_logregr('usage');

drop table if exists tbl_o2;
select madlib.logregr_train('abalone', 'tbl_o2', 'rings < 10', 'array[1, shell, viscera, shucked, whole, height, diameter, length]');

select * from tbl_o2;

drop table if exists tbl_o3;
select madlib.clustered_variance_logregr('abalone', 'tbl_o3', 'rings < 10', 'array[1, shell, viscera, shucked, whole, height, diameter, length]', 'sex');

select * from tbl_o3;

----------------------------------------------------------------------

select 'y < '||avg(y) from lin_auto_mpg_wi_cl1 where y is not null and madlib.array_contains_null(string_to_array(btrim(x, $${}$$), $$,$$)::double precision[]) is false;

drop table if exists cl_out;
select madlib.clustered_variance_logregr(
    'lin_auto_mpg_wi_cl1',
    'cl_out',
    'y < 23.4459183673469',
    'string_to_array(btrim(x, $${}$$), $$,$$)::double precision[]',
    'cl',
    NULL::text,
    1000,
    'irls',
    1e-8,
    False);


----------------------------------------------------------------------

select 'y < '||avg(y) from madlibtestdata.lin_auto_mpg_wi_cl2 where y is not null and madlib.array_contains_null(string_to_array(btrim(x, $${}$$), $$,$$)::double precision[]) is false;

select 'y < '||avg(y) from madlibtestdata.ris_part_null_double_wi_cl2 where y is not null and madlib.array_contains_null(x) is false;
