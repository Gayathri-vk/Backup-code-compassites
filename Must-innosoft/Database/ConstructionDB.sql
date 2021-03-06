USE [ConstructionDB]
GO
/****** Object:  StoredProcedure [dbo].[CreateCopyDatabaseprocedures]    Script Date: 1/26/2019 11:11:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[CreateCopyDatabaseTable]    Script Date: 1/26/2019 11:11:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateCopyDatabaseTable]
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
/****** Object:  StoredProcedure [dbo].[CreateCopyDatabaseuser]    Script Date: 1/26/2019 11:11:11 AM ******/
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
/****** Object:  StoredProcedure [dbo].[CreateCopyDatabaseView]    Script Date: 1/26/2019 11:11:11 AM ******/
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
/****** Object:  Table [dbo].[Client]    Script Date: 1/26/2019 11:11:11 AM ******/
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
/****** Object:  Table [dbo].[Company]    Script Date: 1/26/2019 11:11:11 AM ******/
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
/****** Object:  Table [dbo].[Country]    Script Date: 1/26/2019 11:11:11 AM ******/
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
/****** Object:  Table [dbo].[DatabaseDetails]    Script Date: 1/26/2019 11:11:11 AM ******/
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
/****** Object:  Table [dbo].[MenuDetails]    Script Date: 1/26/2019 11:11:11 AM ******/
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
/****** Object:  Table [dbo].[UserDetails]    Script Date: 1/26/2019 11:11:11 AM ******/
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
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 1/26/2019 11:11:11 AM ******/
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
/****** Object:  Table [dbo].[UserRoleMenu]    Script Date: 1/26/2019 11:11:11 AM ******/
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
/****** Object:  Table [dbo].[UserValidity]    Script Date: 1/26/2019 11:11:11 AM ******/
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
SET IDENTITY_INSERT [dbo].[Company] ON 

GO
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [UintNo], [Building], [Street], [City], [State], [StateCode], [Pincode], [Country], [TaxNo], [GSTNo], [AuthorisedPerson], [HandPhoneNo], [TelePhoneNo], [EmailId], [Website]) VALUES (1, N'New Solution', NULL, N'New Building', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Company] OFF
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
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (8, N'Location', N'process/location', 7, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (9, N'Menu', N'master/usermenu', 1, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (10, N'Project', N'process/project', 7, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (11, N'Project Description', N'process/projectdescription', 7, 1)
GO
INSERT [dbo].[MenuDetails] ([MID], [Formname], [RouteName], [ParentId], [Status]) VALUES (12, N'Bill of Quantities', N'process/boqdetails', 7, 1)
GO
SET IDENTITY_INSERT [dbo].[MenuDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[UserDetails] ON 

GO
INSERT [dbo].[UserDetails] ([UserId], [CompanyId], [ClientId], [ClientCode], [Username], [Password], [User_Role_Id], [MaintanceDate], [ExprieDate], [Created_by], [CreateDate], [Modified_by], [Modfied_Date], [Status]) VALUES (1, 1, NULL, N'0001', N'admin', N'admin', 1, NULL, NULL, NULL, NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[UserDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[UserRole] ON 

GO
INSERT [dbo].[UserRole] ([User_RoleId], [Role_Name], [Status]) VALUES (1, N'Admin', 1)
GO
INSERT [dbo].[UserRole] ([User_RoleId], [Role_Name], [Status]) VALUES (2, N'Company', 1)
GO
SET IDENTITY_INSERT [dbo].[UserRole] OFF
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
