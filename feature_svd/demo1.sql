select madlib.pca_train();

select madlib.pca_train('usage');

select * from madlibtestdata.pca_mat_600_100 limit 2;

drop table if exists pca_tbl;
drop table if exists pca_tbl_mean;
drop table if exists res_sum;
select madlib.pca_train('pca_mat_2000_1000', 'pca_tbl', 'row_id', 50, NULL, 100, False, 'res_sum');

select * from res_sum;

select eigen_values from pca_tbl order by row_id;

select principal_components from pca_tbl order by row_id limit 1;

------------------------------------------------------------------------

select madlib.pca_project();

select madlib.pca_project('usage');

drop table if exists proj_rst;
drop table if exists tbl_resid;
drop table if exists res_sum;
select madlib.pca_project('madlibtestdata.pca_mat_600_100', 'pca_tbl', 'proj_rst', 'row_id', 'tbl_resid', 'res_sum');

select * from proj_rst order by row_id limit 10;

select * from tbl_resid order by row_id limit 10;

select * from res_sum;

------------------------------------------------------------------------

select madlib.pca_sparse_train();

select madlib.pca_sparse_train('usage');

select * from madlibtestdata.pca_smat_600_100 order by row_id limit 10;

drop table if exists pca_tbl;
drop table if exists pca_tbl_mean;
drop table if exists res_sum;
select madlib.pca_sparse_train('madlibtestdata.pca_smat_600_100', 'pca_tbl', 'row_id', 'col_id', 'value', 600, 100, 30, NULL, 100, False, 'res_sum');

select * from res_sum;

select eigen_values from pca_tbl order by row_id;

select principal_components from pca_tbl order by row_id limit 1;

------------------------------------------------------------------------

select madlib.pca_sparse_project();

select madlib.pca_sparse_project('usage');

drop table if exists proj_rst;
drop table if exists tbl_resid;
drop table if exists res_sum;
select madlib.pca_sparse_project('madlibtestdata.pca_smat_600_100', 'pca_tbl', 'proj_rst', 'row_id', 'col_id', 'value', 600, 100, 'tbl_resid', 'res_sum');

select * from proj_rst order by row_id limit 10;

select * from tbl_resid order by row_id limit 10;

select * from res_sum;
