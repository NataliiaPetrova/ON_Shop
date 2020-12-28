CREATE TABLE [Master].[Products] (
    [ProductID]          INT            IDENTITY (1, 1) NOT NULL,
    [ProductName]        NVARCHAR (100) NULL,
    [ProductDescription] NVARCHAR (MAX) NULL,
    [BrandID]            INT            NULL,
    [CategoryID]         INT            NULL,
    PRIMARY KEY CLUSTERED ([ProductID] ASC)
);

