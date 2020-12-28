CREATE     PROCEDURE [Logs].[SP_EventC](
@EventProcName  VARCHAR(250),
@rowcount int
)
AS
BEGIN
	-- Create event on @EventProcName process complete
	INSERT INTO Logs.EventLogs (OperationRunID, EventProcName, EventStatusID, AffectedRows, EventMessage)
	SELECT 
		IDENT_CURRENT('Logs.OperationRuns') AS OperationRunID,
		@EventProcName AS EventProcName,
		(SELECT OperationStatusID FROM Logs.OperationsStatuses WHERE Status = 'C') AS EventStatusID,
		@rowcount AS AffectedRows,
		@EventProcName+' '+'process is completed' AS EventMessage
END;
