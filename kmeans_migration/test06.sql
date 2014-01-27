SELECT madlib.simple_silhouette(
    'madlibtestdata.km_abalone'                      -- rel_source
    , 'position'                      -- expr_point
    , (madlib.kmeanspp(
        'madlibtestdata.km_abalone'              -- rel_source
        , 'position'              -- expr_point
        , 6
        , 'madlib.dist_tanimoto'          -- fn_dist_kmeans
        , 'madlib.normalized_avg'            -- agg_centroid
        , 100, 0.001
    )).centroids::FLOAT8[][]
    , 'madlib.dist_tanimoto'              -- fn_dist_silhouette
) AS simple_silhouette2;


SELECT madlib.simple_silhouette(
    'madlibtestdata.km_rgenerated3_1e4'                      -- rel_source
    , 'point'                      -- expr_point
    , (madlib.kmeanspp(
        'madlibtestdata.km_rgenerated3_1e4'              -- rel_source
        , 'point'              -- expr_point
        , 3
        , 'madlib.dist_norm1'          -- fn_dist_kmeans
        , 'madlib.normalized_avg'            -- agg_centroid
        , 50, 0.001
    )).centroids::FLOAT8[][]
    , 'madlib.dist_norm1'              -- fn_dist_silhouette
) AS simple_silhouette2;
