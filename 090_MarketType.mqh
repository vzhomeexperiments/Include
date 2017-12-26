//+-------------------------------------------------------------------+
//|                                                 09_MarketType.mqh |
//|                                  Copyright 2017, Vladimir Zhbanko |
//|                                        vladimir.zhbanko@gmail.com |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2016, Vladimir Zhbanko"
#property link      "vladimir.zhbanko@gmail.com"
#property strict

#define MARKET_NONE      0       //Market not siutable for trading e.g. macroeconomic event
#define MARKET_BULLVOL   1       //Market with volatile bullish character
#define MARKET_BEARVOL   2       //Market with volatile bearish character
#define MARKET_RANGEVOL  3       //Ranging Market volatile
#define MARKET_BULLNOR   4       //Market with bullish character
#define MARKET_BEARNOR   5       //Market with bearish character
#define MARKET_RANGENOR  6       //Ranging Market
#define MARKET_CALM      7       //Calm Market
// function return integer code describing the market type
// version 02
// date 27.11.2016

//+-------------------------------------------------------------+//
// Aim of this function is to return information about the market type
//+-------------------------------------------------------------+//
/*
Function Functional Description:
Function is using currency symbol, begin date, and history deepth parameters
1. It look on the chart with specified period
2. It look on Bollinger Bands and corresponding price behaviour and derive market type using special algorithm
3. returns back the value

User guide:
1. #include this file to the folder Include
2. Call function when desired from the robot

*/

//+------------------------------------------------------------------+
//| FUNCTION MARKET TYPE                                     
//+------------------------------------------------------------------+

