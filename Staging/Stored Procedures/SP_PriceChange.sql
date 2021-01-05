--========================================================================================================--
/*
	   Object:				StoredProcedure [Staging].[SP_PriceChange]   
	   Script Date:			05.01.2021 16:50:55 
	   Short Description:	Gathering random data from stocks and inserting into Staging.NewDeliveries
	   Scripted by:			LV4097\NATALIIAPETROVA
*/
--========================================================================================================--

CREATE PROCEDURE [Staging].[SP_PriceChange]
AS

BEGIN TRY 
DECLARE @DeliveryDate date = getdate(),
		@StockID int,
		@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	    @RowCount INT = 0

		-- logging events
		EXECUTE Logs.SP_EventR @EventProcName, @rowcount
		
		DROP TABLE IF EXISTS ##Stocks 
		CREATE TABLE ##Stocks 
			(
			[StockID] [int] NOT NULL,
			[ProductID] [int] NULL,
			[Price] [money] NULL,
			[EndVersion] [int] default 999999999,
			[StartVersion] [int] NULL
			)

		INSERT INTO ##Stocks (
				[StockID],
				[ProductID],
				[Price],
				[EndVersion],
				[StartVersion] )
		SELECT TOP(10)
				[StockID],
				[ProductID],
				[Price] as [Price],
				[EndVersion],
				[StartVersion]
		FROM MASTER.Stocks
				where endversion = 999999999
				ORDER BY NEWID();

						INSERT INTO Staging.NewDeliveries  (ProductID, Price, NewDeliveryDate)
							SELECT TOP(10)
								[ProductID],
								[Price]*1.2 as [Price],
								@DeliveryDate  AS DeliveryDate
						FROM ##Stocks
								ORDER BY NEWID();
								set @rowcount+=@@rowcount
	EXECUTE Logs.SP_EventC @EventProcName, @rowcount

	
END TRY 

BEGIN CATCH

	DECLARE 
	@ErrorMessage nvarchar (max) = ERROR_MESSAGE(),
	@ErrorNumber int = ERROR_NUMBER(),
	@ErrortProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

	EXEC [Logs].[SP_Errors]  @ErrortProcName=@ErrortProcName, @ErrorMessage = @ErrorMessage, @ErrorNumber =  @ErrorNumber 

END CATCH;