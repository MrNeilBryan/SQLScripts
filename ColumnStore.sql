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
CREATE TABLE dbo.tbl_Account
(
	 CustomerID				INT IDENTITY (1,1) PRIMARY KEY
	,TransactionDate		DATE		NOT NULL
	,TransactionAmount		MONEY		NOT NULL
	,TaxCode				CHAR(1)		NOT NULL
	,TaxAmount				MONEY		NOT NULL DEFAULT 0
	,Val1					MONEY		NOT NULL DEFAULT 0
	,Val2					MONEY		NOT NULL DEFAULT 0
	,Val3					MONEY		NOT NULL DEFAULT 0
	,Val4					MONEY		NOT NULL DEFAULT 0
	,Val5					MONEY		NOT NULL DEFAULT 0
	,Val6					MONEY		NOT NULL DEFAULT 0
	,Val7					MONEY		NOT NULL DEFAULT 0
	,Val8					MONEY		NOT NULL DEFAULT 0
	,Val9					MONEY		NOT NULL DEFAULT 0
	,Val10					MONEY		NOT NULL DEFAULT 0
	,Val11					MONEY		NOT NULL DEFAULT 0
	,Val12					MONEY		NOT NULL DEFAULT 0
	,Val13					MONEY		NOT NULL DEFAULT 0
	,Val14					MONEY		NOT NULL DEFAULT 0
	,Val15					MONEY		NOT NULL DEFAULT 0
	,Val16					MONEY		NOT NULL DEFAULT 0
	,Val17					MONEY		NOT NULL DEFAULT 0
	,Val18					MONEY		NOT NULL DEFAULT 0
	,Val19					MONEY		NOT NULL DEFAULT 0
	,Val20					MONEY		NOT NULL DEFAULT 0
	,Val21					MONEY		NOT NULL DEFAULT 0
	,Val22					MONEY		NOT NULL DEFAULT 0
	,Val23					MONEY		NOT NULL DEFAULT 0
	,Val24					MONEY		NOT NULL DEFAULT 0
	,Val25					MONEY		NOT NULL DEFAULT 0
	,Val26					MONEY		NOT NULL DEFAULT 0
	,Val27					MONEY		NOT NULL DEFAULT 0
	,Val28					MONEY		NOT NULL DEFAULT 0
	,Val29					MONEY		NOT NULL DEFAULT 0
	,Val30					MONEY		NOT NULL DEFAULT 0
	,Val31					MONEY		NOT NULL DEFAULT 0
	,Val32					MONEY		NOT NULL DEFAULT 0
	,Val33					MONEY		NOT NULL DEFAULT 0
	,Val34					MONEY		NOT NULL DEFAULT 0
	,Val35					MONEY		NOT NULL DEFAULT 0
	,Val36					MONEY		NOT NULL DEFAULT 0
	,Val37					MONEY		NOT NULL DEFAULT 0
	,Val38					MONEY		NOT NULL DEFAULT 0
	,Val39					MONEY		NOT NULL DEFAULT 0
	,Val40					MONEY		NOT NULL DEFAULT 0
	,Val41					MONEY		NOT NULL DEFAULT 0
	,Val42					MONEY		NOT NULL DEFAULT 0
	,Val43					MONEY		NOT NULL DEFAULT 0
	,Val44					MONEY		NOT NULL DEFAULT 0
	,Val45					MONEY		NOT NULL DEFAULT 0
	,Val46					MONEY		NOT NULL DEFAULT 0
	,Val47					MONEY		NOT NULL DEFAULT 0
	,Val48					MONEY		NOT NULL DEFAULT 0
	,Val49					MONEY		NOT NULL DEFAULT 0
	,Val50					MONEY		NOT NULL DEFAULT 0
	,Val51					MONEY		NOT NULL DEFAULT 0
	,Val52					MONEY		NOT NULL DEFAULT 0
	,Val53					MONEY		NOT NULL DEFAULT 0
	,Val54					MONEY		NOT NULL DEFAULT 0
	,Val55					MONEY		NOT NULL DEFAULT 0
	,Val56					MONEY		NOT NULL DEFAULT 0
	,Val57					MONEY		NOT NULL DEFAULT 0
	,Val58					MONEY		NOT NULL DEFAULT 0
	,Val59					MONEY		NOT NULL DEFAULT 0
	,Val60					MONEY		NOT NULL DEFAULT 0
	,Val61					MONEY		NOT NULL DEFAULT 0
	,Val62					MONEY		NOT NULL DEFAULT 0
	,Val63					MONEY		NOT NULL DEFAULT 0
	,Val64					MONEY		NOT NULL DEFAULT 0
	,Val65					MONEY		NOT NULL DEFAULT 0
	,Val66					MONEY		NOT NULL DEFAULT 0
	,Val67					MONEY		NOT NULL DEFAULT 0
	,Val68					MONEY		NOT NULL DEFAULT 0
	,Val69					MONEY		NOT NULL DEFAULT 0
	,Val70					MONEY		NOT NULL DEFAULT 0
	,Val71					MONEY		NOT NULL DEFAULT 0
	,Val72					MONEY		NOT NULL DEFAULT 0
	,Val73					MONEY		NOT NULL DEFAULT 0
	,Val74					MONEY		NOT NULL DEFAULT 0
	,Val75					MONEY		NOT NULL DEFAULT 0
	,Val76					MONEY		NOT NULL DEFAULT 0
	,Val77					MONEY		NOT NULL DEFAULT 0
	,Val78					MONEY		NOT NULL DEFAULT 0
	,Val79					MONEY		NOT NULL DEFAULT 0
	,Val80					MONEY		NOT NULL DEFAULT 0
	,Val81					MONEY		NOT NULL DEFAULT 0
	,Val82					MONEY		NOT NULL DEFAULT 0
	,Val83					MONEY		NOT NULL DEFAULT 0
	,Val84					MONEY		NOT NULL DEFAULT 0
	,Val85					MONEY		NOT NULL DEFAULT 0
	,Val86					MONEY		NOT NULL DEFAULT 0
	,Val87					MONEY		NOT NULL DEFAULT 0
	,Val88					MONEY		NOT NULL DEFAULT 0
	,Val89					MONEY		NOT NULL DEFAULT 0
	,Val90					MONEY		NOT NULL DEFAULT 0
	,Val91					MONEY		NOT NULL DEFAULT 0
	,Val92					MONEY		NOT NULL DEFAULT 0
	,Val93					MONEY		NOT NULL DEFAULT 0
	,Val94					MONEY		NOT NULL DEFAULT 0
	,Val95					MONEY		NOT NULL DEFAULT 0
	,Val96					MONEY		NOT NULL DEFAULT 0
	,Val97					MONEY		NOT NULL DEFAULT 0
	,Val98					MONEY		NOT NULL DEFAULT 0
	,Val99					MONEY		NOT NULL DEFAULT 0
	,Val100					MONEY		NOT NULL DEFAULT 0
)  ;
GO

