CREATE TABLE kmeans_2d(
	id SERIAL,
	x DOUBLE PRECISION,
	y DOUBLE PRECISION,
	position DOUBLE PRECISION[]
);

INSERT INTO kmeans_2d(x, y, position)
SELECT
	x, y,
	ARRAY[
		x + random() * 15.0,
		y + random() * 15.0
	]::DOUBLE PRECISION[] AS position
FROM (
	SELECT
		random() * 100.0 AS x,
		random() * 100.0 AS y
	FROM generate_series(1,10)
) AS centroids, generate_series(1,100) i;

CREATE TABLE centroids AS
SELECT position
FROM kmeans_2d
ORDER BY random()
LIMIT 10;


SELECT * FROM madlib.kmeanspp('kmeans_2d', 'position', 10);




select madlib.__filter_input_relation('kmeans_2d', 'position');

\d _madlib_kmeans_2d_filtered

select array[madlib.weighted_sample(_src.position::float8[], 1)] from _madlib_kmeans_2d_filtered as _src;











select 0 as _iteration, madlib.__array_to_1d((select array[madlib.weighted_sample(_src.position::float8[], 1)] from _madlib_kmeans_2d_filtered as _src)) as _state;


SELECT
    0 AS _iteration,
    madlib.__array_to_1d((
    SELECT
        ARRAY[madlib.weighted_sample(_src.position::FLOAT8[], 1)]
    FROM _madlib_kmeans_2d_filtered AS _src
    )) AS _state;

select 0 as _iteration, madlib.__array_to_1d(a) as _state from (select array[madlib.weighted_sample(_src.position::float8[], 1)] as a from _madlib_kmeans_2d_filtered as _src) s;
