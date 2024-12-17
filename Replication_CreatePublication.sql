-- Enabling the replication database
use master
exec sp_replicationdboption @dbname = N'StackOverflow2010', @optname = N'publish', @value = N'true'
GO

-- Adding the snapshot publication
use [StackOverflow2010]
exec sp_addpublication @publication = N'BadgesTable', @description = N'Snapshot publication of database ''StackOverflow2010'' from Publisher ''LAPTOP-OK2JQJ3O''.', @sync_method = N'native', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'true', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @compress_snapshot = N'false', @ftp_port = 21, @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'snapshot', @status = N'active', @independent_agent = N'true', @immediate_sync = N'true', @allow_sync_tran = N'false', @autogen_sync_procs = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1
GO


exec sp_addpublication_snapshot @publication = N'BadgesTable', @frequency_type = 4, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 0, @frequency_subday = 8, @frequency_subday_interval = 1, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = null, @job_password = null, @publisher_security_mode = 1


use [StackOverflow2010]
exec sp_addarticle @publication = N'BadgesTable', @article = N'Badges', @source_owner = N'dbo', @source_object = N'Badges', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Badges', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




