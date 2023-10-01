-- liquibase formatted sql
--changeset Mano : 01
--comment UXT-863 | Allow customers to run the AvT report in an offline mode

IF NOT EXISTS (
			SELECT 1
			FROM dbo.XC_APPCONFIG WITH (NOLOCK)
			WHERE CONFIGKEY='XC_SUPPORT_EMAIL'
			)
	BEGIN
		INSERT INTO dbo.XC_APPCONFIG (
			 CONFIGKEY
			,CONFIGVALUE
			)
		VALUES (
			'XC_SUPPORT_EMAIL'
			,'support@xtrachef.com'
			)
END
GO

IF NOT EXISTS (
			SELECT 1
			FROM dbo.XC_APPCONFIG WITH (NOLOCK)
			WHERE CONFIGKEY='SA_OFFLINE_REPORT_FETCH_INTERVAL'
			)
	BEGIN
		INSERT INTO dbo.XC_APPCONFIG (
			 CONFIGKEY
			,CONFIGVALUE
			)
		VALUES (
			'SA_OFFLINE_REPORT_FETCH_INTERVAL'
			,'3000'
			)
END
GO

--changeset Magesh S : 07
--comment XON-1112 | Update script for Books description
IF EXISTS (
			SELECT 1
			FROM dbo.[SA_USERGOALS_MASTER] WITH (NOLOCK)
			WHERE Description='Onboarding only'
			AND Badge = 'Books'
			)
	BEGIN
		UPDATE dbo.[SA_USERGOALS_MASTER]
		SET Description = 'Onboarding help (Waitlist)'
		WHERE Description = 'Onboarding only'
		AND Badge = 'Books'
	END
GO
--changeset Jerome : 06
--comment IOPS-705 | Merge UOM amf script

IF EXISTS (
	SELECT 1 FROM [dbo].[XC_MODULE_FEATURE_MASTER] WITH (NOLOCK) WHERE PK = 202
)
BEGIN
	UPDATE [dbo].[XC_MODULE_FEATURE_MASTER]  SET [Priority] = 67 WHERE PK = 202
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[XC_MODULE_FEATURE_MASTER] WITH (NOLOCK) WHERE ModuleFeatureCode = '871')
BEGIN
INSERT INTO [dbo].[XC_MODULE_FEATURE_MASTER]
           ([GUID]
           ,[Name]
           ,[Type]
           ,[System]
           ,[ListPrice]
           ,[ListPriceType]
		   ,[ValidFrom]
           ,[ExpiresOn]
           ,[Created]
           ,[CreatedBy]
           ,[LastModified]
           ,[LastModifiedBy]
           ,[Json]
           ,[ModuleFeatureCode]
           ,[Caption]
           ,[ModuleCode]
           ,[Active]
           ,[ParentFeatureKey]
           ,[Endpoint]
           ,[Beta]
           ,[WebLink]
           ,[Priority]
           ,[LockedWebLink]
           ,[MenuGroup]
           ,[ModuleFeatureId]
           ,[ModuleGroupId]
           ,[MenuType]
           ,[AllowAllLocation])
     VALUES
           (NEWID()
           ,'Merge UOM'
           ,'Modules'
           ,0
           ,0.00
           ,0
		   ,GETDATE()
           ,DATEADD(YEAR, 20, GETDATE())
           ,GETDATE()
           ,1
           ,GETDATE()
           ,1
           ,''
           ,'871'
           ,'Merge UOM'
           ,'871'
           ,1
           ,null
           ,null
           ,0
           ,'/XtraChefManagement/MergeUom/MergeUom'
           ,64
           ,''
           ,1
           ,871
           ,1
           ,0
           ,0)
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[XC_PACKAGE_DETAIL] WITH (NOLOCK) WHERE PackageCode = 'XC_SA' and ModuleFeatureCode='871')
BEGIN
INSERT INTO [dbo].[XC_PACKAGE_DETAIL]
           ([PackageCode]
           ,[ModuleFeatureCode]
           ,[Created]
           ,[CreatedBy]
           ,[LastModified]
           ,[LastModifiedBy])
     VALUES
           ('XC_SA'
           ,'871'
           ,GETDATE()
           ,1
           ,GETDATE()
           ,1)
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[XC_PACKAGE_DETAIL] WITH (NOLOCK) WHERE PackageCode = 'XC_SA_NEW' and ModuleFeatureCode='871')
BEGIN
INSERT INTO [dbo].[XC_PACKAGE_DETAIL]
           ([PackageCode]
           ,[ModuleFeatureCode]
           ,[Created]
           ,[CreatedBy]
           ,[LastModified]
           ,[LastModifiedBy])
     VALUES
           ('XC_SA_NEW'
           ,'871'
           ,GETDATE()
           ,1
           ,GETDATE()
           ,1)
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[XC_MODULE_ACCESS_GROUP_DETAIL] WITH (NOLOCK) WHERE ModuleFeatureCode = '871' and AccessGroupId=1)
BEGIN
INSERT INTO [dbo].[XC_MODULE_ACCESS_GROUP_DETAIL]
           ([AccessGroupId]
           ,[ModuleFeatureCode]
           ,[AccessLevel]
           ,[Created]
           ,[CreatedBy]
           ,[LastModified]
           ,[LastModifiedBy])
     VALUES
           (1
           ,'871'
           ,1
           ,GETDATE()
           ,1
           ,GETDATE()
           ,1)
END
GO

--changeset Ranjith:17
--comment SAMX-358 | adding default standard categories in XC_TENANT_CUSTCATEGORIES table
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '1' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Baked Goods', '1', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '2' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Bar Supplies', '2', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '3' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Beer - Other', '3', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '4' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Beer - Bottles & Cans', '4', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '5' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Coffee & Tea', '5', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '6' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Dairy', '6', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '7' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Beer - Draft', '7', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '8' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Dry Goods', '8', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '9' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Food - other', '9', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '10' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Frozen', '10', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '11' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Juice', '11', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '12' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Liquor - Other', '12', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '13' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Meat/ Protein', '13', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '14' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Retail', '14', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '15' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'NA Beverage - Other', '15', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '16' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Non-Food Items', '16', 1, GETUTCDATE(), GETUTCDATE(), 0)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '17' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Produce', '17', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '18' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Seafood', '18', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '19' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Soda', '19', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '20' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Liquor', '20', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '21' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Water', '21', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO
IF NOT EXISTS(SELECT 1 FROM [DBO].[XC_TENANT_CUSTCATEGORIES] WITH (NOLOCK) WHERE TENANTID = 0 and SYSTEM_CATEGORY_CODE = '22' )
BEGIN
	INSERT INTO [DBO].[XC_TENANT_CUSTCATEGORIES](
    TENANTID, CUSTOMCATEGORYNAME, SYSTEM_CATEGORY_CODE, ACTIVE, CREATEDON, MODIFIEDON, IncludeCOGS
    )
    VALUES(0, 'Wine', '22', 1, GETUTCDATE(), GETUTCDATE(), 1)
END
GO

--changeset Ashish Verma : 26
--comment IOPS-694 | USF Toast Tech Package

IF NOT EXISTS (
	SELECT 1
    FROM [DBO].XC_APPCONFIG WITH (NOLOCK)
    WHERE CONFIGKEY = 'USF_SUPPLIER_PORTAL'
    )
BEGIN
	INSERT INTO [DBO].XC_APPCONFIG (
	CONFIGKEY,
	CONFIGVALUE
	)
	VALUES (
	'USF_SUPPLIER_PORTAL',
	'https://order.usfoods.com/'
	)
END
GO

