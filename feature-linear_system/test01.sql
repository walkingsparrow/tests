-- test linear system

select madlib.linear_solver_sparse('usage');

select madlib.matrix_sparsify('s_dm', 's_sm', False);

create table s_sm1 as select * from s_sm where value is not NULL;

drop table if exists out_sm;
select madlib.linear_solver_sparse('s_sm1', 'y_sm', 'out_sm', 'row_id', 'col_id', 'value', 'row_id', 'val', 8, NULL, 'direct', 'algorithm = ldlt');
