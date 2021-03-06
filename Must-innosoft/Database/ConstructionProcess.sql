USE [ConstructionProcess]
GO
/****** Object:  StoredProcedure [dbo].[CreateCopyDatabaseprocedures]    Script Date: 1/26/2019 11:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateCopyDatabaseprocedures]
	-- parameters for the stored procedure here
	@Name VARCHAR(100)
	as
	begin
--select * into  Testingdb1.dbo.Company from Test4.dbo.Company
declare @sql  nvarchar(max)
--declare @Name  nvarchar(max)='Testingdb1'
DECLARE c CURSOR FOR 
   SELECT Definition
   FROM [ConstructionProcess].[sys].[procedures] p
   INNER JOIN [ConstructionProcess].sys.sql_modules m ON p.object_id = m.object_id

OPEN c

FETCH NEXT FROM c INTO @sql

WHILE @@FETCH_STATUS = 0 
BEGIN
   SET @sql = REPLACE(@sql,'''','''''')
   SET @sql = 'USE [' + @Name + ']; EXEC(''' + @sql + ''')'

   EXEC(@sql)

   FETCH NEXT FROM c INTO @sql
END             

CLOSE c
DEALLOCATE c
end

GO
/****** Object:  StoredProcedure [dbo].[CreateCopyDatabaseTable]    Script Date: 1/26/2019 11:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[CreateCopyDatabaseTable]
	-- parameters for the stored procedure here
	@toDatabase VARCHAR(100)
	
AS
BEGIN
exec('CREATE DATABASE ' + @toDatabase) 
declare @fromDatabase VARCHAR(100)='ConstructionProcess'
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
 
	DECLARE @fullTableList VARCHAR(8000);
	DECLARE @idx INT;
	DECLARE @tableName VARCHAR(8000);
	DECLARE @SQLQuery NVARCHAR(500);
	DECLARE @ParameterDefinition NVARCHAR(100);
 
	-- this  query gives the list of table name existing in the database.
	SELECT @fullTableList = ISNULL(@fullTableList + ',' + TABLE_NAME, TABLE_NAME)
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_TYPE = 'BASE TABLE';
 --select @fullTableList
	SELECT @idx = 1
 
	/* this section splits the table name from comma separated string and copies that table name from  
		one database to another database*/
	IF LEN(@fullTableList) > 1
		OR @fullTableList IS NOT NULL
		WHILE @idx != 0
		BEGIN
			SET @idx = CHARINDEX(',', @fullTableList)
 
			IF @idx != 0
				SET @tableName = LEFT(@fullTableList, @idx - 1)
			ELSE
				SET @tableName = @fullTableList
 
			IF (LEN(@tableName) > 0)
				SET @SQLQuery = 'SELECT  * INTO [' + @toDatabase + '].[dbo].[' + @tableName + '] FROM [' + @fromDatabase + '].[dbo].[' + @tableName + ']'
 
			EXEC (@SQLQuery)
 
			SET @fullTableList = RIGHT(@fullTableList, LEN(@fullTableList) - @idx)
 
			IF LEN(@fullTableList) = 0
				BREAK
		END
		
		
		
END

