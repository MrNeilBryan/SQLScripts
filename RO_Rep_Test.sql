USE master
GO
SET NOCOUNT ON
GO
----------------------------------------------------------------------------------------------------
-- Locals
----------------------------------------------------------------------------------------------------
DECLARE @stmt NVARCHAR(4000) = N'';
DECLARE @BackupFolder NVARCHAR(4000) = CAST(SERVERPROPERTY('InstanceDefaultBackupPath') AS NVARCHAR(4000)) + '\';
DECLARE @BackupFile1 NVARCHAR(4000) = @BackupFolder + 'DB_1.bak';
DECLARE @BackupFile2 NVARCHAR(4000) = @BackupFolder + 'DB_2.bak';
DECLARE @Output TABLE (o NVARCHAR(4000));
DECLARE @StandbyFile1 NVARCHAR(4000) = @BackupFolder + 'Standby_DB_1_RO.dat';
DECLARE @StandbyFile2 NVARCHAR(4000) = @BackupFolder + 'Standby_DB_2_RO.dat';


----------------------------------------------------------------------------------------------------
-- Drop work table
----------------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb.dbo.#sp_Who2')   IS NOT NULL DROP TABLE #sp_Who2;

----------------------------------------------------------------------------------------------------
-- Create the work table
----------------------------------------------------------------------------------------------------
CREATE TABLE #sp_Who2
(
	SPID INT, STATUS VARCHAR(1000) NULL, LOGIN SYSNAME NULL, HostName SYSNAME NULL, BlkBy SYSNAME NULL, DBName SYSNAME NULL, Command VARCHAR(1000) NULL, CPUTime INT NULL, DiskIO BIGINT NULL, -- int
	LastBatch VARCHAR(1000) NULL, ProgramName VARCHAR(1000) NULL, SPID2 INT, RequestId INT NULL --comment out for SQL 2000 databases
);

----------------------------------------------------------------------------------------------------
-- Populate work table
----------------------------------------------------------------------------------------------------
INSERT INTO #sp_Who2 EXEC sp_who2;

----------------------------------------------------------------------------------------------------
-- Kill of any sessions to the work databases
---------------------------------------------------------------------------------------------------- 
SELECT @stmt+= 'KILL '  + CAST(SPID AS NVARCHAR(32)) + CHAR(13) + CHAR(10) FROM #sp_Who2 WHERE DBName IN ('DB_2_RO','DB_1_RO','DB_1','DB_2');
EXEC sp_executesql @stmt = @stmt;

IF ISNULL(@stmt,'') <> '' 
BEGIN
	EXEC sp_executesql @stmt = @stmt;
END

----------------------------------------------------------------------------------------------------
-- Recreate work databases
---------------------------------------------------------------------------------------------------- 
IF EXISTS (SELECT 1 FROM sys.databases  WHERE name = 'DB_1')
BEGIN	
	DROP DATABASE DB_1;
END;
CREATE DATABASE DB_1;
IF EXISTS (SELECT 1 FROM sys.databases  WHERE name = 'DB_2')
BEGIN	
	DROP DATABASE DB_2;
END;
CREATE DATABASE DB_2;

IF EXISTS (SELECT 1 FROM sys.databases  WHERE name = 'DB_1_RO')
BEGIN	
	DROP DATABASE DB_1_RO;
END;
 

IF EXISTS (SELECT 1 FROM sys.databases  WHERE name = 'DB_2_RO')
BEGIN	
	DROP DATABASE DB_2_RO;
END;
 


----------------------------------------------------------------------------------------------------
-- Create the work tables
---------------------------------------------------------------------------------------------------- 
SET @stmt = 'CREATE TABLE DB_1.dbo.tbl_int (i INT);';
EXEC sp_executesql @stmt = @stmt;
SET @stmt = 'CREATE TABLE DB_2.dbo.tbl_int (i INT);';
EXEC sp_executesql @stmt = @stmt;


----------------------------------------------------------------------------------------------------
-- Backup databases
---------------------------------------------------------------------------------------------------- 
SET @stmt = 'DEL "'+@BackupFile1+'"'
INSERT @Output EXEC xp_cmdshell @stmt ;

SET @stmt = 'DEL "'+@BackupFile2+'"'
INSERT @Output EXEC xp_cmdshell @stmt ;

SET @stmt = 'BACKUP DATABASE [DB_1] TO DISK = ''' + @BackupFile1 + '''';
PRINT @stmt;
EXEC sp_executesql @stmt = @stmt;

SET @stmt = 'BACKUP DATABASE [DB_2] TO DISK = ''' + @BackupFile2 + '''';
PRINT @stmt;
EXEC sp_executesql @stmt = @stmt;
PRINT 'HERE'
PRINT @BackupFile1
----------------------------------------------------------------------------------------------------
-- Restore databases
---------------------------------------------------------------------------------------------------- 
RESTORE DATABASE DB_1_RO FROM DISK = @BackupFile1
WITH MOVE 'DB_1'     TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DB_1_RO.mdf',
     MOVE 'DB_1_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DB_1_RO.ldf',
	 REPLACE,
	 STANDBY = @StandbyFile1;

RESTORE DATABASE DB_2_RO FROM DISK = @BackupFile2
WITH MOVE 'DB_2'     TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DB_2_RO.mdf',
     MOVE 'DB_2_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DB_2_RO.ldf',
	 REPLACE,
	 STANDBY = @StandbyFile2;

