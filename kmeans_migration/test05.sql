SELECT madlib.simple_silhouette(
    'madlibtestdata.km_rgenerated3_1e4'
    , 'point'                      -- expr_point
    , (madlib.kmeans(
        'madlibtestdata.km_rgenerated3_1e4'
    , 'point'              -- expr_point
    , array[array[1,1],array[1,0],array[0,1]]
    , 'madlib.dist_norm2'          -- fn_dist_kmeans
    , 'madlib.avg'            -- agg_centroid
    , 20
    , 0.001
    ) ).centroids::FLOAT8[][]
    , 'madlib.no_such_dist'              -- fn_dist_silhouette
    ) AS simple_silhouette;


select * from madlib.kmeans(
    'madlibtestdata.km_rgenerated3_1e4'
    , 'point'              -- expr_point
    , array[array[1,1],array[1,0],array[0,1]]
    , 'madlib.dist_norm2'          -- fn_dist_kmeans
    , 'madlib.avg'            -- agg_centroid
    , 20
    , 0.001);

select * from madlib.kmeans(
    'madlibtestdata.km_rgenerated3_1e4'
    , 'point'              -- expr_point
    , array[array[1,1],array[1,0],array[0,1]]);

select * from madlib.kmeanspp(
    'madlibtestdata.km_rgenerated3_1e4'
    , 'point'              -- expr_point
    , 3);
