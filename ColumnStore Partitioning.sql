USE master 
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET STATISTICS IO OFF
GO
SET SHOWPLAN_TEXT OFF
GO
 
-----------------------------------------------------------------------------
-- Name:       ColumnStorePartitioning
-- Author:     SlowSQLServer
-- Date:       20230410
-- Description:Backup the backup meta data to a native backup file.
--
-- Amendments:
-- -----------
--
-- Who                  When         Ref              Description
-- ---                  ----         ---              -----------
-- 
-----------------------------------------------------------------------------

 
------------------------------------------------------------------------------------
-- Locals
------------------------------------------------------------------------------------
DECLARE @ObjectName NVARCHAR(MAX) = 'ColumnStorePartitioning';
DECLARE @ProcessTime DATETIME = GETDATE();
DECLARE @ProcMessage NVARCHAR(4000) = N'';
DECLARE @i INT = 1 ;
DECLARE @startDate AS DATE = '20130101';
DECLARE @EndDate AS DATE = '20231231';
DECLARE @DT DATE ='20000101'

------------------------------------------------------------------------------------
-- Initialize
------------------------------------------------------------------------------------
SET NOCOUNT ON;
 

------------------------------------------------------------------------------------
-- Main processing and error handling start
------------------------------------------------------------------------------------
BEGIN TRY
	SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - Starting.';
	RAISERROR (@ProcMessage,10,1);


	----------------------------------------------------------------------------------------------------------------
	-- Drop SlowSQLServer Database
	----------------------------------------------------------------------------------------------------------------
	IF EXISTS (SELECT 1 FROM sys.databases where [name] = 'SlowSQLServer')
	BEGIN
		EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'SlowSQLServer'
		ALTER DATABASE SlowSQLServer SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE SlowSQLServer
	END
 
	----------------------------------------------------------------------------------------------------------------
	-- Create SlowSQLServer Database
	----------------------------------------------------------------------------------------------------------------
	CREATE DATABASE SlowSQLServer
	ALTER DATABASE SlowSQLServer SET RECOVERY SIMPLE;

	
	----------------------------------------------------------------------------------------------------------------
	-- Create a partition function called pfMonths with 50 vears of months 2000 - 2050
	----------------------------------------------------------------------------------------------------------------
	USE SlowSQLServer
	IF NOT EXISTS (SELECT 1 FROM sys.partition_functions WHERE [name] = 'pfMonths') 
	BEGIN
		SET @DT  ='20000101'
		DECLARE @Str NVARCHAR(MAX) = N' CREATE PARTITION FUNCTION pfMonths (DATE) AS RANGE RIGHT FOR VALUES (';
		WHILE @DT < '20510101'
		BEGIN
				SET @Str += '''' + CONVERT (NVARCHAR(256), @DT, 112) + ''',';
				SET @DT = DATEADD(MONTH, 1, @DT ) ;
		END

		SET @Str = SUBSTRING(@Str, 1, LEN(@Str)-1) + ')'
		EXEC sp_executesql @stmt = @Str;
		SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - Partition Function pfMonths created.';
		RAISERROR (@ProcMessage,10,1);
	END
	ELSE
	BEGIN
		SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - Partition Function pfMonths already exists.';
		RAISERROR (@ProcMessage,10,1);
	END;


	--------------------------------------------------------------------------------------------
	-- Create the partition scheme psMonths for partition function pfMonths
	--------------------------------------------------------------------------------------------
	IF NOT EXISTS (SELECT 1 FROM sys.partition_schemes WHERE [name] = 'psMonths')
	BEGIN
		CREATE PARTITION SCHEME psMonths AS PARTITION pfMonths ALL TO ([Primary]);
		SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - Partition Scheme psMonths created.';
		RAISERROR (@ProcMessage,10,1);
	END
	ELSE
	BEGIN
		SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - Partition Scheme psMonths already exists.';
		RAISERROR (@ProcMessage,10,1);
	END
 

	--------------------------------------------------------------------------------------------
	-- Drop the non columnstore partition work table
	--------------------------------------------------------------------------------------------
	IF OBJECT_ID('dbo.tbl_Test_Non_ColumnStore_Partition') IS NOT NULL
	BEGIN
		DROP TABLE do.tbl_Test_Non_ColumnStore_Partition
		SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - Dropped table tbl_Test_Non_ColumnStore_Partition.';
		RAISERROR (@ProcMessage,10,1);
	END

 

	--------------------------------------------------------------------------------------------
	--  Drop the partition work table
	--------------------------------------------------------------------------------------------
	IF OBJECT_ID('dbo.tbl_Test_ColumnStore_Partition') IS NOT NULL
	BEGIN
		DROP TABLE dbo.tbl_Test_ColumnStore_Partition
		SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - Dropped table tbl_Test_ColumnStore_Partition.';
		RAISERROR (@ProcMessage,10,1);
	END

 
	--------------------------------------------------------------------------------------------
	-- Create the partition work table
	--------------------------------------------------------------------------------------------
	CREATE TABLE dbo.tbl_Test_ColumnStore_Partition(
	[Date] [date] NOT NULL , 
	[ID] INT NOT NULL IDENTITY(1,1) ,
	[AccRef] BIGINT NOT NULL,
	[Amount] [money] NULL ) ON psMonths ( [Date])
	SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - Created table dbo.tbl_Test_ColumnStore_Partition.';
	RAISERROR (@ProcMessage,10,1)
 
	--------------------------------------------------------------------------------------------
	-- Create the non partition work table
	--------------------------------------------------------------------------------------------
	CREATE TABLE dbo.tbl_Test_Non_ColumnStore_Partition(
	[Date] [date] NOT NULL ,ID INT NOT NULL IDENTITY(1,1),
	[AccRef] [bigint] NOT NULL,
	[Amount] [money] NULL, PRIMARY KEY CLUSTERED ( ID)
	) ON [PRIMARY];
 	SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - Created table dbo.tbl_Test_Non_ColumnStore_Partition.';
	RAISERROR (@ProcMessage,10,1);

	--------------------------------------------------------------------------------------------
	-- Populate the non columnstore/partition work table
	--------------------------------------------------------------------------------------------
	SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - Populating table dbo.tbl_Test_Non_ColumnStore_Partition with 100000 rows.';
	RAISERROR (@ProcMessage,10,1);
	SET @i = 1;
	WHILE (@i <= 100000)
	BEGIN
		SET @DT = DATEADD(DAY, RAND(CHECKSUM(NEWID()))* (1+DATEDIFF (DAY, @startDate, @EndDate)) , @StartDate) ;
		INSERT dbo.tbl_Test_Non_ColumnStore_Partition ([Date], [AccRef], [Amount]) SELECT @DT, CAST (@I AS NVARCHAR (256)), 
																					DATEDIFF(DAY, @DT, GETDATE());
		IF @i % 1000 = 0
		BEGIN
			SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - ' + CAST(@i AS NVARCHAR(256)) + ' rows inserted.';
			RAISERROR (@ProcMessage,10,1);
		END
		SET @i +=1
	END;
	SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - Populated table dbo.tbl_Test_Non_ColumnStore_Partition.';
	RAISERROR (@ProcMessage,10,1);
 
 	--------------------------------------------------------------------------------------------
	-- Populate the columntore partition work table
	--------------------------------------------------------------------------------------------
	SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + 
			N' - Copy data from the dbo.tbl_Test_Non_ColumnStore_Partition table to the dbo.tbl_Test_ColumnStore_Partition table.';
	RAISERROR (@ProcMessage,10,1);
	SET IDENTITY_INSERT dbo.tbl_Test_ColumnStore_Partition ON;
	INSERT dbo.tbl_Test_ColumnStore_Partition ([Date],[ID],[AccRef],[Amount]) SELECT [Date],[ID],[AccRef],[Amount] FROM dbo.tbl_Test_Non_ColumnStore_Partition ;
	SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - ' + CAST(@@ROWCOUNT AS NVARCHAR(256)) + 
						' rows inserted into table dbo.tbl_Test_ColumnStore_Partition table.';
	RAISERROR (@ProcMessage,10,1);
	SET IDENTITY_INSERT dbo.tbl_Test_ColumnStore_Partition OFF;

 	--------------------------------------------------------------------------------------------
	-- Create a columnstore clustered index on the dbo.tbl_Test_Non_ColumnStore_Partition table.
	--------------------------------------------------------------------------------------------
	SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + 
				N' - Create a columnstore clustered index on the dbo.tbl_Test_Non_ColumnStore_Partition table.';
	RAISERROR (@ProcMessage,10,1); 
	CREATE CLUSTERED COLUMNSTORE INDEX CCI ON dbo.tbl_Test_ColumnStore_Partition;

 	--------------------------------------------------------------------------------------------
	-- Testing
	--------------------------------------------------------------------------------------------	
	SET STATISTICS IO ON
 

	SELECT * FROM dbo.tbl_Test_Non_ColumnStore_Partition  
	WHERE [Date] BETWEEN '20190801' AND '20190831'

	SELECT * FROM dbo.tbl_Test_ColumnStore_Partition  
	WHERE [Date] BETWEEN '20190801' AND '20190831'

	SET STATISTICS IO OFF
 

	------------------------------------------------------------------------------------
	-- Finish
	-----------------------------------------------------------------------------------
	SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - Finish.';
	RAISERROR (@ProcMessage,10,1);
	SET NOCOUNT OFF;
END TRY

BEGIN CATCH
	DECLARE @Catch_ErrorMessage NVARCHAR(4000);
	DECLARE @Catch_ErrorSeverity INT;
	DECLARE @Catch_ErrorState INT;
	DECLARE @Catch_Subject VARCHAR(256);

	SELECT @Catch_ErrorMessage = ERROR_MESSAGE()
		,@Catch_ErrorSeverity = ERROR_SEVERITY()
		,@Catch_ErrorState = ERROR_STATE();

	RAISERROR (@Catch_ErrorMessage,@Catch_ErrorSeverity,@Catch_ErrorState);
	 
	
	WHILE (@@TRANCOUNT > 0)
	BEGIN
		ROLLBACK;
	END

 
END CATCH

 


