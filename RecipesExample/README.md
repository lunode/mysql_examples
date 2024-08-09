---
hidden: true
date: 2024-08-06 06:00:21
---

# RecipesExample

RecipesExample 是 `SQL 查询：从入门到实践（第４版）` 提供的示例数据库。

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

或者直接访问 [DrawSQL](https://drawsql.app/teams/sql-404/diagrams/recipesexample)，查看 ERD 关系图。

## 表字段注释

数据库包含 6 张表：

- `Recipes` 菜品表
  - `RecipeID` 菜品 ID
  - `RecipeTitle` 菜品名称
  - `RecipeClassID` 菜品分类 ID
  - `Preparation` 菜品制作方法
  - `Notes` 菜品提示
- `Recipe_Classes` 菜品分类表
  - `RecipeClassID` 菜品分类 ID
  - `RecipeClassDescription` 菜品分类名称
- `Ingredients` 食材表（成分）
  - `IngredientID` 食材 ID
  - `IngredientName` 食材名称
  - `IngredientClassID` 食材分类
  - `MeasureAmountID` 计量单位 ID
- `Ingredient_Classes` 食材分类表
  - `IngredientClassID` 食材分类 ID
  - `IngredientClassDescription` 成分分类名称
- `Recipe_Ingredients` 菜品-食材 linking table
  - `RecipeID` 菜品 ID
  - `IngredientID` 食材 ID
  - `RecipeSeqNo` 食材顺序
  - `MeasureAmountID` 计量单位 ID
  - `Amount` 食材用量用量
- `Measurements` 计量单位表
  - `MeasureID` 计量单位 ID
  - `MeasurementDescription` 计量单位名称

## 练习

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.2.3-2 使用内连接，列出数据库中所有菜品的名称，制作方法和菜品类型描述</summary>

返回 15 条记录

```sql
select RecipeTitle, RecipeClassDescription, Preparation
from Recipes
inner join Recipe_Classes
on Recipe_Classes.RecipeClassID = Recipes.RecipeClassID;
```

书中提供的其它示例：

```sql
select RecipeTitle, RecipeClassDescription, Preparation
from Recipes, Recipe_Classes
where Recipe_Classes.RecipeClassID = Recipes.RecipeClassID;
```

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.2.3-2 使用内连接，列出数据库中菜品分类为主菜 Main course 或者甜品 Dessert 的菜品的名称，制作方法和菜品类型描述</summary>

返回 9 条记录：

```sql
select RecipeTitle, RecipeClassDescription, Preparation
from Recipes
inner join Recipe_Classes
on Recipe_Classes.RecipeClassID = Recipes.RecipeClassID
where RecipeClassDescription = "Main course"
or RecipeClassDescription = "Dessert";
```

</details>

对于上述内连接查询，Recipes 共有 15 条记录，Recipe_Classes 共有 7 条件，也就是造成了 7 x 15 = 105 条查询记录。

对于上述查询，可以使用 `子查询` 优化查询。

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.2.3-3 使用子查询优化上述查询</summary>

返回 9 条记录：

```sql
select RecipeTitle, Preparation, DerivedTable.RecipeClassDescription
from (
  select RecipeClassID, RecipeClassDescription
  from Recipe_Classes
  where RecipeClassDescription = "Main course"
  or RecipeClassDescription = "Dessert"
) as DerivedTable -- [!code ++] 子查询派生表需要添加别名 alias
inner join Recipes
on DerivedTable.RecipeClassID = Recipes.RecipeClassID;
```

</details>
使用子查询优化后，子查询的派生表 Derived Table 只有 2条数据，内连接表 Recipes 有 7 条数据，于是就有了 7 x 2 = 14 条查询记录。

虽然理论上降低了参与查询的数据量，优化了查询速度，但实际上 Mysql 优化器会进行主动优化。通过 Explain 分析查询语句，发现两种查询语句的效率其实是一样的。

接下来 5 表连接：

![5表连接](./imgs//5table-join.png)

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">

<summary markdown="span">#8.2.3-4 五表连接，获取菜品类型、菜品名、制作说明、食材名、食材序号、食材数量和食材度 量单位，并按菜品名和序号排序</summary>

返回 88 条记录：

```sql
select Recipe_Classes.RecipeClassDescription,
	Recipes.RecipeTitle,
	Ingredients.IngredientName,
	Recipe_Ingredients.RecipeSeqNo,
	Recipe_Ingredients.Amount,
	Measurements.MeasurementDescription,
	Recipes.Preparation
from Recipes
inner JOIN Recipe_Classes on Recipes.RecipeClassID = Recipe_Classes.RecipeClassID
inner JOIN Recipe_Ingredients on Recipes.RecipeID = Recipe_Ingredients.RecipeID
inner JOIN Ingredients on Recipe_Ingredients.IngredientID = Ingredients.IngredientID
inner join Measurements on Recipe_Ingredients.MeasureAmountID = Measurements.MeasureAmountID
order by
Recipes.RecipeTitle,
RecipeSeqNo;
Recipes.RecipeTitle;
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.2.3-4 五表连接，书中示例</summary>

返回 88 条记录：

```sql
SELECT
Recipe_Classes.RecipeClassDescription,
Recipes.RecipeTitle,
Recipes.Preparation,
Ingredients.IngredientName,
Recipe_Ingredients.RecipeSeqNo,
Recipe_Ingredients.Amount,
Measurements.MeasurementDescription
FROM (
  (
    (
      Recipe_Classes
      INNER JOIN Recipes
      ON Recipe_Classes.RecipeClassID =
      Recipes.RecipeClassID
    )
    INNER JOIN Recipe_Ingredients
    ON Recipes.RecipeID =
    Recipe_Ingredients.RecipeID
  )
  INNER JOIN Ingredients
  ON Ingredients.IngredientID =
     Recipe_Ingredients.IngredientID
)
INNER JOIN Measurements
ON Measurements.MeasureAmountID = Recipe_Ingredients.MeasureAmountID
ORDER BY RecipeTitle, RecipeSeqNo
```

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.2.3-4 五表连接，书中示例 2</summary>

返回 88 条记录：

```sql
SELECT
Recipe_Classes.RecipeClassDescription,
Recipes.RecipeTitle,
Recipes.Preparation,
Ingredients.IngredientName,
Recipe_Ingredients.RecipeSeqNo,
Recipe_Ingredients.Amount,
Measurements.MeasurementDescription
FROM Recipe_Classes
INNER JOIN (
  (
    (
      Recipes
      INNER JOIN Recipe_Ingredients
      ON Recipes.RecipeID = Recipe_Ingredients.RecipeID
    )
    INNER JOIN Ingredients
    ON Ingredients.IngredientID = Recipe_Ingredients.IngredientID
  )
  INNER JOIN Measurements
  ON Measurements.MeasureAmountID = Recipe_Ingredients.MeasureAmountID
)
ON Recipe_Classes.RecipeClassID = Recipes.RecipeClassID
ORDER BY RecipeTitle, RecipeSeqNo
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.2.4 列出所有菜品的名称以及制作每种菜品所需的食材</summary>

返回 88 条记录：

```sql
select RecipeTitle, IngredientName
from Recipes
INNER JOIN Recipe_Ingredients
on Recipes.RecipeID = Recipe_Ingredients.RecipeID
inner join Ingredients
on Recipe_Ingredients.IngredientID = Ingredients.IngredientID;
```

书中示例，返回 88 条记录：

```sql
SELECT
Recipes.RecipeTitle,
Ingredients.IngredientName
FROM (
  Recipes
  INNER JOIN Recipe_Ingredients
  ON Recipes.RecipeID = Recipe_Ingredients.RecipeID
)
INNER JOIN Ingredients
ON Ingredients.IngredientID = Recipe_Ingredients.IngredientID;
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.4.1 列出包含食材牛肉或大蒜的菜品</summary>

返回 5 条记录：

```sql
select DISTINCT Recipes.RecipeTitle
from Recipes
inner join Recipe_Ingredients
on Recipes.RecipeID = Recipe_Ingredients.RecipeID
inner join Ingredients
on Recipe_Ingredients.IngredientID = Ingredients.IngredientID
where Ingredients.IngredientName = 'Beef' or Ingredients.IngredientName = 'Garlic';
```

```sql
select DISTINCT Recipes.RecipeTitle
from Recipes
inner join Recipe_Ingredients
on Recipes.RecipeID = Recipe_Ingredients.RecipeID
where Recipe_Ingredients.IngredientID in (
  select distinct IngredientID from Ingredients
  where Ingredients.IngredientName = 'Beef' or Ingredients.IngredientName = 'Garlic'
);
```

书中示例，返回 5 条记录：

```sql
SELECT DISTINCT Recipes.RecipeTitle
FROM Recipes
INNER JOIN Recipe_Ingredients
ON Recipes.RecipeID = Recipe_Ingredients.RecipeID
WHERE Recipe_Ingredients.IngredientID IN (1, 9);
```

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.4.1 使用内连接，列出主菜及其使用的所有食材</summary>

返回 53 条记录：

```sql
select RecipeTitle, IngredientName, MeasurementDescription, Amount
from Recipes
inner join Recipe_Classes
on Recipe_Classes.RecipeClassID = Recipes.RecipeClassID
inner join Recipe_Ingredients
on Recipes.RecipeID = Recipe_Ingredients.RecipeID
inner join Ingredients
on Recipe_Ingredients.IngredientID = Ingredients.IngredientID
inner join Measurements
on Recipe_Ingredients.MeasureAmountID = Measurements.MeasureAmountID
where Recipe_Classes.RecipeClassDescription = 'Main Course';
```

书中示例，返回 53 条记录：

```sql
SELECT Recipes.RecipeTitle,Ingredients.IngredientName,
Measurements.MeasurementDescription,Recipe_Ingredients.Amount
FROM (
  (
    (
      Recipe_Classes
      INNER JOIN Recipes
      ON Recipes.RecipeClassID = Recipe_Classes.RecipeClassID
    )
    INNER JOIN Recipe_Ingredients
    ON Recipes.RecipeID = Recipe_Ingredients.RecipeID
  )
  INNER JOIN Ingredients
  ON Ingredients.IngredientID = Recipe_Ingredients.IngredientID
)
INNER JOIN Measurements
ON Measurements.MeasureAmountID = Recipe_Ingredients.MeasureAmountID
WHERE Recipe_Classes.RecipeClassDescription = 'Main course';
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.4.3 使用内连接，显示包含胡萝卜的菜品的所有食材</summary>

参考 DrawSQL ERD 图，先将菜品表 Recipes 与菜品-食材 Recipe_Ingredients 表 inner join，然后再 inner join Ingredients 表，获取到包含胡萝卜食材的菜品 ID，然后再 inner join 一次 Recipe_Ingredients 表，获取该菜品 ID 的所有食材。

返回 16 条记录：

```sql
SELECT
	RecipeIDTable.RecipeID,
	Ingredients.IngredientName
FROM (
	SELECT DISTINCT Recipe_Ingredients.RecipeID
	FROM Recipe_Ingredients
	INNER JOIN Ingredients ON Recipe_Ingredients.IngredientID = Ingredients.IngredientID
	WHERE Ingredients.IngredientName = 'Carrot'
) AS RecipeIDTable
INNER JOIN Recipe_Ingredients ON RecipeIDTable.RecipeID = Recipe_Ingredients.RecipeID
INNER JOIN Ingredients ON Recipe_Ingredients.IngredientID = Ingredients.IngredientID
```

书中示例，返回 16 条

```sql
SELECT
	Recipes.RecipeID,
	Recipes.RecipeTitle,
	Ingredients.IngredientName
FROM(
	(
		Recipes
		INNER JOIN Recipe_Ingredients
		ON Recipes.RecipeID = Recipe_Ingredients.RecipeID
	)
	INNER JOIN Ingredients ON Ingredients.IngredientID = Recipe_Ingredients.IngredientID
)
INNER JOIN (
	SELECT Recipe_Ingredients.RecipeID
	FROM Ingredients
	INNER JOIN Recipe_Ingredients ON Ingredients.IngredientID = Recipe_Ingredients.IngredientID
	WHERE Ingredients.IngredientName = 'Carrot'
) AS Carrots ON Recipes.RecipeID = Carrots.RecipeID
```

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.6 使用内连接，列出所有属于沙拉的菜品</summary>

返回 1 条记录：

```sql
select Recipes.RecipeTitle
from Recipes
inner join Recipe_Classes
on Recipes.RecipeClassID = Recipe_Classes.RecipeClassID
where Recipe_Classes.RecipeClassDescription = 'Salad';
```

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.6 使用内连接，列出所有包含奶制品的菜品</summary>

返回 2 条记录：

```sql

```

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.6 使用内连接，找出默认度量单位相同的食材</summary>

同一张表自连接，需要排除主键 ID 相同的行。

返回 628 条记录：

```sql
select DISTINCT *
from Ingredients A
inner join Ingredients B
on A.MeasureAmountID = B.MeasureAmountID
and A.IngredientID != B.IngredientID;
```

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.6 使用内连接，显示包含牛肉和大蒜的菜品</summary>

拆分需求，包含牛肉食材的菜品和包含大蒜菜品食材的交集。

返回 1 条记录：

```sql
select A.RecipeTitle from (
  select DISTINCT Recipes.RecipeTitle, Recipes.RecipeID
  from Recipes
  inner join Recipe_Ingredients
  on Recipes.RecipeID = Recipe_Ingredients.RecipeID
  inner join Ingredients
  on Recipe_Ingredients.IngredientID = Ingredients.IngredientID
  where Ingredients.IngredientName = 'Beef'
) as A
inner join
(
  select DISTINCT Recipes.RecipeTitle, Recipes.RecipeID
  from Recipes
  inner join Recipe_Ingredients
  on Recipes.RecipeID = Recipe_Ingredients.RecipeID
  inner join Ingredients
  on Recipe_Ingredients.IngredientID = Ingredients.IngredientID
  where  Ingredients.IngredientName = 'Garlic'
) AS B
on A.RecipeID = B.RecipeID
```

可以优化一下结构:

```sql

select DISTINCT Recipes.RecipeTitle, Recipes.RecipeID
from Recipes
inner join Recipe_Ingredients
on Recipes.RecipeID = Recipe_Ingredients.RecipeID
inner join Ingredients
on Recipe_Ingredients.IngredientID = Ingredients.IngredientID
inner join (
  select DISTINCT Recipes.RecipeTitle, Recipes.RecipeID
  from Recipes
  inner join Recipe_Ingredients
  on Recipes.RecipeID = Recipe_Ingredients.RecipeID
  inner join Ingredients
  on Recipe_Ingredients.IngredientID = Ingredients.IngredientID
  where  Ingredients.IngredientName = 'Garlic'
) AS A
on A.RecipeID = Recipes.RecipeID
where Ingredients.IngredientName = 'Beef';
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.2 使用外连接，列出所有的菜品类型以及各类型包含的菜品</summary>

查询 Recipes 表，返回 15 条记录：

```sql
select * from Recipes;
```

返回 16 行记录：

```sql
select RecipeClassDescription, RecipeTitle from Recipe_Classes
left outer join Recipes
on Recipe_Classes.RecipeClassID = Recipes.RecipeClassID;
```

使用 Recipe_Classes 分类表作为左表进行查询，除了两张表 **`交集`** 的 15 条菜品记录外，还多出了 1 条分类记录，该记录没有任何分类。

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.2 使用外连接，列出不包含任何菜品的菜品类型</summary>

```sql
select RecipeClassDescription, RecipeTitle from Recipe_Classes
left outer join Recipes
on Recipe_Classes.RecipeClassID = Recipes.RecipeClassID
where Recipes.RecipeID is null;
```

使用 Recipe_Classes 分类表作为左表进行查询，除了两张表 **`交集`** 的 15 条菜品记录外，还多出了 1 条分类记录，该记录没有任何分类。

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.2 使用外连接，列出菜品类型为沙拉 Salad，汤类 Soups 和主菜 Main course 类型的菜品</summary>

返回 9 条记录：

```sql
select Recipe_Classes.RecipeClassDescription, Recipes.RecipeTitle
from Recipe_Classes
left outer join Recipes
on Recipe_Classes.RecipeClassID =  Recipes.RecipeClassID
where Recipe_Classes.RecipeClassDescription = 'Salad'
or Recipe_Classes.RecipeClassDescription = 'Soup'
or Recipe_Classes.RecipeClassDescription = 'Main course';
```

书中示例，返回 9 条记录：

```sql
SELECT
	RCFiltered.RecipeClassDescription,
	R.RecipeTitle
FROM
	(
	SELECT
		RecipeClassID,
		RecipeClassDescription
	FROM
		Recipe_Classes
	WHERE
		Recipe_Classes.RecipeClassDescription = 'Salad'
		OR Recipe_Classes.RecipeClassDescription = 'Soup'
		OR Recipe_Classes.RecipeClassDescription = 'Main Course'
	) AS RCFiltered
	LEFT OUTER JOIN Recipes AS R ON RCFiltered.RecipeClassID = R.RecipeClassID
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.2 使用外连接，列出菜品类型为沙拉 Salad，汤类 Soups 和主菜 Main course 类型的菜品，并且菜品名称中含有 beef。</summary>

使用不同的查询方式，返回的记录数不一样，但都包含一条 `Main course | Roast Beef` 的记录。

```sql
SELECT RCFiltered.RecipeClassDescription, R.RecipeTitle
              FROM
                  (SELECT RecipeClassID,
                      RecipeClassDescription
                  FROM Recipe_Classes AS RC
                  WHERE RC.RecipeClassDescription = 'Salads'
                      OR RC.RecipeClassDescription = 'Soup'
                      OR RC.RecipeClassDescription = 'Main Course') AS RCFiltered
              LEFT OUTER JOIN
                  (SELECT Recipes.RecipeClassID, Recipes.RecipeTitle
										FROM Recipes
                  WHERE Recipes.RecipeTitle LIKE '%beef%')
                AS R
              ON RCFiltered.RecipeClassID = R.RecipeClassID
```

```sql
SELECT Recipe_Classes.RecipeClassDescription,
       Recipes.RecipeTitle
    FROM Recipe_Classes
    LEFT OUTER JOIN Recipes
    ON Recipe_Classes.RecipeClassID =
       Recipes.RecipeClassID
    AND
       (Recipe_Classes.RecipeClassDescription = 'Salads'
    OR Recipe_Classes.RecipeClassDescription = 'Soup'
    OR Recipe_Classes.RecipeClassDescription =
       'Main Course')
    AND Recipes.RecipeTitle LIKE '%beef%'
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.2 使用外连接，从 Recipes 数据库中获取所有的菜品类型以及各类型中菜品的名称、制作说明、食材名、食材序 号、食材数量和食材度量单位，并按菜品名和序号排序</summary>

返回 88 条记录：

```sql
select
Recipe_Classes.RecipeClassDescription,
Recipes.RecipeTitle
from Recipe_Classes
left join Recipes
on Recipe_Classes.RecipeClassID = Recipes.RecipeClassID
inner join Recipe_Ingredients
on Recipes.RecipeID = Recipe_Ingredients.RecipeID
inner join Ingredients
on Recipe_Ingredients.IngredientID = Ingredients.IngredientID
```

书中示例，返回 88 条记录：

```sql
SELECT
	Recipe_Classes.RecipeClassDescription,
	Recipes.RecipeTitle,
	Recipes.Preparation,
	Ingredients.IngredientName,
	Recipe_Ingredients.RecipeSeqNo,
	Recipe_Ingredients.Amount,
	Measurements.MeasurementDescription
FROM
	(((
				Recipe_Classes
				LEFT OUTER JOIN Recipes ON Recipe_Classes.RecipeClassID = Recipes.RecipeClassID
				)
			INNER JOIN Recipe_Ingredients ON Recipes.RecipeID = Recipe_Ingredients.RecipeID
			)
		INNER JOIN Ingredients ON Ingredients.IngredientID = Recipe_Ingredients.IngredientID
	)
	INNER JOIN Measurements ON Measurements.MeasureAmountID = Recipe_Ingredients.MeasureAmountID
ORDER BY
	RecipeTitle,
	RecipeSeqNo
```

其中 Soup 分类是没有菜品的，上述 SQL 在第一个 left join 后使用了 inner join，导致菜品 Soup 分类数据丢失，如果需要这个 `空行`，则可以将 inner join 统统修改为 left join

返回 89 条记录：

```sql
select
Recipe_Classes.RecipeClassDescription,
Recipes.RecipeTitle
from Recipe_Classes
left join Recipes
on Recipe_Classes.RecipeClassID = Recipes.RecipeClassID
left join Recipe_Ingredients
on Recipes.RecipeID = Recipe_Ingredients.RecipeID
left join Ingredients
on Recipe_Ingredients.IngredientID = Ingredients.IngredientID
```

| RecipeClassDescription | RecipeTitle   |
| ---------------------- | ------------- |
| ...                    | ...           |
| Dessert                | Coupe Colonel |
| Soup                   |               |

> [!CAUTION]
> 需要注意，外连接只在 1 对多关系时才会按照预期那样工作，而 Recipes, Recipe_Classes 是 1 对多 Recipe_Classes，Recipe_Ingredients 是 1 对多的关系，所以下面书中示例并没有像我所给出示例那样，全部使用内连接，从而导致 Soup 信息的丢失，而我上面全部使用 left join 也并不会影响数据。

书中示例，返回 **`88`** 条记录：

```sql
SELECT Recipe_Classes.RecipeClassDescription, Recipes.RecipeTitle, Recipes.Preparation,
Ingredients.IngredientName,Recipe_Ingredients.RecipeSeqNo,
Recipe_Ingredients.Amount,Measurements.MeasurementDescription
FROM (
	(
		(
			Recipe_Classes
      LEFT OUTER JOIN Recipes
      ON Recipe_Classes.RecipeClassID =Recipes.RecipeClassID
		)
    LEFT OUTER JOIN Recipe_Ingredients
    ON Recipes.RecipeID = Recipe_Ingredients.RecipeID
	)
	INNER JOIN Ingredients
  ON Ingredients.IngredientID = Recipe_Ingredients.IngredientID
)
INNER JOIN Measurements
ON Measurements.MeasureAmountID = Recipe_Ingredients.MeasureAmountID
ORDER BY RecipeTitle, RecipeSeqNo
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.7 使用外连接，列出未在任何菜品中使用的食材</summary>

返回 20 条记录：

```sql
select Ingredients.IngredientName
from Ingredients
left join (
	Recipes
	inner join Recipe_Ingredients
	on Recipes.RecipeID = Recipe_Ingredients.RecipeID
)
on Ingredients.IngredientID = Recipe_Ingredients.IngredientID
where Recipe_Ingredients.RecipeId is NULL;
```

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.7 使用全外连接，从 Recipes 数据库中获取所有的菜品类型、所有的菜品名以及各个菜品的食材序号、食材数量和食材度量单位，还有所有的食材名，并依次按菜品类型描述降序、菜品名和食材序列号升序排列</summary>

需求分析，主要保留所有菜品类型，也就是 Recipe_Classes 全表数据，所有的菜品名，也就是 Recipes 全表数据，Recipe_Classes 和 Recipes 是 1 对多的关系，所以 inner join 和 left/right join 都不符合，只有全外连接 full outer join 适用。

<img src="./imgs/demo9-5.png"/>

观察图中 1 部分，从左到右整个链条都是 1 对多，可以看成一个整体。

观察图中 2 部分，两张表是 1 对多关系，可以看成一个整体。

这两个整体，也就是 2 部分 和 1 部分是 1 对多关系，观察 Ingredients 和 Recipe_Ingredients。

所以首先处理第 1 部分，Recipe_Classes 和 Recipes 全外连接，保留两张表的数据，将这个结果集左外连接 Recipe_Ingredients，保留左边结果集的 NULL 行。

Measurements 和 第 1 部分是 1 对多，实际上反过来，第 1 部分和 Measurements 是 1 对 1 的关系，可以无关紧要的内连接一下。

第二部分由于需求中没有使用到食材的分类，所以两张表不用外连接，因为没说要全部的食材和食材分类，所以不需要全外连接，以至把所有食材和所有食材分类都保存。

然后第 2 部分和 第 1 部分是 1 对多关系，为了保全两张表的全部信息，所以要全外连接。

返回 109 条记录，由于 MySQL 不支持全外连接，所以需要自己转换 SQL：

```sql
SELECT
	Recipe_Classes.RecipeClassDescription,
	Recipes.RecipeTitle,
	Ingredients.IngredientName,
	Recipe_Ingredients.RecipeSeqNo,
	Recipe_Ingredients.Amount,
	Measurements.MeasurementDescription
FROM
	(
		(
			(
				Recipe_Classes
				FULL OUTER JOIN Recipes ON Recipe_Classes.RecipeClassID = Recipes.RecipeClassID
			)
			LEFT OUTER JOIN Recipe_Ingredients ON Recipes.RecipeID = Recipe_Ingredients.RecipeID
		)
		INNER JOIN Measurements ON Measurements.MeasureAmountID = Recipe_Ingredients.MeasureAmountID
	)
	FULL OUTER JOIN Ingredients
	ON Ingredients.IngredientID = Recipe_Ingredients.IngredientID
	and Recipe_Classes.RecipeClassID = Recipes.RecipeClassID
ORDER BY
	RecipeClassDescription DESC,
	RecipeTitle,
	RecipeSeqNo
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.7 使用外连接，显示不包含任何菜品的菜品类型</summary>

返回 1 条记录：

```sql
select Recipe_Classes.RecipeClassID, Recipe_Classes.RecipeClassDescription
from Recipe_Classes
left join Recipes
on Recipes.RecipeClassID = Recipe_Classes.RecipeClassID
where Recipes.RecipeClassID is NULL;
```

书中示例返回 1 条记录，参考 CH09_Recipe_Classes_No_Recipes

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.7 使用外连接，显示所有的食材及其被用来制作的菜品</summary>

返回 108 条记录：

```sql
select Ingredients.IngredientName, Recipes.RecipeTitle
from Ingredients
left join (
	Recipes
	inner join Recipe_Ingredients
	on Recipes.RecipeID = Recipe_Ingredients.RecipeID
)
on Ingredients.IngredientID = Recipe_Ingredients.IngredientID;
```

书中示例返回 108 条记录，参考 CH09_All_Ingredients_Any_Recipes

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.7 使用外连接，列出菜品类型 Salad(沙拉)、Soup(汤菜)和 Main course(主菜)及其包含的菜品</summary>

返回 9 条记录：

```sql
select * from Recipe_Classes
left join Recipes
on Recipes.RecipeClassID = Recipe_Classes.RecipeClassID
where RecipeClassDescription in ('Soup','Salad','Main course')

```

书中示例返回 9 条记录，参考 CH09_Salad_Soup_Main_Courses

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.7 使用外连接，显示所有的菜品类型及其包含的菜品</summary>

返回 16 条记录：

```sql
select * from Recipe_Classes
left join Recipes
on Recipes.RecipeClassID = Recipe_Classes.RecipeClassID
```

书中示例返回 16 条记录，参考 CH09_All_RecipeClasses_And_Matching_Recipes

</details>
