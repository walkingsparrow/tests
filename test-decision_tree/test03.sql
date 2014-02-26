-- test decision tree

\d madlibtestdata.solder

select * from madlibtestdata.solder limit 10;

-- ADD A COLUMN for THE ID
alter table madlibtestdata.solder add column id SERIAL ;

select madlib.c45_clean('solder_tt_infogain')  ;
select madlib.c45_clean('class_res');
SELECT * FROM madlib.c45_train(
    'infogain',
    'madlibtestdata.solder',
    'solder_tt_infogain',
    null,
    'panel, skips',
    'opening, mask, padtype, panel, skips',
    'id',
    'solder',
    100,
    'explicit',
    8,
    0.01,
    0.01,
    0);

SELECT * FROM madlib.c45_classify (
    'solder_tt_infogain',
    'madlibtestdata.solder',
    'class_res');

select madlib.c45_display('solder_tt_infogain');

select madlib.c45_score(
    'solder_tt_infogain',
    'madlibtestdata.solder',
    0);


----------------------------------------------------------------------

SELECT unnest
                    (
                        ARRAY[
                            'SMALLINT'::regtype::oid,
                            'INT'::regtype::oid,
                            'BIGINT'::regtype::oid,
                            'FLOAT8'::regtype::oid,
                            'REAL'::regtype::oid,
                            'DECIMAL'::regtype::oid,
                            'INET'::regtype::oid,
                            'CIDR'::regtype::oid,
                            'MACADDR'::regtype::oid,
                            'BOOLEAN'::regtype::oid,
                            'CHAR'::regtype::oid,
                            'VARCHAR'::regtype::oid,
                            'TEXT'::regtype::oid,
                            '"char"'::regtype::oid,
                            'DATE'::regtype::oid,
                            'TIME'::regtype::oid,
                            'TIMETZ'::regtype::oid,
                            'TIMESTAMP'::regtype::oid,
                            'TIMESTAMPTZ'::regtype::oid,
                            'INTERVAL'::regtype::oid
                        ]
                    );

select 1 where 22 not in (SELECT unnest
                    (
                        ARRAY[
                            'SMALLINT'::regtype::oid,
                            'INT'::regtype::oid
                        ]
                    )
);

create temp table test2 as (SELECT unnest
                    (
                        ARRAY[
                            'SMALLINT'::regtype::oid,
                            'INT'::regtype::oid,
                            'BIGINT'::regtype::oid,
                            'FLOAT8'::regtype::oid,
                            'REAL'::regtype::oid,
                            'DECIMAL'::regtype::oid,
                            'INET'::regtype::oid,
                            'CIDR'::regtype::oid,
                            'MACADDR'::regtype::oid,
                            'BOOLEAN'::regtype::oid,
                            'CHAR'::regtype::oid,
                            'VARCHAR'::regtype::oid,
                            'TEXT'::regtype::oid,
                            '"char"'::regtype::oid,
                            'DATE'::regtype::oid,
                            'TIME'::regtype::oid,
                            'TIMETZ'::regtype::oid,
                            'TIMESTAMP'::regtype::oid,
                            'TIMESTAMPTZ'::regtype::oid,
                            'INTERVAL'::regtype::oid
                        ]
                    )
);

select 1 where 22 not in (select * from test2);

select 1 where 22 not in (SELECT unnest(array[1,2]));
