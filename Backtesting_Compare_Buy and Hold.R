# run the command below if quantmod isn't already installed
# install.packages("quantmod")
# use the quantmod package (loads TTR, xts, and zoo)
require(quantmod)
# pull SPX data from Yahoo (getSymbols returns an xts object)
#getSymbols("^GSPC")
symbols <- c("^GSPC","PPA","AAPL","GE","AMZN", "DJIA", "BAC")
getSymbols(symbols)

test <- AAPL

# calculate DVI indicator
dvi <- DVI(Cl(test))  # Cl() extracts the close price column
# create signal: (long (short) if DVI is below (above) 0.5)
# lag so yesterday's signal is applied to today's returns
#sig <- Lag(ifelse(dvi$dvi < 0.5, 1, -1))
sig <- 1

# calculate signal-based returns
ret <- ROC(Cl(test))*sig

# subset returns to match data in Excel file
ret <- ret['2005-06-02/2013-09-07']
# use the PerformanceAnalytics package
# install.packages("PerformanceAnalytics")
require(PerformanceAnalytics)
# create table showing drawdown statistics
table.Drawdowns(ret, top=10)
# create table of downside risk estimates
table.DownsideRisk(ret)
# chart equity curve, daily performance, and drawdowns
charts.PerformanceSummary(ret)