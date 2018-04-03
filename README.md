# Include

# Content:

1. 01_HistoryFunction.mqh				Function returning n of orders in history
2. 02_OrderProfitToCSV.mqh				Function to log PnL of previously set orders by function GetHistoryOrderByCloseTime
3. 03_ReadCommandFromCSV.mqh			Function to recieve command to trade from csv file located in the Sandbox
4. 04_SupportResistanceLevels.mqh		Not used at the moment
5. 05_MarketInfoLogger.mqh				Function to enable logging to files from EA to Sandbox
6. 06_NormalizeDouble.mqh				Function to normalize values from e.g. 0.2343254443 to 0.23432
7. 
8. 08_TerminalNumber.mqh				Function to retreieve Terminal Number from Magic Number
9. 09_MarketType.mqh					Function to retreieve or read Market Type (planned to generate Market Type using Deep Learning in R)
10.10_isNewBar.mqh						Function to speed up EA execution by running logic only 1x per bar


# Synchronize or Deploy

Dedicated executable scripts will synchronize existing files from Repo to the working destinations.
It will only copy files with specific extension and only overwrite in case files were changed

1. To synchronize MT4 Development Terminal Folder to Version Control Repository: launch *_PullFromMT4.bat*
2. To deploy reverted changes from Version Control to Development Terminal: launch *_PushToMT4Dev.bat*
3. To deploy reverted changes from Version Control to All Terminals: launch *_PushToMT4Prod*

## Courious how to apply?

Join these UDEMY courses with a tremendious discount!

* https://www.udemy.com/your-trading-journal/?couponCode=LAZYTRADE-GIT
* https://www.udemy.com/your-trading-robot/?couponCode=LAZYTRADE-GIT
* https://www.udemy.com/your-home-trading-environment/?couponCode=LAZYTRADE-GIT
