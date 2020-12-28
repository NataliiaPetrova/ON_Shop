CREATE TABLE [Logs].[EventLogs] (
    [EventID]        INT            IDENTITY (1, 1) NOT NULL,
    [OperationRunID] INT            NOT NULL,
    [User]           NVARCHAR (250) CONSTRAINT [DF_LogsEventLogsUser] DEFAULT (suser_name()) NULL,
    [EventDataTime]  DATETIME       CONSTRAINT [DF_LogsEventLogsEventStartTime] DEFAULT (getdate()) NULL,
    [EventStatusID]  INT            NULL,
    [AffectedRows]   INT            NULL,
    [EventProcName]  NVARCHAR (250) NULL,
    [EventMessage]   NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_LogsEventLogsEventID] PRIMARY KEY CLUSTERED ([EventID] ASC),
    CONSTRAINT [FK_LogsEventLogsEventStatusID_LogsOperationsStatusesOperationStatusID] FOREIGN KEY ([EventStatusID]) REFERENCES [Logs].[OperationsStatuses] ([OperationStatusID]),
    CONSTRAINT [FK_LogsEventLogsOperationRunID_LogsOperationRunsOperationRunID] FOREIGN KEY ([OperationRunID]) REFERENCES [Logs].[OperationRuns] ([OperationRunID])
);

