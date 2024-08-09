# mysql_examples

精选 Mysql 样例数据库用于练习和参照

- `SQL 查询：从入门到实践（第４版）`

  - [RecipesExample](./RecipesExample/README.md) 这是一个菜品数据库，包含菜品的制作食材，食材分类，计量单位的数据库，共有 6 张表，表关系相对 `复杂程度：高`，适合练习 `多表连接查询` 等功能。
  - [SalesOrdersExample](./SalesOrdersExample/README.md) 这是一个商品销售订单数据库，包含的客户，订单，订单详情表，产品，分类表等 12 张表，表关系 `复杂程度：低`，适合练习 `多表连接查询`，了解 `简易商品订单模型` 等功能。
  - [EntertainmentAgencyExample](./EntertainmentAgencyExample/README.md) 这是一个乐队演出数据库，包含乐队，乐队成员，演出，观众等，共 13 表，表关系 `复杂程度：低`，适合练习 `多表连接查询` 等功能。
  - [SchoolSchedulingExample](./SchoolSchedulingExample/README.md) 这是一个学校课程管理数据库，包含学生，课程，教职人员，课程管理等共计 21 张表，表关系 `复杂成都：高`，适合练习 `多表连接查询` 等复杂查询功能。
  - [BowlingLeagueExample](./BowlingLeagueExample/README.md) 这是一个保龄球联赛数据库，包含保龄球队，球员，联赛，比赛记录等共计 9 张表，`复杂程度：高`，适合练习 `多表连接查询` 等功能。

- [employees](./employees/README.md) 这是一个经典的员工管理数据库，用于展示基本的数据库设计和 SQL 查询，适用于练习 JOIN 操作、分组统计、子查询等 SQL 技能，以及理解数据库设计中的实体关系。
- [sakila](./sakila/README.md) 这是一个模拟的在线 DVD 租赁数据库，提供了一个标准的数据库模式，用于演示 Mysql 的各种功能特性，如视图，存储过程，和触发器。sakila 相对复杂和完整，可用于测试和学习。

- `world` 这是一个小型的示例数据库，通常用于演示 SQL 语句和基本的数据库操作，适合初学者用来学习基本的 SQL 查询语句，如排序、筛选、计数等，过于简单，可以忽略。
- ~~`worldx` 这个数据库是基于 world 修改后的版本，主要用于测试 MySQL 5.7 之后提供的文档存储功能和 X DevAPI。它包含了文档存储的示例和相关的数据模型。过于简单，可以忽略。~~
- `menagerie` 这是一个简单的示例数据库，通常用于演示基本的数据库操作和概念
- `airportdb` 这是一个大型数据集，旨在与 Oracle Cloud Infrastructure （OCI） 和 AWS 上的 MySQL HeatWave 一起使用，用于复杂的分析查询，个人测试一般很少用
- [其它数据库模型 ERD 图参考](https://www.visual-paradigm.com/cn/guide/data-modeling/what-is-entity-relationship-diagram/)

## 参考

- [博客园 MySQL 技术：MySQL 示例数据库大全 ](https://www.cnblogs.com/mysqljs/p/18243559)
- [Mysql 官网示例数据库下载列表页](https://dev.mysql.com/doc/index-other.html)
