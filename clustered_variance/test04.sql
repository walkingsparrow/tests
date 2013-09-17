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



















------------------------------------------------------------------------

drop table if exists tbl_o7;
select madlib.clustered_variance_logregr('abalone1', 'tbl_o7', 'rings < 10', 'array[1, shell, viscera, shucked, whole, height, diameter, length]', 'const');
