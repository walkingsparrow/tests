drop table if exists lin_out;
drop table if exists lintest;

create table lintest as select *,
    ((0.00+lnauto)/ris_asset)   autopct, (0.00+lncrcd)/ris_asset crdpct ,
    (0.00+lnconoth)/ris_asset commpct, (0.00+lnrenr1a + lnrenr2a + lnrenr3a)/ris_asset  mtgpct,
    case when intmsrfv >0 then 1 else 0 end mtg_srv
from madlibtestdata.fdic where
    ris_asset is not null and lncrcd is not null and lnauto is not null and lnconoth  is not null and lnconrp  is not null and
    intmsrfv  is not null and lnrenr1a  is not null and lnrenr2a  is not null and lnrenr3a  is not null and sz100 is not null and sz100t1b is not null and sz1bt10b is not null;

\d lintest

drop table if exists logit_out_clus;
SELECT * FROM madlib.clustered_variance_logregr( 'lintest', 'logit_out_clus', 'mtg_srv::boolean', 'ARRAY[1, sz100, sz100t1b , sz1bt10b, autopct, crdpct, commpct, mtgpct]','call_stalp');

select madlib.logregr_train('lintest', 'logout', 'mtg_srv', 'ARRAY[1, sz100, sz100t1b , sz1bt10b, autopct, crdpct, commpct, mtgpct]');

SELECT
madlib.linregr_train('lintest', 'lin_out','sf_mrtg_pct_assets', 'array[1, RIS_asset, LNCRCD, LNAUTO,LNCONOTH, LNCONRP, INTMSRFV, LNRENR1A, LNRENR2A, LNRENR3A]');

select * from lin_out;
