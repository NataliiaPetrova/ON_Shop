--========================================================================================================--
/*
	   Object:				StoredProcedures [Master].[SP_DataPopulation], [Master].[SP_ReStocking]   
	   Script Date:			28.12.2020 16:50:55 
	   Short Description:	Launches procedures for populating tables with data, 
							creating version for newdelivery
	   Scripted by:			LV4097\NATALIIAPETROVA
*/
--========================================================================================================--

EXEC [Master].[SP_DataPopulation]

EXEC [Master].[SP_ReStocking]

EXEC [Staging].[SP_PlacingOrder] 1
