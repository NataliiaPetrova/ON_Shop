
CREATE     PROCEDURE [Staging].[SP_PlacingOrder](
@OrderID  INT
)
AS

BEGIN TRY 

DECLARE
@StartOrderDetailID INT,
@EndOrderDetailID INT,
@CurrentOrderDetailID INT,
@CurrentStockID INT


EXECUTE [Staging].[SP_VersionOrder] @OrderID -- Create a new Version for the current order

-- SELECT 'OrderDetailID' for chosen @OrderID
	SELECT @StartOrderDetailID = MIN(OrderDetails.OrderDetailID), 
		   @EndOrderDetailID   = MAX(OrderDetails.OrderDetailID)
	FROM Master.OrderDetails 



	SET @CurrentOrderDetailID = @StartOrderDetailID

	-- selecting a current product from the 'Stock' table and update necessary fields
		WHILE @CurrentOrderDetailID <= @EndOrderDetailID
			BEGIN
				SELECT @CurrentStockID = StockID 
					FROM Master.Stocks
					WHERE 1 = 1
					  AND ProductID = (SELECT ProductID 
										FROM Master.OrderDetails
										WHERE OrderDetailID = @CurrentOrderDetailID)
					  AND EndVersion = 999999999
					ORDER BY StartVersion, StockID
					OFFSET 0 ROWS FETCH FIRST 1 ROWS ONLY

					UPDATE Master.Stocks
						SET EndVersion = IDENT_CURRENT('Master.VersionConfigs')  
						WHERE StockID = @CurrentStockID

					--UPDATE Master.OrderDetails
						--SET StockID = @CurrentStockID
						--WHERE OrderDetailID = @CurrentOrderDetailID

			  SET @CurrentOrderDetailID +=1 
			END

END TRY 

BEGIN CATCH

DECLARE 
@ErrorMessage nvarchar (max) = ERROR_MESSAGE(),
@ErrorNumber int = ERROR_NUMBER(),
@ErrortProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

EXEC [Logs].[SP_Errors]  @ErrortProcName=@ErrortProcName, @ErrorMessage = @ErrorMessage, @ErrorNumber =  @ErrorNumber 

END CATCH;