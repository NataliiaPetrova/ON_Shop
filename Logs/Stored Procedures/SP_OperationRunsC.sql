CREATE     PROCEDURE [Logs].[SP_OperationRunsC]
@OperationRunID INT = NULL
AS
BEGIN
DECLARE
@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)
DECLARE 
@rowcount INT 
--Update 'Logs.OperationRuns' as process is completed
	UPDATE Logs.OperationRuns
		SET EndTime = CURRENT_TIMESTAMP, 
			StatusID = (SELECT OperationStatusID FROM Logs.OperationsStatuses WHERE Status = 'C'),
			OperationRunDescription = 'Completed successfully'
		WHERE OperationRunID = IDENT_CURRENT('OperationRuns')

-- Create event on 'OperationRuns' process complete
	INSERT INTO Logs.EventLogs (OperationRunID, EventProcName, EventStatusID, AffectedRows, EventMessage)
	SELECT 
		IDENT_CURRENT('Logs.OperationRuns') AS OperationRunID,
		@EventProcName AS EventProcName,
		(SELECT OperationStatusID FROM Logs.OperationsStatuses WHERE Status = 'C') AS EventStatusID,
		@rowcount AS AffectedRows,
		'Completed successfully' AS EventMessage
END;