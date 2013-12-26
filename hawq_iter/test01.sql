\timing

select version();

show optimizer;

select count(*) from perf_test10;

select * from perf_test10 limit 2;

select distinct g from perf_test10;

select distinct g from perf_test1000;

----------------------------------------------------------------------

drop table if exists logout, logout_summary;

select madlib.logregr_train(
    'perf_test10', 'logout',
    'y::integer',
    'array[1, "V1", "V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13","V14","V15","V16","V17","V18","V19","V20"]',
    NULL, 10, 'irls', 0);

----------------------------------------------------------------------

drop table if exists logout, logout_summary;

select madlib.logregr_train(
    'perf_test10', 'logout',
    'y::integer',
    'array[1, "V1", "V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13","V14","V15","V16","V17","V18","V19","V20"]',
    'g', 10, 'irls', 0);

----------------------------------------------------------------------

drop table if exists logout, logout_summary;

select madlib.logregr_train(
    'perf_test1000', 'logout',
    'y::integer',
    'array[1, "V1", "V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13","V14","V15","V16","V17","V18","V19","V20"]',
    'g', 10, 'irls', 0);

----------------------------------------------------------------------

drop table if exists linout, linout_summary;

select madlib.linregr_train(
    'perf_test10', 'linout',
    'y',
    'array[1, "V1", "V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13","V14","V15","V16","V17","V18","V19","V20"]');

----------------------------------------------------------------------

drop table if exists linout, linout_summary;

select madlib.linregr_train(
    'perf_test10', 'linout',
    'y',
    'array[1, "V1", "V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13","V14","V15","V16","V17","V18","V19","V20"]',
    'g');

----------------------------------------------------------------------

drop table if exists linout, linout_summary;

select madlib.linregr_train(
    'perf_test1000', 'linout',
    'y',
    'array[1, "V1", "V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13","V14","V15","V16","V17","V18","V19","V20"]',
    'g');
