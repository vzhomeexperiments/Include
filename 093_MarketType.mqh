//+-------------------------------------------------------------------+
//|                                                 09_MarketType.mqh |
//|                                  Copyright 2016, Vladimir Zhbanko |
//|                                        vladimir.zhbanko@gmail.com |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2016, Vladimir Zhbanko"
#property link      "vladimir.zhbanko@gmail.com"
#property strict

#define MARKET_NONE      0       //Market not siutable for trading e.g. macroeconomic event
#define MARKET_BULL      1       //Market with volatile bullish character
#define MARKET_BEAR      2       //Market with volatile bearish character
// function return integer code describing the market type
// version 03
// date 27.01.2017

//+-------------------------------------------------------------+//
// Aim of this function is to return information about the market type
//+-------------------------------------------------------------+//
/*
Function Functional Description:
Function is using currency symbol, begin date, and history deepth parameters
1. It look on the chart with specified period
2. It look on SuperSmoother indicator and corresponding price behaviour and derive market type using simple algorithm
3. returns back the value

User guide:
1. #include this file to the folder Include
2. Call function when desired from the robot

*/

//+------------------------------------------------------------------+
//| FUNCTION MARKET TYPE                                     
//+------------------------------------------------------------------+

// Function to analyse market type
int MarketType(string pair, int period, int begin, int deepth)
{
   /* Definitions of variables
   pair - contains the string with symbol
   period - contains period in 1M bars e.g. 1440 OR PERIOD_D1
   begin - contains the starting point of the history to look (should be 1 when used by EA)
   deepth - how many days in the past we look to the history from the begin variable reactive is 1 or 2
   */
   
   //define internal variables needed
   int marketType = 0;     //Variable to store and return the market type
   /* Definitions of marketType
   #define MARKET_NONE      0       //Market not siutable for trading e.g. macroeconomic event
   #define MARKET_BULL      1       //Market with bullish character
   #define MARKET_BEAR      2       //Market with bearish character
   */
   
   double SS[];            //Array SuperSmoother
   double SS_prev[];       //Array SuperSmoother previous
   double SS_angle[];      //Array SuperSmoother line angle 
   
   double SS_sumangle = 0;//contain sum of angle of the averaging line

   //resize the arrays, dimension equals to deepth parameter
   ArrayResize(SS, deepth, 0);
   ArrayResize(SS_prev, deepth, 0);
   ArrayResize(SS_angle, deepth, 0);
   
//fill in the arrays
for(int i = 0; i < deepth; i++)
  {
   //calculate indicators
   SS[i]         = iCustom(pair,period,"SuperSmoother", 10, 0, 0, i + begin);      //Supersmoother
   SS_prev[i]    = iCustom(pair,period,"SuperSmoother", 10, 0, 0, i + begin + 1);  //Supersmoother previous

   //calculate derivatives
   SS_angle[i] = SS[i] - SS_prev[i];                      //difference towards previous value
   SS_sumangle = SS_sumangle + SS_angle[i];               //total difference by summing the angles
  }
   
   //Interpret the result of calculations
   /* Definitions of marketType
   #define MARKET_NONE      0       //Market not siutable for trading e.g. macroeconomic event
   #define MARKET_BULLVOL   1       //Market with volatile bullish character
   #define MARKET_BEARVOL   2       //Market with volatile bearish character
   */
   if(SS_sumangle > 0)                           marketType = MARKET_BULL;//Bullish Volatile
   if(SS_sumangle < 0)                           marketType = MARKET_BEAR;//Bearish Volatile
     
   if(ReadFile() == 1)                           marketType = MARKET_NONE; //Macroeconomic event
   
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
