CREATE PROCEDURE [Master].[SP_Deliveries]
as

BEGIN TRY

DECLARE @EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)
DECLARE @ROWCOUNT INT = 0
DECLARE @RandomSteetID int
Declare @RandomCityID int
DECLARE @count int
SET @count = 1

EXECUTE Logs.SP_EventR @EventProcName, @rowcount

begin
WHILE @count <= 1000
BEGIN 

   SELECT @RandomSteetID = (SELECT TOP(1) [StreetID]FROM [MASTER].[Streets] ORDER BY NEWID()) 
   SELECT @RandomCityID = (SELECT TOP(1) [CityID] FROM [MASTER].[Cities] ORDER BY NEWID())

   INSERT INTO master.Deliveries VALUES (@RandomSteetID, @RandomCityID)
   
   SET @ROWCOUNT += @@ROWCOUNT
   SET @count = @count + 1

 
END


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