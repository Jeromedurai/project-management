-- liquibase formatted sql 

-- changeset Ashwin:3 
-- comment PET-504 | SA - Database - SQL Server to Aurora Migration - Reports

IF NOT EXISTS (
			SELECT 1 from INFORMATION_SCHEMA.TABLE_CONSTRAINTS   with(nolock)
			WHERE Table_schema = 'dbo'
			and Table_name = 'XC_SALES_GROUP'
			and Constraint_Name = 'PK_IX_XC_SALES_GROUP_PK'
			and CONSTRAINT_TYPE = 'PRIMARY KEY'
		)
BEGIN

	IF EXISTS (Select * From sys.Indexes with(nolock) Where Object_id = Object_ID(N'[dbo].[XC_SALES_GROUP]') and Name = 'PK_IX_XC_SALES_GROUP_PK')
	DROP INDEX [PK_IX_XC_SALES_GROUP_PK] ON [dbo].[XC_SALES_GROUP]
	
	IF NOT EXISTS (
				SELECT 1 from INFORMATION_SCHEMA.TABLE_CONSTRAINTS   with(nolock)
				WHERE Table_schema = 'dbo'
				and Table_name = 'XC_SALES_GROUP'
				and Constraint_Name = 'PK_IX_XC_SALES_GROUP_PK'
				and CONSTRAINT_TYPE = 'PRIMARY KEY'
			)
	BEGIN
		ALTER TABLE [dbo].[XC_SALES_GROUP]
		ADD CONSTRAINT [PK_IX_XC_SALES_GROUP_PK] PRIMARY KEY CLUSTERED (Pk) ON [XC_TransactionFG] 
	END
END
GO

IF NOT EXISTS (
			SELECT 1 from INFORMATION_SCHEMA.TABLE_CONSTRAINTS   with(nolock)
			WHERE Table_schema = 'dbo'
			and Table_name = 'XC_PARTNER_TENANT_STAGING'
			and Constraint_Name = 'PK_IX_XC_PARTNER_TENANT_STAGING_PK'
			and CONSTRAINT_TYPE = 'PRIMARY KEY'
		)
BEGIN

	IF EXISTS (Select * From sys.Indexes with(nolock) Where Object_id = Object_ID(N'[dbo].[XC_PARTNER_TENANT_STAGING]') and Name = 'PK_IX_XC_PARTNER_TENANT_STAGING_PK')
	DROP INDEX [PK_IX_XC_PARTNER_TENANT_STAGING_PK] ON [dbo].[XC_PARTNER_TENANT_STAGING]
	
	IF NOT EXISTS (
				SELECT 1 from INFORMATION_SCHEMA.TABLE_CONSTRAINTS   with(nolock)
				WHERE Table_schema = 'dbo'
				and Table_name = 'XC_PARTNER_TENANT_STAGING'
				and Constraint_Name = 'PK_IX_XC_PARTNER_TENANT_STAGING_PK'
				and CONSTRAINT_TYPE = 'PRIMARY KEY'
			)
	BEGIN
		ALTER TABLE [dbo].[XC_PARTNER_TENANT_STAGING]
		ADD CONSTRAINT [PK_IX_XC_PARTNER_TENANT_STAGING_PK] PRIMARY KEY CLUSTERED (Pk) ON [XC_TransactionFG] 
	END
END
GO

IF NOT EXISTS (
			SELECT 1 from INFORMATION_SCHEMA.TABLE_CONSTRAINTS   with(nolock)
			WHERE Table_schema = 'dbo'
			and Table_name = 'XC_PARTNER_LOCATION_STAGING'
			and Constraint_Name = 'PK_IX_XC_PARTNER_LOCATION_STAGING_PK'
			and CONSTRAINT_TYPE = 'PRIMARY KEY'
		)
