DECLARE @s VARCHAR(MAX)


IF OBJECT_ID('tempdb.dbo.quick_debug') IS NOT NULL DROP TABLE tempdb.dbo.quick_debug;
 

EXEC sp_WhoIsActive
    @format_output = 0,@get_plans=1,
    @return_schema = 1,
    @schema = @s OUTPUT

SET @s = REPLACE(@s, '<table_name>', 'tempdb.dbo.quick_debug')

EXEC(@s)
GO

EXEC sp_WhoIsActive
    @format_output = 0,@get_plans = 1,
    @destination_table = 'tempdb.dbo.quick_debug'


select * from tempdb.dbo.quick_debug

IF OBJECT_ID('tempdb.dbo.quick_debug') IS NOT NULL DROP TABLE tempdb.dbo.quick_debug;
 