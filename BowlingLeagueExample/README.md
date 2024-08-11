---
hidden: true
date: 2024-08-06 06:00:21
---

# BowlingLeagueExample

BowlingLeagueExample 是 `SQL 查询：从入门到实践（第４版）` 提供的示例数据库。

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

或者直接访问 [DrawSQL](https://drawsql.app/teams/sql-404/diagrams/bowlingleagueexample)，查看 ERD 关系图。

## 表字段注释

数据库包含 9 张表：

- `Bowlers` 球员表
  - `BowlerID` 投手的唯一标识符。
  - `BowlerLastName` 投手的姓氏。
  - `BowlerFirstName` 投手的名字。
  - `BowlerMiddleInit` 投手的中间名首字母。
  - `BowlerAddress` 投手的地址。
  - `BowlerCity` 投手所在的城市。
  - `BowlerState` 投手所在的州。
  - `BowlerZip` 投手的邮政编码。
  - `BowlerPhoneNumber` 投手的电话号码。
  - `TeamID` 投手所属的队伍标识符。
- `Tournaments` 联赛
  - `ToryneyID` 联赛 ID
  - `ToryneyDate` 联赛日期
  - `ToryneyLocation` 联赛地点
- `Tourney_Matches` 联赛场次
  - `MatchID` 联赛场次 ID
  - `TourneyID` 联赛 ID
  - `Lanes` 保龄球道标记
  - `EvenLaneTeamID` 保龄球道 偶数球队
  - `OaddLaneTeamID` 保龄球道 奇数球队
- `Match_Games` 每场次的比赛回合
  - `MatchID` 联赛场次 ID
  - `GameNumber` 该比赛场次回合数
  - `WinningTeamID` 该比赛场次胜利团队 ID
- `Bowler_Scores` 该比赛场次胜利团队 ID
  - `MatchID` 比赛的唯一标识符。
  - `GameNumber` 比赛中的游戏编号。
  - `BowlerID` 投手的唯一标识符。
  - `RawScore` 投手的实际得分。
  - `HandiCapScore` 让分得分，加权得，室内联赛让步优待分
  - `WonGame` 是否赢得比赛，0 表示否，1 表示是
- `Teams` 存储队伍信息。
  - `TeamID` 队伍的唯一标识符。
  - `TeamName` 队伍的名称。
  - `CaptainID`队长的标识符
- `ztblBowlerRatings` 存储投手的评分信息。
  - `BowlerRating` 投手的评分描述，如 "Beginner"、"Pro"。
  - `BowlerLowAvg` 投手的最低平均分。
  - `BowlerHighAvg` 投手的最高平均分。
- `ztblSkipLabels` 用于生成跳过标签的信息。
  - `LabelCount` 标签的数量。
- `ztblWeeks` 存储每周的起始和结束日期。
  - `WeekStart` 每周的开始日期。
  - `WeekEnd` 每周的结束日期。

## 练习

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.4.1 使用内连接，列出保龄球队及其队长的姓名</summary>

返回 10 条记录：

```sql
SELECT
Teams.TeamName,
concat(Bowlers.BowlerLastName, ', ', Bowlers.BowlerFirstName) AS CaptainName
FROM Teams
INNER JOIN Bowlers
ON Teams.CaptainID = Bowlers.BowlerID;
```

书中示例同上，可参考 view.sql 文件中 CH08_Teams_And_Captains。

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">

<summary markdown="span">#8.4.2 使用内连接，列出所有的保龄球联赛、场次和各局的结果 </summary>

为了列举比赛双方，需要 3 次连表 Team，获取双方的队名，及胜利队的队名。

返回 168 条记录：

```sql
SELECT
    Tournaments.TourneyID,
    Tournaments.TourneyDate,
    Tournaments.TourneyLocation,
		Tourney_Matches.MatchID,
    Tourney_Matches.Lanes,
		OddTeam.TeamName as OddTeamName,
		EvenTeam.TeamName as EvenTeamName,
    Match_Games.GameNumber,
    Match_Games.WinningTeamID,
		WinnerTeam.TeamName
FROM Tournaments
JOIN Tourney_Matches ON Tournaments.TourneyID = Tourney_Matches.TourneyID
JOIN Match_Games  ON Tourney_Matches.MatchID = Match_Games.MatchID
inner join Teams EvenTeam on Tourney_Matches.EvenLaneTeamID = EvenTeam.TeamID
inner join Teams OddTeam on Tourney_Matches.OddLaneTeamID = OddTeam.TeamID
inner join Teams WinnerTeam on Match_Games.WinningTeamID = WinnerTeam.TeamID
order by
Tournaments.TourneyDate,
Tourney_Matches.MatchID;
```

书中示例，返回 168 条记录，可参考 view.sql CH08_Tournament_Match_Game_Results：

为了获取比赛双方和赢家的队名，需要连 Team 表 3 次

```sql
SELECT
Tournaments.TourneyID AS Tourney,
Tournaments.TourneyLocation AS Location,
Tourney_Matches.MatchID,
Tourney_Matches.Lanes,
OddTeam.TeamName AS OddLaneTeam,
EvenTeam.TeamName AS EvenLaneTeam,
Match_Games.GameNumber AS GameNo,
Winner.TeamName AS Winner
FROM (
  (
    (
      (
        Tournaments
        INNER JOIN Tourney_Matches
        ON Tournaments.TourneyID = Tourney_Matches.TourneyID
      )
      INNER JOIN Teams AS OddTeam
      ON OddTeam.TeamID = Tourney_Matches.OddLaneTeamID
    )
    INNER JOIN Teams AS EvenTeam
    ON EvenTeam.TeamID = Tourney_Matches.EvenLaneTeamID
  )
  INNER JOIN Match_Games
  ON Match_Games.MatchID = Tourney_Matches.MatchID
)
INNER JOIN Teams AS Winner
ON Winner.TeamID = Match_Games.WinningTeamID;
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.4.3 **`思路1`** 使用内连接，找出在保龄球馆 Thunderbird Lanes 和 Bolero Lanes 比赛时，原始得分都不低于 170 的投球手 </summary>

可以将需求拆分成两部分，先找出在保龄球馆 Thunderbird Lanes 内原始得分不低于 170 的投球手，然后再找到在保龄球馆 Bolero Lanes 内原始得分不低于 170 的投球手。

从 DrawSQL 的 ERD 关系图上看，我们顺着保龄球联赛表 Tourments 的关系从左往右走过去，首先 inner join 联赛比赛表 Tourney_Matchney_Matches 表，获得所有联赛以及所有比赛场次信息，再继续 inner join 比赛回合表，这样就得出了所有场次的比赛回合信息，接着 inner join 比赛分数表，获取了每个回合比赛的分数，这样就拿到了所有联赛所有场次所有回合的比赛分数，然后再连上保龄球员 Bowlers 表，就获取到每个回合的分数所对应的球员，再加上 filter condition，就能获取到具体信息。最后，将两个集合取交集就能得出结果。

> [!NOTE]
> 看完下面思路 2，发现思路 1 的 Match_Games 表也可以不连，虽然不符合直觉逻辑，但不影响结果。

> [!CAUTION]
> 如果查询出错，可能需要设置 `set GLOBAL max_allowed_packet = 1024 * 1024 * 1`

返回 11 条记录：

```sql
select distinct A.BowlerID, A.BowlerFirstName, A.BowlerLastName
from (
	select distinct Bowlers.BowlerID, Bowlers.BowlerFirstName, Bowlers.BowlerLastName,
	Bowler_Scores.RawScore, Bowler_Scores.WonGame
	from Tournaments
	inner join Tourney_Matches
	on Tournaments.TourneyID = Tourney_Matches.TourneyID
	inner join Match_Games
	on Match_Games.MatchID = Tourney_Matches.MatchID
	inner join Bowler_Scores
	on Match_Games.MatchID = Bowler_Scores.MatchID and Match_Games.GameNumber = Bowler_Scores.GameNumber -- [!code ++] 注意这里主键是两个字段！
	inner join Bowlers
	on Bowler_Scores.BowlerID = Bowlers.BowlerID
	where Tournaments.TourneyLocation = 'Thunderbird Lanes' and Bowler_Scores.RawScore > 170
) as A
inner join (
	select distinct Bowlers.BowlerID, Bowlers.BowlerFirstName, Bowlers.BowlerLastName,
	Bowler_Scores.RawScore, Bowler_Scores.WonGame
	from Tournaments
	inner join Tourney_Matches
	on Tournaments.TourneyID = Tourney_Matches.TourneyID
	inner join Match_Games
	on Match_Games.MatchID = Tourney_Matches.MatchID
	inner join Bowler_Scores
	on Match_Games.MatchID = Bowler_Scores.MatchID and Match_Games.GameNumber = Bowler_Scores.GameNumber -- [!code ++] 注意这里主键是两个字段！
	inner join Bowlers
	on Bowler_Scores.BowlerID = Bowlers.BowlerID
	where Tournaments.TourneyLocation = 'Bolero Lanes' and Bowler_Scores.RawScore > 170
) as B
	on A.BowlerID = B.BowlerID;
```

无书中示例。

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.4.3 **`思路2`** 使用内连接，找出在保龄球馆 Thunderbird Lanes 和 Bolero Lanes 比赛时，原始得分都不低于 170 的投球手 </summary>

从 DrawSQL ERD 关系图上看，我们从右侧的 Bowler 球员来入手，inner join 球员分数表 Bowler_Scores 表，直接就能拿到所有球员的分数信息，接下来只要找到比赛对应的场地即可。我们发现 Bowler_Scores 的比赛 ID MatchID 直接就可以和联赛场次 Tourney_Match 关联起来，直接跳过联赛场次回合表 Match_Games，就可以省去一张表

> [!CAUTION]
> 如果查询出错，可能需要设置 `set GLOBAL max_allowed_packet = 1024 * 1024 * 1`

```sql
select distinct A.BowlerID, A.BowlerFirstName, A.BowlerLastName
from (
	select distinct Bowlers.BowlerID, Bowlers.BowlerFirstName, Bowlers.BowlerLastName,
	Bowler_Scores.RawScore, Bowler_Scores.WonGame
	from Bowlers
	inner join Bowler_Scores
	on Bowler_Scores.BowlerID = Bowlers.BowlerID
	inner join Tourney_Matches
	on Bowler_Scores.MatchID = Tourney_Matches.MatchID
	inner join Tournaments
	on Tournaments.TourneyID = Tourney_Matches.TourneyID
	where Tournaments.TourneyLocation = 'Thunderbird Lanes' and Bowler_Scores.RawScore > 170
) as A
inner join (
	select distinct Bowlers.BowlerID, Bowlers.BowlerFirstName, Bowlers.BowlerLastName,
	Bowler_Scores.RawScore, Bowler_Scores.WonGame
	from Bowlers
	inner join Bowler_Scores
	on Bowler_Scores.BowlerID = Bowlers.BowlerID
	inner join Tourney_Matches
	on Bowler_Scores.MatchID = Tourney_Matches.MatchID
	inner join Tournaments
	on Tournaments.TourneyID = Tourney_Matches.TourneyID
	where Tournaments.TourneyLocation = 'Bolero Lanes' and Bowler_Scores.RawScore > 170
) as B
	on A.BowlerID = B.BowlerID;
```

书中示例，返回 11 条结果，可参考 view.sql 文件中 CH08_Good_Bowlers_TBird_And_Bolero：

```sql
SELECT
	BowlerTbird.BowlerFullName
FROM
	(
	SELECT DISTINCT
		Bowlers.BowlerID,
		concat( Bowlers.BowlerLastName, ', ', Bowlers.BowlerFirstName ) AS BowlerFullName
	FROM
		((
				Bowlers
				INNER JOIN Bowler_Scores ON Bowlers.BowlerID = Bowler_Scores.BowlerID
				)
			INNER JOIN Tourney_Matches ON Tourney_Matches.MatchID = Bowler_Scores.MatchID
		)
		INNER JOIN Tournaments ON Tournaments.TourneyID = Tourney_Matches.TourneyID
	WHERE
		Tournaments.TourneyLocation = 'Thunderbird Lanes'
		AND Bowler_Scores.RawScore >= 170
	) AS BowlerTbird
	INNER JOIN (
	SELECT DISTINCT
		Bowlers.BowlerID,
		concat( Bowlers.BowlerLastName, ', ', Bowlers.BowlerFirstName ) AS BowlerFullName
	FROM
		((
				Bowlers
				INNER JOIN Bowler_Scores ON Bowlers.BowlerID = Bowler_Scores.BowlerID
				)
			INNER JOIN Tourney_Matches ON Tourney_Matches.MatchID = Bowler_Scores.MatchID
		)
		INNER JOIN Tournaments ON Tournaments.TourneyID = Tourney_Matches.TourneyID
	WHERE
		Tournaments.TourneyLocation = 'Bolero Lanes'
	AND Bowler_Scores.RawScore >= 170
	) AS BowlerBolero ON BowlerTbird.BowlerID = BowlerBolero.BowlerID
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.6 使用内连接，列出所有保龄球队及其队员</summary>

返回 32 条记录：

```sql
select TeamName, Bowlers.BowlerFirstName, Bowlers.BowlerLastName
from Teams
inner join Bowlers
on Teams.TeamID = Bowlers.TeamID;
```

书中示例如上，可参考 view.sql 文件中的 CH08_Teams_And_Bowlers

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.6 使用内连接，显示投球手及其参加的比赛场次和得分</summary>

返回 1344 条记录：

```sql
select
Bowlers.BowlerFirstName,
Bowlers.BowlerLastName,
Tourney_Matches.Lanes,
Tourney_Matches.TourneyID,
Bowler_Scores.RawScore
from Bowlers
inner join Bowler_Scores
on Bowlers.BowlerID = Bowler_Scores.BowlerID
inner join Tourney_Matches
on Bowler_Scores.MatchID = Tourney_Matches.MatchID
```

书中示例如上，可参考 view.sql 文件中的 CH08_Bowler_Game_Scores

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#8.6 使用内连接，找出居住地邮政编码相同的投球手</summary>

同一张表连接，注意排除主键相同的行。

返回 92 条记录：

```sql
select
CONCAT(A.BowlerFirstName,',',A.BowlerLastName) as BowlerName_A,
CONCAT(B.BowlerFirstName,',',B.BowlerLastName) as BowlerName_B,
A.BowlerZip
from Bowlers AS A
inner join Bowlers as B
on A.BowlerZip = B.BowlerZip
and A.BowlerID != B.BowlerID;
```

书中示例如上，可参考 view.sql 文件中的 CH08_Bowlers_Same_ZipCode

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.5 使用外连接，列出还未举行的联赛</summary>

如果比赛场次表 Tourney_Matches 还没有联赛 Tournaments 的场次 Matches，则说明联赛还未举行。

这个说法其实不太正确，但书中是这样理解的。

返回 6 条记录：

```sql
select Tournaments.*
from Tournaments
left join Tourney_Matches
on Tournaments.TourneyID = Tourney_Matches.TourneyID
where Tourney_Matches.MatchID is NULL;
```

书中示例同上，可参考 view.sql 文件中 CH09_Tourney_Not_Yet_Played。

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.5 使用外连接，列出所有的投球手及其得分超过 180 的比赛场次</summary>

需求分析，本次查询一共涉及 5 张表，其中 `Tournaments->Tourney_Matches->Match_Games` 都是 1 对多的关系，可以适用内连接和左外连接，而 `Match_Games` 和 `Bowlers` 是多对多关系 `Bowler_Scores` 是他们的中间表，于是 `Tournaments->Tourney_Matches->Match_Games->Bowler_Scores` 都是一对多的关系，只要将这 4 张表内连接起来，Bowlers 和 4 张表的结果集还是 1 对多关系，适用左外连接。

返回 106 条记录：

```sql
select
Bowlers.BowlerID, Bowlers.BowlerFirstName, Bowlers.BowlerLastName,
BowlerScore.RawScore, BowlerScore.TourneyDate, BowlerScore.TourneyLocation
from Bowlers
left join (
	select Bowler_Scores.BowlerID, Bowler_Scores.RawScore,
	Tournaments.TourneyDate, Tournaments.TourneyLocation
	from Tournaments
	inner join Tourney_Matches
	on Tournaments.TourneyID = Tourney_Matches.TourneyID
	inner join Match_Games
	on Tourney_Matches.MatchID = Match_Games.MatchID
	inner join Bowler_Scores
	on Match_Games.MatchID = Bowler_Scores.MatchID
	and Match_Games.GameNumber = Bowler_Scores.GameNumber
	where Bowler_Scores.RawScore > 180
) as BowlerScore
on BowlerScore.BowlerID = Bowlers.BowlerID;
```

书中示例，返回 106 行记录，可参考 view.sql 文件中 CH09_All_Bowlers_And_Scores_Over_180：

```sql
SELECT
	Bowlers.BowlerLastName || ', ' || Bowlers.BowlerFirstName AS BowlerName,
	TI.TourneyDate,
	TI.TourneyLocation,
	TI.MatchID,
	TI.RawScore
FROM
	Bowlers
	LEFT OUTER JOIN (
		SELECT
		Tournaments.TourneyDate,
		Tournaments.TourneyLocation,
		Bowler_Scores.MatchID,
		Bowler_Scores.BowlerID,
		Bowler_Scores.RawScore
		FROM
		(
			Bowler_Scores
			INNER JOIN Tourney_Matches
			ON Bowler_Scores.MatchID = Tourney_Matches.MatchID
		)
		INNER JOIN Tournaments
		ON Tournaments.TourneyID = Tourney_Matches.TourneyID
		WHERE Bowler_Scores.RawScore > 180
	) AS TI
	ON Bowlers.BowlerID = TI.BowlerID;
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.7 使用外连接，显示没有比赛数据的场次</summary>

返回 1 行：

```sql
select *
from Tourney_Matches
left join Match_Games
ON Tourney_Matches.MatchID = Match_Games.MatchID
where Match_Games.MatchID is NULL;
```

书中示例，返回 1 行，可参考 view.sql 文件中的 CH09_Matches_Not_Played_Yet：

```sql
SELECT
	Tourney_Matches.MatchID,
	Tourney_Matches.TourneyID,
	Teams.TeamName AS OddLaneTeam,
	Teams_1.TeamName AS EvenLaneTeam
FROM Teams Teams_1
INNER JOIN (
	Teams
	INNER JOIN (
		Tourney_Matches
		LEFT OUTER JOIN Match_Games
		ON Tourney_Matches.MatchID = Match_Games.MatchID
	)
	ON Teams.TeamID = Tourney_Matches.OddLaneTeamID
)
ON Teams_1.TeamID = Tourney_Matches.EvenLaneTeamID
WHERE Match_Games.MatchID IS NULL;
```

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#9.7 使用外连接，显示所有的联赛及其已举行的比赛场次</summary>

**`错误示例`**，返回 175 行：

```sql
-- 这是错误示例
select *
from Tournaments
left join Tourney_Matches
on Tournaments.TourneyID = Tourney_Matches.TourneyID
left join Match_Games
on Match_Games.MatchID = Tourney_Matches.MatchID;
```

之所以会错误，是因为联赛 Tournaments 有了比赛 id，也就是 Tourney_Matches 的记录之后，并没有开始比赛，也就是 Match_Games 表里还没有关联 MatchID 的记录。

所以 Tourney_Matches 有一个 TourneyID 为 57 的记录，并没有场次记录，所以它的比赛还没有开始，这和需求不符合，可以将 Tourney_Matches 和 Match_Games 的数据进行内连接，返回没有 NULL 也就是没有还未开始比赛场次的比赛。

正确示例，返回 174 行：

```sql
select
Tournaments.TourneyID,
	Tournaments.TourneyDate,
	Tournaments.TourneyLocation,
	Tourney_Matches.MatchID,
	Match_Games.GameNumber
from Tournaments
left join (
	Tourney_Matches
	inner join Match_Games
	on Match_Games.MatchID = Tourney_Matches.MatchID
)
on Tournaments.TourneyID = Tourney_Matches.TourneyID
```

书中示例，返回 174 行，可参考 view.sql 文件中的 CH09_Matches_Not_Played_Yet：

```sql
SELECT
	Tournaments.TourneyID,
	Tournaments.TourneyDate,
	Tournaments.TourneyLocation,
	TM.MatchID,
	TM.GameNumber,
	TM.Winner
FROM Tournaments
LEFT OUTER JOIN (
	SELECT
		Tourney_Matches.TourneyID,
		Tourney_Matches.MatchID,
		Match_Games.GameNumber,
		Teams.TeamName AS Winner
	FROM Tourney_Matches
	INNER JOIN (
		Teams
		INNER JOIN Match_Games
		ON Teams.TeamID = Match_Games.WinningTeamID
	)
	ON Tourney_Matches.MatchID = Match_Games.MatchID
) AS TM
ON Tournaments.TourneyID = TM.TourneyID
ORDER BY Tournaments.TourneyID;
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#10.4 使用 union all，列出哪些球队(球队的名称和队长)在哪些联赛场次中开始使用的是单数球道，哪些球队(球队的名称和队长)在哪些联赛场次中开始使用的是双数球道，并按联赛日期和场次编号排序</summary>

书中示例，返回 114 条记录，可参考 view.sql 文件中 CH10_Bowling_Schedule：

```sql
SELECT
	Tournaments.TourneyLocation,
	Tournaments.TourneyDate,
	Tourney_Matches.MatchID,
	Teams.TeamName,
	concat( Bowlers.BowlerLastName, ', ', Bowlers.BowlerFirstName ) AS Captain,
	'Odd Lane' AS Lane
FROM (
	(
		Tournaments
		INNER JOIN Tourney_Matches ON Tournaments.TourneyID = Tourney_Matches.TourneyID
		)
		INNER JOIN Teams ON Teams.TeamID = Tourney_Matches.OddLaneTeamID
)
INNER JOIN Bowlers ON Bowlers.BowlerID = Teams.CaptainID
UNION ALL
SELECT
	Tournaments.TourneyLocation,
	Tournaments.TourneyDate,
	Tourney_Matches.MatchID,
	Teams.TeamName,
	concat( Bowlers.BowlerLastName, ', ', Bowlers.BowlerFirstName ) AS Captain,
	'Even Lane' AS Lane
FROM (
	(
		Tournaments
		INNER JOIN Tourney_Matches ON Tournaments.TourneyID = Tourney_Matches.TourneyID
	)
	INNER JOIN Teams
	ON Teams.TeamID = Tourney_Matches.EvenLaneTeamID
)
INNER JOIN Bowlers
ON Bowlers.BowlerID = Teams.CaptainID
ORDER BY 2,3
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#11.5.1 列表达式中使用标量子查询，示所有的投球手及其最高得分</summary>

书中示例，返回 32 条记录，可参考 view.sql 文件中的 CH11_Bowler_High_Score：

```sql
SELECT
	Bowlers.BowlerFirstName,
	Bowlers.BowlerLastName,
	( SELECT MAX( RawScore ) FROM Bowler_Scores
		WHERE Bowler_Scores.BowlerID = Bowlers.BowlerID
	)
	AS HighScore
FROM Bowlers;
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#11.5.2 筛选器中使用子查询，显示让分得分比其球队中其他球员都高的队长</summary>

书中示例，返回 1 条记录，可参考 view.sql 文件中 CH11_Team_Captains_High_Score：

```sql
SELECT
	Teams.TeamName,
	Bowlers.BowlerID,
	Bowlers.BowlerFirstName,
	Bowlers.BowlerLastName,
	Bowler_Scores.HandiCapScore
FROM	(
		Bowlers
		INNER JOIN Teams ON Bowlers.BowlerID = Teams.CaptainID
)
INNER JOIN Bowler_Scores ON Bowlers.BowlerID = Bowler_Scores.BowlerID
WHERE Bowler_Scores.HandiCapScore > ALL (
	SELECT BS2.HandiCapScore
	FROM Bowlers AS B2
	INNER JOIN Bowler_Scores AS BS2 ON B2.BowlerID = BS2.BowlerID
	WHERE B2.BowlerID <> Bowlers.BowlerID
	AND B2.TeamID = Bowlers.TeamID
)
```

</details>

<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#11.7 使用子查询 TODO，显示所有的投球手及其参加的比赛局数</summary>

提示: 使用聚合函数 COUNT

书中示例，返回 32 条记录，可参考 view.sql 文件中 CH11_Bowlers_And_Count_Games:

```sql
SELECT
	BowlerFirstName,
	BowlerLastName,
	( SELECT COUNT(*) FROM Bowler_Scores
		WHERE Bowler_Scores.BowlerID = Bowlers.BowlerID
	) AS Games
FROM Bowlers;
```

</details>
<details style="padding: 8px 20px; margin-bottom: 20px; background-color: rgba(142, 150, 170, 0.14);">
<summary markdown="span">#11.7 使用子查询 TODO，列出原始得分比其球队中其他所有队员都低的投球手</summary>

提示: 使用< ALL 创建一个筛选器;另外，使用 DISTINCT，以防有投球手在多次比赛中的得分都一样低

书中示例，返回 3 条记录，可参考 view.sql 文件中 CH11_Bowlers_Low_Score:

```sql
SELECT DISTINCT
	Bowlers.BowlerID,
	Bowlers.BowlerFirstName,
	Bowlers.BowlerLastName,
	Bowler_Scores.RawScore
FROM Bowlers
INNER JOIN Bowler_Scores ON Bowlers.BowlerID = Bowler_Scores.BowlerID
WHERE Bowler_Scores.RawScore < ALL (
	SELECT BS2.RawScore FROM Bowlers
	AS B2
	INNER JOIN Bowler_Scores
	AS BS2
	ON B2.BowlerID = BS2.BowlerID
	WHERE B2.BowlerID <> Bowlers.BowlerID
	AND B2.TeamID = Bowlers.TeamID
);
```

</details>
