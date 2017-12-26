//+-------------------------------------------------------------------+
//|                                                094_MarketType.mqh |
//|                                  Copyright 2017, Vladimir Zhbanko |
//|                                        vladimir.zhbanko@gmail.com |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2017, Vladimir Zhbanko"
#property link      "vz.home.experiments@gmail.com"
#property strict

#define MARKET_NONE       0       //Market not siutable for trading e.g. macroeconomic event
#define MARKET_RANGE      1       //Market with ranging character
#define MARKET_TREND      2       //Market with trending character
// function return integer code describing the market type
// version 04
// date 29.06.2017

//+-------------------------------------------------------------+//
// Aim of this function is to return information about the market type
//+-------------------------------------------------------------+//
/*
Function Functional Description:
Function is using chart time frame
1. It look on the chart with specified period time frame
2. It look on Bollinger Bands and Keltner Channels to determine that the market ether ranging or trending
   2.1. If B.Bands are within K.Channel --> Ranging
   2.2. If B.Bands are out of K.Channel --> Trending
3. returns back the value

User guide:
1. #include this file to the folder Include
2. Call function when desired from the robot

*/

//+------------------------------------------------------------------+
//| FUNCTION MARKET TYPE                                     
//+------------------------------------------------------------------+

// Function to analyse market type
int MarketType(int period)
{
   /* Definitions of variables
   period - contains period in 1M bars e.g. 1440 OR PERIOD_D1
   */
   
   //define internal variables needed
   int marketType = 0;     //Variable to store and return the market type
   /* Definitions of marketType
   #define MARKET_NONE       0       //Market not siutable for trading e.g. macroeconomic event
   #define MARKET_RANGE      1       //Market with ranging character
   #define MARKET_TREND      2       //Market with trending character
   */
   
   double BB_Up;      //Bollinger Band Upper Bound
   double BB_Dn;      //Bollinger Band Upper Bound
   double KC_Up;      //Keltner Channel Up
   double KC_Dn;      //Keltner Channel Down
   
   
   //calculate indicators
   BB_Up = iBands(Symbol(), period, 20, 2, 0,PRICE_TYPICAL, MODE_UPPER,1);
   BB_Dn = iBands(Symbol(), period, 20, 2, 0,PRICE_TYPICAL, MODE_LOWER,1);
   KC_Up = iCustom(Symbol(), period, "Keltner_Channels", 20, 0, 5, 20, 2, True, 0, 1); // Shift 1
   KC_Dn = iCustom(Symbol(), period, "Keltner_Channels", 20, 0, 5, 20, 2, True, 2, 1); // Shift 1
   
   //Interpret the result of calculations
   /* Definitions of marketType
   #define MARKET_NONE       0       //Market not siutable for trading e.g. macroeconomic event
   #define MARKET_RANGE      1       //Market with ranging character
   #define MARKET_TREND      2       //Market with trending character
   */
   
   if((BB_Up < KC_Up)&&(BB_Dn > KC_Dn)) marketType = MARKET_RANGE;
   if((BB_Up > KC_Up)&&(BB_Dn < KC_Dn)) marketType = MARKET_TREND;
   
   //if(ReadFile() == 1)                marketType = MARKET_NONE; //Macroeconomic event  
   
   
   //Output the result of calculations
   return(marketType);
}

//+------------------------------------------------------------------+
//| End of FUNCTION MARKET TYPE
//+------------------------------------------------------------------+
//function
int ReadFile() 
{
int handle, el1 = 1;
string str;

handle=FileOpen("01_MacroeconomicEvent.csv",FILE_READ);
if(handle==-1)Comment("Error - file does not exist"); 
if(FileSize(handle)==0){FileClose(handle); Comment("Error - File is empty"); }
   
   while(!FileIsEnding(handle))
   {
   str=FileReadString(handle);
   el1 = (int)str;
   
   }
   
   FileClose(handle);
   return(el1);
}
