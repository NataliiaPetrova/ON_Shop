CREATE TABLE [Logs].[OperationRuns] (
    [OperationRunID]          INT            IDENTITY (1, 1) NOT NULL,
    [OperationID]             INT            NULL,
    [StatusID]                INT            NULL,
    [StartTime]               DATETIME       CONSTRAINT [DF_LogsOperationRunsStartTime] DEFAULT (getdate()) NULL,
    [EndTime]                 DATETIME       NULL,
    [OperationRunDescription] NVARCHAR (MAX) CONSTRAINT [DF_LogsOperationRunsOperationRunDescription] DEFAULT ('Created new OperationRunID failed and process is waiting following events.') NULL,
    CONSTRAINT [PK_LogsOperationRunsOperationRunID] PRIMARY KEY CLUSTERED ([OperationRunID] ASC),
    CONSTRAINT [FK_LogsOperationRunsOperationID_LogsOperationsOperationID] FOREIGN KEY ([OperationID]) REFERENCES [Logs].[Operations] ([OperationID]),
    CONSTRAINT [FK_LogsOperationRunsStatusID_LogsOperationsStatusesOperationStatusID] FOREIGN KEY ([StatusID]) REFERENCES [Logs].[OperationsStatuses] ([OperationStatusID])
);

