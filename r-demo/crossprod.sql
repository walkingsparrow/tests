create or replace function crossprod (
    arr1    double precision[],
    arr2    double precision[]
) returns double precision[] as $$
    select array_agg(sq1.x * sq2.x)
    from
        (select unnest($1) as x) as sq1,
        (select unnest($2) as x) as sq2
$$ language sql IMMUTABLE;

----------------------------------------------------------------------

create or replace function crossprod1 (
    arr1    double precision[],
    arr2    double precision[]
) returns double precision[] as $$
    return [x*y for x in arr1 for y in arr2]
$$ language plpythonu IMMUTABLE;

----------------------------------------------------------------------

create or replace function crossprod2 (
    arr1    double precision[],
    arr2    double precision[]
) returns double precision[] as $$
    select sq1.x * sq2.x
    from
        (select unnest($1) as x) as sq1,
        (select unnest($2) as x) as sq2
$$ language sql IMMUTABLE;
