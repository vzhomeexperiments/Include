//+------------------------------------------------------------------+
//|                    03b_ReadCommandFromCSV_MacroEconomicEvent.mqh |
//|                                                    Miguel Ferraz |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Miguel Ferraz"
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+


bool ReadCommandFromCSVMacroEconomicEvent(string symboll)
{
//- Function reads the file SystemControlMagicNumber.csv
//- It is searching the code 1 and return trade as enabled 
 string symboll1 = StringSubstr(symboll,0,3); 
 string symboll2 = StringSubstr(symboll,3,3); 
 

//int el1, el2, handle, comma,i,pos[];      bool TradePossible = False;
int handle, comma,i,pos[];      bool TradePossible = False;

static int el1 = 0; // added ver.02
static int el2 = 0; // added ver.02

string str, word, trigger;


   while(!FileIsEnding(handle) && TradePossible == FALSE)
   {
   str=FileReadString(handle);
   if(str!="")
      {   
        word=StringSubstr(str,1,3);
             //Alert(word);
        trigger = StringSubstr(str,6,1);
             //Alert(trigger);
             
          if(word == symboll1 || word == symboll2 )
                  {if(trigger == "1")
                     {//Alert("The system is enabled!!!");
                      TradePossible = TRUE;
                      return TradePossible; 
                      }
                   if(trigger == "0")
                     {//Alert("The system is disabled!!!");
                      TradePossible = FALSE;} }
             
               }
   }
   FileClose(handle);
   return(TradePossible);
} 
