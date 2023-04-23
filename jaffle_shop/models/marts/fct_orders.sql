with orders as (
	select * from analytics.stg_orders
),

payments as (
	select * from analytics.stg_payments
),

payment_totals as (
	select 
		order_id,
		sum(case when status ='success' then amount end) as amount
	from payments
	group by order_id
),

final as (
	select 
		orders.order_id,
		orders.customer_id,
		coalesce(payment_totals.amount, 0) as amount
	from orders
	left join payment_totals using (order_id)
)

select * from final