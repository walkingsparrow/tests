DROP TABLE IF EXISTS dictionary_tbl, train_feature_tbl, train_featureset_tbl;
SELECT * FROM
    madlib.crf_train_fgen(
        'madlibtestdata.train_seg_tbl',
        'madlibtestdata.regex_tbl',
        'madlibtestdata.label_tbl',
        'dictionary_tbl',
        'train_feature_tbl',
        'train_featureset_tbl'
    );

select * from dictionary_tbl limit 10;
select * from train_feature_tbl limit 10;

select * from train_featureset_tbl limit 10;


SELECT count(*) AS dict_size FROM dictionary_tbl;

SELECT count(*) AS feature_tbl_size FROM train_feature_tbl;

SELECT count(*) AS featureset_tbl_size FROM train_featureset_tbl;

DROP TABLE IF EXISTS crf_stats_tbl, crf_weights_tbl;
SELECT * FROM
    madlib.lincrf_train(
        'train_feature_tbl',
        'train_featureset_tbl',
        'madlibtestdata.label_tbl',
        'crf_stats_tbl',
        'crf_weights_tbl',
        5
    );

SELECT sum(abs(t.weight-q.weight)) AS divergence
FROM crf_weights_tbl t, madlibtestdata.expected_weights q
WHERE t.name = q.f_name AND
    t.prev_label_id = q.prev_label_id AND
    t.label_id = q.label_id;

DROP TABLE IF EXISTS viterbi_mtbl, viterbi_rtbl;
SELECT * FROM
    madlib.crf_test_fgen(
        'madlibtestdata.test_seg_tbl',
        'dictionary_tbl',
        'madlibtestdata.label_tbl',
        'madlibtestdata.regex_tbl',
        'crf_weights_tbl',
        'viterbi_mtbl',
        'viterbi_rtbl'
    );

DROP TABLE IF EXISTS result_tbl;
SELECT * FROM
    madlib.vcrf_label(
        'madlibtestdata.test_seg_tbl',
        'viterbi_mtbl',
        'viterbi_rtbl',
        'madlibtestdata.label_tbl',
        'result_tbl'
    );

SELECT count(*) AS matching_labels
FROM result_tbl t, madlibtestdata.expected_labels q
WHERE t.doc_id = q.doc_id AND t.start_pos = q.start_pos
AND t.label = q.label;

select count(*) from result_tbl;

----------------------------------------------------------------------

select * from result_tbl order by doc_id, start_pos limit 40;

select s.doc_id, s.start_pos, s.seg_text, t.label from madlibtestdata.train_seg_tbl s join madlibtestdata.label_tbl t on s.label = t.id limit 40;

copy (
    select s.seg_text, t.label
    from
        madlibtestdata.train_seg_tbl s
        join
        madlibtestdata.label_tbl t
        on s.label = t.id
    order by s.doc_id, s.start_pos)
to '/Users/qianh1/workspace/tests/test-crf/train_txt_label.csv' with csv delimiter E'\t';

select * from madlibtestdata.label_tbl order by id;

select * from madlibtestdata.regex_tbl;

select * from madlibtestdata.train_seg_tbl order by doc_id, start_pos limit 40;

select * from dictionary_tbl limit 10;
