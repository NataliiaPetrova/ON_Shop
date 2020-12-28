
CREATE     PROC [Logs].[SP_Errors]
@OperationRunID INT = NULL,
@ErrorMessage NVARCHAR(max) = NULL,
@ErrorNumber INT = NULL,
@ErrortProcName VARCHAR(250) = NULL 

AS

BEGIN
DECLARE 
@ErrorSeverity INT =ERROR_SEVERITY(),  
@ErrorState INT =ERROR_STATE()



INSERT INTO [Logs].[ErrorLogs]
(   [OperationRunID],
	[EventID],
	[ErrortProcName],
	[ErrorDataTime],
	[ErrorLine],
	[ErrorNumber],
	[ErrorSeverity],
	[ErrorState],
	[ErrorMessage]
)  
SELECT  
IDENT_CURRENT('Logs.OperationRuns'),
IDENT_CURRENT('Logs.EventLogs'),
--ERROR_PROCEDURE() as 'Proc', 
@ErrortProcName,
GETDATE () as DateErrorRaised, 
ERROR_LINE () as ErrorLine,  
@ErrorNumber,  
Error_Severity() as ErrorSeverity,  
Error_State() as ErrorState,  
@ErrorMessage
;
RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END  