--changeset Mohana : 23
--comment IOPS-677 | config to enable reject in possible duplicate edi invoices
IF NOT EXISTS (
			SELECT 1
			FROM dbo.XC_APPCONFIG WITH (NOLOCK)
			WHERE CONFIGKEY='ENABLE_EDI_POSSIBLE_DUPLICATE_REJECT'
			)
	BEGIN
		INSERT INTO dbo.XC_APPCONFIG (
			 CONFIGKEY
			,CONFIGVALUE
			)
		VALUES (
			'ENABLE_EDI_POSSIBLE_DUPLICATE_REJECT'
			,'TRUE'
			)
END
GO

--changeset Divya : 14
--comment BOOK-104 | Insert default cogs in cogs master

IF NOT EXISTS (
			SELECT 1
			FROM [DBO].[XC_COGS_GROUP_MASTER]
            WHERE TENANT_ID = 0
            AND COGS_GROUP_NAME = 'Beer'
			)
	BEGIN
		INSERT INTO [DBO].[XC_COGS_GROUP_MASTER] (
            TENANT_ID,
            COGS_GROUP_NAME,
            ACTIVE,
            CREATED_ON,
            COGS_ORDER,
            EXCLUDE_FROM_SALES
			)
		VALUES (
			0,
            'Beer',
            1,
            GETDATE(),
            0,
            NULL
			)
END
GO


IF NOT EXISTS (
			SELECT 1
			FROM [DBO].[XC_COGS_GROUP_MASTER]
            WHERE TENANT_ID = 0
            AND COGS_GROUP_NAME = 'Food'
			)
	BEGIN
		INSERT INTO [DBO].[XC_COGS_GROUP_MASTER] (
            TENANT_ID,
            COGS_GROUP_NAME,
            ACTIVE,
            CREATED_ON,
            COGS_ORDER,
            EXCLUDE_FROM_SALES
			)
		VALUES (
			0,
            'Food',
            1,
            GETDATE(),
            0,
            NULL
			)
END
GO


IF NOT EXISTS (
			SELECT 1
			FROM [DBO].[XC_COGS_GROUP_MASTER]
            WHERE TENANT_ID = 0
            AND COGS_GROUP_NAME = 'Liquor'
			)
	BEGIN
		INSERT INTO [DBO].[XC_COGS_GROUP_MASTER] (
            TENANT_ID,
            COGS_GROUP_NAME,
            ACTIVE,
            CREATED_ON,
            COGS_ORDER,
            EXCLUDE_FROM_SALES
			)
		VALUES (
			0,
            'Liquor',
            1,
            GETDATE(),
            0,
            NULL
			)
END
GO

IF NOT EXISTS (
			SELECT 1
			FROM [DBO].[XC_COGS_GROUP_MASTER]
            WHERE TENANT_ID = 0
            AND COGS_GROUP_NAME = 'NA Beverage'
			)
	BEGIN
		INSERT INTO [DBO].[XC_COGS_GROUP_MASTER] (
            TENANT_ID,
            COGS_GROUP_NAME,
            ACTIVE,
            CREATED_ON,
            COGS_ORDER,
            EXCLUDE_FROM_SALES
			)
		VALUES (
			0,
            'NA Beverage',
            1,
            GETDATE(),
            0,
            NULL
			)
END
GO

IF NOT EXISTS (
			SELECT 1
			FROM [DBO].[XC_COGS_GROUP_MASTER]
            WHERE TENANT_ID = 0
            AND COGS_GROUP_NAME = 'Retail'
			)
	BEGIN
		INSERT INTO [DBO].[XC_COGS_GROUP_MASTER] (
            TENANT_ID,
            COGS_GROUP_NAME,
            ACTIVE,
            CREATED_ON,
            COGS_ORDER,
            EXCLUDE_FROM_SALES
			)
		VALUES (
			0,
            'Retail',
            1,
            GETDATE(),
            0,
            NULL
			)
END
GO

IF NOT EXISTS (
			SELECT 1
			FROM [DBO].[XC_COGS_GROUP_MASTER]
            WHERE TENANT_ID = 0
            AND COGS_GROUP_NAME = 'Wine'
			)
	BEGIN
		INSERT INTO [DBO].[XC_COGS_GROUP_MASTER] (
            TENANT_ID,
            COGS_GROUP_NAME,
            ACTIVE,
            CREATED_ON,
            COGS_ORDER,
            EXCLUDE_FROM_SALES
			)
		VALUES (
			0,
            'Wine',
            1,
            GETDATE(),
            0,
            NULL
			)
END
GO


IF EXISTS (
		SELECT 1
		FROM [dbo].[XC_COGS_GROUP_MASTER] WITH (NOLOCK)
		WHERE COGS_GROUP_NAME = 'Food'
		)
BEGIN
	UPDATE [dbo].[XC_TENANT_CUSTCATEGORIES]
	SET COGS_GROUP_ID = XCGM.COGS_GROUP_ID
	FROM [dbo].[XC_TENANT_CUSTCATEGORIES] XCT
	INNER JOIN [dbo].[XC_COGS_GROUP_MASTER] XCGM ON XCGM.TENANT_ID = XCT.TENANTID
	WHERE XCT.TENANTID = 0
		AND XCGM.COGS_GROUP_NAME = 'Food'
		AND XCT.CUSTOMCATEGORYNAME IN (
			'Meat/ Protein'
			,'Food - other'
			,'Frozen'
			,'Dry Goods'
			,'Baked Goods'
			,'Seafood'
			,'Produce'
			,'Dairy'
			)
END
GO

IF EXISTS (
		SELECT 1
		FROM [dbo].[XC_COGS_GROUP_MASTER] WITH (NOLOCK)
		WHERE COGS_GROUP_NAME = 'Liquor'
		)
BEGIN
	UPDATE [dbo].[XC_TENANT_CUSTCATEGORIES]
	SET COGS_GROUP_ID = XCGM.COGS_GROUP_ID
	FROM [dbo].[XC_TENANT_CUSTCATEGORIES] XCT
	INNER JOIN [dbo].[XC_COGS_GROUP_MASTER] XCGM ON XCGM.TENANT_ID = XCT.TENANTID
	WHERE XCT.TENANTID = 0
		AND XCGM.COGS_GROUP_NAME = 'Liquor'
		AND XCT.CUSTOMCATEGORYNAME IN (
			'Liquor'
			,'Bar Supplies'
			,'Liquor - Other'
			)
END
GO

IF EXISTS (
		SELECT 1
		FROM [dbo].[XC_COGS_GROUP_MASTER] WITH (NOLOCK)
		WHERE COGS_GROUP_NAME = 'NA Beverage'
		)
BEGIN
	UPDATE [dbo].[XC_TENANT_CUSTCATEGORIES]
	SET COGS_GROUP_ID = XCGM.COGS_GROUP_ID
	FROM [dbo].[XC_TENANT_CUSTCATEGORIES] XCT
	INNER JOIN [dbo].[XC_COGS_GROUP_MASTER] XCGM ON XCGM.TENANT_ID = XCT.TENANTID
	WHERE XCT.TENANTID = 0
		AND XCGM.COGS_GROUP_NAME = 'NA Beverage'
		AND XCT.CUSTOMCATEGORYNAME IN (
			'NA Beverage - Other'
			,'Coffee & Tea'
			,'Soda'
			,'Juice'
			,'Water'
			)
END
GO

IF EXISTS (
		SELECT 1
		FROM [dbo].[XC_COGS_GROUP_MASTER] WITH (NOLOCK)
		WHERE COGS_GROUP_NAME = 'Beer'
		)
BEGIN
	UPDATE [dbo].[XC_TENANT_CUSTCATEGORIES]
	SET COGS_GROUP_ID = XCGM.COGS_GROUP_ID
	FROM [dbo].[XC_TENANT_CUSTCATEGORIES] XCT
	INNER JOIN [dbo].[XC_COGS_GROUP_MASTER] XCGM ON XCGM.TENANT_ID = XCT.TENANTID
	WHERE XCT.TENANTID = 0
		AND XCGM.COGS_GROUP_NAME = 'Beer'
		AND XCT.CUSTOMCATEGORYNAME IN (
			'Beer - Draft'
			,'Beer - Bottles & Cans'
			,'Beer - Other'
			)
