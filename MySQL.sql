系统命令：
net start mysql								启动MySQL
net stop  mysql 							停止MySQL

MySQL:内部命令
show character set;							显示字符集
show collation like 'utf8%';				显示校对规则，比如“utf8%”;
show collation;								查看字符集校对规则
show variables like 'character%';			显示系统变量'字符%'
show variables like '%storage_engine%';		查询系统默认的存储引擎"(storage_engine:存储引擎)"
show create database 数据库名;				查阅一下某些表完整字符集的建库语句
set character_set_server=utf8;				修改 字符集 服务器 编码=utf8;
set character_set_database=gbk;				修改 字符集 数据库 编码=gbk;
show engines;								显示引擎
show tables;								显示某个数据库中的所有 表
desc|describe 表名[列名|通配符];									显示表结构
show table status from test like 'book';



------------------------------------创建数据库---------------------------------------------------------------------------


数据模型的三要素
	1.数据结构
	
	2.数据操作
	
	3.数据约束条件

常见的模型

	1.层次模型： 用 "树" 结构
	2.网状模型： 用 "图" 结构
	3.关系模型： 用 "表" 结构

create database text_data character set gb2312;	
use text_data;
create table text_table(
	uID int(10) not null auto_increment primary key comment '用户编号'		/*comment默认值*/
	) engine=innodb | default character set utf8; 

-- 修改表2020年4月17日
	库				表				结构				引擎
	add				drop			modify			select
alter database yggl character set gb2312;									/*修改yggl数据库的字符集*/
alter table old_表名 rename new_表名;										/*修名单个表名*/
rename table old_表名 to new_表名[, old_表名2 to new_表名2], ...;				/*同时修改多个表名*/
drop table 表名;																/*删除某单个表*/

alter table 表名 change old_字段名 new_字段名 varchar(20);  					/*修改某个表字段名、字段长度为20*/
alter table 表名 modify 字段名 int(20);										/*修改字段类型*/
alter table 表名 modify 字段名 int(20) after 字段名2; 						/*修改排列位置（调换两个字段的排序）*/
alter table 表名 add 字段名 数据类型;											/*添加某个表中的字段*/
alter table 表名 drop 字段名;												/*删除某个表中的字段*/
-- 修改某个表的存储引擎（engine）
alter table 表名 engine = 
alter table 表名 engine=MyISAM;												/*修改表的引擎*/
alter database database_name character set gb2312;							--修改数据库的字符集
alter database database_name collate set 排序规则名称;						--排序规则
show table status from 数据库名 like '表名';
or 																			/*这两条语句是查看某个表的信（xin）息*/
show table status from 数据库名 where name='表名';

alter table 表名 alter 图书编号 set default 'ISBN';							/*修改默认值*/
alter table 表名 alter 图书编号 drop default;									/*删除默认值*/
			
			-- copy拷贝
create table new_表名 select * from old_表名;								/*创建新表，并拷贝某个原有表中的所有内容到这个表*/
	select * from 表名;
create table new_表名 select * from old_表名 where false;					/*创建新表，拷贝表结构*/
create table book_copy1 like books;											/*创建表，拷贝结构*/
create table new_表名 as (select 字段1，字段2，....  from old_表名);			/*子查询创建表*/


	-------------------------------------------------------------------------------------------------------
											数据的完整性
alter table 表名 add new_字段名 varchar(30) not null after old_字段名;		/*添加非空约束*/
alter table new_表名 modify 字段名 char(30) | not null;								/*添加空约束（not null）*/
alter table 表名 modify 字段名 char(30) default "我与地坛" not null;			/*同时添加默认值和非空约束*/

-------------------------------------------主键约束------------------------------
create table book_copy(
	图书编号 varchar(6),
	书名 varchar(20) primary key ,出版日期 date
);
-- comment "注释"
create table sCarInfo(
	gdID int not null comment '商品ID',
 	uID int not null comment '用户ID', 
 	scNum int comment '购买数量', 
 	primary key (gdID, uID) 
 );

create table users1 (
uID int(11) not null primary key auto_increment comment "用户ID",     			/*auto_increment:自增*/	
uName varchar(30) not null unique comment "姓名",								/*unique:唯一索引*/	
uPwd varchar(30) not null comment "密码",										/*comment:注释说明*/	
uSex enum('男','女') default '男' comment "性别"									/*enum:枚举,注 default*/	
);
 ---------------------------------------------------------------------------------------------------------2020年5月6日
											index-索引
alter table book_copy3 drop primary key,drop index 书名;							/*删除主关键字和唯一索引
																					注：定义了索引名，删除则用索引名*/
alter table book_copy3 add primary key (图书编号),	
	add index unique u_idx (书名);												/*添加主关键字和唯一索引*/						
