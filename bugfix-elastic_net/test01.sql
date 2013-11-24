drop table if exists abalone1;
create table abalone1 as
    select *, (rings < 10)::integer as rings1
    from madlibtestdata.dt_abalone;

select madlib.elastic_net_train('usage');

drop table if exists el_out;
select madlib.elastic_net_train('abalone1', 'el_out', 'rings1', 'array[length,diameter,height,whole,shucked,viscera,shell]', 'binomial', 1, 0.1, TRUE, NULL, 'fista', '', NULL, 100, 1e-3);

\x on
select * from el_out;
\x off


----------------------------------------------------------------------

select madlib.cross_validation()