END
GO

IF EXISTS (
		SELECT 1
		FROM [dbo].[XC_COGS_GROUP_MASTER] WITH (NOLOCK)
		WHERE COGS_GROUP_NAME = 'Retail'
		)
BEGIN
	UPDATE [dbo].[XC_TENANT_CUSTCATEGORIES]
	SET COGS_GROUP_ID = XCGM.COGS_GROUP_ID
	FROM [dbo].[XC_TENANT_CUSTCATEGORIES] XCT
	INNER JOIN [dbo].[XC_COGS_GROUP_MASTER] XCGM ON XCGM.TENANT_ID = XCT.TENANTID
	WHERE XCT.TENANTID = 0
		AND XCGM.COGS_GROUP_NAME = 'Retail'
		AND XCT.CUSTOMCATEGORYNAME = 'Retail'
END
GO

IF EXISTS (
		SELECT 1
		FROM [dbo].[XC_COGS_GROUP_MASTER] WITH (NOLOCK)
		WHERE COGS_GROUP_NAME = 'Wine'
		)
BEGIN
	UPDATE [dbo].[XC_TENANT_CUSTCATEGORIES]
	SET COGS_GROUP_ID = XCGM.COGS_GROUP_ID
	FROM [dbo].[XC_TENANT_CUSTCATEGORIES] XCT
	INNER JOIN [dbo].[XC_COGS_GROUP_MASTER] XCGM ON XCGM.TENANT_ID = XCT.TENANTID
	WHERE XCT.TENANTID = 0
		AND XCGM.COGS_GROUP_NAME = 'Wine'
		AND XCT.CUSTOMCATEGORYNAME = 'Wine'
END
GO

--changeset Megala : 32
--comment : IOPS-868 | System reject ABBYY identified duplicate instead of routing to internal exception

IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[XC_APPCONFIG] WITH (NOLOCK)
            WHERE CONFIGKEY='ENABLED_DUPLICATE_INVOICE_REJECT'
            )
    BEGIN
        INSERT INTO [dbo].[XC_APPCONFIG] (
             CONFIGKEY
            ,CONFIGVALUE
            )
        VALUES (
            'ENABLED_DUPLICATE_INVOICE_REJECT'
            ,'TRUE'
            )
END
GO


--changeset Vamsi: 43
--comment - BIT-1285 | system default payment term changes

IF NOT EXISTS (
			SELECT 1
			FROM [DBO].[XC_APPCONFIG] WITH (NOLOCK)
			WHERE CONFIGKEY='BILL_PAY_DEFAULT_PAYMENT_TERM'
			)
BEGIN
	INSERT INTO [DBO].[XC_APPCONFIG] (
	CONFIGKEY
	,CONFIGVALUE
	)
	VALUES (
	'BILL_PAY_DEFAULT_PAYMENT_TERM'
	,'20'
	)
END
GO


--changeset Ashwin: 44
--comment - PET-504	| SA - Database - SQL Server to Aurora Migration - Reports

--Exception Operator Summary	->Operations Portal
IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME= 'Exception Operator Summary' AND TEMPLATE_REPORT=1  )
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"FROM_DATE","key":"FROM_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-1,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"From Date : ","range":30,"IsValidate":true}},{"id":"TO_DATE","key":"TO_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-1,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"To Date : "}},{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","className":"hide","defaultValue":"XC_EXCEPTIONOPERATOR_REPORT,FROM_DATE|VarChar,TO_DATE|VarChar","templateOptions":{"type":"hidden"}},{"id":"DBSource","type":"input","key":"DBSource","className":"hide","defaultValue":"AURORA","templateOptions":{"type":"hidden"}}]'
	WHERE REPORT_NAME = 'Exception Operator Summary'  AND TEMPLATE_REPORT=1
END
GO

--Product Duplicate Tracking	->Operations Portal
IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME = 'Product Duplicate Tracking')
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"FROM_DATE","key":"FROM_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-1,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"From Date : ","range":30,"IsValidate":true}},{"id":"TO_DATE","key":"TO_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-1,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"To Date : "}},{"id":"LOCATION","key":"LOCATION","className":"xc-w-288 xc-mr-20 xc-pt-8 pull-left","type":"ui-select-single-select2","defaultValue":"All","templateOptions":{"label":"Locations :","required":true,"valueProp":"id","labelProp":"name","options":"","items":[],"Sp_Name":"OPERATOR_LOCATION","Append_array":[{"id":"All","name":"All"}]}},{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","className":"hide","defaultValue":"XC_OPERATION_PRODUCT_DUPLICATE_TRACKING,FROM_DATE|VarChar,TO_DATE|VarChar,LOCATION|VARCHAR,USERID|BIGINT,USER_ROLEID|BIGINT","templateOptions":{"type":"hidden"}},{"id":"DBSource","type":"input","key":"DBSource","className":"hide","defaultValue":"AURORA","templateOptions":{"type":"hidden"}}]'
	WHERE REPORT_NAME = 'Product Duplicate Tracking'
END
GO

--Product Verification Report	->Operations Portal
IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME = 'Product Verification Report')
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"FROM_DATE","key":"FROM_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-1,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"From Date : ","range":180,"IsValidate":true}},{"id":"TO_DATE","key":"TO_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-1,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"To Date : "}},{"id":"LOCATION","key":"LOCATION","className":"xc-w-288 xc-mr-20 xc-pt-8 pull-left","type":"ui-select-single-select2","defaultValue":"All","templateOptions":{"label":"Locations :","required":true,"valueProp":"id","labelProp":"name","options":"","items":[],"Sp_Name":"OPERATOR_LOCATION","Append_array":[{"id":"All","name":"All"}]}},{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","className":"hide","defaultValue":"xc_operation_verification,FROM_DATE|VarChar,TO_DATE|VarChar,LOCATION|VARCHAR,USERID|BIGINT,USER_ROLEID|BIGINT","templateOptions":{"type":"hidden"}},{"id":"DBSource","type":"input","key":"DBSource","className":"hide","defaultValue":"AURORA","templateOptions":{"type":"hidden"}}]'
	WHERE REPORT_NAME = 'Product Verification Report'
END
GO

--Operations Monthly Stats	->Operations Portal
IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME = 'Operations Monthly Stats')
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"FROM_DATE","key":"FROM_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-1,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"From Date : ","range":30,"IsValidate":true}},{"id":"TO_DATE","key":"TO_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-1,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"To Date : "}},{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","className":"hide","defaultValue":"XC_OPERATIONS_MONTHLY_STATS,FROM_DATE|VarChar,TO_DATE|VarChar","templateOptions":{"type":"hidden"}},{"id":"DBSource","type":"input","key":"DBSource","className":"hide","defaultValue":"AURORA","templateOptions":{"type":"hidden"}}]'
	WHERE REPORT_NAME = 'Operations Monthly Stats'
END
GO

--Sales Sync Reconciliation	->KPI Portal/Customer Success portal
IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME = 'Sales Sync Reconciliation')
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"TENANTID","key":"TENANT_ID","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","type":"ui-select-single-select2","defaultValue":"","templateOptions":{"label":"Tenant :","required":true,"valueProp":"id","labelProp":"name","options":"","items":[],"Sp_Name":"JOURNAL_TENANT","Append_array":[]}},{"id":"LOCATIONID","key":"LOCATION_ID","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","type":"ui-select-single-select2","defaultValue":"","templateOptions":{"label":"Location :","required":true,"valueProp":"id","labelProp":"name","options":"","items":[],"Sp_Name":"LC","Append_array":[]}},{"id":"DATE","key":"DATE","type":"dateRangePicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-7,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":true,"datePicker":"","label":"Date : ","range":30,"IsValidate":true}},{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","className":"hide","defaultValue":"SA_GET_SALES_SYNC_RECONCILIATION,TENANTID|BigInt,LOCATIONID|BigInt,FROM_DATE|SqlDbType.DateTime,TO_DATE|SqlDbType.DateTime","templateOptions":{"type":"hidden"}},{"id":"DBSource","type":"input","key":"DBSource","className":"hide","defaultValue":"AURORA","templateOptions":{"type":"hidden"}}]'
	WHERE REPORT_NAME = 'Sales Sync Reconciliation'
END
GO


--TOAST Reconciliation	->KPI Portal/Customer Success portal
IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME = 'TOAST Reconciliation')
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","className":"hide","defaultValue":"XC_GET_TOAST_RECONCILIATION_DATA","templateOptions":{"type":"hidden"},"summary":{"id":"SummaryStoredProcedure","inputparameters":"XC_GET_TOAST_RECONCILIATION_DATA_ADDED_COUNT","url":"","type":"bar"}},{"id":"DBSource","type":"input","key":"DBSource","className":"hide","defaultValue":"AURORA","templateOptions":{"type":"hidden"}}]'
	WHERE REPORT_NAME = 'TOAST Reconciliation'
