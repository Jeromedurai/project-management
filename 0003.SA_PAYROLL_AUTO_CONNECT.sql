-- liquibase formatted sql 

--changeset Vinoth: 2
--comment - BIT-1300 | Enable journal posting for auto-onboarded payroll tenant

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SA_PAYROLL_AUTO_CONNECT]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SA_PAYROLL_AUTO_CONNECT]
GO

CREATE PROCEDURE [DBO].[SA_PAYROLL_AUTO_CONNECT]
( 
	@TENANT_ID BIGINT 
	,@ECCUSTOMERUUID VARCHAR(36) 
	,@PAYROLLINITIATIONDATE VARCHAR(10) 
) 
AS 
BEGIN 
	SET NOCOUNT ON 
 
	DROP TABLE IF EXISTS #CONFIGKEYTABLE 
 
	DECLARE @TENANT_ID_IP BIGINT 
		,@PAYROLLINITIATIONDATE_IP VARCHAR(10) 
		,@CURRENT_DATE DATETIME 
		,@ECCUSTOMERUUID_IP VARCHAR(36) 
 
	SELECT @TENANT_ID_IP = @TENANT_ID 
		,@PAYROLLINITIATIONDATE_IP = @PAYROLLINITIATIONDATE 
		,@CURRENT_DATE = GETDATE() 
		,@ECCUSTOMERUUID_IP = @ECCUSTOMERUUID 
 
	IF EXISTS ( 
			SELECT 1 
			FROM DBO.[XC_TENANT] WITH (NOLOCK) 
			WHERE TENANT_ID = @TENANT_ID_IP 
				AND ( 
					ECTenantUuid = @ECCUSTOMERUUID_IP 
					OR ECTenantUuid > '' 
					) 
			) 
	BEGIN 
		SELECT ECTenantUuid AS 'OldCustomerUuid' 
			,@ECCUSTOMERUUID_IP AS 'NewCustomerUuid' 
		FROM DBO.[XC_TENANT] WITH (NOLOCK) 
		WHERE TENANT_ID = @TENANT_ID_IP 
			AND ( 
				ECTenantUuid = @ECCUSTOMERUUID_IP 
				) 
	END 
	ELSE 
	BEGIN 
 
		CREATE TABLE #CONFIGKEYTABLE ( 
		CONFIG_KEY NVARCHAR(510) 
		,CONFIG_VALUE VARCHAR(MAX) 
		) 
	  BEGIN TRANSACTION trans 
 
		UPDATE dbo.[XC_TENANT] 
		SET ECTenantUuid = @ECCUSTOMERUUID_IP 
		,MODIFIED_ON = @CURRENT_DATE 
		WHERE TENANT_ID = @TENANT_ID_IP 
	 
		INSERT INTO #CONFIGKEYTABLE 
		VALUES ( 
			'ENABLE_PAYROLL' 
			,'TRUE' 
			)
            ,(
            'PAYROLL_START_DATE'
            ,FORMAT(@CURRENT_DATE, 'yyyy-MM-ddTHH:mm:ss.fffZ')
            ) 
			,( 
			'ENABLE_PAYROLL_POSTING' 
			,'TRUE' 
			) 
			,( 
			'PayrollInitiationDate' 
			,@PAYROLLINITIATIONDATE_IP 
			) 
			,( 
			'NextPayrollRetryDate' 
			,'' 
			) 
 
		UPDATE XTC 
		SET XTC.CONFIG_VALUE = CKT.CONFIG_VALUE 
			,XTC.MODIFIED_ON = @CURRENT_DATE 
		FROM [DBO].[XC_TENANT_CONFIG] XTC 
		INNER JOIN #CONFIGKEYTABLE CKT ON XTC.CONFIG_KEY = CKT.CONFIG_KEY 
		WHERE XTC.TENANT_ID = @TENANT_ID_IP 
 
		INSERT INTO [DBO].[XC_TENANT_CONFIG] ( 
			TENANT_ID 
			,CONFIG_KEY 
			,CONFIG_VALUE 
			,CREATED_ON 
			,MODIFIED_ON 
			,CONFIG_VALUE_DESCRIPTION 
			) 
		SELECT @TENANT_ID_IP 
			,CKT.CONFIG_KEY 
			,CKT.CONFIG_VALUE 
			,@CURRENT_DATE 
			,@CURRENT_DATE 
			,'PAYROLL' 
		FROM #CONFIGKEYTABLE CKT 
		LEFT JOIN [DBO].[XC_TENANT_CONFIG] XCTC WITH (NOLOCK) ON CKT.CONFIG_KEY = XCTC.CONFIG_KEY 
			AND XCTC.TENANT_ID = @TENANT_ID_IP 
		WHERE XCTC.CONFIG_KEY IS NULL 
 
		 IF NOT EXISTS (   
        SELECT 1 FROM [DBO].[XC_TENANT_ACCESS_PACKAGE] WITH (NOLOCK)  
		WHERE PackageCode = 'XC_ADD_PAYROLL_SETUP' AND TENANTID = @TENANT_ID_IP   
        )   
        BEGIN   
            INSERT INTO [dbo].[XC_TENANT_ACCESS_PACKAGE]   
            (    
                TenantId   
                ,LocationId   
                ,PackageCode   
                ,Created   
                ,CreatedBy   
                ,LastModified   
                ,LastModifiedBy   
            )   
            VALUES   
            (    
                @TENANT_ID_IP   
                ,0   
                ,'XC_ADD_PAYROLL_SETUP'   
                ,@CURRENT_DATE   
                ,1   
                ,@CURRENT_DATE   
                ,1   
            )   
        END   
 
	IF @@Trancount > 0  
	BEGIN 
	COMMIT TRANSACTION trans 
	END 
 
		SELECT @ECCUSTOMERUUID_IP AS 'NewCustomerUuid' 
			,'' AS 'OldCustomerUuid' 
		 
		DROP TABLE IF EXISTS #CONFIGKEYTABLE 
 
	END 
	SET NOCOUNT OFF 
END
GO