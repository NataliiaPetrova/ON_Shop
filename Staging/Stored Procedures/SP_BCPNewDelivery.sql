/****** Object:  StoredProcedure [Staging].[SP_NewDelivery]    Script Date: 28.12.2020 18:41:00 ******/

CREATE  PROCEDURE [Staging].[SP_NewDelivery]
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
	@RowCount INT = 0,

	-- managing xp_cmdshell Server configuration option
	@prevAdvancedOptions INT, 
	--variables for managing xp_cmdshell Server configuration option
	@prevXpCmdshell INT,       

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

	-- deleting verything from NewDeliveries
	TRUNCATE TABLE  Staging.NewDeliveries

	-- store all ordered products in a temporary table
	DROP TABLE IF EXISTS #AllOrders
		SELECT OrderDetails.ProductID, COUNT(*) AS AllProducts
        INTO #AllOrders
		 FROM Master.OrderDetails 
		    GROUP BY OrderDetails.ProductID
	        ORDER BY OrderDetails.ProductID
		
		

	-- populating 'Staging.NewDeliveries'

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

					-- Calculate and save how many rows were populeted
					SET @RowCount += (SELECT @@ROWCOUNT) 

				SET @Counter += 1
				END
		
		 SET @CurrentProdID +=1
		END
		
    --completing event logging
	EXECUTE Logs.SP_EventC @EventProcName, @rowcount


	-- BCP process - loading new delivery to txt file.

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