//+-------------------------------------------------------------------+
//|                                            07_GetMarketStatus.mqh |
//|                                  Copyright 2016, Vladimir Zhbanko |
//|                                        vladimir.zhbanko@gmail.com |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2016, Vladimir Zhbanko"
#property link      "vladimir.zhbanko@gmail.com"
#property strict
// function returning a string with information about market status
// version 01
// date 16.10.2016

//+-------------------------------------------------------------+//
// Aim of this function is to return information about the market status
// to enable or pause certain strategies
//+-------------------------------------------------------------+//
/*
Function Functional Description:
Function is calculating the integral of the Bear and Bull power indicators over Period of days
1. Calculate Power Indicator for X days
2. Calculate sums of the daily power indicators over the period of X days
3. Sum obtained results for Bear and Bull powers and get their absolute value
4. Calculate "fight" variable as a difference btw Bull and Bear values
5. Compare the condition of "fight" and return the market value using provided Thresholds
6. Return a string with identified market 
7. Should there is no identification occurred return key "Error"

User guide:
1. #include this file to the folder Include
2. When it's required to return market status use function GetMarketStatus()
3. Provide follwing information:
   HistDays - How many days in the past the market should be accessed
   StrBullThr - Value of strong Bullish Threshold Market, tipically  0.1
   StrBearThr - Value of strong Bearish Threshold Market, tipically -0.1
   RngBullThr - Value of ranging Bullish Threshold Market, tipically  0.03
   RngBearThr - Value of ranging Bearish Threshold Market, tipically -0.03

*/

//+------------------------+//
// GetMarketStatus          //
//+------------------------+//

string GetMarketStatus(int HistDays, double StrBullThr, double StrBearThr, double RngBullThr, double RngBearThr)
 {
   // Accessing the market using Daily Time frame and PowersIndicators 10(d)
   // Calculate sums of returned values and compare their abs values, when done return string as a function
   double Bulls, Bears, SumsBulls, SumsBears, AbsBulls, AbsBears, Fight;
   string MarketType;
   
  // reset first
   SumsBears = 0;
   SumsBulls = 0;
   
   for(int i = 0; i < HistDays - 1; i++)
     {
      Bulls = iBullsPower(NULL, PERIOD_D1, HistDays, PRICE_TYPICAL, i);
      Bears = iBearsPower(NULL, PERIOD_D1, HistDays, PRICE_TYPICAL, i);
      SumsBulls = SumsBulls + Bulls;
      SumsBears = SumsBears + Bears;
     }
   AbsBulls = MathAbs(SumsBulls);
   AbsBears = MathAbs(SumsBears);
   
   // determine a "fight" variable
   Fight = AbsBulls - AbsBears; 
   
   /* Example
   Case: less -0.1 --> strong bearish, return("StrBear")
   Case: more  0.1 --> strong bullish, return("StrBull")
   Case: btw -0.1 to -0.03 --> ranging bearish, return("RngBear")
   Case: btw 0.03 to  0.1  --> ranging bullish, return("RngBull")
   Case: btw -0.03 to 0.03 --> ranging, return("Rng")
   
   */ 
   
   if(Fight >= StrBullThr)
     {
       return("StrBull");
     } else if(Fight <= StrBearThr)
              {
                MarketType = "StrBear";
              } else if(Fight <= RngBearThr && Fight > StrBearThr)
                       {
                         MarketType = "RngBear";
                       }   else if(Fight >= RngBullThr && Fight < StrBullThr)
                                  {
                                    MarketType = "RngBull";
                                  } else if(Fight > RngBearThr && Fight < RngBullThr)
                                           {
                                             MarketType = "Rng";
                                           } else
                                               {
                                                MarketType = "Error";
                                               }
         return(MarketType);
         
 }

//+------------------------+//
// End of GetMarketStatus   //
//+------------------------+//