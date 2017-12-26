//+------------------------------------------------------------------+
//|                                           Clarissa_Functions.mqh 
//|                                        Copyright 2016,Lucas Liew 
//|                                  lucas@blackalgotechnologies.com 
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Black Algo Technologies Pte Ltd"
#property link      "lucas@blackalgotechnologies.com"


//+------------------------------------------------------------------------------------------------------------------------------------+
// FUNCTIONS LIBRARY                                                                                                                   
//+------------------------------------------------------------------------------------------------------------------------------------+

//+------------------------------------------------------------------+
// Customized Print                                                  
//+------------------------------------------------------------------+
void noMoneyPrint(){

   Print("We have no money. Free Margin = ", AccountFreeMargin());

}
//+------------------------------------------------------------------+
// End of Customized Print                                           
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
// Cross                                                             
//+------------------------------------------------------------------+

// We didn't use the Cross function for CLARISSA but it is a good habit to keep the functions here for potential future use

/* 

Function Notes:

Declare these before the init() of the EA 

int current_direction, last_direction;
bool first_time = True;

----  

If Output is 0: No cross happened
If Output is 1: Line 1 crossed Line 2 from Bottom
If Output is 2: Line 1 crossed Line 2 from top 

*/

int Crossed(double line1 , double line2) 
  {

//----
    if(line1 > line2)
        current_direction = 1;  // line1 above line2
    if(line1 < line2)
        current_direction = 2;  // line1 below line2
//----
    if(first_time == true) // Need to check if this is the first time the function is run
      {
        first_time = false; // Change variable to false
        last_direction = current_direction; // Set new direction
        return (0);
      }

    if(current_direction != last_direction && first_time == false)  // If not the first time and there is a direction change
      {
        last_direction = current_direction; // Set new direction
        return(current_direction); // 1 for up, 2 for down
      }
    else
      {
        return (0);  // No direction change
      }
  }


//+------------------------------------------------------------------+
// End of Cross                                                      
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Volatility Stop Loss                                             
//+------------------------------------------------------------------+

// TDL 1: 

double volBasedStopLoss(bool isVolatilitySwitchOn, double fixedStop, double volATR, double volMultiplier, int K) // K represents our P multiplier to adjust for broker digits
  {
  
  double StopL;
  
      if(!isVolatilitySwitchOn){
         StopL=fixedStop; // If Volatility Stop Loss not activated. Stop Loss = Fixed Pips Stop Loss
      } else {
         StopL=volMultiplier*volATR/(K*Point); // Stop Loss in Pips
      }
      
  return(StopL);
  
  }

//+------------------------------------------------------------------+
//| End of Volatility Stop Loss // CURRENT SYMBOL                    
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Volatility-Based Take Profit                                     
//+------------------------------------------------------------------+

// TDL 1: 

double volBasedTakeProfit(bool isVolatilitySwitchOn, double fixedTP, double volATR, double volMultiplier, int K) // K represents our P multiplier to adjust for broker digits
  {
  
  double TakeP;
  
      if(!isVolatilitySwitchOn){
         TakeP=fixedTP; // If Volatility Take Profit not activated. Take Profit = Fixed Pips Take Profit
      } else {
         TakeP=volMultiplier*volATR/(K*Point); // Take Profit in Pips
      }
    
  return(TakeP);
  
  }

//+------------------------------------------------------------------+
//| End of Volatility-Based Take Profit                 
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Position Sizing Algo               
//+------------------------------------------------------------------+
   
// TDL 2: 
   
double getLot(bool isSizingOnTrigger,double fixedLots, double riskPerTrade, int yenAdjustment, double stops, int K) {
   
   double output;
      
   if (isSizingOnTrigger == true) {
      output = riskPerTrade * 0.01 * AccountBalance() / (MarketInfo(Symbol(),MODE_LOTSIZE) * stops * K * Point); // Sizing Algo based on account size
      output = output * yenAdjustment; // Adjust for Yen Pairs
   } else {
      output = fixedLots;
   }
   output = NormalizeDouble(output, 2); // Round to 2 decimal place
   return(output);
}
   
//+------------------------------------------------------------------+
//| End of Position Sizing Algo               
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
// Entry Rule                                                        
//+------------------------------------------------------------------+

// TDL 3: 

int entryRules(int ver, double ATR_K, double volATR) {
   
   double mondayPriceChangeUpDay = 0;
   double mondayPriceChangeDownDay = 0;
   double mondayPriceChange = 0;
   int output = 0;
   
   if(DayOfWeek() == 2) if(Hour() == 0){

      if (ver == 1) {
         mondayPriceChange = iClose(NULL,PERIOD_D1,1) - iOpen(NULL,PERIOD_D1,1);
         if (mondayPriceChange > 0) mondayPriceChangeUpDay = mondayPriceChange;
         if (mondayPriceChange < 0) mondayPriceChangeDownDay = MathAbs(mondayPriceChange);
      }
    
      if (ver == 2) {
         mondayPriceChangeUpDay = iHigh(NULL,PERIOD_D1,1) - iOpen(NULL,PERIOD_D1,1);
         mondayPriceChangeDownDay = iOpen(NULL,PERIOD_D1,1) - iLow(NULL,PERIOD_D1,1);
      }
      
      if (mondayPriceChangeUpDay > ATR_K * volATR){
         output = 1; // Long signal
      } else if (mondayPriceChangeDownDay > ATR_K * volATR){
         output = -1; // Short signal
      }
      
   }
   
   return(output);
}
//+------------------------------------------------------------------+
// End of Entry Rule                                                 
//+------------------------------------------------------------------+