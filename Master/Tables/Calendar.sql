CREATE TABLE [Master].[Calendar] (
    [DateID]  INT           IDENTITY (1, 1) NOT NULL,
    [TheDate] DATE          NOT NULL,
    [DayWeek] NVARCHAR (10) NOT NULL,
    [Quarter] INT           NOT NULL,
    [Year]    BIT           NOT NULL,
    PRIMARY KEY CLUSTERED ([DateID] ASC)
);

