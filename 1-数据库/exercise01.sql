--插入数据
insert into account(account_number,branch_name,balance)
values ('aa11','zssv','11100');

--重新插入一条数据，account_number一致，违犯primary_key约束。
insert into account(account_number,branch_name,balance)
values ('aa11','xsfds','54360');
---约束检验check(balance>=0)
因为：MySQL只是check，但是不强制check。
      mysql对于可列举的约束,如性别的约束('男','女')可列举的，可以直接进行约束。
create table account_user
   (id       integer not null,
    branch_name    char(30),
    xb enum('男','女'),
    primary key (id));
insert into account_user(id,branch_name,xb)
values('1','祖国歌','其他');
insert into account_user(id,branch_name,xb)
values('1','祖国歌','女');
             
mysql对大范围的约束，如：>0的值，需要只用触发器来代替实现数据的有效性。
delimiter // 
create trigger checkTrigger 
before insert on account 
for each row 
begin  
if new.balance<0 then 
	insert into account(account_number,branch_name,balance) values ('0','0','-1'); 
end if;
end; 
//
insert into account(account_number,branch_name,balance)
values ('aa12','xsfds','-3');


/*基本表操作：根据已有表创建基本表，newtable为新表名*/
create table newtable 
select * from account;

/*基本表操作：根据已有表创建基本表，newtable为新表名，选择部分属性*/
create table newtable2
select account_number,balance from account;

/*基本表操作：从指定数据库中基本表创建指定数据库的基本表*/
create table newtable3 
select * from information_schema.tables limit2;

/*准备基本表备用*/
create table loan
select * from information_schema.tables;

create table borrower
select * from 
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
delete from newtable;
----delete删除表中数据，但是表结构还存在。
/*基本表操作：彻底删除*/
drop table newtable;
----drop将表彻底删除，包括表结构。


/*基本表属性修改*/
/*基本表操作：添加属性*/
alter table newtable add  newatt1 varchar(15),add newatt2 varchar(15);

/*基本表操作：删除属性*/
alter table newtable drop column newatt1, drop column newatt2;

/*基本表索引操作*/
/*基本表操作：创建索引*/
create index acco on account (account_number);

/*基本表操作：删除索引，account：表名，acco：索引名*/
drop index acco on account;

/*基本表操作DML*/
/*基本表增删改*/
/*基本表操作：插入一个元组*/
Insert into account values('A-101','Downtown',400);

/*基本表操作：插入一个查询结果*/
Insert into account
      select loan_number,branch_name,200
      from bank.dbo.loan
      where branch_name='Downtown'


/*复杂查询*/
/*复杂查询：找出那些平均账户余额大于500美元的支行的平均账户余额*/
select branch_name, avg (balance)
      from account
      group by branch_name

--将上述作为一个查询表
select branch_name, avg_balance
from (select branch_name, avg (balance)
      from account
      group by branch_name)
as result (branch_name, avg_balance)
where avg_balance > 500
                          
---存款报账                                              
account: 
account_number/branch_name/balance                        
account_number='L-14' or account_number='L-17'
branch_name = 'Perryridge'
Insert into account values('A-101','Downtown',400);

select branch_name, avg (balance)
      from account
      group by branch_name

---支行
branch：
branch_number/branch_name/branch_city
branch_city ='Brooklyn' 
and branch.branch_name  not in
(select R.branch_name from depositor as T, account as R 
Where T.account_number = R.account_number and R.customer_name = T.customer_name )))

create table branch(
    branch_number  char(8) not null,
    branch_name    char(30),
    branch_city    char(30)
    );   

--借款，借出
loan:
loan_number/branch_name/amount
branch_name ='Perryridge' and amount > 1200
amount between 900 and 1300
amount is null
create table loan(
             loan_number  char(8) not null,
             branch_name  char(30),
             amount       integer
             );            
---借款人   
borrower:   
loan_number/customer_name
create table borrower(
             loan_number  char(8) not null,
             customer_number      char(8) not null,
             customer_name          char(30)
             );            
