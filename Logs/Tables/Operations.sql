CREATE TABLE [Logs].[Operations] (
    [OperationID]          INT            IDENTITY (1, 1) NOT NULL,
    [OperationName]        NVARCHAR (250) NULL,
    [OperationDescription] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_LogsOperationsOperationsID] PRIMARY KEY CLUSTERED ([OperationID] ASC)
);