----------------------------------------------------------------------------------------------------------------
-- Populate the work table
----------------------------------------------------------------------------------------------------------------
USE SlowSQLServer
GO
DECLARE @DT			DATE = '20230101';
DECLARE @i			INT = 0;
DECLARE @TxCode		CHAR(1);
DECLARE @Rand		INT;
DECLARE @CustomerID	INT = 0;
 		
WHILE @i < 1000000
BEGIN
	SET @Rand = FLOOR(RAND() * (364-1 + 1)) + 1;
	SET @DT = DATEADD(DAY, @Rand, '20220101');
	INSERT dbo.tbl_Account (TransactionDate,TransactionAmount,TaxCode) 	  SELECT @DT, @i, CHAR((@i %26) + 40)
	SELECT @CustomerID = MAX(CustomerID) FROM  dbo.tbl_Account;

	UPDATE dbo.tbl_Account 
	SET Val1 = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val2	 = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val3	 = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val4	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val5	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val6	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val7	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val8	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val9	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val10	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val11	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val12	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val13	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val14	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val15	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val16	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val17	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val18	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val19	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val20	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val21	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val22	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val23	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val24	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val25	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val26	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val27	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val28	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val29	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val30	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val31	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val32	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val33	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val34	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val35	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val36	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val37	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val38	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val39	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val40	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val41	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val42	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val43	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val44	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val45	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val46	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val47	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val48	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val49	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val50	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val51	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val52	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val53	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val54	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val55	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val56	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val57	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val58	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val59	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val60	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val61	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val62	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val63	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val64	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val65	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val66	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val67	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val68	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val69	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val70	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val71	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val72	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val73	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val74	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val75	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val76	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val77	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val78	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val79	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val80	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val81	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val82	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val83	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val84	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val85	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val86	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val87	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val88	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val89	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val90	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val91	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val92	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val93	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val94	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val95	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val96	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val97	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val98	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val99	    = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	,Val100	 = 	FLOOR(RAND() * (999999-1 + 1)) + 1
	WHERE CustomerID = @CustomerID;
	
	
	


	
	SET @i +=1;
