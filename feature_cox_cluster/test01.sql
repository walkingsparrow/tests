

select madlib.clustered_variance_coxph('model_table', 'output_table', 'cl1, cl2');

select * from output_table;

* coef
* loglikelihood
* std_err
* clustervar
* robust_se
* robust_z
* robust_p
* hessian
