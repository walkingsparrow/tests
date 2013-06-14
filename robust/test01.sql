-- test robust

select madlib.version();

\df madlib.robust_variance*

select madlib.robust_variance();

\d madlibtestdata.lin_ornstein

\dt madlibtestdata.*

\d madlibtestdata.rf_abalone

\df madlib.linregr_train

select madlib.linregr_train('madlibtestdata.rf_abalone', 'tbl_out', 'rings', 'array[1, length, diameter, height]');

\x

select * from tbl_out;

select madlib.robust_variance('madlibtestdata.rf_abalone', 'tbl_robust', 'linear', 'rings', 'array[1, length, diameter, height]', coef) from tbl_out;

select madlib.robust_variance('madlibtestdata.rf_abalone', 'tbl_robust', 'linear', 'rings', 'array[1, length, diameter, height]', (select coef from tbl_out));

select * from tbl_robust;

------------------------------------------------------------------------

select madlib.linregr_train('madlibtestdata.rf_abalone', 'tbl_out', 'rings', 'array[1, log(length), diameter, height]');

select * from tbl_out;

select log(1.2);

select madlib.robust_variance('madlibtestdata.rf_abalone', 'tbl_robust', 'linear', 'rings', 'array[1, log(length), diameter, height]', coef) from tbl_out;

select * from tbl_robust;

------------------------------------------------------------------------

select madlib.linregr_train('madlibtestdata.rf_abalone', 'tbl_out', 'rings', 'array[1, log(length), exp(diameter), (height+1)/2.]');

select * from tbl_out;

select log(1.2);

select madlib.robust_variance('madlibtestdata.rf_abalone', 'tbl_robust', 'linear', 'rings', 'array[1, log(length), exp(diameter), (height+1)/2.]', coef) from tbl_out;

select * from tbl_robust;

------------------------------------------------------------------------

\df madlib.logregr_train

select madlib.logregr_train('madlibtestdata.rf_abalone', 'tbl_out', 'rings < 10', 'array[1, length, diameter, height]');

\x

select * from tbl_out;

select madlib.robust_variance('madlibtestdata.rf_abalone', 'tbl_robust', 'logistic', '(rings<10)::integer', 'array[1, log(length), diameter, height]', coef) from tbl_out;

select madlib.robust_variance('madlibtestdata.rf_abalone', 'tbl_robust', 'logistic', '(rings<10)::integer', 'array[1, log(length), diameter, height]', array[6.00511127110202,8.26183024082684,-16.52831469061,-25.2117307300432]);

-- cannot use coef
-- cannot use rings<10, must be (rings<10)::integer

------------------------------------------------------------------------

\d madlibtestdata.patie*

select madlib.robust_variance('patients', 'newTable', 'logistic', 'second_attack', 'ARRAY[1, treatment, trait_anxiety]', ARRAY[-6.36346994177327,-1.02410605238946,0.119044916668435]);

select * from patients;
