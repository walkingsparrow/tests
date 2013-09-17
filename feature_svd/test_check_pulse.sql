
DROP TABLE IF EXISTS leukemia;
CREATE TABLE leukemia (
    id INTEGER NOT NULL,
    grp DOUBLE PRECISION,
    wbc DOUBLE PRECISION,
    timedeath INTEGER,
    status BOOLEAN,
    CONSTRAINT pk_leukemia PRIMARY key (id)
);


INSERT INTO leukemia(id, grp, wbc, timedeath,status) VALUES
(0,0,1.45,35,TRUE),
(1,0,1.47,34,TRUE),
(3,0,2.2,32,TRUE),
(4,0,1.78,25,TRUE),
(5,0,2.57,23,TRUE),
(6,0,2.32,22,TRUE),
(7,0,2.01,20,TRUE),
(8,0,2.05,19,TRUE),
(9,0,2.16,17,TRUE),
(10,0,3.6,16,TRUE),
(11,1,2.3,15,TRUE),
(12,0,2.88,13,TRUE),
(13,1,1.5,12,TRUE),
(14,0,2.6,11,TRUE),
(15,0,2.7,10,TRUE),
(16,0,2.8,9,TRUE),
(17,1,2.32,8,TRUE),
(18,0,4.43,7,TRUE),
(19,0,2.31,6,TRUE),
(20,1,3.49,5,TRUE),
(21,1,2.42,4,TRUE),
(22,1,4.01,3,TRUE),
(23,1,4.91,2,TRUE),
(24,1,5,1,TRUE);


SELECT assert(
    relative_error(coef, ARRAY[2.5444, 1.6718]) < 1e-2 AND
    relative_error(loglikelihood, -37.8532) < 1e-2 AND
    relative_error(std_err, ARRAY[0.6773,0.3873]) < 1e-2 AND
    relative_error(z_stats, ARRAY[3.7567,4.3165]) < 1e-2 AND
    relative_error(p_values, ARRAY[0.000172,0.00001584]) < 1e-2,  
    'Cox-Proportional hazards (unique time of death): Wrong results'
) FROM (
		SELECT (madlib.cox_prop_hazards_regr(
    'leukemia', 'ARRAY[grp, wbc]', 'timedeath', 'status', NULL, 20, 'newton',  0.001
		)).*
) q;

DROP TABLE IF EXISTS tmp_out;
SELECT cox_prop_hazards('leukemia', 'tmp_out', 'timedeath', 'ARRAY[grp, wbc]', 'status');
SELECT * from tmp_out;

DROP TABLE IF EXISTS leukemia;
CREATE TABLE leukemia (
    id INTEGER NOT NULL,
    grp DOUBLE PRECISION,
    wbc DOUBLE PRECISION,
    timedeath INTEGER,
    status BOOLEAN,
    CONSTRAINT pk_leukemia PRIMARY key (id)
);

INSERT INTO leukemia(id, grp, wbc, timedeath, status) VALUES
(1,0,1.45,35,TRUE),
(2,0,1.47,34,TRUE),
(3,0,2.2,32,TRUE),
(4,0,2.53,32,TRUE),
(5,0,1.78,25,TRUE),
(6,0,2.57,23,TRUE),
(7,0,2.32,22,TRUE),
(8,0,2.01,20,TRUE),
(9,0,2.05,19,TRUE),
(10,0,2.16,17,TRUE),
(11,0,3.6,16,TRUE),
(12,0,2.88,13,TRUE),
(13,0,2.6,11,TRUE),
(14,0,2.7,10,TRUE),
(15,0,2.96,10,TRUE),
(16,0,2.8,9,TRUE),
(17,0,4.43,7,TRUE),
(18,0,3.2,6,TRUE),
(19,0,2.31,6,TRUE),
(20,0,4.06,6,TRUE),
(21,0,3.28,6,TRUE),
(22,1,1.97,23,TRUE),
(23,1,2.73,22,TRUE),
(24,1,2.95,17,TRUE),
(25,1,2.3,15,TRUE),
(26,1,1.5,12,TRUE),
(27,1,3.06,12,TRUE),
(28,1,3.49,11,TRUE),
(29,1,2.12,11,TRUE),
(30,1,3.52,8,TRUE),
(31,1,3.05,8,TRUE),
(32,1,2.32,8,TRUE),
(33,1,3.26,8,TRUE),
(34,1,3.49,5,TRUE),
(35,1,3.97,5,TRUE),
(36,1,4.36,4,TRUE),
(37,1,2.42,4,TRUE),
(38,1,4.01,3,TRUE),
(39,1,4.91,2,TRUE),
(40,1,4.48,2,TRUE),
(41,1,2.8,1,TRUE),
(42,1,5,1,TRUE);

-- Values computed with Madlib
SELECT assert(
    relative_error(coef, ARRAY[0.6987, 1.4148]) < 1e-2 AND
    relative_error(loglikelihood, -100.5537) < 1e-2 AND
    relative_error(std_err, ARRAY[0.3483,0.2743]) < 1e-2 AND
    relative_error(z_stats, ARRAY[2.0057,5.1563]) < 1e-2 AND
    relative_error(p_values, ARRAY[0.0448,0.000000025185]) < 1e-2,  
    'Cox-Proportional hazards (tied times of death): Wrong results'
) FROM (
		SELECT (cox_prop_hazards_regr(
    'leukemia', 'ARRAY[grp, wbc]', 'timedeath', 'status', NULL::VARCHAR, 20, 'newton',  0.001
		)).*
) q;

----------------------------------------------------------------------

SELECT assert(
    relative_error(coef, ARRAY[0.6987, 1.4148]) < 1e-2 AND
    relative_error(loglikelihood, -100.5537) < 1e-2 AND
    relative_error(std_err, ARRAY[0.3483,0.2743]) < 1e-2 AND
    relative_error(z_stats, ARRAY[2.0057,5.1563]) < 1e-2 AND
    relative_error(p_values, ARRAY[0.0448,0.000000025185]) < 1e-2,  
    'Cox-Proportional hazards (tied times of death): Wrong results'
) FROM (
		SELECT (cox_prop_hazards_regr(
    'leukemia', 'ARRAY[grp, wbc]', 'timedeath', 'id < 20', 'status', 20, 'newton',  0.001
		)).*
) q;

----------------------------------------------------------------------
----------------------------------------------------------------------

select madlib.svd_sparse_native(
        'madlibtestdata.pca_smat_100_100',
        '__madlib_temp_92380672_1378949382_11528838__',
        'row_id',
        'col_id',
        'value',
        100,
        100,
        10
    );


select * from __madlib_temp_92380672_1378949382_11528838___u order by row_id;

select * from __madlib_temp_92380672_1378949382_11528838___s order by row_id;
