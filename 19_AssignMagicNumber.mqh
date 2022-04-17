//+-------------------------------------------------------------------+
//|                                          19_AssignMagicNumber.mqh |
//|                                  Copyright 2020, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2021, Vladimir Zhbanko"
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
@param strat - int with a 2 digit strategy number 
@guide:
1. Define external variable StrategyNumber = 11;
2. Use function in the first line of the init function e.g.:  MagicNumber = AssignMagicNumber(Symbol(), StrategyNumber);
*/
/*
Magic number codification :
Digit 1 : current year digit
Digit 2 : type (1= live account ; 2 : demo account ; 3 : contest) 
Digit 3-4 : strategy ID
Digit 5 : Terminal number
Digit 6-7 : Pair ID
*/

int AssignMagicNumber(string symbol, string strat, int termnum)
{
/*
- 
- 
*/
//define internal variables needed
string Core28Pairs[] = {"AUDCAD","AUDCHF","AUDJPY","AUDNZD","AUDUSD","CADCHF","CADJPY","CHFJPY","EURAUD",
                        "EURCAD","EURCHF","EURGBP","EURJPY","EURNZD","EURUSD","GBPAUD","GBPCAD","GBPCHF",
                        "GBPJPY","GBPNZD","GBPUSD","NZDCAD","NZDCHF","NZDJPY","NZDUSD","USDCAD","USDCHF",
                        "USDJPY","ADAUSD","XRPUSD"};
int result;
string year, digit6_7;

//=============================
// Digit 1 : current year digit
//=============================
year = "2021";
year = StringSubstr(year, 3, 1);

//=============================
// Digit 2 : type (2= live account ; 2 : demo account ; 3 : contest) 
//=============================
ENUM_ACCOUNT_TRADE_MODE account_type=(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE); 

   string digit2; 
   switch(account_type) 
     { 
      case  ACCOUNT_TRADE_MODE_DEMO: 
         digit2 ="2"; 
         break; 
      case  ACCOUNT_TRADE_MODE_CONTEST: 
         digit2 ="3"; 
         break; 
      default: 
         digit2 ="2"; 
         break; 
     } 

//=============================
//Digit 3-4 : strategy ID
//=============================
//Strategy
string digit3_4 = strat;

//=============================
//Digit 5 : Terminal number
//=============================
string digit5 = (string)termnum;

//=============================
//Digit 6-7 : Pair ID
//=============================
 
for(int i=0;i<ArrayRange(Core28Pairs,0);i++)
  {
   if(symbol == Core28Pairs[i])
     {
      if(i <= 9)
        {
         digit6_7 = StringConcatenate("0"+(string)i); //add zero in front of the number
        } else
            {
             digit6_7 = (string)i;
            }
           
      break;
     }
  }    


//Final Result:
result = StrToInteger(StringConcatenate(year, digit2, digit3_4,digit5,digit6_7));        //translate to integer
return(result);
 
} 
