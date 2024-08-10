---
hidden: true
date: 2024-08-06 06:00:21
---

# SalesOrdersExample

SalesOrdersExample 是 `SQL 查询：从入门到实践（第４版）` 提供的示例数据库。

## 导入数据

使用 `schema.SQL` 文件导入建表语句，使用 `data.SQL` 导入数据。

`view.sql` 是书中提供的参考答案，以创建视图的形式保存在 SQL 文件中，可以参考，意义不大，也用不上。

> [!CAUTION]
> DrawSQL 疑似不支持 ADD CONSTRINAT 语句，可以删除该关键词，直接使用 Foreign Key 关键词。或者直接使用本文档同目录下 [schema-for-drawsql.sql](./schema-for-drawsql.sql) 文件。

```sh
mysql -uroot -p12345 < "schema.SQL"
mysql -uroot -p12345 < "data.SQL"
```

导入数据到 Mysql 容器中，首先需要将文件拷贝到容器中：

```sh
docker exec -it container_name mysql -uroot -p12345 -t < /path/to/schema.SQL
docker exec -it container_name mysql -uroot -p12345 -t < /path/to/data.SQL
```

## ERD 关系图

![Navicate Export ERD](./imgs/image.png)
![DrawSQL Export ERD](./imgs/drawsql.png)

