//+-------------------------------------------------------------------+
//|                                             08_TerminalNumber.mqh |
//|                                  Copyright 2016, Vladimir Zhbanko |
//|                                        vladimir.zhbanko@gmail.com |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2016, Vladimir Zhbanko"
#property link      "vladimir.zhbanko@gmail.com"
#property strict
// function returning an integer value with Termnal Number from Magic Number
// version 01
// date 13.11.2016

//+-------------------------------------------------------------+//
// Aim of this function is to return information about the terminal number
// to enable writing to file
//+-------------------------------------------------------------+//
/*
Function Functional Description:
Function is using Magic Number to retrieve the terminal number
1. Convert input Magic Number to string
2. substract needed number by position and convert to the integer
3. return back the value

User guide:
1. #include this file to the folder Include

*/

//+------------------------------------------------------------------+
//| FUNCTION TERMINAL NUMBER                                          
//+------------------------------------------------------------------+
int T_Num(int Magic)
  {
// This function does automatically retrieve terminal number using magic number
// By convention terminal number is the 5th symbol from left: xxxx1xx
   int result;
   string tempString;
   tempString = string(Magic);               //convert to string
   tempString=StringSubstr(tempString,4,1);  //substract 3rd element from right
   result = StrToInteger(tempString);        //translate to integer

   return(result);

  }
//+------------------------------------------------------------------+
//| End of TERMINAL NUMBER                                                
//+------------------------------------------------------------------+