-- Test SVD

select madlib.matrix_sparsify('s_m', 'res_example', False);

\timing

drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
drop table if exists res_sum;
select madlib.svd_sparse('res_example', 'svd', 'row_id', 'col_id', 'value', 24, 24, 'res_sum');

select * from svd_s order by row_id;

select * from res_sum;

select row_vec[1:10] from svd_u order by row_id limit 10;

select sum(row_vec[24] * row_vec[24])  from svd_v;

------------------------------------------------------------------------

\timing

drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
drop table if exists res_sum;
select madlib.svd_sparse_native('res_example', 'svd', 'row_id', 'col_id', 'value', 24, 24, 'res_sum');

select * from svd_s order by row_id;

select * from res_sum;

select row_vec[1:10] from svd_u order by row_id limit 10;

select sum(row_vec[24] * row_vec[24])  from svd_v;

------------------------------------------------------------------------
\timing

drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
drop table if exists res_sum;
select madlib.svd('madlibtestdata.pca_mat_600_100', 'svd', 'row_id', 100, 100, 'res_sum');

select * from svd_s order by row_id;

select * from res_sum;

select row_vec[1:10] from svd_u order by row_id limit 10;

select sum(row_vec[1] * row_vec[1])  from svd_u;

select sum(row_vec[24] * row_vec[24])  from svd_v;

------------------------------------------------------------------------

drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
drop table if exists res_sum;
select madlib.svd('s_m', 'svd', 'row_id', 24, 24);

select * from svd_s order by row_id;

select * from res_sum;

select row_vec[1:10] from svd_u order by row_id limit 10;

select sum(row_vec[20] * row_vec[20])  from svd_u;

------------------------------------------------------------------------

drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
drop table if exists res_sum;

select madlib.matrix_blockize('s_m', 100, 24, 's_m_b');

select madlib.svd_block('s_m_b', 'svd', 24, 24, 'res_sum');

select * from svd_s order by row_id;

select * from res_sum;

select row_vec[1:10] from svd_u order by row_id limit 10;

select sum(row_vec[20] * row_vec[20])  from svd_u;


------------------------------------------------------------------------

select madlib.matrix_blockize('madlibtestdata.pca_mat_100_100', 10, 10, 'mat_in_block');
