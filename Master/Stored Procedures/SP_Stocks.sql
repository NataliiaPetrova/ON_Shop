
CREATE     PROCEDURE [Master].[SP_Stocks]
AS

BEGIN TRY 

DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT

 -- logging events
	EXECUTE Logs.SP_EventR @EventProcName, @rowcount 

	INSERT INTO Master.Stocks(ProductID, Price, StartVersion)
		SELECT ProductID, 
			   Price, 
			   IDENT_CURRENT('[Master].VersionConfigs') AS StartVersion
			FROM Staging.NewDeliveries

			SET @RowCount = (SELECT @@ROWCOUNT)  

			
	TRUNCATE TABLE Staging.NewDeliveries
	
  -- completing logging
	EXECUTE Logs.SP_EventC @EventProcName, @rowcount 
END TRY 

BEGIN CATCH

DECLARE 
@ErrorMessage nvarchar (max) = ERROR_MESSAGE(),
@ErrorNumber int = ERROR_NUMBER(),
@ErrortProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

EXEC [Logs].[SP_Errors]  @ErrortProcName=@ErrortProcName, @ErrorMessage = @ErrorMessage, @ErrorNumber =  @ErrorNumber 

END CATCH;