--1
Select product_name, quantity_per_unit from products

--2
Select product_id, product_name, discontinued from products where discontinued>0

--3
Select product_id, product_name, discontinued from products where discontinued=0

--4
Select product_id, product_name, unit_price from products where unit_price<20

--5
Select product_id, product_name, unit_price from products where unit-price between 15 and 25

--6
Select product_name, product_id, units_in_stock, units_on_order from products where units_in_stock<units_on_order

--7
select * from products where LOWER(product_name) LIKE 'a%'

--8
Select * from products where LOWER(product_name) LIKE '%i'

--9
Select product_name, unit_price, unit_price*1.18 as unit_price_kdv from products

--10
Select COUNT(*) from products where unit_price>30

--11
Select LOWER(product_name), unit_price from products order by unit_price desc

--12
Select CONCAT(first_name, ' ', last_name) as full_name from employees

--13
Select COUNT(*) from employees where (region IS NULL)

--14
Select COUNT(*) from employees where (region IS NOT NULL)

--15
Select CONCAT('TR', UPPER(product_name)) from products

--16
Select CONCAT('TR',product_name), unit_price from products where unit_price<20 

--17
Select product_name, unit_price from products where unit_price=(Select MAX(unit_price) from products)

--18
Select product_name, unit_price from products order by unit_price desc LIMIT 10

--19
Select product_name, unit_price from products where unit_price>(Select AVG(unit_price) from products)

--20
Select SUM(units_in_stock*unit_price) as revenue from products where units_in_stock>0

--21
Select COUNT(units_in_stock+discontinued) from products where units_in_stock>0 AND discontinued=1

--22
Select p.product_name, c.category_name from products p INNER JOIN categories c ON c.category_id=p.category_id

--23
Select category_id, AVG(unit_price) AS average_price FROM products GROUP BY category_id

--24
Select p.product_name, p.unit_price,c.category_name from products as p INNER join categories as c ON p.category_id=c.category_id where unit_price=(Select MAX(unit_price) from products)

--25
Select p.product_name, p.units_on_order, p.unit_price, c.category_name, s.company_name from products p JOIN categories c ON p.category_id=c.category_id JOIN suppliers s ON p.supplier_id=s.supplier_id where units_on_order=(Select MAX(units_on_order) from products)