// Function to analyse market type
int MarketType(string pair, int period, int begin, int deepth)
{
   /* Definitions of variables
   pair - contains the string with symbol
   period - contains period in 15M bars
   begin - contains the starting point of the history to look (should be 1 when used by EA)
   deepth - how many days in the past we look to the history from the begin variable
   */
   
   //define internal variables needed
   int marketType = 0;     //Variable to store and return the market type
   /* Definitions of marketType
   #define MARKET_NONE      0       //Market not siutable for trading e.g. macroeconomic event
   #define MARKET_BULLVOL   1       //Market with volatile bullish character
   #define MARKET_BEARVOL   2       //Market with volatile bearish character
   #define MARKET_RANGEVOL  3       //Ranging Market volatile
   #define MARKET_BULLNOR   4       //Market with bullish character
   #define MARKET_BEARNOR   5       //Market with bearish character
   #define MARKET_RANGENOR  6       //Ranging Market
   #define MARKET_CALM      7       //Calm Market
   */
   
   double BB_ub[];         //Array Bollinger Bands upper bound
   double BB_lb[];         //Array Bollinger Bands lower bound
   double BB_al[];         //Array Bollinger Bands averaging line
   double BB_al_prev[];    //Array Bollinger Bands averaging line previous aver. line
   double BB_al_angle[];   //Array Bollinger Bands averaging line angle 
   double BB_ub_area[];    //Array Area contained by upper bound of BB
   double BB_lb_area[];    //Array Area contained by lower bound of BB
   double BB_area[];       //Array Area contained by BB
   double BAR_high[];      //Array High price of the symbol
   double BAR_low[];       //Array Low price of the symbol
   double BAR_quartile[];  //Array containing quartile occupied by BAR inside the band
   double BAR_area[];      //Array Area contained by price bars (high - low)
   
   double BB_ub_surface = 0;//contain sum of areas or surface of BB upper bound
   double BB_lb_surface = 0;//contain sum of areas or surface of BB upper bound
   double BB_surface = 0;  //contain sum of areas or surface of BB
   double BAR_surface = 0; //contain sum of areas or surface of bars
   double BAR_vs_BB_ratio = 0; //contain ratio of the bar surface vs total BB surface
   
   double BB_ub_occupied = 0;//contain ratio of BB upper bound occupied by bar
   double BB_lb_occupied = 0;//contain ratio of BB lower bound occupied by bar
   
   double BB_al_sumangle = 0;//contain sum of angle of the averaging line
   

   //resize the arrays, dimension equals to deepth parameter
   ArrayResize(BB_ub, deepth, 0);
   ArrayResize(BB_lb, deepth, 0);
   ArrayResize(BB_al, deepth, 0);
   ArrayResize(BB_al_prev, deepth, 0);
   ArrayResize(BB_al_angle, deepth, 0);
   ArrayResize(BB_ub_area, deepth, 0);
   ArrayResize(BB_lb_area, deepth, 0); 
   ArrayResize(BB_area, deepth, 0); 
   ArrayResize(BAR_high, deepth, 0);
   ArrayResize(BAR_low, deepth, 0);
   ArrayResize(BAR_area, deepth, 0);
   
//fill in the arrays
for(int i = 0; i < deepth; i++)
  {
   //calculate indicators
   BB_ub[i]      = iBands(pair,period,20,2,0,PRICE_CLOSE,MODE_UPPER,i + begin);      //upper bound
   BB_lb[i]      = iBands(pair,period,20,2,0,PRICE_CLOSE,MODE_LOWER,i + begin);      //lower bound
   BB_al[i]      = iBands(pair,period,20,2,0,PRICE_CLOSE,MODE_MAIN,i + begin);       //averaging line
   BB_al_prev[i] = iBands(pair,period,20,2,0,PRICE_CLOSE,MODE_MAIN,i + begin + 1);   //averaging line previous
   BAR_high[i]   = iHigh(pair,period,i + begin);
   BAR_low[i]    = iLow(pair,period,i + begin);
   //calculate derivatives
   BB_ub_area[i] = BB_ub[i] - BB_al[i];                     //area upper bound
   BB_lb_area[i] = BB_al[i] - BB_lb[i];                     //area lower bound
   BB_area[i]    = BB_ub[i] - BB_lb[i];                     //total area BBands
   
   BB_surface = BB_surface + BB_area[i];                    //calculate surface occpied by BBands
   BB_ub_surface = BB_ub_surface + BB_ub_area[i];           //calculate surface occpied by BBands Upper Bound
   BB_lb_surface = BB_lb_surface + BB_lb_area[i];           //calculate surface occpied by BBands Lower Bound
   
   BAR_area[i]   = BAR_high[i] - BAR_low[i];                //area of the price bars
   
   BAR_surface = BAR_surface + (BAR_high[i] - BAR_low[i]);  //calculate surface occupied by price bars
   
   BB_al_angle[i] = BB_al[i] - BB_al_prev[i];               //calculate angle of averaging line > 0 -> Bullish market
   BB_al_sumangle = BB_al_sumangle + BB_al_angle[i];        //sum of the angles gives the period direction
   
  }
   
   //Analyse the result of calculations 1. Total area occupied by bands, 2. Total area occupied by price vs bands, 3. Direction of trend sum of angles
   BAR_vs_BB_ratio = BAR_surface/(0.00001 + BB_surface);
   
   
   //Interpret the result of calculations
   /* Definitions of marketType
   #define MARKET_NONE      0       //Market not siutable for trading e.g. macroeconomic event
   #define MARKET_BULLVOL   1       //Market with volatile bullish character
   #define MARKET_BEARVOL   2       //Market with volatile bearish character
   #define MARKET_RANGEVOL  3       //Ranging Market volatile
   #define MARKET_BULLNOR   4       //Market with bullish character
   #define MARKET_BEARNOR   5       //Market with bearish character
   #define MARKET_RANGENOR  6       //Ranging Market
   #define MARKET_CALM      7       //Calm Market
   */
   if(BAR_vs_BB_ratio < 0.20 && BB_al_sumangle >= 0.02)                           marketType = MARKET_BULLVOL;//Bullish Volatile
   if(BAR_vs_BB_ratio < 0.20 && BB_al_sumangle <= -0.02)                          marketType = MARKET_BEARVOL;//Bearish Volatile
   if(BAR_vs_BB_ratio < 0.20 && BB_al_sumangle > -0.02 && BB_al_sumangle < 0.02)  marketType = MARKET_RANGEVOL;//Ranging Volatile
   if(BAR_vs_BB_ratio >= 0.20 && BB_al_sumangle >= 0.02)                          marketType = MARKET_BULLNOR;//Bullish Normal   
   if(BAR_vs_BB_ratio >= 0.20 && BB_al_sumangle <= -0.02)                         marketType = MARKET_BEARNOR;//Bearish Normal  
   if(BAR_vs_BB_ratio >= 0.20 && ((BB_al_sumangle > -0.02 
                              && BB_al_sumangle < -0.01) 
                              || (BB_al_sumangle > 0.01
                              && BB_al_sumangle < 0.02)))                         marketType = MARKET_RANGENOR;//Ranging Normal   
   if(BAR_vs_BB_ratio >= 0.20 && BB_al_sumangle >= -0.01 
                              && BB_al_sumangle <= 0.01)                          marketType = MARKET_CALM;//Ranging Normal      
      
   
   //Enable comment for debugging   
   Comment(BB_surface, "\n", BAR_surface, "\n", BAR_vs_BB_ratio, "\n", BB_al_sumangle, "\n", marketType);
   
   //Output the result of calculations
   return(marketType);
}

//+------------------------------------------------------------------+
//| End of FUNCTION MARKET TYPE
//+------------------------------------------------------------------+