---
hidden: true
date: 2024-09-27 06:27:19
---

# z-blog

一共有 9 张表

- zbp_category 分类表
- zbp_comment 评论表
- zbp_config 插件配置表
- zbp_member 用户表
- zbp_module 模块表
- zbp_post 文章表
- zbp_tag 标签表
- zbp_upload 附件表
- zbp_app 应用表

分类表：

```sql
-- 分类表
CREATE TABLE zbp_category (
  cate_ID int(11) NOT NULL AUTO_INCREMENT,/*分类id*/
  cate_Name varchar(255) NOT NULL DEFAULT '',/*分类名称*/
  cate_Order int(11) NOT NULL DEFAULT '0',/*分类排序*/
  cate_Type tinyint(4) NOT NULL DEFAULT '0',
  cate_Count int(11) NOT NULL DEFAULT '0',/*文章数量*/
  cate_Alias varchar(255) NOT NULL DEFAULT '',/*文章别名*/
  cate_Intro text NOT NULL,/*分类摘要*/
  cate_RootID int(11) NOT NULL DEFAULT '0',/*分类的顶级id*/
  cate_ParentID int(11) NOT NULL DEFAULT '0',/*分类的上一级id*/
  cate_Template varchar(255) NOT NULL DEFAULT '',/*分类所用模板*/
  cate_LogTemplate varchar(255) NOT NULL DEFAULT '',/*分类下文章所用模板*/
  cate_Meta longtext NOT NULL,/*分类页扩展数据*/
  PRIMARY KEY (cate_ID),
  KEY zbp_cate_Order (cate_Order)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```

文章表：

```sql
CREATE TABLE zbp_post (
  log_ID int(11) NOT NULL AUTO_INCREMENT,/*文章id*/
  log_CateID int(11) NOT NULL DEFAULT '0',/*分类id*/
  log_AuthorID int(11) NOT NULL DEFAULT '0',/*作者id*/
  log_Tag varchar(255) NOT NULL DEFAULT '',/*标签id列表*/
  log_Status tinyint(4) NOT NULL DEFAULT '0',/*文章状态（0公开，1草稿，2审核）*/
  log_Type tinyint(4) NOT NULL DEFAULT '0',
  log_Alias varchar(255) NOT NULL DEFAULT '',/*别名*/
  log_IsTop int(11) NOT NULL DEFAULT '0',/*是否置顶*/
  log_IsLock tinyint(1) NOT NULL DEFAULT '0',/*是否锁定*/
  log_Title varchar(255) NOT NULL DEFAULT '',/*文章标题*/
  log_Intro text NOT NULL,/*文章摘要*/
  log_Content longtext NOT NULL,/*文章内容*/
  log_PostTime int(11) NOT NULL DEFAULT '0',/*发布时间（时间戳格式）*/
  log_CommNums int(11) NOT NULL DEFAULT '0',/*评论数量*/
  log_ViewNums int(11) NOT NULL DEFAULT '0',/*浏览量*/
  log_Template varchar(255) NOT NULL DEFAULT '',/*文章模板*/
  log_Meta longtext NOT NULL,/*meta扩展数据信息*/
  PRIMARY KEY (log_ID),
  KEY zbp_log_TPISC (log_Type,log_PostTime,log_IsTop,log_Status,log_CateID),
  KEY zbp_log_VTSC (log_ViewNums,log_Type,log_Status,log_CateID)
) ENGINE=MyISAM AUTO_INCREMENT=1415104 DEFAULT CHARSET=utf8;
```

标签表：

```sql
CREATE TABLE `zbp_tag` (
  tag_ID int(11) NOT NULL AUTO_INCREMENT,/*标签id*/
  tag_Name varchar(255) NOT NULL DEFAULT '',/*标签名称*/
  tag_Order int(11) NOT NULL DEFAULT '0',/*标签排序*/
  tag_Count int(11) NOT NULL DEFAULT '0',/*标签下文章数量*/
  tag_Alias varchar(255) NOT NULL DEFAULT '',/*标签别名*/
  tag_Intro text NOT NULL,/*标签摘要，可用于网站页面的描述信息*/
  tag_Template varchar(255) NOT NULL DEFAULT '',/*所用模板*/
  tag_Meta longtext NOT NULL,/*标签扩展数据*/
  tag_Type tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tag_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=452 DEFAULT CHARSET=utf8;
```

