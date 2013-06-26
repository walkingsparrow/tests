
\df madlib.robust_variance

select madlib.robust_variance();

select madlib.robust_variance('');

select madlib.robust_variance('usage');

------------------------------------------------------------------------

drop table if exists tbl_out;
select madlib.linregr_train('abalone', 'tbl_out', 'rings', 'array[1, height, diameter, length, whole]');

select * from tbl_out;

drop table if exists tbl_out;
select madlib.robust_variance('abalone', 'tbl_out', 'linear', 'rings', 'array[1, height, diameter, length, whole]');

select * from tbl_out;

------------------------------------------------------------------------

drop table if exists tbl_out;
select madlib.robust_variance('abalone', 'tbl_out', 'linear', 'rings', 'array[1, log(height+1), log(diameter+1), length, whole]');

select * from tbl_out;

------------------------------------------------------------------------

-- drop table if exists tbl_out;
-- select madlib.robust_variance('abalone', 'tbl_out', 'linear', 'rings', '*');

-- select * from tbl_out;

------------------------------------------------------------------------

drop table if exists tbl_out;
select madlib.linregr_train('abalone', 'tbl_out', 'rings+shell', 'array[1, height, diameter, length, whole]');

select * from tbl_out;

drop table if exists tbl_out;
select madlib.robust_variance('abalone', 'tbl_out', 'linear', 'rings+shell', 'array[1, height, diameter, length, whole]');

select * from tbl_out;

------------------------------------------------------------------------

drop table if exists tbl_out;
select madlib.linregr_train('abalone', 'tbl_out', 'rings+shell', 'array[height, diameter, length, whole]');

select * from tbl_out;

drop table if exists tbl_out;
select madlib.robust_variance('abalone', 'tbl_out', 'linear', 'rings+shell', 'array[height, diameter, length, whole]');

select * from tbl_out;

------------------------------------------------------------------------
-- Logistic regression

drop table if exists tbl_out;
select madlib.logregr_train('abalone', 'tbl_out', 'rings < 10', 'array[1, height, diameter, length, whole]');

select * from tbl_out;

drop table if exists tbl_out;
select madlib.robust_variance('abalone', 'tbl_out', 'logistic', 'rings < 10', 'array[1, height, diameter, length, whole]');

select * from tbl_out;

------------------------------------------------------------------------

drop table if exists tbl_out;
select madlib.robust_variance('abalone', 'tbl_out', 'logistic', 'rings < 10', 'array[height, diameter, length, whole]');

select * from tbl_out;

------------------------------------------------------------------------

drop table if exists tbl_out;
select madlib.robust_variance('abalone', 'tbl_out', 'logistic', '"rings" < 10', 'array[1, log(height+1), diameter, length, "whole"]');

select * from tbl_out;

------------------------------------------------------------------------

