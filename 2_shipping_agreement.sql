drop table if exists public.shipping_agreement;
create table public.shipping_agreement (
  agreement_id BIGINT,
  agreement_number text,
  agreement_rate NUMERIC(14,3),
  agreement_commission NUMERIC(14,3),
  primary key (agreement_id)
);
insert into public.shipping_agreement  (agreement_id,agreement_number,agreement_rate,agreement_commission)
SELECT distinct
	cast(vendor_agreement_list[1] as BIGINT) as agreement_id,
	cast(vendor_agreement_list[2] as text) as agreement_number,
	cast(vendor_agreement_list[3] as NUMERIC(14,3)) as agreement_rate,
	cast(vendor_agreement_list[4] as NUMERIC(14,3)) as agreement_commission
FROM
  (SELECT DISTINCT regexp_split_to_array(vendor_agreement_description, ':+') AS vendor_agreement_list
   FROM public.shipping) AS shipping;