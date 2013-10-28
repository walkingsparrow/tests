
drop table if exists bladder1_out;
drop table if exists bladder1_out_summary;
select madlib.coxph_train('bladder1', 'bladder1_out', 'stop', 'array[rx, size, number]', 'event>0', NULL, NULL);

select * from bladder1_out;

----------------------------------------------------------------------

drop table if exists bladder1_out;
drop table if exists bladder1_out_summary;
select madlib.robust_variance_coxph('bladder1', 'bladder1_out', 'stop', 'array[rx, size, number]', 'TRUE', NULL, NULL);

\x on
select * from bladder1_out;
select * from bladder1_out_summary;

----------------------------------------------------------------------

drop table if exists bladder1_out;
drop table if exists bladder1_out_summary;
select madlib.robust_variance_coxph('madlibtestdata.cox_leukemia', 'bladder1_out', 'y', 'x', 'TRUE', NULL, 'max_iter=20');

\x on
select * from bladder1_out;
select * from bladder1_out_summary;

----------------------------------------------------------------------

drop table if exists lk_out;
drop table if exists lk_out_summary;
select madlib.coxph_train('madlibtestdata.cox_leukemia', 'lk_out', 'y', 'x', 'TRUE', NULL);

\x on
select * from lk_out;
select * from lk_out_summary;

drop table if exists lk_r_out;
select madlib.robust_variance_coxph('lk_out', 'lk_r_out');

\x on
select * from lk_r_out;

----------------------------------------------------------------------

drop table if exists bladder1_out;
drop table if exists bladder1_out_summary;
select madlib.coxph_train('bladder2', 'bladder1_out', 'stop', 'array[rx, size, number]', 'event>0', 'enum1', NULL);

\x on
select * from bladder1_out;

drop table if exists bladder1_r_out;
select madlib.robust_variance_coxph('bladder1_out', 'bladder1_r_out');

\x on
select * from bladder1_r_out;

----------------------------------------------------------------------

drop table if exists lk_out;
drop table if exists lk_out_summary;
select madlib.coxph_train('madlibtestdata.cox_leukemia', 'lk_out', 'y', 'x', 'y < 15', NULL);

\x on
select * from lk_out;
select * from lk_out_summary;

drop table if exists lk_r_out;
select madlib.robust_variance_coxph('lk_out', 'lk_r_out');

\x on
select * from lk_r_out;

create type _test_type as (
    x   double precision[],
    y   double precision
);

create table test23 (a _test_type, b integer);


SELECT t.typname
FROM pg_class c JOIN pg_attribute a ON c.oid = a.attrelid JOIN pg_type t ON a.atttypid = t.oid
WHERE c.relname = '_test_type';

SELECT c.oid,
  n.nspname,
  c.relname
FROM pg_catalog.pg_class c
     LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relname ~ '^(_test_type)$'
  AND pg_catalog.pg_table_is_visible(c.oid)
ORDER BY 2, 3;

SELECT a.attname,
  pg_catalog.format_type(a.atttypid, a.atttypmod),
  (SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128)
   FROM pg_catalog.pg_attrdef d
   WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef),
  a.attnotnull, a.attnum
FROM pg_catalog.pg_attribute a
LEFT OUTER JOIN pg_catalog.pg_attribute_encoding e
ON   e.attrelid = a .attrelid AND e.attnum = a.attnum
WHERE a.attrelid = '211933' AND a.attnum > 0 AND NOT a.attisdropped
ORDER BY a.attnum


select madlib.coxph_train(
'madlibtestdata.pbc',
'__madlib_temp_80294032_1382141071_85680586__',
'time',
'array[trt, log(bili), log(protime), age, platelet]',
'TRUE',
NULL,
NULL);

\x on
select * from __madlib_temp_80294032_1382141071_85680586__;

drop table if exists lk_r_out;
select madlib.robust_variance_coxph('__madlib_temp_80294032_1382141071_85680586__', 'lk_r_out');
