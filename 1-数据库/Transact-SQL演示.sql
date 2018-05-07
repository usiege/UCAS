Transact-SQL演示
/*数据库操作*/

/*数据库操作：创建数据库*/
create database banksql

/*数据库操作：删除数据库*/
drop database banksql

/*数据库操作：打开数据库*/
use banksql


/*系统表操作*/
use Formse

SELECT *
from dbo.syscolumns
where name='account_number'

select *
from dbo.sysusers
/*基本表操作DDL*/
/*基本表创建*/
/*基本表操作：创建基本表*/
/*use banksql*/
create table branch
   (branch_name	char(15) not null,
    branch_city	char(30),
    assets      integer)

/*基本表操作：创建基本表-含约束*/
/*use banksql*/
create table account
   (account_number char(15) not null,
    branch_name    char(30),
    balance        integer,
    primary key (account_number),
    check (balance >= 0))

/*基本表操作：根据已有表创建基本表，newtable为新表名*/
select * into newtable 
from account

/*基本表操作：根据已有表创建基本表，newtable为新表名，选择部分属性*/
select account_number,balance into newtable 
from account



/*基本表操作：从指定数据库中基本表创建指定数据库的基本表*/
select * into banksql.dbo.account 
from bank.dbo.account

/*准备基本表备用*/
select * into banksql.dbo.loan 
from bank.dbo.loan

select * into banksql.dbo.borrower 
from bank.dbo.borrower

select * into banksql.dbo.customer
from bank.dbo.customer

select * into banksql.dbo.depositor
from bank.dbo.depositor

select * into banksql.dbo.branch
from bank.dbo.branch

/*基本表删除*/
/*基本表操作：删除表中所有元组*/
delete from newtable

/*基本表操作：彻底删除*/
drop table newtable

/*基本表属性修改*/
/*基本表操作：添加属性*/
alter table newtable add newatt1 char(15),newatt2 char(15)

/*基本表操作：删除属性*/
alter table newtable drop column newatt1,newatt2

/*基本表索引操作*/
/*基本表操作：创建索引*/
create index acco on account (account_number)

/*基本表操作：删除索引，account：表名，acco：索引名*/
drop index account.acco

/*基本表操作DML*/
/*基本表增删改*/
/*基本表操作：插入一个元组*/
Insert into account values('A-101','Downtown',400)

/*基本表操作：插入一个查询结果*/
Insert into account
      select loan_number,branch_name,200
      from bank.dbo.loan
      where branch_name='downtown'

/*基本表操作：删除账号为L-14和L-17的元组*/
delete from account
where account_number='L-14' or account_number='L-17'

/*基本表操作：更新*/
Update account
Set balance=balance*1.05


/*基本表查询*/
/*简单查询*/
/*DISTINCT消除重复的值*/
select distinct branch_name 
from account

/*all显示地表示不要去除重复*/
select all branch_name 
from account

/*符号*表示选择所有属性 */
select * 
from account

/*选择指定属性，并含算术表达式*/
select loan_number, branch_name, amount*100 from loan

/*找出所有在Perryridge支行贷款并且贷款超过1200美元的贷款的贷款号*/
select loan_number 
from loan 
where branch_name ='Perryridge' and amount > 1200

/*贷款额在900到1300的贷款号*/
select loan_number from loan where amount between 900 and 1300

/*找出所有从银行贷款用户的名字、贷款号、贷款额*/
select customer_name, T.loan_number, S.amount 
from borrower as T, loan as S 
where  T.loan_number = S.loan_number

/*字符串操作：找出街道地址中含有子串‘Main’的所有客户的姓名*/
select customer_name 
from customer 
where customer_street like '%Main%'

/*排序操作*/
/*排序：按字母顺序列出在Perryridge支行中有贷款的客户*/
select distinct customer_name
from borrower, loan
where borrower.loan_number = loan.loan_number and
      branch_name = 'Perryridge'
order by customer_name

/*排序：升序*/
select *
from account
order by balance ASC

/*排序：降序*/
select *
from account
order by balance DESC

/*集合操作*/

/*集合并运算：找出在银行有帐户、贷款或两者都有的帐户*/
(select customer_name from depositor)
union
(select customer_name from borrower)

/*集合交运算：找出在银行同时有帐户和贷款的帐户，教材用intersect, T-SQL用select实现*/
SELECT DISTINCT customer_name
FROM depositor
WHERE EXISTS
   (SELECT *
   FROM borrower
   WHERE depositor.customer_name = borrower.customer_name)

/*集合差运算：找出在银行有帐户但无贷款的帐户，教材用except, T-SQL用select实现*/
select distinct customer_name
from depositor
where not EXISTS
   (select *
   from borrower
   where depositor.customer_name = borrower.customer_name)

/*聚集查询*/
/*聚集函数：找出Perryridge支行的帐户余额平均值*/
select avg (balance) as avg_bananlce
from account
where branch_name = 'Perryridge'