END
GO

--Active Users List	->KPI Portal/Customer Success
IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME = 'Active Users List')
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","className":"hide","defaultValue":"XC_GET_ACTIVE_USERS_LIST","templateOptions":{"type":"hidden"}},{"id":"DBSource","type":"input","key":"DBSource","className":"hide","defaultValue":"AURORA","templateOptions":{"type":"hidden"}}]'
	WHERE REPORT_NAME = 'Active Users List'
END
GO

--xtraCASH Statistics	->KPI Portal/Customer Success
IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME = 'xtraCASH Statistics')
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"YEAR_ID","key":"YEAR_ID","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","type":"ui-select-single-select2","defaultValue":"-1","templateOptions":{"label":"Year :","required":true,"valueProp":"id","labelProp":"name","options":"","items":[],"Sp_Name":"SELECT_YEAR","Append_array":[{"id":"-1","name":"All"}]}},{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","className":"hide","defaultValue":"XC_XTRACASH_STATISTICS_REPORTS,YEAR_ID|BigInt","templateOptions":{"type":"hidden"}},{"id":"DBSource","type":"input","key":"DBSource","className":"hide","defaultValue":"AURORA","templateOptions":{"type":"hidden"}}]'
	WHERE REPORT_NAME = 'xtraCASH Statistics'
END
GO

--Top 25 App Usage Statistics	->KPI Portal/Customer Success portal
IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME = 'Top 25 App Usage Statistics')
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"FROM_DATE","key":"FROM_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-7,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"From Date : ","range":30,"IsValidate":true}},{"id":"TO_DATE","key":"TO_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-1,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"To Date : "}},{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","className":"hide","defaultValue":"XC_TOP_25_APP_USAGE_STATISTICS_BY_DATE,FROM_DATE|DateTime,TO_DATE|DateTime","templateOptions":{"type":"hidden"}},{"id":"DBSource","type":"input","key":"DBSource","className":"hide","defaultValue":"AURORA","templateOptions":{"type":"hidden"}}]'
	WHERE REPORT_NAME = 'Top 25 App Usage Statistics'
END
GO

--QuickBooks Sync Status	->KPI Portal/Customer Success portal
IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME =  'QuickBooks Sync Status')
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"FROM_DATE","key":"FROM_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-1,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"Date : ","range":30,"IsValidate":false}},{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","defaultValue":"XC_GET_TOAST_QUICKBOOKS_SYNC_REPORT_DAYWISE,FROM_DATE|SqlDbType.VarChar","className":"hide","templateOptions":{"type":"hidden"}},{"id":"DBSource","type":"input","key":"DBSource","className":"hide","defaultValue":"AURORA","templateOptions":{"type":"hidden"}}]'
	WHERE REPORT_NAME = 'QuickBooks Sync Status'
END
GO

--QuickBooks Sync History	->KPI Portal/Customer Success portal
IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME = 'QuickBooks Sync History')
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"TENANTID","key":"TENANT_ID","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","type":"ui-select-single-select2","defaultValue":"-1","templateOptions":{"label":"Tenant :","required":true,"valueProp":"id","labelProp":"name","options":"","items":[],"Sp_Name":"JOURNAL_TENANT","Append_array":[{"id":"-1","name":"All"}]}},{"id":"FROM_DATE","key":"FROM_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-7,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"From Date : ","range":30,"IsValidate":true}},{"id":"TO_DATE","key":"TO_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-1,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"To Date : "}},{"id":"SALES_STATUS","key":"SALES_STATUS","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","type":"ui-select-single-select2","defaultValue":"All","templateOptions":{"label":"Sales Status :","required":true,"valueProp":"id","labelProp":"name","options":"","items":[],"Sp_Name":"SALES_STATUS","Append_array":[]}},{"id":"SYNC_STATUS","key":"SYNC_STATUS","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","type":"ui-select-single-select2","defaultValue":"All","templateOptions":{"label":"Sync Status :","required":true,"valueProp":"id","labelProp":"name","options":"","items":[],"Sp_Name":"SYNC_STATUS","Append_array":[]}},{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","className":"hide","defaultValue":"XC_GET_TOAST_QUICKBOOKS_SYNC_REPORT,TENANTID|BigInt,FROM_DATE|SqlDbType.VarChar,TO_DATE|SqlDbType.VarChar,SALES_STATUS|SqlDbType.VarChar,SYNC_STATUS|SqlDbType.VarChar","templateOptions":{"type":"hidden"}},{"id":"DBSource","type":"input","key":"DBSource","className":"hide","defaultValue":"AURORA","templateOptions":{"type":"hidden"}}]'
	WHERE REPORT_NAME = 'QuickBooks Sync History'
END
GO
--changeset Balajeeraj: 47
--comment - XON-1085 | Data Insertion for categories with cogs
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Wine'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master]
(category_name,cogs_name,isfood_item,created_on,modified_on)
VALUES ('Wine','Wine',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Retail'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Retail','Retail',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Meat/ Protein'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Meat/ Protein','Food',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Dairy'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Dairy','Food',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Seafood'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Seafood','Food',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Produce'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Produce','Food',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Baked Goods'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Baked Goods','Food',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Dry Goods'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Dry Goods','Food',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Frozen'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Frozen','Food',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Food - other'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Food - other','Food',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Liquor'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Liquor','Liquor',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Bar Supplies'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Bar Supplies','Liquor',1,GETDATE(),GETDATE())
END
GO

IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Liquor - Other'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Liquor - Other','Liquor',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Beer - Draft'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Beer - Draft','Beer',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Beer - Bottles & Cans'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Beer - Bottles & Cans','Beer',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Beer - Other'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Beer - Other','Beer',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Soda'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Soda','NA Beverage',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Juice'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Juice','NA Beverage',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Coffee & Tea'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Coffee & Tea','NA Beverage',1,GETDATE(),GETDATE())
END
GO

IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'NA Beverage - Other'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('NA Beverage - Other','NA Beverage',1,GETDATE(),GETDATE())
END
GO

IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Water'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Water','NA Beverage',1,GETDATE(),GETDATE())
END
GO
IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[sa_default_cogs_categories_master] WITH (NOLOCK)
		WHERE [category_name] = 'Non-Food Items'
		)
BEGIN
	INSERT INTO [dbo].[sa_default_cogs_categories_master] (category_name,cogs_name,isfood_item,created_on,modified_on)
	VALUES ('Non-Food Items',NULL,0,GETDATE(),GETDATE())
END

GO

--changeset Dinesh R : 53
--comment UXT-1203 | Update scripts to add displayNames

IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 1
			AND [STATUS] = 'Completed'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Completed'
		WHERE ID = 1
		AND [STATUS] = 'Completed'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 3
			AND [STATUS] = 'Uploaded'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 3
		AND [STATUS] = 'Uploaded'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 2
			AND [STATUS] = 'Invoice Data Entry Processing'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 2
		AND [STATUS] = 'Invoice Data Entry Processing'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 5
			AND [STATUS] = 'Deleted'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 5
		AND [STATUS] = 'Deleted'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 6
			AND [STATUS] = 'Vendor review waiting'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 6
		AND [STATUS] = 'Vendor review waiting'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 7
			AND [STATUS] = 'Vendor Review Processing'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 7
		AND [STATUS] = 'Vendor Review Processing'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 8
			AND [STATUS] = 'Ready For IDC'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 8
		AND [STATUS] = 'Ready For IDC'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 9
			AND [STATUS] = 'IDC Completed'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 9
		AND [STATUS] = 'IDC Completed'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 10
			AND [STATUS] = 'Exception'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 10
		AND [STATUS] = 'Exception'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 11
			AND [STATUS] = 'Manual Exception'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 11
		AND [STATUS] = 'Manual Exception'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 12
			AND [STATUS] = 'Pending Data Extraction'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 12
		AND [STATUS] = 'Pending Data Extraction'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 13
			AND [STATUS] = 'User Edit'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 13
		AND [STATUS] = 'User Edit'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 14
			AND [STATUS] = 'Invoice Review'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Info missing'
		WHERE ID = 14
		AND [STATUS] = 'Invoice Review'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 15
			AND [STATUS] = 'Pending Page Separation'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 15
		AND [STATUS] = 'Pending Page Separation'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 17
			AND [STATUS] = 'Invoice Approve Waiting'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Ready to approve'
		WHERE ID = 17
		AND [STATUS] = 'Invoice Approve Waiting'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 21
			AND [STATUS] = 'Cost Center Allocation Waiting'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Ready to allocate'
		WHERE ID = 21
		AND [STATUS] = 'Cost Center Allocation Waiting'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 22
			AND [STATUS] = 'Product Review Waiting'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Ready to verify product'
		WHERE ID = 22
		AND [STATUS] = 'Product Review Waiting'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 23
			AND [STATUS] = 'Product Duplicate Waiting'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 23
		AND [STATUS] = 'Product Duplicate Waiting'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 24
			AND [STATUS] = 'Pending Map Location - XC'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 24
		AND [STATUS] = 'Pending Map Location - XC'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 25
			AND [STATUS] = 'Pending Map Location - User'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Ready to map location'
		WHERE ID = 25
		AND [STATUS] = 'Pending Map Location - User'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 26
			AND [STATUS] = 'Global Vendor Mapping'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 26
		AND [STATUS] = 'Global Vendor Mapping'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 99
			AND [STATUS] = 'Error in file uploaded to S3'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 99
		AND [STATUS] = 'Error in file uploaded to S3'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 16
			AND [STATUS] = 'Completed Page Sepration'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Processing'
		WHERE ID = 16
		AND [STATUS] = 'Completed Page Sepration'
	END
GO
IF EXISTS (
			SELECT 1
			FROM dbo.[XC_INVOICE_STATUSMASTER] WITH (NOLOCK)
			WHERE ID = 4
			AND [STATUS] = 'Rejected'
			)
	BEGIN
		UPDATE dbo.[XC_INVOICE_STATUSMASTER]
		SET DISPLAY_NAME = 'Rejected'
		WHERE ID = 4
		AND [STATUS] = 'Rejected'
	END
GO
IF NOT EXISTS (
			SELECT 1
			FROM dbo.XC_INVOICE_REJECT_REASONS WITH (NOLOCK)
			WHERE REJECT_REASON='Archived' AND TENANTID = NULL
			)
	BEGIN
		INSERT INTO dbo.XC_INVOICE_REJECT_REASONS (
			 REJECT_REASON
			,ACTIVE
			,CREATED_ON
			,MODIFIED_ON
			,REJECT_OVERRIDE
			,DEFAULT_REASONS
			,TENANTID
			,CREATED_BY
			,LASTMODIFIED_BY
			,DISPLAY_NAME
			)
		VALUES (
			'Archived'
			,1
			,GETDATE()
			,GETDATE()
			,0
			,NULL
			,NULL
			,NULL
			,NULL
			,'Archived'
			)
	END
GO

--changeset Ashwin: 56
--comment - PET-504	| SA - Database - SQL Server to Aurora Migration - Reports

IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME = 'Sales Sync Reconciliation')
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"TENANTID","key":"TENANT_ID","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","type":"ui-select-single-select2","defaultValue":"","templateOptions":{"label":"Tenant :","required":true,"valueProp":"id","labelProp":"name","options":"","items":[],"Sp_Name":"JOURNAL_TENANT","Append_array":[]}},{"id":"LOCATIONID","key":"LOCATION_ID","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","type":"ui-select-single-select2","defaultValue":"","templateOptions":{"label":"Location :","required":true,"valueProp":"id","labelProp":"name","options":"","items":[],"Sp_Name":"LC","Append_array":[]}},{"id":"DATE","key":"DATE","type":"dateRangePicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-7,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":true,"datePicker":"","label":"Date : ","range":30,"IsValidate":true}},{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","className":"hide","defaultValue":"SA_GET_SALES_SYNC_RECONCILIATION,TENANTID|BigInt,LOCATIONID|BigInt,FROM_DATE|DATETIME,TO_DATE|DATETIME","templateOptions":{"type":"hidden"}},{"id":"DBSource","type":"input","key":"DBSource","className":"hide","defaultValue":"AURORA","templateOptions":{"type":"hidden"}}]'
	WHERE REPORT_NAME = 'Sales Sync Reconciliation'
END
GO

--QuickBooks Sync Status	->KPI Portal/Customer Success portal
IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME =  'QuickBooks Sync Status')
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"FROM_DATE","key":"FROM_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-1,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"Date : ","range":30,"IsValidate":false}},{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","defaultValue":"XC_GET_TOAST_QUICKBOOKS_SYNC_REPORT_DAYWISE,FROM_DATE|VARCHAR","className":"hide","templateOptions":{"type":"hidden"}},{"id":"DBSource","type":"input","key":"DBSource","className":"hide","defaultValue":"AURORA","templateOptions":{"type":"hidden"}}]'
	WHERE REPORT_NAME = 'QuickBooks Sync Status'
END
GO


--QuickBooks Sync History	->KPI Portal/Customer Success portal
IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME = 'QuickBooks Sync History')
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"TENANTID","key":"TENANT_ID","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","type":"ui-select-single-select2","defaultValue":"-1","templateOptions":{"label":"Tenant :","required":true,"valueProp":"id","labelProp":"name","options":"","items":[],"Sp_Name":"JOURNAL_TENANT","Append_array":[{"id":"-1","name":"All"}]}},{"id":"FROM_DATE","key":"FROM_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-7,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"From Date : ","range":30,"IsValidate":true}},{"id":"TO_DATE","key":"TO_DATE","type":"datepicker","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","defaultValue":-1,"ngModelAttrs":{"datePicker":{"attribute":"date-picker"}},"templateOptions":{"required":false,"datePicker":"","label":"To Date : "}},{"id":"SALES_STATUS","key":"SALES_STATUS","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","type":"ui-select-single-select2","defaultValue":"All","templateOptions":{"label":"Sales Status :","required":true,"valueProp":"id","labelProp":"name","options":"","items":[],"Sp_Name":"SALES_STATUS","Append_array":[]}},{"id":"SYNC_STATUS","key":"SYNC_STATUS","className":"xc-w-200 xc-mr-20 xc-pt-8 pull-left","type":"ui-select-single-select2","defaultValue":"All","templateOptions":{"label":"Sync Status :","required":true,"valueProp":"id","labelProp":"name","options":"","items":[],"Sp_Name":"SYNC_STATUS","Append_array":[]}},{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","className":"hide","defaultValue":"XC_GET_TOAST_QUICKBOOKS_SYNC_REPORT,TENANTID|BigInt,FROM_DATE|VARCHAR,TO_DATE|VARCHAR,SALES_STATUS|VARCHAR,SYNC_STATUS|VARCHAR","templateOptions":{"type":"hidden"}},{"id":"DBSource","type":"input","key":"DBSource","className":"hide","defaultValue":"AURORA","templateOptions":{"type":"hidden"}}]'
	WHERE REPORT_NAME = 'QuickBooks Sync History'