--26
--Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını
--(`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.

Select p.product_id, p.product_name, s.company_name, s.phone from products p
inner join suppliers s on p.supplier_id=s.supplier_id
where discontinued=1

--27
--1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı

Select e.employee_id, o.order_date, o.ship_address, e.last_name, e.first_name from employees e 
inner join orders o on e.employee_id=o.employee_id
where DATE_PART('year', o.order_date) = 1998 AND DATE_PART('month', o.order_date) = 3;

--28
--1997 yılı şubat ayında kaç siparişim var?
--orders - order_details

-- Select o.order_id, SUM(od.quantity) as "Sipariş Miktarı", o.order_date as "Sipariş Tarihi" from orders o
-- inner join order_details od on o.order_id=od.order_id
-- where DATE_PART('year',o.order_date)=1997 AND DATE_PART('month',o.order_date)=2
-- group by od.quantity, o.order_id

Select COUNT(o.order_id) from orders o 
where DATE_PART('year',o.order_date)=1997 AND DATE_PART('month',o.order_date)=2

--29
--London şehrinden 1998 yılında kaç siparişim var?
Select COUNT(o.order_id) from orders o
where DATE_PART('year',o.order_date)=1998 AND o.ship_city='London'

--30
--1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
-- customers -orders , customer_id

Select c.contact_name, c.phone from customers c
inner join orders o on c.customer_id=o.customer_id
where DATE_PART('year',o.order_date)=1997

--31
--Taşıma ücreti 40 üzeri olan siparişlerim
--freight -orders 

--1. yöntem
Select freight from orders 
where freight>40

--2. yöntem
Select freight from orders 
GROUP BY freight
HAVING freight>40

--32
--Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
--customers - orders , customer_id
Select o.freight, o.ship_city, c.contact_name from orders o
inner join customers c on o.customer_id=c.customer_id
GROUP BY o.freight , o.ship_city, c.contact_name
HAVING freight>=40
ORDER BY freight ASC


--33
--1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
--orders - employees ,employee_id

Select o.order_date, o.ship_city, UPPER(e.first_name || ' ' || e.last_name) as "AD SOYAD" from orders o
inner join employees e on o.employee_id=e.employee_id 
WHERE DATE_PART('year',o.order_date)=1997

--34
--1997 yılında sipariş veren müşterilerin contactname'i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
--orders -customers, customer_id

Select c.customer_id, c.contact_name, regexp_replace(c.phone, '[^0-9]', '', 'g') as trimmed_phone from customers c
inner join orders o on c.customer_id=o.customer_id
WHERE DATE_PART('year',o.order_date)=1997

--35
--Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
--orders - customers - employee

Select o.order_date, c.contact_name, e.first_name, e.last_name from orders o
inner join employees e on o.employee_id=e.employee_id
inner join customers c on c.customer_id=o.customer_id

--36
--Geciken siparişlerim?
Select order_id, required_date, shipped_date from orders
WHERE shipped_date>required_date

--37
--Geciken siparişlerimin tarihi, müşterisinin adı
Select o.order_id, c.contact_name, o.required_date, o.shipped_date from orders o
inner join customers c on o.customer_id=c.customer_id
WHERE shipped_date>required_date

--38
--10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
--product_name, category_name,
--orders - products - categories - order_details

Select o.order_id, p.product_name,c.category_name, od.quantity from orders o
inner join order_details od on o.order_id=od.order_id
inner join products p on p.product_id=od.product_id
inner join categories c on p.category_id=c.category_id
WHERE o.order_id=10248

--39
--10248 nolu siparişin ürünlerinin adı , tedarikçi adı
--orders - products - suppliers

Select o.order_id, p.product_name, s.company_name from orders o
inner join order_details od on o.order_id=od.order_id
inner join products p on od.product_id=p.product_id
inner join suppliers s on p.supplier_id=s.supplier_id
WHERE o.order_id=10248

--40
--3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
--orders - order_details - employees - products
-- orders+order_details , order_details+products , orders+employees

Select o.order_id, e.employee_id, o.order_date, p.product_name, od.quantity from orders o
inner join order_details od on o.order_id=od.order_id
inner join products p on od.product_id=p.product_id
inner join employees e on o.employee_id=e.employee_id
WHERE e.employee_id=3


--41
--1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad

--1.Yöntem
Select e.employee_id, e.first_name, e.last_name, od.quantity from employees e
inner join orders o on e.employee_id=o.employee_id
inner join order_details od on o.order_id=od.order_id
WHERE DATE_PART('year',order_date)=1997
GROUP BY e.employee_id, od.quantity
ORDER BY quantity DESC LIMIT 1

--2.Yöntem
select o.order_id,e.employee_id,od.quantity,o.order_date, e.first_name,e.last_name from employees e
inner join orders o on o.employee_id=e.employee_id
inner join order_details od on od.order_id=o.order_id
where DATE_PART('year', o.order_date)= 1997
order by od.quantity desc LIMIT 1

--42
--1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****

Select o.employee_id, e.first_name, e.last_name, SUM(od.quantity) as total_quantity from orders o
inner join order_details od on o.order_id=od.order_id
inner join employees e on o.employee_id=e.employee_id
Where DATE_PART('year', o.order_date)=1997
GROUP BY o.employee_id, e.first_name, e.last_name
ORDER BY total_quantity DESC LIMIT 1


--43
--En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?

Select p.product_name, p.unit_price, c.category_name from products p
inner join categories c on p.category_id=c.category_id
ORDER BY unit_price desc LIMIT 1


--44
--Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre

Select o.order_id, o.order_date, e.first_name, e.last_name from orders o
inner join employees e on o.employee_id=e.employee_id
ORDER BY order_date DESC  

--45
-- SON 5 siparişimin ortalama fiyatı ve orderid nedir?

Select o.order_id, AVG(od.unit_price) as average from orders o
inner join order_details od on o.order_id=od.order_id
WHERE o.order_id IN (
	Select order_id from orders
	ORDER BY order_date ASC LIMIT 5
)
GROUP BY o.order_id

--46
--Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

Select o.order_id, p.product_name, c.category_name, SUM(od.quantity) as total_sells from orders o
INNER JOIN order_details od on o.order_id=od.order_id
INNER JOIN products p on od.product_id=p.product_id
INNER JOIN categories c on p.category_id=c.category_id
WHERE DATE_PART('month',order_date)=1
GROUP BY o.order_id, p.product_name, c.category_name

--47
--Ortalama satış miktarımın üzerindeki satışlarım nelerdir?

Select od.order_id, SUM(od.quantity) as "total_miktar" from order_details od
GROUP BY od.order_id,od.quantity
HAVING od.quantity > (Select AVG(quantity) from order_details)


--48
--En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı

Select p.product_id, p.product_name, SUM(od.quantity) as "ürün adedi", c.category_name, s.contact_name from products p 
INNER JOIN order_details od on p.product_id=od.product_id
INNER JOIN categories c on p.category_id=c.category_id
INNER JOIN suppliers s on p.supplier_id=s.supplier_id
GROUP BY p.product_id, c.category_name, s.contact_name


--49
--Kaç ülkeden müşterim var

SELECT COUNT(DISTINCT country) AS "Ülke sayısı" FROM customers;

--50 
--3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
--employees - orders - order_details

Select e.employee_id, e.first_name, e.last_name, SUM(od.unit_price * od.quantity) AS "toplam satış" from employees e
INNER JOIN orders o on e.employee_id=o.employee_id
INNER JOIN order_details od on o.order_id=od.order_id
WHERE e.employee_id=3 AND DATE_PART('month',o.order_date)>=1 AND DATE_PART('year',o.order_date)=1998  AND o.order_date<=CURRENT_DATE
GROUP BY e.employee_id


Select e.employee_id, e.first_name, e.last_name, SUM(od.unit_price * od.quantity) AS "toplam satış" from employees e
INNER JOIN orders o on e.employee_id=o.employee_id
INNER JOIN order_details od on o.order_id=od.order_id
WHERE e.employee_id=3 AND o.order_date >= '1998-01-01' AND o.order_date<=CURRENT_DATE
GROUP BY e.employee_id


--51
--10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi

Select o.order_id, p.product_name,c.category_name, od.quantity from orders o
inner join order_details od on o.order_id=od.order_id
inner join products p on p.product_id=od.product_id
inner join categories c on p.category_id=c.category_id
WHERE o.order_id=10248

--52
--10248 nolu siparişin ürünlerinin adı , tedarikçi adı

Select o.order_id, p.product_name, s.company_name from orders o
inner join order_details od on o.order_id=od.order_id
inner join products p on od.product_id=p.product_id
inner join suppliers s on p.supplier_id=s.supplier_id
WHERE o.order_id=10248

--53
--3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti

Select o.order_id, e.employee_id, o.order_date, p.product_name, od.quantity from orders o
inner join order_details od on o.order_id=od.order_id
inner join products p on od.product_id=p.product_id
inner join employees e on o.employee_id=e.employee_id
WHERE e.employee_id=3

--54
--1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad

Select e.employee_id, e.first_name, e.last_name, od.quantity from employees e
inner join orders o on e.employee_id=o.employee_id
inner join order_details od on o.order_id=od.order_id
WHERE DATE_PART('year',order_date)=1997
GROUP BY e.employee_id, od.quantity
ORDER BY quantity DESC LIMIT 1


--55
--1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****

Select o.employee_id, e.first_name, e.last_name, SUM(od.quantity) as total_quantity from orders o
inner join order_details od on o.order_id=od.order_id
inner join employees e on o.employee_id=e.employee_id
Where DATE_PART('year', o.order_date)=1997
GROUP BY o.employee_id, e.first_name, e.last_name
ORDER BY total_quantity DESC LIMIT 1

--56
--En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?

Select p.product_name, p.unit_price, c.category_name from products p
inner join categories c on p.category_id=c.category_id
ORDER BY unit_price desc LIMIT 1 


--57
--Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre

Select o.order_id, o.order_date, e.first_name, e.last_name from orders o
inner join employees e on o.employee_id=e.employee_id
ORDER BY order_date DESC 

--58
--SON 5 siparişimin ortalama fiyatı ve orderid nedir?

Select o.order_id, AVG(od.unit_price) as average from orders o
inner join order_details od on o.order_id=od.order_id
WHERE o.order_id IN (
	Select order_id from orders
	ORDER BY order_date ASC LIMIT 5
)
GROUP BY o.order_id

--59
--Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

Select o.order_id, p.product_name, c.category_name, SUM(od.quantity) as total_sells from orders o
INNER JOIN order_details od on o.order_id=od.order_id
INNER JOIN products p on od.product_id=p.product_id
INNER JOIN categories c on p.category_id=c.category_id
WHERE DATE_PART('month',order_date)=1
GROUP BY o.order_id, p.product_name, c.category_name


--60
--Ortalama satış miktarımın üzerindeki satışlarım nelerdir?

Select od.order_id, SUM(od.quantity) as "total_miktar" from order_details od
GROUP BY od.order_id,od.quantity
HAVING od.quantity > (Select AVG(quantity) from order_details)


--61
--En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı

Select p.product_id, p.product_name, SUM(od.quantity) as "ürün adedi", c.category_name, s.contact_name from products p 
INNER JOIN order_details od on p.product_id=od.product_id
INNER JOIN categories c on p.category_id=c.category_id
INNER JOIN suppliers s on p.supplier_id=s.supplier_id
GROUP BY p.product_id, c.category_name, s.contact_name


--62
--Kaç ülkeden müşterim var

SELECT COUNT(DISTINCT country) AS "Ülke sayısı" FROM customers;

--63
--Hangi ülkeden kaç müşterimiz var

Select DISTINCT country as "Ülke", COUNT(customer_id) as "Müşteri Sayısı" from customers
GROUP BY country

--64
--3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

Select e.employee_id, e.first_name, e.last_name, SUM(od.unit_price * od.quantity) AS "toplam satış" from employees e
INNER JOIN orders o on e.employee_id=o.employee_id
INNER JOIN order_details od on o.order_id=od.order_id
WHERE e.employee_id=3 AND DATE_PART('month',o.order_date)=1 AND o.order_date<=CURRENT_DATE
GROUP BY e.employee_id


--65
--10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?

Select SUM(od.quantity*od.unit_price) as "CİRO" from order_details od
INNER JOIN orders o on od.order_id=o.order_id
WHERE od.product_id=10 AND o.order_date >= '1998-01-01' AND o.order_date<='1998-03-31'


--66
--Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?

Select e.first_name, e.last_name, COUNT(order_id) as "sipariş miktarı" from employees e
INNER JOIN orders o on e.employee_id=o.employee_id
GROUP BY e.employee_id


--67
--91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun

Select * from customers c
LEFT JOIN orders o on c.customer_id=o.customer_id
WHERE o.customer_id IS NULL


--68
--Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri

Select customer_id, company_name, contact_name, address, city, country from customers
WHERE country='Brazil'
	   	   

--69
--Brezilya’da olmayan müşteriler

Select customer_id, company_name, contact_name, address, city, country from customers
WHERE country!='Brazil'

--70
--Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler

Select customer_id, company_name, contact_name, address, city, country from customers
WHERE country='Spain' OR country='France' OR country='Germany'

--71
--Faks numarasını bilmediğim müşteriler

Select * from customers
WHERE fax IS NULL

--72
--Londra’da ya da Paris’de bulunan müşterilerim

Select * from customers
WHERE city='London' OR city='Paris'


--73
--Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler

Select * from customers
WHERE city='México D.F.' AND contact_title='Owner'

--74
-- C ile başlayan ürünlerimin isimleri ve fiyatları

Select product_name, unit_price from products
WHERE product_name LIKE 'C%';

--75
--Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri

Select first_name, last_name, birth_date from employees 
WHERE first_name LIKE 'A%'

--76
--İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları

Select contact_name, company_name from customers 
WHERE LOWER(company_name) LIKE '%restaurant%'

--77
--50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları

Select product_name, unit_price from products
WHERE unit_price BETWEEN 50 AND 100

--78
--1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin 
--(Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri

Select order_id, order_date from orders 
WHERE order_date >= '1996-07-01' AND order_date<='1996-12-31'


--79
--Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler

Select customer_id, company_name, contact_name, address, city, country from customers
WHERE country='Spain' OR country='France' OR country='Germany'


--80
--Faks numarasını bilmediğim müşteriler

Select * from customers
WHERE fax IS NULL

--81
--Müşterilerimi ülkeye göre sıralıyorum:

Select contact_name as "Müşteri Adı", country as "Ülke"  from customers

--82
--Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz

Select product_name, unit_price from products
ORDER BY unit_price DESC

--83
--Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru 
--göstersin sonuç olarak ürün adı ve fiyatını istiyoruz

--2.yol
Select product_name, unit_price, units_in_stock from products 
ORDER BY units_in_stock ASC, unit_price DESC

--2.yol
SELECT product_name, unit_price FROM Products
ORDER BY unit_price DESC, units_in_stock ASC;

--84
--1 Numaralı kategoride kaç ürün vardır..?

Select COUNT(p.product_id) as "ürün sayısı" from categories c
INNER JOIN products p on c.category_id=p.category_id
WHERE c.category_id=1


--85
--Kaç farklı ülkeye ihracat yapıyorum..?

Select COUNT(DISTINCT(ship_country)) from orders

--86
--a.Bu ülkeler hangileri..?

Select country, COUNT(DISTINCT(country)) from customers
GROUP BY country


--87
--En Pahalı 5 ürün

Select product_name, unit_price from products
GROUP BY product_name, unit_price
ORDER BY unit_price desc limit 5

--88
--ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?

Select COUNT(order_id) from orders
WHERE customer_id='ALFKI'
GROUP BY customer_id

--89
--Ürünlerimin toplam maliyeti

Select SUM(unit_price*units_in_stock) as "Toplam Maliyet" from products


--90
--Şirketim, şimdiye kadar ne kadar ciro yapmış..?

Select SUM(unit_price*quantity) as Total from order_details

--91
--Ortalama Ürün Fiyatım

Select AVG(unit_price) from products

--92
--En Pahalı Ürünün Adı

Select product_name from products
order by unit_price desc limit 1

--93
--En az kazandıran sipariş

select o.order_id, SUM(quantity*unit_price) from orders o 
join order_details od on o.order_id = od.order_id
group by o.order_id 
order by SUM(quantity*unit_price) asc LIMIT 1

--94
--Müşterilerimin içinde en uzun isimli müşteri

Select contact_name FROM customers
ORDER BY LENGTH(contact_name) DESC
LIMIT 1

--95
--Çalışanlarımın Ad, Soyad ve Yaşları
--1.yol
Select first_name, last_name, (DATE_PART('year',CURRENT_DATE)-DATE_PART('year',birth_date)) as "yaş"
from employees

--2.yol
SELECT 
    e.first_name || ' ' || e.last_name AS full_name,
    EXTRACT(YEAR FROM age(current_date, e.birth_date)) AS age
FROM employees e;

--96
--Hangi üründen toplam kaç adet alınmış..?

Select p.product_name, SUM(od.quantity) from order_details od
INNER JOIN products p on od.product_id=p.product_id
GROUP BY od.product_id,p.product_name

--97
--Hangi siparişte toplam ne kadar kazanmışım..?

Select order_id, SUM(unit_price*quantity) from order_details
GROUP BY order_id


--98
--Hangi kategoride toplam kaç adet ürün bulunuyor..?

select c.category_id,c.category_name, count(product_id) from products p
join categories c on c.category_id = p.category_id
group by c.category_id,c.category_name

--99
--1000 Adetten fazla satılan ürünler?

Select product_id, SUM(quantity) as total from order_details
GROUP BY product_id
having SUM(quantity)>1000

--100
--Hangi Müşterilerim hiç sipariş vermemiş..?

Select * from customers c
LEFT JOIN orders o on c.customer_id=o.customer_id
WHERE o.order_id is null

--101
--Hangi tedarikçi hangi ürünü sağlıyor ?

Select s.company_name, p.product_name from suppliers s
inner join products p on s.supplier_id=p.supplier_id
GROUP BY s.company_name, p.product_name

--102
--Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?

Select order_id, ship_name, shipped_date from orders
GROUP BY order_id, ship_name, shipped_date

--103
--Hangi siparişi hangi müşteri verir..?

SELECT o.order_id,o.customer_id, c.contact_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

--104
--Hangi çalışan, toplam kaç sipariş almış..?

Select * from employees e 
JOIN orders o on o.order_id=e.order_id
GROUP BY e.employees-----------------------

--105
--En fazla siparişi kim almış..?
select e.employee_id, count(o.order_id) from orders o join employees e on 
e.employee_id = o.employee_id
group by e.employee_id, e.first_name, e.last_name
order by count(o.order_id) desc
limit 1

--106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?

select o.order_id, e.first_name || ' ' || e.last_name, c.contact_name from orders o 
join employees e 
on e.employee_id = o.employee_id
join customers c
on c.customer_id = o.customer_id

--107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?

select p.product_name, c.category_name, s.contact_name from products p join categories c on c.category_id = p.category_id
join suppliers s on s.supplier_id = p.supplier_id

--108
--Hangi siparişi hangi müşteri vermiş,
--hangi çalışan almış, hangi tarihte,
--hangi kargo şirketi tarafından gönderilmiş
--hangi üründen kaç adet alınmış, hangi fiyattan alınmış,
--ürün hangi kategorideymiş 
--bu ürünü hangi tedarikçi sağlamış

--orders -products -suppliers -customers -categories


Select o.order_id, c.company_name, e.first_name, e.last_name,
o.order_date, o.ship_name, p.product_name, od.quantity, od.unit_price, 
ca.category_name, c.contact_name from customers c 
INNER JOIN orders o on c.customer_id=o.customer_id
INNER JOIN order_details od on o.order_id=od.order_id
INNER JOIN products p on od.product_id=p.product_id
INNER JOIN suppliers s on p.supplier_id=s.supplier_id
INNER JOIN categories ca on p.category_id=ca.category_id
INNER JOIN employees e on o.employee_id=e.employee_id


--109 Altında ürün bulunmayan kategoriler

select c.category_name, p.units_in_stock from products p inner join categories c on c.category_id=p.category_id where units_in_stock=0
group by c.category_name,p.units_in_stock

--110 Manager ünvanına sahip tüm müşterileri listeleyiniz.

Select * from customers 
WHERE LOWER(contact_title) ILIKE '%Manager%'

--111 FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.

Select company_name from customers
WHERE customer_id ILIKE 'Fr___'

--112 (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.

--1.yol
Select * FROM customers WHERE phone LIKE '(171)%'

--2.yol 
select company_name,phone from customers where regexp_replace(phone, '[^0-9]', '', 'g') ilike '171%'

--regexp_replace(c.phone, '[^0-9]', '', 'g')


--113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.

Select * from products WHERE quantity_per_unit ILIKE '%boxes%'

--114 Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)

Select contact_name, contact_title, phone, country from customers 
WHERE country in ('France', 'Germany') and contact_title ILIKE '%manager%'

--115 En yüksek birim fiyata sahip 10 ürünü listeleyiniz.

Select * from products ORDER BY unit_price LIMIT 10

--116 Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.

Select city,country,company_name from customers ORDER BY city,country

--117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.

Select (first_name || ' ' || last_name) as full_name,
EXTRACT(YEAR FROM AGE(NOW(),birth_date)) as Age from employees 


--118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.

select order_id,required_date,shipped_date, (shipped_date-order_date) as "gün" from orders
where (shipped_date-order_date) > 35 

--119 Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)

Select c.category_name from categories c
INNER JOIN products p on c.category_id=p.category_id
where unit_price=ALL(Select MAX(unit_price) from products)

-- Select p.product_id, p.product_name, p.unit_price, p.quantity_per_unit, p.units_in_stock, c.category_name  from products p
-- INNER JOIN categories c on p.category_id=c.category_id
-- ORDER BY unit_price DESC 


--120 Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)

Select product_name, category_name from products p
INNER JOIN categories c on p.category_id=c.category_id
where exists (Select category_name from categories c
			 where p.category_id=c.category_id
			 AND category_name ILIKE '%on%' )

--121 Konbu adlı üründen kaç adet satılmıştır.

Select p.product_name, SUM(od.quantity) from products p
INNER JOIN order_details od on p.product_id=od.product_id
WHERE p.product_name='Konbu'
GROUP BY p.product_name

--122 Japonyadan kaç farklı ürün tedarik edilmektedir.

Select DISTINCT p.product_name from products p 
INNER JOIN suppliers s on s.supplier_id=p.supplier_id
WHERE s.country='Japan'


--123 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?

Select MAX(freight), MIN(freight), AVG(freight) from orders 
WHERE EXTRACT(YEAR FROM order_date)=1997

--124. Faks numarası olan tüm müşterileri listeleyiniz.

Select * from customers 
WHERE fax IS NOT NULL

--125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 

Select order_id, order_date from orders 
WHERE shipped_date >= '1996-07-16' AND shipped_date<='1996-07-30'


