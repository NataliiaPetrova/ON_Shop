CREATE TABLE [Master].[Employees] (
    [EmployeeID]   INT           IDENTITY (1, 1) NOT NULL,
    [EmpFirstName] NVARCHAR (50) NOT NULL,
    [EmpLastName]  NVARCHAR (50) NOT NULL,
    [Email]        NVARCHAR (50) NULL,
    [Phone]        NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([EmployeeID] ASC)
);

