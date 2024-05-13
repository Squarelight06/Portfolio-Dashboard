/* GetPortfolioHistory - provides the daily balance, cashflow gains, and the ROI of entire portfolio.
Important Notes:  - GetPortfolioHistory populates the #TEMP_Portfolio_History table and 
					so before using GetPortfolioHistory #TEMP_Portfolio_History table must be created as follows:
					DROP TABLE IF EXISTS #TEMP_Portfolio_History 
					CREATE TABLE #TEMP_Portfolio_History (
					[date] date,
					[balance] decimal(12,2),
					[gains] decimal(12,2),
					[returns] decimal(12,2)
					)
*/
CREATE PROCEDURE GetPortfolioHistory
AS
BEGIN
DECLARE @count int
/* Getting the total number of assets (required for looping) */
SET @count = (SELECT COUNT(*) FROM Trades)

DROP TABLE IF EXISTS #TEMP_Price_History 
/* Table to store the data in the Price_History table
	to make it usuable with the Trades table (Normalization)*/
CREATE TABLE #TEMP_Price_History (
[date] date,
[ticker] nvarchar(20),
[price] decimal(12,2)
)

/* Required for dynamic sql operations */
DECLARE @statement nvarchar(max)

DECLARE @cashflow decimal(12,2)
/* Getting the total cash spent to buy the asset */
SELECT @cashflow = SUM(cashflow) FROM Trades

/* Looping to normalize the Price_History table */
WHILE (@count>0)
BEGIN

DECLARE @ticker nvarchar(20)
/* Getting the ticker of the asset */
SELECT @ticker = [ticker] FROM Trades WHERE trade_id = @count

/* Dynamically normalizes the data of the asset
   Normalization process explained in the documentation*/
SET @statement = 'INSERT INTO #TEMP_Price_History
                SELECT ph.date, ''' + @ticker + ''', ph.' + @ticker + '
                FROM PriceHistory_Portfolio ph'

EXEC sp_executesql @statement

SET @count = @count - 1
END

DROP TABLE IF EXISTS #TEMP_Portfolio_Balance 
/* Table to store the daily balance of the portfolio */
CREATE TABLE #TEMP_Portfolio_Balance (
[date] date,
[balance] decimal(12,2)
)

/* Inserting the returns and type of the asset to original returns table */
INSERT INTO #TEMP_Portfolio_Balance
SELECT ph.date, SUM(ph.price * t.shares_number)
FROM #TEMP_Price_History ph
JOIN Trades t ON ph.ticker = t.ticker
GROUP BY ph.date

/* Dynamically inserts the daily portfolio balance, cash gains and ROI to the #TEMP_Portfolio_History table */
SET @statement = '
INSERT INTO #TEMP_Portfolio_History 
SELECT pb.date, pb.balance, 
CAST((pb.balance +' + CAST(@cashflow as nvarchar(20)) +') as decimal(12,2)), 
CAST((((pb.balance +' + CAST(@cashflow as nvarchar(20)) + ')/-(' + CAST(@cashflow as nvarchar(20)) + ')) * 100) as decimal(12,2))
FROM #TEMP_Portfolio_Balance pb'

EXEC sp_executesql @statement

END
