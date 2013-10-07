drop table if exists log_out;
select madlib.logregr_train(
    'madlibtestdata.fdic_part_null_grp2',
    'log_out',
    'y', 'x', 'z1', 20, 'irls',
    '1e-05');

\x
select * from log_out;

drop table if exists pg_temp.__madlib_temp_18140662_1380326193_6384957__; 
create TEMPORARY table __madlib_temp_18140662_1380326193_6384957__ as (
    select
        distinct z1,
        0::integer as _iteration,
        Null::double precision[] as _state
    from madlibtestdata.fdic_part_null_grp    
);


alter table pg_temp.__madlib_temp_18140662_1380326193_6384957__
                set distributed by (_iteration , z1);
                
alter table pg_temp.__madlib_temp_18140662_1380326193_6384957__
                add primary key (_iteration , z1);

drop table if exists madlibtestdata.fdic_part_null_grp1;
create table madlibtestdata.fdic_part_null_grp1 as
    select y, x, z1::integer as z1, z2::integer as z2 from madlibtestdata.fdic_part_null_grp
    where z1 is not NULL and z2 is not NULL;


    CREATE CAST (BOOLEAN AS TEXT)
     WITH FUNCTION madlib.bool_to_text(BOOLEAN)
     AS ASSIGNMENT;
