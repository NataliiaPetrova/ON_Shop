
CREATE DATABASE OnShop;
GO
USE OnShop;
GO
CREATE SCHEMA [Master];
GO
CREATE SCHEMA Logs;
GO
CREATE SCHEMA Staging;
GO


--------------------------------
-- SCHEMA Master
--------------------------------
CREATE TABLE [MASTER].[Customers](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[FirstName] [nvarchar](30) NOT NULL,
	[LastName] [nvarchar](30) NOT NULL,
	[PhoneNumber] [nvarchar](25) NOT NULL,
	[Email] [nvarchar](100) NOT NULL
	);

CREATE TABLE [MASTER].[Calendar](
	[DateID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[TheDate] [date] NOT NULL,
	[DayWeek] [nvarchar](10) NOT NULL,
	[Quarter] [int] NOT NULL,
	[Year] [bit] NOT NULL
);

CREATE TABLE [MASTER].[Employees](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[EmpFirstName] [nvarchar](50) NOT NULL,
	[EmpLastName] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NULL,
	[Phone] [nvarchar](50)  NULL
);

CREATE TABLE [MASTER].[Cities](
	[CityID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[CityName] [nvarchar](50) NOT NULL
);

CREATE TABLE [MASTER].[Streets](
	[StreetID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[StreetName] [nvarchar](50) NOT NULL
);

CREATE TABLE [MASTER].[Payments](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[PaymentStatus] [bit] NOT NULL,
	[PaymentType] [nvarchar](10) NULL
);
CREATE TABLE [MASTER].[Brands](
	[BrandID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[BrandName] [nvarchar](50) NOT NULL
);


CREATE TABLE [MASTER].[Categories](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[CategoryName] [nvarchar](50) NOT NULL
);

CREATE TABLE [MASTER].[Products](
	[ProductID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[ProductName] [nvarchar](100) NULL,
	[ProductDescription] [nvarchar](max) NULL,
	[BrandID] [int] NULL ,
	[CategoryID] [int] NULL,
	CONSTRAINT FK_ProductsBrands FOREIGN KEY ([BrandID]) REFERENCES [MASTER].[Brands] ([BrandID]),
	CONSTRAINT FK_ProductsCategories FOREIGN KEY ([CategoryID]) REFERENCES [MASTER].[Categories] ([CategoryID])

	);

CREATE TABLE [MASTER].[Stocks] (
    [StockID]      INT   IDENTITY (1, 1) NOT NULL,
    [ProductID]    INT   NULL,
    [Price]        MONEY NULL,
	[EndVersion]   INT CONSTRAINT [DF_EndVersion]  DEFAULT ((999999999)),
    [StartVersion] INT,  
    PRIMARY KEY CLUSTERED ([StockID] ASC),
    CONSTRAINT FK_ProductsStocks FOREIGN KEY ([ProductID]) REFERENCES [MASTER].[Products] ([ProductID]),
 );



CREATE TABLE [MASTER].[Deliveries](
	[DeliveryLocationID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[StreetID] [int] NOT NULL  CONSTRAINT FK_StreetsDeliveries FOREIGN KEY REFERENCES MASTER.Streets(StreetID),
	[CityID] [int] NOT NULL CONSTRAINT FK_CitiesDeliveries FOREIGN KEY REFERENCES MASTER.Cities(CityID)
	)

CREATE TABLE [MASTER].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[CustomerID] [int] NOT NULL CONSTRAINT FK_CustomersOrders FOREIGN KEY REFERENCES MASTER.Customers(CustomerID),
	[EmployeeID] [int] NOT NULL CONSTRAINT FK_EmployeesOrders FOREIGN KEY REFERENCES MASTER.Employees(EmployeeID),
	[OrderDate] [date] NULL,
	[PaymentID] [int] NOT NULL CONSTRAINT PaymentsOrders FOREIGN KEY REFERENCES MASTER.Payments(PaymentID),
	[DeliveryID] [int] NULL CONSTRAINT DeliveriesOrders FOREIGN KEY REFERENCES MASTER.Deliveries(DeliveryLocationID)
	)

CREATE TABLE [MASTER].[OrderDetails](
	[OrderDetailID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[ProductID] [int] NULL  CONSTRAINT FK_ProductsOrderDetails FOREIGN KEY REFERENCES MASTER.Products(ProductID),
	[OrderID] [int] NOT NULL  CONSTRAINT FK_OrdersOrderDetails FOREIGN KEY REFERENCES MASTER.Orders(OrderID),
	[QuantityProducts] [int] NULL
	)


--------------------------------
-- SCHEMA Logs
--------------------------------
CREATE TABLE Logs.Operations (
	OperationID INT IDENTITY(1,1) NOT NULL,
	OperationName NVARCHAR(250) NULL,
	OperationDescription NVARCHAR(MAX) NULL,
	CONSTRAINT PK_LogsOperationsOperationsID PRIMARY KEY(OperationID)
);

CREATE TABLE Logs.OperationsStatuses (
	OperationStatusID INT IDENTITY(1,1) NOT NULL,
	[Status] NVARCHAR(50)  NULL,
	StatusName NVARCHAR(250) NULL,
	CONSTRAINT PK_LogsOperationsStatusesOperationStatusID PRIMARY KEY(OperationStatusID)
);

CREATE TABLE Logs.OperationRuns (
	OperationRunID INT IDENTITY(1,1) NOT NULL,
	OperationID INT NULL,
	StatusID INT NULL,
	StartTime DATETIME CONSTRAINT DF_LogsOperationRunsStartTime DEFAULT CURRENT_TIMESTAMP,
	EndTime DATETIME NULL,
	OperationRunDescription NVARCHAR(MAX) CONSTRAINT DF_LogsOperationRunsOperationRunDescription DEFAULT 'Created new OperationRunID failed and process is waiting following events.',
	CONSTRAINT PK_LogsOperationRunsOperationRunID PRIMARY KEY(OperationRunID),
	CONSTRAINT FK_LogsOperationRunsOperationID_LogsOperationsOperationID FOREIGN KEY (OperationID) REFERENCES Logs.Operations(OperationID),
	CONSTRAINT FK_LogsOperationRunsStatusID_LogsOperationsStatusesOperationStatusID FOREIGN KEY (StatusID) REFERENCES Logs.OperationsStatuses(OperationStatusID)
);

CREATE TABLE Logs.EventLogs (
	EventID INT IDENTITY(1,1) NOT NULL,
	OperationRunID INT NOT NULL,
	[User] NVARCHAR(250) CONSTRAINT DF_LogsEventLogsUser DEFAULT SUSER_NAME(),
	EventDataTime DATETIME CONSTRAINT DF_LogsEventLogsEventStartTime DEFAULT CURRENT_TIMESTAMP,
	EventStatusID INT NULL,
	AffectedRows INT NULL,
	EventProcName NVARCHAR(250) NULL,
	EventMessage NVARCHAR(MAX),
	CONSTRAINT PK_LogsEventLogsEventID PRIMARY KEY(EventID),
	CONSTRAINT FK_LogsEventLogsOperationRunID_LogsOperationRunsOperationRunID FOREIGN KEY (OperationRunID) REFERENCES Logs.OperationRuns(OperationRunID),
	CONSTRAINT FK_LogsEventLogsEventStatusID_LogsOperationsStatusesOperationStatusID FOREIGN KEY (EventStatusID) REFERENCES Logs.OperationsStatuses(OperationStatusID)
);

CREATE TABLE Logs.ErrorLogs (
	ErrorID INT IDENTITY(1,1) NOT NULL,
	OperationRunID INT NULL,
	EventID INT NULL,
	ErrortProcName NVARCHAR(250) NULL,
	ErrorDataTime DATETIME NULL,
	ErrorLine INT,
	ErrorNumber INT NULL,
	ErrorSeverity INT,
	ErrorState NVARCHAR(MAX) NULL,
	ErrorMessage NVARCHAR(MAX) NULL,
	CONSTRAINT PK_LogsErrorLogsErrorID PRIMARY KEY(ErrorID),
	CONSTRAINT FK_LogsErrorLogsEventID_LogsEventLogsEventID FOREIGN KEY (EventID) REFERENCES Logs.EventLogs(EventID)
);



CREATE TABLE [Master].VersionConfigs (
	VersionID INT IDENTITY(1,1) PRIMARY KEY,
	VersionDateTime DATETIME NULL,
	OperationRunID INT NULL CONSTRAINT FK_OperationRunsOperationVersionConfigsRunID FOREIGN KEY (OperationRunID) REFERENCES Logs.OperationRuns(OperationRunID)
	);

CREATE TABLE Staging.NewDeliveries(
NewDeliveryID INT PRIMARY KEY IDENTITY (1,1),
ProductID INT NOT NULL, 
Price MONEY NOT NULL, 
NewDeliveryDate DATE NOT NULL 
);

CREATE TABLE Master.NewDeliveries(
NewDeliveryID INT PRIMARY KEY IDENTITY (1,1),
ProductID INT NOT NULL, 
Price MONEY NOT NULL, 
NewDeliveryDate DATE NOT NULL 
);
