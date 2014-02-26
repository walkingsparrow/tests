-- huge lamda making all coef to be zeroes
drop table if exists house_en;
select madlib.elastic_net_train(
    'madlibtestdata.lin_housing_wi',
    'house_en',
    'y',
    'x',
    'gaussian',
    1,
    1e300,
    True,
    NULL,
    'fista',
    '{eta = 2, max_stepsize = 0.5, use_active_set = f}',
    NULL,
    2000,
    1e-6
);

select * from house_en;

select *, y - predict AS residual FROM (
    SELECT
        lin_housing_wi.*,
        madlib.elastic_net_predict( 'gaussian',
                                    m.coef_nonzero,
                                    m.intercept,
                                    x
                                  )
                                  AS predict
    FROM lin_housing_wi, house_en m) s;
