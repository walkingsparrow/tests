-- test decision tree

\d madlibtestdata.kyphosis

select * from madlibtestdata.kyphosis limit 10;

-- ADD A COLUMN for THE ID
-- alter table madlibtestdata.kyphosis add column id SERIAL ;

select madlib.c45_clean('kyphosis_tt_infogain');
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
    6,
    0.01,
    0.01,
    0);

select * from kyphosis_tt_infogain;

SELECT * FROM madlib.c45_classify (
    'kyphosis_tt_infogain',
    'madlibtestdata.kyphosis',
    'class_res');

select madlib.c45_display('kyphosis_tt_infogain');

select madlib.c45_score(
    'kyphosis_tt_infogain',
    'madlibtestdata.kyphosis',
    0);
