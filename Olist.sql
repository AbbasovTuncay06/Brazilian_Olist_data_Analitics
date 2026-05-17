CREATE DATABASE Brazilian_E_Commerce_Public_Dataset_by_Olist

use Brazilian_E_Commerce_Public_Dataset_by_Olist

ALTER TABLE order_items_dataset
ADD CONSTRAINT PK_order_items
PRIMARY KEY (order_id, order_item_id);

ALTER TABLE dbo.order_items_dataset
ADD CONSTRAINT FK_order_items_orders
FOREIGN KEY (order_id)
REFERENCES dbo.orders_dataset(order_id);

ALTER TABLE dbo.order_items_dataset
ADD CONSTRAINT FK_order_items_products
FOREIGN KEY (product_id)
REFERENCES dbo.products_dataset(product_id);

-- Composite Primary Key (order_id + payment_sequential)
ALTER TABLE order_payments_dataset
ADD CONSTRAINT PK_order_payments
PRIMARY KEY (order_id, payment_sequential);

-- Foreign Key → orders
ALTER TABLE order_payments_dataset
ADD CONSTRAINT FK_order_payments_orders
FOREIGN KEY (order_id)
REFERENCES orders_dataset(order_id);


select * from customers_dataset
select * from order_payments_dataset
select * from orders_dataset
select * from products_dataset
select * from order_items_dataset


select distinct(customer_id) from customers_dataset --  Distinctdi hamsı
select distinct(order_id) from order_items_dataset --Distinct order_id lerin sayı normaldan azdır sebebi bezi musteriler iki defeden artıq ve ya cox  siparis verib
SELECT DISTINCT order_id, payment_sequential
FROM order_payments_dataset;                         -- Distinctdi hamsi
select distinct  * from  orders_dataset                --Distinctdi hamsi
select distinct  * from  products_dataset               --Distinctdi hamsi

--Null deyerlerin yoxlanilmasi

select customer_id from customers_dataset
where customer_city is null or customer_state is null   --Null deyer yoxdur 


select  order_id from order_items_dataset
where order_item_id is null or price is null  or freight_value is null  --Null deyer yoxdur


select  order_id from order_payments_dataset
where payment_sequential is null or payment_type is null  or payment_installments is null or payment_value is null


SELECT * from orders_dataset
WHERE 
       customer_id IS NULL
    OR order_status IS NULL
    OR order_purchase_timestamp IS NULL
    OR order_approved_at IS NULL
    OR order_delivered_carrier_date IS NULL
    OR order_delivered_customer_date IS NULL
    OR order_estimated_delivery_date IS NULL    
	/*
	2980 eded null setrimiz varki ,coxu order_approved_at,order_delivered_carrier_date,order_delivered_customer_date onlar haqqinda deqiq melumat ucun
	order_status sutunundan istifade etmek lazimdir
	*/
  
SELECT * from orders_dataset
WHERE order_status  in  ('unavailable','canceled','shipped') and
       customer_id IS NULL
    OR order_status IS NULL
    OR order_purchase_timestamp IS NULL
    OR order_approved_at IS NULL
    OR order_delivered_carrier_date IS NULL
    OR order_delivered_customer_date IS NULL
    OR order_estimated_delivery_date IS NULL     -- 2980 null deyer olan sutun var.Bunu arasdiranda asanliqla demek olurki null olan sutunlarin coxu order_statusdan tesirlenerek null deyerini alib

	SELECT *
FROM products_dataset
WHERE product_id IS NULL
OR product_category_name IS NULL
OR product_name_lenght IS NULL
OR product_description_lenght IS NULL
OR product_photos_qty IS NULL
OR product_weight_g IS NULL
OR product_length_cm IS NULL
OR product_height_cm IS NULL
OR product_width_cm IS NULL;  
/*
611 eded null deyeri olan rows varki bunlari product_id-ye esasen tapmaq lazimdir belke bir qismi istifadeci terefinden sifarisi legv olunmus mehsullardir 
deye ve ya mehsullar legv olunmuyum sadece onlar haqda detalli melumat yoxdu
*/


--Joinlerle uyuşmayan məlumatların təhlili

SELECT c.customer_id,
       COUNT(o.order_id) AS order_count
FROM customers_dataset c
INNER JOIN orders_dataset o 
    ON o.customer_id = c.customer_id
	inner join order_items_dataset oi
	on oi.order_id=o.order_id
GROUP BY c.customer_id
HAVING COUNT(oi.order_id) >= 2;

--Burdanda gorunurki melumatlar duzgundur.Bəzi müstərilər bir nece defe order verdiklərindən order_item_dataset-deki setir sayı ile diger iki cedvel olan  customer ve orders_id sayı beraber olmur

select  product_category_name,
  count(o.order_item_id) as item_count
from products_dataset p 
inner join order_items_dataset o
on o.product_id=p.product_id
group by  product_category_name