BEGIN

	IF EXISTS (Select * From sys.Indexes with(nolock) Where Object_id = Object_ID(N'[dbo].[XC_PARTNER_LOCATION_STAGING]') and Name = 'PK_IX_XC_PARTNER_LOCATION_STAGING_PK')
	DROP INDEX [PK_IX_XC_PARTNER_LOCATION_STAGING_PK] ON [dbo].[XC_PARTNER_LOCATION_STAGING]
	
	IF NOT EXISTS (
				SELECT 1 from INFORMATION_SCHEMA.TABLE_CONSTRAINTS   with(nolock)
				WHERE Table_schema = 'dbo'
				and Table_name = 'XC_PARTNER_LOCATION_STAGING'
				and Constraint_Name = 'PK_IX_XC_PARTNER_LOCATION_STAGING_PK'
				and CONSTRAINT_TYPE = 'PRIMARY KEY'
			)
	BEGIN
		ALTER TABLE [dbo].[XC_PARTNER_LOCATION_STAGING]
		ADD CONSTRAINT [PK_IX_XC_PARTNER_LOCATION_STAGING_PK] PRIMARY KEY CLUSTERED (Pk) ON [XC_TransactionFG] 
	END
END
GO

-- changeset Kokulan: 18 
-- comment RIO-985 | Alter table script for JSON column length max 
IF EXISTS (
	SELECT 1 FROM information_schema.columns
	WHERE table_schema = 'dbo'
	AND table_name = 'xc_inventory_area'
	AND column_name = 'json'
	AND DATA_TYPE = 'varchar'
	AND CHARACTER_MAXIMUM_LENGTH = 1000
)
BEGIN
    ALTER TABLE [dbo].[XC_INVENTORY_AREA]
    ALTER COLUMN [Json] VARCHAR(MAX)
END
GO

--changeset ranjith :16
--comment - SAMX-358 | Add new column in XC_TENANT_CUSTCATEGORIES

IF NOT EXISTS (
		SELECT 1
		FROM sys.columns
		WHERE NAME = N'SYSTEM_CATEGORY_CODE'
			AND OBJECT_ID = OBJECT_ID(N'dbo.XC_TENANT_CUSTCATEGORIES')
		)
BEGIN
	ALTER TABLE [DBO].[XC_TENANT_CUSTCATEGORIES] ADD SYSTEM_CATEGORY_CODE VARCHAR(25) NULL
END
GO

-- changeset Dinesh R: 22
-- comment UXT-1203 | Added new columns 

IF NOT EXISTS (
		SELECT 1
		FROM SYS.COLUMNS
		WHERE [NAME] = (N'Display_Name')
			AND Object_ID = Object_ID(N'[dbo].[XC_INVOICE_STATUSMASTER]')
		)
BEGIN
ALTER TABLE DBO.XC_INVOICE_STATUSMASTER ADD Display_Name VARCHAR(100) NULL
END 
GO

IF NOT EXISTS (
		SELECT 1
		FROM SYS.COLUMNS
		WHERE [NAME] = (N'Display_Name')
			AND Object_ID = Object_ID(N'[dbo].[XC_INVOICE_REJECT_REASONS]')
		)
BEGIN
ALTER TABLE DBO.XC_INVOICE_REJECT_REASONS ADD Display_Name VARCHAR(100) NULL
END 
GO
-- changeset Balajeeraj : 46
-- comment xon-1085 | New Table Introduced -sa_default_cogs_categories_master
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'sa_default_cogs_categories_master'
		)
BEGIN
	DROP TABLE [dbo].sa_default_cogs_categories_master
END
GO
CREATE TABLE [dbo].sa_default_cogs_categories_master (
	[pk] [bigint] IDENTITY(1, 1) NOT NULL
	,[category_name] [nvarchar](700) NOT NULL
    ,[cogs_name] [nvarchar](700)  NULL
    ,[isfood_item][BIT] NOT NULL
    ,[created_on] [DATETIME] NOT NULL
    ,[modified_on] [DATETIME] NOT NULL
	,CONSTRAINT [pk_sa_default_cogs_categories_master] PRIMARY KEY CLUSTERED ([pk] ASC) ON [XC_MetaFG]
	) ON [XC_MetaFG]
GO
GO
IF EXISTS (
		SELECT 1
		FROM sys.Indexes
		WHERE Object_id = Object_ID(N'[dbo].[sa_default_cogs_categories_master]')
			AND Name = 'nci_sa_default_cogs_categories_master_category_name'
		)
	DROP INDEX [nci_sa_default_cogs_categories_master_category_name] ON [dbo].[sa_default_cogs_categories_master]