END
GO


--changeset Ashwin:62
--comment - PET-504	| SA - Database - SQL Server to Aurora Migration - Reports- removing aurora source obj

--TOAST Reconciliation	->KPI Portal/Customer Success portal
IF EXISTS(SELECT * FROM dbo.XC_REPORT_MASTER WITH(NOLOCK) WHERE REPORT_NAME = 'TOAST Reconciliation')
BEGIN
	UPDATE dbo.XC_REPORT_MASTER SET TEMPLATE_JSON='[{"id":"StoreProcedureName","type":"input","key":"StoreProcedureName","className":"hide","defaultValue":"XC_GET_TOAST_RECONCILIATION_DATA","templateOptions":{"type":"hidden"},"summary":{"id":"SummaryStoredProcedure","inputparameters":"XC_GET_TOAST_RECONCILIATION_DATA_ADDED_COUNT","url":"","type":"bar"}}]'
	WHERE REPORT_NAME = 'TOAST Reconciliation'
END
GO

--changeset Dharanivel:69
--comment -RIO-1004 | added new key in appConfig
IF NOT EXISTS (
			SELECT 1
			FROM dbo.XC_APPCONFIG WITH (NOLOCK)
			WHERE CONFIGKEY='SA_RECIPE_AURORA_DB_FETCH_DELAY'
			)
BEGIN
	INSERT INTO dbo.XC_APPCONFIG (
		 CONFIGKEY
		,CONFIGVALUE
		)
	VALUES (
		'SA_RECIPE_AURORA_DB_FETCH_DELAY'
		,'1200'
		)
END
ELSE
BEGIN
	UPDATE dbo.XC_APPCONFIG SET CONFIGVALUE = '1200' WHERE CONFIGKEY='SA_RECIPE_AURORA_DB_FETCH_DELAY'
END
GO

--changeset Vamsi: 71
--comment - BIT-1285 | system default payment term changes
IF EXISTS (
			SELECT 1
			FROM [DBO].[XC_APPCONFIG] WITH (NOLOCK)
			WHERE CONFIGKEY='BILL_PAY_DEFAULT_PAYMENT_TERM' AND CONFIGVALUE='20'
			)
BEGIN
	UPDATE [DBO].[XC_APPCONFIG] SET CONFIGVALUE='7'
	WHERE CONFIGKEY='BILL_PAY_DEFAULT_PAYMENT_TERM'
END
GO

--changeset Divya: 79
--comment - BOOK-103 | Insert script for Books Reports

DECLARE @OPR_APP_OBJECT_ID BIGINT

SELECT @OPR_APP_OBJECT_ID = APP_OBJECT_ID
FROM XC_APP_OBJECTS WITH (NOLOCK)
WHERE APP_OBJECT_TYPE = 'portal'
	AND APP_OBJECT_NAME = 'Books_portal'


IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[XC_REPORT_MASTER] WITH (NOLOCK)
		WHERE report_name = 'COA Sync'
			AND category_name = 'Menu'
			AND APP_OBJECT_ID = @OPR_APP_OBJECT_ID
		)
BEGIN
	INSERT INTO [dbo].[XC_REPORT_MASTER]
           ([REPORT_NAME]
           ,[REPORT_URL]
           ,[CATEGORY_NAME]
           ,[CATEGORY_ORDER]
           ,[ICON_NAME]
           ,[DESCRIPTION]
           ,[APP_OBJECT_ID]
           ,[REPORT_TYPE]
           ,[REPORT_LEVEL]
           ,[TEMPLATE_REPORT]
           ,[TEMPLATE_JSON]
           ,[CONFIG_JSON]
           ,[DASHBOARD_REPORT]
           ,[IS_HELPTEXT]
           ,[HELPTEXT_CONTENT]
           ,[IS_DETAIL_VIEW]
           ,[IS_EMAIL_REQUIRED]
           ,[ACTIVE]
           ,[CREATED]
           ,[CREATED_BY]
           ,[LASTMODIFIED]
           ,[LASTMODIFIED_BY])
	VALUES (
		'COA Sync'
		,''
		,'Menu'
		,1
		,''
		,'Move Standard GL to QBO'
		,@OPR_APP_OBJECT_ID
		,'NA'
		,'NA'
		,'1'
		,NULL
		,NULL
		,0
        ,NULL
        ,NULL
        ,0
        , NULL
        ,1
        ,GETDATE()
        ,1
        ,GETDATE()
        ,1
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[XC_REPORT_MASTER] WITH (NOLOCK)
		WHERE report_name = 'Product Category Review'
			AND category_name = 'Menu'
			AND APP_OBJECT_ID = @OPR_APP_OBJECT_ID
		)
BEGIN
	INSERT INTO [dbo].[XC_REPORT_MASTER]
           ([REPORT_NAME]
           ,[REPORT_URL]
           ,[CATEGORY_NAME]
           ,[CATEGORY_ORDER]
           ,[ICON_NAME]
           ,[DESCRIPTION]
           ,[APP_OBJECT_ID]
           ,[REPORT_TYPE]
           ,[REPORT_LEVEL]
           ,[TEMPLATE_REPORT]
           ,[TEMPLATE_JSON]
           ,[CONFIG_JSON]
           ,[DASHBOARD_REPORT]
           ,[IS_HELPTEXT]
           ,[HELPTEXT_CONTENT]
           ,[IS_DETAIL_VIEW]
           ,[IS_EMAIL_REQUIRED]
           ,[ACTIVE]
           ,[CREATED]
           ,[CREATED_BY]
           ,[LASTMODIFIED]
           ,[LASTMODIFIED_BY])
	VALUES (
		'Product Category Review'
		,''
		,'Menu'
		,2
		,''
		,'Product Category Review'
		,@OPR_APP_OBJECT_ID
		,'NA'
		,'NA'
		,'1'
		,NULL
		,NULL
		,0
        ,NULL
        ,NULL
        ,0
        , NULL
        ,1
        ,GETDATE()
        ,1
        ,GETDATE()
        ,1
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[XC_REPORT_MASTER] WITH (NOLOCK)
		WHERE report_name = 'COA -> Add Standard COA to QBO'
			AND category_name = 'Action'
			AND APP_OBJECT_ID = @OPR_APP_OBJECT_ID
		)
BEGIN
	INSERT INTO [dbo].[XC_REPORT_MASTER]
           ([REPORT_NAME]
           ,[REPORT_URL]
           ,[CATEGORY_NAME]
           ,[CATEGORY_ORDER]
           ,[ICON_NAME]
           ,[DESCRIPTION]
           ,[APP_OBJECT_ID]
           ,[REPORT_TYPE]
           ,[REPORT_LEVEL]
           ,[TEMPLATE_REPORT]
           ,[TEMPLATE_JSON]
           ,[CONFIG_JSON]
           ,[DASHBOARD_REPORT]
           ,[IS_HELPTEXT]
           ,[HELPTEXT_CONTENT]
           ,[IS_DETAIL_VIEW]
           ,[IS_EMAIL_REQUIRED]
           ,[ACTIVE]
           ,[CREATED]
           ,[CREATED_BY]
           ,[LASTMODIFIED]
           ,[LASTMODIFIED_BY])
	VALUES (
		'COA -> Add Standard COA to QBO'
		,''
		,'Action'
		,2
		,''
		,'Add Standard COA to QBO'
		,@OPR_APP_OBJECT_ID
		,'NA'
		,'NA'
		,'1'
		,NULL
		,NULL
		,0
        ,NULL
        ,NULL
        ,0
        , NULL
        ,1
        ,GETDATE()
        ,1
        ,GETDATE()
        ,1
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[XC_REPORT_MASTER] WITH (NOLOCK)
		WHERE report_name = 'COA -> Merge Standard COA to QBO'
			AND category_name = 'Action'
			AND APP_OBJECT_ID = @OPR_APP_OBJECT_ID
		)
