CREATE TABLE [Master].[Products] (
    [ProductID]          INT            IDENTITY (1, 1) NOT NULL,
    [ProductName]        NVARCHAR (100) NULL,
    [ProductDescription] NVARCHAR (MAX) NULL,
    [BrandID]            INT            NULL CONSTRAINT FK_ProductsBrands FOREIGN KEY ([BrandID]) REFERENCES [MASTER].[Brands] ([BrandID]),
    [CategoryID]         INT            NULL CONSTRAINT FK_ProductsCategories FOREIGN KEY ([CategoryID]) REFERENCES [MASTER].[Categories] ([CategoryID]),
    PRIMARY KEY CLUSTERED ([ProductID] ASC)
);

