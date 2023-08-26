drop table if exists public.shipping_datamart;
create table public.shipping_datamart(
  shipping_id BIGINT,
  vendor_id BIGINT,
  transfer_type text,
  full_day_at_shipping  integer,
  is_delay boolean,
  is_shipping_finish boolean,
  delay_day_at_shipping  integer,
  payment_amount  NUMERIC(14,2),
  vat NUMERIC(14,2),
  profit NUMERIC(14,2),
  PRIMARY KEY (shipping_id)
);
insert into public.shipping_datamart( shipping_id,
                                     vendor_id,
									 transfer_type,
                                     full_day_at_shipping,
                                     is_delay,
                                     is_shipping_finish,
                                    delay_day_at_shipping,
                                     payment_amount,
                                     vat,
                                    profit)
select
ss.shipping_id,
si.vendor_id,
si.transfer_type,
extract(day from ss.shipping_end_fact_datetime - ss.shipping_start_fact_datetime)::int as full_day_at_shipping,
case when ss.shipping_end_fact_datetime>si.shipping_plan_datetime then 1::bool
else 0::bool
end as is_delay,
case when ss.status = 'finished' then 1::bool
else 0::bool
end as is_shipping_finish,
case when ss.shipping_end_fact_datetime > si.shipping_plan_datetime
then extract(day from ss.shipping_end_fact_datetime - si.shipping_plan_datetime)::int
else 0
end as delay_day_at_shipping,
si.payment_amount,
si.payment_amount * (si.shipping_country_base_rate + si.agreement_rate + si.shipping_transfer_rate) as vat,
si.payment_amount * si.agreement_commission as profit
from public.shipping_status ss
left join (select * from public.shipping_info si
		   left join public.shipping_transfer st on si.shipping_transfer_id=st.id
		   left join public.shipping_country_rates scr  on si.shipping_country_rate_id=scr.id
		   left join public.shipping_agreement sa on si.shipping_agreement_id=sa.agreement_id
		  ) si on ss.shipping_id=si.shipping_id
