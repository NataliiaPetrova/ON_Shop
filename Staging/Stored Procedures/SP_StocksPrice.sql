--========================================================================================================--
/*
	   Object:				StoredProcedure [Staging].[SP_StocksPrice]   
	   Script Date:			05.01.2021 16:50:55 
	   Short Description:	Populating Stocks with items with changed price from Staging.NewDeliveries
							and closing previous version  
	   Scripted by:			LV4097\NATALIIAPETROVA
*/
--========================================================================================================--

CREATE   PROCEDURE [Master].[SP_StocksPrice]
AS

BEGIN TRY 

	DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT = 0

	-- logging events
	EXECUTE Logs.SP_EventR @EventProcName, @rowcount 

	INSERT INTO Master.Stocks(ProductID, Price, StartVersion)
		SELECT ProductID, 
			   Price, 
			   IDENT_CURRENT('[Master].VersionConfigs') AS StartVersion
		FROM Staging.NewDeliveries

	SET @ROWCOUNT += (SELECT @@ROWCOUNT)

	MERGE Master.Stocks AS target 
		USING ##Stocks AS source 
		ON (target.stockid = source.stockid)
			WHEN MATCHED 
    THEN
	UPDATE SET EndVersion = IDENT_CURRENT('Master.VersionConfigs');  

			
	TRUNCATE TABLE Staging.NewDeliveries
	
	-- completing logging
	EXECUTE Logs.SP_EventC @EventProcName, @rowcount 

END TRY 

BEGIN CATCH

	DECLARE 
	@ErrorMessage nvarchar (max) = ERROR_MESSAGE(),
	@ErrorNumber int = ERROR_NUMBER(),
	@ErrortProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

EXEC [Logs].[SP_Errors]  @ErrortProcName=@ErrortProcName, @ErrorMessage = @ErrorMessage, @ErrorNumber =  @ErrorNumber 

END CATCH;