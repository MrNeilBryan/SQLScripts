USE [DBAtools] 

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
 
 

-----------------------------------------------------------------------------
-- Name:       xxx.xxxx
-- Author:     Neil Bryan
-- Date:       20230129
-- Description:Backup the backup meta data to a native backup file.
--
-- Amendments:
-- -----------
--
-- Who                  When         Ref              Description
-- ---                  ----         ---              -----------
-- 
-----------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE xxx.xxxx

AS
BEGIN
	------------------------------------------------------------------------------------
	-- Locals
	------------------------------------------------------------------------------------
	DECLARE @ObjectName NVARCHAR(MAX) = 'xxx.xxxx';
	DECLARE @ProcessTime DATETIME = GETDATE();
	DECLARE @ProcMessage NVARCHAR(4000) = N'';

	------------------------------------------------------------------------------------
	-- Initialize
	------------------------------------------------------------------------------------
	SET NOCOUNT ON;
 

	------------------------------------------------------------------------------------
	-- Main processing and error handling start
	------------------------------------------------------------------------------------
	BEGIN TRY
		SET @ProcMessage = @ObjectName + N' - ' +  CONVERT(NVARCHAR(64), GETDATE(),120) + N' - Starting.';
		RAISERROR (@ProcMessage,10,1);

		------------------------------------------------------------------------------------
		-- Finish
		-----------------------------------------------------------------------------------
		SET NOCOUNT OFF;
	END TRY

	BEGIN CATCH
		DECLARE @Catch_ErrorMessage NVARCHAR(4000);
		DECLARE @Catch_ErrorSeverity INT;
		DECLARE @Catch_ErrorState INT;
		DECLARE @Catch_Subject VARCHAR(256);

		SELECT @Catch_ErrorMessage = ERROR_MESSAGE()
			,@Catch_ErrorSeverity = ERROR_SEVERITY()
			,@Catch_ErrorState = ERROR_STATE();

		RAISERROR (@Catch_ErrorMessage,@Catch_ErrorSeverity,@Catch_ErrorState);
		 
		
		WHILE (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK;
		END

 
	END CATCH


END


