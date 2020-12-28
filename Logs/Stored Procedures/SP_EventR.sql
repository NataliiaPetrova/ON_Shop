CREATE     PROCEDURE [Logs].[SP_EventR](
@EventProcName  VARCHAR(250),
@rowcount int
)
AS
BEGIN
	-- Create event on  @EventProcName process start
	INSERT INTO Logs.EventLogs (OperationRunID, EventProcName, EventStatusID, AffectedRows, EventMessage)
	SELECT 
		IDENT_CURRENT('Logs.OperationRuns') AS OperationRunID,
		@EventProcName AS EventProcName,
		(SELECT OperationStatusID FROM Logs.OperationsStatuses WHERE Status = 'R') AS EventStatusID,
		@rowcount AS AffectedRows,
		@EventProcName+' '+'process is running' AS EventMessage
END;