或者直接访问 [DrawSQL](https://drawsql.app/teams/sql-404/diagrams/salesordersexample)，查看 ERD 关系图。

## 表字段注释

数据库包含 11 张表：

- `Products`
  - `ProductNumber` 商品 ID
  - `ProductName` 商品名称
  - `ProductDescription` 商品描述
  - `RetailPrice` 零售价格
  - `QuantityOnHand`
  - `CategoryID` 分类 ID
- `Orders`
  - `OrderDate` 下单日期
  - `ShipDate` 发货日期

## 练习

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.4.1 使用内连接，显示所有商品及其所属的类别</summary>

需求分析，获取 `所有` 商品，即在没有外键为 NULL 的情况下，可以使用内连接。如果外键可能存在为 NULL 的情况，则需要使用左外连接。

返回 40 条记录：

```sql
select ProductName, Categories.CategoryDescription
from Products
inner join Categories
on Products.CategoryID = Categories.CategoryID;
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.4.2 使用内连接，找出所有订购了自行车头盔的顾客</summary>

需求分析，获取 `所有` 顾客，即在没有外键为 NULL 的情况下，可以使用内连接。如果外键可能存在为 NULL 的情况，则需要使用左外连接。而限制条件 `订购了自行车头盔`，就排除了所有外键为 NULL 的情况，所以此例使用内连接。

由于顾客可能多次订购头盔，因此使用了关键字 DISTINCT 来消除重复行。

返回 25 条记录：

```sql
select DISTINCT Customers.CustomerID, Customers.CustLastName, Customers.CustFirstName
from Orders
inner join Customers
on Orders.CustomerID = Customers.CustomerID
inner join Order_Details
on Orders.OrderNumber = Order_Details.OrderNumber
inner join Products
on Order_Details.ProductNumber = Products.ProductNumber
where ProductName like '%helmet%';
```

书中示例，返回 25 条记录:

```sql
SELECT DISTINCT Customers.CustFirstName, Customers.CustLastName
FROM (
  (
    Customers
    INNER JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID
  )
  INNER JOIN Order_Details
  ON Orders.OrderNumber = Order_Details.OrderNumber
)
INNER JOIN Products
ON Products.ProductNumber = Order_Details.ProductNumber
WHERE Products.ProductName LIKE '%Helmet%';
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.4.3 使用内连接，找出所有订购了自行车和头盔的顾客</summary>

需求分析，可以将需求拆分成，购买了自行车的顾客和购买了头盔的顾客的交集。所有购买了自行车的顾客，参考上例，由于条件中排除了外键为 NULL 的情况，所以使用内连接。所有订购了头盔的顾客是一样的逻辑，使用内连接获取，然后取这两个结果集的交集即可。

查询购买了自行车的顾客，返回 909 条记录：

```sql
select Customers.CustomerID
from Customers
inner join Orders
on Orders.CustomerID = Customers.CustomerID
inner join Order_Details
on Orders.OrderNumber = Order_Details.OrderNumber
inner join Products
on Order_Details.ProductNumber = Products.ProductNumber
where Products.ProductName like '%Bike';
```

查询购买了头盔的顾客，返回 279 条记录：

```sql
select Customers.CustomerID
from Customers
inner join Orders
on Orders.CustomerID = Customers.CustomerID
inner join Order_Details
on Orders.OrderNumber = Order_Details.OrderNumber
inner join Products
on Order_Details.ProductNumber = Products.ProductNumber
where Products.ProductName like '%Helmet';
```

对两个结果集派生表 Derived Table 使用 inner join 取交集，返回 21 条记录：

```sql
SELECT distinct A.CustomerID, A.CustFirstName, A.CustLastName
FROM (
	SELECT Customers.CustomerID,
	Customers.CustFirstName, Customers.CustLastName
	FROM Customers
	INNER JOIN Orders ON Orders.CustomerID = Customers.CustomerID
	INNER JOIN Order_Details ON Orders.OrderNumber = Order_Details.OrderNumber
	INNER JOIN Products ON Order_Details.ProductNumber = Products.ProductNumber
	WHERE Products.ProductName LIKE '%Bike'
) AS A
INNER JOIN (
	SELECT Customers.CustomerID
	FROM Customers
	INNER JOIN Orders ON Orders.CustomerID = Customers.CustomerID
	INNER JOIN Order_Details ON Orders.OrderNumber = Order_Details.OrderNumber
	INNER JOIN Products ON Order_Details.ProductNumber = Products.ProductNumber
	WHERE Products.ProductName LIKE '%Helmet'
) AS B
on A.CustomerID = B.CustomerID;
```

书中示例，返回 21 条记录：

```sql
SELECT CustBikes.CustFirstName,
   CustBikes.CustLastName
FROM
   (SELECT DISTINCT Customers.CustomerID,
      Customers.CustFirstName,
      Customers.CustLastName
    FROM ((Customers
    INNER JOIN Orders
      ON Customers.CustomerID
        = Orders.CustomerID)
    INNER JOIN Order_Details
      ON Orders.OrderNumber =
        Order_Details.OrderNumber)
    INNER JOIN Products
      ON Products.ProductNumber =
      Order_Details.ProductNumber
    WHERE Products.ProductName LIKE '%Bike')
  AS CustBikes
INNER JOIN
  (SELECT DISTINCT Customers.CustomerID
    FROM ((Customers
    INNER JOIN Orders
      ON Customers.CustomerID =
         Orders.CustomerID)
    INNER JOIN Order_Details
      ON Orders.OrderNumber =
         Order_Details.OrderNumber)
    INNER JOIN Products
      ON Products.ProductNumber =
         Order_Details.ProductNumber
    WHERE Products.ProductName LIKE '%Helmet')
      AS CustHelmets
ON CustBikes.CustomerID =
   CustHelmets.CustomerID;
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.6 使用内连接，列出顾客及其下单日期，并按下单日期排序</summary>

返回 994 条记录：

```sql
select
Customers.CustomerID,
concat(Customers.CustFirstName, ',', Customers.CustLastName) as CustomerName,
OrderDate
from Customers
inner join Orders
on Customers.CustomerID = Orders.CustomerID
order by Orders.OrderDate, Customers.CustomerID;
```

书中示例同上，可参考 view.sql 文件中 CH08_Customers_And_OrderDates

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.6 使用内连接，列出员工及其为哪些顾客下了订单</summary>

返回 211 条记录：

```sql
select DISTINCT
CONCAT(Employees.EmpFirstName,',',Employees.EmpLastName) as EmployeesName,
CONCAT(Customers.CustFirstName, ',', Customers.CustLastName) as CustomerName
from Employees
inner join Orders
on Employees.EmployeeID = Orders.EmployeeID
inner join Customers
on Orders.CustomerID = Customers.CustomerID
```

书中示例同上，可参考 view.sql 文件中 CH08_Employees_And_Customers

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.6 显示所有的订单、每个订单包含的商品以及每种商品的库存量，并按订单号排序</summary>

返回 3973 条记录：

```sql
select
distinct Orders.OrderNumber,
Products.ProductNumber,
ProductName,
Products.QuantityOnHand
ProductNumber
from Orders
inner join Order_Details
on Orders.OrderNumber = Order_Details.OrderNumber
inner join Products
on Products.ProductNumber = Order_Details.ProductNumber
order by Orders.OrderNumber;
```

书中示例同上，可参考 view.sql 文件中 CH08_Orders_With_Products

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.6 使用内连接，显示供应商及其提供的价格低于 100 美元的商品</summary>

返回 66 条记录：

```sql
select *
from Products
inner join Product_Vendors
on Products.ProductNumber = Product_Vendors.ProductNumber
inner join Vendors
on Product_Vendors.VendorID = Vendors.VendorID
where Product_Vendors.WholesalePrice < 100;
```

书中示例同上，可参考 view.sql 文件中 CH08_Vendors_And_Products_Less_Than_100

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.6 使用内连接，列出同姓的顾客和员工</summary>

返回 16 条记录：

```sql
select Customers.CustFirstName, Customers.CustLastName, Employees.EmpFirstName, Employees.EmpLastName from Customers
inner join Employees
on Customers.CustLastName = Employees.EmpLastName;
```

书中示例同上，可参考 view.sql 文件中 CH08_Customers_Employees_Same_LastName

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.6 使用内连接，列出居住在同一座城市的顾客和员工</summary>

返回 10 条记录：

```sql
select DISTINCT
Customers.CustFirstName, Customers.CustLastName,
Employees.EmpFirstName, Employees.EmpLastName,
Customers.CustCity, Employees.EmpCity
from Customers
inner join Employees
on Customers.CustCity = Employees.EmpCity;
```

书中示例同上，可参考 view.sql 文件中 CH08_Customers_Employees_Same_City

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.5 使用左外连接，查询哪些商品从未被订购过</summary>

返回 2 条记录：

```sql
SELECT
Products.ProductNumber,
Products.ProductName,
Order_Details.OrderNumber
FROM Products
LEFT OUTER JOIN Order_Details
ON Products.ProductNumber =
Order_Details.ProductNumber
WHERE Order_Details.OrderNumber IS NULL;
```

书中示例同上。

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.5 使用左外连接，查询所有顾客及其自行车订单</summary>

首先上来就是万能 left join 大法，手写 **`错误`** 示例，返回 909 条记录：

```sql
-- 这是错误示例
select *
from Customers
left join Orders
on Customers.CustomerID = Orders.CustomerID
left join Order_Details
on Orders.OrderNumber = Order_Details.OrderNumber
left join Products
on Order_Details.ProductNumber = Products.ProductNumber
left join Categories
on Products.CategoryID = Categories.CategoryID
where Categories.CategoryDescription = 'Bikes';
```

MySQL 查询语句的执行顺序

- `5.select column, 5.2 distinct, 5.3 top`
- `1.from`
- `2.where`
- `3.group by`
- `4.having`
- `6.order by`
- `limit,offset`

尽管使用左连接，想留住 Customers 表中没有下单，甚至没有下单 Bikes 的用户，但到了最后，一条 **`where`** 筛选就将没有买 Bikes 的客户过滤掉，更别说没有下单任何产品的用户。

所以 Where 过滤掉的应该是还没有包含 Customers 表信息的数据，然后在和 Customer 连表。将上述 SQL 稍作修改，将 Customers 之后的结果集用括号包起来。

返回 914 条记录：

```sql
select *
from Customers
left join (
  SELECT Orders.CustomerID
  from Orders
  left join Order_Details
  on Orders.OrderNumber = Order_Details.OrderNumber
  left join Products
  on Order_Details.ProductNumber = Products.ProductNumber
  left join Categories
  on Products.CategoryID = Categories.CategoryID
  where Categories.CategoryDescription = 'Bikes'
) as A
on Customers.CustomerID = A.CustomerID
```

书中示例，返回 914 条记录：

```sql
select
Customers.CustFirstName,
Customers.CustLastName,
A.OrderNumber,
A.ProductNumber,
A.OrderDate,
A.QuantityOrdered,
A.QuotedPrice
from Customers
left join (
	select Orders.CustomerID, Orders.OrderDate, Orders.OrderNumber,
	Products.ProductNumber, Order_Details.QuantityOrdered, Order_Details.QuotedPrice
	from Orders
	inner join Order_Details
		on Orders.OrderNumber = Order_Details.OrderNumber
	inner join Products
		on Order_Details.ProductNumber = Products.ProductNumber
	inner join Categories
		on Products.CategoryID = Categories.CategoryID
	where Categories.CategoryDescription = 'Bikes'
) as A
on Customers.CustomerID = A.CustomerID;
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.7 使用外连接，列出从未订购过头盔的顾客</summary>

返回 3 条记录：

```sql
select Customers.CustFirstName, Customers.CustLastName
from Customers
left join (
	select Orders.CustomerID
	from Orders
	inner join Order_Details
	on Orders.OrderNumber = Order_Details.OrderNumber
	inner join Products
	on Order_Details.ProductNumber = Products.ProductNumber
	where Products.ProductName like '%Helmet'
) as HelmetOrder
on Customers.CustomerID = HelmetOrder.CustomerID
where HelmetOrder.CustomerID is NUll;
```

书中示例同上，可参考 view.sql 文件中 CH09_Customers_No_Helmets

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.7 使用外连接，显示没有任何销售代表(员工)的邮政编码与其相同的顾客</summary>

返回 18 条记录：

```sql
select Customers.CustomerID, Customers.CustFirstName, Customers.CustLastName
from Customers
left join Employees
on Customers.CustZipCode = Employees.EmpZipCode
where Employees.EmpZipCode is NULL;
```

书中示例同上，可参考 view.sql 文件中 CH09_Customers_No_Rep_Same_Zip

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.7 使用外连接，列出所有的商品及包含它的订单的日期</summary>

查看错误示例：

```sql
-- 这是错误示例
select  ProductName, ood.OrderDate
from Products
left join (
	select distinct Orders.CustomerID, Order_Details.ProductNumber, Orders.OrderDate
	from Orders
	inner join Order_Details
	on Orders.OrderNumber = Order_Details.OrderNumber
) as ood
on Products.ProductNumber = ood.ProductNumber;
```

一个 DISTINCT 引发的错误，上述 SQL 将连表的主键作为 DISTINCT 去重对象，将结果集所有的内容保存下来了，订单用户 id，订单日期，订单详情产品 id。而需求只要产品和日期，不同的用户可能在同一天对同一个产品进行下单，所以导致上述结果集还包含了用户信息。需求中只要求商品和订单日期，所以需要排除用户，进一步去重。

返查看正确示例，回 2681 条记录：

```sql
select  ProductName, ood.OrderDate
from Products
left join (
	select distinct Order_Details.ProductNumber, Orders.OrderDate
	from Orders
	inner join Order_Details
	on Orders.OrderNumber = Order_Details.OrderNumber
) as ood
on Products.ProductNumber = ood.ProductNumber;
```

书中示例同上，可参考 view.sql 文件中 CH09_All_Products_Any_Order_Dates

</details>
