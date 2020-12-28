CREATE TABLE [Master].[Payments] (
    [PaymentID]     INT           IDENTITY (1, 1) NOT NULL,
    [PaymentStatus] BIT           NOT NULL,
    [PaymentType]   NVARCHAR (10) NULL,
    PRIMARY KEY CLUSTERED ([PaymentID] ASC)
);

