---开启事务
begin tran
--错误扑捉机制，看好啦，这里也有的。并且可以嵌套。
begin try  
   --语句正确
   insert into account (account_number,branch_name,balance) values ('A-101','Downtown',100)
   --Numb为int类型，出错
   insert into account (account_number,branch_name,balance) values ('A-203','Brighton','abc')
   --语句正确
   insert into account (account_number,branch_name,balance) values ('A-303','Redwood',2000)
end try

begin catch
   select Error_number() as ErrorNumber,  --错误代码
          Error_severity() as ErrorSeverity,  --错误严重级别，级别小于10 try catch 捕获不到
          Error_state() as ErrorState ,  --错误状态码
          Error_Procedure() as ErrorProcedure , --出现错误的存储过程或触发器的名称。
          Error_line() as ErrorLine,  --发生错误的行号
          Error_message() as ErrorMessage  --错误的具体信息
   if(@@trancount>0) --全局变量@@trancount，事务开启此值+1，他用来判断是有开启事务
      rollback tran  ---由于出错，这里回滚到开始，第一条语句也没有插入成功。
end catch

if(@@trancount>0)
commit tran  --如果成功Lives表中，将会有3条数据。

--表本身为空表，ID ,Numb为int 类型，其它为nvarchar类型
select * from account

---开启事务
begin tran
--错误扑捉机制，看好啦，这里也有的。并且可以嵌套。
begin try    
   --语句正确
   insert into account (account_number,branch_name,balance) values ('A-203','Brighton','abc')
    --加入保存点
   save tran saveStoreOne
   --Numb为int类型，出错
   insert into account (account_number,branch_name,balance) values ('A-203','Brighton','efg')
   --语句正确
   insert into account (account_number,branch_name,balance) values ('A-203','Brighton','666')
end try
begin catch
   select Error_number() as ErrorNumber,  --错误代码
          Error_severity() as ErrorSeverity,  --错误严重级别，级别小于10 try catch 捕获不到
          Error_state() as ErrorState ,  --错误状态码
          Error_Procedure() as ErrorProcedure , --出现错误的存储过程或触发器的名称。
          Error_line() as ErrorLine,  --发生错误的行号
          Error_message() as ErrorMessage  --错误的具体信息
   if(@@trancount>0) --全局变量@@trancount，事务开启此值+1，他用来判断是有开启事务
      rollback tran   ---由于出错，这里回滚事务到原点，第一条语句也没有插入成功。
end catch
if(@@trancount>0)
rollback tran saveStoreOne --如果成功account表中，将会有3条数据。

--表本身为空表，ID ,Numb为int 类型，其它为nvarchar类型
select * from account

delete account  --清空数据
set xact_abort off
begin tran 
    --语句正确
   insert into account (account_number,branch_name,balance) values ('A-203','Brighton',666)
   --Numb为int类型，出错,如果1234..那个大数据换成'132dsaf' xact_abort将失效
   insert into account (account_number,branch_name,balance) values ('A-203','Brighton','666')
   --语句正确
   insert into account (account_number,branch_name,balance) values ('A-203','Brighton',555)
commit tran
select * from account

begin tran 
  update account account_number='A-108'
  waitfor delay '0:0:5'  
  update dbo.branch set branch_city='北京' 
commit tran

begin tran 
  update branch set branch_city='北京' 
  waitfor  delay '0:0:5' --等待5秒执行下面的语句
  update account set account_number='A-108'
commit tran
select * from account
select * from branch

----------------------------
----------------------------
----------------------------
----------------------------
----------------------------
----------------------------
----------------------------
----------------------------

--查看超时时间,默认为-1
select @@lock_timeout
--设置超时时间
set lock_timeout 0 --为0时，即为一旦发现资源锁定，立即报错，不在等待，当前事务不回滚，设置时间需谨慎处理后事啊，你hold不住的。
--检测死锁
--如果发生死锁了，我们怎么去检测具体发生死锁的是哪条SQL语句或存储过程？
--这时我们可以使用以下存储过程来检测，就可以查出引起死锁的进程和SQL语句。SQL Server自带的系统存储过程sp_who和sp_lock也可以用来查找阻塞和死锁, 但没有这里介绍的方法好用。 

