//+-------------------------------------------------------------------+
//|                                     096_ReadMarketTypeFromCSV.mqh |
//|                                  Copyright 2018, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2018, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "1.001"  
#property strict
// function to record current market type to csv
// logs will be done at the moment of opening trades
// version 1.001 date 01.09.2018
 
//+-------------------------------------------------------------+//
//Function requires generation of the MarketType information 
//+-------------------------------------------------------------+//
/*
User guide:
1. EA should have produced market type code: e.g.:       nt     MyMarketType;
2. Add function call inside order opening section of EA
3. Add include call to this file  to EAe.g.:            #include <16_LogMarketType.mqh>
4. Verify that files are written to the sandbox, including new orders are appended
5. List of Market Types is below
#define MARKET_NONE 0       //Market not siutable for trading e.g. macroeconomic event or not properly defined
#define MARKET_BUN  1       //Market with bullish character
#define MARKET_BUV  2       //Market with volatile bullish character
#define MARKET_BEN  3       //Market with bearish character
#define MARKET_BEV  4       //Market with volatile bearish character
#define MARKET_RAN  5       //Market with Ranging character
#define MARKET_RAV  6       //Market with volatile Ranging character
*/
void LogMarketType(int magic, int order, int markettype)
{
/*
- Function creates the file eg: MarketTypeLog8134201.csv
- File will contain Order Number, Magic Number and MarketType information
*/
string res = "-1";

   //Assign market variable based on result
   if(markettype == 0) res = "-1";
   if(markettype == 1) res = "BUN";
   if(markettype == 2) res = "BUV";
   if(markettype == 3) res = "BEN";
   if(markettype == 4) res = "BEV";
   if(markettype == 5) res = "RAN";
   if(markettype == 6) res = "RAV";
   
string fileName = "MarketTypeLog"+string(magic)+".csv";
// open file handle
int handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE);   
             FileSeek(handle,0,SEEK_END);
string data = string(magic) + "," + string(order) + "," + res;
FileWrite(handle,data);   //write data to the file during each for loop iteration
FileClose(handle);        //close file when data write is over


}

void LogMarketTypeInfo(int magic, int order, int markettype, int timetohold)
{
/*
- Function creates the file eg: MarketTypeLog8134201.csv
- File will contain Order Number, Magic Number, MarketType and time to hold order
*/
string res = "-1";

   //Assign market variable based on result
   if(markettype == 0) res = "-1";
   if(markettype == 1) res = "BUN";
   if(markettype == 2) res = "BUV";
   if(markettype == 3) res = "BEN";
   if(markettype == 4) res = "BEV";
   if(markettype == 5) res = "RAN";
   if(markettype == 6) res = "RAV";
   
string fileName = "MarketTypeLog"+string(magic)+".csv";

// check if the ticket number exists, then log
if(order >= 0)
  {
   // open file handle
   int handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE);   
                FileSeek(handle,0,SEEK_END);
   string data = string(magic) + "," + string(order) + "," + string(markettype) + "," + IntegerToString(timetohold,0) + "," + res;
   FileWrite(handle,data);   //write data to the file during each for loop iteration
   FileClose(handle);        //close file when data write is over
  }
}