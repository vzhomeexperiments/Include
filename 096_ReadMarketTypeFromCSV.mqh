//+-------------------------------------------------------------------+
//|                                         03_ReadMarketFromCSV.mqh |
//|                                  Copyright 2018, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2018, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "1.001"  
#property strict
// function to recieve market type from csv
// version 1.001 date 29.12.2017
// version 02 

#define MARKET_NONE      0       //Market not siutable for trading e.g. macroeconomic event or not properly defined
#define MARKET_BULLNOR   1       //Market with volatile bullish character
#define MARKET_BULLVOL   2       //Market with volatile bearish character
#define MARKET_BEARNOR   3       //Ranging Market volatile
#define MARKET_BEARVOL   4       //Market with bullish character
#define MARKET_RANGENOR  5       //Market with bearish character
#define MARKET_RANGEVOL  6       //Ranging Market

/*
1. Bull normal
2. Bull volatile
3. Bear normal
4. Bear volatile
5. Sideways quiet
6. Sideways volatile
*/

//+-------------------------------------------------------------+//
//Function requires input of the symbol 
//+-------------------------------------------------------------+//
/*
User guide:
1. Add global bool variable to EA: e.g.:                     bool TradeAllowed = true; 
2. Add function call inside start function to EA: e.g.: TradeAllowed = ReadCommandFromCSV(MagicNumber);
3. Insert TradeAllowed inside condition to start trading eg.: if(TradeAllowed && TickVolume > MinVolumeTicks) { signals...}
4. Add include call to this file  to EAe.g.:            #include <03_ReadCommandFromCSV.mqh>
*/
int ReadMarketFromCSV(string symbol)
{
/*
- Function reads the file AI_SystemControlMagicNumber.csv
- It is searching the code 1 and return trade as enabled 
 
*/
   //define internal variables needed
   int marketType = 0;     //Variable to store and return the market type
   int res = 0;            //Variable to return result of the function

   //Read the file
   res = ReadFile(symbol);

   //Assign market variable based on result
   if(res == 0 || res == -1){marketType = MARKET_NONE; return(marketType); }
   if(res == 1){marketType = MARKET_BULLNOR; return(marketType); }
   if(res == 2){marketType = MARKET_BULLVOL; return(marketType); }
   if(res == 3){marketType = MARKET_BEARNOR; return(marketType); }
   if(res == 4){marketType = MARKET_BEARVOL; return(marketType); }
   if(res == 5){marketType = MARKET_RANGENOR; return(marketType); }
   if(res == 6){marketType = MARKET_RANGEVOL; return(marketType); }
 return(marketType);
 
} 


//function
int ReadFile(string symbol) 
{
int handle, el1 = 0;
string str;

handle=FileOpen("AI_MarketType_"+symbol+".csv",FILE_READ);
if(handle==-1){Comment("Error - file does not exist"); el1 = 0; } 
if(FileSize(handle)==0){FileClose(handle); Comment("Error - File is empty"); }
   
   while(!FileIsEnding(handle))
   {
   str=FileReadString(handle);
   el1 = (int)str;
   
   }
   
   FileClose(handle);
   return(el1);
}
