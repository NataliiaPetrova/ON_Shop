CREATE TABLE [Staging].[NewDeliveries] (
    [NewDeliveryID]   INT   IDENTITY (1, 1) NOT NULL,
    [ProductID]       INT   NOT NULL,
    [Price]           MONEY NOT NULL,
    [NewDeliveryDate] DATE  NOT NULL,
    PRIMARY KEY CLUSTERED ([NewDeliveryID] ASC)
);