GO
/****** Object:  StoredProcedure [dbo].[CreateCopyDatabaseuser]    Script Date: 1/26/2019 11:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateCopyDatabaseuser]
@toDatabase VARCHAR(100)
as
begin
--declare @toDatabase VARCHAR(100)='Testingdb1'

	if not exists (select * from dbo.sysusers where name = N'con' and uid < 16382)
		EXEC sp_grantdbaccess N'con', N'con'
	
	exec sp_addrolemember N'db_owner', N'con'
	
	alter USER [con]  WITH DEFAULT_SCHEMA=[dbo]
	
	end

GO
/****** Object:  StoredProcedure [dbo].[CreateCopyDatabaseView]    Script Date: 1/26/2019 11:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateCopyDatabaseView]
	-- parameters for the stored procedure here
	@Name VARCHAR(100)
	as
	begin
--select * into  Testingdb1.dbo.Company from Test4.dbo.Company
declare @sql  nvarchar(max)
--declare @Name  nvarchar(max)='Testingdb1'
DECLARE c CURSOR FOR 
   SELECT Definition
   FROM [ConstructionProcess].[sys].[views] p
   INNER JOIN [ConstructionProcess].sys.sql_modules m ON p.object_id = m.object_id

OPEN c

FETCH NEXT FROM c INTO @sql

WHILE @@FETCH_STATUS = 0 
BEGIN
   SET @sql = REPLACE(@sql,'''','''''')
   SET @sql = 'USE [' + @Name + ']; EXEC(''' + @sql + ''')'

   EXEC(@sql)

   FETCH NEXT FROM c INTO @sql
END             

CLOSE c
DEALLOCATE c
end

GO
/****** Object:  Table [dbo].[BlockDetails]    Script Date: 1/26/2019 11:13:01 AM ******/
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
/****** Object:  Table [dbo].[ClientMaster]    Script Date: 1/26/2019 11:13:01 AM ******/
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
/****** Object:  Table [dbo].[ExternalWorkDetails]    Script Date: 1/26/2019 11:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ExternalWorkDetails](
	[ExDetId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProjectId] [bigint] NOT NULL,
	[ExId] [bigint] NOT NULL,
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
/****** Object:  Table [dbo].[ExternalWorkMaster]    Script Date: 1/26/2019 11:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExternalWorkMaster](
	[ExId] [bigint] IDENTITY(1,1) NOT NULL,
	[ExternalWork] [nvarchar](150) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_ExternalWork] PRIMARY KEY CLUSTERED 
(
	[ExId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FoundationDetails]    Script Date: 1/26/2019 11:13:01 AM ******/
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
/****** Object:  Table [dbo].[LocationMaster]    Script Date: 1/26/2019 11:13:01 AM ******/
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
/****** Object:  Table [dbo].[MainItemMaster]    Script Date: 1/26/2019 11:13:01 AM ******/
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
/****** Object:  Table [dbo].[ProjectDescription]    Script Date: 1/26/2019 11:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectDescription](
	[PDId] [bigint] NOT NULL,
	[ProjectId] [bigint] NOT NULL,
	[Foundation] [int] NULL,
	[Basement] [int] NULL,
	[Podium] [int] NULL,
	[Mezanine] [int] NULL,
	[CreateDate] [datetime] NULL,
	[UserId] [int] NULL,
 CONSTRAINT [PK_ProjectDescription] PRIMARY KEY CLUSTERED 
(
	[PDId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectMaster]    Script Date: 1/26/2019 11:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectMaster](
	[ProjectId] [bigint] NOT NULL,
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
 CONSTRAINT [PK_ProjectMaster] PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubItemMaster]    Script Date: 1/26/2019 11:13:01 AM ******/
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
/****** Object:  Table [dbo].[SubSubItemMaster]    Script Date: 1/26/2019 11:13:01 AM ******/
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
SET IDENTITY_INSERT [dbo].[ExternalWorkMaster] ON 

GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (1, N'SEWER MANHOLES', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (2, N'TELECOM MANHOLES', 1)
GO
INSERT [dbo].[ExternalWorkMaster] ([ExId], [ExternalWork], [Status]) VALUES (3, N'MANHOLES', 1)
GO
SET IDENTITY_INSERT [dbo].[ExternalWorkMaster] OFF
GO
ALTER TABLE [dbo].[BlockDetails]  WITH CHECK ADD  CONSTRAINT [FK_BlockDetails_ProjectMaster] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[ProjectMaster] ([ProjectId])
GO
ALTER TABLE [dbo].[BlockDetails] CHECK CONSTRAINT [FK_BlockDetails_ProjectMaster]
GO
ALTER TABLE [dbo].[ExternalWorkDetails]  WITH CHECK ADD  CONSTRAINT [FK_ExternalWorkDetails_ExternalWorkMaster] FOREIGN KEY([ExId])
REFERENCES [dbo].[ExternalWorkMaster] ([ExId])
GO
ALTER TABLE [dbo].[ExternalWorkDetails] CHECK CONSTRAINT [FK_ExternalWorkDetails_ExternalWorkMaster]
GO
ALTER TABLE [dbo].[ExternalWorkDetails]  WITH CHECK ADD  CONSTRAINT [FK_ExternalWorkDetails_ProjectMaster] FOREIGN KEY([ExId])
REFERENCES [dbo].[ExternalWorkMaster] ([ExId])
GO
ALTER TABLE [dbo].[ExternalWorkDetails] CHECK CONSTRAINT [FK_ExternalWorkDetails_ProjectMaster]
GO
ALTER TABLE [dbo].[FoundationDetails]  WITH CHECK ADD  CONSTRAINT [FK_FoundationDetails_ProjectMaster] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[ProjectMaster] ([ProjectId])
GO
ALTER TABLE [dbo].[FoundationDetails] CHECK CONSTRAINT [FK_FoundationDetails_ProjectMaster]
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
