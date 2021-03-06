USE [ConstructionPro]
GO
/****** Object:  StoredProcedure [dbo].[Boq_CriticaltaskUpdate]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Boq_CriticaltaskUpdate] (@Criticaltaskid varchar(50) ,@StartDate datetime,@EndDate datetime,@Duration int,@dep  varchar(50),@Predec  varchar(50),@Priority bigint,@TaskId  varchar(50),@Flag int) 
as
begin
if(@Flag=0)
Update BoqEntryDetails set Criticaltaskid= @Criticaltaskid, StartDate=@StartDate,EndDate=@EndDate,Duration=@Duration,dep=@dep,Predec=@Predec,Priority=@Priority where TaskId=@TaskId
else if(@Flag=1)
Update BoqEntryDetails set  StartDate=@StartDate, EndDate=@EndDate,Duration=@Duration, Predec=@Predec where ProjectId=@Priority and  TaskId=@TaskId
else
Update BoqEntryDetails set  RVStartDate=@StartDate, RVEndDate=@EndDate,RDuration=@Duration, Predec=@Predec where ProjectId=@Priority and  TaskId=@TaskId
select 'OK' as ok
end
GO
/****** Object:  StoredProcedure [dbo].[Boq_Update]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Boq_Update] (@MainItemId bigint,@subitem varchar(250),@flag varchar(2),@ProjectId bigint,@tasId varchar(50))
as
begin
--declare @MainItemId bigint=9
declare @StartDate datetime
declare @EndDate datetime
declare @SStartDate datetime
declare @SEndDate datetime
declare @SQty decimal
declare @MQty decimal
declare @PQty decimal

declare @SAmt decimal
declare @MAmt decimal
declare @PAmt decimal

declare @Smyday int
declare @myday int
declare @Pmyday int

declare @PStartDate datetime
declare @PEndDate datetime

if(@flag='P')
begin




if exists(select * from dbo.BoqEntryDetails b where  MainItemId=@MainItemId and b.SubItem=@subitem and b.SubSubItem!='' and BOQType=@flag and ProjectId=@ProjectId)
begin
set @StartDate =(select min(b.StartDate) from dbo.BoqEntryDetails b where  MainItemId=@MainItemId and b.SubItem=@subitem and b.SubSubItem!='' and BOQType=@flag and ProjectId=@ProjectId)
set @EndDate =(select max(b.EndDate) from dbo.BoqEntryDetails b where  MainItemId=@MainItemId and b.SubItem=@subitem and b.SubSubItem!='' and BOQType=@flag and ProjectId=@ProjectId)
set @myday = (DATEDIFF(DAY, @StartDate, @EndDate))
Update BoqEntryDetails set StartDate=@StartDate,EndDate=@EndDate,Duration=@myday+1 where MainItemId=@MainItemId  and SubItem=@subitem and SubSubItem=''  and BOQType=@flag and ProjectId=@ProjectId
end

if exists (select * from dbo.BoqEntryDetails b where  b.MainItemId=@MainItemId  and BOQType=@flag and ProjectId=@ProjectId)
begin
set @PStartDate =(select min(b.StartDate) from dbo.BoqEntryDetails b where  MainItemId!=0  and BOQType=@flag and ProjectId=@ProjectId)
set @PEndDate =(select max(b.EndDate) from dbo.BoqEntryDetails b where  MainItemId!=0  and BOQType=@flag and ProjectId=@ProjectId)
set @Pmyday = (DATEDIFF(DAY, @PStartDate, @PEndDate))

Update BoqEntryDetails set StartDate=@PStartDate,EndDate=@PEndDate,Duration=@Pmyday+1 where MainItemId=0  and BOQType='V' and ProjectId=@ProjectId
end

if exists(select * from dbo.BoqEntryDetails b where  MainItemId=@MainItemId and b.SubItem!='' and BOQType=@flag and ProjectId=@ProjectId)
begin
set @SStartDate =(select min(b.StartDate) from dbo.BoqEntryDetails b where  MainItemId=@MainItemId and b.SubItem!='' and BOQType=@flag and ProjectId=@ProjectId)
set @SEndDate =(select max(b.EndDate) from dbo.BoqEntryDetails b where  MainItemId=@MainItemId and b.SubItem!='' and BOQType=@flag and ProjectId=@ProjectId)
set @Smyday = (DATEDIFF(DAY, @SStartDate, @SEndDate))
Update BoqEntryDetails set StartDate=@SStartDate,EndDate=@SEndDate,Duration=@Smyday+1 where MainItemId=@MainItemId  and SubItem=''  and BOQType=@flag  and ProjectId=@ProjectId
end



if exists(select * from dbo.BoqEntryDetails b where  MainItemId=0 and BOQType=@flag and ProjectId=@ProjectId)
begin

set @SStartDate =(select min(b.Start_Date) from dbo.ProjectMaster b where  ProjectId=@ProjectId)
set @SEndDate =(select max(b.End_Date) from dbo.ProjectMaster b where ProjectId=@ProjectId)
if not exists(select * from dbo.BoqEntryDetails b where StartDate=@SStartDate and EndDate=@SEndDate and  MainItemId=0 and BOQType=@flag and ProjectId=@ProjectId)
Update BoqEntryDetails set StartDate=@SStartDate,EndDate=@SEndDate where MainItemId=0 and BOQType=@flag and ProjectId=@ProjectId
end


if exists (select * from dbo.BoqEntryDetails b where  b.SubSubItem!='' and BOQType=@flag and ProjectId=@ProjectId)
begin
set @SQty =(select sum(b.Qty) from dbo.BoqEntryDetails b where  MainItemId=@MainItemId  and b.SubItem=@subitem and b.SubSubItem!='' and BOQType=@flag and ProjectId=@ProjectId)
set @SAmt =(select sum(b.TotalCost) from dbo.BoqEntryDetails b where  MainItemId=@MainItemId and b.SubItem=@subitem and b.SubSubItem!='' and BOQType=@flag and ProjectId=@ProjectId)
Update BoqEntryDetails set Qty=@SQty,TotalCost=@SAmt where MainItemId=@MainItemId and SubItem=@subitem  and SubItem!='' and SubSubItem='' and BOQType=@flag and ProjectId=@ProjectId

set @MAmt =(select sum(b.TotalCost) from dbo.BoqEntryDetails b where  MainItemId=@MainItemId and b.SubItem!='' and SubSubItem='' and BOQType=@flag and ProjectId=@ProjectId)
set @MQty =(select sum(b.Qty) from dbo.BoqEntryDetails b where  MainItemId=@MainItemId and b.SubItem!='' and SubSubItem='' and BOQType=@flag and ProjectId=@ProjectId)
Update BoqEntryDetails set Qty=@MQty,TotalCost=@MAmt where MainItemId=@MainItemId and SubItem='' and BOQType=@flag  and ProjectId=@ProjectId

set @PAmt =(select sum(b.TotalCost) from dbo.BoqEntryDetails b where  MainItemId!=0 and  b.SubItem='' and BOQType=@flag and ProjectId=@ProjectId)
set @PQty =(select sum(b.Qty) from dbo.BoqEntryDetails b where  MainItemId!=0  and b.SubItem='' and BOQType=@flag and ProjectId=@ProjectId)
Update BoqEntryDetails set Qty=@PQty,TotalCost=@PAmt where MainItemId=0 and BOQType=@flag and ProjectId=@ProjectId

end
end

else if(@flag='V')
begin
if exists(select * from dbo.BoqEntryDetails b where  MainItemId=@MainItemId and RefId=3 and BOQType=@flag and ProjectId=@ProjectId)
begin
set @SStartDate =(select min(b.StartDate) from dbo.BoqEntryDetails b where  MainItemId=@MainItemId and RefId=3 and BOQType=@flag and ProjectId=@ProjectId)
set @SEndDate =(select max(b.EndDate) from dbo.BoqEntryDetails b where  MainItemId=@MainItemId and RefId=3 and BOQType=@flag and ProjectId=@ProjectId)
set @Smyday = (DATEDIFF(DAY, @SStartDate, @SEndDate))
Update BoqEntryDetails set StartDate=@SStartDate,EndDate=@SEndDate,Duration=@Smyday+1 where MainItemId=@MainItemId  and RefId=2 and BOQType=@flag and ProjectId=@ProjectId
end


if exists (select * from dbo.BoqEntryDetails b where  b.MainItemId=@MainItemId and RefId=2 and BOQType=@flag and ProjectId=@ProjectId)
begin
set @PStartDate =(select min(b.StartDate) from dbo.BoqEntryDetails b where  MainItemId!=0 and RefId=2   and BOQType=@flag and ProjectId=@ProjectId)
set @PEndDate =(select max(b.EndDate) from dbo.BoqEntryDetails b where  MainItemId!=0  and RefId=2  and BOQType=@flag and ProjectId=@ProjectId)
set @Pmyday = (DATEDIFF(DAY, @PStartDate, @PEndDate))

Update BoqEntryDetails set StartDate=@PStartDate,EndDate=@PEndDate,Duration=@Pmyday+1 where MainItemId=0  and BOQType=@flag and ProjectId=@ProjectId
end

if exists (select * from dbo.BoqEntryDetails b where   MainItemId=@MainItemId and RefId=3 and BOQType=@flag and ProjectId=@ProjectId)
begin
set @SQty =(select sum(b.Qty) from dbo.BoqEntryDetails b where    MainItemId=@MainItemId and RefId=3  and BOQType=@flag and ProjectId=@ProjectId)
set @SAmt =(select sum(b.TotalCost) from dbo.BoqEntryDetails b where    MainItemId=@MainItemId and RefId=3  and BOQType=@flag and ProjectId=@ProjectId)
Update BoqEntryDetails set Qty=@SQty,TotalCost=@SAmt where MainItemId=@MainItemId  and RefId=2 and BOQType=@flag and ProjectId=@ProjectId
end

if exists (select * from dbo.BoqEntryDetails b where   RefId=2 and BOQType=@flag and ProjectId=@ProjectId)
begin
set @PAmt =(select sum(b.TotalCost) from dbo.BoqEntryDetails b where  RefId=2  and BOQType=@flag and ProjectId=@ProjectId)
set @PQty =(select sum(b.Qty) from dbo.BoqEntryDetails b where    RefId=2  and BOQType=@flag and ProjectId=@ProjectId)
Update BoqEntryDetails set Qty=@PQty,TotalCost=@PAmt where MainItemId=0 and BOQType=@flag and ProjectId=@ProjectId
end
end
else 
begin
declare @SSWAmt decimal
declare @SWAmt decimal
declare @MWAmt decimal
set @flag='P'
if exists (select * from dbo.BoqEntryDetails b where   MainItemId=@MainItemId and RefId=4 and BOQType=@flag and ProjectId=@ProjectId)
begin
set @SSWAmt =(select sum(b.Workdonecost) from dbo.BoqEntryDetails b where    MainItemId=@MainItemId and RefId=4  and BOQType=@flag and ProjectId=@ProjectId)
Update BoqEntryDetails set Workdonecost=@SSWAmt where MainItemId=@MainItemId  and RefId=3 and BOQType=@flag and ProjectId=@ProjectId
end

if exists (select * from dbo.BoqEntryDetails b where   MainItemId=@MainItemId and RefId=3 and BOQType=@flag and ProjectId=@ProjectId)
begin
set @SWAmt =(select sum(b.Workdonecost) from dbo.BoqEntryDetails b where    MainItemId=@MainItemId and RefId=3  and BOQType=@flag and ProjectId=@ProjectId)
Update BoqEntryDetails set Workdonecost=@SWAmt where MainItemId=@MainItemId  and RefId=2 and BOQType=@flag and ProjectId=@ProjectId
end

if exists (select * from dbo.BoqEntryDetails b where   MainItemId=@MainItemId and RefId=2 and BOQType=@flag and ProjectId=@ProjectId)
begin 
set @MWAmt =(select sum(b.Workdonecost) from dbo.BoqEntryDetails b where    MainItemId=@MainItemId and RefId=2 and BOQType=@flag and ProjectId=@ProjectId)
Update BoqEntryDetails set Workdonecost=@MWAmt where MainItemId=0   and BOQType=@flag and ProjectId=@ProjectId
end


set @flag='V'
if exists (select * from dbo.BoqEntryDetails b where   MainItemId=@MainItemId and RefId=4 and BOQType=@flag and ProjectId=@ProjectId)
begin
set @SSWAmt =(select sum(b.Workdonecost) from dbo.BoqEntryDetails b where    MainItemId=@MainItemId and RefId=4  and BOQType=@flag and ProjectId=@ProjectId)
Update BoqEntryDetails set Workdonecost=@SSWAmt where MainItemId=@MainItemId  and RefId=3 and BOQType=@flag and ProjectId=@ProjectId
end

if exists (select * from dbo.BoqEntryDetails b where   MainItemId=@MainItemId and RefId=3 and BOQType=@flag and ProjectId=@ProjectId)
begin
set @SWAmt =(select sum(b.Workdonecost) from dbo.BoqEntryDetails b where    MainItemId=@MainItemId and RefId=3  and BOQType=@flag and ProjectId=@ProjectId)
Update BoqEntryDetails set Workdonecost=@SWAmt where MainItemId=@MainItemId  and RefId=2 and BOQType=@flag and ProjectId=@ProjectId
end

if exists (select * from dbo.BoqEntryDetails b where   MainItemId=@MainItemId and RefId=2 and BOQType=@flag and ProjectId=@ProjectId)
begin 
set @MWAmt =(select sum(b.Workdonecost) from dbo.BoqEntryDetails b where    MainItemId=@MainItemId and RefId=2 and BOQType=@flag and ProjectId=@ProjectId)
Update BoqEntryDetails set Workdonecost=@MWAmt where MainItemId=0   and BOQType=@flag and ProjectId=@ProjectId
end


end
select @myday as ok
end
GO
/****** Object:  StoredProcedure [dbo].[CriticalPath_Report]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[CriticalPath_Report](@ProjectId bigint)
as
begin 
;with t as (
select SubSubItem,SUM(Duration) as Duration from dbo.BoqEntryDetails bd 
where bd.BOQType='P' and SubSubItem!=''
and bd.WorkdonePer!=100
and (select End_Date from dbo.ProjectMaster p where p.ProjectId=bd.ProjectId) < bd.EndDate
and bd.Flag='V'
and bd.ProjectId=@ProjectId
group by  SubSubItem
)
select bd.BOQRefId as id,bd.DescriptionName  as text,bd.MainItem as name,bd.SubItem  as subitem,t.SubSubItem as subsubitem,t.Duration as duration  from t
join dbo.BoqEntryDetails bd on t.SubSubItem=bd.SubSubItem
end

GO
/****** Object:  StoredProcedure [dbo].[Get_BOQRefid]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Get_BOQRefid] (@refid int,@ParentId varchar(30),@boqtype varchar(2),@ProjectId bigint)
--,@tasId varchar(30)
as
begin
--declare @refid int=0
--declare @ParentId varchar(30)='1536897835992' 


declare @boqrefid varchar(30)
declare @id varchar(10)
declare @ss varchar(10)
declare @ss1 varchar(10)


if(@boqtype='P')
begin

if(@refid=5)
begin
declare @boqid varchar(20) 
set @boqid = (select ISNULL(BOQRefId,'') as BOQRefId from dbo.BoqEntryDetails b where b.BOQType='P' and  ProjectId=@ProjectId and   TaskId=@ParentId)
set @id=(select  ISNULL(max(cast(Replace(BOQRefId,@boqid+'.','')as int)+1),0) from dbo.BoqEntryDetails b where b.BOQType='P'and b.RefId=@refid and ProjectId=@ProjectId and  ParentId=@ParentId) 
if(@id=0)
set @boqrefid=@boqid +'.1'
else
set @boqrefid=@boqid +'.'+@id

declare @TaskId varchar(20) 
set @TaskId = (select ISNULL(TaskId,'') as TaskId from dbo.BoqEntryDetails b where b.BOQType='P' and  ProjectId=@ProjectId and   TaskId=@ParentId)
--if(@TaskId!='')
--update dbo.BoqEntryDetails set ParentId=@TaskId where TaskId=@tasId
end



if(@refid=4)
begin
set @id=( select ISNULL(max(cast(RIGHT(BOQRefId,LEN(BOQRefId)-CHARINDEX('.',BOQRefId))as int)+1),0) from dbo.BoqEntryDetails b where b.BOQType='P' and b.RefId=@refid and ParentId=@ParentId and ProjectId=@ProjectId)
set @ss=( select top 1 ISNULL(LEFT(BOQRefId,CHARINDEX('.',BOQRefId)-1),'') from dbo.BoqEntryDetails b where b.BOQType='P' and b.RefId=@refid and ParentId=@ParentId and ProjectId=@ProjectId)
if(@id=0)
begin
set @ss=( select top 1 ISNULL(LEFT(BOQRefId,CHARINDEX('.',BOQRefId)-1),'') from dbo.BoqEntryDetails b where b.BOQType='P' and b.RefId=@refid and ProjectId=@ProjectId order by BOQId Desc )
if(@ss is null)
begin
set @boqrefid='S10.1'
end
else
begin
set @ss1=(select cast(RIGHT(@ss,LEN(@ss)-CHARINDEX('S',@ss))as int)+10)
set @ss='S'+@ss1
set @id=1
set @boqrefid=@ss+'.'+@id
end
end
else
set @boqrefid=@ss+'.'+@id
end

if(@refid=3)
begin
set @id=( select ISNULL(max(cast(RIGHT(BOQRefId,LEN(BOQRefId)-CHARINDEX('S',BOQRefId))as int)+10),0) from dbo.BoqEntryDetails b where b.BOQType='P' and b.RefId=@refid and ProjectId=@ProjectId)
if(@id=0)
set @boqrefid='S10'
else
set @boqrefid='S'+@id
end

if(@refid=2)
begin
set @id=( select ISNULL(max(cast(RIGHT(BOQRefId,LEN(BOQRefId)-CHARINDEX('M',BOQRefId))as int)+10),0) from dbo.BoqEntryDetails b where b.BOQType='P' and b.RefId=@refid and ProjectId=@ProjectId)
if(@id=0)
set @boqrefid='M10'
else
set @boqrefid='M'+@id
end

if(@refid=0)
begin
set @id=( select ISNULL(max(cast(RIGHT(BOQRefId,LEN(BOQRefId)-CHARINDEX('P',BOQRefId))as int)+10),0) from dbo.BoqEntryDetails b where b.BOQType='P' and b.RefId=@refid and ProjectId=@ProjectId)
if(@id=0)
set @boqrefid='P10'
else
set @boqrefid='P'+@id
end
end

else
begin

if(@refid=3)
begin
set @id=( select ISNULL(max(cast(RIGHT(BOQRefId,LEN(BOQRefId)-CHARINDEX('.',BOQRefId))as int)+1),0) from dbo.BoqEntryDetails b where b.BOQType='V' and b.RefId=@refid and ParentId=@ParentId and ProjectId=@ProjectId)
set @ss=( select top 1 ISNULL(LEFT(BOQRefId,CHARINDEX('.',BOQRefId)-1),'') from dbo.BoqEntryDetails b where b.BOQType='V' and b.RefId=@refid and ParentId=@ParentId and ProjectId=@ProjectId)
if(@id=0)
begin
set @ss=( select top 1 ISNULL(LEFT(BOQRefId,CHARINDEX('.',BOQRefId)-1),'') from dbo.BoqEntryDetails b where b.BOQType='V' and b.RefId=@refid and ProjectId=@ProjectId order by BOQId Desc )
if(@ss is null)
begin
set @boqrefid='SV10.1'
end
else
begin
set @ss1=(select cast(RIGHT(@ss,LEN(@ss)-CHARINDEX('V',@ss))as int)+10)
set @ss='SV'+@ss1
set @id=1
set @boqrefid=@ss+'.'+@id
end
end
else
set @boqrefid=@ss+'.'+@id
end

--if(@refid=3)
--begin
--set @id=( select ISNULL(max(cast(RIGHT(BOQRefId,LEN(BOQRefId)-CHARINDEX('V',BOQRefId))as int)+10),0) from dbo.BoqEntryDetails b where b.BOQType='V' and b.RefId=@refid)
--if(@id=0)
--set @boqrefid='SV10'
--else
--set @boqrefid='SV'+@id
--end

if(@refid=2)
begin
set @id=( select ISNULL(max(cast(RIGHT(BOQRefId,LEN(BOQRefId)-CHARINDEX('V',BOQRefId))as int)+10),0) from dbo.BoqEntryDetails b where b.BOQType='V' and b.RefId=@refid and ProjectId=@ProjectId)
if(@id=0)
set @boqrefid='MV10'
else
set @boqrefid='MV'+@id
end

if(@refid=0)
begin
set @id=( select ISNULL(max(cast(RIGHT(BOQRefId,LEN(BOQRefId)-CHARINDEX('V',BOQRefId))as int)+10),0) from dbo.BoqEntryDetails b where b.BOQType='V' and b.RefId=@refid and ProjectId=@ProjectId)
if(@id=0)
set @boqrefid='PV10'
else
set @boqrefid='PV'+@id
end


end



select @boqrefid as boqrefid
end


--exec Get_BOQRefid 3,'1536897835992','P',18
GO
/****** Object:  StoredProcedure [dbo].[Get_MaxEF]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Get_MaxEF](@ProjectId bigint,@BOQId bigint,@flag nvarchar(10))
as
begin
DECLARE @AUX nvarchar(255);
set @AUX =  (select distinct Predec from dbo.CriticalPathDetails where Flag=@flag and ProjectId=@ProjectId and  BOQId=@BOQId)
select max(EF) as maxdur from dbo.CriticalPathDetails where Flag=@flag and ProjectId=@ProjectId and BOQRefId in ( select * from dbo.fnSplitString(@AUX,','))
end
GO
/****** Object:  StoredProcedure [dbo].[Get_MInLF]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Get_MInLF](@ProjectId bigint,@BOQId bigint,@flag nvarchar(10))
as
begin
DECLARE @AUX nvarchar(255);
set @AUX =  (select distinct dep from dbo.CriticalPathDetails where Flag=@flag and ProjectId=@ProjectId and  BOQId=@BOQId)
select ISNULL(min(LS),0) as maxdur from dbo.CriticalPathDetails where Flag=@flag and ProjectId=@ProjectId and BOQRefId in ( select * from dbo.fnSplitString(@AUX,','))
end

--exec Get_MInLF 17,333
GO
/****** Object:  StoredProcedure [dbo].[Link_Update]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Link_Update] (@ProjectId bigint,@TaskId varchar(100),@SourceId  varchar(100),@TargetId varchar(100),@LinkType int,@flag nvarchar(10))
as
begin
declare @BOQId bigint
set @BOQId = (select BOQId from BoqEntryDetails where  TaskId=@TargetId and ProjectId=@ProjectId)
IF NOT EXISTS (select BOQId from BOQLinkDetails where  ProjectId=@ProjectId and BOQId=@BOQId)
insert into BOQLinkDetails values (@BOQId,@ProjectId,@TaskId,@SourceId,@TargetId,@LinkType,'orange',@flag)
end

GO
/****** Object:  StoredProcedure [dbo].[Save_BOQ]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Save_BOQ] (@myproj bigint,@location bigint,@locationname nvarchar(250),@mainitem bigint,@mainitemname nvarchar(250),@subitem nvarchar(250),@subsubitem nvarchar(250),@boq nvarchar(100),@task nvarchar(250),@unit varchar(10),@qty decimal(18, 2),@urate decimal(18, 2),@cost decimal(18, 2) ,@step bigint,@id varchar(100),@parent varchar(100),@clientid bigint,@userid bigint, @brefid varchar(20),@dep varchar(20))
as
begin 

declare @linktype bigint
--if(@step = 4)
--set @linktype=3
--else 
set @linktype=@step


insert into BoqEntryDetails (ProjectId,DescriptionId,DescriptionName,MainItemId,MainItem,SubItem,SubSubItem,BoqRef,Task,Unit,Qty,UnitRate,TotalCost,WorkdonePer,Priority,RefId,TaskId,ParentId,ClientId,UserId,BOQType,BOQRefId,Workdonecost,Flag,dep) values(@myproj,@location,@locationname,@mainitem,@mainitemname,@subitem,@subsubitem,@boq,@task,@unit,@qty,@urate,@cost,0,0,@linktype ,@id,@parent,@clientid,@userid,'P',@brefid,0,'P',@dep)
declare @BOQId bigint
set @BOQId = (select BOQId from BoqEntryDetails where  TaskId=@id and ProjectId=@myproj)

if( @brefid like '%S%' or @brefid like '%P%')
begin
if not exists (select * from CriticalPathDetails where BOQId=@BOQId and TaskId=@id and ProjectId=@myproj)
insert into dbo.CriticalPathDetails (ProjectId,BOQId,TaskId,BOQRefId,dep,Flag) values (@myproj,@BOQId,@id,@brefid,@dep,'P')

if not exists (select * from BOQLinkDetails where BOQId=@BOQId and TaskId=@id and SourceId=@parent and ProjectId=@myproj)
insert into BOQLinkDetails (BOQId,ProjectId,TaskId,SourceId,TargetId,Mcolor,Flag) values (@BOQId,@myproj,@id,@parent,@id,'orange','P')
end
end
GO
/****** Object:  StoredProcedure [dbo].[Save_Project]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Save_Project] (@ClientId bigint,@ProjectName nvarchar(200),@ProjectLocation  nvarchar(200),@ProjectIncharge nvarchar(200),@ContactNo nvarchar(50),@EmailId nvarchar(200),@Start_Date datetime,@End_Date datetime,@duration  nvarchar(50),@userid int,@Status int,@Fromday  nvarchar(50),@Today  nvarchar(50),@Fromtime  nvarchar(50),@Totime nvarchar(50))
as
begin
insert into ProjectMaster values( @ClientId , @ProjectName , @ProjectLocation , @ProjectIncharge , @ContactNo , @EmailId , @Start_Date,@End_Date,@duration ,@userid ,@Status,@Fromday,@Today,@Fromtime,@Totime)
end
GO
/****** Object:  StoredProcedure [dbo].[Update_BoqReviseDetails]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Update_BoqReviseDetails] (@ReviseType varchar(50),@RStartDate datetime,@REndDate datetime,@RDuration int,@userid int,@SysDate datetime,@BOQId int,@ProjectId bigint,@Flag int)
as
begin
if(@Flag=0)
insert into BoqReviseDetails values(@BOQId,@ReviseType,@RStartDate,@REndDate,@userid,@SysDate,'P',@SysDate,@ProjectId)
else if(@Flag=1)
Update BoqReviseDetails set RStartDate=@RStartDate,REndDate=@REndDate where BOQId=@BOQId
else if(@Flag=2)
Update BoqEntryDetails set RVStartDate=@RStartDate,RVEndDate=@REndDate,RDuration=@RDuration where BOQId=@BOQId
else
Update BoqReviseDetails set FDate=@SysDate,Flag='F' where BOQId=@BOQId
select 'OK' as ok
end 
GO
/****** Object:  UserDefinedFunction [dbo].[fnSplitString]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnSplitString] 
( 
    @string NVARCHAR(MAX), 
    @delimiter CHAR(1) 
) 
RETURNS @output TABLE(splitdata NVARCHAR(MAX) 
) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (splitdata)  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
        
    END 
    RETURN 
END
GO
/****** Object:  Table [dbo].[BlockDetails]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlockDetails](
	[BlockId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProjectId] [bigint] NOT NULL,
	[BlockName] [nvarchar](150) NULL,
	[LoweRoof] [int] NULL,
	[UpperRoof] [int] NULL,
	[BlockQty] [int] NULL,
 CONSTRAINT [PK_BlockDetails] PRIMARY KEY CLUSTERED 
(
	[BlockId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BoqDailyProcess]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BoqDailyProcess](
	[DId] [bigint] IDENTITY(1,1) NOT NULL,
	[WorkdonePer] [decimal](18, 2) NULL,
	[BOQId] [bigint] NOT NULL,
	[Date] [datetime] NULL,
	[UserId] [int] NULL,
	[WorkdoneType] [nvarchar](50) NULL,
 CONSTRAINT [PK_BoqDailyProcess] PRIMARY KEY CLUSTERED 
(
	[DId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BoqEntryDetails]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BoqEntryDetails](
	[BOQId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProjectId] [bigint] NULL,
	[DescriptionId] [bigint] NULL,
	[DescriptionName] [nvarchar](250) NULL,
	[MainItemId] [bigint] NULL,
	[MainItem] [nvarchar](250) NULL,
	[SubItem] [nvarchar](250) NULL,
	[SubSubItem] [nvarchar](250) NULL,
	[BoqRef] [nvarchar](100) NULL,
	[Task] [nvarchar](250) NULL,
	[Unit] [varchar](10) NULL,
	[Qty] [decimal](18, 2) NULL,
	[UnitRate] [decimal](18, 2) NULL,
	[TotalCost] [decimal](18, 2) NULL,
	[WorkdonePer] [decimal](18, 2) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Duration] [decimal](18, 2) NULL,
	[Priority] [bigint] NULL,
	[RefId] [varchar](100) NULL,
	[TaskId] [varchar](100) NULL,
	[ParentId] [varchar](100) NULL,
	[ClientId] [bigint] NULL,
	[UserId] [int] NULL,
	[Workdonedate] [datetime] NULL CONSTRAINT [DF_BoqEntryDetails_Workdonedate]  DEFAULT (getdate()),
	[BOQType] [varchar](10) NULL,
	[BOQRefId] [varchar](20) NULL,
	[Workdonecost] [decimal](18, 2) NULL,
	[Flag] [varchar](2) NULL,
	[dep] [varchar](20) NULL,
	[Predec] [varchar](20) NULL,
	[Criticaltaskid] [varchar](100) NULL,
	[RVStartDate] [datetime] NULL,
	[RVEndDate] [datetime] NULL,
	[RDuration] [decimal](18, 2) NULL,
 CONSTRAINT [PK_BoqEntryDetails_1] PRIMARY KEY CLUSTERED 
(
	[BOQId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BOQLinkDetails]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BOQLinkDetails](
	[BoqLinkId] [bigint] IDENTITY(1,1) NOT NULL,
	[BOQId] [bigint] NULL,
	[ProjectId] [bigint] NULL,
	[TaskId] [varchar](100) NULL,
	[SourceId] [varchar](100) NULL,
	[TargetId] [varchar](100) NULL,
	[LinkType] [int] NULL,
	[Mcolor] [varchar](50) NULL,
	[Flag] [nvarchar](20) NULL,
 CONSTRAINT [PK_BOQLinkDetails] PRIMARY KEY CLUSTERED 
(
	[BoqLinkId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BoqReviseDetails]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BoqReviseDetails](
	[ReviseId] [bigint] IDENTITY(1,1) NOT NULL,
	[BOQId] [bigint] NOT NULL,
	[ReviseType] [nvarchar](50) NULL,
	[RStartDate] [datetime] NULL,
	[REndDate] [datetime] NULL,
	[UserId] [int] NULL,
	[EntryDate] [datetime] NULL,
	[Flag] [varchar](2) NULL,
	[FDate] [datetime] NULL,
	[ProjectId] [bigint] NULL,
 CONSTRAINT [PK_BoqReviseDetails] PRIMARY KEY CLUSTERED 
(
	[ReviseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Client]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Client](
	[ClientId] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyId] [int] NOT NULL,
	[ClientCode] [nvarchar](20) NULL,
	[ClientName] [nvarchar](200) NULL,
	[TaxNo] [nvarchar](50) NULL,
	[GSTNo] [nvarchar](50) NULL,
	[ContactPerson] [nvarchar](100) NULL,
	[Designation] [nvarchar](100) NULL,
	[HandPhoneNo] [nvarchar](50) NULL,
	[TelePhoneNo] [nvarchar](50) NULL,
	[EmailId] [nvarchar](50) NULL,
	[Website] [nvarchar](50) NULL,
	[UintNo] [nvarchar](50) NULL,
	[Building] [nvarchar](250) NULL,
	[Street] [nvarchar](250) NULL,
	[City] [nvarchar](50) NULL,
	[State] [nvarchar](50) NULL,
	[StateCode] [int] NULL,
	[Pincode] [bigint] NULL,
	[CountryId] [int] NOT NULL,
	[NoofUser] [int] NULL,
	[Remark] [nvarchar](max) NULL,
	[ExprieDate] [datetime] NULL,
	[Modfied_Date] [datetime] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED 
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientMaster]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientMaster](
	[ClientId] [bigint] NOT NULL,
	[ClientCode] [nvarchar](20) NULL,
	[ClientName] [nvarchar](200) NULL,
	[TaxNo] [nvarchar](50) NULL,
	[GSTNo] [nvarchar](50) NULL,
	[ContactPerson] [nvarchar](100) NULL,
	[Designation] [nvarchar](100) NULL,
	[HandPhoneNo] [nvarchar](50) NULL,
	[TelePhoneNo] [nvarchar](50) NULL,
	[EmailId] [nvarchar](50) NULL,
	[Website] [nvarchar](50) NULL,
	[UintNo] [nvarchar](50) NULL,
	[Building] [nvarchar](250) NULL,
	[Street] [nvarchar](250) NULL,
	[City] [nvarchar](50) NULL,
	[State] [nvarchar](50) NULL,
	[StateCode] [int] NULL,
	[Pincode] [bigint] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_ClientMaster] PRIMARY KEY CLUSTERED 
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientReg]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientReg](
	[ClientId] [bigint] NOT NULL,
	[ClientName] [nvarchar](200) NULL,
	[TaxNo] [nvarchar](50) NULL,
	[GSTNo] [nvarchar](50) NULL,
	[ContactPerson] [nvarchar](100) NULL,
	[Designation] [nvarchar](100) NULL,
	[HandPhoneNo] [nvarchar](50) NULL,
	[TelePhoneNo] [nvarchar](50) NULL,
	[EmailId] [nvarchar](50) NULL,
	[Website] [nvarchar](50) NULL,
	[UintNo] [nvarchar](50) NULL,
	[Building] [nvarchar](250) NULL,
	[Street] [nvarchar](250) NULL,
	[City] [nvarchar](50) NULL,
	[State] [nvarchar](50) NULL,
	[StateCode] [int] NULL,
	[Pincode] [bigint] NULL,
	[CountryId] [int] NOT NULL,
	[NoofUser] [nvarchar](50) NULL,
	[Remark] [nvarchar](max) NULL,
	[Modfied_Date] [datetime] NULL,
	[License] [int] NULL,
	[Cost] [decimal](18, 2) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_ClientReg] PRIMARY KEY CLUSTERED 
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Company]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[CompanyId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](100) NULL,
	[UintNo] [nvarchar](50) NULL,
	[Building] [nvarchar](250) NULL,
	[Street] [nvarchar](250) NULL,
	[City] [nvarchar](50) NULL,
	[State] [nvarchar](50) NULL,
	[StateCode] [int] NULL,
	[Pincode] [bigint] NULL,
	[Country] [nvarchar](50) NULL,
	[TaxNo] [nvarchar](50) NULL,
	[GSTNo] [nvarchar](50) NULL,
	[AuthorisedPerson] [nvarchar](100) NULL,
	[HandPhoneNo] [nvarchar](50) NULL,
	[TelePhoneNo] [nvarchar](50) NULL,
	[EmailId] [nvarchar](50) NULL,
	[Website] [nvarchar](50) NULL,
 CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Country]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryId] [int] IDENTITY(1,1) NOT NULL,
	[Country_Name] [nvarchar](50) NULL,
	[Country_Code] [nvarchar](20) NULL,
	[Country_TimeZone] [nvarchar](50) NULL,
	[Country_Currency] [nvarchar](50) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CriticalPathDetails]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CriticalPathDetails](
	[CriticalId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProjectId] [bigint] NULL,
	[BOQId] [bigint] NULL,
	[TaskId] [varchar](100) NOT NULL,
	[BOQRefId] [varchar](20) NULL,
	[dep] [varchar](20) NULL,
	[Duration] [decimal](18, 2) NULL,
	[ES] [decimal](18, 2) NULL,
	[EF] [decimal](18, 2) NULL,
	[Predec] [varchar](20) NULL,
	[LS] [decimal](18, 2) NULL,
	[LF] [decimal](18, 2) NULL,
	[Slack] [decimal](18, 2) NULL,
	[Criticaltaskid] [varchar](100) NULL,
	[Flag] [nvarchar](20) NULL,
 CONSTRAINT [PK_CriticalPathDetails] PRIMARY KEY CLUSTERED 
(
	[CriticalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DatabaseDetails]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatabaseDetails](
	[DatabaseId] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyId] [int] NOT NULL,
	[ClientId] [bigint] NOT NULL,
	[Server_Name] [nvarchar](50) NULL,
	[DB_Name] [nvarchar](50) NULL,
	[DB_Username] [nvarchar](50) NULL,
	[DB_Password] [nvarchar](50) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_DatabaseDetails] PRIMARY KEY CLUSTERED 
(
	[DatabaseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ExternalWorkDetails]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ExternalWorkDetails](
	[ExDetId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProjectId] [bigint] NOT NULL,
	[ExternalWork] [nvarchar](250) NOT NULL,
	[Units] [varchar](20) NULL,
	[Qty] [int] NULL,
 CONSTRAINT [PK_ExternalWorkDetails] PRIMARY KEY CLUSTERED 
(
	[ExDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ExternalWorkMaster]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExternalWorkMaster](
	[ExId] [nvarchar](250) NOT NULL,
	[ExternalWork] [nvarchar](150) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_ExternalWork] PRIMARY KEY CLUSTERED 
(
	[ExId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FoundationDetails]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoundationDetails](
	[FoundationId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProjectId] [bigint] NOT NULL,
	[FoundationName] [nvarchar](250) NULL,
 CONSTRAINT [PK_FoundationDetails] PRIMARY KEY CLUSTERED 
(
	[FoundationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HolidayMaster]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HolidayMaster](
	[HId] [bigint] IDENTITY(1,1) NOT NULL,
	[ClientId] [bigint] NOT NULL,
	[HolidayName] [nvarchar](250) NULL,
	[HolidayDate] [datetime] NULL,
	[Status] [nvarchar](50) NULL,
 CONSTRAINT [PK_HolidayMaster] PRIMARY KEY CLUSTERED 
(
	[HId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LocationMaster]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocationMaster](
	[LocationId] [bigint] IDENTITY(1,1) NOT NULL,
	[LocationName] [nvarchar](250) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_LocationMaster] PRIMARY KEY CLUSTERED 
(
	[LocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MainItemMaster]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MainItemMaster](
	[MainItemId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProjectId] [bigint] NOT NULL,
	[MainItemName] [nvarchar](500) NULL,
	[Cost] [decimal](18, 2) NULL,
 CONSTRAINT [PK_MainItemMaster] PRIMARY KEY CLUSTERED 
(
	[MainItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MenuDetails]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuDetails](
	[MID] [bigint] IDENTITY(1,1) NOT NULL,
	[Formname] [nvarchar](200) NULL,
	[RouteName] [nvarchar](200) NULL,
	[ParentId] [bigint] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_MenuDetails] PRIMARY KEY CLUSTERED 
(
	[MID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectDescription]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectDescription](
	[PDId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProjectId] [bigint] NOT NULL,
	[Foundation] [int] NULL,
	[Basement] [int] NULL,
	[Podium] [int] NULL,
	[Mezanine] [int] NULL,
	[CreateDate] [datetime] NULL CONSTRAINT [DF_ProjectDescription_CreateDate]  DEFAULT (getdate()),
	[UserId] [int] NULL,
 CONSTRAINT [PK_ProjectDescription] PRIMARY KEY CLUSTERED 
(
	[PDId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectDescriptionDetails]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectDescriptionDetails](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[RefId] [bigint] NULL,
	[ProjectId] [bigint] NOT NULL,
	[Name] [nvarchar](300) NULL,
	[Type] [nvarchar](10) NULL,
 CONSTRAINT [PK_ProjectDescriptionDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectMaster]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectMaster](
	[ProjectId] [bigint] IDENTITY(1,1) NOT NULL,
	[ClientId] [bigint] NOT NULL,
	[ProjectName] [nvarchar](250) NULL,
	[ProjectLocation] [nvarchar](250) NULL,
	[ProjectIncharge] [nvarchar](250) NULL,
	[ContactNo] [nvarchar](250) NULL,
	[EmailId] [nvarchar](250) NULL,
	[Start_Date] [datetime] NULL,
	[End_Date] [datetime] NULL,
	[ProjectDuration] [nvarchar](50) NULL,
	[UserId] [bigint] NOT NULL,
	[Status] [int] NULL,
	[Fromday] [nvarchar](50) NULL,
	[Today] [nvarchar](50) NULL,
	[Fromtime] [nvarchar](50) NULL,
	[Totime] [nvarchar](50) NULL,
 CONSTRAINT [PK_ProjectMaster] PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubItemMaster]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubItemMaster](
	[SubItemId] [bigint] IDENTITY(1,1) NOT NULL,
	[MainItemId] [bigint] NOT NULL,
	[SubItemName] [nvarchar](250) NULL,
	[SubItemDescription] [nvarchar](500) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_SubItemMaster] PRIMARY KEY CLUSTERED 
(
	[SubItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubSubItemMaster]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubSubItemMaster](
	[SubSubItemId] [bigint] IDENTITY(1,1) NOT NULL,
	[SubItemId] [bigint] NOT NULL,
	[SubSubItemName] [nvarchar](250) NULL,
	[SubSubItemDescription] [nvarchar](500) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_SubSubItemMaster] PRIMARY KEY CLUSTERED 
(
	[SubSubItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SupplierMaster]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupplierMaster](
	[SupplierId] [bigint] IDENTITY(1,1) NOT NULL,
	[ClientId] [bigint] NOT NULL,
	[Type] [nvarchar](50) NULL,
	[SupplierName] [nvarchar](200) NULL,
	[SupplierAddress] [nvarchar](max) NULL,
	[ContactPerson] [nvarchar](100) NULL,
	[ContactNo] [nvarchar](50) NULL,
	[EmailId] [nvarchar](50) NULL,
	[Modfied_Date] [datetime] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_SupplierMaster] PRIMARY KEY CLUSTERED 
(
	[SupplierId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserDetails]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserDetails](
	[UserId] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyId] [int] NOT NULL,
	[ClientId] [bigint] NULL,
	[ClientCode] [nvarchar](20) NULL,
	[Username] [nvarchar](100) NULL,
	[Password] [nvarchar](50) NULL,
	[User_Role_Id] [int] NOT NULL,
	[MaintanceDate] [datetime] NULL,
	[ExprieDate] [datetime] NULL,
	[Created_by] [nvarchar](100) NULL,
	[CreateDate] [datetime] NULL,
	[Modified_by] [nvarchar](100) NULL,
	[Modfied_Date] [datetime] NULL,
	[Status] [int] NULL,
	[Loginuser] [nvarchar](100) NULL,
	[Designation] [nvarchar](100) NULL,
	[Type] [int] NULL,
	[SupplierId] [bigint] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserPassReset]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPassReset](
	[UserRestId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[Password] [nvarchar](50) NULL,
	[Up_Date] [datetime] NULL,
 CONSTRAINT [PK_UserPassReset] PRIMARY KEY CLUSTERED 
(
	[UserRestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole](
	[User_RoleId] [int] IDENTITY(1,1) NOT NULL,
	[Role_Name] [nvarchar](100) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
(
	[User_RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserRoleMenu]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoleMenu](
	[UID] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyId] [int] NOT NULL,
	[ClientId] [bigint] NULL,
	[User_RoleId] [int] NOT NULL,
	[MID] [bigint] NOT NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_UserRoleMenu] PRIMARY KEY CLUSTERED 
(
	[UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserValidity]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserValidity](
	[ValidityId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[ClientId] [bigint] NOT NULL,
	[MaintanceDate] [datetime] NULL,
	[ExprieDate] [datetime] NULL,
 CONSTRAINT [PK_UserValidity] PRIMARY KEY CLUSTERED 
(
	[ValidityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[VariationMaster]    Script Date: 1/26/2019 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VariationMaster](
	[VID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProjectId] [bigint] NULL,
	[ClientId] [bigint] NULL,
	[VariationName] [nvarchar](250) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_VariationMaster] PRIMARY KEY CLUSTERED 
(
	[VID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[BlockDetails] ON 

GO
INSERT [dbo].[BlockDetails] ([BlockId], [ProjectId], [BlockName], [LoweRoof], [UpperRoof], [BlockQty]) VALUES (9, 1, N'BLOCK-X', 1, 1, 4)
GO
INSERT [dbo].[BlockDetails] ([BlockId], [ProjectId], [BlockName], [LoweRoof], [UpperRoof], [BlockQty]) VALUES (10, 1, N'TOWER-X', 1, 1, 4)
GO
INSERT [dbo].[BlockDetails] ([BlockId], [ProjectId], [BlockName], [LoweRoof], [UpperRoof], [BlockQty]) VALUES (11, 10, N'BLOCK-X', 0, 0, 1)
GO
INSERT [dbo].[BlockDetails] ([BlockId], [ProjectId], [BlockName], [LoweRoof], [UpperRoof], [BlockQty]) VALUES (12, 10, N'TOWER-X', 0, 0, 1)
GO
INSERT [dbo].[BlockDetails] ([BlockId], [ProjectId], [BlockName], [LoweRoof], [UpperRoof], [BlockQty]) VALUES (13, 11, N'BLOCK-X', 0, 0, 1)
GO
INSERT [dbo].[BlockDetails] ([BlockId], [ProjectId], [BlockName], [LoweRoof], [UpperRoof], [BlockQty]) VALUES (15, 19, N'BLOCK-1', 1, 1, 1)
GO
SET IDENTITY_INSERT [dbo].[BlockDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[BoqDailyProcess] ON 

GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (1, CAST(20.00 AS Decimal(18, 2)), 227, CAST(N'2018-05-13 14:16:48.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (2, CAST(80.00 AS Decimal(18, 2)), 227, CAST(N'2018-05-13 15:49:38.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (3, CAST(20.00 AS Decimal(18, 2)), 231, CAST(N'2018-05-13 15:50:44.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (4, CAST(20.00 AS Decimal(18, 2)), 235, CAST(N'2018-05-13 15:50:44.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (5, CAST(20.00 AS Decimal(18, 2)), 232, CAST(N'2018-05-16 01:59:55.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (6, CAST(20.00 AS Decimal(18, 2)), 232, CAST(N'2018-05-16 02:01:18.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (7, CAST(10.00 AS Decimal(18, 2)), 228, CAST(N'2018-05-21 14:46:00.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (8, CAST(10.00 AS Decimal(18, 2)), 228, CAST(N'2018-05-21 14:48:01.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (9, CAST(10.00 AS Decimal(18, 2)), 228, CAST(N'2018-05-21 14:58:06.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (10, CAST(10.00 AS Decimal(18, 2)), 228, CAST(N'2018-05-21 14:58:06.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (11, CAST(10.00 AS Decimal(18, 2)), 256, CAST(N'2018-05-29 23:58:23.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (12, CAST(10.00 AS Decimal(18, 2)), 250, CAST(N'2018-05-29 23:59:59.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (13, CAST(10.00 AS Decimal(18, 2)), 228, CAST(N'2018-06-04 05:45:34.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (14, CAST(30.00 AS Decimal(18, 2)), 228, CAST(N'2018-06-30 23:22:48.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (15, CAST(90.00 AS Decimal(18, 2)), 250, CAST(N'2018-07-11 07:46:49.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (16, CAST(80.00 AS Decimal(18, 2)), 231, CAST(N'2018-07-11 08:27:58.000' AS DateTime), 0, NULL)
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (17, CAST(20.00 AS Decimal(18, 2)), 232, CAST(N'2018-07-12 00:08:51.000' AS DateTime), 0, N'Workdone')
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (18, CAST(20.00 AS Decimal(18, 2)), 232, CAST(N'2018-07-12 00:25:32.000' AS DateTime), 0, N'ReviseWorkdone')
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (19, CAST(50.00 AS Decimal(18, 2)), 337, CAST(N'2018-09-30 14:04:11.000' AS DateTime), 17, N'Workdone')
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (20, CAST(50.00 AS Decimal(18, 2)), 337, CAST(N'2018-09-30 17:19:14.000' AS DateTime), 17, N'Workdone')
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (21, CAST(20.00 AS Decimal(18, 2)), 338, CAST(N'2018-09-30 17:44:15.000' AS DateTime), 17, N'Workdone')
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (22, CAST(50.00 AS Decimal(18, 2)), 338, CAST(N'2018-09-30 18:09:55.000' AS DateTime), 17, N'Workdone')
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (23, CAST(30.00 AS Decimal(18, 2)), 338, CAST(N'2018-10-03 06:46:35.000' AS DateTime), 17, N'Workdone')
GO
INSERT [dbo].[BoqDailyProcess] ([DId], [WorkdonePer], [BOQId], [Date], [UserId], [WorkdoneType]) VALUES (24, CAST(100.00 AS Decimal(18, 2)), 339, CAST(N'2018-10-04 19:12:29.000' AS DateTime), 17, N'ReviseWorkdone')
GO
SET IDENTITY_INSERT [dbo].[BoqDailyProcess] OFF
GO
SET IDENTITY_INSERT [dbo].[BoqEntryDetails] ON 

GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (222, 1, 1, N'BIMCAD Technologies', 0, N'', N'', N'', N'', N'', N'', CAST(99.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(6655.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-01 00:00:00.000' AS DateTime), CAST(N'2018-06-10 00:00:00.000' AS DateTime), CAST(40.00 AS Decimal(18, 2)), 1, N'0', N'1525032452196', N'0', NULL, NULL, NULL, N'P', N'P10', CAST(7350.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-01 00:00:00.000' AS DateTime), CAST(N'2018-06-10 00:00:00.000' AS DateTime), CAST(40.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (223, 1, 1, N'Foundation1', 9, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'', N'', N'', N'', N'', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(3600.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-01 00:00:00.000' AS DateTime), CAST(N'2018-06-13 00:00:00.000' AS DateTime), CAST(42.00 AS Decimal(18, 2)), 1, N'2', N'1525032452197', N'1525032452196', NULL, NULL, NULL, N'P', N'M10', CAST(7350.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-01 00:00:00.000' AS DateTime), CAST(N'2018-06-13 00:00:00.000' AS DateTime), CAST(42.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (224, 1, 1, N'Foundation1', 9, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'', N'01A', N'', N'', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1600.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-01 00:00:00.000' AS DateTime), CAST(N'2018-06-13 00:00:00.000' AS DateTime), CAST(42.00 AS Decimal(18, 2)), 2, N'3', N'1525032630985', N'1525032452197', NULL, NULL, NULL, N'P', N'S10', CAST(2450.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-01 00:00:00.000' AS DateTime), CAST(N'2018-06-13 00:00:00.000' AS DateTime), CAST(42.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (225, 1, 1, N'Foundation1', 9, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'Setting out 1', N'01A.01', N'Setting out 1', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(N'2018-05-01 00:00:00.000' AS DateTime), CAST(N'2018-05-03 00:00:00.000' AS DateTime), CAST(3.00 AS Decimal(18, 2)), 1, N'4', N'1525032889515', N'1525032630985', NULL, NULL, CAST(N'2018-05-03 00:00:00.000' AS DateTime), N'P', N'S10.1', CAST(500.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-01 00:00:00.000' AS DateTime), CAST(N'2018-05-03 00:00:00.000' AS DateTime), CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (226, 1, 1, N'Foundation1', 9, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'Setting out 2', N'01A.02', N'Setting out 2', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(N'2018-05-04 00:00:00.000' AS DateTime), CAST(N'2018-05-07 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 1, N'4', N'1525033218759', N'1525032630985', NULL, NULL, CAST(N'2018-05-04 00:00:00.000' AS DateTime), N'P', N'S10.2', CAST(400.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-04 00:00:00.000' AS DateTime), CAST(N'2018-05-07 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (227, 1, 1, N'Foundation1', 9, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'Setting out 3', N'01A.03', N'Setting out 3', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(N'2018-05-08 00:00:00.000' AS DateTime), CAST(N'2018-05-28 00:00:00.000' AS DateTime), CAST(21.00 AS Decimal(18, 2)), 1, N'4', N'1525033528842', N'1525032630985', NULL, NULL, CAST(N'2018-05-08 00:00:00.000' AS DateTime), N'P', N'S10.3', CAST(300.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-08 00:00:00.000' AS DateTime), CAST(N'2018-05-28 00:00:00.000' AS DateTime), CAST(21.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (228, 1, 1, N'Foundation1', 9, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'Setting out 4', N'01A.04', N'Setting out 4', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(N'2018-05-29 00:00:00.000' AS DateTime), CAST(N'2018-06-14 00:00:00.000' AS DateTime), CAST(17.00 AS Decimal(18, 2)), 1, N'4', N'1525034443513', N'1525032630985', NULL, NULL, CAST(N'2018-06-30 23:22:48.000' AS DateTime), N'P', N'S10.4', CAST(400.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-29 00:00:00.000' AS DateTime), CAST(N'2018-06-14 00:00:00.000' AS DateTime), CAST(17.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (229, 1, 1, N'Foundation1', 9, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Temporary power & lighting', N'', N'01B', N'', N'', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1350.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-09 00:00:00.000' AS DateTime), CAST(N'2018-05-21 00:00:00.000' AS DateTime), CAST(11.00 AS Decimal(18, 2)), 2, N'3', N'1525034521439', N'1525032452197', NULL, NULL, NULL, N'P', N'S20', CAST(2450.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-09 00:00:00.000' AS DateTime), CAST(N'2018-05-21 00:00:00.000' AS DateTime), CAST(11.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (231, 1, 1, N'Foundation1', 9, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Temporary power & lighting', N'Week 1', N'01B.01', N'Week 1', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(N'2018-05-09 00:00:00.000' AS DateTime), CAST(N'2018-05-13 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)), 1, N'4', N'1525089457286', N'1525034521439', NULL, NULL, CAST(N'2018-07-11 08:27:58.000' AS DateTime), N'P', N'S20.1', CAST(450.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-09 00:00:00.000' AS DateTime), CAST(N'2018-05-13 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (232, 1, 1, N'Foundation1', 9, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Temporary power & lighting', N'Week 2', N'01B.02', N'Week 2', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(80.00 AS Decimal(18, 2)), CAST(N'2018-05-14 00:00:00.000' AS DateTime), CAST(N'2018-05-16 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)), 1, N'4', N'1525089605294', N'1525034521439', NULL, NULL, CAST(N'2018-07-12 00:25:32.000' AS DateTime), N'P', N'S20.2', CAST(360.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-14 00:00:00.000' AS DateTime), CAST(N'2018-05-16 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (233, 1, 1, N'Foundation1', 9, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Temporary power & lighting', N'Week 3', N'01B.03', N'Week 3', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-17 00:00:00.000' AS DateTime), CAST(N'2018-05-21 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 1, N'4', N'1525090132635', N'1525034521439', NULL, NULL, NULL, N'P', N'S20.3', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-17 00:00:00.000' AS DateTime), CAST(N'2018-05-21 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (234, 1, 1, N'Foundation1', 9, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Periodic cleaning', N'', N'01C', N'', N'', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(650.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-12 00:00:00.000' AS DateTime), CAST(N'2018-05-22 00:00:00.000' AS DateTime), CAST(10.00 AS Decimal(18, 2)), 2, N'3', N'1526204211127', N'1525032452197', 1, 0, NULL, N'P', N'S30', CAST(2450.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-12 00:00:00.000' AS DateTime), CAST(N'2018-05-22 00:00:00.000' AS DateTime), CAST(10.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (235, 1, 1, N'Foundation1', 9, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Periodic cleaning', N'Week 1', N'01C.01', N'Week 1', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), CAST(N'2018-05-12 00:00:00.000' AS DateTime), CAST(N'2018-05-15 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 1, N'4', N'1526204308599', N'1526204211127', 1, 0, NULL, N'P', N'S30.1', CAST(40.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-12 00:00:00.000' AS DateTime), CAST(N'2018-05-15 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (236, 1, 1, N'Foundation1', 9, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Periodic cleaning', N'Week 2', N'01C.02', N'Week 2', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(250.00 AS Decimal(18, 2)), CAST(250.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-16 00:00:00.000' AS DateTime), CAST(N'2018-05-18 00:00:00.000' AS DateTime), CAST(3.00 AS Decimal(18, 2)), 1, N'4', N'1526204539386', N'1526204211127', 1, 0, NULL, N'P', N'S30.2', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-16 00:00:00.000' AS DateTime), CAST(N'2018-05-18 00:00:00.000' AS DateTime), CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (237, 1, 1, N'Foundation1', 9, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Periodic cleaning', N'Week 3', N'01C.03', N'Week 3', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-19 00:00:00.000' AS DateTime), CAST(N'2018-05-22 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 1, N'4', N'1526204599825', N'1526204211127', 1, 0, NULL, N'P', N'S30.3', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-19 00:00:00.000' AS DateTime), CAST(N'2018-05-22 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (239, 1, 1, N'Foundation1', 10, N'SITE WORKS', N'', N'', N'02', N'', N'', CAST(35.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(625.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-11 00:00:00.000' AS DateTime), CAST(N'2018-06-03 00:00:00.000' AS DateTime), CAST(24.00 AS Decimal(18, 2)), 1, N'2', N'1526204760451', N'1525032452196', 1, 0, NULL, N'P', N'M20', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-11 00:00:00.000' AS DateTime), CAST(N'2018-06-03 00:00:00.000' AS DateTime), CAST(24.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (240, 1, 1, N'Foundation1', 10, N'SITE WORKS', N'Site clearance', N'', N'02A', N'', N'', CAST(35.00 AS Decimal(18, 2)), CAST(15.00 AS Decimal(18, 2)), CAST(625.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-11 00:00:00.000' AS DateTime), CAST(N'2018-06-03 00:00:00.000' AS DateTime), CAST(24.00 AS Decimal(18, 2)), 2, N'3', N'1526204760452', N'1526204760451', 1, 0, NULL, N'P', N'S40', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-11 00:00:00.000' AS DateTime), CAST(N'2018-06-03 00:00:00.000' AS DateTime), CAST(24.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (241, 1, 1, N'Foundation1', 10, N'SITE WORKS', N'Site clearance', N'Clearing of site', N'02A.01', N'Clearing of site', N'M3', CAST(25.00 AS Decimal(18, 2)), CAST(15.00 AS Decimal(18, 2)), CAST(375.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-11 00:00:00.000' AS DateTime), CAST(N'2018-05-31 00:00:00.000' AS DateTime), CAST(20.00 AS Decimal(18, 2)), 1, N'4', N'1526205031781', N'1526204760452', 1, 0, NULL, N'P', N'S40.1', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-11 00:00:00.000' AS DateTime), CAST(N'2018-05-31 00:00:00.000' AS DateTime), CAST(20.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (242, 1, 1, N'Foundation1', 10, N'SITE WORKS', N'Site clearance', N'Clearing of site 1', N'02A.02', N'Clearing of site 1', N'M3', CAST(10.00 AS Decimal(18, 2)), CAST(25.00 AS Decimal(18, 2)), CAST(250.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-06-01 00:00:00.000' AS DateTime), CAST(N'2018-06-03 00:00:00.000' AS DateTime), CAST(3.00 AS Decimal(18, 2)), 1, N'4', N'1526205079150', N'1526204760452', 1, 0, NULL, N'P', N'S40.2', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-06-01 00:00:00.000' AS DateTime), CAST(N'2018-06-03 00:00:00.000' AS DateTime), CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (243, 1, 1, N'Foundation1', 11, N'CONCRETE', N'', N'', N'03', N'', N'', CAST(54.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2430.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-13 00:00:00.000' AS DateTime), CAST(N'2018-05-30 00:00:00.000' AS DateTime), CAST(18.00 AS Decimal(18, 2)), 1, N'2', N'1526239111344', N'1525032452196', 1, 0, CAST(N'2018-05-14 00:56:30.000' AS DateTime), N'P', N'M30', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-13 00:00:00.000' AS DateTime), CAST(N'2018-05-30 00:00:00.000' AS DateTime), CAST(18.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (244, 1, 1, N'Foundation1', 11, N'CONCRETE', N'Column footings', N'', N'03A', N'', N'', CAST(54.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2430.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-13 00:00:00.000' AS DateTime), CAST(N'2018-05-30 00:00:00.000' AS DateTime), CAST(18.00 AS Decimal(18, 2)), 2, N'3', N'1526239111345', N'1526239111344', 1, 0, CAST(N'2018-05-14 00:57:38.000' AS DateTime), N'P', N'S50', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-13 00:00:00.000' AS DateTime), CAST(N'2018-05-30 00:00:00.000' AS DateTime), CAST(18.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (245, 1, 1, N'Foundation1', 11, N'CONCRETE', N'Column footings', N'PCC 1:4:8', N'03A.01', N'PCC 1:4:8', N'M2', CAST(12.00 AS Decimal(18, 2)), CAST(45.00 AS Decimal(18, 2)), CAST(540.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-13 00:00:00.000' AS DateTime), CAST(N'2018-05-17 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)), 1, N'4', N'1526239663890', N'1526239111345', 1, 0, CAST(N'2018-05-14 00:58:51.000' AS DateTime), N'P', N'S50.1', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-13 00:00:00.000' AS DateTime), CAST(N'2018-05-17 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (246, 1, 0, N'All', 0, N'', N'', N'', N'VARIATIONS', N'', N'', CAST(1117.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(5500.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-24 00:00:00.000' AS DateTime), CAST(N'2018-06-08 00:00:00.000' AS DateTime), CAST(16.00 AS Decimal(18, 2)), 1, N'0', N'1527121923741', N'0', 1, 0, CAST(N'2018-05-24 06:05:22.000' AS DateTime), N'V', N'PV10', CAST(100.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-05-24 00:00:00.000' AS DateTime), CAST(N'2018-06-08 00:00:00.000' AS DateTime), CAST(16.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (249, 1, 1, N'Foundation1', 1, N'VARIATIONS', N'ARCHITECT INSTRUCTIONS (AI)', N'', N'ARCHITECT INSTRUCTIONS (AI)', N'', N'', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-24 00:00:00.000' AS DateTime), CAST(N'2018-06-04 00:00:00.000' AS DateTime), CAST(6.00 AS Decimal(18, 2)), 1, N'2', N'1527124847664', N'1527121923741', 1, 0, CAST(N'2018-05-24 06:51:22.000' AS DateTime), N'V', N'MV10', CAST(100.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-05-24 00:00:00.000' AS DateTime), CAST(N'2018-06-04 00:00:00.000' AS DateTime), CAST(6.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (250, 1, 1, N'Foundation1', 1, N'VARIATIONS', N'ARCHITECT INSTRUCTIONS (AI)', N'', N'AI # 001', N'Addition of Setting out 5', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(N'2018-05-24 00:00:00.000' AS DateTime), CAST(N'2018-05-29 00:00:00.000' AS DateTime), CAST(6.00 AS Decimal(18, 2)), 2, N'3', N'1527125257949', N'1527124847664', 1, 0, CAST(N'2018-07-11 07:46:50.000' AS DateTime), N'V', N'SV10.1', CAST(100.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-05-24 00:00:00.000' AS DateTime), CAST(N'2018-05-29 00:00:00.000' AS DateTime), CAST(6.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (251, 1, 1, N'Foundation1', 11, N'CONCRETE', N'Column footings', N'PCC 1:4:8', N'03A.02', N'C1_2', N'M2', CAST(15.00 AS Decimal(18, 2)), CAST(45.00 AS Decimal(18, 2)), CAST(675.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-18 00:00:00.000' AS DateTime), CAST(N'2018-05-21 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 1, N'4', N'1527125590971', N'1526239111345', 1, 0, CAST(N'2018-05-24 07:10:58.000' AS DateTime), N'P', N'S50.2', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-18 00:00:00.000' AS DateTime), CAST(N'2018-05-21 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (252, 1, 1, N'Foundation1', 11, N'CONCRETE', N'Column footings', N'PCC 1:4:8', N'03A.03', N'C2_1', N'M2', CAST(12.00 AS Decimal(18, 2)), CAST(45.00 AS Decimal(18, 2)), CAST(540.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-22 00:00:00.000' AS DateTime), CAST(N'2018-05-25 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 1, N'4', N'1527401445681', N'1526239111345', 1, 0, CAST(N'2018-05-27 11:47:06.000' AS DateTime), N'P', N'S50.3', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-05-22 00:00:00.000' AS DateTime), CAST(N'2018-05-25 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (253, 1, 1, N'Foundation1', 1, N'VARIATIONS', N'ARCHITECT INSTRUCTIONS (AI)', N'', N'AI # 002', N'Omission of week-4 periodic cleaning', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-30 00:00:00.000' AS DateTime), CAST(N'2018-06-04 00:00:00.000' AS DateTime), CAST(6.00 AS Decimal(18, 2)), 2, N'3', N'1527403867765', N'1527124847664', 1, 0, CAST(N'2018-05-27 12:26:08.000' AS DateTime), N'V', N'SV10.2', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-05-30 00:00:00.000' AS DateTime), CAST(N'2018-06-04 00:00:00.000' AS DateTime), CAST(6.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (254, 1, 1, N'Foundation1', 2, N'VARIATIONS', N'STRUCTURAL ENGINEERS INSTRUCTION (EI-STR)', N'', N'STRUCTURAL ENGINEERS INSTRUCTION (EI-STR)', N'', N'', CAST(1115.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(5200.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-29 00:00:00.000' AS DateTime), CAST(N'2018-06-08 00:00:00.000' AS DateTime), CAST(11.00 AS Decimal(18, 2)), 1, N'2', N'1527408279280', N'1527121923741', 1, 0, CAST(N'2018-05-27 13:35:23.000' AS DateTime), N'V', N'MV20', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-05-29 00:00:00.000' AS DateTime), CAST(N'2018-06-08 00:00:00.000' AS DateTime), CAST(11.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (255, 1, 1, N'Foundation1', 2, N'VARIATIONS', N'STRUCTURAL ENGINEERS INSTRUCTION (EI-STR)', N'', N'EI (STRC) # 001', N'Omission of C1_2 column foundation concrete RCC G20', N'M3', CAST(15.00 AS Decimal(18, 2)), CAST(90.00 AS Decimal(18, 2)), CAST(1350.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-29 00:00:00.000' AS DateTime), CAST(N'2018-06-05 00:00:00.000' AS DateTime), CAST(8.00 AS Decimal(18, 2)), 2, N'3', N'1527408393623', N'1527408279280', 1, 0, CAST(N'2018-05-27 13:37:39.000' AS DateTime), N'V', N'SV20.1', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-05-29 00:00:00.000' AS DateTime), CAST(N'2018-06-05 00:00:00.000' AS DateTime), CAST(8.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (256, 1, 1, N'Foundation1', 2, N'VARIATIONS', N'STRUCTURAL ENGINEERS INSTRUCTION (EI-STR)', N'', N'EI (STRC) # 002', N'Addition of C2_2 column foundation rebar', N'KG', CAST(1100.00 AS Decimal(18, 2)), CAST(3.50 AS Decimal(18, 2)), CAST(3850.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), CAST(N'2018-05-31 00:00:00.000' AS DateTime), CAST(N'2018-06-08 00:00:00.000' AS DateTime), CAST(9.00 AS Decimal(18, 2)), 2, N'3', N'1527408607143', N'1527408279280', 1, 0, CAST(N'2018-05-29 23:58:24.000' AS DateTime), N'V', N'SV20.2', CAST(385.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-05-31 00:00:00.000' AS DateTime), CAST(N'2018-06-08 00:00:00.000' AS DateTime), CAST(9.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (257, 1, 1, N'Foundation1', 11, N'CONCRETE', N'Column footings', N'Dependency', N'03A.04', N'C2_2', N'M2', CAST(10.00 AS Decimal(18, 2)), CAST(45.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-21 00:00:00.000' AS DateTime), CAST(N'2018-05-30 00:00:00.000' AS DateTime), CAST(10.00 AS Decimal(18, 2)), 1, N'4', N'1528002255925', N'1526239111345', 1, 0, CAST(N'2018-06-03 10:52:46.000' AS DateTime), N'P', N'S50.4', CAST(0.00 AS Decimal(18, 2)), N'V', N'S50.2', NULL, NULL, CAST(N'2018-05-21 00:00:00.000' AS DateTime), CAST(N'2018-05-30 00:00:00.000' AS DateTime), CAST(10.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (258, 1, 1, N'Foundation1', 11, N'CONCRETE', N'Column footings', N'PCC 1:4:8', N'03A.05', N'C3', N'M2', CAST(5.00 AS Decimal(18, 2)), CAST(45.00 AS Decimal(18, 2)), CAST(225.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-05-17 00:00:00.000' AS DateTime), CAST(N'2018-05-30 00:00:00.000' AS DateTime), CAST(14.00 AS Decimal(18, 2)), 1, N'4', N'1528016442082', N'1526239111345', 1, 0, CAST(N'2018-06-03 14:34:19.000' AS DateTime), N'P', N'S50.5', CAST(0.00 AS Decimal(18, 2)), N'V', N'S50.1', NULL, NULL, CAST(N'2018-05-17 00:00:00.000' AS DateTime), CAST(N'2018-05-30 00:00:00.000' AS DateTime), CAST(14.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (259, 10, 10, N'new', 0, N'', N'', N'', N'', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-07-19 18:30:00.000' AS DateTime), CAST(N'2019-06-29 18:30:00.000' AS DateTime), CAST(345.00 AS Decimal(18, 2)), 1, N'0', N'1532112363698', N'0', 5, 0, CAST(N'2018-07-21 00:19:04.000' AS DateTime), N'P', N'P10', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-07-19 18:30:00.000' AS DateTime), CAST(N'2019-06-29 18:30:00.000' AS DateTime), CAST(345.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (260, 10, 17, N'Foundation1', 13, N'01-GENERAL REQUIREMENTS/ PRELIMINARIES', N'', N'', N'', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-07-21 00:00:00.000' AS DateTime), CAST(N'2018-07-28 00:00:00.000' AS DateTime), CAST(8.00 AS Decimal(18, 2)), 1, N'2', N'1532112363715', N'1532112363698', 5, 0, CAST(N'2018-07-21 00:58:37.000' AS DateTime), N'P', N'M10', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-07-21 00:00:00.000' AS DateTime), CAST(N'2018-07-28 00:00:00.000' AS DateTime), CAST(8.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (261, 10, 17, N'Foundation1', 13, N'01-GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'', N'01A', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-07-21 00:00:00.000' AS DateTime), CAST(N'2018-07-28 00:00:00.000' AS DateTime), CAST(8.00 AS Decimal(18, 2)), 2, N'3', N'1532114929297', N'1532112363715', 5, 0, CAST(N'2018-07-21 01:06:47.000' AS DateTime), N'P', N'S10', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-07-21 00:00:00.000' AS DateTime), CAST(N'2018-07-28 00:00:00.000' AS DateTime), CAST(8.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (262, 11, 11, N'demo1', 0, N'', N'', N'', N'', N'', N'', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(3799.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-07-21 18:30:00.000' AS DateTime), CAST(N'2019-06-29 18:30:00.000' AS DateTime), CAST(343.00 AS Decimal(18, 2)), 1, N'0', N'1532369409969', N'0', 6, 10, CAST(N'2018-07-23 23:40:20.373' AS DateTime), N'P', N'P10', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-07-21 18:30:00.000' AS DateTime), CAST(N'2019-06-29 18:30:00.000' AS DateTime), CAST(343.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (263, 11, 23, N'Foundation', 18, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'', N'', N'', N'', N'', CAST(6.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2799.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-07-21 00:00:00.000' AS DateTime), CAST(N'2018-08-11 00:00:00.000' AS DateTime), CAST(22.00 AS Decimal(18, 2)), 1, N'2', N'1532369409970', N'1532369409969', 6, 10, CAST(N'2018-07-23 23:41:04.287' AS DateTime), N'P', N'M10', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-07-21 00:00:00.000' AS DateTime), CAST(N'2018-08-11 00:00:00.000' AS DateTime), CAST(22.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (264, 11, 23, N'Foundation', 18, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'', N'01A', N'', N'', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1500.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-07-21 00:00:00.000' AS DateTime), CAST(N'2018-07-27 00:00:00.000' AS DateTime), CAST(7.00 AS Decimal(18, 2)), 2, N'3', N'1532369474070', N'1532369409970', 6, 10, CAST(N'2018-07-23 23:42:08.583' AS DateTime), N'P', N'S10', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-07-21 00:00:00.000' AS DateTime), CAST(N'2018-07-27 00:00:00.000' AS DateTime), CAST(7.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (265, 11, 23, N'Foundation', 18, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'Setting out 1', N'01A.01', N'Setting out 1', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-07-21 00:00:00.000' AS DateTime), CAST(N'2018-07-24 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 1, N'4', N'1532369474071', N'1532369474070', 6, 10, CAST(N'2018-07-23 23:43:13.890' AS DateTime), N'P', N'S10.1', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-07-21 00:00:00.000' AS DateTime), CAST(N'2018-07-24 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (266, 11, 23, N'Foundation', 18, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'Setting out 2', N'01A.02', N'Setting out 2', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-08-08 00:00:00.000' AS DateTime), CAST(N'2018-08-12 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)), 1, N'4', N'1532369474072', N'1532369474070', 6, 10, CAST(N'2018-07-23 23:44:08.647' AS DateTime), N'P', N'S10.2', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'S10.3', NULL, CAST(N'2018-08-08 00:00:00.000' AS DateTime), CAST(N'2018-08-12 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (267, 11, 23, N'Foundation', 18, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'Setting out 3', N'01A.02.1', N'Setting out 3', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-07-22 00:00:00.000' AS DateTime), CAST(N'2018-07-23 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)), 1, N'5', N'1532369474074', N'1532369474071', 6, 10, CAST(N'2018-07-24 00:36:21.937' AS DateTime), N'P', N'S10.1.1', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-07-22 00:00:00.000' AS DateTime), CAST(N'2018-07-23 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (268, 11, 23, N'Foundation', 18, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'Setting out 4', N'01A.02.2', N'Setting out 4', N'Sum', CAST(2.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-07-24 00:00:00.000' AS DateTime), CAST(N'2018-07-24 00:00:00.000' AS DateTime), CAST(1.00 AS Decimal(18, 2)), 1, N'5', N'1532454378047', N'1532369474071', 6, 10, CAST(N'2018-07-24 23:22:18.213' AS DateTime), N'P', N'S10.1.2', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-07-24 00:00:00.000' AS DateTime), CAST(N'2018-07-24 00:00:00.000' AS DateTime), CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (269, 11, 23, N'Foundation', 18, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'new', N'new01', N'new', N'Sum', CAST(2.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-07-28 00:00:00.000' AS DateTime), CAST(N'2018-08-07 00:00:00.000' AS DateTime), CAST(11.00 AS Decimal(18, 2)), 1, N'4', N'1533464651496', N'1532369474070', 6, 10, CAST(N'2018-08-05 15:57:54.070' AS DateTime), N'P', N'S10.3', CAST(0.00 AS Decimal(18, 2)), N'P', N'S10.2', NULL, NULL, CAST(N'2018-07-28 00:00:00.000' AS DateTime), CAST(N'2018-08-07 00:00:00.000' AS DateTime), CAST(11.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (270, 11, 23, N'Foundation', 18, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'new1', N'new02', N'new1', N'Sum', CAST(3.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), CAST(3000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-08-08 00:00:00.000' AS DateTime), CAST(N'2018-08-11 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 1, N'4', N'1533464950881', N'1532369474070', 6, 10, CAST(N'2018-08-05 16:01:54.347' AS DateTime), N'P', N'S10.4', CAST(0.00 AS Decimal(18, 2)), N'P', N'S10.3', NULL, NULL, CAST(N'2018-08-08 00:00:00.000' AS DateTime), CAST(N'2018-08-11 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (271, 11, 23, N'Foundation', 18, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'as', N'', N'', N'', N'', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1299.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-08-05 00:00:00.000' AS DateTime), CAST(N'2018-08-11 00:00:00.000' AS DateTime), CAST(7.00 AS Decimal(18, 2)), 2, N'3', N'1533465134755', N'1532369409970', 6, 10, CAST(N'2018-08-05 16:14:55.823' AS DateTime), N'P', N'S20', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-08-05 00:00:00.000' AS DateTime), CAST(N'2018-08-11 00:00:00.000' AS DateTime), CAST(7.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (272, 11, 23, N'Foundation', 18, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'as', N'admin', N'q1', N'sd', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-08-12 00:00:00.000' AS DateTime), CAST(N'2018-08-13 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)), 1, N'4', N'1533466216984', N'1533465134755', 6, 10, CAST(N'2018-08-05 16:21:19.270' AS DateTime), N'P', N'S20.1', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'S20.3', NULL, CAST(N'2018-08-12 00:00:00.000' AS DateTime), CAST(N'2018-08-13 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (273, 11, 23, N'Foundation', 18, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'as', N'a', N'a', N'a', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(199.00 AS Decimal(18, 2)), CAST(199.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-08-05 00:00:00.000' AS DateTime), CAST(N'2018-08-11 00:00:00.000' AS DateTime), CAST(7.00 AS Decimal(18, 2)), 1, N'4', N'1533467906830', N'1533465134755', 6, 10, CAST(N'2018-08-05 16:50:23.870' AS DateTime), N'P', N'S20.2', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-08-05 00:00:00.000' AS DateTime), CAST(N'2018-08-11 00:00:00.000' AS DateTime), CAST(7.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (274, 11, 23, N'Foundation', 18, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'as', N'v', N'v', N'a', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-08-05 00:00:00.000' AS DateTime), CAST(N'2018-08-11 00:00:00.000' AS DateTime), CAST(7.00 AS Decimal(18, 2)), 1, N'4', N'1533468282321', N'1533465134755', 6, 10, CAST(N'2018-08-05 16:57:38.830' AS DateTime), N'P', N'S20.3', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-08-05 00:00:00.000' AS DateTime), CAST(N'2018-08-11 00:00:00.000' AS DateTime), CAST(7.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (275, 11, 23, N'Foundation', 19, N'SITE WORKS', N'', N'', N'', N'', N'M', CAST(1.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 1, N'2', N'1533758692005', N'1532369409969', 6, 10, CAST(N'2018-08-09 01:38:23.487' AS DateTime), N'P', N'M20', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (276, 11, 23, N'Foundation', 19, N'SITE WORKS', N'as', N'', N'', N'', N'', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 2, N'3', N'1533841610154', N'1533758692005', 6, 10, CAST(N'2018-08-10 00:41:23.550' AS DateTime), N'P', N'S30', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (277, 11, 23, N'Foundation', 19, N'SITE WORKS', N'as', N'asdf', N'12', N'dsfdf', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 1, N'4', N'1533841974157', N'1533841610154', 6, 10, CAST(N'2018-08-10 00:44:04.830' AS DateTime), N'P', N'S30.1', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (278, 16, 16, N'ASN Market City', 0, N'', N'', N'', N'', N'', N'', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-07-01 18:30:00.000' AS DateTime), CAST(N'2019-11-15 18:30:00.000' AS DateTime), CAST(167.00 AS Decimal(18, 2)), 0, N'0', N'1534536033221', N'0', 7, 14, CAST(N'2018-08-18 02:14:24.907' AS DateTime), N'P', N'P10', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-07-01 18:30:00.000' AS DateTime), CAST(N'2019-11-15 18:30:00.000' AS DateTime), CAST(167.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (287, 16, 27, N'Foundation-Main Contract', 23, N'2nd storey wall opening between Yotel Carpark Lift Lobby to IB.', N'', N'', N'', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-08-02 00:00:00.000' AS DateTime), CAST(N'2018-08-29 05:07:53.000' AS DateTime), CAST(28.00 AS Decimal(18, 2)), 0, N'2', N'1535110822014', N'1534536033221', 7, 14, CAST(N'2018-08-24 17:30:36.060' AS DateTime), N'P', N'M10', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'M30,P10,P10,P10,P10', NULL, CAST(N'2018-08-02 00:00:00.000' AS DateTime), CAST(N'2018-08-29 05:07:53.000' AS DateTime), CAST(28.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (288, 16, 27, N'Foundation-Main Contract', 23, N'2nd storey wall opening between Yotel Carpark Lift Lobby to IB.', N'Hacking Works (3rd storey IB slab, IB wall, Yotel  Wall)', N'', N'A1030', N'', N'', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-06-14 00:00:00.000' AS DateTime), CAST(N'2018-06-26 00:00:00.000' AS DateTime), CAST(13.00 AS Decimal(18, 2)), 0, N'3', N'1535110822015', N'1535110822014', 7, 14, CAST(N'2018-08-24 17:31:25.540' AS DateTime), N'P', N'S10', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'S140,M10,M10,M10,M10', NULL, CAST(N'2018-06-14 00:00:00.000' AS DateTime), CAST(N'2018-06-26 00:00:00.000' AS DateTime), CAST(13.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (289, 16, 27, N'Foundation-Main Contract', 23, N'2nd storey wall opening between Yotel Carpark Lift Lobby to IB.', N'Propping, Installation of additional structural supports/strengthening works (2nd & 3rd storey)', N'', N'A1040', N'', N'', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-06-26 00:00:00.000' AS DateTime), CAST(N'2018-07-17 00:00:00.000' AS DateTime), CAST(21.00 AS Decimal(18, 2)), 0, N'3', N'1535110822018', N'1535110822014', 7, 14, CAST(N'2018-08-24 17:50:38.043' AS DateTime), N'P', N'S20', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'S10,S10,S10,S10,S10', NULL, CAST(N'2018-06-26 00:00:00.000' AS DateTime), CAST(N'2018-07-17 00:00:00.000' AS DateTime), CAST(21.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (290, 16, 27, N'Foundation-Main Contract', 23, N'2nd storey wall opening between Yotel Carpark Lift Lobby to IB.', N'Construct New stair', N'', N'A1050', N'', N'', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-07-17 00:00:00.000' AS DateTime), CAST(N'2018-07-31 00:00:00.000' AS DateTime), CAST(15.00 AS Decimal(18, 2)), 0, N'3', N'1535110822019', N'1535110822014', 7, 14, CAST(N'2018-08-24 17:51:14.790' AS DateTime), N'P', N'S30', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'S20,S20,S20,S20,S20', NULL, CAST(N'2018-07-17 00:00:00.000' AS DateTime), CAST(N'2018-07-31 00:00:00.000' AS DateTime), CAST(15.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (291, 16, 27, N'Foundation-Main Contract', 23, N'2nd storey wall opening between Yotel Carpark Lift Lobby to IB.', N'M&E Works (Shutter controls, new lightings)', N'', N'A1060', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'3', N'1535110822020', N'1535110822014', 7, 14, CAST(N'2018-08-24 17:52:01.730' AS DateTime), N'P', N'S40', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (292, 16, 27, N'Foundation-Main Contract', 23, N'2nd storey wall opening between Yotel Carpark Lift Lobby to IB.', N'Architectural Finishes (shutters, railings, interfacing  seals, floor, ceiling)', N'', N'A1070', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'3', N'1535110822021', N'1535110822014', 7, 14, CAST(N'2018-08-24 17:53:55.690' AS DateTime), N'P', N'S50', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (293, 16, 27, N'Foundation-Main Contract', 24, N'Flipping of existing Escalator', N'', N'', N'', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-08-02 00:00:00.000' AS DateTime), CAST(N'2018-08-29 05:07:53.000' AS DateTime), CAST(28.00 AS Decimal(18, 2)), 0, N'2', N'1535110822023', N'1534536033221', 7, 14, CAST(N'2018-08-24 18:01:06.890' AS DateTime), N'P', N'M20', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'M10,M10,M10,M10', NULL, CAST(N'2018-08-02 00:00:00.000' AS DateTime), CAST(N'2018-08-29 05:07:53.000' AS DateTime), CAST(28.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (294, 16, 27, N'Foundation-Main Contract', 24, N'Flipping of existing Escalator', N'Decommissioning & Dismantle of existing escalator', N'', N'A1080', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'3', N'1535110822024', N'1535110822023', 7, 14, CAST(N'2018-08-24 18:02:30.770' AS DateTime), N'P', N'S60', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (295, 16, 27, N'Foundation-Main Contract', 24, N'Flipping of existing Escalator', N'Installation of additional structural supports/strengthening works', N'', N'A1090', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'3', N'1535110822025', N'1535110822023', 7, 14, CAST(N'2018-08-24 18:03:08.340' AS DateTime), N'P', N'S70', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (296, 16, 27, N'Foundation-Main Contract', 24, N'Flipping of existing Escalator', N'Construction of escalator pit', N'', N'A1100', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'3', N'1535110822026', N'1535110822023', 7, 14, CAST(N'2018-08-24 18:04:24.580' AS DateTime), N'P', N'S80', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (297, 16, 27, N'Foundation-Main Contract', 24, N'Flipping of existing Escalator', N'Installation of escalator', N'', N'A1110', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'3', N'1535110822027', N'1535110822023', 7, 14, CAST(N'2018-08-24 18:04:46.453' AS DateTime), N'P', N'S90', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (298, 16, 27, N'Foundation-Main Contract', 24, N'Flipping of existing Escalator', N'Cladding works', N'', N'A1120', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'3', N'1535110822028', N'1535110822023', 7, 14, CAST(N'2018-08-24 18:05:20.833' AS DateTime), N'P', N'S100', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (299, 16, 27, N'Foundation-Main Contract', 24, N'Flipping of existing Escalator', N'Testing and commissioning', N'', N'A1130', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'3', N'1535110822029', N'1535110822023', 7, 14, CAST(N'2018-08-24 18:05:42.777' AS DateTime), N'P', N'S110', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (300, 16, 27, N'Foundation-Main Contract', 25, N'2nd storey', N'', N'', N'', N'', N'', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-08-02 00:00:00.000' AS DateTime), CAST(N'2018-08-29 05:07:53.000' AS DateTime), CAST(28.00 AS Decimal(18, 2)), 0, N'2', N'1535114209338', N'1534536033221', 7, 14, CAST(N'2018-08-24 18:07:09.560' AS DateTime), N'P', N'M30', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'M20,M20,M20,M20', NULL, CAST(N'2018-08-02 00:00:00.000' AS DateTime), CAST(N'2018-08-29 05:07:53.000' AS DateTime), CAST(28.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (301, 16, 27, N'Foundation-Main Contract', 25, N'2nd storey', N'Corridor', N'', N'', N'', N'', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'3', N'1535114209339', N'1535114209338', 7, 14, CAST(N'2018-08-24 18:07:20.150' AS DateTime), N'P', N'S120', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (302, 16, 27, N'Foundation-Main Contract', 25, N'2nd storey', N'Corridor', N'Removal of existing ceiling including termination/diversion of existing M&E services', N'A1230', N'A1230', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'4', N'1535114209340', N'1535114209339', 7, 14, CAST(N'2018-08-24 18:08:01.727' AS DateTime), N'P', N'S10.1', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (303, 16, 27, N'Foundation-Main Contract', 25, N'2nd storey', N'Corridor', N'Demolish existing floor finishes', N'A1235', N'A1235', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'4', N'1535114209341', N'1535114209339', 7, 14, CAST(N'2018-08-24 18:08:22.180' AS DateTime), N'P', N'S10.2', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (304, 16, 27, N'Foundation-Main Contract', 25, N'2nd storey', N'Corridor', N'Demolition existing shop front, partitions & M&E  Doors', N'A1265', N'A1265', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'4', N'1535114209342', N'1535114209339', 7, 14, CAST(N'2018-08-24 18:08:41.423' AS DateTime), N'P', N'S10.3', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (305, 16, 27, N'Foundation-Main Contract', 25, N'2nd storey', N'Corridor', N'Erect new MEP shaft', N'A1290', N'A1290', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'4', N'1535114209343', N'1535114209339', 7, 14, CAST(N'2018-08-24 18:09:31.627' AS DateTime), N'P', N'S10.4', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (306, 16, 27, N'Foundation-Main Contract', 25, N'2nd storey', N'Corridor', N'Installation of fire rated doors', N'A1300', N'A1300', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'4', N'1535114209344', N'1535114209339', 7, 14, CAST(N'2018-08-24 18:10:06.937' AS DateTime), N'P', N'S10.5', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (307, 16, 27, N'Foundation-Main Contract', 25, N'2nd storey', N'Corridor', N'Installation of platform lift (including testing and  commissioning)', N'A1305', N'A1305', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'4', N'1535114209345', N'1535114209339', 7, 14, CAST(N'2018-08-24 18:10:32.623' AS DateTime), N'P', N'S10.6', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (308, 16, 27, N'Foundation-Main Contract', 25, N'2nd storey', N'Corridor', N'Installation of new M&E services', N'A1306', N'A1306', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 0, N'4', N'1535114209346', N'1535114209339', 7, 14, CAST(N'2018-08-24 18:10:50.830' AS DateTime), N'P', N'S10.7', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (309, 16, 27, N'Foundation-Main Contract', 22, N'Main Contract', N'', N'', N'', N'', N'', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-06-01 00:00:00.000' AS DateTime), CAST(N'2018-10-01 00:00:00.000' AS DateTime), CAST(123.00 AS Decimal(18, 2)), 0, N'2', N'1535114209376', N'1534536033221', 7, 14, CAST(N'2018-08-24 18:13:13.200' AS DateTime), N'P', N'M40', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'M50,M30,M30,M30,M30', NULL, CAST(N'2018-06-01 00:00:00.000' AS DateTime), CAST(N'2018-10-01 00:00:00.000' AS DateTime), CAST(123.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (310, 16, 27, N'Foundation-Main Contract', 22, N'Main Contract', N'Contract Commencement', N'', N'A1000', N'', N'', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-06-01 00:00:00.000' AS DateTime), CAST(N'2018-06-04 00:00:00.000' AS DateTime), CAST(3.00 AS Decimal(18, 2)), 0, N'3', N'1535114209377', N'1535114209376', 7, 14, CAST(N'2018-08-24 18:13:30.703' AS DateTime), N'P', N'S130', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'S140', N'1535110822015', CAST(N'2018-06-01 00:00:00.000' AS DateTime), CAST(N'2018-06-04 00:00:00.000' AS DateTime), CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (311, 16, 27, N'Foundation-Main Contract', 22, N'Main Contract', N'Application/Issuance of Permit to Commence Work', N'', N'PR10', N'', N'', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-06-01 00:00:00.000' AS DateTime), CAST(N'2018-06-03 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)), 0, N'3', N'1535114209378', N'1535114209376', 7, 14, CAST(N'2018-08-24 18:13:48.437' AS DateTime), N'P', N'S140', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'S130,S130,S130,S130', N'1535110822015', CAST(N'2018-06-01 00:00:00.000' AS DateTime), CAST(N'2018-06-03 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (312, 16, 27, N'Foundation-Main Contract', 22, N'Main Contract', N'PE cal./Drawing/material submission', N'', N'PR20', N'', N'', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-06-07 00:00:00.000' AS DateTime), CAST(N'2018-08-01 00:00:00.000' AS DateTime), CAST(55.00 AS Decimal(18, 2)), 0, N'3', N'1535114209379', N'1535114209376', 7, 14, CAST(N'2018-08-24 18:20:31.610' AS DateTime), N'P', N'S150', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'S130,S140,S140,S140', N'1535110822015', CAST(N'2018-06-07 00:00:00.000' AS DateTime), CAST(N'2018-08-01 00:00:00.000' AS DateTime), CAST(55.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (313, 16, 27, N'Foundation-Main Contract', 22, N'Main Contract', N'PE cal./Drawing/material approval', N'', N'PR30', N'', N'', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-06-14 00:00:00.000' AS DateTime), CAST(N'2018-08-01 00:00:00.000' AS DateTime), CAST(48.00 AS Decimal(18, 2)), 0, N'3', N'1535114209380', N'1535114209376', 7, 14, CAST(N'2018-08-24 18:20:53.110' AS DateTime), N'P', N'S160', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'S150,S150,S150,S150', N'1535110822015', CAST(N'2018-06-14 00:00:00.000' AS DateTime), CAST(N'2018-08-01 00:00:00.000' AS DateTime), CAST(48.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (314, 16, 27, N'Foundation-Main Contract', 22, N'Main Contract', N'Procurement of Platform Lift', N'', N'PR40', N'', N'', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-06-14 00:00:00.000' AS DateTime), CAST(N'2018-10-01 00:00:00.000' AS DateTime), CAST(109.00 AS Decimal(18, 2)), 0, N'3', N'1535114209381', N'1535114209376', 7, 14, CAST(N'2018-08-24 18:21:10.200' AS DateTime), N'P', N'S170', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'S160,S160,S160,S160', N'1535110822015', CAST(N'2018-06-14 00:00:00.000' AS DateTime), CAST(N'2018-10-01 00:00:00.000' AS DateTime), CAST(109.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (315, 16, 27, N'Foundation-Main Contract', 26, N'Inspection & Commissioning', N'', N'', N'START', N'', N'', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(0.00 AS Decimal(18, 2)), 0, N'2', N'1535364501334', N'1534536033221', 7, 14, CAST(N'2018-08-27 16:26:16.260' AS DateTime), N'P', N'M50', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'M40,M40,M40,M40', NULL, CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(0.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (317, 16, 27, N'Foundation-Main Contract', 27, N'Completion', N'', N'', N'TASKA', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(N'2018-01-05 00:08:50.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 0, N'2', N'1536508611614', N'1534536033221', 7, 14, CAST(N'2018-09-09 21:30:09.313' AS DateTime), N'P', N'M60', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'', N'0', CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(N'2018-01-05 00:08:50.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (318, 16, 27, N'Foundation-Main Contract', 27, N'Completion', N'', N'', N'TASKB', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(N'2018-01-07 00:08:50.000' AS DateTime), CAST(6.00 AS Decimal(18, 2)), 0, N'2', N'1536508611615', N'1534536033221', 7, 14, CAST(N'2018-09-09 21:30:28.860' AS DateTime), N'P', N'M70', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'', N'0', CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(N'2018-01-07 00:08:50.000' AS DateTime), CAST(6.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (319, 16, 27, N'Foundation-Main Contract', 27, N'Completion', N'', N'', N'TASKC', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-01-01 00:00:00.000' AS DateTime), CAST(N'2018-01-06 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)), 0, N'2', N'1536508611617', N'1534536033221', 7, 14, CAST(N'2018-09-09 21:30:50.640' AS DateTime), N'P', N'M80', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'', N'0', CAST(N'2018-01-01 00:00:00.000' AS DateTime), CAST(N'2018-01-06 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (320, 16, 27, N'Foundation-Main Contract', 27, N'Completion', N'', N'', N'TASKD', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(N'2018-01-08 00:08:50.000' AS DateTime), CAST(7.00 AS Decimal(18, 2)), 0, N'2', N'1536508611618', N'1534536033221', 7, 14, CAST(N'2018-09-09 21:31:10.047' AS DateTime), N'P', N'M90', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'', N'0', CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(N'2018-01-08 00:08:50.000' AS DateTime), CAST(7.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (321, 16, 27, N'Foundation-Main Contract', 27, N'Completion', N'', N'', N'TASKE', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(N'2018-01-06 00:08:50.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)), 0, N'2', N'1536508611619', N'1534536033221', 7, 14, CAST(N'2018-09-09 21:31:23.520' AS DateTime), N'P', N'M100', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'', N'0', CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(N'2018-01-06 00:08:50.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (322, 16, 27, N'Foundation-Main Contract', 27, N'Completion', N'', N'', N'TASKF', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(N'2018-01-06 00:08:50.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)), 0, N'2', N'1536508611620', N'1534536033221', 7, 14, CAST(N'2018-09-09 21:31:32.643' AS DateTime), N'P', N'M110', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'', N'0', CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(N'2018-01-06 00:08:50.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (323, 16, 27, N'Foundation-Main Contract', 27, N'Completion', N'', N'', N'TASKG', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-01-01 00:00:00.000' AS DateTime), CAST(N'2018-01-06 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)), 0, N'2', N'1536508611622', N'1534536033221', 7, 14, CAST(N'2018-09-09 21:31:45.297' AS DateTime), N'P', N'M120', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'', N'0', CAST(N'2018-01-01 00:00:00.000' AS DateTime), CAST(N'2018-01-06 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (324, 16, 27, N'Foundation-Main Contract', 27, N'Completion', N'', N'', N'Finish', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(0.00 AS Decimal(18, 2)), 0, N'2', N'1536509168832', N'1534536033221', 7, 14, CAST(N'2018-09-09 22:02:58.363' AS DateTime), N'P', N'M130', CAST(0.00 AS Decimal(18, 2)), N'P', N'', NULL, NULL, CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(N'2018-01-01 00:08:50.000' AS DateTime), CAST(0.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (325, 17, 17, N'LUX', 0, N'', N'', N'', N'', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(0.00 AS Decimal(18, 2)), 0, N'0', N'1536519789201', N'0', 8, 16, CAST(N'2018-09-10 00:33:22.000' AS DateTime), N'P', N'P10', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'', N'0', CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(0.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (326, 17, 29, N'Start', 29, N'Start', N'', N'', N'Task A', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-13 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 0, N'2', N'1536519821126', N'1536519789201', 8, 16, CAST(N'2018-09-10 00:34:08.893' AS DateTime), N'P', N'M10', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'P10', N'0', CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-13 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (327, 17, 29, N'Start', 29, N'Start', N'', N'', N'Task B', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-15 00:00:00.000' AS DateTime), CAST(6.00 AS Decimal(18, 2)), 0, N'2', N'1536519821127', N'1536519789201', 8, 16, CAST(N'2018-09-10 00:34:36.320' AS DateTime), N'P', N'M20', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'P10', N'0', CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-15 00:00:00.000' AS DateTime), CAST(6.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (328, 17, 29, N'Start', 29, N'Start', N'', N'', N'Task C', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-14 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)), 0, N'2', N'1536519821130', N'1536519789201', 8, 16, CAST(N'2018-09-10 00:36:23.433' AS DateTime), N'P', N'M30', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'M10', N'0', CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-14 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (329, 17, 29, N'Start', 29, N'Start', N'', N'', N'Task D', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-16 00:00:00.000' AS DateTime), CAST(7.00 AS Decimal(18, 2)), 0, N'2', N'1536519821132', N'1536519789201', 8, 16, CAST(N'2018-09-10 00:40:20.407' AS DateTime), N'P', N'M40', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'M10', N'0', CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-16 00:00:00.000' AS DateTime), CAST(7.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (330, 17, 29, N'Start', 29, N'Start', N'', N'', N'Task E', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-14 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)), 0, N'2', N'1536519821133', N'1536519789201', 8, 16, CAST(N'2018-09-10 00:41:55.253' AS DateTime), N'P', N'M50', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'M30,M20', N'0', CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-14 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (331, 17, 29, N'Start', 29, N'Start', N'', N'', N'Task F', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-14 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)), 0, N'2', N'1536519821135', N'1536519789201', 8, 16, CAST(N'2018-09-10 00:42:53.787' AS DateTime), N'P', N'M60', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'M40', N'0', CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-14 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (332, 17, 29, N'Start', 29, N'Start', N'', N'', N'Task G', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-14 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)), 0, N'2', N'1536519821137', N'1536519789201', 8, 16, CAST(N'2018-09-10 00:43:49.050' AS DateTime), N'P', N'M70', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'M50', N'0', CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-14 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (333, 17, 29, N'Start', 29, N'Start', N'', N'', N'Finish', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(0.00 AS Decimal(18, 2)), 0, N'2', N'1536519821138', N'1536519789201', 8, 16, CAST(N'2018-09-10 00:46:26.957' AS DateTime), N'P', N'M80', CAST(0.00 AS Decimal(18, 2)), N'P', N'', N'M60,M70', N'0', CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(N'2018-09-09 00:00:00.000' AS DateTime), CAST(0.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (334, 18, 18, N'Grand Mall', 0, N'', N'', N'', N'', N'', N'', CAST(1132.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(10000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-13 18:30:00.000' AS DateTime), CAST(N'2019-06-13 18:30:00.000' AS DateTime), CAST(273.00 AS Decimal(18, 2)), 0, N'0', N'1536897835991', N'0', 9, 17, CAST(N'2018-09-14 09:37:40.170' AS DateTime), N'P', N'P10', CAST(3600.00 AS Decimal(18, 2)), N'V', N'', N'', N'0', CAST(N'2018-09-13 18:30:00.000' AS DateTime), CAST(N'2019-06-13 18:30:00.000' AS DateTime), CAST(273.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (335, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'', N'', N'01', N'', N'', CAST(12.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(4200.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-13 00:00:00.000' AS DateTime), CAST(N'2018-10-10 00:00:00.000' AS DateTime), CAST(28.00 AS Decimal(18, 2)), 0, N'2', N'1536897835992', N'1536897835991', 9, 17, CAST(N'2018-09-14 09:39:53.550' AS DateTime), N'P', N'M10', CAST(3600.00 AS Decimal(18, 2)), N'V', N'', N'', N'0', CAST(N'2018-09-13 00:00:00.000' AS DateTime), CAST(N'2018-10-10 00:00:00.000' AS DateTime), CAST(28.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (336, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'', N'01A', N'', N'', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1600.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-13 00:00:00.000' AS DateTime), CAST(N'2018-09-26 00:00:00.000' AS DateTime), CAST(14.00 AS Decimal(18, 2)), 0, N'3', N'1536897835994', N'1536897835992', 9, 17, CAST(N'2018-09-14 09:40:33.190' AS DateTime), N'P', N'S10', CAST(1200.00 AS Decimal(18, 2)), N'V', N'', N'', N'0', CAST(N'2018-09-13 00:00:00.000' AS DateTime), CAST(N'2018-09-26 00:00:00.000' AS DateTime), CAST(14.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (337, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'Setting out 1', N'01A.01', N'Setting out 1', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(N'2018-09-13 00:00:00.000' AS DateTime), CAST(N'2018-09-19 00:00:00.000' AS DateTime), CAST(6.00 AS Decimal(18, 2)), 0, N'4', N'1536897835995', N'1536897835994', 9, 17, CAST(N'2018-09-30 17:19:14.000' AS DateTime), N'P', N'S10.1', CAST(500.00 AS Decimal(18, 2)), N'V', N'', N'', N'1536897835995', CAST(N'2018-09-13 00:00:00.000' AS DateTime), CAST(N'2018-09-19 00:00:00.000' AS DateTime), CAST(6.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (338, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'Setting out 2', N'01A.02', N'Setting out 2', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(N'2018-09-19 00:00:00.000' AS DateTime), CAST(N'2018-09-21 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)), 0, N'4', N'1536897835996', N'1536897835994', 9, 17, CAST(N'2018-10-03 06:46:35.000' AS DateTime), N'P', N'S10.2', CAST(400.00 AS Decimal(18, 2)), N'V', N'', N'S10.1', N'1536897835996', CAST(N'2018-09-19 00:00:00.000' AS DateTime), CAST(N'2018-09-21 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (339, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'Setting out 3', N'01A.03', N'Setting out 3', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(N'2018-09-21 00:00:00.000' AS DateTime), CAST(N'2018-09-25 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 0, N'4', N'1536898466218', N'1536897835994', 9, 17, CAST(N'2018-10-04 19:12:29.000' AS DateTime), N'P', N'S10.3', CAST(300.00 AS Decimal(18, 2)), N'V', N'', N'S10.2', N'0', CAST(N'2018-09-21 00:00:00.000' AS DateTime), CAST(N'2018-09-25 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (340, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Pre-commencement inspection & setting', N'Setting out 4', N'01A.04', N'Setting out 4', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-25 00:00:00.000' AS DateTime), CAST(N'2018-09-26 00:00:00.000' AS DateTime), CAST(1.00 AS Decimal(18, 2)), 0, N'4', N'1536898466219', N'1536897835994', 9, 17, CAST(N'2018-09-14 09:45:49.110' AS DateTime), N'P', N'S10.4', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', N'0', CAST(N'2018-09-25 00:00:00.000' AS DateTime), CAST(N'2018-09-26 00:00:00.000' AS DateTime), CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (341, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Temporary power & lighting', N'', N'01B', N'', N'', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1800.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-19 00:00:00.000' AS DateTime), CAST(N'2018-10-01 00:00:00.000' AS DateTime), CAST(13.00 AS Decimal(18, 2)), 0, N'3', N'1537025686930', N'1536897835992', 9, 17, CAST(N'2018-09-15 21:05:24.097' AS DateTime), N'P', N'S20', CAST(1200.00 AS Decimal(18, 2)), N'V', N'', N'', NULL, CAST(N'2018-09-19 00:00:00.000' AS DateTime), CAST(N'2018-10-01 00:00:00.000' AS DateTime), CAST(13.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (342, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Temporary power & lighting', N'Week 1', N'01B.01', N'Week 1', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-19 00:00:00.000' AS DateTime), CAST(N'2018-09-20 00:00:00.000' AS DateTime), CAST(1.00 AS Decimal(18, 2)), 0, N'4', N'1537025686931', N'1537025686930', 9, 17, CAST(N'2018-09-15 21:08:00.777' AS DateTime), N'P', N'S20.1', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', N'0', CAST(N'2018-09-19 00:00:00.000' AS DateTime), CAST(N'2018-09-20 00:00:00.000' AS DateTime), CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (343, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Temporary power & lighting', N'Week 2', N'01B.02', N'Week 2', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-26 00:00:00.000' AS DateTime), CAST(N'2018-09-28 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)), 0, N'4', N'1537025686932', N'1537025686930', 9, 17, CAST(N'2018-09-15 21:08:57.517' AS DateTime), N'P', N'S20.2', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'S10.4', N'0', CAST(N'2018-09-29 00:00:00.000' AS DateTime), CAST(N'2018-10-08 00:00:00.000' AS DateTime), CAST(9.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (344, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Temporary power & lighting', N'Week 3', N'01B.03', N'Week 3', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-28 00:00:00.000' AS DateTime), CAST(N'2018-09-29 00:00:00.000' AS DateTime), CAST(1.00 AS Decimal(18, 2)), 0, N'4', N'1537025686933', N'1537025686930', 9, 17, CAST(N'2018-09-15 21:12:32.910' AS DateTime), N'P', N'S20.3', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', N'0', CAST(N'2018-09-28 00:00:00.000' AS DateTime), CAST(N'2018-09-29 00:00:00.000' AS DateTime), CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (345, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Temporary power & lighting', N'Week 4', N'01B.04', N'Week 4', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-29 00:00:00.000' AS DateTime), CAST(N'2018-10-01 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)), 0, N'4', N'1537025686934', N'1537025686930', 9, 17, CAST(N'2018-09-15 21:14:33.420' AS DateTime), N'P', N'S20.4', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', N'1537025686934', CAST(N'2018-09-29 00:00:00.000' AS DateTime), CAST(N'2018-10-01 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (346, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Periodic cleaning', N'', N'01C', N'', N'', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(800.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-20 00:00:00.000' AS DateTime), CAST(N'2018-10-10 00:00:00.000' AS DateTime), CAST(21.00 AS Decimal(18, 2)), 0, N'3', N'1537025686935', N'1536897835992', 9, 17, CAST(N'2018-09-15 21:16:17.890' AS DateTime), N'P', N'S30', CAST(1200.00 AS Decimal(18, 2)), N'V', N'', N'', NULL, CAST(N'2018-09-20 00:00:00.000' AS DateTime), CAST(N'2018-10-10 00:00:00.000' AS DateTime), CAST(21.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (347, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Periodic cleaning', N'Week 1', N'01C.01', N'Week 1', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-09-20 00:00:00.000' AS DateTime), CAST(N'2018-09-24 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 0, N'4', N'1537031911833', N'1537025686935', 9, 17, CAST(N'2018-09-15 23:00:03.980' AS DateTime), N'P', N'S30.1', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', N'0', CAST(N'2018-09-20 00:00:00.000' AS DateTime), CAST(N'2018-09-24 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (348, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Periodic cleaning', N'Week 2', N'01C.02', N'Week 2', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-01 00:00:00.000' AS DateTime), CAST(N'2018-10-04 00:00:00.000' AS DateTime), CAST(3.00 AS Decimal(18, 2)), 0, N'4', N'1537031911834', N'1537025686935', 9, 17, CAST(N'2018-09-15 23:01:19.517' AS DateTime), N'P', N'S30.2', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'S30.1', N'0', CAST(N'2018-09-26 00:00:00.000' AS DateTime), CAST(N'2018-09-29 00:00:00.000' AS DateTime), CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (349, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Periodic cleaning', N'Week 3', N'01C.03', N'Week 3', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-04 00:00:00.000' AS DateTime), CAST(N'2018-10-08 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 0, N'4', N'1537032741770', N'1537025686935', 9, 17, CAST(N'2018-09-15 23:03:43.223' AS DateTime), N'P', N'S30.3', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', N'1537032741770', CAST(N'2018-10-04 00:00:00.000' AS DateTime), CAST(N'2018-10-08 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (350, 18, 30, N'Foundation', 30, N'GENERAL REQUIREMENTS/ PRELIMINARIES', N'Periodic cleaning', N'Week 4', N'01C.04', N'Week 4', N'Sum', CAST(1.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-08 00:00:00.000' AS DateTime), CAST(N'2018-10-10 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)), 0, N'4', N'1537032741771', N'1537025686935', 9, 17, CAST(N'2018-09-15 23:04:39.137' AS DateTime), N'P', N'S30.4', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', N'1537032741771', CAST(N'2018-10-08 00:00:00.000' AS DateTime), CAST(N'2018-10-10 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (351, 18, 30, N'Foundation', 31, N'SITE WORKS', N'', N'', N'02', N'', N'', CAST(1120.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(5800.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-10 00:00:00.000' AS DateTime), CAST(N'2018-10-23 00:00:00.000' AS DateTime), CAST(14.00 AS Decimal(18, 2)), 0, N'2', N'1537033035628', N'1536897835991', 9, 17, CAST(N'2018-09-15 23:08:26.220' AS DateTime), N'P', N'M20', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'S30.4', NULL, CAST(N'2018-10-10 00:00:00.000' AS DateTime), CAST(N'2018-10-23 00:00:00.000' AS DateTime), CAST(14.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (352, 18, 30, N'Foundation', 31, N'SITE WORKS', N'Site clearance', N'', N'02A', N'', N'', CAST(1000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(4000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-10 00:00:00.000' AS DateTime), CAST(N'2018-10-14 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)), 0, N'3', N'1537033035629', N'1537033035628', 9, 17, CAST(N'2018-09-15 23:10:05.187' AS DateTime), N'P', N'S40', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', N'0', CAST(N'2018-10-10 00:00:00.000' AS DateTime), CAST(N'2018-10-14 00:00:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (353, 18, 30, N'Foundation', 31, N'SITE WORKS', N'Site clearance', N'Clearing of site', N'02A.01', N'Clearing of site debris, plants, bushes, etc. including plain leveling fit for centre line marking ', N'M2', CAST(1000.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), CAST(4000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-10 00:00:00.000' AS DateTime), CAST(N'2018-10-14 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 0, N'4', N'1537033035630', N'1537033035629', 9, 17, CAST(N'2018-09-15 23:11:39.557' AS DateTime), N'P', N'S40.1', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', N'1537033035630', CAST(N'2018-10-10 00:00:00.000' AS DateTime), CAST(N'2018-10-14 00:00:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (354, 18, 30, N'Foundation', 31, N'SITE WORKS', N'Excavation', N'', N'02B', N'', N'', CAST(120.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1800.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-14 00:00:00.000' AS DateTime), CAST(N'2018-10-23 00:00:00.000' AS DateTime), CAST(10.00 AS Decimal(18, 2)), 0, N'3', N'1537033035631', N'1537033035628', 9, 17, CAST(N'2018-09-15 23:12:19.290' AS DateTime), N'P', N'S50', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', NULL, CAST(N'2018-10-14 00:00:00.000' AS DateTime), CAST(N'2018-10-23 00:00:00.000' AS DateTime), CAST(10.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (355, 18, 30, N'Foundation', 31, N'SITE WORKS', N'Excavation', N'Area 1', N'02B.01', N'Area 1', N'M3', CAST(25.00 AS Decimal(18, 2)), CAST(15.00 AS Decimal(18, 2)), CAST(375.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-14 00:00:00.000' AS DateTime), CAST(N'2018-10-17 00:00:00.000' AS DateTime), CAST(3.00 AS Decimal(18, 2)), 0, N'4', N'1537033035632', N'1537033035631', 9, 17, CAST(N'2018-09-15 23:14:29.197' AS DateTime), N'P', N'S50.1', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', N'', CAST(N'2018-10-14 00:00:00.000' AS DateTime), CAST(N'2018-10-17 00:00:00.000' AS DateTime), CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (356, 18, 30, N'Foundation', 31, N'SITE WORKS', N'Excavation', N'Area 2', N'02B.02', N'Area 2', N'M3', CAST(35.00 AS Decimal(18, 2)), CAST(15.00 AS Decimal(18, 2)), CAST(525.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-17 00:00:00.000' AS DateTime), CAST(N'2018-10-20 00:00:00.000' AS DateTime), CAST(3.00 AS Decimal(18, 2)), 0, N'4', N'1537033035633', N'1537033035631', 9, 17, CAST(N'2018-09-15 23:15:27.847' AS DateTime), N'P', N'S50.2', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', N'0', CAST(N'2018-10-17 00:00:00.000' AS DateTime), CAST(N'2018-10-20 00:00:00.000' AS DateTime), CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (357, 18, 30, N'Foundation', 31, N'SITE WORKS', N'Excavation', N'Area 3', N'02B.03', N'Area 3', N'M3', CAST(40.00 AS Decimal(18, 2)), CAST(15.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-20 00:00:00.000' AS DateTime), CAST(N'2018-10-22 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)), 0, N'4', N'1537033035634', N'1537033035631', 9, 17, CAST(N'2018-09-15 23:16:23.323' AS DateTime), N'P', N'S50.3', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', N'0', CAST(N'2018-10-20 00:00:00.000' AS DateTime), CAST(N'2018-10-22 00:00:00.000' AS DateTime), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (358, 18, 30, N'Foundation', 31, N'SITE WORKS', N'Excavation', N'Area 4', N'02B.04', N'Area 4', N'M3', CAST(20.00 AS Decimal(18, 2)), CAST(15.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-22 00:00:00.000' AS DateTime), CAST(N'2018-10-23 00:00:00.000' AS DateTime), CAST(1.00 AS Decimal(18, 2)), 0, N'4', N'1537033035635', N'1537033035631', 9, 17, CAST(N'2018-09-15 23:16:58.347' AS DateTime), N'P', N'S50.4', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', N'0', CAST(N'2018-10-22 00:00:00.000' AS DateTime), CAST(N'2018-10-23 00:00:00.000' AS DateTime), CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (359, 19, 19, N'New Grand Mall', 0, N'', N'', N'', N'', N'', N'', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(15000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-27 18:30:00.000' AS DateTime), CAST(N'2019-03-30 18:30:00.000' AS DateTime), NULL, 0, N'0', N'1540450464213', N'0', 10, 18, CAST(N'2018-10-25 12:24:30.840' AS DateTime), N'P', N'P10', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-10-27 18:30:00.000' AS DateTime), CAST(N'2019-03-30 18:30:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (360, 19, 31, N'Foundation-1', 35, N'A', N'', N'', N'', N'', N'', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-27 18:30:00.000' AS DateTime), CAST(N'2018-10-31 18:30:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)), 0, N'2', N'1540450464214', N'1540450464213', 10, 18, CAST(N'2018-10-25 12:24:40.900' AS DateTime), N'P', N'M10', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-10-27 18:30:00.000' AS DateTime), CAST(N'2018-10-31 18:30:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (361, 19, 31, N'Foundation-1', 35, N'A', N'A1', N'', N'A1', N'', N'', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-27 18:30:00.000' AS DateTime), CAST(N'2018-10-31 18:30:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)), 0, N'3', N'1540450464215', N'1540450464214', 10, 18, CAST(N'2018-10-25 12:24:55.790' AS DateTime), N'P', N'S10', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', NULL, CAST(N'2018-10-27 18:30:00.000' AS DateTime), CAST(N'2018-10-31 18:30:00.000' AS DateTime), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (362, 19, 31, N'Foundation-1', 35, N'A', N'A1', N'A11', N'A11', N'A11', N'No', CAST(1.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-27 18:30:00.000' AS DateTime), CAST(N'2018-10-31 18:30:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 0, N'4', N'1540450464216', N'1540450464215', 10, 18, CAST(N'2018-10-25 12:26:38.097' AS DateTime), N'P', N'S10.1', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', N'', CAST(N'2018-10-27 18:30:00.000' AS DateTime), CAST(N'2018-10-31 18:30:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (363, 19, 31, N'Foundation-1', 36, N'B', N'', N'', N'', N'', N'', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(10000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-31 18:30:00.000' AS DateTime), CAST(N'2018-12-04 18:30:00.000' AS DateTime), CAST(35.00 AS Decimal(18, 2)), 0, N'2', N'1540450764547', N'1540450464213', 10, 18, CAST(N'2018-10-25 12:34:40.360' AS DateTime), N'P', N'M20', CAST(0.00 AS Decimal(18, 2)), N'V', N'', NULL, NULL, CAST(N'2018-10-31 18:30:00.000' AS DateTime), CAST(N'2018-12-04 18:30:00.000' AS DateTime), CAST(35.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (364, 19, 31, N'Foundation-1', 36, N'B', N'B1', N'', N'B1', N'', N'', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(10000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-31 18:30:00.000' AS DateTime), CAST(N'2018-12-04 18:30:00.000' AS DateTime), CAST(35.00 AS Decimal(18, 2)), 0, N'3', N'1540450764548', N'1540450764547', 10, 18, CAST(N'2018-10-25 12:38:29.560' AS DateTime), N'P', N'S20', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'', NULL, CAST(N'2018-10-31 18:30:00.000' AS DateTime), CAST(N'2018-12-04 18:30:00.000' AS DateTime), CAST(35.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (365, 19, 31, N'Foundation-1', 36, N'B', N'B1', N'B11', N'B11', N'B11', N'No', CAST(1.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-10-31 18:30:00.000' AS DateTime), CAST(N'2018-11-04 18:30:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)), 0, N'4', N'1540450764549', N'1540450764548', 10, 18, CAST(N'2018-10-25 12:38:56.997' AS DateTime), N'P', N'S20.1', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'S10.1', N'', CAST(N'2018-10-31 18:30:00.000' AS DateTime), CAST(N'2018-11-04 18:30:00.000' AS DateTime), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[BoqEntryDetails] ([BOQId], [ProjectId], [DescriptionId], [DescriptionName], [MainItemId], [MainItem], [SubItem], [SubSubItem], [BoqRef], [Task], [Unit], [Qty], [UnitRate], [TotalCost], [WorkdonePer], [StartDate], [EndDate], [Duration], [Priority], [RefId], [TaskId], [ParentId], [ClientId], [UserId], [Workdonedate], [BOQType], [BOQRefId], [Workdonecost], [Flag], [dep], [Predec], [Criticaltaskid], [RVStartDate], [RVEndDate], [RDuration]) VALUES (366, 19, 31, N'Foundation-1', 36, N'B', N'B1', N'B12', N'B12', N'B12', N'No', CAST(1.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(N'2018-11-27 18:30:00.000' AS DateTime), CAST(N'2018-12-04 18:30:00.000' AS DateTime), CAST(7.00 AS Decimal(18, 2)), 0, N'5', N'1540562625682', N'1540450764549', 10, 18, CAST(N'2018-10-26 19:35:28.730' AS DateTime), N'P', N'S20.1.1', CAST(0.00 AS Decimal(18, 2)), N'V', N'', N'S20.1', N'', CAST(N'2018-11-27 18:30:00.000' AS DateTime), CAST(N'2018-12-04 18:30:00.000' AS DateTime), CAST(7.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[BoqEntryDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[BOQLinkDetails] ON 

GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (475, 287, 16, N'1536477632582', N'1534536033221', N'1535110822014', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (476, 293, 16, N'1536479509082', N'1535110822014', N'1535110822023', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (477, 300, 16, N'1536479509083', N'1535110822023', N'1535114209338', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (478, 309, 16, N'1536479509084', N'1535114209338', N'1535114209376', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (479, 315, 16, N'1536479509085', N'1535114209376', N'1535364501334', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (480, 289, 16, N'1536479509086', N'1535110822015', N'1535110822018', 3, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (481, 290, 16, N'1536479509087', N'1535110822018', N'1535110822019', 3, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (482, 288, 16, N'1536479509088', N'1535110822014', N'1535110822015', 3, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (483, 311, 16, N'1536479509090', N'1535114209377', N'1535114209378', 3, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (484, 312, 16, N'1536479509091', N'1535114209378', N'1535114209379', 3, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (955, 325, 17, N'1536519789201', N'0', N'1536519789201', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (956, 326, 17, N'1536542857310', N'1536519789201', N'1536519821126', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (957, 327, 17, N'1536590643984', N'1536519789201', N'1536519821127', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (958, 328, 17, N'1536590643986', N'1536519821126', N'1536519821130', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (959, 329, 17, N'1536590643987', N'1536519821126', N'1536519821132', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (960, 330, 17, N'1536590643989', N'1536519821130', N'1536519821133', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (961, 330, 17, N'1536590643997', N'1536519821127', N'1536519821133', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (962, 331, 17, N'1536590643998', N'1536519821132', N'1536519821135', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (963, 332, 17, N'1536590644001', N'1536519821133', N'1536519821137', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (964, 333, 17, N'1536590644002', N'1536519821135', N'1536519821138', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (965, 333, 17, N'1536590644003', N'1536519821137', N'1536519821138', 2, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2688, 343, 18, N'1538884511454', N'1536898466219', N'1537025686932', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2689, 345, 18, N'1538935040404', N'1537025686933', N'1537025686934', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2690, 338, 18, N'1538940809309', N'1536897835995', N'1536897835996', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2691, 339, 18, N'1538940809310', N'1536897835996', N'1536898466218', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2692, 342, 18, N'1538940809316', N'1536897835995', N'1537025686931', 1, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2693, 340, 18, N'1538962124749', N'1536898466218', N'1536898466219', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2694, 344, 18, N'1538962124751', N'1537025686932', N'1537025686933', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2695, 343, 18, N'1538962124753', N'1536897835996', N'1537025686932', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2696, 347, 18, N'1538962124755', N'1537025686931', N'1537031911833', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2697, 348, 18, N'1538962124756', N'1537025686934', N'1537031911834', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2698, 349, 18, N'1538962124757', N'1537031911834', N'1537032741770', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2699, 350, 18, N'1538962124758', N'1537032741770', N'1537032741771', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2700, 348, 18, N'1538962124759', N'1537031911833', N'1537031911834', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2701, 349, 18, N'1538962124760', N'1537031911833', N'1537032741770', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2702, 350, 18, N'1538962794296', N'1537031911833', N'1537032741771', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2703, 353, 18, N'1538962794297', N'1537032741771', N'1537033035630', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2704, 355, 18, N'1538962794298', N'1537033035630', N'1537033035632', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2705, 356, 18, N'1538962794299', N'1537033035632', N'1537033035633', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2706, 357, 18, N'1538962794300', N'1537033035633', N'1537033035634', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2707, 358, 18, N'1538962794301', N'1537033035634', N'1537033035635', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2730, 343, 18, N'1538884511454', N'1536898466219', N'1537025686932', 0, N'orange', N'R')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2731, 347, 18, N'1538921084191', N'1537025686934', N'1537031911833', 0, N'orange', N'R')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2732, 345, 18, N'1538935040404', N'1537025686933', N'1537025686934', 0, N'orange', N'R')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2733, 348, 18, N'1539011851068', N'1537031911833', N'1537031911834', 0, N'orange', N'R')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2734, 340, 18, N'1539351015725', N'1536898466218', N'1536898466219', 0, N'orange', N'R')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2735, 355, 18, N'1539351635854', N'1537033035630', N'1537033035632', 0, N'orange', N'R')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2736, 356, 18, N'1539351635855', N'1537033035632', N'1537033035633', 0, N'orange', N'R')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2737, 349, 18, N'1539351635856', N'1537031911834', N'1537032741770', 0, N'orange', N'R')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2738, 359, 19, N'1540450464213', N'0', N'1540450464213', NULL, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2744, 359, 19, N'1540450464213', N'0', N'1540450464213', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2749, 359, 19, N'1540450464213', N'0', N'1540450464213', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2753, 359, 19, N'1540450464213', N'0', N'1540450464213', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2756, 359, 19, N'1540450464213', N'0', N'1540450464213', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2758, 359, 19, N'1540450464213', N'0', N'1540450464213', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2761, 359, 19, N'1540450464213', N'0', N'1540450464213', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2765, 359, 19, N'1540450464213', N'0', N'1540450464213', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2766, 359, 19, N'1540450464213', N'0', N'1540450464213', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2767, 366, 19, N'1540625055445', N'1540450764549', N'1540562625682', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2768, 366, 19, N'1540625055445', N'1540450764549', N'1540562625682', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2769, 365, 19, N'1540625055446', N'1540450464216', N'1540450764549', 0, N'orange', N'P')
GO
INSERT [dbo].[BOQLinkDetails] ([BoqLinkId], [BOQId], [ProjectId], [TaskId], [SourceId], [TargetId], [LinkType], [Mcolor], [Flag]) VALUES (2770, 365, 19, N'1540625055446', N'1540450464216', N'1540450764549', 0, N'orange', N'P')
GO
SET IDENTITY_INSERT [dbo].[BOQLinkDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[BoqReviseDetails] ON 

GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (60, 232, N'REVISE 1', CAST(N'2018-05-14 00:00:00.000' AS DateTime), CAST(N'2018-05-18 00:00:00.000' AS DateTime), 0, CAST(N'2018-07-12 00:24:55.000' AS DateTime), N'F', CAST(N'2018-07-12 00:25:16.000' AS DateTime), NULL)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (61, 233, N'REVISE 1', CAST(N'2018-05-17 00:00:00.000' AS DateTime), CAST(N'2018-05-21 00:00:00.000' AS DateTime), 0, CAST(N'2018-07-12 00:24:55.000' AS DateTime), N'F', CAST(N'2018-07-12 00:25:16.000' AS DateTime), NULL)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (62, 235, N'REVISE 1', CAST(N'2018-05-12 00:00:00.000' AS DateTime), CAST(N'2018-05-15 00:00:00.000' AS DateTime), 0, CAST(N'2018-07-12 00:24:55.000' AS DateTime), N'F', CAST(N'2018-07-12 00:25:16.000' AS DateTime), NULL)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (63, 236, N'REVISE 1', CAST(N'2018-05-16 00:00:00.000' AS DateTime), CAST(N'2018-05-18 00:00:00.000' AS DateTime), 0, CAST(N'2018-07-12 00:24:55.000' AS DateTime), N'F', CAST(N'2018-07-12 00:25:16.000' AS DateTime), NULL)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (64, 237, N'REVISE 1', CAST(N'2018-05-19 00:00:00.000' AS DateTime), CAST(N'2018-05-22 00:00:00.000' AS DateTime), 0, CAST(N'2018-07-12 00:24:55.000' AS DateTime), N'F', CAST(N'2018-07-12 00:25:16.000' AS DateTime), NULL)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (65, 241, N'REVISE 1', CAST(N'2018-05-11 00:00:00.000' AS DateTime), CAST(N'2018-05-31 00:00:00.000' AS DateTime), 0, CAST(N'2018-07-12 00:24:55.000' AS DateTime), N'F', CAST(N'2018-07-12 00:25:16.000' AS DateTime), NULL)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (66, 242, N'REVISE 1', CAST(N'2018-06-01 00:00:00.000' AS DateTime), CAST(N'2018-06-03 00:00:00.000' AS DateTime), 0, CAST(N'2018-07-12 00:24:55.000' AS DateTime), N'F', CAST(N'2018-07-12 00:25:16.000' AS DateTime), NULL)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (67, 245, N'REVISE 1', CAST(N'2018-05-13 00:00:00.000' AS DateTime), CAST(N'2018-05-17 00:00:00.000' AS DateTime), 0, CAST(N'2018-07-12 00:24:55.000' AS DateTime), N'F', CAST(N'2018-07-12 00:25:17.000' AS DateTime), NULL)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (68, 251, N'REVISE 1', CAST(N'2018-05-18 00:00:00.000' AS DateTime), CAST(N'2018-05-21 00:00:00.000' AS DateTime), 0, CAST(N'2018-07-12 00:24:55.000' AS DateTime), N'F', CAST(N'2018-07-12 00:25:17.000' AS DateTime), NULL)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (69, 252, N'REVISE 1', CAST(N'2018-05-22 00:00:00.000' AS DateTime), CAST(N'2018-05-25 00:00:00.000' AS DateTime), 0, CAST(N'2018-07-12 00:24:55.000' AS DateTime), N'F', CAST(N'2018-07-12 00:25:17.000' AS DateTime), NULL)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (70, 257, N'REVISE 1', CAST(N'2018-05-21 00:00:00.000' AS DateTime), CAST(N'2018-05-30 00:00:00.000' AS DateTime), 0, CAST(N'2018-07-12 00:24:55.000' AS DateTime), N'F', CAST(N'2018-07-12 00:25:17.000' AS DateTime), NULL)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (71, 258, N'REVISE 1', CAST(N'2018-05-17 00:00:00.000' AS DateTime), CAST(N'2018-05-30 00:00:00.000' AS DateTime), 0, CAST(N'2018-07-12 00:24:55.000' AS DateTime), N'F', CAST(N'2018-07-12 00:25:17.000' AS DateTime), NULL)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (73, 339, N'REVISE 1', CAST(N'2018-09-22 00:00:00.000' AS DateTime), CAST(N'2018-09-25 00:00:00.000' AS DateTime), 17, CAST(N'2018-09-30 11:41:22.000' AS DateTime), N'F', CAST(N'2018-10-03 07:00:27.000' AS DateTime), 18)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (74, 343, N'REVISE 1', CAST(N'2018-09-13 18:30:00.000' AS DateTime), CAST(N'2018-09-23 00:00:00.000' AS DateTime), 17, CAST(N'2018-09-30 12:00:02.000' AS DateTime), N'F', CAST(N'2018-10-12 19:01:09.000' AS DateTime), 18)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (75, 340, N'REVISE 1', CAST(N'2018-09-26 00:00:00.000' AS DateTime), CAST(N'2018-09-29 00:00:00.000' AS DateTime), 17, CAST(N'2018-09-30 14:05:46.000' AS DateTime), N'F', CAST(N'2018-10-12 19:01:09.000' AS DateTime), 18)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (76, 343, N'REVISE 2', CAST(N'2018-09-13 18:30:00.000' AS DateTime), CAST(N'2018-09-23 00:00:00.000' AS DateTime), 17, CAST(N'2018-10-07 09:32:43.000' AS DateTime), N'F', CAST(N'2018-10-12 19:01:09.000' AS DateTime), 18)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (77, 342, N'REVISE 2', CAST(N'2018-09-19 00:00:00.000' AS DateTime), CAST(N'2018-09-20 00:00:00.000' AS DateTime), 17, CAST(N'2018-10-07 09:36:01.000' AS DateTime), N'F', CAST(N'2018-10-12 19:01:09.000' AS DateTime), 18)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (78, 347, N'REVISE 2', CAST(N'2018-09-19 18:30:00.000' AS DateTime), CAST(N'2018-09-26 00:00:00.000' AS DateTime), 17, CAST(N'2018-10-07 18:29:08.000' AS DateTime), N'F', CAST(N'2018-10-12 19:01:09.000' AS DateTime), 18)
GO
INSERT [dbo].[BoqReviseDetails] ([ReviseId], [BOQId], [ReviseType], [RStartDate], [REndDate], [UserId], [EntryDate], [Flag], [FDate], [ProjectId]) VALUES (79, 346, N'REVISE 2', CAST(N'2018-09-20 00:00:00.000' AS DateTime), CAST(N'2018-10-10 00:00:00.000' AS DateTime), 17, CAST(N'2018-10-07 19:34:30.000' AS DateTime), N'P', CAST(N'2018-10-07 19:34:30.000' AS DateTime), 18)
GO
SET IDENTITY_INSERT [dbo].[BoqReviseDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[Client] ON 

GO
INSERT [dbo].[Client] ([ClientId], [CompanyId], [ClientCode], [ClientName], [TaxNo], [GSTNo], [ContactPerson], [Designation], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [CountryId], [NoofUser], [Remark], [ExprieDate], [Modfied_Date], [Status]) VALUES (1, 1, N'1001', N'Sha Construction', NULL, NULL, N'Sha', NULL, NULL, NULL, N'sha@z.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 100, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime), CAST(N'2018-02-28 01:51:18.530' AS DateTime), 1)
GO
INSERT [dbo].[Client] ([ClientId], [CompanyId], [ClientCode], [ClientName], [TaxNo], [GSTNo], [ContactPerson], [Designation], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [CountryId], [NoofUser], [Remark], [ExprieDate], [Modfied_Date], [Status]) VALUES (5, 1, N'1002', N'New', NULL, NULL, N'New', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 25, NULL, CAST(N'2019-02-27 18:30:00.000' AS DateTime), CAST(N'2018-07-16 23:08:34.533' AS DateTime), 1)
GO
INSERT [dbo].[Client] ([ClientId], [CompanyId], [ClientCode], [ClientName], [TaxNo], [GSTNo], [ContactPerson], [Designation], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [CountryId], [NoofUser], [Remark], [ExprieDate], [Modfied_Date], [Status]) VALUES (6, 1, N'1003', N'demo', NULL, NULL, NULL, NULL, NULL, NULL, N'sha@z.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 25, NULL, CAST(N'2019-06-29 18:30:00.000' AS DateTime), CAST(N'2018-07-22 15:16:08.653' AS DateTime), 1)
GO
INSERT [dbo].[Client] ([ClientId], [CompanyId], [ClientCode], [ClientName], [TaxNo], [GSTNo], [ContactPerson], [Designation], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [CountryId], [NoofUser], [Remark], [ExprieDate], [Modfied_Date], [Status]) VALUES (7, 1, N'1004', N'ASN Construction', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 10, NULL, CAST(N'2019-08-30 18:30:00.000' AS DateTime), CAST(N'2018-08-17 00:02:16.287' AS DateTime), 1)
GO
INSERT [dbo].[Client] ([ClientId], [CompanyId], [ClientCode], [ClientName], [TaxNo], [GSTNo], [ContactPerson], [Designation], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [CountryId], [NoofUser], [Remark], [ExprieDate], [Modfied_Date], [Status]) VALUES (8, 1, N'1005', N'INO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 100, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime), CAST(N'2018-09-09 23:32:03.353' AS DateTime), 1)
GO
INSERT [dbo].[Client] ([ClientId], [CompanyId], [ClientCode], [ClientName], [TaxNo], [GSTNo], [ContactPerson], [Designation], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [CountryId], [NoofUser], [Remark], [ExprieDate], [Modfied_Date], [Status]) VALUES (9, 1, N'1006', N'SS Builders', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 100, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime), CAST(N'2018-09-14 08:21:14.090' AS DateTime), 1)
GO
INSERT [dbo].[Client] ([ClientId], [CompanyId], [ClientCode], [ClientName], [TaxNo], [GSTNo], [ContactPerson], [Designation], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [CountryId], [NoofUser], [Remark], [ExprieDate], [Modfied_Date], [Status]) VALUES (10, 1, N'1007', N'Bajaj', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 25, NULL, CAST(N'2019-04-29 18:30:00.000' AS DateTime), CAST(N'2018-10-25 12:16:51.007' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[Client] OFF
GO
INSERT [dbo].[ClientMaster] ([ClientId], [ClientCode], [ClientName], [TaxNo], [GSTNo], [ContactPerson], [Designation], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [Status]) VALUES (1, N'1001', N'Sha Construction', N'', N'', N'Sha', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, 1)
GO
INSERT [dbo].[ClientMaster] ([ClientId], [ClientCode], [ClientName], [TaxNo], [GSTNo], [ContactPerson], [Designation], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [Status]) VALUES (5, N'1002', N'New', NULL, NULL, N'New', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ClientMaster] ([ClientId], [ClientCode], [ClientName], [TaxNo], [GSTNo], [ContactPerson], [Designation], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [Status]) VALUES (6, N'1003', N'demo', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, 1)
GO
INSERT [dbo].[ClientMaster] ([ClientId], [ClientCode], [ClientName], [TaxNo], [GSTNo], [ContactPerson], [Designation], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [Status]) VALUES (7, N'1004', N'ASN Construction', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, 1)
GO
INSERT [dbo].[ClientMaster] ([ClientId], [ClientCode], [ClientName], [TaxNo], [GSTNo], [ContactPerson], [Designation], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [Status]) VALUES (8, N'1005', N'New', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, 1)
GO
INSERT [dbo].[ClientMaster] ([ClientId], [ClientCode], [ClientName], [TaxNo], [GSTNo], [ContactPerson], [Designation], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [Status]) VALUES (9, N'1006', N'SS Builders', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, 1)
GO
INSERT [dbo].[ClientMaster] ([ClientId], [ClientCode], [ClientName], [TaxNo], [GSTNo], [ContactPerson], [Designation], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [Status]) VALUES (10, N'1007', N'Bajaj', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, 1)
GO
SET IDENTITY_INSERT [dbo].[Company] ON 

GO
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [Country], [TaxNo], [GSTNo], [AuthorisedPerson], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website]) VALUES (1, N'MUST INNOSOFT PTE LTD', NULL, N'New Building', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Company] OFF
GO
SET IDENTITY_INSERT [dbo].[Country] ON 

GO
INSERT [dbo].[Country] ([CountryId], [Country_Name], [Country_Code], [Country_TimeZone], [Country_Currency], [Status]) VALUES (1, N'Singapore', N'+65', N'UTC +8', N'Singapore Dollar', 1)
GO
INSERT [dbo].[Country] ([CountryId], [Country_Name], [Country_Code], [Country_TimeZone], [Country_Currency], [Status]) VALUES (2, N'United Arab Emirates', N'+971', N'GMT +4', N'United Arab Emirates Dirham', 1)
GO
SET IDENTITY_INSERT [dbo].[Country] OFF
GO
SET IDENTITY_INSERT [dbo].[CriticalPathDetails] ON 

GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (1, 16, 278, N'1534536033221', N'P10', N',M10', CAST(167.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (2, 16, 287, N'1535110822014', N'M10', N',M20,S10', CAST(28.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(28.00 AS Decimal(18, 2)), N',P10', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (3, 16, 288, N'1535110822015', N'S10', N',S20', CAST(13.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(13.00 AS Decimal(18, 2)), N',M10', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (4, 16, 289, N'1535110822018', N'S20', N',S30', CAST(21.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(21.00 AS Decimal(18, 2)), N',S10', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (5, 16, 290, N'1535110822019', N'S30', N'', CAST(15.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(15.00 AS Decimal(18, 2)), N',S20', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (6, 16, 291, N'1535110822020', N'S40', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (7, 16, 292, N'1535110822021', N'S50', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (8, 16, 293, N'1535110822023', N'M20', N',M30', CAST(28.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(28.00 AS Decimal(18, 2)), N',M10', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (9, 16, 294, N'1535110822024', N'S60', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (10, 16, 295, N'1535110822025', N'S70', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (11, 16, 296, N'1535110822026', N'S80', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (12, 16, 297, N'1535110822027', N'S90', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (13, 16, 298, N'1535110822028', N'S100', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (14, 16, 299, N'1535110822029', N'S110', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (15, 16, 300, N'1535114209338', N'M30', N',M40', CAST(28.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(28.00 AS Decimal(18, 2)), N',M20', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (16, 16, 301, N'1535114209339', N'S120', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (17, 16, 302, N'1535114209340', N'S10.1', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (18, 16, 303, N'1535114209341', N'S10.2', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (19, 16, 304, N'1535114209342', N'S10.3', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (20, 16, 305, N'1535114209343', N'S10.4', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (21, 16, 306, N'1535114209344', N'S10.5', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (22, 16, 307, N'1535114209345', N'S10.6', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (23, 16, 308, N'1535114209346', N'S10.7', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (24, 16, 309, N'1535114209376', N'M40', N',M50', CAST(123.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), N',M30', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (25, 16, 310, N'1535114209377', N'S130', N',S140', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (26, 16, 311, N'1535114209378', N'S140', N'', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N',S130', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (27, 16, 312, N'1535114209379', N'S150', N'', CAST(55.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (28, 16, 313, N'1535114209380', N'S160', N'', CAST(48.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (29, 16, 314, N'1535114209381', N'S170', N'', CAST(109.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (30, 16, 315, N'1535364501334', N'M50', N'', CAST(28.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(28.00 AS Decimal(18, 2)), N',M40', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (31, 16, 316, N'1536486622057', N'S180', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (32, 16, 317, N'1536508611614', N'M60', N'', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (33, 16, 318, N'1536508611615', N'M70', N'', CAST(6.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (34, 16, 319, N'1536508611617', N'M80', N'', CAST(5.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (35, 16, 320, N'1536508611618', N'M90', N'', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (36, 16, 321, N'1536508611619', N'M100', N'', CAST(5.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (37, 16, 322, N'1536508611620', N'M110', N'', CAST(5.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (38, 16, 323, N'1536508611622', N'M120', N'', CAST(5.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (39, 16, 324, N'1536509168832', N'M130', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (40, 17, 325, N'1536519789201', N'P10', N'M10,M20', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1536519789201', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (41, 17, 326, N'1536519821126', N'M10', N'M30,M40', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), N'P10', CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1536519821126', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (42, 17, 327, N'1536519821127', N'M20', N'M50', CAST(6.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), N'P10', CAST(3.00 AS Decimal(18, 2)), CAST(9.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (43, 17, 328, N'1536519821130', N'M30', N'M50', CAST(5.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), CAST(9.00 AS Decimal(18, 2)), N'M10', CAST(4.00 AS Decimal(18, 2)), CAST(9.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1536519821130', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (44, 17, 329, N'1536519821132', N'M40', N'M60', CAST(7.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), CAST(11.00 AS Decimal(18, 2)), N'M10', CAST(7.00 AS Decimal(18, 2)), CAST(14.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (45, 17, 330, N'1536519821133', N'M50', N'M70', CAST(5.00 AS Decimal(18, 2)), CAST(9.00 AS Decimal(18, 2)), CAST(14.00 AS Decimal(18, 2)), N'M30,M20', CAST(9.00 AS Decimal(18, 2)), CAST(14.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1536519821133', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (46, 17, 331, N'1536519821135', N'M60', N'M80', CAST(5.00 AS Decimal(18, 2)), CAST(11.00 AS Decimal(18, 2)), CAST(16.00 AS Decimal(18, 2)), N'M40', CAST(14.00 AS Decimal(18, 2)), CAST(19.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (47, 17, 332, N'1536519821137', N'M70', N'M80', CAST(5.00 AS Decimal(18, 2)), CAST(14.00 AS Decimal(18, 2)), CAST(19.00 AS Decimal(18, 2)), N'M50', CAST(14.00 AS Decimal(18, 2)), CAST(19.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1536519821137', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (48, 17, 333, N'1536519821138', N'M80', N'', CAST(0.00 AS Decimal(18, 2)), CAST(19.00 AS Decimal(18, 2)), CAST(19.00 AS Decimal(18, 2)), N'M60,M70', CAST(19.00 AS Decimal(18, 2)), CAST(19.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (49, 18, 334, N'1536897835991', N'P10', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (50, 18, 335, N'1536897835992', N'M10', N'', CAST(4.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (51, 18, 336, N'1536897835994', N'S10', N'', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (52, 18, 337, N'1536897835995', N'S10.1', N'S10.2,S20.1', CAST(6.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1536897835995', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (53, 18, 338, N'1536897835996', N'S10.2', N'S10.3,S20.2', CAST(2.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), CAST(8.00 AS Decimal(18, 2)), N'S10.1', CAST(6.00 AS Decimal(18, 2)), CAST(8.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1536897835996', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (54, 18, 339, N'1536898466218', N'S10.3', N'S10.4', CAST(4.00 AS Decimal(18, 2)), CAST(8.00 AS Decimal(18, 2)), CAST(12.00 AS Decimal(18, 2)), N'S10.2', CAST(8.00 AS Decimal(18, 2)), CAST(12.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1536898466218', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (55, 18, 340, N'1536898466219', N'S10.4', N'S20.2', CAST(1.00 AS Decimal(18, 2)), CAST(12.00 AS Decimal(18, 2)), CAST(13.00 AS Decimal(18, 2)), N'S10.3', CAST(12.00 AS Decimal(18, 2)), CAST(13.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1536898466219', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (56, 18, 341, N'1537025686930', N'S20', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (57, 18, 342, N'1537025686931', N'S20.1', N'S30.1', CAST(1.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), CAST(7.00 AS Decimal(18, 2)), N'S10.1', CAST(13.00 AS Decimal(18, 2)), CAST(14.00 AS Decimal(18, 2)), CAST(7.00 AS Decimal(18, 2)), N'1537025686931', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (58, 18, 343, N'1537025686932', N'S20.2', N'S20.3', CAST(2.00 AS Decimal(18, 2)), CAST(13.00 AS Decimal(18, 2)), CAST(15.00 AS Decimal(18, 2)), N'S10.4,S10.2', CAST(13.00 AS Decimal(18, 2)), CAST(15.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1537025686932', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (59, 18, 344, N'1537025686933', N'S20.3', N'S20.4', CAST(1.00 AS Decimal(18, 2)), CAST(15.00 AS Decimal(18, 2)), CAST(16.00 AS Decimal(18, 2)), N'S20.2', CAST(15.00 AS Decimal(18, 2)), CAST(16.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1537025686933', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (60, 18, 345, N'1537025686934', N'S20.4', N'S30.2', CAST(2.00 AS Decimal(18, 2)), CAST(16.00 AS Decimal(18, 2)), CAST(18.00 AS Decimal(18, 2)), N'S20.3', CAST(16.00 AS Decimal(18, 2)), CAST(18.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1537025686934', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (61, 18, 346, N'1537025686935', N'S30', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (62, 18, 347, N'1537031911833', N'S30.1', N'S30.2,S30.3,S30.4', CAST(4.00 AS Decimal(18, 2)), CAST(7.00 AS Decimal(18, 2)), CAST(11.00 AS Decimal(18, 2)), N'S20.1', CAST(14.00 AS Decimal(18, 2)), CAST(18.00 AS Decimal(18, 2)), CAST(7.00 AS Decimal(18, 2)), N'', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (63, 18, 348, N'1537031911834', N'S30.2', N'S30.3', CAST(3.00 AS Decimal(18, 2)), CAST(18.00 AS Decimal(18, 2)), CAST(21.00 AS Decimal(18, 2)), N'S20.4,S30.1', CAST(18.00 AS Decimal(18, 2)), CAST(21.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1537031911834', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (64, 18, 349, N'1537032741770', N'S30.3', N'S30.4', CAST(4.00 AS Decimal(18, 2)), CAST(21.00 AS Decimal(18, 2)), CAST(25.00 AS Decimal(18, 2)), N'S30.2,S30.1', CAST(21.00 AS Decimal(18, 2)), CAST(25.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1537032741770', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (65, 18, 350, N'1537032741771', N'S30.4', N'S40.1', CAST(2.00 AS Decimal(18, 2)), CAST(25.00 AS Decimal(18, 2)), CAST(27.00 AS Decimal(18, 2)), N'S30.3,S30.1', CAST(25.00 AS Decimal(18, 2)), CAST(27.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1537032741771', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (66, 18, 351, N'1537033035628', N'M20', N'', NULL, CAST(27.00 AS Decimal(18, 2)), NULL, N'S30.4', NULL, NULL, NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (67, 18, 352, N'1537033035629', N'S40', N'', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (68, 18, 353, N'1537033035630', N'S40.1', N'S50.1', CAST(4.00 AS Decimal(18, 2)), CAST(27.00 AS Decimal(18, 2)), CAST(31.00 AS Decimal(18, 2)), N'S30.4', CAST(27.00 AS Decimal(18, 2)), CAST(31.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1537033035630', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (69, 18, 354, N'1537033035631', N'S50', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (70, 18, 355, N'1537033035632', N'S50.1', N'S50.2', CAST(3.00 AS Decimal(18, 2)), CAST(31.00 AS Decimal(18, 2)), CAST(34.00 AS Decimal(18, 2)), N'S40.1', CAST(31.00 AS Decimal(18, 2)), CAST(34.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1537033035632', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (71, 18, 356, N'1537033035633', N'S50.2', N'S50.3', CAST(3.00 AS Decimal(18, 2)), CAST(34.00 AS Decimal(18, 2)), CAST(37.00 AS Decimal(18, 2)), N'S50.1', CAST(34.00 AS Decimal(18, 2)), CAST(37.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1537033035633', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (72, 18, 357, N'1537033035634', N'S50.3', N'S50.4', CAST(2.00 AS Decimal(18, 2)), CAST(37.00 AS Decimal(18, 2)), CAST(39.00 AS Decimal(18, 2)), N'S50.2', CAST(37.00 AS Decimal(18, 2)), CAST(39.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1537033035634', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (73, 18, 358, N'1537033035635', N'S50.4', N'', CAST(1.00 AS Decimal(18, 2)), CAST(39.00 AS Decimal(18, 2)), CAST(40.00 AS Decimal(18, 2)), N'S50.3', CAST(39.00 AS Decimal(18, 2)), CAST(40.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1537033035635', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (74, 18, 334, N'1536897835991', N'P10', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (75, 18, 335, N'1536897835992', N'M10', N'', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (76, 18, 336, N'1536897835994', N'S10', N'', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (77, 18, 337, N'1536897835995', N'S10.1', N'', CAST(6.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (78, 18, 338, N'1536897835996', N'S10.2', N'', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (79, 18, 339, N'1536898466218', N'S10.3', N'', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (80, 18, 340, N'1536898466219', N'S10.4', N'S20.2', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'', CAST(-3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(-3.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (81, 18, 341, N'1537025686930', N'S20', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (82, 18, 342, N'1537025686931', N'S20.1', N'', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (83, 18, 343, N'1537025686932', N'S20.2', N'', CAST(9.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), CAST(12.00 AS Decimal(18, 2)), N'S10.4', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1537025686932', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (84, 18, 344, N'1537025686933', N'S20.3', N'', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (85, 18, 345, N'1537025686934', N'S20.4', N'', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (86, 18, 346, N'1537025686935', N'S30', N'', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (87, 18, 347, N'1537031911833', N'S30.1', N'S30.2', CAST(6.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), N'', CAST(3.00 AS Decimal(18, 2)), CAST(9.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (88, 18, 348, N'1537031911834', N'S30.2', N'', CAST(3.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), CAST(9.00 AS Decimal(18, 2)), N'S30.1', CAST(9.00 AS Decimal(18, 2)), CAST(12.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (89, 18, 349, N'1537032741770', N'S30.3', N'', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (90, 18, 350, N'1537032741771', N'S30.4', N'', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (91, 18, 351, N'1537033035628', N'M20', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (92, 18, 352, N'1537033035629', N'S40', N'', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (93, 18, 353, N'1537033035630', N'S40.1', N'', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (94, 18, 354, N'1537033035631', N'S50', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (95, 18, 355, N'1537033035632', N'S50.1', N'', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (96, 18, 356, N'1537033035633', N'S50.2', N'', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (97, 18, 357, N'1537033035634', N'S50.3', N'', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (98, 18, 358, N'1537033035635', N'S50.4', N'', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (99, 18, 334, N'1536897835991', N'P10', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (100, 18, 335, N'1536897835992', N'M10', N'', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (101, 18, 336, N'1536897835994', N'S10', N'', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (102, 18, 337, N'1536897835995', N'S10.1', N'', CAST(6.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (103, 18, 338, N'1536897835996', N'S10.2', N'', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (104, 18, 339, N'1536898466218', N'S10.3', N'', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (105, 18, 340, N'1536898466219', N'S10.4', N'S20.2', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'', CAST(-1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(-1.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (106, 18, 341, N'1537025686930', N'S20', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (107, 18, 342, N'1537025686931', N'S20.1', N'', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (108, 18, 343, N'1537025686932', N'S20.2', N'', CAST(9.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), CAST(12.00 AS Decimal(18, 2)), N'S10.4', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1537025686932', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (109, 18, 344, N'1537025686933', N'S20.3', N'', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (110, 18, 345, N'1537025686934', N'S20.4', N'', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (111, 18, 346, N'1537025686935', N'S30', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (112, 18, 347, N'1537031911833', N'S30.1', N'S30.2', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), N'', CAST(5.00 AS Decimal(18, 2)), CAST(9.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (113, 18, 348, N'1537031911834', N'S30.2', N'', CAST(3.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), CAST(9.00 AS Decimal(18, 2)), N'S30.1', CAST(9.00 AS Decimal(18, 2)), CAST(12.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (114, 18, 349, N'1537032741770', N'S30.3', N'', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (115, 18, 350, N'1537032741771', N'S30.4', N'', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (116, 18, 351, N'1537033035628', N'M20', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (117, 18, 352, N'1537033035629', N'S40', N'', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (118, 18, 353, N'1537033035630', N'S40.1', N'', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (119, 18, 354, N'1537033035631', N'S50', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (120, 18, 355, N'1537033035632', N'S50.1', N'', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (121, 18, 356, N'1537033035633', N'S50.2', N'', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (122, 18, 357, N'1537033035634', N'S50.3', N'', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (123, 18, 358, N'1537033035635', N'S50.4', N'', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (124, 19, 359, N'1540450464213', N'P10', N'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (125, 19, 361, N'1540450464215', N'S10', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (126, 19, 362, N'1540450464216', N'S10.1', N'S20.1', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1540450464216', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (127, 19, 364, N'1540450764548', N'S20', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (128, 19, 365, N'1540450764549', N'S20.1', N'S20.1.1', CAST(4.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), CAST(8.00 AS Decimal(18, 2)), N'S10.1', CAST(4.00 AS Decimal(18, 2)), CAST(8.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1540450764549', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (129, 19, 366, N'1540562625682', N'S20.1.1', N'', CAST(7.00 AS Decimal(18, 2)), CAST(8.00 AS Decimal(18, 2)), CAST(15.00 AS Decimal(18, 2)), N'S20.1', CAST(8.00 AS Decimal(18, 2)), CAST(15.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1540562625682', N'P')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (130, 19, 359, N'1540450464213', N'P10', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (131, 19, 361, N'1540450464215', N'S10', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (132, 19, 362, N'1540450464216', N'S10.1', N'', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (133, 19, 364, N'1540450764548', N'S20', N'', NULL, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (134, 19, 365, N'1540450764549', N'S20.1', N'', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
INSERT [dbo].[CriticalPathDetails] ([CriticalId], [ProjectId], [BOQId], [TaskId], [BOQRefId], [dep], [Duration], [ES], [EF], [Predec], [LS], [LF], [Slack], [Criticaltaskid], [Flag]) VALUES (135, 19, 366, N'1540562625682', N'S20.1.1', N'', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'R')
GO
SET IDENTITY_INSERT [dbo].[CriticalPathDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[DatabaseDetails] ON 

GO
INSERT [dbo].[DatabaseDetails] ([DatabaseId], [CompanyId], [ClientId], [Server_Name], [DB_Name], [DB_Username], [DB_Password], [Status]) VALUES (1, 1, 1, N'AZEES-PC', N'ConstructionPro', N'condb', N'condb@123', 1)
GO
INSERT [dbo].[DatabaseDetails] ([DatabaseId], [CompanyId], [ClientId], [Server_Name], [DB_Name], [DB_Username], [DB_Password], [Status]) VALUES (5, 1, 5, N'AZEES-PC', N'ConstructionPro', N'condb', N'condb@123', 1)
GO
INSERT [dbo].[DatabaseDetails] ([DatabaseId], [CompanyId], [ClientId], [Server_Name], [DB_Name], [DB_Username], [DB_Password], [Status]) VALUES (6, 1, 6, N'AZEES-PC', N'ConstructionPro', N'condb', N'condb@123', 1)
GO
INSERT [dbo].[DatabaseDetails] ([DatabaseId], [CompanyId], [ClientId], [Server_Name], [DB_Name], [DB_Username], [DB_Password], [Status]) VALUES (7, 1, 7, N'AZEES-PC', N'ConstructionPro', N'condb', N'condb@123', 1)
GO
INSERT [dbo].[DatabaseDetails] ([DatabaseId], [CompanyId], [ClientId], [Server_Name], [DB_Name], [DB_Username], [DB_Password], [Status]) VALUES (8, 1, 8, N'AZEES-PC', N'ConstructionPro', N'condb', N'condb@123', 1)
GO
INSERT [dbo].[DatabaseDetails] ([DatabaseId], [CompanyId], [ClientId], [Server_Name], [DB_Name], [DB_Username], [DB_Password], [Status]) VALUES (9, 1, 9, N'AZEES-PC', N'ConstructionPro', N'condb', N'condb@123', 1)
GO
INSERT [dbo].[DatabaseDetails] ([DatabaseId], [CompanyId], [ClientId], [Server_Name], [DB_Name], [DB_Username], [DB_Password], [Status]) VALUES (10, 1, 10, N'AZEES-PC', N'ConstructionPro', N'condb', N'condb@123', 1)
GO
SET IDENTITY_INSERT [dbo].[DatabaseDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[ExternalWorkDetails] ON 

GO
INSERT [dbo].[ExternalWorkDetails] ([ExDetId], [ProjectId], [ExternalWork], [Units], [Qty]) VALUES (6, 1, N'1', N'Nos', 1)
GO
INSERT [dbo].[ExternalWorkDetails] ([ExDetId], [ProjectId], [ExternalWork], [Units], [Qty]) VALUES (7, 1, N'2', N'Kg', 2)
GO
INSERT [dbo].[ExternalWorkDetails] ([ExDetId], [ProjectId], [ExternalWork], [Units], [Qty]) VALUES (8, 10, N'1', N'Nos', 2)
GO
INSERT [dbo].[ExternalWorkDetails] ([ExDetId], [ProjectId], [ExternalWork], [Units], [Qty]) VALUES (9, 10, N'2', N'Kg', 2)
GO
INSERT [dbo].[ExternalWorkDetails] ([ExDetId], [ProjectId], [ExternalWork], [Units], [Qty]) VALUES (10, 11, N'1', N'Nos', 5)
GO
INSERT [dbo].[ExternalWorkDetails] ([ExDetId], [ProjectId], [ExternalWork], [Units], [Qty]) VALUES (11, 11, N'2', N'Nos', 5)
GO
INSERT [dbo].[ExternalWorkDetails] ([ExDetId], [ProjectId], [ExternalWork], [Units], [Qty]) VALUES (12, 11, N'3', N'Nos', 2)
GO
INSERT [dbo].[ExternalWorkDetails] ([ExDetId], [ProjectId], [ExternalWork], [Units], [Qty]) VALUES (14, 16, N'Corridor', N'Nos', 2)
GO
INSERT [dbo].[ExternalWorkDetails] ([ExDetId], [ProjectId], [ExternalWork], [Units], [Qty]) VALUES (15, 16, N'GUARD HOUSE', N'Nos', 1)
GO
INSERT [dbo].[ExternalWorkDetails] ([ExDetId], [ProjectId], [ExternalWork], [Units], [Qty]) VALUES (16, 16, N'Lift Lobby', N'Nos', 2)
GO
INSERT [dbo].[ExternalWorkDetails] ([ExDetId], [ProjectId], [ExternalWork], [Units], [Qty]) VALUES (17, 19, N'SEWER MANHOLES', N'Nos', 1)
GO
INSERT [dbo].[ExternalWorkDetails] ([ExDetId], [ProjectId], [ExternalWork], [Units], [Qty]) VALUES (18, 19, N'New', N'Kg', 1)
GO
SET IDENTITY_INSERT [dbo].[ExternalWorkDetails] OFF
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'1', N'SEWER MANHOLES', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'10', N'SUBSTATION', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'11', N'BIN CENTRE', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'12', N'SECURITY HOUSE', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'13', N'GUARD HOUSE', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'14', N'FENCE', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'15', N'BOUNDARY WALL', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'16', N'GATES', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'17', N'REINSTATEMENT', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'18', N'ANY OTHERS-"X"', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'2', N'TELECOM MANHOLES', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'3', N'MANHOLES', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'4', N'RC DRAINS', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'5', N'U-DRAINS', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'6', N'LANDSCAPE AREAS', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'7', N'HARDSCAPE AREAS', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'8', N'FOOTPATH', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (N'9', N'KERBS', 1)
GO
SET IDENTITY_INSERT [dbo].[HolidayMaster] ON 

GO
INSERT [dbo].[HolidayMaster] ([HId], [ClientId], [HolidayName], [HolidayDate], [Status]) VALUES (1, 9, N'Gan', CAST(N'2018-10-01 00:00:00.000' AS DateTime), N'1')
GO
INSERT [dbo].[HolidayMaster] ([HId], [ClientId], [HolidayName], [HolidayDate], [Status]) VALUES (2, 9, N'Cris', CAST(N'2018-10-31 00:00:00.000' AS DateTime), N'1')
GO
SET IDENTITY_INSERT [dbo].[HolidayMaster] OFF
GO
SET IDENTITY_INSERT [dbo].[MainItemMaster] ON 

GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (9, 1, N'GENERAL REQUIREMENTS/ PRELIMINARIES', CAST(4200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (10, 1, N'SITE WORKS', CAST(4000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (11, 1, N'CONCRETE', CAST(81365.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (12, 1, N'MECHANICAL WORKS', CAST(148380.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (13, 10, N'01-GENERAL REQUIREMENTS/ PRELIMINARIES', CAST(1600.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (14, 10, N'02-SITE WORKS', CAST(4000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (15, 10, N'03-CONCRETE', CAST(81000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (16, 10, N'15-MECHANICAL WORKS', CAST(148000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (17, 10, N'16-ELECTRICAL WORKS', CAST(580000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (18, 11, N'GENERAL REQUIREMENTS/ PRELIMINARIES', CAST(5000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (19, 11, N'SITE WORKS', CAST(2000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (20, 11, N'CONCRETE', CAST(3000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (21, 11, N'MECHANICAL WORKS', CAST(2000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (22, 16, N'Main Contract', CAST(1000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (23, 16, N'2nd storey wall opening between Yotel Carpark Lift Lobby to IB.', CAST(1000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (24, 16, N'Flipping of existing Escalator', CAST(1000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (25, 16, N'2nd storey', CAST(1000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (26, 16, N'Inspection & Commissioning', CAST(1000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (27, 16, N'Completion', CAST(1000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (28, 16, N'Construction', CAST(1000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (29, 17, N'Start', CAST(10000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (30, 18, N'GENERAL REQUIREMENTS/ PRELIMINARIES', CAST(4200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (31, 18, N'SITE WORKS', CAST(7230.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (32, 18, N'CONCRETE', CAST(81365.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (33, 18, N'MECHANICAL WORKS', CAST(148380.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (34, 18, N'ELECTRICAL WORKS', CAST(22952.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (35, 19, N'A', CAST(10000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (36, 19, N'B', CAST(10000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[MainItemMaster] ([MainItemId], [ProjectId], [MainItemName], [Cost]) VALUES (37, 19, N'C', CAST(20000.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[MainItemMaster] OFF
GO
SET IDENTITY_INSERT [dbo].[MenuDetails] ON 

GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (1, N'Master', N'master', NULL, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (2, N'Dashboard', N'master/dashboard', 1, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (3, N'Admin Company', N'master/company', 1, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (4, N'Country', N'master/country', 1, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (5, N'Client Company', N'master/client', 1, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (6, N'User Details', N'master/userdetails', 1, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (7, N'Projects', N'Process', NULL, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (9, N'Menu', N'master/usermenu', 1, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (10, N'Project Name & Duration', N'process/project', 7, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (11, N'Project Description', N'process/projectdescription', 7, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (12, N'Bill of Quantities', N'process/boqdetails', 7, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (13, N'BOQ Variation', N'process/boqvariation', 7, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (14, N'BOQ View', N'process/boqview', 7, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (15, N'Reports', N'reports', NULL, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (16, N'BOQ Detail Report', N'reports/boqreports', 15, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (17, N'BOQ Daily Workdone %', N'process/boqprocess', 7, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (18, N'BOQ Base Schedule', N'process/boqupdate', 7, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (19, N'BOQ Schedule Revisions', N'process/reviseboq', 7, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (20, N'Supplier/Subcontractor', N'master/supplier', 1, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (21, N'BOQ Schedule Dates View', N'process/boqreviseview', 7, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (22, N'BOQ Revise New', N'process/reviseboq', 7, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (23, N'Holiday Entry', N'master/holidayentry', 1, 1)
GO
SET IDENTITY_INSERT [dbo].[MenuDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[ProjectDescription] ON 

GO
INSERT [dbo].[ProjectDescription] ([PDId], [ProjectId], [Foundation], [Basement], [Podium], [Mezanine], [CreateDate], [UserId]) VALUES (1, 1, 2, 1, 1, 0, CAST(N'2018-03-21 22:49:30.000' AS DateTime), 0)
GO
INSERT [dbo].[ProjectDescription] ([PDId], [ProjectId], [Foundation], [Basement], [Podium], [Mezanine], [CreateDate], [UserId]) VALUES (2, 10, 2, 2, 0, 0, CAST(N'2018-07-20 23:00:14.000' AS DateTime), 0)
GO
INSERT [dbo].[ProjectDescription] ([PDId], [ProjectId], [Foundation], [Basement], [Podium], [Mezanine], [CreateDate], [UserId]) VALUES (3, 11, 1, 0, 0, 0, CAST(N'2018-07-23 23:39:51.460' AS DateTime), 10)
GO
INSERT [dbo].[ProjectDescription] ([PDId], [ProjectId], [Foundation], [Basement], [Podium], [Mezanine], [CreateDate], [UserId]) VALUES (5, 16, 2, 0, 0, 0, CAST(N'2018-08-18 01:19:22.010' AS DateTime), 14)
GO
INSERT [dbo].[ProjectDescription] ([PDId], [ProjectId], [Foundation], [Basement], [Podium], [Mezanine], [CreateDate], [UserId]) VALUES (6, 17, 1, 0, 0, 0, CAST(N'2018-09-09 23:38:14.727' AS DateTime), 16)
GO
INSERT [dbo].[ProjectDescription] ([PDId], [ProjectId], [Foundation], [Basement], [Podium], [Mezanine], [CreateDate], [UserId]) VALUES (7, 18, 1, 0, 0, 0, CAST(N'2018-09-14 09:33:47.657' AS DateTime), 17)
GO
INSERT [dbo].[ProjectDescription] ([PDId], [ProjectId], [Foundation], [Basement], [Podium], [Mezanine], [CreateDate], [UserId]) VALUES (8, 19, 1, 1, 0, 0, CAST(N'2018-10-25 12:24:16.203' AS DateTime), 18)
GO
SET IDENTITY_INSERT [dbo].[ProjectDescription] OFF
GO
SET IDENTITY_INSERT [dbo].[ProjectDescriptionDetails] ON 

GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (1, 1, 1, N'Foundation1', N'FO')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (2, 1, 1, N'Foundation2', N'FO')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (3, 1, 1, N'Basement', N'BA')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (4, 1, 1, N'Podium', N'PO')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (5, 9, 1, N'1Floor', N'FL')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (6, 9, 1, N'2Floor', N'FL')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (7, 9, 1, N'3Floor', N'FL')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (8, 9, 1, N'4Floor', N'FL')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (9, 9, 1, N'LOWER ROOF', N'LR')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (10, 9, 1, N'UPPER ROOF', N'UR')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (11, 10, 1, N'1Floor', N'FL')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (12, 10, 1, N'2Floor', N'FL')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (13, 10, 1, N'3Floor', N'FL')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (14, 10, 1, N'4Floor', N'FL')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (15, 10, 1, N'LOWER ROOF', N'LR')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (16, 10, 1, N'UPPER ROOF', N'UR')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (17, 2, 10, N'Foundation1', N'FO')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (18, 2, 10, N'Foundation2', N'FO')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (19, 2, 10, N'Basement1', N'BA')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (20, 2, 10, N'Basement2', N'BA')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (21, 11, 10, N'Floor1', N'FL')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (22, 12, 10, N'Floors1', N'FL')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (23, 3, 11, N'Foundation', N'FO')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (24, 13, 11, N'Floor-1', N'FL')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (27, 5, 16, N'Foundation-Main Contract', N'FO')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (28, 5, 16, N'Foundation-ID NSC Works', N'FO')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (29, 6, 17, N'Start', N'FO')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (30, 7, 18, N'Foundation', N'FO')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (31, 8, 19, N'Foundation-1', N'FO')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (32, 8, 19, N'Basement-1', N'BA')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (33, 15, 19, N'Floor-1', N'FL')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (34, 15, 19, N'LOWER ROOF-1', N'LR')
GO
INSERT [dbo].[ProjectDescriptionDetails] ([Id], [RefId], [ProjectId], [Name], [Type]) VALUES (35, 15, 19, N'UPPER ROOF-1', N'UR')
GO
SET IDENTITY_INSERT [dbo].[ProjectDescriptionDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[ProjectMaster] ON 

GO
INSERT [dbo].[ProjectMaster] ([ProjectId], [ClientId], [ProjectName], [ProjectLocation], [ProjectIncharge], [ContactNo], [EmailId], [Start_Date], [End_Date], [ProjectDuration], [UserId], [Status], [Fromday], [Today], [Fromtime], [Totime]) VALUES (1, 1, N'BIMCAD Technologies', N'', N'', N'', N'', CAST(N'2018-05-01 00:00:00.000' AS DateTime), CAST(N'2018-06-10 00:00:00.000' AS DateTime), N'0.2 Years & 3 Months & 13 Weeks & 91 Days', 0, 1, N'0', N'5', N'9', N'18')
GO
INSERT [dbo].[ProjectMaster] ([ProjectId], [ClientId], [ProjectName], [ProjectLocation], [ProjectIncharge], [ContactNo], [EmailId], [Start_Date], [End_Date], [ProjectDuration], [UserId], [Status], [Fromday], [Today], [Fromtime], [Totime]) VALUES (10, 5, N'new', N'', N'', N'', N'', CAST(N'2018-07-19 18:30:00.000' AS DateTime), CAST(N'2019-06-29 18:30:00.000' AS DateTime), N'0.9 Years & 13 Months & 49 Weeks & 345 Days', 0, 1, N'0', N'5', N'9', N'18')
GO
INSERT [dbo].[ProjectMaster] ([ProjectId], [ClientId], [ProjectName], [ProjectLocation], [ProjectIncharge], [ContactNo], [EmailId], [Start_Date], [End_Date], [ProjectDuration], [UserId], [Status], [Fromday], [Today], [Fromtime], [Totime]) VALUES (11, 6, N'demo1', N'', N'', N'', N'', CAST(N'2018-07-21 18:30:00.000' AS DateTime), CAST(N'2019-06-29 18:30:00.000' AS DateTime), N'0.9 Years & 13 Months & 49 Weeks & 343 Days', 10, 1, N'1', N'5', N'10', N'19')
GO
INSERT [dbo].[ProjectMaster] ([ProjectId], [ClientId], [ProjectName], [ProjectLocation], [ProjectIncharge], [ContactNo], [EmailId], [Start_Date], [End_Date], [ProjectDuration], [UserId], [Status], [Fromday], [Today], [Fromtime], [Totime]) VALUES (16, 7, N'ASN Market City', N'', N'', N'', N'', CAST(N'2018-07-01 18:30:00.000' AS DateTime), CAST(N'2019-11-15 18:30:00.000' AS DateTime), N'0.7 Years & 8 Months & 34 Weeks & 241 Days', 14, 1, N'1', N'5', N'10', N'19')
GO
INSERT [dbo].[ProjectMaster] ([ProjectId], [ClientId], [ProjectName], [ProjectLocation], [ProjectIncharge], [ContactNo], [EmailId], [Start_Date], [End_Date], [ProjectDuration], [UserId], [Status], [Fromday], [Today], [Fromtime], [Totime]) VALUES (17, 8, N'LUX', N'', N'', N'', N'', CAST(N'2018-09-08 18:30:00.000' AS DateTime), CAST(N'2019-04-29 18:30:00.000' AS DateTime), N'0.6 Years & 8 Months & 33 Weeks & 233 Days', 16, 1, N'0', N'5', N'9', N'18')
GO
INSERT [dbo].[ProjectMaster] ([ProjectId], [ClientId], [ProjectName], [ProjectLocation], [ProjectIncharge], [ContactNo], [EmailId], [Start_Date], [End_Date], [ProjectDuration], [UserId], [Status], [Fromday], [Today], [Fromtime], [Totime]) VALUES (18, 9, N'Grand Mall', N'', N'', N'', N'', CAST(N'2018-09-13 18:30:00.000' AS DateTime), CAST(N'2019-06-13 18:30:00.000' AS DateTime), N'0.7 Years & 9 Months & 39 Weeks & 273 Days', 17, 1, N'1', N'5', N'9', N'18')
GO
INSERT [dbo].[ProjectMaster] ([ProjectId], [ClientId], [ProjectName], [ProjectLocation], [ProjectIncharge], [ContactNo], [EmailId], [Start_Date], [End_Date], [ProjectDuration], [UserId], [Status], [Fromday], [Today], [Fromtime], [Totime]) VALUES (19, 10, N'New Grand Mall', N'', N'', N'', N'', CAST(N'2018-10-27 18:30:00.000' AS DateTime), CAST(N'2019-03-30 18:30:00.000' AS DateTime), N'0.4 Years & 5 Months & 22 Weeks & 154 Days', 18, 1, N'1', N'6', N'9', N'18')
GO
SET IDENTITY_INSERT [dbo].[ProjectMaster] OFF
GO
SET IDENTITY_INSERT [dbo].[SupplierMaster] ON 

GO
INSERT [dbo].[SupplierMaster] ([SupplierId], [ClientId], [Type], [SupplierName], [SupplierAddress], [ContactPerson], [ContactNo], [EmailId], [Modfied_Date], [Status]) VALUES (1, 5, N'Supplier', N'Steel Exports', NULL, NULL, NULL, NULL, CAST(N'2018-07-22 09:47:59.100' AS DateTime), 1)
GO
INSERT [dbo].[SupplierMaster] ([SupplierId], [ClientId], [Type], [SupplierName], [SupplierAddress], [ContactPerson], [ContactNo], [EmailId], [Modfied_Date], [Status]) VALUES (2, 6, N'Supplier', N'New Supplier', NULL, NULL, NULL, NULL, CAST(N'2018-07-29 14:19:29.500' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[SupplierMaster] OFF
GO
SET IDENTITY_INSERT [dbo].[UserDetails] ON 

GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (1, 1, NULL, N'0001', N'admin', N'admin', 1, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (2, 1, 1, N'1001', N'sha', N'sha', 2, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime), NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (3, 1, 1, N'1001', N'sa', N'sa', 2, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime), NULL, NULL, NULL, CAST(N'2018-07-07 19:03:42.747' AS DateTime), 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (4, 1, 1, N'1001', N'sa1', N'sa1', 2, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime), NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (5, 1, 1, N'1001', N'sa2', N'sa2', 2, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime), NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (6, 1, NULL, N'0000', N'demo', N'demo', 8, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (7, 1, 1, N'1001', N'must', N'must', 5, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime), NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (8, 1, 5, N'1002', N'new', N'new', 2, NULL, CAST(N'2019-02-27 18:30:00.000' AS DateTime), NULL, NULL, NULL, NULL, 1, N'a', N'a', NULL, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (10, 1, 6, N'1003', N'demo', N'demo', 2, NULL, CAST(N'2019-06-29 18:30:00.000' AS DateTime), NULL, NULL, NULL, NULL, 1, N'demo', NULL, NULL, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (11, 1, 1, N'1001', N'sha', N'XEGN178', 2, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime), NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (12, 1, 6, N'1003', N'sup1', N'sup1', 7, NULL, CAST(N'2019-06-29 18:30:00.000' AS DateTime), NULL, NULL, NULL, CAST(N'2018-07-29 14:48:32.423' AS DateTime), 1, N'Supplier', NULL, 1, 2)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (13, 1, 6, N'1003', N'demo', N'XEGN178', 2, NULL, CAST(N'2019-06-29 18:30:00.000' AS DateTime), NULL, NULL, NULL, NULL, 1, N'demo', NULL, NULL, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (14, 1, 7, N'1004', N'asn', N'asn', 2, NULL, CAST(N'2019-08-30 18:30:00.000' AS DateTime), NULL, NULL, NULL, CAST(N'2018-08-17 00:12:16.923' AS DateTime), 1, N'ASN', NULL, 0, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (15, 1, 5, N'1002', N'new1', N'new1', 2, NULL, CAST(N'2019-02-27 18:30:00.000' AS DateTime), NULL, NULL, NULL, NULL, 1, NULL, NULL, 0, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (16, 1, 8, N'1005', N'ino', N'ino', 2, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime), NULL, NULL, NULL, NULL, 1, NULL, NULL, 0, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (17, 1, 9, N'1006', N'ss', N'ss', 2, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime), NULL, NULL, NULL, NULL, 1, N'SS', NULL, 0, NULL)
GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status], [Loginuser], [Designation], [Type], [SupplierId]) VALUES (18, 1, 10, N'1007', N'bb', N'bb', 2, NULL, CAST(N'2019-04-29 18:30:00.000' AS DateTime), NULL, NULL, NULL, NULL, 1, N'bb', NULL, 0, NULL)
GO
SET IDENTITY_INSERT [dbo].[UserDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[UserPassReset] ON 

GO
INSERT [dbo].[UserPassReset] ([UserRestId], [UserId], [Password], [Up_Date]) VALUES (1, 2, N'sha', CAST(N'2018-07-29 01:25:02.713' AS DateTime))
GO
INSERT [dbo].[UserPassReset] ([UserRestId], [UserId], [Password], [Up_Date]) VALUES (2, 10, N'demo', CAST(N'2018-07-29 15:08:05.600' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[UserPassReset] OFF
GO
SET IDENTITY_INSERT [dbo].[UserRole] ON 

GO
INSERT [dbo].[UserRole] ([User_RoleId], [Role_Name], [Status]) VALUES (1, N'Admin', 1)
GO
INSERT [dbo].[UserRole] ([User_RoleId], [Role_Name], [Status]) VALUES (2, N'Company', 1)
GO
INSERT [dbo].[UserRole] ([User_RoleId], [Role_Name], [Status]) VALUES (3, N'Super User', 1)
GO
INSERT [dbo].[UserRole] ([User_RoleId], [Role_Name], [Status]) VALUES (4, N'User', 1)
GO
INSERT [dbo].[UserRole] ([User_RoleId], [Role_Name], [Status]) VALUES (5, N'Reporting User', 1)
GO
INSERT [dbo].[UserRole] ([User_RoleId], [Role_Name], [Status]) VALUES (6, N'External User', 1)
GO
INSERT [dbo].[UserRole] ([User_RoleId], [Role_Name], [Status]) VALUES (7, N'Other User', 1)
GO
INSERT [dbo].[UserRole] ([User_RoleId], [Role_Name], [Status]) VALUES (8, N'Register', 1)
GO
SET IDENTITY_INSERT [dbo].[UserRole] OFF
GO
SET IDENTITY_INSERT [dbo].[UserRoleMenu] ON 

GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (1, 1, 1, 2, 1, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (2, 1, 1, 2, 2, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (3, 1, 1, 2, 5, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (4, 1, 1, 2, 6, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (5, 1, 1, 2, 7, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (6, 1, 1, 2, 11, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (7, 1, 1, 2, 12, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (8, 1, 1, 2, 10, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (9, 1, 1, 2, 13, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (10, 1, 1, 2, 14, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (11, 1, 1, 2, 15, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (12, 1, 1, 2, 16, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (13, 1, 1, 2, 17, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (14, 1, 1, 2, 9, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (16, 1, 1, 2, 18, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (17, 1, 1, 2, 19, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (33, 1, 1, 4, 7, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (34, 1, 1, 4, 10, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (35, 1, 1, 4, 1, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (36, 1, 1, 4, 2, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (38, 1, 1, 5, 15, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (56, 1, 1, 2, 20, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (60, 1, 6, 2, 1, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (61, 1, 6, 2, 2, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (62, 1, 6, 2, 5, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (63, 1, 6, 2, 6, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (64, 1, 6, 2, 7, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (65, 1, 6, 2, 9, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (66, 1, 6, 2, 10, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (67, 1, 6, 2, 11, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (68, 1, 6, 2, 12, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (69, 1, 6, 2, 13, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (70, 1, 6, 2, 14, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (71, 1, 6, 2, 15, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (72, 1, 6, 2, 16, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (73, 1, 6, 2, 17, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (74, 1, 6, 2, 18, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (75, 1, 6, 2, 19, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (76, 1, 6, 2, 20, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (78, 1, 1, 2, 21, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (79, 1, 6, 2, 21, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (80, 1, 7, 2, 1, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (81, 1, 7, 2, 2, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (82, 1, 7, 2, 5, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (83, 1, 7, 2, 6, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (84, 1, 7, 2, 7, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (85, 1, 7, 2, 9, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (86, 1, 7, 2, 10, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (87, 1, 7, 2, 11, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (88, 1, 7, 2, 12, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (89, 1, 7, 2, 13, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (90, 1, 7, 2, 14, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (91, 1, 7, 2, 15, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (92, 1, 7, 2, 16, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (93, 1, 7, 2, 17, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (94, 1, 7, 2, 18, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (95, 1, 7, 2, 19, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (96, 1, 7, 2, 20, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (97, 1, 7, 2, 21, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (98, 1, 5, 2, 1, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (99, 1, 5, 2, 2, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (100, 1, 5, 2, 5, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (101, 1, 5, 2, 6, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (102, 1, 5, 2, 7, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (103, 1, 5, 2, 9, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (104, 1, 5, 2, 10, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (105, 1, 5, 2, 11, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (106, 1, 5, 2, 12, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (107, 1, 5, 2, 13, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (108, 1, 5, 2, 14, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (109, 1, 5, 2, 15, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (110, 1, 5, 2, 16, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (111, 1, 5, 2, 17, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (112, 1, 5, 2, 18, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (113, 1, 5, 2, 19, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (114, 1, 5, 2, 20, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (115, 1, 5, 2, 21, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (116, 1, 8, 2, 1, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (117, 1, 8, 2, 2, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (118, 1, 8, 2, 5, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (119, 1, 8, 2, 6, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (120, 1, 8, 2, 7, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (121, 1, 8, 2, 9, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (122, 1, 8, 2, 10, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (123, 1, 8, 2, 11, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (124, 1, 8, 2, 12, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (125, 1, 8, 2, 13, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (126, 1, 8, 2, 14, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (127, 1, 8, 2, 15, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (128, 1, 8, 2, 16, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (129, 1, 8, 2, 17, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (130, 1, 8, 2, 18, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (131, 1, 8, 2, 19, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (132, 1, 8, 2, 20, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (133, 1, 8, 2, 21, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (134, 1, 9, 2, 1, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (135, 1, 9, 2, 2, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (136, 1, 9, 2, 5, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (137, 1, 9, 2, 6, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (138, 1, 9, 2, 7, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (139, 1, 9, 2, 9, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (140, 1, 9, 2, 10, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (141, 1, 9, 2, 11, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (142, 1, 9, 2, 12, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (143, 1, 9, 2, 13, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (144, 1, 9, 2, 14, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (145, 1, 9, 2, 15, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (146, 1, 9, 2, 16, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (147, 1, 9, 2, 17, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (148, 1, 9, 2, 18, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (149, 1, 9, 2, 19, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (150, 1, 9, 2, 20, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (151, 1, 9, 2, 21, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (152, 1, 9, 2, 22, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (153, 1, 8, 2, 22, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (154, 1, 9, 2, 23, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (155, 1, 8, 2, 23, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (156, 1, 9, 4, 1, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (157, 1, 9, 4, 2, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (158, 1, 9, 4, 15, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (159, 1, 9, 4, 16, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (160, 1, 10, 2, 1, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (161, 1, 10, 2, 2, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (162, 1, 10, 2, 5, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (163, 1, 10, 2, 6, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (164, 1, 10, 2, 7, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (165, 1, 10, 2, 9, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (166, 1, 10, 2, 10, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (167, 1, 10, 2, 11, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (168, 1, 10, 2, 12, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (169, 1, 10, 2, 13, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (170, 1, 10, 2, 14, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (171, 1, 10, 2, 15, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (172, 1, 10, 2, 16, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (173, 1, 10, 2, 17, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (174, 1, 10, 2, 18, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (175, 1, 10, 2, 19, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (176, 1, 10, 2, 20, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (177, 1, 10, 2, 21, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (178, 1, 10, 2, 22, 1)
GO
INSERT [dbo].[UserRoleMenu] ([UID], [CompanyId], [ClientId], [User_RoleId], [MID], [Status]) VALUES (179, 1, 10, 2, 23, 1)
GO
SET IDENTITY_INSERT [dbo].[UserRoleMenu] OFF
GO
SET IDENTITY_INSERT [dbo].[UserValidity] ON 

GO
INSERT [dbo].[UserValidity] ([ValidityId], [UserId], [ClientId], [MaintanceDate], [ExprieDate]) VALUES (1, 2, 1, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime))
GO
INSERT [dbo].[UserValidity] ([ValidityId], [UserId], [ClientId], [MaintanceDate], [ExprieDate]) VALUES (2, 3, 1, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime))
GO
INSERT [dbo].[UserValidity] ([ValidityId], [UserId], [ClientId], [MaintanceDate], [ExprieDate]) VALUES (3, 4, 1, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime))
GO
INSERT [dbo].[UserValidity] ([ValidityId], [UserId], [ClientId], [MaintanceDate], [ExprieDate]) VALUES (4, 5, 1, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime))
GO
INSERT [dbo].[UserValidity] ([ValidityId], [UserId], [ClientId], [MaintanceDate], [ExprieDate]) VALUES (5, 7, 1, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime))
GO
INSERT [dbo].[UserValidity] ([ValidityId], [UserId], [ClientId], [MaintanceDate], [ExprieDate]) VALUES (6, 8, 5, NULL, CAST(N'2019-02-27 18:30:00.000' AS DateTime))
GO
INSERT [dbo].[UserValidity] ([ValidityId], [UserId], [ClientId], [MaintanceDate], [ExprieDate]) VALUES (7, 9, 6, NULL, CAST(N'2019-06-29 18:30:00.000' AS DateTime))
GO
INSERT [dbo].[UserValidity] ([ValidityId], [UserId], [ClientId], [MaintanceDate], [ExprieDate]) VALUES (8, 10, 6, NULL, CAST(N'2019-06-29 18:30:00.000' AS DateTime))
GO
INSERT [dbo].[UserValidity] ([ValidityId], [UserId], [ClientId], [MaintanceDate], [ExprieDate]) VALUES (9, 12, 6, NULL, CAST(N'2019-06-29 18:30:00.000' AS DateTime))
GO
INSERT [dbo].[UserValidity] ([ValidityId], [UserId], [ClientId], [MaintanceDate], [ExprieDate]) VALUES (10, 14, 7, NULL, CAST(N'2019-08-30 18:30:00.000' AS DateTime))
GO
INSERT [dbo].[UserValidity] ([ValidityId], [UserId], [ClientId], [MaintanceDate], [ExprieDate]) VALUES (11, 15, 5, NULL, CAST(N'2019-02-27 18:30:00.000' AS DateTime))
GO
INSERT [dbo].[UserValidity] ([ValidityId], [UserId], [ClientId], [MaintanceDate], [ExprieDate]) VALUES (12, 16, 8, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime))
GO
INSERT [dbo].[UserValidity] ([ValidityId], [UserId], [ClientId], [MaintanceDate], [ExprieDate]) VALUES (13, 17, 9, NULL, CAST(N'2019-12-30 18:30:00.000' AS DateTime))
GO
INSERT [dbo].[UserValidity] ([ValidityId], [UserId], [ClientId], [MaintanceDate], [ExprieDate]) VALUES (14, 18, 10, NULL, CAST(N'2019-04-29 18:30:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[UserValidity] OFF
GO
SET IDENTITY_INSERT [dbo].[VariationMaster] ON 

GO
INSERT [dbo].[VariationMaster] ([VID], [ProjectId], [ClientId], [VariationName], [Status]) VALUES (1, 1, 1, N'ARCHITECT INSTRUCTIONS (AI)', 1)
GO
INSERT [dbo].[VariationMaster] ([VID], [ProjectId], [ClientId], [VariationName], [Status]) VALUES (2, 1, 1, N'STRUCTURAL ENGINEER''S INSTRUCTION (EI-STR)', 1)
GO
INSERT [dbo].[VariationMaster] ([VID], [ProjectId], [ClientId], [VariationName], [Status]) VALUES (3, 1, 1, N'M&E ENGINEER''S INSTRUCTION (EI-M&E)', 1)
GO
SET IDENTITY_INSERT [dbo].[VariationMaster] OFF
GO
ALTER TABLE [dbo].[BlockDetails]  WITH CHECK ADD  CONSTRAINT [FK_BlockDetails_ProjectMaster] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[ProjectMaster] ([ProjectId])
GO
ALTER TABLE [dbo].[BlockDetails] CHECK CONSTRAINT [FK_BlockDetails_ProjectMaster]
GO
ALTER TABLE [dbo].[Client]  WITH CHECK ADD  CONSTRAINT [FK_Client_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_Client_Company]
GO
ALTER TABLE [dbo].[Client]  WITH CHECK ADD  CONSTRAINT [FK_Client_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_Client_Country]
GO
ALTER TABLE [dbo].[DatabaseDetails]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseDetails_Client] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[DatabaseDetails] CHECK CONSTRAINT [FK_DatabaseDetails_Client]
GO
ALTER TABLE [dbo].[DatabaseDetails]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseDetails_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[DatabaseDetails] CHECK CONSTRAINT [FK_DatabaseDetails_Company]
GO
ALTER TABLE [dbo].[ExternalWorkDetails]  WITH CHECK ADD  CONSTRAINT [FK_ExternalWorkDetails_ProjectMaster] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[ProjectMaster] ([ProjectId])
GO
ALTER TABLE [dbo].[ExternalWorkDetails] CHECK CONSTRAINT [FK_ExternalWorkDetails_ProjectMaster]
GO
ALTER TABLE [dbo].[FoundationDetails]  WITH CHECK ADD  CONSTRAINT [FK_FoundationDetails_ProjectMaster] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[ProjectMaster] ([ProjectId])
GO
ALTER TABLE [dbo].[FoundationDetails] CHECK CONSTRAINT [FK_FoundationDetails_ProjectMaster]
GO
ALTER TABLE [dbo].[HolidayMaster]  WITH CHECK ADD  CONSTRAINT [FK_HolidayMaster_Client] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[HolidayMaster] CHECK CONSTRAINT [FK_HolidayMaster_Client]
GO
ALTER TABLE [dbo].[MainItemMaster]  WITH CHECK ADD  CONSTRAINT [FK_MainItemMaster_ProjectMaster] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[ProjectMaster] ([ProjectId])
GO
ALTER TABLE [dbo].[MainItemMaster] CHECK CONSTRAINT [FK_MainItemMaster_ProjectMaster]
GO
ALTER TABLE [dbo].[ProjectDescription]  WITH CHECK ADD  CONSTRAINT [FK_ProjectDescription_ProjectMaster] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[ProjectMaster] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectDescription] CHECK CONSTRAINT [FK_ProjectDescription_ProjectMaster]
GO
ALTER TABLE [dbo].[ProjectMaster]  WITH CHECK ADD  CONSTRAINT [FK_ProjectMaster_ClientMaster] FOREIGN KEY([ClientId])
REFERENCES [dbo].[ClientMaster] ([ClientId])
GO
ALTER TABLE [dbo].[ProjectMaster] CHECK CONSTRAINT [FK_ProjectMaster_ClientMaster]
GO
ALTER TABLE [dbo].[SubSubItemMaster]  WITH CHECK ADD  CONSTRAINT [FK_SubSubItemMaster_SubItemMaster] FOREIGN KEY([SubItemId])
REFERENCES [dbo].[SubItemMaster] ([SubItemId])
GO
ALTER TABLE [dbo].[SubSubItemMaster] CHECK CONSTRAINT [FK_SubSubItemMaster_SubItemMaster]
GO
ALTER TABLE [dbo].[SubSubItemMaster]  WITH CHECK ADD  CONSTRAINT [FK_SubSubItemMaster_SubSubItemMaster] FOREIGN KEY([SubSubItemId])
REFERENCES [dbo].[SubSubItemMaster] ([SubSubItemId])
GO
ALTER TABLE [dbo].[SubSubItemMaster] CHECK CONSTRAINT [FK_SubSubItemMaster_SubSubItemMaster]
GO
ALTER TABLE [dbo].[SupplierMaster]  WITH CHECK ADD  CONSTRAINT [FK_SupplierMaster_Client] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[SupplierMaster] CHECK CONSTRAINT [FK_SupplierMaster_Client]
GO
ALTER TABLE [dbo].[UserDetails]  WITH CHECK ADD  CONSTRAINT [FK_User_Client] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[UserDetails] CHECK CONSTRAINT [FK_User_Client]
GO
ALTER TABLE [dbo].[UserDetails]  WITH CHECK ADD  CONSTRAINT [FK_User_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[UserDetails] CHECK CONSTRAINT [FK_User_Company]
GO
ALTER TABLE [dbo].[UserDetails]  WITH CHECK ADD  CONSTRAINT [FK_User_UserRole] FOREIGN KEY([User_Role_Id])
REFERENCES [dbo].[UserRole] ([User_RoleId])
GO
ALTER TABLE [dbo].[UserDetails] CHECK CONSTRAINT [FK_User_UserRole]
GO
ALTER TABLE [dbo].[UserRoleMenu]  WITH CHECK ADD  CONSTRAINT [FK_UserRoleMenu_Client] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[UserRoleMenu] CHECK CONSTRAINT [FK_UserRoleMenu_Client]
GO
ALTER TABLE [dbo].[UserRoleMenu]  WITH CHECK ADD  CONSTRAINT [FK_UserRoleMenu_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[UserRoleMenu] CHECK CONSTRAINT [FK_UserRoleMenu_Company]
GO
ALTER TABLE [dbo].[UserRoleMenu]  WITH CHECK ADD  CONSTRAINT [FK_UserRoleMenu_MenuDetails] FOREIGN KEY([MID])
REFERENCES [dbo].[MenuDetails] ([MID])
GO
ALTER TABLE [dbo].[UserRoleMenu] CHECK CONSTRAINT [FK_UserRoleMenu_MenuDetails]
GO
ALTER TABLE [dbo].[UserRoleMenu]  WITH CHECK ADD  CONSTRAINT [FK_UserRoleMenu_UserRole] FOREIGN KEY([User_RoleId])
REFERENCES [dbo].[UserRole] ([User_RoleId])
GO
ALTER TABLE [dbo].[UserRoleMenu] CHECK CONSTRAINT [FK_UserRoleMenu_UserRole]
GO
