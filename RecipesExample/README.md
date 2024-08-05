---
hidden: true
date: 2024-08-06 06:00:21
---

# RecipesExample

RecipesExample 是 SQL 查询：从入门到实践（第４版）提供的示例数据库。

## 导入数据

使用 `00 RecipesStructureMy.SQL` 文件导入建表语句，使用 `01 RecipesDataMY.SQL` 导入数据，使用 `02 RecipesViewsMY.SQL` 导入视图等文件，对于 `02 RecipesViewsMY.SQL`也可以暂时不导入。

> [!CAUTION]
> 对于 DrawSQL 而言，无法正确导入书籍提供的建表语句，可以使用 `RecipesExample.sql` 文件。

```sh
mysql -uroot -p12345 < "00 RecipesStructureMy.SQL"
mysql -uroot -p12345 < "01 RecipesDataMY.SQL"
```

导入数据到 Mysql 容器中，首先需要将文件拷贝到容器中：

```sh
docker cp /path/to/"00 RecipesStructureMy.SQL" \
contianer_name:/tmp/"00 RecipesStructureMy.SQL"

docker cp /path/to/"01 RecipesDataMY.SQL" \
contianer_name:/tmp/"01 RecipesDataMY.SQL"

docker exec -it sh container_name sh
mysql -uroot -p12345 -t < /tmp/"00 RecipesStructureMy.SQL"
mysql -uroot -p12345 -t < /tmp/"01 RecipesDataMY.SQL"
```

## ERD 关系图

![Navicate Export ERD](./imgs//image.png)
![DrawSQL Export ERD](./imgs/drawsql.png)

或者直接访问 [DrawSQL](https://drawsql.app/teams/sql-404/diagrams/recipesexample)，查看 ERD 关系图。