END
GO


----------------------------------------------------------------------------------------------------------------
-- Create a non clustered index on the table
----------------------------------------------------------------------------------------------------------------
USE SlowSQLServer
GO
CREATE INDEX NCI_TransactionDate ON dbo.tbl_Account (TransactionDate);
GO

----------------------------------------------------------------------------------------------------------------
-- Create a columnstore version of the table
----------------------------------------------------------------------------------------------------------------
USE SlowSQLServer
GO
CREATE TABLE dbo.tbl_Account_ColumnStore
(
	 CustomerID				INT IDENTITY (1,1) 
	,TransactionDate		DATE		NOT NULL
	,TransactionAmount		MONEY		NOT NULL
	,TaxCode				CHAR(1)		NOT NULL
	,TaxAmount				MONEY		NOT NULL DEFAULT 0
	,Val1					MONEY		NOT NULL DEFAULT 0
	,Val2					MONEY		NOT NULL DEFAULT 0
	,Val3					MONEY		NOT NULL DEFAULT 0
	,Val4					MONEY		NOT NULL DEFAULT 0
	,Val5					MONEY		NOT NULL DEFAULT 0
	,Val6					MONEY		NOT NULL DEFAULT 0
	,Val7					MONEY		NOT NULL DEFAULT 0
	,Val8					MONEY		NOT NULL DEFAULT 0
	,Val9					MONEY		NOT NULL DEFAULT 0
	,Val10					MONEY		NOT NULL DEFAULT 0
	,Val11					MONEY		NOT NULL DEFAULT 0
	,Val12					MONEY		NOT NULL DEFAULT 0
	,Val13					MONEY		NOT NULL DEFAULT 0
	,Val14					MONEY		NOT NULL DEFAULT 0
	,Val15					MONEY		NOT NULL DEFAULT 0
	,Val16					MONEY		NOT NULL DEFAULT 0
	,Val17					MONEY		NOT NULL DEFAULT 0
	,Val18					MONEY		NOT NULL DEFAULT 0
	,Val19					MONEY		NOT NULL DEFAULT 0
	,Val20					MONEY		NOT NULL DEFAULT 0
	,Val21					MONEY		NOT NULL DEFAULT 0
	,Val22					MONEY		NOT NULL DEFAULT 0
	,Val23					MONEY		NOT NULL DEFAULT 0
	,Val24					MONEY		NOT NULL DEFAULT 0
	,Val25					MONEY		NOT NULL DEFAULT 0
	,Val26					MONEY		NOT NULL DEFAULT 0
	,Val27					MONEY		NOT NULL DEFAULT 0
	,Val28					MONEY		NOT NULL DEFAULT 0
	,Val29					MONEY		NOT NULL DEFAULT 0
	,Val30					MONEY		NOT NULL DEFAULT 0
	,Val31					MONEY		NOT NULL DEFAULT 0
	,Val32					MONEY		NOT NULL DEFAULT 0
	,Val33					MONEY		NOT NULL DEFAULT 0
	,Val34					MONEY		NOT NULL DEFAULT 0
	,Val35					MONEY		NOT NULL DEFAULT 0
	,Val36					MONEY		NOT NULL DEFAULT 0
	,Val37					MONEY		NOT NULL DEFAULT 0
	,Val38					MONEY		NOT NULL DEFAULT 0
	,Val39					MONEY		NOT NULL DEFAULT 0
	,Val40					MONEY		NOT NULL DEFAULT 0
	,Val41					MONEY		NOT NULL DEFAULT 0
	,Val42					MONEY		NOT NULL DEFAULT 0
	,Val43					MONEY		NOT NULL DEFAULT 0
	,Val44					MONEY		NOT NULL DEFAULT 0
	,Val45					MONEY		NOT NULL DEFAULT 0
	,Val46					MONEY		NOT NULL DEFAULT 0
	,Val47					MONEY		NOT NULL DEFAULT 0
	,Val48					MONEY		NOT NULL DEFAULT 0
	,Val49					MONEY		NOT NULL DEFAULT 0
	,Val50					MONEY		NOT NULL DEFAULT 0
	,Val51					MONEY		NOT NULL DEFAULT 0
	,Val52					MONEY		NOT NULL DEFAULT 0
	,Val53					MONEY		NOT NULL DEFAULT 0
	,Val54					MONEY		NOT NULL DEFAULT 0
	,Val55					MONEY		NOT NULL DEFAULT 0
	,Val56					MONEY		NOT NULL DEFAULT 0
	,Val57					MONEY		NOT NULL DEFAULT 0
	,Val58					MONEY		NOT NULL DEFAULT 0
	,Val59					MONEY		NOT NULL DEFAULT 0
	,Val60					MONEY		NOT NULL DEFAULT 0
	,Val61					MONEY		NOT NULL DEFAULT 0
	,Val62					MONEY		NOT NULL DEFAULT 0
	,Val63					MONEY		NOT NULL DEFAULT 0
	,Val64					MONEY		NOT NULL DEFAULT 0
	,Val65					MONEY		NOT NULL DEFAULT 0
	,Val66					MONEY		NOT NULL DEFAULT 0
	,Val67					MONEY		NOT NULL DEFAULT 0
	,Val68					MONEY		NOT NULL DEFAULT 0
	,Val69					MONEY		NOT NULL DEFAULT 0
	,Val70					MONEY		NOT NULL DEFAULT 0
	,Val71					MONEY		NOT NULL DEFAULT 0
	,Val72					MONEY		NOT NULL DEFAULT 0
	,Val73					MONEY		NOT NULL DEFAULT 0
	,Val74					MONEY		NOT NULL DEFAULT 0
	,Val75					MONEY		NOT NULL DEFAULT 0
	,Val76					MONEY		NOT NULL DEFAULT 0
	,Val77					MONEY		NOT NULL DEFAULT 0
	,Val78					MONEY		NOT NULL DEFAULT 0
	,Val79					MONEY		NOT NULL DEFAULT 0
	,Val80					MONEY		NOT NULL DEFAULT 0
	,Val81					MONEY		NOT NULL DEFAULT 0
	,Val82					MONEY		NOT NULL DEFAULT 0
	,Val83					MONEY		NOT NULL DEFAULT 0
	,Val84					MONEY		NOT NULL DEFAULT 0
	,Val85					MONEY		NOT NULL DEFAULT 0
	,Val86					MONEY		NOT NULL DEFAULT 0
	,Val87					MONEY		NOT NULL DEFAULT 0
	,Val88					MONEY		NOT NULL DEFAULT 0
	,Val89					MONEY		NOT NULL DEFAULT 0
	,Val90					MONEY		NOT NULL DEFAULT 0
	,Val91					MONEY		NOT NULL DEFAULT 0
	,Val92					MONEY		NOT NULL DEFAULT 0
	,Val93					MONEY		NOT NULL DEFAULT 0
	,Val94					MONEY		NOT NULL DEFAULT 0
	,Val95					MONEY		NOT NULL DEFAULT 0
	,Val96					MONEY		NOT NULL DEFAULT 0
	,Val97					MONEY		NOT NULL DEFAULT 0
	,Val98					MONEY		NOT NULL DEFAULT 0
	,Val99					MONEY		NOT NULL DEFAULT 0
	,Val100					MONEY		NOT NULL DEFAULT 0
)  ;
GO

 
----------------------------------------------------------------------------------------------------------------
-- Populate the ColumnStore table.
----------------------------------------------------------------------------------------------------------------
USE SlowSQLServer
GO
SET IDENTITY_INSERT  dbo.tbl_Account_ColumnStore ON;
INSERT dbo.tbl_Account_ColumnStore 
(
[CustomerID], [TransactionDate], [TransactionAmount], [TaxCode], [TaxAmount], [Val1], [Val2], [Val3], [Val4], [Val5], [Val6], [Val7], [Val8], [Val9], [Val10], [Val11], [Val12], [Val13], [Val14], [Val15], [Val16], [Val17], [Val18], [Val19], [Val20], [Val21], [Val22], [Val23], [Val24], [Val25], [Val26], [Val27], [Val28], [Val29], [Val30], [Val31], [Val32], [Val33], [Val34], [Val35], [Val36], [Val37], [Val38], [Val39], [Val40], [Val41], [Val42], [Val43], [Val44], [Val45], [Val46], [Val47], [Val48], [Val49], [Val50], [Val51], [Val52], [Val53], [Val54], [Val55], [Val56], [Val57], [Val58], [Val59], [Val60], [Val61], [Val62], [Val63], [Val64], [Val65], [Val66], [Val67], [Val68], [Val69], [Val70], [Val71], [Val72], [Val73], [Val74], [Val75], [Val76], [Val77], [Val78], [Val79], [Val80], [Val81], [Val82], [Val83], [Val84], [Val85], [Val86], [Val87], [Val88], [Val89], [Val90], [Val91], [Val92], [Val93], [Val94], [Val95], [Val96], [Val97], [Val98], [Val99], [Val100]
)

