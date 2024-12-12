--Distributor AGent
USE distribution ---in distributor server

IF NOT EXISTS (
		SELECT 1
		FROM sys.tables
		WHERE name = 'MSreplservers'
		)
BEGIN
	SELECT 'Distribution Agent' AS Info, job.name JobName, a.name AgentName, a.publisher_db, a.publication AS publicationName, sp.name AS publisherName, ss.name AS subscriber, a.subscriber_db, a.local_job
	FROM MSdistribution_agents a
	INNER JOIN sys.servers sp ON a.publisher_id = sp.server_id --publisher
	INNER JOIN sys.servers ss ON a.subscriber_id = ss.server_id --subscriber
	LEFT JOIN msdb..sysjobs job ON job.job_id = a.job_id
	WHERE a.subscription_type <> 2 --- filter out the anonymous subscriber
END
ELSE
BEGIN
	SELECT 'Distribution Agent' AS Info, job.name JobName, a.name AgentName, a.publisher_db, a.publication AS publicationName, sp.srvname AS publisherName, ss.srvname AS subscriber, a.subscriber_db, a.local_job
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
	SELECT 'Snapshot Agent' AS Info, job.name JobName, a.name AgentName, publisher_db, publication, s.data_source AS publisher, CASE publication_type
			WHEN 0
				THEN 'Transactional'
			WHEN 1
				THEN 'snapshot'
			WHEN 2
				THEN 'Merge'
			END AS publication_type
	FROM MSsnapshot_agents a
	INNER JOIN sys.servers s ON a.publisher_id = s.server_id
	INNER JOIN msdb..sysjobs job ON a.job_id = job.job_id
END
ELSE
BEGIN
	SELECT 'Snapshot Agent' AS Info, job.name JobName, a.name AgentName, publisher_db, publication, s.srvname AS publisher, CASE publication_type
			WHEN 0
				THEN 'Transactional'
			WHEN 1
				THEN 'snapshot'
			WHEN 2
				THEN 'Merge'
			END AS publication_type
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
	SELECT job.name JobName, a.name AgentName, publisher_db, s.name AS publisher
	FROM MSlogreader_agents a
	INNER JOIN sys.servers s ON a.publisher_id = s.server_id
	INNER JOIN msdb..sysjobs job ON job.job_id = a.job_id
END
ELSE
BEGIN
	SELECT 'LogReader Agent' AS Info, job.name JobName, a.name AgentName, publisher_db, s.srvname AS publisher
	FROM MSlogreader_agents a
	INNER JOIN MSreplservers s ON a.publisher_id = s.srvid
	INNER JOIN msdb..sysjobs job ON job.job_id = a.job_id
END