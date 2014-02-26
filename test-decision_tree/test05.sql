drop table if exists abalone;
create table abalone as select * from madlibtestdata.dt_abalone;

alter table abalone add column r boolean;
update abalone set r = rings < 10;

select madlib.c45_clean('tt_infogain');

select madlib.c45_clean('class_res');

SELECT * FROM madlib.c45_train(
    'infogain',
    'abalone',
    'tt_infogain',
    null,
    'length, diameter, height, whole, shucked, viscera, shell',
    'sex, length, diameter, height, whole, shucked, viscera, shell',
    'id',
    'r',
    100,
    'explicit',
    7,
    0.01,
    0.01,
    0);

SELECT * FROM madlib.c45_classify (
    'tt_infogain',
    'abalone',
    'class_res');

select madlib.c45_display('tt_infogain');

select madlib.c45_score(
    'tt_infogain',
    'abalone',
    0);

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

select madlib.c45_clean('tt_infogain');
select madlib.c45_clean('class_res');

SELECT * FROM madlib.c45_train(
    'infogain',
    'dt_train',
    'tt_infogain',
    null,
    'length, diameter, height, whole, shucked, viscera, shell',
    'sex, length, diameter, height, whole, shucked, viscera, shell',
    'id',
    'r',
    100,
    'explicit',
    7,
    0.01,
    0.01,
    0);

SELECT * FROM madlib.c45_classify (
    'tt_infogain',
    'dt_test',
    'class_res');

select madlib.c45_display('tt_infogain');

select madlib.c45_score(
    'tt_infogain',
    'dt_test',
    0);