SELECT [CustomerID], [TransactionDate], [TransactionAmount], [TaxCode], [TaxAmount], [Val1], [Val2], [Val3], [Val4], [Val5], [Val6], [Val7], [Val8], [Val9], [Val10], [Val11], [Val12], [Val13], [Val14], [Val15], [Val16], [Val17], [Val18], [Val19], [Val20], [Val21], [Val22], [Val23], [Val24], [Val25], [Val26], [Val27], [Val28], [Val29], [Val30], [Val31], [Val32], [Val33], [Val34], [Val35], [Val36], [Val37], [Val38], [Val39], [Val40], [Val41], [Val42], [Val43], [Val44], [Val45], [Val46], [Val47], [Val48], [Val49], [Val50], [Val51], [Val52], [Val53], [Val54], [Val55], [Val56], [Val57], [Val58], [Val59], [Val60], [Val61], [Val62], [Val63], [Val64], [Val65], [Val66], [Val67], [Val68], [Val69], [Val70], [Val71], [Val72], [Val73], [Val74], [Val75], [Val76], [Val77], [Val78], [Val79], [Val80], [Val81], [Val82], [Val83], [Val84], [Val85], [Val86], [Val87], [Val88], [Val89], [Val90], [Val91], [Val92], [Val93], [Val94], [Val95], [Val96], [Val97], [Val98], [Val99], [Val100] 
FROM dbo.tbl_Account
SET IDENTITY_INSERT  dbo.tbl_Account_ColumnStore OFF;
GO


----------------------------------------------------------------------------------------------------------------
-- Add a column store clsutered key to bo.tbl_Account_ColumnStore
----------------------------------------------------------------------------------------------------------------
USE SlowSQLServer
GO
CREATE CLUSTERED COLUMNSTORE INDEX CCI ON dbo.tbl_Account_ColumnStore;


--7.172 MB
--868.063 MB



----------------------------------------------------------------------------------------------------------------
-- Testing
----------------------------------------------------------------------------------------------------------------
USE SlowSQLServer
GO
SET STATISTICS IO ON
SET STATISTICS TIME ON
GO
SELECT * FROM [dbo].[tbl_Account_ColumnSTore] WHERE TransactionDate >= '20220801' AND TransactionDate <= '20220830';
GO

USE SlowSQLServer
GO
SET STATISTICS IO ON
SET STATISTICS TIME ON
GO
SELECT * FROM [dbo].[tbl_Account] WHERE TransactionDate >= '20220801' AND TransactionDate <= '20220830';