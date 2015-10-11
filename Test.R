# Goal: Using data from Yahoo finance, estimate the Fama-French Factors for any security
# using monthly returns
 
library(tseries)
library(zoo)
 
# Load FF factor returns
startyear = 2008;
startmonth = 11;
endyear = 2013;
endmonth = 10;
 
start = (startyear-1926.5)*12+startmonth;
stop = (endyear - 1926.5)*12+endmonth;
 
ff_returns = read.table("F-F_Factors_monthly.txt")
rmrf = ff_returns[start:stop,2]/100
smb = ff_returns[start:stop,3]/100
hml = ff_returns[start:stop,4]/100
rf = ff_returns[start:stop,5]/100

#symbols <- c("GE","AAPL","COP")

symbols <- c("GE")
symbols <- c("GE","AAPL","LUV","SPY","PG","amzn","cost","ba")


quotes <- function(x) {
  prices <- get.hist.quote(x, quote="Adj", start="2008-10-30", retclass="zoo")
  # To make weekly returns, you must have this incantation:
  monthly.prices <- aggregate(prices, as.yearmon, tail, 1)
  
  # Convert monthly prices to monthly returns
  r <- diff(log(monthly.prices))
  r1 <- exp(r)-1
  
  # Now shift out of zoo to become an ordinary matrix --
  rj <- coredata(r1)
  rj <- rj[1:60]
  rjrf <- rj - rf
  
  d <- lm(rjrf ~ rmrf + smb + hml)               # FF model estimation.
  list(c(name=x,coeff=d$coefficients,R2=summary.lm(d)$adj.r.squared))

  }


pp <- lapply(symbols, quotes)
cols <- c("symbol","intercept","rmrf","smb","hml","R2")
output <- as.data.frame(matrix(unlist(pp), ncol = 6, byrow = TRUE))
colnames(output) <- cols
write_csv(output,"outout.csv")


