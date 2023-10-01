-- liquibase formatted sql 

--changeset Dharanivel: 3
--comment - RIO-994 | modified the active condition for recipe user

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SA_GET_RECIPE_DETAIL]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SA_GET_RECIPE_DETAIL]
GO
CREATE PROCEDURE [DBO].[SA_GET_RECIPE_DETAIL]
(
	@RECIPEID BIGINT
   ,@TENANTID BIGINT
   ,@LOCATIONID BIGINT
) AS
BEGIN
	SET NOCOUNT ON

	DECLARE @RECIPEID_IP BIGINT = @RECIPEID
   ,@TENANTID_IP BIGINT = @TENANTID
   ,@LOCATIONID_IP BIGINT = @LOCATIONID
   ,@AssociatedRecipeCount INT
   ,@BucketName VARCHAR(200)

    SELECT @BucketName = BUCKET_NAME
	FROM [dbo].[XC_S3BUCKETS] WITH (NOLOCK)
	WHERE TENANT_ID = @TENANTID_IP

    SELECT @AssociatedRecipeCount = COUNT(DISTINCT R.[Pk])
    FROM [dbo].[XC_RECIPE] AS R WITH (NOLOCK)  
    INNER JOIN [dbo].[XC_RECIPE_INGREDIENTS] AS RI WITH (NOLOCK) ON RI.RecipeId = R.Pk
    WHERE R.TenantId = @TENANTID_IP  
     AND R.LocationId = @LOCATIONID_IP  
     AND R.Active = '1'  
     AND RI.[Type] = 'PrepRecipe'  
     AND RI.ReferenceId = @RECIPEID_IP  
     AND RI.Active = '1'  
     AND RI.[Classification] = 1  

   SELECT R.Pk AS 'Id'
         ,R.[Guid] AS 'Guid'
		 ,R.[Name] AS 'Name'
		 ,CASE
			WHEN R.Published = '1' THEN 'Complete'
			WHEN R.Published = '2' THEN 'Not Started'
			ELSE 'Draft'
		  END AS 'Status'
		 ,R.LastModified
		 ,CASE
			WHEN U.IS_SYSTEM_USER = 1 THEN 'System User'
			ELSE ISNULL(U.FIRST_NAME+' '+U.LAST_NAME, '')
		  END AS 'LastModifiedBy'
		 ,R.MenuPrice
		 ,R.Category
		 ,R.[Type] AS 'RecipeGroup'
		 ,R.ExternalMenuItemGuid
		 ,R.PrepRecipeYield
		 ,R.PrepRecipeYieldUom AS 'PrepRecipeYieldUomId'
		 ,UM.UOM AS 'PrepRecipeYieldUomName'
		 ,R.PrepRecipeYieldPercentage
		 ,R.ShelfLife
		 ,R.ShelfLifeUom
		 ,R.[Description] AS 'Description'
		 ,RI.Pk AS 'IngredientId'
		 ,RI.ReferenceId
		 ,RI.ReferenceGuid
		 ,RI.[Type] AS 'IngredientType'
		 ,CASE
			WHEN RI.[Type] = 'Group' THEN PG.[Name]
			ELSE RN.[Name]
		  END AS 'IngredientName'
		 ,RI.MeasurementSize
		 ,RI.MeasurementUomId
		 ,RI.PYield
		 ,RI.UsableYield
		 ,RUM.[Name] AS 'MeasurementUomName'
		 ,R.S3Reference
		 ,R.InstructionJSON
		 ,R.PrepTime
		 ,R.PrepTimeUOM
		 ,R.CookTime
		 ,R.CookTimeUOM
		 ,R.AllergensJSON
		 ,R.ToolJSON
		 ,@AssociatedRecipeCount AS 'AssociatedRecipeCount'
		 ,@BucketName AS 'BucketName'
   FROM [DBO].[XC_RECIPE] R WITH(NOLOCK)
   LEFT JOIN [DBO].[XC_RECIPE_INGREDIENTS] RI WITH(NOLOCK) ON RI.RecipeId = R.Pk AND RI.Active = '1' AND RI.[Classification] = 1
   LEFT JOIN [DBO].[XC_RECIPE_UOM_MASTER] RUM WITH(NOLOCK) ON RUM.Pk = RI.MeasurementUomId AND RUM.Active = '1'
   LEFT JOIN [DBO].[XC_USER] U WITH(NOLOCK) ON U.[USER_ID] = R.LastModifiedBy
   LEFT JOIN [DBO].[XC_UOM_MASTER] UM WITH(NOLOCK) ON UM.ID = R.PrepRecipeYieldUom
   LEFT JOIN [DBO].[XC_RECIPE] RN WITH(NOLOCK) ON CAST(RN.Pk AS VARCHAR(36)) = RI.ReferenceId AND RN.Active = '1'
   LEFT JOIN [DBO].[XC_PRODUCT_GROUP] PG WITH(NOLOCK) ON PG.[Guid] = RI.ReferenceGuid AND PG.Active = 1
   WHERE R.TenantId = @TENANTID_IP
   AND R.LocationId = @LOCATIONID_IP
   AND R.Pk = @RECIPEID_IP
   AND R.Active = '1'
   ORDER BY RI.SequenceNo

   SET NOCOUNT OFF
END
GO