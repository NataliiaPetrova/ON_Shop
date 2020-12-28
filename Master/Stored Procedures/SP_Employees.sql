CREATE    PROCEDURE [Master].[SP_Employees]
as

BEGIN TRY

DECLARE @EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)
DECLARE @ROWCOUNT int

EXECUTE Logs.SP_EventR @EventProcName, @rowcount

IF NOT EXISTS (SELECT TOP (1) EmployeeID FROM master.Employees)
BEGIN
BULK INSERT master.Employees
FROM  'C:\Users\npetrov\source\repos\OnShop\Inserts\Employees.csv'
WITH (FIRSTROW = 2,
    FIELDTERMINATOR = ',',
	ROWTERMINATOR='\n' );


SET @ROWCOUNT += (SELECT @@ROWCOUNT)

END 

EXECUTE Logs.SP_EventC @EventProcName, @rowcount 

END TRY 

BEGIN CATCH

DECLARE 
@ErrorMessage nvarchar (max) = ERROR_MESSAGE(),
@ErrorNumber int = ERROR_NUMBER(),
@ErrortProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

EXEC [Logs].[SP_Errors]  @ErrortProcName=@ErrortProcName, @ErrorMessage = @ErrorMessage, @ErrorNumber =  @ErrorNumber 

END CATCH;