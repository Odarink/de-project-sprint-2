drop table if exists public.shipping_country_rates;
create table public.shipping_country_rates(
  ID SERIAL,
  shipping_country text,
  shipping_country_base_rate NUMERIC(14,3),
  PRIMARY KEY (ID)
);
insert into public.shipping_country_rates(shipping_country,shipping_country_base_rate)
select distinct
	shipping_country,
	shipping_country_base_rate
from public.shipping;

select * from public.shipping_country_rates;