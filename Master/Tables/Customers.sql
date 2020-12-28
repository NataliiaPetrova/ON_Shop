CREATE TABLE [Master].[Customers] (
    [CustomerID]  INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]   NVARCHAR (30)  NOT NULL,
    [LastName]    NVARCHAR (30)  NOT NULL,
    [PhoneNumber] NVARCHAR (25)  NOT NULL,
    [Email]       NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([CustomerID] ASC)
);

