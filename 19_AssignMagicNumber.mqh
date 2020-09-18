//+-------------------------------------------------------------------+
//|                                          19_AssignMagicNumber.mqh |
//|                                  Copyright 2020, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2020, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "1.001"  
#property strict
// function to automatically assign magic number to the symbol
// version 1.001 date 18.09.2020

//+-------------------------------------------------------------+//
//Function requires input of the symbol 
//+-------------------------------------------------------------+//
/*
@description: Automatically assign magic number based on the symbol used and main strategy magic number
@purpose: Quicker deploy of the trading robots with predictable order management
@param symbol - string with a symbol
@param magic - int with a 7 digit magic number 
@guide:
1. Use function in the first line of the init function e.g.:  MagicNumber = AssignMagicNumber(Symbol(), MagicNumber);
*/
int AssignMagicNumber(string symbol, int magic)
{
/*
- 
- 
 
*/
//define internal variables needed
string Core28Pairs[] = {"AUDCAD","AUDCHF","AUDJPY","AUDNZD","AUDUSD","CADCHF","CADJPY","CHFJPY","EURAUD","EURCAD","EURCHF","EURGBP","EURJPY","EURNZD","EURUSD","GBPAUD","GBPCAD","GBPCHF","GBPJPY","GBPNZD","GBPUSD","NZDCAD","NZDCHF","NZDJPY","NZDUSD","USDCAD","USDCHF","USDJPY"};
int result;
string tempString1, tempString2;

//extract 5 left elements of the magic number
tempString1 = string(magic);               //convert to string
tempString1=StringSubstr(tempString1,0,StringLen(tempString1)-2);  //substract 3rd element from right
//Comment(tempString1);
   
for(int i=0;i<ArrayRange(Core28Pairs,0);i++)
  {
   if(symbol == Core28Pairs[i])
     {
      if(i <= 9)
        {
         tempString2 = StringConcatenate("0"+(string)i); //add zero in front of the number
        } else
            {
             tempString2 = (string)i;
            }
           
      break;
     }
  }    

//Comment(tempString2);
result = StrToInteger(StringConcatenate(tempString1, tempString2));        //translate to integer
return(result);
 
} 