模块表：

```sql
CREATE TABLE zbp_module (
  mod_ID int(11) NOT NULL AUTO_INCREMENT,/*模块id*/
  mod_Name varchar(255) NOT NULL DEFAULT '',/*模块名称*/
  mod_FileName varchar(255) NOT NULL DEFAULT '',/*模块文件名*/
  mod_Content text NOT NULL,/*模块内容*/
  mod_SidebarID int(11) NOT NULL DEFAULT '0',/*侧栏id*/
  mod_HtmlID varchar(255) NOT NULL DEFAULT '',/*htmlid 用于写css样式*/
  mod_Type varchar(5) NOT NULL DEFAULT '',/*模块类型。是ul还是div*/
  mod_MaxLi int(11) NOT NULL DEFAULT '0',
  mod_Source varchar(255) NOT NULL DEFAULT '',/*模块属性。system代表系统模块，theme_XXX代表主题创建的模块*/
  mod_IsHideTitle tinyint(1) NOT NULL DEFAULT '0',/*是否显示模块标题*/
  mod_Meta longtext NOT NULL,/*模块扩展数据*/
  PRIMARY KEY (mod_ID)
) ENGINE=MyISAM AUTO_INCREMENT=187 DEFAULT CHARSET=utf8
```

用户表：ChatGPT 根据 [zbp_member](https://www.jb51.net/article/278971.htm) 的描述推导的

```sql
CREATE TABLE zbp_member (
  mem_ID int(11) NOT NULL AUTO_INCREMENT,  /* 序号，即用户ID */
  mem_Guid varchar(255) NOT NULL DEFAULT '',  /* 注册邀请码 */
  mem_Level tinyint(4) NOT NULL DEFAULT '0',  /* 用户级别 */
  mem_Status tinyint(4) NOT NULL DEFAULT '0',  /* 用户状态：0正常，1审核，2禁用 */
  mem_Name varchar(255) NOT NULL DEFAULT '',  /* 用户名称 */
  mem_Password varchar(255) NOT NULL DEFAULT '',  /* 用户密码 */
  mem_Email varchar(255) NOT NULL DEFAULT '',  /* 用户邮箱 */
  mem_HomePage varchar(255) NOT NULL DEFAULT '',  /* 个人主页网址 */
  mem_IP varchar(15) NOT NULL DEFAULT '',  /* 注册时的IP地址 */
  mem_PostTime int(11) NOT NULL DEFAULT '0',  /* 注册时间，使用时间戳格式 */
  mem_Alias varchar(255) NOT NULL DEFAULT '',  /* 用户别名 */
  mem_Intro text NOT NULL,  /* 用户简介 */
  mem_Articles int(11) NOT NULL DEFAULT '0',  /* 文章记录数量 */
  mem_Pages int(11) NOT NULL DEFAULT '0',  /* 页面记录数量 */
  mem_Comments int(11) NOT NULL DEFAULT '0',  /* 评论记录数量 */
  mem_Uploads int(11) NOT NULL DEFAULT '0',  /* 附件记录数量 */
  mem_Template varchar(255) NOT NULL DEFAULT '',  /* 用户模板 */
  mem_Meta longtext NOT NULL,  /* 用户的自定义附加字段，存储扩展数据 */
  PRIMARY KEY (mem_ID),
  KEY zbp_mem_Status_Level (mem_Status, mem_Level)  /* 添加状态和等级的联合索引，方便筛选 */
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```

## 参考

- https://web.archive.org/web/20220930002915/https://www.wangjingxian.cn/zblog/487.html
- http://www.qingzhouquanzi.com/144.html
