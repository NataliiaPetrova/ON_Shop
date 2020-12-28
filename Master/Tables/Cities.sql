CREATE TABLE [Master].[Cities] (
    [CityID]   INT           IDENTITY (1, 1) NOT NULL,
    [CityName] NVARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([CityID] ASC)
);