select distinct(product_category_name) from products_dataset 

--Categoriyasi belli olmayan   1603 eded item var hansiki Purchase legv olub deye ola biler

--Null deyerlerin legv olunmjus sifarisler olmasini arasdiraq

select * from orders_dataset
select * from products_dataset
select * from order_items_dataset

select o.order_id  from  orders_dataset o
inner join  order_items_dataset oi
on oi.order_id=o.order_id
inner join products_dataset p
on p.product_id=oi.product_id
where o.order_approved_at is null 
or o.order_delivered_carrier_date is null
or o.order_delivered_customer_date is null   

--Burdanda gorunur ki  2470 eded order legv edilib

                                    --Null sehv deyerlerin ve bezi sutunlarin silinmesi ,yeni sutunlarin yaradilmasi(tarix tipli),Reqemlerin formatinin deyisdirilmesi

select * from customers_dataset

update customers_dataset 
set customer_city=upper(left(customer_city,1))+
LOWER(SUBSTRING(customer_city,2,LEN(customer_city)))




--Order_items_dataset uzerindeki isler

select * from order_items_dataset

select  distinct year(shipping_limit_date) from  order_items_dataset

alter table order_items_dataset
drop column seller_id 

--seller_id sutunundan istifade etmediyimiz ucun sutunu silirik

--Cedvele il ve Ay sutunlari elave edek

alter table order_items_dataset
add shipping_limit_year int

alter table order_items_dataset
add shipping_limit_month int

update order_items_dataset
set  shipping_limit_year= year(shipping_limit_date)

update order_items_dataset
set  shipping_limit_month= month(shipping_limit_date)
 

ALTER TABLE order_items_dataset
ALTER COLUMN shipping_limit_month NVARCHAR(20);

UPDATE order_items_dataset
SET shipping_limit_month = 
    CASE 
        WHEN shipping_limit_month = '1' THEN 'Yanvar'
        WHEN shipping_limit_month = '2' THEN 'Fevral'
        WHEN shipping_limit_month = '3' THEN 'Mart'
        WHEN shipping_limit_month = '4' THEN 'Aprel'
        WHEN shipping_limit_month = '5' THEN 'May'
        WHEN shipping_limit_month = '6' THEN 'Iyun'
        WHEN shipping_limit_month = '7' THEN 'Iyul'
        WHEN shipping_limit_month = '8' THEN 'Avqust'
        WHEN shipping_limit_month = '9' THEN 'Sentyabr'
        WHEN shipping_limit_month = '10' THEN 'Oktyabr'
        WHEN shipping_limit_month = '11' THEN 'Noyabr'
        WHEN shipping_limit_month = '12' THEN 'Dekabr'
    END;

--Reqem tipli deyerleri yuvarlaqlasdirmaq

SELECT PRICE,ROUND(PRICE,3) FROM order_items_dataset

UPDATE order_items_dataset
SET price=ROUND(PRICE,3)

SELECT freight_value,ROUND(freight_value,3) FROM order_items_dataset

UPDATE order_items_dataset
SET freight_value=ROUND(freight_value,3)

SELECT * FROM order_items_dataset

--Order_payment_dataset uzerinde emmeller

select * from order_payments_dataset
                      --Payment_type sutunun ilk herfini boyuk yazmaq ve payment_value-ni yuvarlaqlasdiraq

select distinct payment_type fRom order_payments_dataset

update order_payments_dataset
set payment_type=upper(left(payment_type,1)) +
LOWER(SUBSTRING(payment_type,2,LEN(payment_type)))
 
 select payment_value,round(payment_value,3) from order_payments_dataset

 update order_payments_dataset
 set payment_value=round(payment_value,3)


 --Product_Dataset uzerinde emeller

 select * from products_dataset

 --Product_catagery name-in ilk herfini boyuk yazmaq

update products_dataset
set product_category_name=upper(left(product_category_name,1)) +
LOWER(SUBSTRING(product_category_name,2,LEN(product_category_name)))

--Orders_dataset uzerinde emeller

select * from orders_dataset

SELECT
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    -- Faktiki çatdırılma ilə sifariş tarixi arasındakı gün sayı
    DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date) AS delivery_time_days,
    -- Faktiki çatdırılma ilə təxmin edilən çatdırılma tarixi arasındakı fərq
    DATEDIFF(day, order_estimated_delivery_date, order_delivered_customer_date) AS delay_days
FROM orders_dataset;

--Burdaki melumatlara esasen delivery_time_days ve  delay_days sutunlarini yaradaq

alter table orders_dataset
add delivery_time_days int

alter table orders_dataset
add delay_days int

update orders_dataset
set delivery_time_days= DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date)

