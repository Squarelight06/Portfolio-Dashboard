/* GetPerformanceAttribution - provides the returns of each asset type (in percentage) along with their portfolio weights (in percentage). 
Important Notes: - The procedure provides only a view of the performance attributes.
                 - The procedure depends on the GetAssetHistory procedure.
*/
CREATE PROCEDURE GetPerformanceAttribution
AS
BEGIN
DECLARE @count int
/* Getting the total number of assets (required for looping) */
SET @count = (SELECT COUNT(*) FROM Trades)

DROP TABLE IF EXISTS #TEMP_RETURNS
/* Table to store the returns of all the assets */
CREATE TABLE #TEMP_RETURNS (
[returns] decimal(12,2),
[type] nvarchar(20)
)

/* Looping to get the returns of each asset */
WHILE (@count>0)
BEGIN

DECLARE @ticker nvarchar(20)
/* Getting the ticker of the asset */
SELECT @ticker = [ticker] FROM Trades WHERE trade_id = @count

DECLARE @type nvarchar(20)
/* Getting the type of the asset */
SELECT @type = [type] FROM Trades WHERE trade_id = @count

DROP TABLE IF EXISTS #TEMP_Asset_History 
/* Required for GetAssetHistory PROCEDURE (check documentation) */
CREATE TABLE #TEMP_Asset_History (
[date] date,
[balance] decimal(12,2),
[gains] decimal(12,2),
[returns] decimal(12,2)
)

/* Executing GetAssetHistory to get the returns history of the asset */
EXEC GetAssetHistory @ticker = @ticker

DROP TABLE IF EXISTS #TEMP_ASSET_RETURNS 
/* Table to store the returns and type of the asset */
CREATE TABLE #TEMP_ASSET_RETURNS (
[returns] decimal(12,2),
[type] nvarchar(20)
)

/* Inserting only the returns of the asset on the last day (final returns) */
INSERT INTO #TEMP_ASSET_RETURNS
SELECT TOP(1)
[returns], NULL FROM #TEMP_Asset_History
ORDER BY [date] desc

/* Adding the type of the asset */
UPDATE #TEMP_ASSET_RETURNS
SET [type] = @type

/* Inserting the returns and type of the asset to original returns table */
INSERT INTO #TEMP_RETURNS
SELECT * FROM #TEMP_ASSET_RETURNS

SET @count = @count - 1
END

/* Gives the type, weights and the returns of each asset type */
SELECT [type], 
CAST(((COUNT(type)/CAST((SELECT COUNT(*) FROM Trades) as float)) * 100) as decimal(12,2)) as weights, 
CAST((SUM(returns)/COUNT(type)) as decimal(12,2)) as returns
FROM #TEMP_RETURNS
GROUP BY [type]

END
