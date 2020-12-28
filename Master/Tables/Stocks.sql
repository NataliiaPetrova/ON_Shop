CREATE TABLE [Master].[Stocks] (
    [StockID]      INT   IDENTITY (1, 1) NOT NULL,
    [ProductID]    INT   NULL,
    [Price]        MONEY NULL,
    [EndVersion]   INT   CONSTRAINT [DF_EndVersion] DEFAULT ((999999999)) NULL,
    [StartVersion] INT   NULL,
    PRIMARY KEY CLUSTERED ([StockID] ASC),
    CONSTRAINT [FK_ProductsStocks] FOREIGN KEY ([ProductID]) REFERENCES [Master].[Products] ([ProductID])
);