---客户     
customer:   
customer_number/customer_name/customer_street
customer_street like '%Main%'
create table customer(
             customer_number        char(8) not null,
             customer_name          char(30),
             customer_street        char(60)             );  
             
             
account: 
account_number/branch_name/balance                        
account_number='L-14' or account_number='L-17'
branch_name = 'Perryridge'
Insert into account values('A-101','Downtown',400);
             
                       
---存款人   
depositor:  
account_number/customer_name


update depositor set customer_name='Dream' where customer_name='borrower';


/*基本表操作：插入一个查询结果*/
Insert into account
      select lnoa_number,branch_name,200
      from loan
      where branch_name='downtown'
---插入之前：
select * from account where  branch_name='downtown';
---插入之后：
insert into  account
select loan_number,branch_name,200
      from loan
      where branch_name='downtown';     



/*基本表操作：删除账号为L-14和L-17的元组*/
delete from account
where account_number='L-14' or account_number='L-17'
---删除之前：
select * from account
where account_number='L-14' or account_number='L-17';
---删除之后：

/*基本表操作：更新*/
Update account
Set balance=balance*1.05
---为便于对比，在account表中添加新的字段balance_new.
alter table account add balance_new integer;
update account set balance_new=balance*1.05;

/*基本表查询*/
/*简单查询*/
/*DISTINCT消除重复的值*/
select distinct branch_name 
from account;

/*all显示地表示不要去除重复*/
select all branch_name 
from account;

/*符号*表示选择所有属性 */
select * 
from account;

/*选择指定属性，并含算术表达式*/
select loan_number, branch_name, amount*100 from loan;

/*找出所有在Perryridge支行贷款并且贷款超过1200美元的贷款的贷款号*/
select loan_number 
from loan 
where branch_name ='Perryridge' and amount > 1200;

/*贷款额在900到1300的贷款号*/
select loan_number from loan where amount between 900 and 1300;

/*找出所有从银行贷款用户的名字、贷款号、贷款额*/
select T.customer_name, T.loan_number, S.amount 
from borrower as T, loan as S 
where  T.loan_number = S.loan_number;

/*字符串操作：找出街道地址中含有子串‘Main’的所有客户的姓名*/
select customer_name 
from customer 
where customer_street like '%Main%';

/*排序操作*/
/*排序：按字母顺序列出在Perryridge支行中有贷款的客户*/
select distinct customer_name
from borrower, loan
where borrower.loan_number = loan.loan_number and
      branch_name = 'Perryridge'
order by customer_name;

/*排序：升序*/
select *
from account
order by balance ASC

/*排序：降序*/
select *
from account
order by balance DESC;

/*集合操作*/

/*集合并运算：找出在银行有帐户、贷款或两者都有的帐户*/
(select customer_name from depositor)
union
(select customer_name from borrower);
--两个表单独的查询结果：
--并集查询的结果：
/*集合交运算：找出在银行同时有帐户和贷款的帐户，教材用intersect, T-SQL用select实现*/
SELECT DISTINCT customer_name
FROM depositor
WHERE EXISTS
   (SELECT *
   FROM borrower
   WHERE depositor.customer_name = borrower.customer_name);

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
where branch_name = 'Perryridge';

/*聚集函数：统计customer中的元组个数*/
select count (*) as customer_count
from customer;

/*聚集函数：统计depositor中的元组个数，重复的名字按一个统计*/
select count (distinct customer_name) as customer_distinct_count 
from depositor;

/*聚集函数：分组统计每个支行的账户余额平均值*/
select branch_name, avg (balance) as avg_balance
from account
group by branch_name;

/*空值测试：检查loan中属性amount是否存在空值，is not null用于检测非空值*/
select loan_number
from loan
where amount='';


/*复杂查询*/
/*复杂查询：找出那些平均账户余额大于500美元的支行的平均账户余额*/
select branch_name, avg (balance)
      from account
      group by branch_name;