use master
go
create procedure sp_who_lock
as
begin
declare @spid int,@bl int,
 @intTransactionCountOnEntry  int,
        @intRowcount    int,
        @intCountProperties   int,
        @intCounter    int

 create table #tmp_lock_who (
 id int identity(1,1),
 spid smallint,
 bl smallint)
 
 IF @@ERROR<>0 RETURN @@ERROR
 
 insert into #tmp_lock_who(spid,bl) select  0 ,blocked
   from (select * from sysprocesses where  blocked>0 ) a 
   where not exists(select * from (select * from sysprocesses where  blocked>0 ) b 
   where a.blocked=spid)
   union select spid,blocked from sysprocesses where  blocked>0

 IF @@ERROR<>0 RETURN @@ERROR 
  
-- 找到临时表的记录数
 select  @intCountProperties = Count(*),@intCounter = 1
 from #tmp_lock_who
 
 IF @@ERROR<>0 RETURN @@ERROR 
 
 if @intCountProperties=0
  select '现在没有阻塞和死锁信息' as message

-- 循环开始
while @intCounter <= @intCountProperties
begin
-- 取第一条记录
  select  @spid = spid,@bl = bl
  from #tmp_lock_who where Id = @intCounter 
 begin
  if @spid =0 
            select '引起数据库死锁的是: '+ CAST(@bl AS VARCHAR(10)) + '进程号,其执行的SQL语法如下'
 else
            select '进程号SPID：'+ CAST(@spid AS VARCHAR(10))+ '被' + '进程号SPID：'+ CAST(@bl AS VARCHAR(10)) +'阻塞,其当前进程执行的SQL语法如下'
 DBCC INPUTBUFFER (@bl )
 end 

-- 循环指针下移
 set @intCounter = @intCounter + 1
end

drop table #tmp_lock_who

return 0
end
 

--杀死锁和进程
--如何去手动的杀死进程和锁？最简单的办法，重新启动服务。但是这里要介绍一个存储过程，通过显式的调用，可以杀死进程和锁。

use master
go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_killspid]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_killspid]
GO

create proc p_killspid
@dbname varchar(200)    --要关闭进程的数据库名
as  
    declare @sql  nvarchar(500)  
    declare @spid nvarchar(20)

    declare #tb cursor for
        select spid=cast(spid as varchar(20)) from master..sysprocesses where dbid=db_id(@dbname)
    open #tb
    fetch next from #tb into @spid
    while @@fetch_status=0
    begin  
        exec('kill '+@spid)
        fetch next from #tb into @spid
    end  
    close #tb
    deallocate #tb
go

--用法  
exec p_killspid  'newdbpy' 

--查看锁信息
--如何查看系统中所有锁的详细信息？在企业管理管理器中，我们可以看到一些进程和锁的信息，这里介绍另外一种方法。
--查看锁信息
create table #t(req_spid int,obj_name sysname)

declare @s nvarchar(4000)
    ,@rid int,@dbname sysname,@id int,@objname sysname

declare tb cursor for 
    select distinct req_spid,dbname=db_name(rsc_dbid),rsc_objid
    from master..syslockinfo where rsc_type in(4,5)
open tb
fetch next from tb into @rid,@dbname,@id
while @@fetch_status=0
begin
    set @s='select @objname=name from ['+@dbname+']..sysobjects where id=@id'
    exec sp_executesql @s,N'@objname sysname out,@id int',@objname out,@id
    insert into #t values(@rid,@objname)
    fetch next from tb into @rid,@dbname,@id
end
close tb
deallocate tb

select 进程id=a.req_spid
    ,数据库=db_name(rsc_dbid)
    ,类型=case rsc_type when 1 then 'NULL 资源（未使用）'
        when 2 then '数据库'
        when 3 then '文件'
        when 4 then '索引'
        when 5 then '表'
        when 6 then '页'
        when 7 then '键'
        when 8 then '扩展盘区'
        when 9 then 'RID（行 ID)'
        when 10 then '应用程序'
    end
    ,对象id=rsc_objid
    ,对象名=b.obj_name
    ,rsc_indid
 from master..syslockinfo a left join #t b on a.req_spid=b.req_spid

go
drop table #t