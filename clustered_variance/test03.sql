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

drop table if exists tbl_o7;
select madlib.clustered_variance_linregr('abalone', 'tbl_o7', 'rings', 'array[1, shell, viscera, shucked, whole, height, diameter, length]', NULL);


------------------------------------------------------------------------


select * from madlibtestdata.lin_ornstein_wi_cl2 limit 10;

drop table if exists tbl_o8;
select madlib.linregr_train('madlibtestdata.lin_ornstein_wi_cl2', 'tbl_o8', 'y', 'string_to_array(btrim(x, $${}$$), $$,$$)::double precision[]');

select * from tbl_o8;

drop table if exists tbl_o9;
select madlib.clustered_variance_linregr('madlibtestdata.lin_ornstein_wi_cl2', 'tbl_o9', 'y', 'string_to_array(btrim(x, $${}$$), $$,$$)::double precision[]', 'cl1, cl2');

select * from tbl_o9;





