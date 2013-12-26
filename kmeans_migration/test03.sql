SELECT madlib.simple_silhouette(
    'madlibtestdata.km_rgenerated3'                      -- rel_source
    , 'point'                      -- expr_point
    , (madlib.kmeans_random(
        'madlibtestdata.km_rgenerated3'              -- rel_source
        , 'point'              -- expr_point
    , 3
    ) ).centroids::FLOAT8[][]
) AS simple_silhouette;

SELECT madlib.simple_silhouette(
        'madlibtestdata.km_rgenerated3'                      -- rel_source
        , 'point'                      -- expr_point
        , (madlib.kmeans_random(
            'madlibtestdata.km_rgenerated3'              -- rel_source
        , 'point'              -- expr_point
        , 3
        , 'madlib.squared_dist_norm2'          -- fn_dist_kmeans
        ) ).centroids::FLOAT8[][]
        , 'madlibtestdata.dist_norm4'              -- fn_dist_silhouette
) AS simple_silhouette;

SELECT madlib.simple_silhouette(
    'madlibtestdata.km_rgenerated3'                      -- rel_source
, 'point'                      -- expr_point
, (madlib.kmeans_random(
    'madlibtestdata.km_rgenerated3'              -- rel_source
, 'point'              -- expr_point
, 3
, 'madlib.squared_dist_norm2'          -- fn_dist_kmeans
, 'madlib.avg'            -- agg_centroid
) ).centroids::FLOAT8[][]
, 'madlibtestdata.dist_norm4'              -- fn_dist_silhouette
) AS simple_silhouette;

SELECT madlib.simple_silhouette(
    'madlibtestdata.km_rgenerated3'                      -- rel_source
, 'point'                      -- expr_point
, (madlib.kmeans_random(
    'madlibtestdata.km_rgenerated3'              -- rel_source
, 'point'              -- expr_point
, 3
, 'madlib.squared_dist_norm2'          -- fn_dist_kmeans
, 'madlib.avg'            -- agg_centroid
, 20
) ).centroids::FLOAT8[][]
, 'madlibtestdata.dist_norm4'              -- fn_dist_silhouette
) AS simple_silhouette;

SELECT madlib.simple_silhouette(
    'madlibtestdata.km_rgenerated3'                      -- rel_source
, 'point'                      -- expr_point
, (madlib.kmeans_random(
    'madlibtestdata.km_rgenerated3'              -- rel_source
, 'point'              -- expr_point
, 3
, 'madlib.squared_dist_norm2'          -- fn_dist_kmeans
, 'madlib.avg'            -- agg_centroid
, 20
, 0.001
) ).centroids::FLOAT8[][]
, 'madlibtestdata.dist_norm4'              -- fn_dist_silhouette
) AS simple_silhouette;

CREATE TABLE madlibtestresult.centroids AS
SELECT madlib.kmeans_random(
    'madlibtestdata.km_rgenerated3'              -- rel_source
, 'point'              -- expr_point
, 3
, 'madlibtestdata.madlib.squared_dist_norm2'          -- fn_dist_kmeans
, 'madlibtestdata.madlib.avg'            -- agg_centroid
, 20
, 0.001
) AS t;

----------------------------------------------------------------------
-- kmeans bug

drop table if exists tk;
create table tk (id integer, tfidf madlib.svec);
insert into tk values
    (1, '{1}:{0}'), (2, '{1}:{0}'), (3, '{1}:{0}'), (4, '{1}:{0}'), (5, '{1}:{0}');

select * from tk;

select array_upper(centroids,1) from madlib.kmeanspp('tk', 'tfidf', 2, 'madlib.dist_angle ', 'madlib.avg', 2, 0.01);

select array_upper(centroids,1) from madlib.kmeanspp('tk','tfidf',4, 'madlib.dist_angle ', 'madlib.avg' , 2, 0.01);


select avg(0 + (1) * (6.23304002945014 * madlib_temp_91405203_1387842927_16764882 * (1 - madlib_temp_91405203_1387842927_16764882))) as __madlib_temp_81103758_1387842927_9079041__,avg(0 + ((1) * (6.23304002945014 * (1 - madlib_temp_91405203_1387842927_16764882) - 6.23304002945014 * madlib_temp_91405203_1387842927_16764882)) * (madlib_temp_91405203_1387842927_16764882 * (1 - madlib_temp_91405203_1387842927_16764882))) as __madlib_temp_85467644_1387842927_20360623__,avg((1) * (madlib_temp_91405203_1387842927_16764882 * (1 - madlib_temp_91405203_1387842927_16764882)) + ((1) * (6.23304002945014 * (1 - madlib_temp_91405203_1387842927_16764882) - 6.23304002945014 * madlib_temp_91405203_1387842927_16764882)) * (length * madlib_temp_91405203_1387842927_16764882 * (1 - madlib_temp_91405203_1387842927_16764882))) as __madlib_temp_73306084_1387842927_68333415__,avg(0 + ((1) * (6.23304002945014 * (1 - madlib_temp_91405203_1387842927_16764882) - 6.23304002945014 * madlib_temp_91405203_1387842927_16764882)) * (diameter * madlib_temp_91405203_1387842927_16764882 * (1 - madlib_temp_91405203_1387842927_16764882))) as __madlib_temp_88137432_1387842927_65781447__ from (select id as id, sex as sex, length as length, diameter as diameter, height as height, whole as whole, shucked as shucked, viscera as viscera, shell as shell, rings as rings, 1/(1+exp(-(6.04570032767213+6.23304002945014*length+-22.59481282658*diameter))) as madlib_temp_91405203_1387842927_16764882 from madlibtestdata.dt_abalone) s;
