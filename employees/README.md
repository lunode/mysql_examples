---
hidden: true
date: 2024-08-05 00:13:31
---

# employees

employees 的 SQL 文件存在于 [test_db 仓库](https://github.com/datacharmer/test_db)，可以直接 clone 仓库到目录，或者下载 仓库的 ZIP 压缩，又或者下载 Release 压缩包。

employees 的 SQL 文件偏多，包含主入口文件 `employees.sql` 文件，以及其它的数据文件，还有包含数据校验的 SQL 文件等，就不一一列举了。

## 导入数据

首先需要下载文件到 Mysql 服务运行所在的服务器上，解压 SQL 文件目录到 `/path/to/test_db`:

```sh
cd /path/to/test_db
```

一定要进入到所有 SQL 文件所在的目录，由于主入口文件 `employees.sql` 文件使用 `source 命令` 导入 SQL 文件，所以需要确保目录正确才能正常执行。

```sh
mysql -uroot -p12345 < employees.sql
```

会输出 7 个 INFO 表格以及 data_load_time_diff 表格，如果没有正常输出，则可能存在路径错误。

导入数据到 Mysql 容器中，首先需要将文件拷贝到容器中：

```sh
docker cp /path/to/test_db contianer_name:/tmp/test_db
docker exec -it sh container_name sh
mysql -uroot -p12345
cd /tmp/test/db
mysql -uroot -p12345 -t < employees.sql
```

<details style="padding: 8px 20px; background-color: rgba(142, 150, 170, 0.14);">

<summary>校验数据</summary>

需要在 `/path/to/test_db` 目录下：

```sh
cd /path/to/test_db
```

SHA 校验：

```sh
mysql -uroot -p12345 -t < test_employees_sha.sql
```

校验时间可能较长，耐心等待，结果如下：

```
+----------------------+
| INFO                 |
+----------------------+
| TESTING INSTALLATION |
+----------------------+
+--------------+------------------+------------------------------------------+
| table_name   | expected_records | expected_crc                             |
+--------------+------------------+------------------------------------------+
| departments  |                9 | 4b315afa0e35ca6649df897b958345bcb3d2b764 |
| dept_emp     |           331603 | d95ab9fe07df0865f592574b3b33b9c741d9fd1b |
| dept_manager |               24 | 9687a7d6f93ca8847388a42a6d8d93982a841c6c |
| employees    |           300024 | 4d4aa689914d8fd41db7e45c2168e7dcb9697359 |
| salaries     |          2844047 | b5a1785c27d75e33a4173aaa22ccf41ebd7d4a9f |
| titles       |           443308 | d12d5f746b88f07e69b9e36675b6067abb01b60e |
+--------------+------------------+------------------------------------------+
+--------------+------------------+------------------------------------------+
| table_name   | found_records    | found_crc                                |
+--------------+------------------+------------------------------------------+
| departments  |                9 | 4b315afa0e35ca6649df897b958345bcb3d2b764 |
| dept_emp     |           331603 | d95ab9fe07df0865f592574b3b33b9c741d9fd1b |
| dept_manager |               24 | 9687a7d6f93ca8847388a42a6d8d93982a841c6c |
| employees    |           300024 | 4d4aa689914d8fd41db7e45c2168e7dcb9697359 |
| salaries     |          2844047 | b5a1785c27d75e33a4173aaa22ccf41ebd7d4a9f |
| titles       |           443308 | d12d5f746b88f07e69b9e36675b6067abb01b60e |
+--------------+------------------+------------------------------------------+
+--------------+---------------+-----------+
| table_name   | records_match | crc_match |
+--------------+---------------+-----------+
| departments  | OK            | ok        |
| dept_emp     | OK            | ok        |
| dept_manager | OK            | ok        |
| employees    | OK            | ok        |
| salaries     | OK            | ok        |
| titles       | OK            | ok        |
+--------------+---------------+-----------+
+------------------+
| computation_time |
+------------------+
| 00:00:47         |
+------------------+
+---------+--------+
| summary | result |
+---------+--------+
| CRC     | OK     |
| count   | OK     |
+---------+--------+
```

MD5 校验：

```sh
mysql -uroot -p12345 -t < test_employees_md5.sql
```

校验时间可能较长，耐心等待，结果如下：

```
+----------------------+
| INFO                 |
+----------------------+
| TESTING INSTALLATION |
+----------------------+
+--------------+------------------+----------------------------------+
| table_name   | expected_records | expected_crc                     |
+--------------+------------------+----------------------------------+
| departments  |                9 | d1af5e170d2d1591d776d5638d71fc5f |
| dept_emp     |           331603 | ccf6fe516f990bdaa49713fc478701b7 |
| dept_manager |               24 | 8720e2f0853ac9096b689c14664f847e |
| employees    |           300024 | 4ec56ab5ba37218d187cf6ab09ce1aa1 |
| salaries     |          2844047 | fd220654e95aea1b169624ffe3fca934 |
| titles       |           443308 | bfa016c472df68e70a03facafa1bc0a8 |
+--------------+------------------+----------------------------------+
+--------------+------------------+----------------------------------+
| table_name   | found_records    | found_crc                        |
+--------------+------------------+----------------------------------+
| departments  |                9 | d1af5e170d2d1591d776d5638d71fc5f |
| dept_emp     |           331603 | ccf6fe516f990bdaa49713fc478701b7 |
| dept_manager |               24 | 8720e2f0853ac9096b689c14664f847e |
| employees    |           300024 | 4ec56ab5ba37218d187cf6ab09ce1aa1 |
| salaries     |          2844047 | fd220654e95aea1b169624ffe3fca934 |
| titles       |           443308 | bfa016c472df68e70a03facafa1bc0a8 |
+--------------+------------------+----------------------------------+
+--------------+---------------+-----------+
| table_name   | records_match | crc_match |
+--------------+---------------+-----------+
| departments  | OK            | ok        |
| dept_emp     | OK            | ok        |
| dept_manager | OK            | ok        |
| employees    | OK            | ok        |
| salaries     | OK            | ok        |
| titles       | OK            | ok        |
+--------------+---------------+-----------+
+------------------+
| computation_time |
+------------------+
| 00:00:47         |
+------------------+
+---------+--------+
| summary | result |
+---------+--------+
| CRC     | OK     |
| count   | OK     |
+---------+--------+
```

</details>

## ERD 关系图

![employees ERD图](./imgs/image.png)
![drawSQL 关系图](./imgs/drawsql.png)

或者访问 [drawsql](https://drawsql.app/teams/sql-404/diagrams/employees)，查看详细 ERD 图。

## 员工管理数据库业务流程介绍

表信息介绍

- `departments` 部门表，存储部门 ID 和 Name
- `employees` 员工表，存储员工 ID，生日，姓名，性别，入职日期(hire_date)
- `dept_emp` 部门和员工关系表，存储部门 ID，员工 ID，入职时间，和离职时间，在职人员的离职时间为(9999-01-01)
- `dept_manager` 部门主管表，存储部门 ID，主管 ID（员工 ID），担任时间，卸任时间，未卸任主管的卸任时间(9999-01-01)
- `salaries` 员工薪水表，存储员工 ID，薪水，开始日期，结束日期
- `titles` 员工职位信息，存储员工 ID，职位信息，开始日期，结束日期

## 练习

<details style="padding: 8px 20px; margin-bottom: 20px;background-color: rgba(142, 150, 170, 0.14);">
<summary>1.查询部门表 departments，9 条记录</summary>

```sql
select * from departments;
```

结果共 9 行：

```
+---------+--------------------+
| dept_no | dept_name          |
+---------+--------------------+
| d009    | Customer Service   |
| d005    | Development        |
| d002    | Finance            |
| d003    | Human Resources    |
| d001    | Marketing          |
| d004    | Production         |
| d006    | Quality Management |
| d008    | Research           |
| d007    | Sales              |
+---------+--------------------+
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary>2.查询部门-员工表 dept_emp </summary>

由于存在数十万条数据，所以加上 limit 限制查询条目：

```sql
select * from dept_name limit 1;
```

结果：

```
+--------+---------+------------+------------+
| emp_no | dept_no | from_date  | to_date    |
+--------+---------+------------+------------+
|  10001 | d005    | 1986-06-26 | 9999-01-01 |
+--------+---------+------------+------------+
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary>3.查询部门-员工表 dept_emp 记录总数 ，331603 条记录</summary>

```sql
select COUNT(*) from dept_emp;
```

结果如下：

```
+----------+
| COUNT(*) |
+----------+
|   331603 |
+----------+
```

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary>4.查询员工表 employees 员工总数，300024 条记录</summary>

```sql
select COUNT(*) from employees;
```

结果如下：

```
+----------+
| COUNT(*) |
+----------+
|   300024 |
+----------+
```

</details>

出现 `dept_emp` 部门-员工记录总数比 `employess` 员工总数要多，主要是由于员工从一个部门迁移到另外一个部门，但是员工 ID 并没有变。

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary>5.查询部门-员工表 dept_emp 重复员工，31579 条记录 </summary>

查询重复员工的 ID：

```sql
select emp_no from dept_emp
group by emp_no
having count(emp_no) > 1
limit 3;
```

结果如下：

```sql
+--------+
| emp_no |
+--------+
|  10010 |
|  10018 |
|  10029 |
+--------+
```

查询重复员工的 ID 总数：

```sql
select count(distinct emp_no) from dept_emp
where emp_no in (
  select emp_no from dept_emp
  group by emp_no
  having count(emp_no) > 1
);
```

结果如下：

```
+------------------------+
| count(distinct emp_no) |
+------------------------+
|                  31579 |
+------------------------+
```

</details>

发现部门-员工表的记录总数 331603 和 员工表的员工总数 300024 之间的差值正好就是 31579，说明部门员工表中重复的员工记录就是员工转换部门的结果。

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary>6.查询部门-员工表 dept_emp 重复员工的部门-员工记录，63158 条记录  </summary>

查询重复员工记录，由于这些员工都有 2 条部门-员工的关系，且没有一个员工有 3 个部门-员工关系，所以一共有 63158 条记录。

```sql
select count(emp_no) from dept_emp
where emp_no in (
  select  emp_no from dept_emp
  group by emp_no
  having count(emp_no) > 1
);
```

结果：

```
+---------------+
| count(emp_no) |
+---------------+
|         63158 |
+---------------+
```

```sql
select * from dept_emp
where emp_no in (
  select emp_no from dept_emp
  group by emp_no
  having count(emp_no) > 1
) limit 5;
```

结果如下：

```
+--------+---------+------------+------------+
| emp_no | dept_no | from_date  | to_date    |
+--------+---------+------------+------------+
|  10010 | d004    | 1996-11-24 | 2000-06-26 |
|  10010 | d006    | 2000-06-26 | 9999-01-01 |
|  10018 | d004    | 1992-07-29 | 9999-01-01 |
|  10018 | d005    | 1987-04-03 | 1992-07-29 |
|  10029 | d004    | 1991-09-18 | 1999-07-08 |
+--------+---------+------------+------------+
```

可以看出 10010，10018 员工都有过 2 次部门记录。

</details>

## 参考

- [博客园(stream886): MySQL 练习-employees 数据库(一) ](https://www.cnblogs.com/stream886/p/6254630.html)
- [博客园(stream886): MySQL 练习-employees 数据库(二)](https://www.cnblogs.com/stream886/p/6254709.html)