update orders_dataset
set delay_days=    DATEDIFF(day, order_estimated_delivery_date, order_delivered_customer_date)


                                       --Data-Driven Desicion

									                                     --Orders_Dataset uzerindeki emeller
--Nece order_statuslarin sayina gore qruplasdirmaq
--Nece sifaris vaxtindan evvel catib ve nece sifaris gecikib onlarin sayini tapmaq ve sebebini arasdirmaq

select * from orders_dataset

select order_status,count(order_status) as Total_count_of_order_status
from orders_dataset
group by order_status
order by Total_count_of_order_status desc

select * from orders_dataset
where order_status='shipped'


WITH Example AS
(
SELECT  
       YEAR(order_delivered_carrier_date) AS il,
       order_status
FROM orders_dataset
)

SELECT il,
       COUNT(order_status) AS total
FROM Example
WHERE order_status = 'shipped'
GROUP BY il
ORDER BY total DESC;

/* 99441 sifarisden , 96478 eded sifaris delivered olub,buda cox yuksek neticedir,
2 approved varki bu sifarisler catdirilib amma ola bilerki insan sehvi ve ya diger bir seyden qaynaqlanaraq sisteme dusmeyim,
geride qalan 3000-ine yaxin sifaris ucunde bele demek olar,bir coxu catdirilma sirketi terefinden duzgun yerine yetirilib,amma musteriye hansisa sebeblerden catdirilmayib,
ve ya sisteme dusmeyib bu sebeblerin coxu 2017 ve 2018- ci ilde bas verib ,evveki sorgularin neticelerine baxsaq 2017 ve 2018-ci ilde sifaris sayi diger illere nisbeten qat-qat coxdur,
Netice: sifaris sayi cox olan illerde (2017 ve 2018) xetalarin sayida cox olub demek olar
*/

select * from orders_dataset


with Example as
(
select 
order_status,
case 
when delay_days<=0  and order_status ='delivered' then  1
when delay_days>0 then 0
else -1
end as Order_Delay_Count
from orders_dataset
)
select  order_status,Order_Delay_Count,count(Order_Delay_Count) as Total_Count
from Example
group by Order_Delay_Count,order_status
order by Total_Count desc

/*  bu sorgudan gorunduyu kimi 100000 yaxin sifarisden cemi 6534 sifaris vaxtindan gec catdirilib,
Order_Delay_Count-u -1 olanlar ise haqqdinda melumat olmayan,ve ya diger nasazliqlaran ibaret sifarislerdiki hansiki gec catdirilan sifarislerle beraber toplam 10000+ sifaris emele getirir,
buda o demekdirki toplam sifarislerin onda 1 hissesinin  catdirilmasinda problem var buda cox ciddidir,
Sebeblerini arasdiraq ki neye gore ola biler
1)Shipping sirketi ile bagli problem ola biler ki hansiki mehsulu gec qebul edir ve ya
2)mehsulun sifaris mesaji catdirilma sirketine gec catir
*/
 select * from orders_dataset

with Example as
(
select 
order_id,
order_status,order_delivered_carrier_date,order_approved_at,order_purchase_timestamp,
datediff(day,order_approved_at,order_delivered_carrier_date) as Shipping_Mood,DATEDIFF(DAY,order_purchase_timestamp,order_approved_at) as Order_send_time,
case 
when delay_days<=0  and order_status ='delivered' then  1
when delay_days>0 then 0
else -1
end as Order_Delay_Count
from orders_dataset
)

select order_id,  Order_send_time,Shipping_Mood
 from Example
 where Order_Delay_Count= 0 and order_status='delivered'   and (Order_send_time>3  or Shipping_Mood>5 )

  select * from orders_dataset 
  where order_id='0a93b40850d3f4becf2f276666e01340'

/* Netice: Sifaris melumatinin  tesdiqleme muddeti bezen heddinden artiq cox ceke bilir hansiki bezen bir ay ve ya daha cox olur bundan basqa 70-80% olaraq ise 
sifarisin gecikmesine sebeb melumatin sifaris catdirsan sirkete gec catmasi olub hansiki bu 20-30 bezen daha cox olurki sifarislerin gecikmesine sebeb olub
toplam 6000+ sifarisin 3de 1 hissesi yuxardaki sertlere esasen  (Order_send_time>3  or Shipping_Mood>5 ) gecikir
Note Reqemleri kicildikse bu say artir
*/

                                                        --Customer_dataset uzerinde emeller

--Customer dataseti icinde seherlere ve state-lere uygun toplam customer sayini tapmaq ,en az ve cox musteriye sahib seher ve state-ni axtarmaq,eger hansi bir sebebi varsa axtarib subut etnmek
--Customer dataseti icinde seherlere ve state-lere uygun toplam customer sayini tapmaq ve aya uygun qruplasdirmaq,en az ve cox musteriye sahib seher ve state-ni axtarmaq,eger hansi bir sebebi varsa axtarib subut etnmek
--Customer dataseti icinde seherlere ve state-lere uygun toplam customer sayini tapmaq ve ile uygun qruplasdirmaq,en az ve cox musteriye sahib seher ve state-ni axtarmaq,eger hansi bir sebebi varsa axtarib subut etnmek


