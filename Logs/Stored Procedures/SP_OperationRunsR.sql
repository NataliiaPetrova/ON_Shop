CREATE     PROCEDURE [Logs].[SP_OperationRunsR]
@OperationRunID INT = NULL OUTPUT 
AS

BEGIN
	DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@rowcount INT
	
		-- Create new 'OperationRunID' and add information about current status and start time.
		INSERT INTO Logs.OperationRuns (StatusID)
		VALUES
		((SELECT OperationStatusID FROM Logs.OperationsStatuses WHERE Status = 'R'))	
			
	-- Create event on 'OperationRuns' process start
		INSERT INTO Logs.EventLogs (OperationRunID, EventProcName, EventStatusID, AffectedRows, EventMessage)
		SELECT 
			IDENT_CURRENT('Logs.OperationRuns') AS OperationRunID,
			@EventProcName AS EventProcName,
			(SELECT OperationStatusID FROM Logs.OperationsStatuses WHERE Status = 'R') AS EventStatusID,
			@rowcount AS AffectedRows,
			'Running' AS EventMessage
		
END;