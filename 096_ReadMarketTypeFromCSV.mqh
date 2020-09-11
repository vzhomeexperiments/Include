//+-------------------------------------------------------------------+
//|                                     096_ReadMarketTypeFromCSV.mqh |
//|                                  Copyright 2018, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2018, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "1.002"  
#property strict
// function to recieve market type from csv
// version 1.001 date 29.12.2017
// version 1.002 date 15.04.2018 

#define MARKET_NONE 0       //Market not siutable for trading e.g. macroeconomic event or not properly defined
#define MARKET_BUN  1       //Market with bullish character
#define MARKET_BUV  2       //Market with volatile bullish character
#define MARKET_BEN  3       //Market with bearish character
#define MARKET_BEV  4       //Market with volatile bearish character
#define MARKET_RAN  5       //Market with Ranging character
#define MARKET_RAV  6       //Market with volatile Ranging character

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
int ReadMarketFromCSV(string symbol, int chart_period)
{
/*
- Function reads the file eg: AI_MarketType_AUDCAD15.csv
- It is searching either numeric code or string value containing market type information 
 
*/
   //define internal variables needed
   int marketType = -1;         //Variable to store and return the market type
   string res = "0";            //Variable to return result of the function
   

   //Read the file
   res = ReadFile(symbol, chart_period);

   //Assign market variable based on result
   if(res == "0" || res == "-1") {marketType = MARKET_NONE; return(marketType); }
   if(res == "1" || res == "BUN"){marketType = MARKET_BUN;  return(marketType); }
   if(res == "2" || res == "BUV"){marketType = MARKET_BUV;  return(marketType); }
   if(res == "3" || res == "BEN"){marketType = MARKET_BEN;  return(marketType); }
   if(res == "4" || res == "BEV"){marketType = MARKET_BEV;  return(marketType); }
   if(res == "5" || res == "RAN"){marketType = MARKET_RAN;  return(marketType); }
   if(res == "6" || res == "RAV"){marketType = MARKET_RAV;  return(marketType); }
   
   return(marketType); //in anomalous case function will return error '-1'
 
} 

//function that read file from sandbox and get the last character
string ReadFile(string symbol, int chart_period) 
{
int handle;
string output;
string str;
string sep=",";              // A separator as a character 
ushort u_sep;                // The code of the separator character 
string result[];             // An array to get string elements
string full_line;            // String reserved for a file string

handle=FileOpen("AI_MarketType_"+symbol+IntegerToString(chart_period)+".csv",FILE_READ);
if(handle==-1){Comment("Error - file does not exist"); str = "-1"; } 
if(FileSize(handle)==0){FileClose(handle); Comment("Error - File is empty"); }
   
    //this will bring the last element
   while(!FileIsEnding(handle)) { 
   
   str=FileReadString(handle); //storing content of the current line
         
            //full current line
            full_line = StringSubstr(str,0);
            //--- Get the separator code 
            u_sep=StringGetCharacter(sep,0); 
            //--- Split the string to substrings and store to the array result[] 
            int k = StringSplit(str,u_sep,result); 
            // extract content of the string array [for better clarify]
   }
   
   FileClose(handle);
   
         if(result[0] == "-1"){output = str; return(output); } //in anomalous case function will return error '-1'
         else if(result[0] == "BUN" ||
                 result[0] == "BUV" ||
                 result[0] == "BEN" ||
                 result[0] == "BEV" ||
                 result[0] == "RAN" ||
                 result[0] == "RAV") output = result[0];
      
      //tested pass: 
   
   
   
   return(output);
}
