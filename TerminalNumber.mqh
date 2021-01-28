//+-------------------------------------------------------------------+
//|                                             08_TerminalNumber.mqh |
//|                                  Copyright 2021, Vladimir Zhbanko |
//|                                  Contributor: Florian Assous      |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2018,2021 Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property strict
// function returning an integer value with Termnal Number from Magic Number
// version 02
// date 05.01.2021

//+-------------------------------------------------------------+//
// Aim of this function is to return information about the terminal number
// to enable writing to file
//+-------------------------------------------------------------+//
/*
@purpose Function Functional Description:
Function is using a flat file 'terminal.csv' to read and retrieve the terminal number
@detail
It is imperative to create file 'terminal.csv' and place there a number (1 or 2 or 3 or 4...)
@description
1. Define variables
2. Read file
3. return back the value

User guide:
1. Add this file to the folder Include
2. Use this function inside trading robot #include <08_TerminalNumber.mqh>

*/

//+------------------------------------------------------------------+
//| FUNCTION TERMINAL NUMBER                                          
//+------------------------------------------------------------------+
int T_Num()
  {
// This function does automatically retrieve terminal number using magic number stored in the file
   int handle;
   int terminalNumber;
   string str;
   
   handle=FileOpen("terminal.csv",FILE_READ);
      if(handle==-1)Print("Function Read terminal: Error - file does not exist, create file terminal.csv in the sandbox"); 
      if(FileSize(handle)==0){FileClose(handle); Comment("Error - File is empty, add a number the file terminal.csv"); }
         
         while(!FileIsEnding(handle))
         {
         str=FileReadString(handle);
         }
       FileClose(handle);
       
       terminalNumber = StrToInteger(str);        //translate to integer

   return(terminalNumber);

  }
//+------------------------------------------------------------------+
//| End of TERMINAL NUMBER                                                
//+------------------------------------------------------------------+