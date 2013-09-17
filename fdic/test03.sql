drop table if exists dcp.logit_test1;

create table dcp.logit_test1 AS
select
    case when intmsrfv >0 then 1 else 0 end intmsrfv,
    array[1, sz100, sz100t1b , sz1bt10b, (0.00+lnauto)/ris_asset , (0.00+lncrcd/ris_asset) , (0.00+lncrcd/ris_asset) , (lnconoth+lnconrp+0.00)/ris_asset, (0.00+lnrenr1a + lnrenr2a + lnrenr3a)/ris_asset ] as x 
from dcp.ris where intmsrfv is not null
distributed randomly;

select * from madlib.logregr_train('dcp.logit_test1','dcp.logit_out', 'intmsrfv', 'array_nvl(x::numeric[], 0::numeric)');

