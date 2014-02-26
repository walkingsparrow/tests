-- ADD A COLUMN for THE
alter table madlibtestdata.kyphosis add column id SERIAL ;

\timing

select madlib.c45_clean('tree_kyphosis');
select madlib.c45_clean('madlibtestdata.tree_kyphosis');
select madlib.c45_clean('class_res');

SELECT * FROM madlib.c45_train(
    'infogain',
    'madlibtestdata.kyphosis',
    'tree_kyphosis',
    null,
    'age, number, start',
    'age, number, start',
    'id',
    'kyphosis',
    100,
    'explicit',
    5,
    0.01, -- node_prune_threshold
    0.01, -- node_split_threshold
    0
);

SELECT * FROM madlib.c45_classify (
    'tree_kyphosis',
    'madlibtestdata.kyphosis',
    'class_res');

select madlib.c45_display('tree_kyphosis');

select madlib.c45_score(
    'tree_kyphosis',
    'madlibtestdata.kyphosis',
    0);

select madlib.__get_schema_name('madlibtestdata.kyphosis');

select length(madlib.__get_schema_name('kyphosis'));

select regexp_replace('madlibtestdata.madlibtestdata_kyphosis', '^' || 'madlibtestdata' || '.', '');

select regexp_replace('kyphosis', 'public' || '.', '');

alter table eldata set schema madlibtestdata;

alter table madlibtestdata.eldata rename to eldata1;

alter table eldata1 set schema public;
