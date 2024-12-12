USE tempdb
GO
SET NOCOUNT ON;
GO

DECLARE @stmt NVARCHAR(MAX) = N'';
IF OBJECT_ID('tempdb..#FreeSpace') IS NOT NULL DROP TABLE #FreeSpace;
CREATE TABLE #FreeSpace (ServerName NVARCHAR(256)    
                        ,DatabaseName NVARCHAR(256)
                        ,FileID INT
                        ,TypeOfFile NVARCHAR(32)
                        ,LogicalFileName NVARCHAR(256)
                        ,PhysicalFileName NVARCHAR(256)
                        ,DatabaseState NVARCHAR(256)
                        ,SizeMB DECIMAL(38,2)
                        ,UsedSpaceMB DECIMAL(38,2)
                        ,UnusedSpaceMB DECIMAL(38,2));


INSERT #FreeSpace (ServerName ,DatabaseName,FileID ,TypeOfFile ,LogicalFileName ,PhysicalFileName,DatabaseState ,SizeMB ,UsedSpaceMB ,UnusedSpaceMB )
EXEC sp_msforeachdb '

USE [?]
;
WITH _01 AS
(
    SELECT   DB_NAME(database_id) AS Databasename
            ,[file_id] AS FileID
            ,type_desc AS typeOfFile
            ,name      AS LogicalFileName
            ,physical_name AS PhysicalName
            ,state_desc AS DatabaseState
            ,CAST((size * 8)  / 1024. AS DECIMAL(38,2)) AS SizeMB
            ,CAST((FILEPROPERTY(name, ''SpaceUsed'') * 8)/1024. AS DECIMAL(38,2)) AS UsedSpace
            ,CAST(((size * 8)  / 1024.) - ((FILEPROPERTY(name, ''SpaceUsed'') * 8)/1024.)  AS DECIMAL(38,2)) AS UnusedSpace
    FROM sys.master_files
    WHERE database_id = DB_ID()
)

SELECT @@SERVERNAME AS ServerName, * FROM _01';


WITH _01 AS (
SELECT f.*,d.recovery_model_desc AS RecoveryModel,CAST(f.UnusedSpaceMB/f.SizeMB*100 AS DECIMAL(38,2)) AS PercentageFree, 'USE ' + QUOTENAME(f.DatabaseName) + ' DBCC SHRINKFILE (' + CAST(f.FileID AS NVARCHAR(32)) + + ',' + CASE WHEN f.TypeOfFile = 'ROWS' THEN '256' ELSE '128' END+ ') WITH NO_INFOMSGS;' AS Command

FROM #FreeSpace f INNER JOIN sys.databases d ON d.name = f.DatabaseName
 )

 select * from _01

--SELECT  @stmt +=  _01.Command + CHAR(13) + CHAR(10) FROM _01

--EXEC sp_executesql @stmt= @stmt;
;

 
WITH _01 AS
(
    SELECT distinct (volume_mount_point), 
      total_bytes/1048576 as Size_in_MB, 
      available_bytes/1048576 as Free_in_MB,
      CAST((select ((available_bytes/1048576* 1.0)/(total_bytes/1048576* 1.0) *100)) AS DECIMAL(38,2)) as FreePercentage,
      @@SERVERNAME AS ServerName
    FROM sys.master_files AS f CROSS APPLY 
      sys.dm_os_volume_stats(f.database_id, f.file_id) 
    group by volume_mount_point, total_bytes/1048576, 
      available_bytes/1048576  
 )
  
 SELECT * FROM _01
 --WHERE FreePercentage <= 10.
 
 ORDER BY FreePercentage DESC
 