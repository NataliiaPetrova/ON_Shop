
CREATE    PROCEDURE [Master].[SP_Calendar]
as

BEGIN TRY

DECLARE @EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)
DECLARE @ROWCOUNT int

EXECUTE Logs.SP_EventR @EventProcName, @ROWCOUNT

--CTE for temp calendar table
DECLARE @StartDate  DATE = '20170101';

DECLARE @EndDate DATE = DATEADD(DAY, -1, DATEADD(YEAR, 3, @StartDate));

;WITH Calendar (n)
 AS
(
  SELECT 0 UNION ALL SELECT n + 1 FROM Calendar
  WHERE n < DATEDIFF(DAY, @StartDate, @EndDate)
),
d(d) AS 
(
  SELECT DATEADD(DAY, n, @StartDate) FROM Calendar
),
Detailed AS
(
  SELECT
    Date         = CONVERT(date, d),
    DayName      = DATENAME(WEEKDAY,   d),
    Quarter      = DATEPART(Quarter,   d),
    Year         = DATEPART(YEAR,      d)
  FROM d
)

INSERT into master.Calendar (TheDate, DayWeek, Quarter, Year)
SELECT * FROM Detailed
  ORDER BY Date
OPTION (MAXRECURSION 0)

SET @ROWCOUNT += (SELECT @@ROWCOUNT)

EXECUTE Logs.SP_EventC @EventProcName, @ROWCOUNT

END TRY 

BEGIN CATCH

DECLARE 
@ErrorMessage nvarchar (max) = ERROR_MESSAGE(),
@ErrorNumber int = ERROR_NUMBER(),
@ErrortProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

EXEC [Logs].[SP_Errors]  @ErrortProcName=@ErrortProcName, @ErrorMessage = @ErrorMessage, @ErrorNumber =  @ErrorNumber 

END CATCH