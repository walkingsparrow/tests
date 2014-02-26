select * from msolder limit 10;

-- ADD A COLUMN for THE ID
alter table msolder add column id SERIAL ;

select madlib.c45_clean('msolder_tt_infogain');


select madlib.c45_clean('class_res');

\timing

SELECT * FROM madlib.c45_train(
    'infogain',
    'msolder',
    'msolder_tt_infogain',
    null,
    'panel, skips',
    'opening, mask, padtype, panel, skips',
    'id',
    'solder',
    100,
    'explicit',
    4,
    0.01, -- node_prune_threshold
    0.01, -- node_split_threshold
    0
);

select * from madlib.training_info;

select * from msolder_tt_infogain;

drop table msolder_tt_infogain_di1;
create table msolder_tt_infogain_di1 as
    select id, column_name, column_type, is_cont, textin(regclassout(table_oid::regclass)) as table_name, num_dist_value from msolder_tt_infogain_di;

drop table msolder_tt_infogain_di;
alter table msolder_tt_infogain_di1 rename to msolder_tt_infogain_di;

SELECT * FROM madlib.c45_classify (
    'msolder_tt_infogain',
    'msolder',
    'class_res');

select madlib.c45_display('msolder_tt_infogain');

select madlib.c45_score(
    'msolder_tt_infogain',
    'msolder',
    0);

----------------------------------------------------------------------

SELECT * FROM madlib.rf_clean('trained_tree_infogain');

SELECT * FROM madlib.rf_train(
    'infogain',
    'madlibtestdata.rf_golf',
    'trained_tree_infogain',
    10,
    NULL,
    0.632,
    'temperature,humidity',
    'outlook,temperature,humidity,windy',
    'id',
    'class',
    'explicit',
    10,
    0.0,
    0.0,
    0);

create table trained_tree_infogain_di1 as
    select id, column_name, column_type, is_cont, textin(regclassout(table_oid::regclass)) as table_name, num_dist_value from trained_tree_infogain_di;

drop table trained_tree_infogain_di;
alter table trained_tree_infogain_di1 rename to trained_tree_infogain_di;

SELECT * FROM madlib.rf_display('trained_tree_infogain');

SELECT * FROM madlib.rf_classify(
    'trained_tree_infogain',
    'madlibtestdata.rf_golf',
    'classification_result');

SELECT t.id, t.outlook, t.temperature, t.humidity, t.windy, c.class
FROM classification_result c, madlibtestdata.rf_golf t
WHERE t.id=c.id ORDER BY id;

SELECT * FROM madlib.rf_score(
    'trained_tree_infogain',
    'madlibtestdata.rf_golf',
    0);