BEGIN
	INSERT INTO [dbo].[XC_REPORT_MASTER]
           ([REPORT_NAME]
           ,[REPORT_URL]
           ,[CATEGORY_NAME]
           ,[CATEGORY_ORDER]
           ,[ICON_NAME]
           ,[DESCRIPTION]
           ,[APP_OBJECT_ID]
           ,[REPORT_TYPE]
           ,[REPORT_LEVEL]
           ,[TEMPLATE_REPORT]
           ,[TEMPLATE_JSON]
           ,[CONFIG_JSON]
           ,[DASHBOARD_REPORT]
           ,[IS_HELPTEXT]
           ,[HELPTEXT_CONTENT]
           ,[IS_DETAIL_VIEW]
           ,[IS_EMAIL_REQUIRED]
           ,[ACTIVE]
           ,[CREATED]
           ,[CREATED_BY]
           ,[LASTMODIFIED]
           ,[LASTMODIFIED_BY])
	VALUES (
		'COA -> Merge Standard COA to QBO'
		,''
		,'Action'
		,2
		,''
		,'Merge Standard COA to QBO'
		,@OPR_APP_OBJECT_ID
		,'NA'
		,'NA'
		,'1'
		,NULL
		,NULL
		,0
        ,NULL
        ,NULL
        ,0
        , NULL
        ,1
        ,GETDATE()
        ,1
        ,GETDATE()
        ,1
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[XC_REPORT_MASTER] WITH (NOLOCK)
		WHERE report_name = 'COA -> Delete QBO Account'
			AND category_name = 'Action'
			AND APP_OBJECT_ID = @OPR_APP_OBJECT_ID
		)
BEGIN
	INSERT INTO [dbo].[XC_REPORT_MASTER]
           ([REPORT_NAME]
           ,[REPORT_URL]
           ,[CATEGORY_NAME]
           ,[CATEGORY_ORDER]
           ,[ICON_NAME]
           ,[DESCRIPTION]
           ,[APP_OBJECT_ID]
           ,[REPORT_TYPE]
           ,[REPORT_LEVEL]
           ,[TEMPLATE_REPORT]
           ,[TEMPLATE_JSON]
           ,[CONFIG_JSON]
           ,[DASHBOARD_REPORT]
           ,[IS_HELPTEXT]
           ,[HELPTEXT_CONTENT]
           ,[IS_DETAIL_VIEW]
           ,[IS_EMAIL_REQUIRED]
           ,[ACTIVE]
           ,[CREATED]
           ,[CREATED_BY]
           ,[LASTMODIFIED]
           ,[LASTMODIFIED_BY])
	VALUES (
		'COA -> Delete QBO Account'
		,''
		,'Action'
		,2
		,''
		,'Delete QBO Account'
		,@OPR_APP_OBJECT_ID
		,'NA'
		,'NA'
		,'1'
		,NULL
		,NULL
		,0
        ,NULL
        ,NULL
        ,0
        , NULL
        ,1
        ,GETDATE()
        ,1
        ,GETDATE()
        ,1
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[XC_REPORT_MASTER] WITH (NOLOCK)
		WHERE report_name = 'PCR -> View Predictions'
			AND category_name = 'Action'
			AND APP_OBJECT_ID = @OPR_APP_OBJECT_ID
		)
BEGIN
	INSERT INTO [dbo].[XC_REPORT_MASTER]
           ([REPORT_NAME]
           ,[REPORT_URL]
           ,[CATEGORY_NAME]
           ,[CATEGORY_ORDER]
           ,[ICON_NAME]
           ,[DESCRIPTION]
           ,[APP_OBJECT_ID]
           ,[REPORT_TYPE]
           ,[REPORT_LEVEL]
           ,[TEMPLATE_REPORT]
           ,[TEMPLATE_JSON]
           ,[CONFIG_JSON]
           ,[DASHBOARD_REPORT]
           ,[IS_HELPTEXT]
           ,[HELPTEXT_CONTENT]
           ,[IS_DETAIL_VIEW]
           ,[IS_EMAIL_REQUIRED]
           ,[ACTIVE]
           ,[CREATED]
           ,[CREATED_BY]
           ,[LASTMODIFIED]
           ,[LASTMODIFIED_BY])
	VALUES (
		'PCR -> View Predictions'
		,''
		,'Action'
		,2
		,''
		,'View Predicted Categories'
		,@OPR_APP_OBJECT_ID
		,'NA'
		,'NA'
		,'1'
		,NULL
		,NULL
		,0
        ,NULL
        ,NULL
        ,0
        , NULL
        ,1
        ,GETDATE()
        ,1
        ,GETDATE()
        ,1
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[XC_REPORT_MASTER] WITH (NOLOCK)
		WHERE report_name = 'PCR -> Update Suggested Category To Product'
			AND category_name = 'Action'
			AND APP_OBJECT_ID = @OPR_APP_OBJECT_ID
		)
BEGIN
	INSERT INTO [dbo].[XC_REPORT_MASTER]
           ([REPORT_NAME]
           ,[REPORT_URL]
           ,[CATEGORY_NAME]
           ,[CATEGORY_ORDER]
           ,[ICON_NAME]
           ,[DESCRIPTION]
           ,[APP_OBJECT_ID]
           ,[REPORT_TYPE]
           ,[REPORT_LEVEL]
           ,[TEMPLATE_REPORT]
           ,[TEMPLATE_JSON]
           ,[CONFIG_JSON]
           ,[DASHBOARD_REPORT]
           ,[IS_HELPTEXT]
           ,[HELPTEXT_CONTENT]
           ,[IS_DETAIL_VIEW]
           ,[IS_EMAIL_REQUIRED]
           ,[ACTIVE]
           ,[CREATED]
           ,[CREATED_BY]
           ,[LASTMODIFIED]
           ,[LASTMODIFIED_BY])
	VALUES (
		'PCR -> Update Suggested Category To Product'
		,''
		,'Action'
		,2
		,''
		,'Update Predicted Categories to Product'
		,@OPR_APP_OBJECT_ID
		,'NA'
		,'NA'
		,'1'
		,NULL
		,NULL
		,0
        ,NULL
        ,NULL
        ,0
        , NULL
        ,1
        ,GETDATE()
        ,1
        ,GETDATE()
        ,1
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[XC_REPORT_MASTER] WITH (NOLOCK)
		WHERE report_name = 'PCR -> Edit Existing Category'
			AND category_name = 'Action'
			AND APP_OBJECT_ID = @OPR_APP_OBJECT_ID
		)
BEGIN
	INSERT INTO [dbo].[XC_REPORT_MASTER]
           ([REPORT_NAME]
           ,[REPORT_URL]
           ,[CATEGORY_NAME]
           ,[CATEGORY_ORDER]
           ,[ICON_NAME]
           ,[DESCRIPTION]
           ,[APP_OBJECT_ID]
           ,[REPORT_TYPE]
           ,[REPORT_LEVEL]
           ,[TEMPLATE_REPORT]
           ,[TEMPLATE_JSON]
           ,[CONFIG_JSON]
           ,[DASHBOARD_REPORT]
           ,[IS_HELPTEXT]
           ,[HELPTEXT_CONTENT]
           ,[IS_DETAIL_VIEW]
           ,[IS_EMAIL_REQUIRED]
           ,[ACTIVE]
           ,[CREATED]
           ,[CREATED_BY]
           ,[LASTMODIFIED]
           ,[LASTMODIFIED_BY])
	VALUES (
		'PCR -> Edit Existing Category'
		,''
		,'Action'
		,2
		,''
		,'Edit Existing Category'
		,@OPR_APP_OBJECT_ID
		,'NA'
		,'NA'
		,'1'
		,NULL
		,NULL
		,0
        ,NULL
        ,NULL
        ,0
        , NULL
        ,1
        ,GETDATE()
        ,1
        ,GETDATE()
        ,1
		)
