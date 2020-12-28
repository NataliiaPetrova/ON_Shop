CREATE PROCEDURE [Staging].[SP_BCPNewDeliveryIN]
	
AS

BEGIN TRY 

	DECLARE
	@prevAdvancedOptions INT, 
	-- variables for managing xp_cmdshell Server configuration option
	@prevXpCmdshell INT,       
	--variables for managing xp_cmdshell Server configuration option

	@bcp_cmd VARCHAR(1000),
	@exe_path VARCHAR(200) = 'call "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\BCP.EXE"',
	@bcpParam VARCHAR(50) = ' -T -c',
	@ServerName VARCHAR(150) = ' -S LV4097\NATALIIAPETROVA',
	@UserName VARCHAR(150) = ' -U SOFTSERVE\npetrov ',
	@Delimeter VARCHAR(10)=' -t ","',
	@Path VARCHAR(350) = ' C:\BCP\',
	@FileName VARCHAR(150) = 'NewDelivery_',
	@Date VARCHAR (30),
	@FileExtention VARCHAR(10) = '.txt'
	

    -- BCP process for loading new delivery from temporary table to txt file
	-- xp_cmdshell Server configuration option
			
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
			SET @bcp_cmd ='BCP "[On_Shop].[Master].[NewDeliveries]" in ' + @Path + @FileName + @Date + @FileExtention + @bcpParam + @Delimeter + @ServerName + @UserName;

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


