--Distributor AGent
USE distribution ---in distributor server
GO

DECLARE @T TABLE (PublisherID INT, AgentJobName NVARCHAR(4000), Info NVARCHAR(4000), PublicationType NVARCHAR(4000),PublicationName NVARCHAR(4000));

IF NOT EXISTS (
		SELECT 1
		FROM sys.tables
		WHERE name = 'MSreplservers'
		)
BEGIN
	INSERT @T (PublisherID,Info,AgentJobName,PublicationName)
	SELECT publisher_id, 'Distribution Agent' AS Info, a.name AgentName , publication 
	FROM MSdistribution_agents a
	INNER JOIN sys.servers sp ON a.publisher_id = sp.server_id --publisher
	INNER JOIN sys.servers ss ON a.subscriber_id = ss.server_id --subscriber
	LEFT JOIN msdb..sysjobs job ON job.job_id = a.job_id
	WHERE a.subscription_type <> 2 --- filter out the anonymous subscriber
END
ELSE
BEGIN
	INSERT @T (PublisherID,Info,AgentJobName,PublicationName)
	SELECT publisher_id, 'Distribution Agent' AS Info, a.name AgentName , publication
	FROM MSdistribution_agents a
	INNER JOIN msreplservers sp ON a.publisher_id = sp.srvid --publisher
	INNER JOIN msreplservers ss ON a.subscriber_id = ss.srvid --subscriber
	LEFT JOIN msdb..sysjobs job ON job.job_id = a.job_id
	WHERE a.subscription_type <> 2 --- filter out the anonymous subscriber
END

-- 2 Snapshot agent
USE distribution --in distributor server

IF NOT EXISTS (
		SELECT 1
		FROM sys.tables
		WHERE name = 'MSreplservers'
		)
BEGIN
	INSERT @T (PublisherID,Info,AgentJobName,PublicationType,PublicationName)
	SELECT publisher_id, 'Snapshot Agent' AS Info, a.name AgentName, CASE publication_type
			WHEN 0
				THEN 'Transactional'
			WHEN 1
				THEN 'snapshot'
			WHEN 2
				THEN 'Merge'
			END AS publication_type,publication
	FROM MSsnapshot_agents a
	INNER JOIN sys.servers s ON a.publisher_id = s.server_id
	INNER JOIN msdb..sysjobs job ON a.job_id = job.job_id
END
ELSE
BEGIN
	INSERT @T (PublisherID,Info,AgentJobName,PublicationType,PublicationName)
	SELECT publisher_id, 'Snapshot Agent' AS Info, a.name AgentName, CASE publication_type
			WHEN 0
				THEN 'Transactional'
			WHEN 1
				THEN 'snapshot'
			WHEN 2
				THEN 'Merge'
			END AS publication_type,publication
	FROM MSsnapshot_agents a
	INNER JOIN MSreplservers s ON a.publisher_id = s.srvid
	INNER JOIN msdb..sysjobs job ON a.job_id = job.job_id
END

--3 Logreader
USE distribution

IF NOT EXISTS (
		SELECT 1
		FROM sys.tables
		WHERE name = 'MSreplservers'
		)
BEGIN
	INSERT @T (PublisherID,Info,AgentJobName,PublicationName)
	SELECT publisher_id,'LogReader Agent' AS Info, a.name AgentName ,publication
	FROM MSlogreader_agents a
	INNER JOIN sys.servers s ON a.publisher_id = s.server_id
	INNER JOIN msdb..sysjobs job ON job.job_id = a.job_id
END
ELSE
BEGIN
	INSERT @T (PublisherID,Info,AgentJobName,PublicationName)
	SELECT  publisher_id,'LogReader Agent' AS Info, a.name AS AgentName,publication
	FROM MSlogreader_agents a
	INNER JOIN MSreplservers s ON a.publisher_id = s.srvid
	INNER JOIN msdb..sysjobs job ON job.job_id = a.job_id
END 

--SELECT * FROM @T;

SELECT DISTINCT  p.publisher_id,
s1.srvname AS PublisherServer,  ms.[publisher_db] AS PublisherDB,s2.srvname AS SubscriberServer,[subscriber_db]
SubscriberDB, publication
      
      
      ,CASE [subscription_type] when 0 THEN 'Push' WHEN 1 THEN 'Pull' WHEN 2 THEN 'Anonymous' ELSE 'Unknown' END AS SubscriptionType
      ,CASE [sync_type] WHEN 1 THEN 'Automatic' WHEN 2 THEN 'No synchronisation' ELSE 'Unknown' END AS SyncType
      ,CASE [status] WHEN 0 THEN 'Inactive' WHEN 1 THEN 'Subscribed' WHEN 2 THEN 'Active' ELSE 'Unknown' END [Status]


 ,p.description
 ,da.AgentJobName AS DistributionAgentJob
 ,sa.AgentJobName AS SnapshotAgentJob
 ,sa.PublicationType AS PublicationType
 ,CASE WHEN sa.PublicationType = 'Transactional' THEN lr.AgentJobName ELSE  NULL END AS LogReaderAgentJob 
  FROM [distribution].[dbo].[MSsubscriptions] ms

  INNER JOIN [dbo].[MSreplservers] s1 ON s1.srvid = ms.publisher_id
  inner join [dbo].[MSreplservers] s2 ON s2.srvid = ms.subscriber_id
  INNER JOIN dbo.MSpublications p ON p.publication_id = ms.publication_id
  LEFT JOIN @T AS da ON da.PublisherID = ms.publisher_id AND  da.Info = 'Distribution Agent' and da.PublicationName = p.publication
  LEFT JOIN @T AS sa ON da.PublisherID = ms.publisher_id AND  sa.Info = 'Snapshot Agent' and sa.PublicationName = p.publication
  LEFT JOIN @T AS lr ON da.PublisherID = ms.publisher_id AND  lr.Info = 'LogReader Agent' --and lr.PublicationName = p.publication
