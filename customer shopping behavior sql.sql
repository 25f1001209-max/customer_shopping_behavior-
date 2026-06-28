-- 1 which total revenue genrated by male vs females 
select gender ,sum(purchase_amount) as revenue 
from customer_shopping_behavior 
group by gender ; 

 
-- 2 which customer use discount but spand more the avg purchase amount 
 
SELECT customer_id, purchase_amount
FROM customer_shopping_behavior
WHERE LOWER(discount_applied) = 'yes'
  AND purchase_amount >= (
      SELECT AVG(purchase_amount) 
      FROM customer_shopping_behavior
  );


-- 3 which top 5 product with heighest avg ratting 

SELECT 
    item_purchased,
    ROUND(AVG(review_rating::NUMERIC), 2) AS Average_product_rating
FROM customer_shopping_behavior 
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;
 

 
-- 4   compare the agerage purchas amount between standard and express sping 
 
SELECT shipping_type,
       AVG(CAST(purchase_amount AS DECIMAL(10,2))) AS avg_purchase_amount
FROM customer_shopping_behavior 
WHERE LOWER(shipping_type) IN ('standard','express')
GROUP BY shipping_type;
 
-- 5 do subscribe custoer spand more , compare the average and total revenue between subscribe and non_subscribe 
select subscription_status ,
count(customer_id ) as total_customer ,
round(avg(purchase_amount),2) as avg_spend ,
round(sum(purchase_amount),2) as total_revenue 
from customer_shopping_behavior 
group by subscription_status 
order by total_revenue ,avg_spend desc; 

-- 6 whitch 5 product have heightest percentege with discount applied 
select item_purchased , 
round(100 * sum(case when LOWER(discount_applied)= 'yes' then 1 else 0 end)/count(*),2 )as discount_rate 
from customer_shopping_behavior 
group by item_purchased 
order by discount_rate desc 
limit 5 ; 


-- 7 segment customer into new , returning and loyel based there total 
-- no of provies purches  and show the count of each segement . 

with customer_type as (
select      customer_id,previous_purchases ,
case 
    when previous_purchases = 1 then 'new' 
    when previous_purchases between 2 and 10  THEN 'returning'
    ELSE 'loyel'
    end as customer_segment 
from customer_shopping_behavior  
)

select customer_segment,count(*)  as "Number of Customer"
from customer_type 
group by customer_segment ;


-- 8 what is top 3 most purchase product in each category  
with item_counts as (
select category ,
item_purchased,
count(customer_id) as total_orders ,
row_number() over(partition by category  order by count(customer_id) desc) as item_rank 
from customer_shopping_behavior 
group by category,item_purchased 
)
select item_rank,category,item_purchased,total_orders
from item_counts 
where item_rank <=3 ; 


-- 9 are count how are repeated boyere ( more than 5 previous purchases) also like to subscribs 
select subscription_status ,
count(customer_id) as repeate_buyers
from customer_shopping_behavior  
where previous_purchases > 5  
group by subscription_status ;

-- 10 what is revenue contributed by each age_group 
select age_group ,
sum(purchase_amount) as total_revenue 
from customer_shopping_behavior 
group by age_group 
order by total_revenue desc ;
