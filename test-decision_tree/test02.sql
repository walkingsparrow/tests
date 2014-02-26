-- test decision tree

\d madlibtestdata.kyphosis

select * from madlibtestdata.kyphosis limit 10;

-- ADD A COLUMN for THE ID
alter table madlibtestdata.kyphosis add column id SERIAL ;

select madlib.c45_clean('kyphosis_tt_infogain')  ;
select madlib.c45_clean('class_res');
SELECT * FROM madlib.c45_train(
    'infogain',
    'madlibtestdata.kyphosis',
    'madlibtestdata.kyphosis_tt_infogain',
    null,
    'age,number,start',
    'age,number,start',
    'id',
    'solder',
    100,
    'explicit',
    4,
    0.10,
    0.01,
    0);

SELECT * FROM madlib.c45_classify (
    'kyphosis_tt_infogain',
    'madlibtestdata.solder',
    'madlibtestdata.class_res');

select madlib.c45_display('madlibtestdata.kyphosis_tt_infogain');

select madlib.c45_score(
    'madlibtestdata.kyphosis_tt_infogain',
    'madlibtestdata.kyphosis',
    0);

----------------------------------------------------------------------

select madlib.c45_clean('kyphosis_tt_infogain')  ;
select madlib.c45_clean('class_res');
SELECT * FROM madlib.c45_train(
    'infogain',
    'madlibtestdata.kyphosis',
    'kyphosis_tt_infogain',
    null,
    'age,number,start',
    'age,number,start',
    'id',
    'kyphosis',
    100,
    'explicit',
    4,
    0.10,
    0.01,
    0);

SELECT * FROM madlib.c45_classify (
    'kyphosis_tt_infogain',
    'madlibtestdata.kyphosis',
    'class_res');

select madlib.c45_display('kyphosis_tt_infogain');

select madlib.c45_score(
    'madlibtestdata.kyphosis_tt_infogain',
    'madlibtestdata.kyphosis',
    0);
