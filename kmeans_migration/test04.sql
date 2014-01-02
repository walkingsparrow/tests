
select madlib.kmeans(
        'madlibtestdata.km_rgenerated3_1e4',
        'point',
        array[array[1,NaN],array[0,1.],array[1.,0.]]::float8[][], 20, 0.001);

select madlib.kmeans(
        NULL,
        'point',
        array[array[1,1.],array[0,1.],array[1.,0.]],
        'madlib.squared_dist_norm2', 'madlib.avg', 20, 0.001);

select (f).* from (select madlib.kmeans(
        'madlibtestdata.km_test_float_nonfinite_two_rows',
        'position',
        array[array[1,1,1.],array[0,1.,0.5]]) as f) s;

----------------------------------------------------------------------

select madlib.simple_silhouette(
    'madlibtestdata.km_test_float_nonfinite_two_rows',
    'position',
    (madlib.kmeans(
        'madlibtestdata.km_test_float_nonfinite_two_rows',
        'position',
        array[array[1,1,1.],array[0,1.,0.5]])).centroids::double precision[][],
    'madlib.dist_norm2'
);
        
----------------------------------------------------------------------

select madlib.simple_silhouette(
    'madlibtestdata.km_rgenerated3_1e4',
    'point',
    (madlib.kmeans(
        'madlibtestdata.km_rgenerated3_1e4',
        'point',
        array[array[1,1.],array[0,1.],array[1.,0.]],
        'madlib.dist_norm2',
        'madlib.avg',
        100,
        0.001)).centroids::double precision[][],
    'madlib.dist_norm2'
);

----------------------------------------------------------------------

select madlib.simple_silhouette(
    'madlibtestdata.km_rgenerated3_1e4',
    'point',
    (madlib.kmeanspp(
        'madlibtestdata.km_rgenerated3_1e4',
        'point',
        3,
        'madlib.dist_norm2',
        'madlib.avg',
        100,
        0.001)).centroids::double precision[][],
    'madlib.dist_norm2'
);


----------------------------------------------------------------------
        \x on
        SELECT madlib.simple_silhouette(
            'madlibtestdata.km_rgenerated3_1e4'                      -- rel_source
        , 'point'                      -- expr_point
        , (madlib.kmeans(
            'madlibtestdata.km_rgenerated3_1e4'              -- rel_source
        , 'point'              -- expr_point
        , array[array[1,1],array[1,0],array[0,1]]       -- initial_centroids
        ) ).centroids::FLOAT8[][]
        ) AS simple_silhouette;

        SELECT madlib.simple_silhouette(
            'madlibtestdata.km_rgenerated3_1e4'                      -- rel_source
        , 'point'                      -- expr_point
        , (madlib.kmeans(
            'madlibtestdata.km_rgenerated3_1e4'              -- rel_source
        , 'point'              -- expr_point
        , array[array[1,1],array[1,0],array[0,1]]       -- initial_centroids
        , 'madlib.dist_norm2'          -- fn_dist_kmeans
        ) ).centroids::FLOAT8[][]
        , 'madlib.dist_tanimoto'              -- fn_dist_silhouette
        ) AS simple_silhouette;

        SELECT madlib.simple_silhouette(
            'madlibtestdata.km_rgenerated3_1e4'                      -- rel_source
        , 'point'                      -- expr_point
        , (madlib.kmeans(
            'madlibtestdata.km_rgenerated3_1e4'              -- rel_source
        , 'point'              -- expr_point
        , array[array[1,1],array[1,0],array[0,1]]       -- initial_centroids
        , 'madlib.dist_norm2'          -- fn_dist_kmeans
        , 'madlibtestdata.array_avg_agg'            -- agg_centroid
        ) ).centroids::FLOAT8[][]
        , 'madlib.dist_tanimoto'              -- fn_dist_silhouette
        ) AS simple_silhouette;

        SELECT madlib.simple_silhouette(
            'madlibtestdata.km_rgenerated3_1e4'                      -- rel_source
        , 'point'                      -- expr_point
        , (madlib.kmeans(
            'madlibtestdata.km_rgenerated3_1e4'              -- rel_source
        , 'point'              -- expr_point
        , array[array[1,1],array[1,0],array[0,1]]       -- initial_centroids
        , 'madlib.dist_norm2'          -- fn_dist_kmeans
        , 'madlibtestdata.array_avg_agg'            -- agg_centroid
        , 50
        ) ).centroids::FLOAT8[][]
        , 'madlib.dist_tanimoto'              -- fn_dist_silhouette
        ) AS simple_silhouette;

        SELECT madlib.simple_silhouette(
            'madlibtestdata.km_rgenerated3_1e4'                      -- rel_source
        , 'point'                      -- expr_point
        , (madlib.kmeans(
            'madlibtestdata.km_rgenerated3_1e4'              -- rel_source
        , 'point'              -- expr_point
        , array[array[1,1],array[1,0],array[0,1]]       -- initial_centroids
        , 'madlib.dist_norm2'          -- fn_dist_kmeans
        , 'madlibtestdata.array_avg_agg'            -- agg_centroid
        , 50
        , 0.001
        ) ).centroids::FLOAT8[][]
        , 'madlib.dist_tanimoto'              -- fn_dist_silhouette
        ) AS simple_silhouette;
        \x off
