﻿--========================================================================================================--
/*
	   Object:				StoredProcedure [Master].[SP_ReStocking]  
	   Short Description:   For launching procedures that are populating newdelivery table,
							creating version and populating stock table. Loging and error handling
	   Script Date:			28.12.2020 16:50:55 
	   Scripted by:			LV4097\NATALIIAPETROVA
*/
--========================================================================================================--

CREATE    PROCEDURE [Master].[SP_ReStocking]
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

	 
	  EXEC [Staging].[SP_CreateNewDelivery]
	  EXEC [Staging].[SP_VersionDelivery]
	  EXEC [Master].[SP_Stocks]    
	

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
