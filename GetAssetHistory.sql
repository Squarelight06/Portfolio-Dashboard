/* GetAssetHistory @ticker - provides the daily balance, cashflow gains, and the ROI of a particular asset. 
Important Notes: - Here @Ticker is an input of nvarchar(20) type, representing the ticker of the asset.
				 - GetAssetHistory populates the #TEMP_Asset_History table and 
					so before using GetPortfolioHistory #TEMP_Portfolio_History table must be created as follows::
					DROP TABLE IF EXISTS #TEMP_Asset_History 
					CREATE TABLE #TEMP_Asset_History (
					[date] date,
					[balance] decimal(12,2),
					[gains] decimal(12,2),
					[returns] decimal(12,2)
					) 
*/
CREATE PROCEDURE GetAssetHistory
@ticker nvarchar(20)
AS
BEGIN

/* Required for dynamic sql operations */
DECLARE @statement nvarchar(max)

DECLARE @cashflow decimal(12,2)
/* Getting the total cash spent to buy the asset */
SELECT @cashflow = [cashflow] FROM Trades WHERE ticker =  @ticker

DECLARE @number int
/* Getting the total number of shares (holdings) bought for this asset */
SELECT @number = [shares_number] FROM Trades WHERE ticker =  @ticker

DECLARE @balance nvarchar(100)
/* Getting the daily value of the holdings */
SET @balance = '((ph.' + @ticker + ')*' + CAST(@number as nvarchar(20)) + ')'

/* Dynamically inserts the daily balance, cash gains and ROI from the holdings to the #TEMP_Asset_History table */
SET @statement = '
INSERT INTO #TEMP_Asset_History
SELECT ph.date, 
' + @balance + ',
CAST((' + @balance + ' +' + CAST(@cashflow as nvarchar(20)) + ') as decimal(12,2)),
CAST((((' + @balance + ' +' + CAST(@cashflow as nvarchar(20)) + ')/-(' + CAST(@cashflow as nvarchar(20)) + ')) * 100) as decimal(12,2))
FROM PriceHistory_Portfolio ph'

EXEC sp_executesql @statement

END
