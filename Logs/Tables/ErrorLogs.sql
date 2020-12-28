CREATE TABLE [Logs].[ErrorLogs] (
    [ErrorID]        INT            IDENTITY (1, 1) NOT NULL,
    [OperationRunID] INT            NULL,
    [EventID]        INT            NULL,
    [ErrortProcName] NVARCHAR (250) NULL,
    [ErrorDataTime]  DATETIME       NULL,
    [ErrorLine]      INT            NULL,
    [ErrorNumber]    INT            NULL,
    [ErrorSeverity]  INT            NULL,
    [ErrorState]     NVARCHAR (MAX) NULL,
    [ErrorMessage]   NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_LogsErrorLogsErrorID] PRIMARY KEY CLUSTERED ([ErrorID] ASC),
    CONSTRAINT [FK_LogsErrorLogsEventID_LogsEventLogsEventID] FOREIGN KEY ([EventID]) REFERENCES [Logs].[EventLogs] ([EventID])
);

