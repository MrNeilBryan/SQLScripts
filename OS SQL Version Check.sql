 


SELECT 
      SERVERPROPERTY('ProductUpdateLevel') AS CU, SERVERPROPERTY('ProductLevel') AS SP;
 



WITH _01 AS (SELECT windows_release, windows_service_pack_level, windows_sku, os_language_version FROM sys.dm_os_windows_info)

SELECT 
    CASE 
        WHEN windows_release = '6.1' THEN 'Windows Server 2008 R2'
        WHEN windows_release = '6.2' THEN 'Windows Server 2012'
        WHEN windows_release = '6.3' THEN 'Windows Server 2012 R2'
        WHEN windows_release = '10.0' THEN 'Windows Server 2016 and later'
        WHEN windows_release = '10.0.17763' THEN 'Windows Server 2019'
        WHEN windows_release = '10.0.20348' THEN 'Windows Server 2022'
        WHEN windows_release = '10.0.25000' THEN 'Windows Server 2025'
        WHEN windows_release = '10.0.22000' THEN 'Windows 11'
        WHEN windows_release = '10.0.22621' THEN 'Windows 11 22H2'
        WHEN windows_release = '10.0.26100' THEN 'Windows 11 24H2'
        ELSE 'Unknown Version'
    END AS WindowsVersion,*
FROM 
    _01

    
USE DBAtools
GO

IF OBJECT_ID('dbo.tbl_ServerCompatibility') IS NOT NULL --SET
BEGIN;
    DROP TABLE dbo.tbl_ServerCompatibility; -- SET
END;

GO


CREATE TABLE dbo.tbl_ServerCompatibility (
    WindowsServerVersion VARCHAR(256),
    SQLServer2022 VARCHAR(256),
    SQLServer2019 VARCHAR(256),
    SQLServer2017 VARCHAR(256),
    SQLServer2016 VARCHAR(256),
    SQLServer2014 VARCHAR(256),
    SQLServer2012 VARCHAR(256),
    SQLServer2008R2 VARCHAR(256),
    SQLServer2008 VARCHAR(256)
);


INSERT INTO dbo.tbl_ServerCompatibility VALUES
('Windows Server 2025', 'Yes (RTM, CU16)', 'Yes (RTM, CU30)', 'Not supported', 'Not supported', 'Not supported', 'Not supported', 'Not supported', 'Not supported'),
('Windows Server 2022', 'Yes (RTM, CU16)', 'Yes (RTM, CU30)', 'Yes (RTM, CU31)', 'Not supported', 'Not supported', 'Not supported', 'Not supported', 'Not supported'),
('Windows Server 2019', 'Yes (RTM, CU16)', 'Yes (RTM, CU30)', 'Yes (RTM, CU31)', 'Yes (SP2, CU17)', 'Yes (SP3, CU17)', 'Yes (SP4, CU17)', 'Not supported', 'Not supported'),
('Windows Server 2016', 'Yes (RTM, CU16)', 'Yes (RTM, CU30)', 'Yes (RTM, CU31)', 'Yes (SP2, CU17)', 'Yes (SP3, CU17)', 'Yes (SP4, CU17)', 'Not supported', 'Not supported'),
('Windows Server 2012 R2', 'No', 'No', 'Yes (RTM, CU31)', 'Yes (SP2, CU17)', 'Yes (SP3, CU17)', 'Yes (SP4, CU17)', 'Yes (SP3, CU17)', 'Yes (SP4, CU17)'),
('Windows Server 2012', 'No', 'No', 'Yes (RTM, CU31)', 'Yes (SP2, CU17)', 'Yes (SP3, CU17)', 'Yes (SP4, CU17)', 'Yes (SP3, CU17)', 'Yes (SP4, CU17)');



SELECT * FROM dbo.tbl_ServerCompatibility


SELECT @@VERSION