--将上述作为一个查询表
select branch_name, avg_balance
from (select branch_name, avg (balance) as avg_balance
      from account
      group by branch_name) a
where avg_balance > 500;

/*
Find all customers who have an account at all branches located in Brooklyn city. 找出找出所有位于Brooklyn的所有支行都有帐户的客户。已知：关系branch、depositor、account
*/
select distinct S.customer_name from depositor as S
where not exists(
(select branch.branch_name from branch 
where branch.branch_city ='Brooklyn' and branch.branch_name
not in
(select R.branch_name from depositor as T, account as R 
Where T.account_number = R.account_number and S.customer_name = T.customer_name )));


(select distinct branch_name from branch where branch_city ='Brooklyn')a
/*连接操作*/
/*基本表连接操作：广义笛卡儿连接*/
SELECT * FROM loan;

SELECT * FROM borrower;

--上述两表乘积

SELECT loan.branch_name,borrower.customer_name,loan.loan_number,loan.amount
FROM loan,borrower
SELECT a.branch_name,p.customer_name,a.loan_number,a.amount
FROM loan AS a cross JOIN borrower AS p
limit 15;
---由于内容太多，仅输出前15行。
/*基本表连接操作：自然连接：与教材loan inner join borrower on loan.loan_number=borrower.loan_number等价*/
SELECT a.branch_name,p.customer_name,a.loan_number,a.amount
FROM loan AS a INNER JOIN borrower AS p 
ON a.loan_number = p.loan_number;

/*基本表连接操作：左外连接*/
SELECT loan.branch_name,borrower.customer_name,loan.loan_number,loan.amount
FROM loan LEFT OUTER JOIN  borrower
ON borrower.loan_number = loan.loan_number;

/*基本表连接操作：右外连接*/
SELECT loan.branch_name,borrower.customer_name,loan.loan_number,loan.amount
FROM loan RIGHT OUTER JOIN  borrower
ON borrower.loan_number = loan.loan_number;

--上述两个表的连接结果相同

/*基本表连接操作：右外连接*/
SELECT loan.branch_name,loan.loan_number,loan.amount,branch.branch_name
FROM loan RIGHT OUTER JOIN branch
ON branch.branch_name = loan.branch_name;

SELECT loan.branch_name,loan.loan_number,loan.amount,branch.branch_name
FROM branch RIGHT OUTER JOIN loan
ON branch.branch_name = loan.branch_name;

--上述连接的左右表交换位置后的结果不同

/*基本表连接操作：全连接*/
SELECT branch.branch_name,branch.branch_city,branch.assets,account.balance
FROM branch FULL JOIN account 
ON branch.branch_name=account.branch_name;

SELECT * FROM t1 
 LEFT JOIN t2 ON t1.id = t2.id 
 UNION 
 SELECT * FROM t1 
 RIGHT JOIN t2 ON t1.id = t2.id

select * from branch
left join account on branch.branch_name=account.branch_name
union
select * from branch
right join account on branch.branch_name=account.branch_name;


--与左外连接结果相同，branch的元组数量大于account
SELECT branch.branch_name,branch.branch_city,branch.assets,account.balance
FROM branch left OUTER JOIN account 
ON branch.branch_name=account.branch_name;

/*基本表连接操作：生成新表*/
create table newtable
SELECT a.branch_name,p.customer_name,a.loan_number,a.amount
FROM loan AS a INNER JOIN borrower AS p 
ON a.loan_number = p.loan_number;
select * from newtable limit 6;

/*视图操作*/
/*视图创建*/
/*视图创建：根据两个基本表*/
create view customer1 as
  (select branch_name, customer_name
   from depositor, account
   where depositor.account_number = account.account_number);
select * from customer1 limit 6;
/*视图创建：利用查询表创建*/
create view all_customer as
  (select branch_name, customer_name
   from depositor, account
   where depositor.account_number = account.account_number)
 union
  (select branch_name, customer_name
  from borrower, loan
  where borrower.loan_number = loan.loan_number);
select * from  all_customer limit 6; 

