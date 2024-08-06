---
hidden: true
date: 2024-08-06 06:00:21
---

# SalesOrdersExample

SalesOrdersExample 是 `SQL 查询：从入门到实践（第４版）` 提供的示例数据库。

## 导入数据

使用 `shcema.SQL` 文件导入建表语句，使用 `data.SQL` 导入数据，使用 `views.SQL` 导入视图等文件，对于 `views.SQL` 创建视图文件，也可以暂时不导入。

> [!CAUTION]
> DrawSQL 疑似不支持 ADD CONSTRINAT 语句，可以删除该关键词，直接使用 Foreign Key 关键词。或者直接使用本文档同目录下 [schema-for-drawsql.sql](./schema-for-drawsql.sql) 文件。

```sh
mysql -uroot -p12345 < "schema.SQL"
mysql -uroot -p12345 < "data.SQL"
```

导入数据到 Mysql 容器中，首先需要将文件拷贝到容器中：

```sh
docker cp /path/to/schema.SQL contianer_name:/tmp/schema.SQL
docker cp /path/to/data.SQL contianer_name:/tmp/data.SQL
docker exec -it sh container_name sh
mysql -uroot -p12345 -t < /tmp/schema.SQL
mysql -uroot -p12345 -t < /tmp/data.SQL
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
  - `RetailPrice`
  - `QuantityOnHand`
  - `CategoryID` 分类 ID

## 练习

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.4.1 使用内连接，显示所有商品及其所属的类别</summary>

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
