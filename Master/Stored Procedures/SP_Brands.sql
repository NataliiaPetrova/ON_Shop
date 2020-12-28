CREATE     PROCEDURE [Master].[SP_Brands]
as

BEGIN TRY

DECLARE @EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)
DECLARE @ROWCOUNT int

EXECUTE Logs.SP_EventR @EventProcName, @rowcount

IF NOT EXISTS (SELECT TOP (1) BrandID FROM master.Brands)
BEGIN
	INSERT INTO Master.Brands (BrandName)
	VALUES
	('DunkinDonuts'),
	('Luwak'),
	('Folgers'),
	('GreenMountainRoaster'),
	('PeetsCoffee'),
	('HaciendaLaEsmeralda'),
	('LaColombe'),
	('JustBright'),
	('Melitta')


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