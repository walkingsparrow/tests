
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
