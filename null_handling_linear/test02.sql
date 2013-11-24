-- test the new marginal code

select madlib.margins_logregr();

select madlib.margins_logregr('?');

drop table if exists log_out;
drop table if exists log_out_summary;
select madlib.logregr_train('madlibtestdata.log_breast_cancer_wisconsin', 'log_out', 'y', 'x');

\x on
select * from log_out;
select * from log_out_summary;
\x off

drop table if exists margin_out;
drop table if exists margin_out_summary;
select madlib.margins_logregr('madlibtestdata.log_breast_cancer_wisconsin', 'margin_out', 'y', 'x', NULL);

\x on
select * from margin_out;
select * from margin_out_summary;
\x off

----------------------------------------------------------------------

drop table if exists log_out;
drop table if exists log_out_summary;
select madlib.logregr_train('madlibtestdata.fdic_part_null_double_wi', 'log_out', 'z1', 'x');

\x on
select * from log_out;
select * from log_out_summary;
\x off

drop table if exists margin_out;
drop table if exists margin_out_summary;
select madlib.margins_logregr('madlibtestdata.fdic_part_null_double_wi', 'margin_out', 'z1', 'x');

\x on
select * from margin_out;
select * from margin_out_summary;
\x off

----------------------------------------------------------------------

drop table if exists madlibtestdata.fdic_all_null_grp;
create table madlibtestdata.fdic_all_null_grp as
    select
        z1 as y,
        case when z2 is False then
            NULL
        else
            x
        end as x,
        z2 as grp
    from madlibtestdata.fdic_part_null_double_wi;

drop table if exists madlibtestdata.fdic_all_null_grp_lin;
create table madlibtestdata.fdic_all_null_grp_lin as
    select
        y as y,
        case when z2 is False then
            NULL
        else
            x
        end as x,
        z2 as grp
    from madlibtestdata.fdic_part_null_double_wi;

