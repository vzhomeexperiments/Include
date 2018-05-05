//+-------------------------------------------------------------------+
//|                                       12_ReadPredictionFromAI.mqh |
//|                                  Copyright 2018, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2018, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "1.001"  
#property strict
// function to recieve direction from csv file
// version 1.001 date 05.05.2018

#define TRADE_NONE 0       //Market not siutable for trading e.g. macroeconomic event or not properly defined
#define TRADE_BU   1       //Predicted bull
#define TRADE_BE   2       //Predicted bear

//+-------------------------------------------------------------+//
//Function requires input of the symbol 
//+-------------------------------------------------------------+//
/*
User guide:
1. Add global bool variable to EA: e.g.:                     int     MyMarketType;
2. Add function call inside start function to EA: e.g.: MyMarketType = ReadMarketFromCSV(Symbol());
3. Adapt Trading Robot conditions to change trading strategy parameters eg.: see Falcon_C
4. Add include call to this file  to EAe.g.:            #include <096_ReadMarketTypeFromCSV.mqh>
*/
int ReadPredictionFromAI(string symbol, int chart_period)
{
/*
- Function reads the file eg: AI_M15_DirectionAUDCAD.csv
- It is searching either numeric code or string value containing market type information 
 
*/
   //define internal variables needed
   int direction = -1;         //Variable to store and return the market type
   string res = "0";            //Variable to return result of the function

   //Read the file
   res = ReadFile2(symbol, chart_period);

   //Assign market variable based on result
   if(res == "-1"){direction = TRADE_NONE; return(direction); }
   if(res == "BU"){direction = TRADE_BU;  return(direction); }
   if(res == "BE"){direction = TRADE_BE;  return(direction); }
    
   return(direction); //in anomalous case function will return error '-1'
 
} 

//function that read file from sandbox and get the last character
string ReadFile2(string symbol, int chart_period) 
{
int handle;
string str;

handle=FileOpen("AI_M"+IntegerToString(chart_period)+"_Direction"+symbol+".csv",FILE_READ);
if(handle==-1){Comment("Error - file does not exist"); str = "-1"; } 
if(FileSize(handle)==0){FileClose(handle); Comment("Error - File is empty"); }
   
    //this will bring the last element
   while(!FileIsEnding(handle)) { str=FileReadString(handle);  }
   
   FileClose(handle);
   return(str);
}
