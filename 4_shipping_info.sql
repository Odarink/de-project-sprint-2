drop table if exists public.shipping_info;
create table public.shipping_info  (
  shipping_id BIGINT,
  vendor_id BIGINT,
  payment_amount NUMERIC(14,2),
  shipping_plan_datetime timestamp NULL,
  shipping_transfer_id BIGINT NULL,
  shipping_agreement_id BIGINT NULL,
  shipping_country_rate_id BIGINT NULL,
  PRIMARY KEY (shipping_id),
  FOREIGN KEY      (shipping_transfer_id) REFERENCES shipping_transfer (ID) ON UPDATE cascade,
  FOREIGN KEY      (shipping_agreement_id) REFERENCES shipping_agreement(agreement_id) ON UPDATE cascade,
  FOREIGN KEY      (shipping_country_rate_id) REFERENCES shipping_country_rates(ID) ON UPDATE cascade
);

insert into public.shipping_info(
  shipping_id,vendor_id,payment_amount,shipping_plan_datetime, shipping_transfer_id, shipping_agreement_id, shipping_country_rate_id)
select distinct * from (select
	shippingid as shipping_id,
	vendorid as vendor_id,
	payment_amount,
	shipping_plan_datetime,
	st.id as shipping_transfer_id,
	(regexp_split_to_array(vendor_agreement_description, ':+'))[1]::bigint as shipping_agreement_id,
	scr.id as  shipping_country_rate_id
from public.shipping s
left join public.shipping_transfer st on s.shipping_transfer_description = st.transfer_type || ':' || st.transfer_model
left join public.shipping_country_rates scr on s.shipping_country=scr.shipping_country) si;
