USE [master]
GO
SET NOCOUNT ON;
GO

----------------------------------------------------------------------------------------------------------------
-- Drop SlowSQLServer Database
----------------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM sys.databases where [name] = 'SlowSQLServer')
BEGIN
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'SlowSQLServer'
	ALTER DATABASE SlowSQLServer SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE SlowSQLServer
END
GO
 

----------------------------------------------------------------------------------------------------------------
-- Create SlowSQLServer Database
----------------------------------------------------------------------------------------------------------------
CREATE DATABASE SlowSQLServer
GO
ALTER DATABASE SlowSQLServer SET RECOVERY SIMPLE;
GO

----------------------------------------------------------------------------------------------------------------
-- Create SlowSQLServer Tables
----------------------------------------------------------------------------------------------------------------
USE SlowSQLServer
GO
CREATE TABLE dbo.Person (PersonID INT IDENTITY(1,1) NOT NULL , FirstName NVARCHAR(256),  RecCreate DATETIME DEFAULT GETDATE() ) ;
CREATE NONCLUSTERED INDEX NCI_FirstName ON dbo.Person  (FirstName)-- INCLUDE (PersonID);
GO



----------------------------------------------------------------------------------------------------------------
-- Create Parameter_Sniffing stored procedures
----------------------------------------------------------------------------------------------------------------
USE SlowSQLServer
GO
CREATE OR ALTER PROCEDURE dbo.usp_Bad_Retrieve @FirstName NVARCHAR(256) = NULL
AS
BEGIN
	SELECT c. FirstName, c. PersonID
	FROM dbo.Person AS c
	WHERE (@FirstName IS NULL OR c.FirstName= @FirstName)
END
GO
CREATE OR ALTER PROCEDURE dbo.usp_Parameter_Sniffing_Retrieve_Optimize_For_Amelia @FirstName NVARCHAR(256) = NULL
AS
BEGIN
	SELECT c. FirstName, c. PersonID
	FROM dbo.Person AS c
	WHERE  c.FirstName= @FirstName OPTION (OPTIMIZE FOR (@FirstName = 'AMELIA'));
END
GO


CREATE OR ALTER PROCEDURE dbo.usp_Parameter_Sniffing_Retrieve  @FirstName NVARCHAR(256) = NULL
AS
BEGIN
	SELECT c. FirstName, c. PersonID
	FROM dbo.Person AS c
	WHERE  c.FirstName= @FirstName
END
GO
CREATE OR ALTER PROCEDURE dbo.usp_Good_Retrieve @FirstName NVARCHAR(256) = NULL
AS
BEGIN
	DECLARE @stmt NVARCHAR (MAX) = N' 
		SELECT c.FirstName, c.PersonID
		FROM Person AS c
		WHERE 1 = 1
		';
	IF (@FirstName IS NOT NULL)
	BEGIN
		SET @stmt += ' AND c. FirstName= ' + '''' + @FirstName+'' + '''' + CHAR(13) + CHAR(10);
	END
	EXEC sp_executesql @stmt = @stmt;
	
 
END
GO

----------------------------------------------------------------------------------------------------------------
-- Creae proc to free plans from cache
----------------------------------------------------------------------------------------------------------------
CREATE  OR ALTER PROC dbo.usp_Remove_Plans AS
DECLARE @cache_plan_handle varbinary(44)
DECLARE cu CURSOR FOR SELECT  c.plan_handle
FROM  sys.dm_exec_cached_plans c  CROSS APPLY sys.dm_exec_sql_text(c.plan_handle) t
WHERE  text LIKE '%Retrieve%' 
OPEN cu 
FETCH cu INTO @cache_plan_handle
WHILE @@FETCH_STATUS <> -1
BEGIN
	PRINT @cache_plan_handle
	DBCC FREEPROCCACHE(@cache_plan_handle)
	FETCH cu INTO @cache_plan_handle
END
CLOSE  cu 
DEALLOCATE cu;
GO

----------------------------------------------------------------------------------------------------------------
-- Ceate Person Data
----------------------------------------------------------------------------------------------------------------
DECLARE @iter INT = 1
WHILE @iter <10000
BEGIN
	INSERT dbo.Person (FirstName) SELECT 'AMELIA'
	SET @iter+=1;
END
INSERT dbo.Person (FirstName) SELECT 'TESS'

select * from Person where FirstName<> 'AMELIA' 

GO
----------------------------------------------------------------------------------------------------------------
-- Testing
----------------------------------------------------------------------------------------------------------------
USE SlowSQLServer
GO
SET STATISTICS IO ON
GO
 
EXEC dbo.usp_Remove_Plans
EXEC dbo.usp_Parameter_Sniffing_Retrieve @FirstName= 'TESS'
EXEC dbo.usp_Parameter_Sniffing_Retrieve @FirstName= 'AMELIA'


EXEC dbo.usp_Remove_Plans
EXEC dbo.usp_Good_Retrieve @FirstName= 'AMELIA'
EXEC dbo.usp_Good_Retrieve @FirstName= 'TESS'

 
SELECT FirstName, COUNT(1) RecoredCOunt 
FROM Person
WHERE FirstName IN ('TESS', 'AMELIA')
GROUP BY FirstName
ORDER BY FirstName

 