/*聚集函数：统计customer中的元组个数*/
select count (*) as customer_count
from customer

/*聚集函数：统计depositor中的元组个数，重复的名字按一个统计*/
select count (distinct customer_name) as customer_distinct_count 
from depositor

/*聚集函数：分组统计每个支行的账户余额平均值*/
select branch_name, avg (balance) as avg_balance
from account
group by branch_name

/*空值测试：检查loan中属性amount是否存在空值，is not null用于检测非空值*/
select loan_number
from loan
where amount is null


/*复杂查询*/
/*复杂查询：找出那些平均账户余额大于500美元的支行的平均账户余额*/
select branch_name, avg (balance)
      from account
      group by branch_name

--将上述作为一个查询表
select branch_name, avg_balance
from (select branch_name, avg (balance)
      from account,depositor
      group by branch_name)
as result (branch_name, avg_balance)
where avg_balance > 500

/*
Find all customers who have an account at all branches located in Brooklyn city. 找出找出所有位于Brooklyn的所有支行都有帐户的客户。已知：关系branch、depositor、account
*/
select distinct S.customer_name from depositor as S
where not exists(
(select branch.branch_name from branch 
where branch.branch_city ='Brooklyn' and branch.branch_name
not in
(select R.branch_name from depositor as T, account as R 
Where T.account_number = R.account_number and S.customer_name = T.customer_name )))


/*连接操作*/
/*基本表连接操作：广义笛卡儿连接*/
SELECT *
FROM loan

SELECT *
FROM borrower

--上述两表乘积

SELECT loan.branch_name,borrower.customer_name,loan.loan_number,loan.amount
FROM loan,borrower/*基本表连接操作：广义笛卡儿连接，与上式等价*/
SELECT a.branch_name,p.customer_name,a.loan_number,a.amount
FROM loan AS a cross JOIN borrower AS p

/*基本表连接操作：自然连接：与教材loan inner join borrower on loan.loan_number=borrower.loan_number等价*/
SELECT a.branch_name,p.customer_name,a.loan_number,a.amount
FROM loan AS a INNER JOIN borrower AS p 
ON a.loan_number = p.loan_number

/*基本表连接操作：左外连接*/
SELECT loan.branch_name,borrower.customer_name,loan.loan_number,loan.amount
FROM loan LEFT OUTER JOIN  borrower
ON borrower.loan_number = loan.loan_number

/*基本表连接操作：右外连接*/
SELECT loan.branch_name,borrower.customer_name,loan.loan_number,loan.amount
FROM loan RIGHT OUTER JOIN  borrower
ON borrower.loan_number = loan.loan_number

--上述两个表的连接结果相同

/*基本表连接操作：右外连接*/
SELECT loan.branch_name,loan.loan_number,loan.amount,branch.branch_name
FROM loan RIGHT OUTER JOIN branch
ON branch.branch_name = loan.branch_name

SELECT loan.branch_name,loan.loan_number,loan.amount,branch.branch_name
FROM branch RIGHT OUTER JOIN loan
ON branch.branch_name = loan.branch_name

--上述连接的左右表交换位置后的结果不同

/*基本表连接操作：全连接*/
SELECT branch.branch_name,branch.branch_city,branch.assets,account.balance
FROM branch FULL OUTER JOIN account 
ON branch.branch_name=account.branch_name

--与左外连接结果相同，branch的元组数量大于account
SELECT branch.branch_name,branch.branch_city,branch.assets,account.balance
FROM branch left OUTER JOIN account 
ON branch.branch_name=account.branch_name

/*基本表连接操作：生成新表*/
SELECT a.branch_name,p.customer_name,a.loan_number,a.amount into newtable
FROM loan AS a INNER JOIN borrower AS p 
ON a.loan_number = p.loan_number


/*视图操作*/
/*视图创建*/
/*视图创建：根据两个基本表*/
create view customer1 as
  (select branch_name, customer_name
   from depositor, account
   where depositor.account_number = account.account_number)

/*视图创建：利用查询表创建*/
create view all_customer as
  (select branch_name, customer_name
   from depositor, account
   where depositor.account_number = account.account_number)
 union
  (select branch_name, customer_name
  from borrower, loan
  where borrower.loan_number = loan.loan_number)

/*创建视图并变更属性*/
CREATE VIEW dbo.loan_view(支行名,资产) AS
SELECT branch_name, amount
FROM dbo.loan


/*视图查询*/

/*视图查询：与基本表一致*/
select * from all_customer


/*触发器*/
/*定义触发器*/
CREATE TRIGGER reminder ON [dbo].[loan] 
FOR INSERT, UPDATE, DELETE 
AS RAISERROR('触发器已经执行',16,10)

/*激活触发器*/
insert into loan
values('L-100','白居易',20000)

/*服务器: 消息 50000，级别 16，状态 10，过程 reminder，行 3
触发器已经执行*/
