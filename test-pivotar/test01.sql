CREATE EXTERNAL TABLE credit (
age int,
job text, 
marital text, 
education text, 
deflt text,
balance float, 
housing text, 
loan text, 
contact text, 
day int, 
month text, 
duration int, 
campaign int, 
pdays int, 
previous int, 
poutcome text, 
y text)
LOCATION ('file:///Users/qianh1/workspace/tests/test-pivotar/bank-full.csv')
FORMAT 'CSV' (DELIMITER as ';' header);

select count(*) from external credit limit 10;

select madlib.linregr_train('credit', 'lin_out', 'age', 'array[1, balance]');


CREATE EXTERNAL TABLE credit (
age int,
job text, 
marital text, 
education text, 
deflt text,
balance float, 
housing text, 
loan text, 
contact text, 
day int, 
month text, 
duration int, 
campaign int, 
pdays int, 
previous int, 
poutcome text, 
y text)
LOCATION ('file:///Users/qianh1/workspace/tests/test-pivotar/bank-full.csv')
FORMAT 'CSV' (DELIMITER as ';' header);

----------------------------------------------------------------------

\d bank

select array_agg(distinct job) from bank;
