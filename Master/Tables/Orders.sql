CREATE TABLE [Master].[Orders] (
    [OrderID]    INT  IDENTITY (1, 1) NOT NULL,
    [CustomerID] INT  NOT NULL,
    [EmployeeID] INT  NOT NULL,
    [OrderDate]  DATE NULL,
    [PaymentID]  INT  NOT NULL,
    [DeliveryID] INT  NULL,
    PRIMARY KEY CLUSTERED ([OrderID] ASC),
    CONSTRAINT [DeliveriesOrders] FOREIGN KEY ([DeliveryID]) REFERENCES [Master].[Deliveries] ([DeliveryLocationID]),
    CONSTRAINT [FK_CustomersOrders] FOREIGN KEY ([CustomerID]) REFERENCES [Master].[Customers] ([CustomerID]),
    CONSTRAINT [FK_EmployeesOrders] FOREIGN KEY ([EmployeeID]) REFERENCES [Master].[Employees] ([EmployeeID]),
    CONSTRAINT [PaymentsOrders] FOREIGN KEY ([PaymentID]) REFERENCES [Master].[Payments] ([PaymentID])
);

