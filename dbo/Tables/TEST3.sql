﻿CREATE TABLE [dbo].[TEST3] (
    [ID]     INT          IDENTITY (1, 1) NOT NULL,
    [NAME]   VARCHAR (30) NOT NULL,
    [SALARY] MONEY        NULL,
    UNIQUE NONCLUSTERED ([ID] ASC)
);
