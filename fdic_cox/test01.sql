select madlib.clustered_coxph('?');

create table ris as select * from madlibtestdata.fdic;

drop table if exists dcp.test_surv;
create table dcp.test_surv as
select a.cert,call_year,
(avg(1e0+DRRELOC)-avg(1e0+CRRELOC))/avg(1e0+LNRELOC) as ELOC_CO_Net_Recov_Pct,
(avg(1e0+DRRERSFM)-avg(1e0+CRRERSFM))/avg(1e0+LNRERSFM) as SFM_CO_Net_Recov_Pct,
(avg(1e0+DRRERSF2)-avg(1e0+CRRERSF2))/avg(1e0+LNRERSF2) as SF2_CO_Net_Recov_Pct,
(avg(1e0+DRREMULT)-avg(1e0+CRREMULT))/avg(1e0+lNREMULT) as Mult_CO_Net_Recov_Pct,
avg(1e0+sf_mrtg_pct_assets) sf_mrtg_pct_assets,
avg(1e0+LNREFNAC)/avg(1e0+LNRE) as Neg_Amort_Pct,
avg(1e0+LNREFMFC)/avg(1e0+LNRE) as FOR_SFM_Pct,
max(time) time,
MAX(call_year) max_year,
call_stalp,
case when not exists (select 1 from ris c where c.CERT=a.CERT and c.call_year>a.call_year) then 1 else 0 end Status
from ris a, (select cert,max(call_year)-min(call_year)  time from ris b group by 1) b where b.cert=a.cert
and
exists (select 1 from ris b where a.CERT=b.CERT and b.call_year=2004)
and exists (select 1 from ris b where a.CERT=b.CERT and b.call_year=2005)
and exists (select 1 from ris b where a.CERT=b.CERT and b.call_year=2006)
and exists (select 1 from ris b where a.CERT=b.CERT and b.call_year=2007)
and exists (select 1 from ris b where a.CERT=b.CERT and b.call_year=2008)
and exists (select 1 from ris b where a.CERT=b.CERT and b.call_year=2009)
and DRRELOC is not null
and CRRELOC is not null
and LNRELOC is not null
and DRRERSFM is not null
and CRRERSFM is not null
and LNRERSFM is not null
and DRRERSF2 is not null
and CRRERSF2 is not null
and LNRERSF2 is not null
and DRREMULT is not null
and CRREMULT is not null
and lNREMULT is not null
and sf_mrtg_pct_assets is not null
and LNREFNAC is not null
and LNRE is not null
and LNREFMFC is not null
group by a.CERT,call_year, call_stalp
distributed randomly;

select madlib.coxph_train('?');

drop table dcp.surv_output, dcp.surv_output_summary;
SELECT madlib.coxph_train('dcp.test_surv', 'dcp.surv_output', 'time', 'ARRAY[1,ELOC_CO_Net_Recov_Pct,SFM_CO_Net_Recov_Pct,SF2_CO_Net_Recov_Pct,Mult_CO_Net_Recov_Pct,sf_mrtg_pct_assets,Neg_Amort_Pct,FOR_SFM_Pct]');

drop table dcp.surv_output_clus;
select madlib.clustered_variance_coxph('dcp.surv_output','dcp.surv_output_clus','call_stalp');
