﻿

CREATE    PROCEDURE [Staging].[SP_NewDelivery]
AS

BEGIN TRY 

DECLARE
	@StartDate DATE,
	@CurrentProdID INT = 3,
	@LastProdID INT,
	@ProdAmount INT,
	@Counter INT,
	@RandomPrice MONEY,

	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT = 0
	
	-- logging events
	EXECUTE Logs.SP_EventR @EventProcName, @rowcount 

	-- deleting verything from NewDeliveries
	TRUNCATE TABLE  Staging.NewDeliveries

-- store all ordered products in a temporary table
	DROP TABLE IF EXISTS #AllOrders
		SELECT OrderDetails.ProductID, COUNT(*) AS AllProducts
        INTO #AllOrders
		  FROM Master.OrderDetails 
		    GROUP BY OrderDetails.ProductID
	        ORDER BY OrderDetails.ProductID
		
		

-- creating a loop to populate 'Staging.NewDeliveries'


	SELECT @StartDate = MIN(OrderDate)
	FROM Master.Orders

	SELECT @LastProdID = MAX(ProductID)
	FROM Master.Products

	WHILE @CurrentProdID <= @LastProdID
		BEGIN
			SELECT @ProdAmount = AllProducts * 1.1
				FROM #AllOrders
				WHERE ProductID = @CurrentProdID

			-- Select a random price from 100 to 500
				SET @RandomPrice = (SELECT CONVERT( DECIMAL(5, 2), 10 + (500-100)*RAND(CHECKSUM(NEWID()))))

			SET @Counter = 1
			WHILE @Counter <= @ProdAmount

                -- populating NewDeliveries table
				BEGIN
					INSERT INTO Staging.NewDeliveries(ProductID, Price, NewDeliveryDate)
					SELECT @CurrentProdID, @RandomPrice, @StartDate

					SET @RowCount = @RowCount + (SELECT @@ROWCOUNT) -- Calculate and save how many rows were populeted

				SET @Counter += 1
				END
		
		 SET @CurrentProdID +=1
		END;

    --completing event logging
	EXECUTE Logs.SP_EventC @EventProcName, @rowcount
END TRY 

BEGIN CATCH

DECLARE 
@ErrorMessage nvarchar (max) = ERROR_MESSAGE(),
@ErrorNumber int = ERROR_NUMBER(),
@ErrortProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

EXEC [Logs].[SP_Errors]  @ErrortProcName=@ErrortProcName, @ErrorMessage = @ErrorMessage, @ErrorNumber =  @ErrorNumber 

END CATCH;