show index from book_copy3;														/*查询表中的索引*/

---------------------------------------------------------------------------------------------------------
									表间关系，约束  外键
1.创建表的同时创建constraint
	create table 表名(列名,...) | [外键定义]
2.在已有的表上添加constraint
alter table 表名 add CONSTRAINT 外键列名_New名 FOREIGN key (外键列名) REFERENCES 主表名 (tID)
	注：foreign(外部键)/ 	


===================================两个表之间的约束例题(FOREIGN key)================================================================
use test;
create table sell_copy1(
订单号 char(10) not null primary key,
用户号 char(18) not null,
图书编号 char(20) not null,
订购册数 int(5) not null,
订购单价 float(0) not null,
订购时间 datetime not null,
是否发货 varchar(10),
是否收货 varchar(10),
是否结清 varchar(10),
constraint  外键列名 													//（	可以不要这条语句，只是起名而已）
foreign key (图书编号) references book_copy1 (图书编号)					
on delete RESTRICT														//默认为拒绝
on update RESTRICT
);

drop table sell_copy1;
alter table sell_copy1
add FOREIGN key (图书编号)
REFERENCES book_copy1 (图书编号)												//已有表，修改约束为（级联：CascaDE）
on delete CASCADE
on update CASCADE; 	
			||
			||
			\/
================================================================================================================
---------------------------------------------------------------------------------------------------------
									表完整性约束
	restrict	拒绝
	cascade		级联

	set null 	父更新，子为空
	not action	同restrict
	set default	父更新，子指定值
	
语法：创建表时 指定外键约束 ：
constraint   约束名称  foreign  key(外键列名)   references  关联表 （关联表的主键）;
alter table sell add foreign key (用户号) references members(用户号) on delete cascade on update cascade;


show create table sell;
alter table sell drop FOREIGN key 外键名;				//删除外键（foreign key）

-- CHECK
1.
create table student(
学号 char(6) primary key,
性别 char(2) not null,									//check约束，（ ）
 CHECK(性别 in ('男','女'))
);
2.
create table student1(
学号 char(6) primary key,
出生日期 date not null,
学分 int null,
check(出生日期>'1980-01-01')
);

alter table books add check(单价>0),add check(折扣>=0.1 and 折扣<=1);		//修改CHECK约束

---------------------------------------------------------------------------------------------------
								增删改擦
//增添
insert 	into table_name (column1,column2,...) values (value1,value2,...);				//指定某些字段，进行插入纪录
insert 	into table_name values (value1,value2,....);										//所有字段插， 入一行纪录
insert 	into table_name set column1=value1,column2=value2,.....;
insert	into table_name values ((value1_1,value1_2,..),(value2_1,value2_2,...),....);	//插入多行纪录
replace into table_name []																// 替换(插入)，针对主键

//更新
update table_name set column1=value1,column2=value2,... where column=value;				//满足条件的，更新纪录
update table_name1,table_name2 set table_name1.column1,table_name2.column2
	where table_name1.column1=table_name2.column2 and table_name2.column2=value;		//更新两个表

delete from table_name where column=value;												//删除，满足条件的数据

=========================================================================================================
DISTINCT  LIKE 
=========================================================================================================


select * from table_name;																//查询表中所有字段数据
select * from table_name where  column = "value";											//查询表中所有字段数据，满足条件的
select column1,column2 from table_name;													//查询表中某些字段数据					
select column1,column2 from table_name where year(column) > 2000;						//查询表中数据，出生为2000年级以上的
											出生日期 = '2000/02/11';
select column1 as another name from table_name;											//查询表中某字段（取个别名显示）数据
select distinct column1 from table_name where column1 = "value1" and column2 = "value2";	//distinct限定重复的数据

select column1 sum(column2) as 数量之和 from table_name group by column1 order by sum(column2) ascending | descending;
	//查询表中 某字段中和的
-- select * from table_name where 姓名 =like"\_刘_%" escape '\';			-- //通配符,转义字符(escape '\' 把\做为转义字符)
select * from table_name where 姓名 like'_%';											//下划线代表一个字符
select * from table_name where 姓名 like'_%' order by 总分 desc;
select * from employees where 性别 in(0,1) order by 员工部门 desc limit 3,5;				//0或1,limit 3后面的5条记录
select * from employees where 员工部门 between  3 and 5 order by 员工部门 desc;			//3到5之间
select * from employees where 性别 between 0 and 1 having avg(工作年限) >3; 
select distinct 性别,学历 from employees where 性别 between 0 and 1 having avg(工作年限) >1 order by 工作年限 desc; 

例题：
select 书名, sum(单价) 总价 from books order by 单价 asc;
+------------+--------+
| 书名       | 总价   |
+------------+--------+
| 计算机基础 | 128.50 |

