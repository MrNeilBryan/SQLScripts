use distribution--in distributor server
if not exists(select 1 from sys.tables where name ='MSreplservers')
begin
select job.name JobName, a.name AgentName , publisher_db,publication, s.data_source as publisher,
case publication_type
when 0 then 'Transactional'
when 1 then 'snapshot'
when 2 then 'Merge'
end as publication_type
   From MSsnapshot_agents a inner join sys.servers s on a.publisher_id=s.server_id
   inner join msdb..sysjobs job on a.job_id=job.job_id
 
end
else
begin
select job.name JobName, a.name AgentName, publisher_db,publication, s.srvname as publisher,
case publication_type
when 0 then 'Transactional'
when 1 then 'snapshot'
when 2 then 'Merge'
end as publication_type
   From MSsnapshot_agents a inner join MSreplservers s on a.publisher_id=s.srvid
   inner join msdb..sysjobs job on a.job_id=job.job_id
end
