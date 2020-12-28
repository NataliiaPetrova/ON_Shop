CREATE TABLE [Logs].[OperationsStatuses] (
    [OperationStatusID] INT            IDENTITY (1, 1) NOT NULL,
    [Status]            NVARCHAR (50)  NULL,
    [StatusName]        NVARCHAR (250) NULL,
    [StatusDescription] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_LogsOperationsStatusesOperationStatusID] PRIMARY KEY CLUSTERED ([OperationStatusID] ASC)
);

