CREATE     PROCEDURE [Logs].[SP_Operations]
as

BEGIN TRY

DECLARE @EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)
DECLARE @ROWCOUNT int

EXECUTE Logs.SP_EventR @EventProcName, @rowcount 

IF NOT EXISTS (SELECT TOP (1) OperationID FROM logs.Operations)
BEGIN
	INSERT INTO logs.Operations
	( OperationName, OperationDescription)
	VALUES
	('Running', 'Operation is currently running'),
	('Completed', 'Operation is successfully completed'),
	('Failed', 'Operation has failed')


SET @rowcount=(SELECT @@ROWCOUNT)

END 

EXECUTE Logs.SP_EventC @EventProcName, @rowcount 

END TRY 

BEGIN CATCH

DECLARE 
@ErrorMessage nvarchar (max) = ERROR_MESSAGE(),
@ErrorNumber int = ERROR_NUMBER(),
@ErrortProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

EXEC [Logs].[SP_Errors]  @ErrortProcName=@ErrortProcName, @ErrorMessage = @ErrorMessage, @ErrorNumber =  @ErrorNumber 

END CATCH