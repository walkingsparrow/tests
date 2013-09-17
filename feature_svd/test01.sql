-- Test SVD

\timing

drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
drop table if exists res_sum;
select madlib.svd_sparse('res_example', 'svd', 'row_id', 'col_id', 'value', 24, 24, 'res_sum');

select * from svd_s order by row_id;

select * from res_sum;

select row_vec[1:10] from svd_u order by row_id limit 10;

select sum(row_vec[1] * row_vec[2])  from svd_u;

------------------------------------------------------------------------

drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
drop table if exists res_sum;
select madlib.svd('pca_mat_600_100', 'svd', 'row_id', 10, 46, 'res_sum');

select * from svd_s order by row_id;

select * from res_sum;

select row_vec[1:10] from svd_u order by row_id limit 10;

select sum(row_vec[1] * row_vec[1])  from svd_u;

------------------------------------------------------------------------

select madlib.matrix_mult('pca_mat_600_100', True, 'pca_mat_600_100', False, 'cor_mat');

drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
drop table if exists res_sum;
select madlib.svd('cor_mat', 'svd', 'row_id', 100, 100, 'res_sum');

select * from svd_s order by row_id;

select * from res_sum;


------------------------------------------------------------------------
-- small data set

drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
select madlib.svd('mat', 'svd', 'row_id', 10);

select * from svd_s order by row_id;

------------------------------------------------------------------------

drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
drop table if exists res_sum;
select madlib.svd('s_m', 'svd', 'row_id', 10, 'res_sum');

select * from svd_s order by row_id;

select * from svd_u order by row_id;

select * from res_sum;

------------------------------------------------------------------------

select madlib.matrix_densify('madlibtestdata.pca_smat_100_100', 'row_id', 'col_id', 'value', 'pca_mat', False);

select row_id, row_vec[1:10] from pca_mat order by row_id limit 10;

select row_id, row_vec[1:10] from madlibtestdata.pca_mat_100_100 order by row_id limit 10;

------------------------------------------------------------------------

drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
drop table if exists res_sum;
select madlib.svd('madlibtestdata.pca_mat_100_100', 'svd', 'row_id', 10, 'res_sum');

select * from svd_s order by row_id;

select * from res_sum;

drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
drop table if exists res_sum;
select madlib.svd_sparse('madlibtestdata.pca_smat_100_100', 'svd', 'row_id', 'col_id', 'value', 10, 'res_sum');

select * from svd_s order by row_id;

select * from res_sum;

