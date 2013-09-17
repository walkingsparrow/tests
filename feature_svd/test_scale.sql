
drop table if exists scale_10000_1600;
create table scale_10000_1600 as select row_id, madlib.__rand_vector(1600)::double precision[] as row_vec from generate_series(0,10000-1) as row_id;

drop table if exists svd_u;
drop table if exists svd_v;
drop table if exists svd_s;
drop table if exists svd_sum;
select madlib.svd('scale_10000_1600', 'svd', 'row_id', 1600, 'svd_sum');
