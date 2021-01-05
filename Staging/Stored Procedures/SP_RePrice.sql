--========================================================================================================--
/*
	   Object:				StoredProcedure [Master].[SP_RePrice]  
	   Script Date:			05.01.2021 16:50:55 
	   Short Description:	Executing procedures to create newdelivery with new price, version 
							and inserting everything in master.stocks table
	   Scripted by:			LV4097\NATALIIAPETROVA
*/
--========================================================================================================--


CREATE PROCEDURE [Master].[SP_RePrice]
AS
BEGIN TRY 
	DECLARE
	@CurrentRunID INT,
	@CurrentEventID INT

	-- Populating 'Operation status' table without logging
	EXECUTE Logs.SP_OperationStatus

	-- Starting 'OperationRuns' process:
	-- Creating new OperationRunID and creating new record in 'Logs.EventLogs' 
	EXECUTE Logs.SP_OperationRunsR

	 
	EXEC [Staging].[SP_PriceChange]
	EXEC [Staging].[SP_VersionDelivery]
	EXEC [Master].[SP_StocksPrice]


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