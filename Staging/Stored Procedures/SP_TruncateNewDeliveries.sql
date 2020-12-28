CREATE     PROCEDURE [Staging].[SP_TruncateNewDeliveries]
AS
	DECLARE @rows INT

	SET @rows = (SELECT COUNT(*) FROM Staging.NewDeliveries)

	IF @rows > 0 
	BEGIN TRY 
		TRUNCATE TABLE Staging.NewDeliveries
	END TRY
  
  BEGIN CATCH

DECLARE 
@ErrorMessage nvarchar (max) = ERROR_MESSAGE(),
@ErrorNumber int = ERROR_NUMBER(),
@ErrortProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

EXEC [Logs].[SP_Errors]  @ErrortProcName=@ErrortProcName, @ErrorMessage = @ErrorMessage, @ErrorNumber =  @ErrorNumber 

END CATCH;