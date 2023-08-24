drop table if exists public.shipping_status;
create table public.shipping_status(
  shipping_id BIGINT,
  status text,
  state text,
  shipping_start_fact_datetime timestamp NULL,
  shipping_end_fact_datetime timestamp NULL,
  PRIMARY KEY (shipping_id)
);
with l_ship as (
  SELECT  ROW_NUMBER() OVER (partition by shippingid order BY state_datetime DESC) AS row_num,
  shippingid as shipping_id,
  status,
  state,
  state_datetime
  FROM shipping
),
v_start_fact_datetime  as (
  SELECT
  shippingid as shipping_id,
  state_datetime as shipping_start_fact_datetime
  FROM shipping
  where state='booked'
),
v_end_fact_datetime  as (
  SELECT
  shippingid as shipping_id,
  state_datetime as shipping_end_fact_datetime
  FROM shipping
  where state='recieved'
)
insert into public.shipping_status(shipping_id,status,state,shipping_start_fact_datetime,shipping_end_fact_datetime)
select
	l1.shipping_id,
	l1.status,
	l1.state,
	l2.shipping_start_fact_datetime,
	l3.shipping_end_fact_datetime
from l_ship l1
left join v_start_fact_datetime l2 on l1.shipping_id = l2.shipping_id
left join v_end_fact_datetime l3 on l1.shipping_id = l3.shipping_id
where row_num=1;