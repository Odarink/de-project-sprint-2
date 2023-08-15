drop table if exists public.shipping_transfer;
create table public.shipping_transfer  (
  ID SERIAL,
  transfer_type text,
  transfer_model text,
  shipping_transfer_rate  NUMERIC(14,3),
  PRIMARY KEY (ID)
);
insert into public.shipping_transfer  (transfer_type,transfer_model,shipping_transfer_rate)
SELECT distinct
	shipping_transfer_list[1] as transfer_type,
	shipping_transfer_list[2] as transfer_model,
	shipping_transfer_rate
FROM
  (SELECT DISTINCT
   regexp_split_to_array(shipping_transfer_description, ':+') AS shipping_transfer_list,
   shipping_transfer_rate
   FROM public.shipping) AS shipping;