-- test kmeans

\timing

select madlib.kmeanspp('kmeans', 'point', 3);