END
GO
--changeset Mano : 84
--comment RIO-890 | Display a snack bar when the offline AvT report is completed or fails
IF NOT EXISTS (
			SELECT 1
			FROM dbo.XC_APPCONFIG WITH (NOLOCK)
			WHERE CONFIGKEY='SA_OFFLINE_REPORT_FETCH_INTERVAL'
			)
BEGIN
	INSERT INTO dbo.XC_APPCONFIG (
		 CONFIGKEY
		,CONFIGVALUE
		)
	VALUES (
		'SA_OFFLINE_REPORT_FETCH_INTERVAL'
		,'60000'
		)
END
ELSE
BEGIN
	UPDATE dbo.XC_APPCONFIG SET CONFIGVALUE = '60000' WHERE CONFIGKEY='SA_OFFLINE_REPORT_FETCH_INTERVAL'
END
GO

--changeset Divya : 97
--comment BOOK-112 | Update the gl detail type meta data
IF EXISTS (
		SELECT 1
		FROM [DBO].[SA_BOOKS_STANDARD_COA_MASTER] WITH (NOLOCK)
		WHERE GL_Type = 'Income'
		)
BEGIN
	UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'SalesOfProductIncome'
    WHERE GL_Code in ('4100' ,'4101', '4102', '4103', '4104','4105','4111')

    UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'ServiceFeeIncome'
    WHERE GL_Code in ('4112' ,'4114')

    UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'OtherPrimaryIncome'
    WHERE GL_Code = 4113

    UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'DiscountsRefundsGiven'
    WHERE GL_Code = 4115

END
GO

IF EXISTS (
		SELECT 1
		FROM [DBO].[SA_BOOKS_STANDARD_COA_MASTER] WITH (NOLOCK)
		WHERE GL_Type = 'Cost of Goods Sold'
		)
BEGIN
	UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'SuppliesMaterialsCogs'
    WHERE GL_Code in ('5100' ,'5101', '5102', '5103', '5104','5105','5110')
END
GO

IF EXISTS (
		SELECT 1
		FROM [DBO].[SA_BOOKS_STANDARD_COA_MASTER] WITH (NOLOCK)
		WHERE GL_Type = 'Expense'
		)
BEGIN
	UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'PayrollExpenses'
    WHERE GL_Code in ('6100' ,'6101', '6102', '6103', '6104','6105',
    '6106','6107' ,'6108', '6109', '6110', '6130','6131','6132','6133')

    UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'PayrollTaxExpenses'
    WHERE GL_Code in ('6120' ,'6121', '6122', '6123', '6124','6125')

    UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'OtherBusinessExpenses'
    WHERE GL_Code in ('7000' ,'7100', '7101', '7102', '7103','7104',
    '7105','7106' ,'7107', '7108', '7109', '7110','7111','7112','7113', '7114', '8300' 
    ,'8301', '8302')

    UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'RentOrLeaseOfBuildings'
    WHERE GL_Code in ('7200' ,'7201', '7202')

    UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'Insurance'
    WHERE GL_Code = '7203'

    UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'Utilities'
    WHERE GL_Code in ('7300' ,'7301', '7302','7303' ,'7304', '7305')

    UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'RepairMaintenance'
    WHERE GL_Code in ('7400' ,'7401', '7402','7403' ,'7404')

    UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'AdvertisingPromotional'
    WHERE GL_Code in ('8100' ,'8101', '8102','8103' ,'8104','8105','8106')

    UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'OfficeGeneralAdministrativeExpenses'
    WHERE GL_Code in ('8200' ,'8201', '8202','8203' ,'8204','8205','8206',
    '8207' ,'8208', '8209','8210' ,'8211','8212','8213', '8214' ,'8215', 
    '8216','8217' ,'8218','8219','8220','8221','8222' ,'8223','8224') 

    UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'TaxesPaid'
    WHERE GL_Code in ('8400' ,'8401', '8402','8403')
END
GO

IF EXISTS (
		SELECT 1
		FROM [DBO].[SA_BOOKS_STANDARD_COA_MASTER] WITH (NOLOCK)
		WHERE GL_Type = 'Other Income'
		)
BEGIN
	UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'InterestEarned'
    WHERE GL_Code = '9101'

    UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'OtherMiscellaneousIncome'
    WHERE GL_Code in ('9102','9103','9104','9105','9100')   
END
GO

IF EXISTS (
		SELECT 1
		FROM [DBO].[SA_BOOKS_STANDARD_COA_MASTER] WITH (NOLOCK)
		WHERE GL_Type = 'Other Expense'
		)
BEGIN
    UPDATE [DBO].[SA_BOOKS_STANDARD_COA_MASTER]
	SET GL_Detail_Type = 'OtherMiscellaneousExpense'
    WHERE GL_Code in ('9201','9202','9203','9204','9205','9206','9200')   
END
GO

--changeset Ramkumar : 103
--comment PET-493 | SA - Containerization - Workflow
IF EXISTS (
		SELECT '1'
		FROM XC_APPCONFIG WITH (NOLOCK)
		WHERE configkey = 'USER_LOGIN_LINK'
			AND configvalue LIKE '%bpo.xtrachef.com%'
		)
BEGIN 

	UPDATE xc_appconfig SET CONFIGVALUE='http://internal-sa-api-inv-workflow-lb-dev-170090208.us-east-1.elb.amazonaws.com/XtraChefWorkFlow.xamlx'
	WHERE CONFIGKEY='WorkFlow_Url'

END
GO

IF EXISTS (
		SELECT '1'
		FROM XC_APPCONFIG WITH (NOLOCK)
		WHERE configkey = 'USER_LOGIN_LINK'
			AND configvalue LIKE '%preprod.xtrachef.com%'
		)
BEGIN 

	UPDATE xc_appconfig SET CONFIGVALUE='http://internal-sa-api-inv-workflow-lb-preprod-1041043038.us-east-1.elb.amazonaws.com/XtraChefWorkFlow.xamlx'
	WHERE CONFIGKEY='WorkFlow_Url'

END
GO

IF EXISTS (
		SELECT '1'
		FROM XC_APPCONFIG WITH (NOLOCK)
		WHERE configkey = 'USER_LOGIN_LINK'
			AND configvalue LIKE '%app.xtrachef.com%'
		)
BEGIN 

	UPDATE xc_appconfig SET CONFIGVALUE='http://internal-sa-api-inv-workflow-lb-prod-983627625.us-east-1.elb.amazonaws.com/XtraChefWorkFlow.xamlx'
	WHERE CONFIGKEY='WorkFlow_Url'

END
GO
--changeset Ramkumar : 104
--comment PET-493 | SA - Containerization - Workflow


IF EXISTS (
		SELECT '1'
		FROM XC_APPCONFIG WITH (NOLOCK)
		WHERE configkey = 'USER_LOGIN_LINK'
			AND configvalue LIKE '%app.xtrachef.com%'
		)
BEGIN 

	UPDATE xc_appconfig SET CONFIGVALUE='http://internal-sa-api-inv-workflow-lb-prod-871089897.us-east-1.elb.amazonaws.com/XtraChefWorkFlow.xamlx'
	WHERE CONFIGKEY='WorkFlow_Url'

END
GO