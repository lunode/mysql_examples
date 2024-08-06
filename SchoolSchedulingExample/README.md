---
hidden: true
date: 2024-08-06 06:00:21
---

# SchoolSchedulingExample

SchoolSchedulingExample 是 `SQL 查询：从入门到实践（第４版）` 提供的示例数据库。

## 导入数据

使用 `shcema.SQL` 文件导入建表语句，使用 `data.SQL` 导入数据，使用 `views.SQL` 导入视图等文件，对于 `views.SQL` 创建视图文件，也可以暂时不导入。

> [!CAUTION]
> DrawSQL 免费版仅支持 15 张表以下，所以并未提供 DrawSQL ERD 图和 SQL 文件。

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

DrawSQL 免费版不支持 > 15 张表。

## 表字段注释

数据库包含 21 张表：

- `Subjects` 课程科目表，如数学，物理。
- `Classes` 课程安排表

## 练习

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.4.1 使用内连接，列出周三上课的课程所属的科目</summary>

由于同一个课程的不同部分可能安排在同一天上课，因此我使用了关键字 DISTINCT 来消除重复行。

返回 34 条记录：

```sql
select distinct SubjectName
from Classes
inner join Subjects
on Classes.SubjectID = Subjects.SubjectID
where Classes.WednesdaySchedule = 1;
```

</details>
