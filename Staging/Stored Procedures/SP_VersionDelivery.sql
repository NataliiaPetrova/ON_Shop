/****** Object:  StoredProcedure [Staging].[SP_VersionDelivery]    Script Date: 28.12.2020 16:44:46 ******/

SET NOCOUNT ON
GO

CREATE PROCEDURE [Staging].[SP_VersionDelivery]
AS

BEGIN TRY 

	DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT

	-- logging events
	EXECUTE Logs.SP_EventR @EventProcName, @rowcount 

	INSERT INTO [Master].VersionConfigs (VersionDateTime, OperationRunID)

		SELECT NewDeliveryDate, 
			   IDENT_CURRENT('Logs.OperationRuns') AS OperationRunID
		FROM Staging.NewDeliveries
	
	-- Calculate and save how many rows were populeted
	SET @RowCount = (SELECT @@ROWCOUNT)  

	-- completing logging
	EXECUTE Logs.SP_EventC @EventProcName, @rowcount 

END TRY 

--logging errors
BEGIN CATCH

	DECLARE 
	@ErrorMessage nvarchar (max) = ERROR_MESSAGE(),
	@ErrorNumber int = ERROR_NUMBER(),
	@ErrortProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

	EXEC [Logs].[SP_Errors]  @ErrortProcName=@ErrortProcName, @ErrorMessage = @ErrorMessage, @ErrorNumber =  @ErrorNumber 

END CATCH;

