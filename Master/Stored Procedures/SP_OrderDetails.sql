
CREATE     PROCEDURE [Master].[SP_OrderDetails]

as

BEGIN TRY

DECLARE @EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)
DECLARE @ROWCOUNT int = 0


EXECUTE Logs.SP_EventR @EventProcName, @rowcount

DECLARE @ProductID int
DECLARE @OrderID int
DECLARE @QuantityProducts int  

DECLARE @StartCounter INT = 1

WHILE @StartCounter<3000
BEGIN
SELECT @OrderID = (SELECT TOP(1) OrderID from MASTER.Orders ORDER BY NEWID() )
SELECT @ProductID = (SELECT TOP(1) ProductID from MASTER.Products ORDER BY NEWID() )
SELECT @QuantityProducts = (select floor(rand()*3+1)) --rand from 1 to 3

INSERT INTO MASTER.OrderDetails(OrderID, ProductID, QuantityProducts)
VALUES (@OrderID,@ProductID,@QuantityProducts )

SET @StartCounter+=1
print @StartCounter
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