/*创建视图并变更属性*/
CREATE VIEW loan_view AS
SELECT branch_name, amount
FROM loan;


/*视图查询*/

/*视图查询：与基本表一致*/
select * from all_customer


/*触发器*/
/*定义触发器*/
CREATE TRIGGER reminder ON loan
FOR INSERT, UPDATE, DELETE 
AS RAISERROR('触发器已经执行',16,10);

delimiter // 
create trigger checkTrigger 
before insert,update,delete on account 
for each row 
begin  
	Raise_application_error('触发器已经执行',16,10); 
end; 
//

---mysql的触发
mysql不能同时在insert,update,delete触发。只能一个个进行触发。

/*激活触发器*/
insert into loan
values('L-100','白居易',20000)

/*服务器: 消息 50000，级别 16，状态 10，过程 reminder，行 3
触发器已经执行*/

delimiter ||      //mysql 默认结束符号是分号，当你在写触发器或者存储过程时有分号出现，会中止转而执行  
drop trigger if exists updatename||    //删除同名的触发器，  
create trigger updatename after update on user for each row   //建立触发器，  
begin  
//old,new都是代表当前操作的记录行，你把它当成表名，也行;  
if new.name!=old.name then   //当表中用户名称发生变化时,执行  
update comment set comment.name=new.name where comment.u_id=old.id;  
end if;  
end||  
delimiter ;

create table account
   (account_number char(15) not null,
    branch_name    char(30),
    balance        integer,
    primary key (account_number),check (balance >= 0))
create table branch (branch_name char(15) not null,branch_city char(30),assets integer)
create table loan (loan_number char(15),branch_name char(30),amount integer)
create table depositor(customer_name char(30),account_number char(30))
create table customer(customer_name char(30),customer_street char(30),customer_city char(30))
create table borrower(customer_name char(30),loan_number integer)


insert into account(account_number,branch_name,balance)
values
('A-101','Downtown','500'),
('A-102','Perryridge','400'),
('A-201','Brighton','900'),
('A-215','Mianus','700'),
('A-217','Brighton','750'),
('A-222','Redwood','700'),
('A-305','Round Hill','350')

insert into branch(branch_name,branch_city,assets)
values
('Brighton','Brooklyn','7100000'),
('Downtown','Brooklyn','9000000'),
('Mianus','Horseneck','400000'),
('North Town','Rye','3700000'),
('Perryridge','Horseneck','1700000'),
('Pownal','Bennington','300000'),
('Redwood','Palo Alto','2100000'),
('Round Hill','Horseneck','8000000');

insert into customer(customer_name,customer_street,customer_city)
values
('Adams','Spring','Pittsfield'),
('Brooks','Senator','Brooklyn'),
('Curry','North','Rye'),
('Glenn','Sand Hill','Woodside'),
('Green','Walnut','Stamford'),
('Hayes','Main','Harrison'),
('Johnson','Alma','Palo Alto'),
('Jones','Main','Harrison'),
('Lindsay','Park','Pittsfield'),
('Smith','North','Rye'),d
('Turner','Putnam','Stamford'),
('Williams','Nassau','Princeton');


insert into depositor(customer_name,account_number)
values
('Hayes','A-102'),
('Johnson','A-101'),
('Johnson','A-201'),
('Jones','A-217'),
('Lindsay','A-222'),
('Smith','A-215'),
('Turner','A-305');

insert into loan(loan_number,branch_name,amount)
values
('L-11','Round Hill','900'),
('L-14','Downtown','1500'),
('L-15','Perryridge','1500'),
('L-16','Perryridge','1300'),
('L-17','Downtown','1000'),
('L-23','Redwood','2000'),
('L-93','Mianus','500');

insert into borrower(customer_name,loan_number)
values
('Adams','L-16'),
('Curry','L-93'),
('Hayes','L-15'),
('Johnson','L-14'),
('Jones','L-17'),
('Smith','L-11'),
('Smith','L-23'),
('Williams','L-17');


