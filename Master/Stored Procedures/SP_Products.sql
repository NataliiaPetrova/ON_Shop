
CREATE   PROCEDURE [Master].[SP_Products]
	@end INT --number of inserted rows
AS

BEGIN TRY

DECLARE @EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)
DECLARE @ROWCOUNT INT = 0


EXECUTE Logs.SP_EventR @EventProcName, @rowcount
	DECLARE @iterator INT
	SET @iterator = 1
	--choose random rows from related tables

	WHILE @iterator < @end
		
BEGIN
		INSERT INTO master.Products (ProductName, ProductDescription, BrandID, CategoryID)
		SELECT  '', --to be updated
				'', --to be updated
				ROUND(RAND()*(9-1)+1,0), --Master.Brands
				ROUND(RAND()*(3-1)+1,0) --Master.Categories
				SET @RowCount = @RowCount + (SELECT @@ROWCOUNT) 
		SET @iterator = @iterator +1
	END

	--temp table for name and description
	CREATE TABLE #tempo (
		id int IDENTITY(1,1) PRIMARY KEY,
		ProductName VARCHAR(150) NOT NULL,
		ProductDescription VARCHAR(MAX) NOT NULL
	)

	SET @iterator = 1

	--select rows using already inserted ones to concatenate them for name and description
	WHILE @iterator < @end
	BEGIN
		INSERT INTO #tempo(ProductName, ProductDescription)
		SELECT CONCAT(b.BrandName, ' ', sc.CategoryName) AS ProductName, 
		CONCAT('Perfect ', sc.CategoryName, ' ', 'coffee from ',  B.BrandName, ' is perfect combination of taste and quality.') AS ProductDescription 
		FROM master.Products p 
		JOIN MASTER.Brands b ON p.BrandID = b.BrandID 
		JOIN MASTER.Categories sc ON sc.CategoryID = p.CategoryID 
		WHERE p.ProductID = @iterator
		SET @iterator = @iterator + 1
	END
	--to check what will be inserted
	SELECT * FROM #tempo
	
	SET @iterator = 1
	--vars for name and description
	DECLARE @temp1 VARCHAR(150),
			@temp2 VARCHAR(max) 
	--update Products one by one using the same id
	WHILE @iterator < @end 
	BEGIN
		
		SET @temp1 = (SELECT ProductName FROM #tempo WHERE id = @iterator)
		SET @temp2 = (SELECT ProductDescription FROM #tempo WHERE id = @iterator)

		UPDATE master.Products
			SET ProductName = @temp1,
				ProductDescription = @temp2 
				WHERE ProductID = @iterator
		
		SET @iterator = @iterator + 1
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

	