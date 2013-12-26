-- test PCA performance in HAWQ

select madlib.pca_train('?');

\timing

drop table if exists pca_out, pca_out_mean;
select madlib.pca_train('pca_mat_1000_1000', 'pca_out', 'row_id', 200, NULL, 1000, False);

drop table if exists svd_out_u, svd_out_v, svd_out_s;
select madlib.svd('pca_mat_1000_1000', 'svd_out', 'row_id', 200, 1000);

drop table if exists svd_out_u, svd_out_v, svd_out_s;
select madlib.svd_sparse_native('pca_sparse', 'svd_out', 'rid', 'cid', 'val', 100000, 100000, 10, 100);

----------------------------------------------------------------------