/*Customer dataseti icinde seherlere ve state-lere uygun toplam customer sayini tapmaq ,
en az ve cox musteriye sahib seher ve state-ni axtarmaq,eger hansi bir sebebi varsa axtarib subut etnmek*/

select * from customers_dataset

select customer_state,count(customer_unique_id) as Customer_Count
from customers_dataset
group by customer_state
order by  Customer_Count desc


select customer_city,count(customer_unique_id) as Customer_Count
from customers_dataset
group by customer_city
order by  Customer_Count desc

select customer_state,customer_city ,count(customer_unique_id) as Customer_Count
from customers_dataset
group by customer_state,customer_city
order by Customer_Count desc

/* Burdan bele cixirki musteri sayi cox olan state-lerin terkibine boyuk seherler daxildir ,ola bilerki orda yasayan ehalinin sayi ve ya sixligi coxdur 
ona gorede bir cox statede musteri sayi diger bolgelerden keskin ferqlenir
*/

                                 --order_items_dataset uzerinde emeller
--Il ve aya gore toplam mal satisini hesabla

select * from  order_items_dataset

select shipping_limit_year,sum(price+ freight_value) as total_revenue 
from order_items_dataset
group by shipping_limit_year
order by total_revenue desc   --il ucun


select shipping_limit_month,sum(price+ freight_value) as total_revenue 
from order_items_dataset
group by shipping_limit_month
order by total_revenue desc     --ay ucun

SELECT 
    shipping_limit_year,
    shipping_limit_month,
    SUM(price + freight_value) AS total_revenue
FROM order_items_dataset
GROUP BY shipping_limit_year, shipping_limit_month
ORDER BY shipping_limit_year asc, shipping_limit_month desc;     --hem il hemde aya gore qruplasdirma

/* neticeden-de gorunduyu kimi Dataset-de  her ile uygun melumat duzgun yoxdur ,
ola bilerki bu shipping isi ile mesgul olan sirketle baglidirki bezi product-lari ancaq  teyin olunan vaxtlarda catdirirlar 
ve ya bezi produktlar ancaq belirli vaxtlarda satilir ve ya elverisli olur
Product cedvelinde data_driven isleri gorerken burdaki melumatlara baxmaq lazimdir!
*/

                                       --order_payments_dataset uzerinde emeller

--Payment_type uygun payment_valueni hesablamaq,payment_instalmente uygun olaraq gruplasdirmaq ,hansiki bilek payment_instalment edenler bahali yoxsa ucuz mehsullar aliblar

select * from order_payments_dataset

select  payment_type,payment_installments,sum(payment_value)as total_money,count(payment_value) as total_count_of_installement
from order_payments_dataset
group by payment_type,payment_installments
order by total_money desc, total_count_of_installement desc

select payment_type,sum(payment_value) as total_money from order_payments_dataset
group by payment_type
order by total_money desc
  

  /* son iki sorgudan gorunduyu kimi  credit card ile odenis edenlerin sayi ve odenisin cemi diger
  odenis novlerinden coxdur,bundan basqa payment_installement sayi artdiqca  total_count_of_installement dusur buda o demekdirki musteriler odenis etme sayini 1-10 arasinda tutmag istirler 
heddinden artiq yuksek qiymetli mehsullar ucun ise payment_installement artir
  */

                      --products_dataset uzerinde emeller

--product categoriyasina uygun mehsullarin toplam sayini bilek

  select * from products_dataset
  select * from order_items_dataset
  select * from orders_dataset


  select distinct product_category_name from products_dataset

  select product_category_name,COUNT(product_id) as total_count_of_product  from products_dataset
  group by product_category_name
  order by total_count_of_product desc

  /* Product category  saylari arasinda arasinda keskin ferq var.
  bunda gorede diger islerde arasdirmaliyiqki bu ferq telebata goredir yoxsa basa bir sebebden bas verib
  Joinden istifade ederek her product_id-ye ve product_catagory_name ne qeder idem dusur gorek
  */

 SELECT 
p.product_category_name,
COUNT(DISTINCT i.order_id) AS Total_Orders
FROM products_dataset p
INNER JOIN order_items_dataset i
ON p.product_id = i.product_id
GROUP BY p.product_category_name
ORDER BY Total_Orders DESC;

/* Mehsul adlari Brazilya dilinde oldugu ucun adlarini sayaraq vaxt itirmek istemirem,
Netice olaraq demek olarki 20-25 categorye aid orderlerin sayi hardasa 500-10000 reqemleri arasindadirki buda cox gozel neticedir
*/

