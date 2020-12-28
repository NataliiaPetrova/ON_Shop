CREATE TABLE [Master].[VersionConfigs] (
    [VersionID]       INT      IDENTITY (1, 1) NOT NULL,
    [VersionDateTime] DATETIME NULL,
    [OperationRunID]  INT      NULL,
    PRIMARY KEY CLUSTERED ([VersionID] ASC),
    CONSTRAINT [FK_OperationRunsOperationVersionConfigsRunID] FOREIGN KEY ([OperationRunID]) REFERENCES [Logs].[OperationRuns] ([OperationRunID])
);

