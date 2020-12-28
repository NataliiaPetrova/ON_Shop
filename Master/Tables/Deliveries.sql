CREATE TABLE [Master].[Deliveries] (
    [DeliveryLocationID] INT IDENTITY (1, 1) NOT NULL,
    [StreetID]           INT NOT NULL,
    [CityID]             INT NOT NULL,
    PRIMARY KEY CLUSTERED ([DeliveryLocationID] ASC),
    CONSTRAINT [FK_CitiesDeliveries] FOREIGN KEY ([CityID]) REFERENCES [Master].[Cities] ([CityID]),
    CONSTRAINT [FK_StreetsDeliveries] FOREIGN KEY ([StreetID]) REFERENCES [Master].[Streets] ([StreetID])
);

