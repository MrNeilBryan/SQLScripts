USE SQLAdministration
GO
SET NOCOUNT ON
GO

DECLARE @JobName NVARCHAR(4000) = N'';
DECLARE @Stmt NVARCHAR(4000) = N'';
DECLARE @JobHistory TABLE (JobName NVARCHAR(4000), MinsToRun DECIMAL(38,2), StartTime DATETIME, [Status] NVARCHAR(64));

DECLARE @Template NVARCHAR(4000) = N'
DECLARE @JobName NVARCHAR(256) = N''__JOBNAME__'';
DECLARE @EndDateSt DATETIME = GETDATE();
DECLARE @StartDateDt DATETIME = DATEADD(DAY,-0,@EndDateSt);
DECLARE @StartDate INT = CAST(CONVERT(NVARCHAR(256),@StartDateDt,112) AS INT);
DECLARE @EndDate INT = CAST(CONVERT(NVARCHAR(256),@EndDateSt,112) AS INT);


WITH _01 AS
(
    SELECT  top (1) h.step_id,  j.name, CAST(DATEDIFF(SECOND,msdb.dbo.agent_datetime(h.run_date, 0), msdb.dbo.agent_datetime(h.run_date, h.run_duration))/60. AS DECIMAL(38,2)) MinutesToRun,
    msdb.dbo.agent_datetime(h.run_date, h.run_time) AS StartTime,
    CASE h.run_status WHEN 0 THEN ''Failed'' WHEN 1 THEN ''SUCCESS'' WHEN 2 THEN ''RETRY'' WHEN 3 THEN ''CANCELLED'' ELSE ''IN PROGRESS'' END AS [Status]
    FROM msdb.dbo.sysjobs j JOIN msdb.dbo.sysjobhistory h ON j.job_id = h.job_id
    WHERE j.name = @JobName
    AND h.run_date =  @StartDate  
    AND h.step_id=0
    ORDER BY instance_id DESC

)

SELECT MinutesToRun, StartTime, Status FROM _01';


DECLARE @Jobs TABLE (DatabaseName NVARCHAR(256), 
                  SubscrptionType NVARCHAR(256),
                  JobName NVARCHAR(4000), 
                  AgentName NVARCHAR(4000), 
                  PublisherName NVARCHAR(256), 
                  SubscriberName NVARCHAR(256), 
                  PublisherDatabase NVARCHAR(2546), 
                  SubscriberDatabase NVARCHAR(256))

INSERT @Jobs (DatabaseName,SubscrptionType,JobName,AgentName,PublisherName,SubscriberName, PublisherDatabase, SubscriberDatabase)

EXEC sp_msforeachdb '
USE [?]
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = ''MSdistribution_agents'')
BEGIN
    SELECT DB_NAME() AS DatabaseName, 
          CASE subscription_type WHEN 0 THEN ''Push'' WHEN 1 THEN ''Pull'' WHEN 2 THEN ''Anonymous'' ELSE ''Unknown'' END AS SubscriptionType,
          job.name AS JobName, 
          a.name AS AgentName, 
          sp.name AS PublisherName, 
          ss.name AS SubscriberName,
          a.publisher_db AS PublisherDatabase, 
          a.subscriber_db AS SubscriberDatabase 
    FROM MSdistribution_agents a INNER JOIN sys.servers sp ON a.publisher_id = sp.server_id 
    INNER JOIN sys.servers ss ON a.subscriber_id = ss.server_id 
    LEFT JOIN msdb.dbo.sysjobs job ON job.job_id = a.job_id  
    WHERE DB_NAME() IN (SELECT [name] FROM sys.databases WHERE is_distributor = 1)
END';

SELECT * FROM @Jobs

DECLARE cu CURSOR FOR SELECT JobName FROM @Jobs
OPEN cu 
FETCH cu INTO @JobName
WHILE @@FETCH_STATUS <> -1
BEGIN
    DELETE @JobHistory
    SET @stmt = REPLACE(@Template, '__JOBNAME__',@JobName);
    print @stmt
    break
    --INSERT @JobHistory (JobName, MinsToRun, StartTime, [Status])
    FETCH cu INTO @JobName
END
CLOSE cu 
DEALLOCATE cu
