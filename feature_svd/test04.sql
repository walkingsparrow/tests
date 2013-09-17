drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
drop table if exists res_sum;
select madlib.svd('madlibtestdata.pca_mat_600_100', 'svd', 'row_id', 20, 100, 'res_sum');

select * from res_sum;

select * from svd_s order by row_id;

select * from svd_u order by row_id;

select sum(row_vec[2] * row_vec[2]) from svd_u;

select * from tmp_w order by row_id;

------------------------------------------------------------------------

select madlib.matrix_sparsify('tmp_w', 'tmp_ws', False);

drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
drop table if exists res_sum;
select madlib.svd_sparse_native('', 'svd', 'row_id', 'col_id', 'value', 4, 4, 2, 4, 'res_sum');

select * from res_sum;

select * from svd_s order by row_id;

select * from svd_u order by row_id;
