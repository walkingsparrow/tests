DROP TABLE IF EXISTS assoc_rule_sets CASCADE;
    CREATE temp TABLE assoc_rule_sets
            (
            text_svec   TEXT,
            set_list madlib.svec,
            support     FLOAT8,
            iteration   INT
            )
DISTRIBUTED BY (text_svec);

DROP TABLE IF EXISTS assoc_rules_aux_tmp CASCADE;
CREATE temp TABLE assoc_rules_aux_tmp
    (
    ruleId      SERIAL,
    pre         TEXT,
    post        TEXT,
    support     FLOAT8,
    confidence  FLOAT8,
    lift        FLOAT8,
    conviction  FLOAT8
)
DISTRIBUTED BY (ruleId);

insert into assoc_rule_sets values
('1',	'{1,3}:{1,0}',	0.6,	1),
('2',	'{1,1,2}:{0,1,0}',	0.4,	1),
('3',	'{2,1,1}:{0,1,0}',	0.4,	1),
('4',	'{3,1}:{0,1}',	0.2,	1),
('1,2',	'{2,2}:{1,0}',	0.2,	2),
('1,3',	'{1,1,1,1}:{1,0,1,0}',	0.4,	2),
('2,3',	'{1,2,1}:{0,1,0}',	0.2,	2),
('1,2,3',	'{3,1}:{1,0}',	0.2,	3);

             INSERT INTO assoc_rules_aux_tmp
                (pre, post, support, confidence, lift, conviction)
             SELECT
                t.item[1],
                t.item[2],
                t.support_xy,
                t.support_xy / x.support,
                t.support_xy / (x.support * y.support),
                CASE WHEN abs(t.support_xy / x.support - 1) < 1.0E-10 THEN
                    0
                ELSE
                    (1 - y.support) / (1 - (t.support_xy / x.support))
                END
            FROM (
                SELECT
                    madlib.gen_rules_from_cfp(text_svec, iteration) as item,
                    support as support_xy
                FROM assoc_rule_sets
                WHERE iteration > 1
            ) t, assoc_rule_sets x, assoc_rule_sets y
            WHERE t.item[1] = x.text_svec AND
                  t.item[2] = y.text_svec AND
                  (t.support_xy / x.support) >= 0.5;


create or replace function test()
returns void as $$
    import plpy
    plpy.execute(
    """
    DROP TABLE IF EXISTS assoc_rule_sets CASCADE;
    CREATE temp TABLE assoc_rule_sets
            (
            text_svec   TEXT,
            set_list madlib.svec,
            support     FLOAT8,
            iteration   INT
            )
DISTRIBUTED BY (text_svec); 
    """)

    plpy.execute(
    """
    DROP TABLE IF EXISTS assoc_rules_aux_tmp CASCADE;
CREATE temp TABLE assoc_rules_aux_tmp
    (
    ruleId      SERIAL,
    pre         TEXT,
    post        TEXT,
    support     FLOAT8,
    confidence  FLOAT8,
    lift        FLOAT8,
    conviction  FLOAT8
)
DISTRIBUTED BY (ruleId);
    """)

    plpy.execute(
    """
    insert into assoc_rule_sets values
('1',	'{1,3}:{1,0}',	0.6,	1),
('2',	'{1,1,2}:{0,1,0}',	0.4,	1),
('3',	'{2,1,1}:{0,1,0}',	0.4,	1),
('4',	'{3,1}:{0,1}',	0.2,	1),
('1,2',	'{2,2}:{1,0}',	0.2,	2),
('1,3',	'{1,1,1,1}:{1,0,1,0}',	0.4,	2),
('2,3',	'{1,2,1}:{0,1,0}',	0.2,	2),
('1,2,3',	'{3,1}:{1,0}',	0.2,	3);
    """)

    plpy.execute(
    """
             INSERT INTO assoc_rules_aux_tmp
                (pre, post, support, confidence, lift, conviction)
             SELECT
                t.item[1],
                t.item[2],
                t.support_xy,
                t.support_xy / x.support,
                t.support_xy / (x.support * y.support),
                CASE WHEN abs(t.support_xy / x.support - 1) < 1.0E-10 THEN
                    0
                ELSE
                    (1 - y.support) / (1 - (t.support_xy / x.support))
                END
            FROM (
                SELECT
                    madlib.gen_rules_from_cfp(text_svec, iteration) as item,
                    support as support_xy
                FROM assoc_rule_sets
                WHERE iteration > 1
            ) t, assoc_rule_sets x, assoc_rule_sets y
            WHERE t.item[1] = x.text_svec AND
                  t.item[2] = y.text_svec AND
                  (t.support_xy / x.support) >= 0.5;

    """)

    return None
$$ language plpythonu;

select test();
