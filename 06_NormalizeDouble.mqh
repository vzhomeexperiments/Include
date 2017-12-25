//+-------------------------------------------------------------------+
//|                                            06_NormalizeDouble.mqh |
//|                                  Copyright 2016, Vladimir Zhbanko |
//|                                        vladimir.zhbanko@gmail.com |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2016, Vladimir Zhbanko"
#property link      "vladimir.zhbanko@gmail.com"
#property strict
// function to return price levels of Resistance and Support
// version 01
// date 11.08.2016

//+-------------------------------------------------------------+//
// Aim of this function is to normalize double prices for calculations
// of stop levels or take profit, etc
//+-------------------------------------------------------------+//
/*

User guide:
1. #include this file to the folder Include
2. When it's required to return Normalized prices just wrap them as follows:
Price = ND(Calculations);

*/

//+------------------------+//
//Normalizing Double prices //
//+------------------------+//

double ND(double val)
{
   return(NormalizeDouble(val, Digits()));
}

//+------------------------+//
//End Normalizing double    //
//+------------------------+//