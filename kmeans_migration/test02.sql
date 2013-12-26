SELECT array_upper(t.kmeanspp_seeding, 1) AS num_centroids FROM
(SELECT madlib.kmeanspp_seeding(
    'madlibtestdata.km_rgenerated3'            -- rel_source
, 'point'            -- expr_point
, 3
) ) AS t;

SELECT array_upper(t.kmeanspp_seeding, 1) AS num_centroids FROM
(SELECT madlib.kmeanspp_seeding(
    'madlibtestdata.km_rgenerated3'            -- rel_source
, 'point'            -- expr_point
, 3
, 'madlib.squared_dist_norm2'               -- fn_dist
) ) AS t;

SELECT array_upper(t.kmeanspp_seeding, 1) AS num_centroids FROM
(SELECT madlib.kmeanspp_seeding(
    'madlibtestdata.km_rgenerated3'            -- rel_source
, 'point'            -- expr_point
, 3
, 'madlib.squared_dist_norm2'               -- fn_dist
, ARRAY[ARRAY[4,1],ARRAY[6,1],ARRAY[4,9]]     -- initial_centroids
) ) AS t;

SELECT array_upper(t.kmeans_random_seeding, 1) AS num_centroids FROM
(SELECT madlib.kmeans_random_seeding(
    'madlibtestdata.km_rgenerated3'            -- rel_source
, 'point'            -- expr_point
, 3
) ) AS t;

SELECT array_upper(t.kmeans_random_seeding, 1) AS num_centroids FROM
(SELECT madlib.kmeans_random_seeding(
    'madlibtestdata.km_rgenerated3'            -- rel_source
, 'point'            -- expr_point
, 3
, 'ARRAY[ARRAY[4,1,2,0,0,1,3,2,2,0,0,3,0,3,3,0,1,0,0,0,0,0,0,1,4,0,2,0,2,0,1,4,1,2,2,0,2,0,2,1,2,2,0,0,0,1,1,0,2,10,0,4,0,1,0,1,0,0,0,1,0,1,1,1,0,10,1,0],ARRAY[6,1,1,0,0,3,3,2,2,0,0,0,0,3,3,0,3,0,0,1,0,0,0,0,9,1,2,0,0,0,1,2,1,2,1,0,2,0,2,2,0,4,0,0,0,2,1,0,4,10,0,1,8,1,0,0,0,0,0,1,0,2,1,1,0,14,1,1],ARRAY[4,9,1,0,4,1,4,2,2,1,0,3,0,1,1,3,1,0,0,0,0,0,0,0,8,0,1,0,0,0,1,4,2,2,2,0,2,3,2,1,2,2,1,0,0,1,1,0,2,52,0,1,0,2,0,1,0,0,0,3,0,1,1,1,0,14,1,0]]'     -- initial_centroids
) ) AS t;
