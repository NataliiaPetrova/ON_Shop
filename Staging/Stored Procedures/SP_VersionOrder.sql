CREATE    PROCEDURE [Staging].[SP_VersionOrder](
@OrderID INT
)
AS

BEGIN TRY 

DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT

    -- logging events
	EXECUTE Logs.SP_EventR @EventProcName, @rowcount 

INSERT INTO [Master].VersionConfigs (VersionDateTime, OperationRunID)
	SELECT OrderDate, 
		   IDENT_CURRENT('Logs.OperationRuns') AS OperationRunID 
		FROM Master.Orders
		WHERE OrderID = @OrderID
	
		SET @RowCount = (SELECT @@ROWCOUNT)  -- Calculate and save how many rows were populeted

    -- completing logging
	EXECUTE Logs.SP_EventR @EventProcName, @rowcount 

END TRY

BEGIN CATCH

DECLARE 
@ErrorMessage nvarchar (max) = ERROR_MESSAGE(),
@ErrorNumber int = ERROR_NUMBER(),
@ErrortProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

EXEC [Logs].[SP_Errors]  @ErrortProcName=@ErrortProcName, @ErrorMessage = @ErrorMessage, @ErrorNumber =  @ErrorNumber 

END CATCH;;
