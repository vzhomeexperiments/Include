//+-------------------------------------------------------------------+
//|                                         03_ReadCommandFromCSV.mqh |
//|                                  Copyright 2018, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2018, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property strict
// function to recieve command to trade from csv
// version 01 date 1.08.2016
// version 02 date 11.08.2016 added static variable to avoid minor error

//+-------------------------------------------------------------+//
//Function requires just input of the trade terminal number      //
//+-------------------------------------------------------------+//
/*
User guide:
1. Add global bool variable to EA: e.g.:                     bool TradeAllowed = true; 
2. Add function call inside start function to EA: e.g.: TradeAllowed = ReadCommandFromCSV(MagicNumber);
3. Insert TradeAllowed inside condition to start trading eg.: if(TradeAllowed && TickVolume > MinVolumeTicks) { signals...}
4. Add include call to this file  to EAe.g.:            #include <03_ReadCommandFromCSV.mqh>
*/
bool ReadCommandFromCSV(int Magic)
{
/*
- Function reads the file SystemControlMagicNumber.csv
- It is searching the code 1 and return trade as enabled 
 
*/
//int el1, el2, handle, comma,i,pos[];      bool TradePossible = False;
int handle, comma,i,pos[];      bool TradePossible = False;

static int el1 = 0; // added ver.02
static int el2 = 0; // added ver.02

string str, word;

handle=FileOpen("SystemControl"+string(Magic)+".csv",FILE_READ);
if(handle==-1){Comment("Error - file does not exist"); TradePossible = TRUE; } 
if(FileSize(handle)==0){FileClose(handle); Comment("Error - File is empty");  }
   
   while(!FileIsEnding(handle))
   {
   str=FileReadString(handle);
   if(str!="")
      {
         comma=0;
         for(i=0;i<StringLen(str);i++)    //This for loop will find number of commas in our string
            {
            if(StringGetChar(str,i)==44)  //comma Dec code 44 see http://www.zytrax.com/tech/codes.htm
               {
               comma++;                   //add 1 if found another comma
               ArrayResize(pos,comma);    //array pos[] will be dimensioned to accomodate n elements 
               pos[comma-1]=i;            //we save location of the commas in our strings!
               }
            }
            
         for(i=0;i<=comma;i++)            //this for loop will return separate string elements 
            {
            if(i==0) 
               {
                 word=StringSubstr(str,0,pos[0]); //this code is to substract first element of the string
                 el1 = StrToInteger(word);        //translate to integer
                 //Comment(el1); Ok!
               }
            else //substracting the second and following elements of the string
               {
                  
                  word=StringSubstr(str,pos[i-1]+1,pos[i-1]+2);
                  //Comment(word);
                  el2 = StrToInteger(word);
                  //Comment("El 2 = ", el2);
               }
               
            }
       }
                 
   // analysing our values
              if(el1 == Magic)
                  {
                    if(el2 == 1)
                     {
                        //Comment("The system is enabled!!!");
                        TradePossible = TRUE;
                     }
                    if(el2 == 0)
                     {
                        Comment("The system is disabled!!!");
                        TradePossible = FALSE;
                     } 
                  }
            //  end of analysis
   
  
   }
   FileClose(handle);
   return(TradePossible);
} 