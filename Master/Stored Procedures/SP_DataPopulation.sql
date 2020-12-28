CREATE    PROCEDURE [Master].[SP_DataPopulation]
AS
BEGIN TRY 
	DECLARE
	@CurrentRunID INT,
	@CurrentEventID INT

-- Populating 'Operation status' table without logging
EXECUTE Logs.SP_OperationStatus

-- Starting 'OperationRuns' process:
	-- Creating new OperationRunID and creating new record in 'Logs.OperationEvent' table
	EXECUTE Logs.SP_OperationRunsR

	  --EXEC[Logs].[SP_Operations]
	  --EXEC [Master].[SP_Customers]
      --EXEC [Master].[SP_Calendar]
      --EXEC [Master].[SP_Employees]	
      --EXEC [Master].[SP_Cities]
      --EXEC [Master].[SP_Streets]
      --EXEC [Master].[SP_Brands]	
      --EXEC [Master].[SP_Categories]
      --EXEC [Master].[SP_Payments]
	  --EXEC [Master].[SP_Products] 20
      --EXEC [Master].[SP_Deliveries]
      --EXEC [Master].[SP_Orders]
      --EXEC [Master].[SP_OrderDetails]
	  --EXEC [Staging].[SP_NewDelivery]
	  --EXEC [Staging].[SP_VersionDelivery]
	  --EXEC [Master].[SP_Stocks]    
	  EXEC [Staging].[SP_PlacingOrder] 2

-- Completing 'OperationRuns' process:
 EXECUTE Logs.SP_OperationRunsC
END TRY 


BEGIN CATCH

DECLARE 
@ErrorMessage nvarchar (max) = ERROR_MESSAGE(),
@ErrorNumber int = ERROR_NUMBER(),
@ErrortProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

EXEC [Logs].[SP_Errors]  @ErrortProcName=@ErrortProcName, @ErrorMessage = @ErrorMessage, @ErrorNumber =  @ErrorNumber 

END CATCH;
