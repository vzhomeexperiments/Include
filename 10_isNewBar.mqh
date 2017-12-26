//+-------------------------------------------------------------------+
//|                                                   10_isNewBar.mqh |
//|                                  Copyright 2017, Vladimir Zhbanko |
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
Function is returning TRUE if it's a new bar start

User guide:
1. #include this file to the folder Include

*/

//+------------------------------------------------------------------+
// FUNCTION is New Bar
//+------------------------------------------------------------------+
// This function is needed to reduce computation of intrabars

/* 
return TRUE if new bar is opened first time
return FALSE in case intrabar

Inputs: 

*/

bool isNewBar()
  {
  static datetime BarTime;  
   bool res=false;
    
   if (BarTime!=Time[0]) 
      {
         BarTime=Time[0];  
         res=true;
      } 
   return(res);
  }
//+------------------------------------------------------------------+
// End of FUNCTION is New Bar
//+------------------------------------------------------------------+