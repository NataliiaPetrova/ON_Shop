CREATE TABLE [Master].[OrderDetails] (
    [OrderDetailID]    INT IDENTITY (1, 1) NOT NULL,
    [ProductID]        INT NULL,
    [OrderID]          INT NOT NULL,
    [QuantityProducts] INT NULL,
    PRIMARY KEY CLUSTERED ([OrderDetailID] ASC),
    CONSTRAINT [FK_OrdersOrderDetails] FOREIGN KEY ([OrderID]) REFERENCES [Master].[Orders] ([OrderID]),
    CONSTRAINT [FK_ProductsOrderDetails] FOREIGN KEY ([ProductID]) REFERENCES [Master].[Products] ([ProductID])
);

