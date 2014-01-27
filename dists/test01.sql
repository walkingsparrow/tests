select madlib.chi_squared_pdf(1, 'NaN'::float8);

select madlib.chi_squared_pdf('Inf'::float8, 1);

select madlib.chi_squared_pdf('Nan'::float8, 2);

select madlib.chi_squared_pdf('Inf'::float8, 2);

select madlib.beta_cdf(1.2, 'Nan'::float8, 1);

select madlib.beta_cdf(1.2, 'Inf'::float8, 1);

select madlib.fisher_f_pdf(0, 'Inf'::float8, 1);

select madlib.fisher_f_pdf(0, 1e-1, 'Inf'::float8);