GO
CREATE NONCLUSTERED INDEX nci_sa_default_cogs_categories_master_category_name ON DBO.sa_default_cogs_categories_master ([category_name] ASC) ON [XC_MetaFG]
GO
GO
IF EXISTS (
		SELECT 1
		FROM sys.Indexes
		WHERE Object_id = Object_ID(N'[dbo].[sa_default_cogs_categories_master]')
			AND Name = 'nci_sa_default_cogs_categories_master_cogs_name'
		)
	DROP INDEX [nci_sa_default_cogs_categories_master_cogs_name] ON [dbo].[sa_default_cogs_categories_master]
GO
CREATE NONCLUSTERED INDEX nci_sa_default_cogs_categories_master_cogs_name ON DBO.sa_default_cogs_categories_master ([cogs_name] ASC) ON [XC_MetaFG]
GO

-- changeset Ramkumar:73 
-- comment PET-579 | Add Audit Time for Each Queue in ABBYY Stats

IF TYPE_ID(N'XC_ABBYY_STATS_TABLE') IS NULL 
BEGIN 
CREATE TYPE [dbo].[XC_ABBYY_STATS_TABLE] AS TABLE(
	[ABBYY_BATCHNO] [nvarchar](200) NOT NULL,
	[XC_ABBYY_REFERENCEID] [nvarchar](200) NOT NULL,
	[DATE] [date] NOT NULL,
	[USER_NAME] [varchar](50) NOT NULL,
	[ROLE_ID] [int] NOT NULL,
	[ROLE_NAME] [varchar](50) NOT NULL,
	[PAGE_COUNT] [smallint] NOT NULL,
	[TIME_TAKEN] [int] NOT NULL,
	[ABBYY_BATCH_CREATED_TIME] [datetime] NOT NULL,
	[LAST_MODIFIED_TIME] [datetime] NOT NULL,
	[AUDIT_TIME] [datetime] NOT NULL
)
END
GO

-- changeset Pratheesh : 89
-- comment IOPS-705 | Build SQL Script to merge values in the XC_UOM_MASTER table - Phase 2
IF  EXISTS (
			SELECT * FROM sys.objects 
			WHERE object_id = OBJECT_ID(N'[dbo].[XC_AUDIT_UOM_MASTER]') 
			AND type in (N'U')
			)
BEGIN
DROP TABLE [dbo].[XC_AUDIT_UOM_MASTER]
END
GO
CREATE TABLE [dbo].[XC_AUDIT_UOM_MASTER](
    [AUDITID] [bigint] IDENTITY(1,1) NOT NULL,
	[AUDIT_DATETIME] [datetime] NOT NULL,
	[AUDIT_INFO] [varchar](255) NULL,
	[USERID] [bigint] NOT NULL,
	[SOURCE_UOM_ID] [bigint] NOT NULL,
	[SOURCE_UOM] [nvarchar](50) NULL,
	[SOURCE_STANDARD_UOM] [varchar](20) NULL,
	[SOURCE_DISPLAY_UOM] [varchar](20) NULL,
	[TARGET_UOM_ID] [bigint] NOT NULL,
	[TARGET_UOM] [nvarchar](50) NULL,
	[JSON] [nvarchar](max) NULL,
 CONSTRAINT [PK_XC_AUDIT_UOM_MASTER] PRIMARY KEY CLUSTERED 
(
	[AUDITID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [XC_MetaFG]
) ON [XC_MetaFG]
GO


-- changeset Divya : 96
-- comment BOOK-112 | Altered table to add a new column GL Detail type
IF NOT EXISTS (
        SELECT 1
        FROM SYS.COLUMNS
        WHERE [NAME] = (N'GL_Detail_Type')
            AND Object_ID = Object_ID(N'[dbo].[SA_BOOKS_STANDARD_COA_MASTER]')
        )
BEGIN
ALTER TABLE DBO.[SA_BOOKS_STANDARD_COA_MASTER] ADD GL_Detail_Type VARCHAR(500) NULL
END 
GO
