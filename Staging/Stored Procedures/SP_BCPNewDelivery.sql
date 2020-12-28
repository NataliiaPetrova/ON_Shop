CREATE PROCEDURE [Staging].[SP_BCPNewDelivery]

(
 @MinPrice INT = 100,
 @MaxPrice INT = 500,
 @MinAmount INT = 1,
 @MaxAmount INT = 10

)
AS

BEGIN TRY 

	DECLARE
	 @EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	 @RowCount INT = 0,
	 @Amount INT = 10,
	 @RandomAmount INT,
	 @CounterKingProd INT,
	 @RandomPrice INT,
	 @CounterProd INT,
	 @DeliveryDate DATETIME,

	@prevAdvancedOptions INT, -- variables for managing xp_cmdshell Server configuration option
	@prevXpCmdshell INT,       --variables for managing xp_cmdshell Server configuration option

	@bcp_cmd VARCHAR(1000),
	@exe_path VARCHAR(200) = 'call "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\BCP.EXE"',
	@FromTable VARCHAR(250) = ' OnShop.Staging.NewDeliveries',
	@Path VARCHAR(350) = ' C:\BCP\',
	@FileName VARCHAR(150) = 'NewDelivery_',
	@Date VARCHAR (30),
	@FileExtention VARCHAR(10) = '.txt',
	@bcpParam VARCHAR(50) = ' -T -c',
	@ServerName VARCHAR(150) = ' -S LV4097\NATALIIAPETROVA',
	@UserName VARCHAR(150) = ' -U SOFTSERVE\npetrov ',
	@Delimeter VARCHAR(10)=' -t ","'
	
	-- logging events
	EXECUTE Logs.SP_EventR @EventProcName, @rowcount 
	

	DROP TABLE IF EXISTS #Products -- temporary table for storing random unique kind of products for new delivery
	CREATE TABLE #Products
	(ID INT IDENTITY(1,1),
	ProductID INT)


	INSERT INTO #Products (ProductID)
	SELECT TOP(10) ProductID
		FROM Master.Products
		ORDER BY NEWID()

	SET  @DeliveryDate = CURRENT_TIMESTAMP
	SET @CounterkingProd = 1
		WHILE @CounterKingProd <= @Amount
			BEGIN
				SELECT @RandomPrice = FLOOR(RAND()*(@MaxPrice-@MinPrice+1))+@MinPrice
				SELECT @RandomAmount = FLOOR(RAND()*(@MaxAmount-@MinAmount+1))+@MinAmount

				SET @CounterProd = 1
					WHILE @CounterProd <= @RandomAmount
						BEGIN
							INSERT INTO Staging.NewDeliveries  (ProductID, Price, NewDeliveryDate)
							SELECT ProductID AS ProductID,
								   @RandomPrice AS PricePerUnit,
								   @DeliveryDate  AS DeliveryDate
							FROM #Products
								WHERE ID = @CounterProd 
	                      
							
						SET @CounterProd +=1
						END

			SET @CounterkingProd +=1
			END

	EXECUTE Logs.SP_EventC @EventProcName, @rowcount


	-- BCP process for loading new delivery from temporary table to txt file.
	--xp_cmdshell Server configuration option
			
		SELECT @prevAdvancedOptions = cast(value_in_use as int) from sys.configurations where name = 'show advanced options'
		SELECT @prevXpCmdshell = cast(value_in_use as int) from sys.configurations where name = 'xp_cmdshell'

			IF (@prevAdvancedOptions = 0)
			BEGIN
				exec sp_configure 'show advanced options', 1
				reconfigure
			END

			IF (@prevXpCmdshell = 0)
			BEGIN
				exec sp_configure 'xp_cmdshell', 1
				reconfigure
			END


	--	 start main bcp block 
            SELECT @Date = CONVERT (VARCHAR (30), GETDATE(), 102)
			SET @bcp_cmd = @exe_path + @FromTable + ' out' + @Path + @FileName + @Date + @FileExtention + @bcpParam + @Delimeter + @ServerName + @UserName;
			
			EXEC master..xp_cmdshell @bcp_cmd;

	--	 end main bcp block 


			SELECT @prevAdvancedOptions = cast(value_in_use as int) from sys.configurations where name = 'show advanced options'
			SELECT @prevXpCmdshell = cast(value_in_use as int) from sys.configurations where name = 'xp_cmdshell'


			IF (@prevXpCmdshell = 1)
			BEGIN
				exec sp_configure 'xp_cmdshell', 0
				reconfigure
			END

			IF (@prevAdvancedOptions = 1)
			BEGIN
				exec sp_configure 'show advanced options', 0
				reconfigure
			END


END TRY 

BEGIN CATCH

	DECLARE 
	@ErrorMessage nvarchar (max) = ERROR_MESSAGE(),
	@ErrorNumber int = ERROR_NUMBER(),
	@ErrortProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

	EXEC [Logs].[SP_Errors]  @ErrortProcName=@ErrortProcName, @ErrorMessage = @ErrorMessage, @ErrorNumber =  @ErrorNumber 

END CATCH;

