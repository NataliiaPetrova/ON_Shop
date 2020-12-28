CREATE     PROCEDURE [Master].[SP_Orders]

as

BEGIN TRY

DECLARE @EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)
DECLARE @ROWCOUNT INT = 0


EXECUTE Logs.SP_EventR @EventProcName, @rowcount

DECLARE @CustomerID int
DECLARE @EmployeeID int
DECLARE @PaymentID int
DECLARE @OrderDate date
DECLARE @DeliveryLocationID int


declare @yearr int 
DECLARE @Counter INT =0
DECLARE @OrderQuantity INT = 3000  ----amount of orders
set @yearr=2020
WHILE @Counter < @OrderQuantity
BEGIN

----distribution by years
IF @Counter<=4795 set @yearr=2017
else if (@counter>4795 and @counter<=12448) set @yearr=2018
else if (@counter>12448 and @counter<=20558) set @yearr=2019
else  set @yearr=2020

----generating random order's DATE
SELECT @OrderDate =( select TOP(1) TheDate 
        from  MASTER.Calendar 
        where year(TheDate)=@yearr ORDER BY NEWID())

---Generating random CUSTOMER
SELECT @CustomerID = (SELECT TOP(1) CustomerID
                        FROM MASTER.Customers 
                        ORDER BY NEWID());


---Generating random PAYMENT
SELECT @PaymentID = (SELECT TOP(1) PaymentID
                        FROM MASTER.Payments where PaymentStatus=1
                        ORDER BY NEWID());


---Generating random EMPLOYEE 

SELECT @EmployeeID =(SELECT TOP(1) EmployeeID 
                    FROM MASTER.Employees 
					ORDER BY NEWID() )


---Generating random DeliveryLocationID 
SELECT @DeliveryLocationID  =(SELECT TOP(1) DeliveryLocationID 
                    FROM MASTER.Deliveries
					ORDER BY NEWID() )



INSERT INTO Master.Orders(CustomerID,EmployeeID,OrderDate,PaymentID,DeliveryID) 
VALUES (@CustomerID,@EmployeeID,@OrderDate,@PaymentID,@DeliveryLocationID )

SET @ROWCOUNT += (SELECT @@ROWCOUNT)
SET @Counter+=1
print @Counter
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