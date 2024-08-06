---
hidden: true
date: 2024-08-06 06:00:21
---

# RecipesExample

RecipesExample 是 `SQL 查询：从入门到实践（第４版）` 提供的示例数据库。

## 导入数据

使用 `shcema.SQL` 文件导入建表语句，使用 `data.SQL` 导入数据，使用 `views.SQL` 导入视图等文件，对于 `views.SQL` 创建视图文件，也可以暂时不导入。

> [!CAUTION]
> 对于 DrawSQL 而言，无法正确导入书籍提供的建表语句，可以使用 `schema-for-drawsql.sql` 文件。

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

或者直接访问 [DrawSQL](https://drawsql.app/teams/sql-404/diagrams/recipesexample)，查看 ERD 关系图。

## 表字段注释

数据库包含 6 张表：

- `Recipes`
  - `RecipeID` 菜品 ID
  - `RecipeTitle` 菜品名称
  - `RecipeClassID` 菜品分类 ID
  - `Preparation` 菜品制作方法
  - `Notes` 菜品提示
- `Recipe_Classes`
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
  - `RecipeSeqNo` 顺序
  - `MeasureAmountID` 计量单位 ID
  - `Amount` 食材用量用量
- `Measurements` 计量单位表
  - `MeasureID` 计量单位 ID
  - `MeasurementDescription` 计量单位名称

## 练习

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.2.3-2 使用内连接，列出数据库中所有菜品的名称，制作方法和菜品类型描述</summary>

```sql
select RecipeTitle, RecipeClassDescription, Preparation
from Recipes
inner join Recipe_Classes
on Recipe_Classes.RecipeClassID = Recipes.RecipeClassID;
```

```sql
select RecipeTitle, RecipeClassDescription, Preparation
from Recipes, Recipe_Classes
where Recipe_Classes.RecipeClassID = Recipes.RecipeClassID;
```

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.2.3-2 使用内连接，列出数据库中菜品分类为主菜 Main course 或者甜品 Dessert 的菜品的名称，制作方法和菜品类型描述</summary>

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

```sql
select RecipeTitle, IngredientName
from Recipes
INNER JOIN Recipe_Ingredients
on Recipes.RecipeID = Recipe_Ingredients.RecipeID
inner join Ingredients
on Recipe_Ingredients.IngredientID = Ingredients.IngredientID;
```

书中示例：

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

书中示例：

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

书中示例：

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
