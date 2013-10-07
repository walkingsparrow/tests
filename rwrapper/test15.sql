create or replace function crossprod(
    x       double precision[]
) returns double precision[] as $$
    select array_agg(x*y)
    from
        (select unnest($1) as x) s1,
        (select unnest($1) as y) s2
$$ language sql;

select sum(crossprod(x)) from (select array[1.,2.,3.2]::double precision[] as x) s;

----------------------------------------------------------------------

create or replace function crossprod(
    x       double precision[]
) returns double precision[] as $$
    with s as (
        select unnest($1) as x
    )
    select array_agg(sq1.x*sq2.x)
    from
        s as sq1, s as sq2
$$ language sql;

select sum(crossprod(x)) from (select array[1.,2.,3.2]::double precision[] as x) s;
