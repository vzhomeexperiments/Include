//+-------------------------------------------------------------------+
//|                                                 DSS_Functions.mqh |
//|                                  Copyright 2021, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2021, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property strict

// Functions library to DSS_Bot, DSS_Rule, DSS_Hybrid robots
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//|                     FUNCTIONS LIBRARY                                   
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/*

Content:
1) EntrySignal
2.1) ExitSignal
2.2) ExitSignalOnTimerMagic
2.3) ExitSignalOnTimerTicket
2.4) ExitSignalOnAI
3) GetLot
4) CheckLot
5) CountPosOrders
6) IsMaxPositionsReached
7) OpenPositionMarket
8) OpenPositionPending
9) CloseOrderPosition
10) GetP
11) GetYenAdjustFactor
12) VolBasedStopLoss
13) VolBasedTakeProfit
14) Crossed1 / Crossed2
15) IsLossLimitBreached
16) IsVolLimitBreached
17) SetStopLossHidden
18) TriggerStopLossHidden
19) SetTakeProfitHidden
20) TriggerTakeProfitHidden
21) BreakevenStopAll
22) UpdateHiddenBEList
23) SetAndTriggerBEHidden
24) TrailingStopAll
25) UpdateHiddenTrailingList
26) SetAndTriggerHiddenTrailing
27) UpdateVolTrailingList
28) SetVolTrailingStop
29) ReviewVolTrailingStop
30) UpdateHiddenVolTrailingList
31) SetHiddenVolTrailing
32) TriggerAndReviewHiddenVolTrailing
33) HandleTradingEnvironment
34) GetErrorDescription
35) GetTradeFlagCondition
36) GetTradePrediction
*/

//+------------------------------------------------------------------+
//| ENTRY SIGNAL                                                     |
//+------------------------------------------------------------------+
int EntrySignal(int CrossOccurred)
  {
// Type: Customisable 
// Modify this function to suit your trading robot

// This function checks for entry signals

   int   entryOutput=0;

   if(CrossOccurred==1)
     {
      entryOutput=1; 
     }

   if(CrossOccurred==2)
     {
      entryOutput=2;
     }

   return(entryOutput);
  }
//+------------------------------------------------------------------+
//| End of ENTRY SIGNAL                                              |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Exit SIGNAL                                                      |
//+------------------------------------------------------------------+
int ExitSignal(int CrossOccurred)
  {
// Type: Customisable 
// Modify this function to suit your trading robot

// This function checks for exit signals

   int   ExitOutput=0;

   if(CrossOccurred==1)
     {
      ExitOutput=1;
     }

   if(CrossOccurred==2)
     {
      ExitOutput=2;
     }

   return(ExitOutput);
  }
//+------------------------------------------------------------------+
//| End of Exit SIGNAL                                               
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Exit SIGNAL ON TIMER MAGIC                                            |
//+------------------------------------------------------------------+
int ExitSignalOnTimerMagic(int CrossOccurred, int Magic, int MaxOrderCloseTimer)
  {
// Type: Customisable 
// Modify this function to suit your trading robot

// This function checks for exit signals using a magic number. Note that function will close multiple orders

   int   ExitOutput=0;
   int   CurrOrderHoldTime;
   double CurrOrderProfit;  
   
   if(CrossOccurred==1)
     {
      //checking the orders time before closing them
       for(int i=OrdersTotal()-1; i>=0; i--) 
        {
         CurrOrderHoldTime = 0;
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true &&
                         OrderSymbol()==Symbol() &&
                         OrderMagicNumber()==Magic && 
                         OrderType()==OP_SELL) 
                         //Calculating order current time in minutes, used for closing orders
                         CurrOrderHoldTime = int((TimeCurrent() - OrderOpenTime())/60);
                         CurrOrderProfit = NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(),2);
         //if(CurrOrderHoldTime >= MaxOrderCloseTimer && CurrOrderProfit > 0)  ExitOutput=1;
         if(CurrOrderHoldTime >= MaxOrderCloseTimer)  ExitOutput=1;
        }
     
     }

   if(CrossOccurred==2)
     {
      //checking the orders time before closing them
       for(int i=OrdersTotal()-1; i>=0; i--) 
        {
         CurrOrderHoldTime = 0;
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true &&
                         OrderSymbol()==Symbol() &&
                         OrderMagicNumber()==Magic && 
                         OrderType() == OP_BUY) 
                         //Calculating order current time in minutes, used for closing orders
                         CurrOrderHoldTime = int((TimeCurrent() - OrderOpenTime())/60);
                         CurrOrderProfit = NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(),2);
         if(CurrOrderHoldTime >= MaxOrderCloseTimer && CurrOrderProfit > 0 )  ExitOutput=2;
         if(CurrOrderHoldTime >= MaxOrderCloseTimer)  ExitOutput=2;
        }
     
     }

   return(ExitOutput);
  }
//+------------------------------------------------------------------+
//| End of Exit SIGNAL ON TIMER                           
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Exit SIGNAL ON AI                                                |
//+------------------------------------------------------------------+
int ExitSignalOnAI(int CrossOccurred, int Magic, double CurrPrediction)
  {
// Type: Customisable 
// Modify this function to suit your trading robot
// CrossOccurred - identifies type of position 2 buy; 1 sell
// CurrPrediction - current prediction from AI

// This function checks for exit signals

   int    ExitOutput=0;
   double CurrOrderProfit; 
   
   if(CrossOccurred==1) //condition for sell orders
     {
      //checking the orders time before closing them
       for(int i=OrdersTotal()-1; i>=0; i--) 
        {
         CurrOrderProfit = 0;
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true &&
                         OrderSymbol()==Symbol() &&
                         OrderMagicNumber()==Magic && 
                         OrderType()==OP_SELL) 
                         //Calculating order current profit
                         CurrOrderProfit = NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(),2);
         if(CurrOrderProfit > 0 && CurrPrediction > 0)  ExitOutput=1;
        }
     
     }

   if(CrossOccurred==2) //condition for buy orders
     {
      //checking the orders time before closing them
       for(int i=OrdersTotal()-1; i>=0; i--) 
        {
         CurrOrderProfit = 0;
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true &&
                         OrderSymbol()==Symbol() &&
                         OrderMagicNumber()==Magic && 
                         OrderType() == OP_BUY) 
                         //Calculating order current profit
                         CurrOrderProfit = NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(),2);
         if(CurrOrderProfit > 0 && CurrPrediction < 0)  ExitOutput=2;
        }
     
     }

   return(ExitOutput);
  }
//+------------------------------------------------------------------+
//| End of Exit SIGNAL ON AI                           
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Exit SIGNAL ON TIMER TICKET                                            |
//+------------------------------------------------------------------+
int ExitSignalOnTimerTicket(int CrossOccurred, int Magic, int & infoArray [][])
  {
// Type: Customisable 
// Modify this function to suit your trading robot

// This function checks for exit signals for each open order separately using the ticket
// If this will output 2 then one or more BUY orders shall be closed
//                     1 then one or more SELL orders shall be closed

   int   ExitOutput=0;
   int   CurrOrderHoldTime;
   double CurrOrderProfit;  
   
      
   if(CrossOccurred==1) //checking sell orders only
     {
         //check the order time using ticket from array
         CurrOrderHoldTime = 0;
         for(int j=0;j<ArrayRange(infoArray,0);j++)
           {
           Print("Info Array Ticket Number: " + (string)infoArray[j][0]);
            if(OrderSelect(infoArray[j][0],SELECT_BY_TICKET,MODE_TRADES)==true &&
                         OrderSymbol()==Symbol() &&
                         OrderMagicNumber()==Magic && 
                         OrderType()==OP_SELL) 
                         //Calculating order current time in minutes, used for closing orders
                         CurrOrderHoldTime = int((TimeCurrent() - OrderOpenTime())/60);
                         CurrOrderProfit = NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(),2);
            //if(CurrOrderHoldTime >= infoArray[j][1] && CurrOrderProfit > 0)  ExitOutput=1;
            if(CurrOrderHoldTime >= infoArray[j][1]) { ExitOutput=1; break;}
            
           }

        
     
     }

   if(CrossOccurred==2) //checking buy orders only
     {
         //checking the orders time using ticket from array
         CurrOrderHoldTime = 0;
         for(int j=0;j<ArrayRange(infoArray,0);j++)
           {
            if(OrderSelect(infoArray[j][0],SELECT_BY_TICKET,MODE_TRADES)==true &&
                         OrderSymbol()==Symbol() &&
                         OrderMagicNumber()==Magic && 
                         OrderType()==OP_BUY) 
                         //Calculating order current time in minutes, used for closing orders
                         CurrOrderHoldTime = int((TimeCurrent() - OrderOpenTime())/60);
                         CurrOrderProfit = NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(),2);
            //if(CurrOrderHoldTime >= infoArray[j][1] && CurrOrderProfit > 0)  ExitOutput=2;
            if(CurrOrderHoldTime >= infoArray[j][1]) { ExitOutput=2; break;}
           }
     
     }

   return(ExitOutput);
  }
//+------------------------------------------------------------------+
//| End of Exit SIGNAL ON TIMER TICKET                          
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Exit SIGNAL ON TIMER TICKET                                            |
//+------------------------------------------------------------------+
int ExitSignalOnTimerTicketBars(int CrossOccurred, int Magic, int BarTimeframeMin, int & infoArray [][])
  {
// Type: Customisable 
// Modify this function to suit your trading robot

// This function checks for exit signals for each open order separately using the information inside the array
// If this will output
//                     1 then one or more SELL orders shall be closed
// This function will calculate order open time in BARS!

   int   ExitOutput=0;
   int RequiredOrderTimeBars;
   int CurrOrderHoldTimeBars = 0;
      
   if(CrossOccurred==1) //checking sell orders only
     {
         //check the order time using ticket from array
         for(int j=0;j<ArrayRange(infoArray,0);j++)
           {
           //Print("Info Array Ticket Number: " + (string)infoArray[j][0]);
            if(OrderSelect(infoArray[j][0],SELECT_BY_TICKET,MODE_TRADES)==true &&
                         OrderSymbol()==Symbol() &&
                         OrderMagicNumber()==Magic && 
                         OrderType()==OP_SELL) 
                         //Calculating order open time shift in bars to avoid closing order after the weekend
                         CurrOrderHoldTimeBars = iBarShift(Symbol(), BarTimeframeMin,OrderOpenTime(),true);
                         RequiredOrderTimeBars = infoArray[j][1]/BarTimeframeMin;
            if(CurrOrderHoldTimeBars >= RequiredOrderTimeBars) { ExitOutput=1; break;}
           }

        
     
     }

   if(CrossOccurred==2) //checking buy orders only
     {
         //checking the orders time using ticket from array
         for(int j=0;j<ArrayRange(infoArray,0);j++)
           {
            if(OrderSelect(infoArray[j][0],SELECT_BY_TICKET,MODE_TRADES)==true &&
                         OrderSymbol()==Symbol() &&
                         OrderMagicNumber()==Magic && 
                         OrderType()==OP_BUY) 
                         //Calculating order open time shift in bars to avoid closing order after the weekend
                         CurrOrderHoldTimeBars = iBarShift(Symbol(), BarTimeframeMin,OrderOpenTime(),true);
                         RequiredOrderTimeBars = infoArray[j][1]/BarTimeframeMin;
            if(CurrOrderHoldTimeBars >= RequiredOrderTimeBars) { ExitOutput=2; break;}
           }
     
     }

   return(ExitOutput);
  }
//+------------------------------------------------------------------+
//| End of Exit SIGNAL ON TIMER TICKET                          
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Position Sizing Algo               
//+------------------------------------------------------------------+
// Type: Customisable 
// Modify this function to suit your trading robot

// This is our sizing algorithm

double GetLot(bool IsSizingOnTrigger,double FixedLots,double RiskPerTrade,int YenAdjustment,double STOP,int K) 
  {

   double output;

   if(IsSizingOnTrigger==true) 
     {
      output=RiskPerTrade*0.01*AccountBalance()/(MarketInfo(Symbol(),MODE_LOTSIZE)*MarketInfo(Symbol(),MODE_TICKVALUE)*STOP*K*Point); // Sizing Algo based on account size
      output=output*YenAdjustment; // Adjust for Yen Pairs
        } else {
      output=FixedLots;
     }
   output=NormalizeDouble(output,2); // Round to 2 decimal place
   return(output);
  }
//+------------------------------------------------------------------+
//| End of Position Sizing Algo               
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| CHECK LOT
//+------------------------------------------------------------------+
double CheckLot(double Lot,bool Journaling)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function checks if our Lots to be trade satisfies any broker limitations

   double LotToOpen=0;
   LotToOpen=NormalizeDouble(Lot,2);
   LotToOpen=MathFloor(LotToOpen/MarketInfo(Symbol(),MODE_LOTSTEP))*MarketInfo(Symbol(),MODE_LOTSTEP);

   if(LotToOpen<MarketInfo(Symbol(),MODE_MINLOT))LotToOpen=MarketInfo(Symbol(),MODE_MINLOT);
   if(LotToOpen>MarketInfo(Symbol(),MODE_MAXLOT))LotToOpen=MarketInfo(Symbol(),MODE_MAXLOT);
   LotToOpen=NormalizeDouble(LotToOpen,2);

   if(Journaling && LotToOpen!=Lot)Print("EA Journaling: Trading Lot has been changed by CheckLot function. Requested lot: "+(string)Lot+". Lot to open: "+(string)LotToOpen);

   return(LotToOpen);
  }
//+------------------------------------------------------------------+
//| End of CHECK LOT
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| COUNT POSITIONS 
//+------------------------------------------------------------------+
int CountPosOrders(int Magic,int TYPE)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function counts number of positions/orders of OrderType TYPE

   int Orders=0;
    for(int i=OrdersTotal()-1; i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==TYPE)
         Orders++;
     }
   return(Orders);

  }
//+------------------------------------------------------------------+
//| End of COUNT POSITIONS
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| MAX ORDERS                                              
//+------------------------------------------------------------------+
bool IsMaxPositionsReached(int MaxPositions,int Magic,bool Journaling)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function checks the number of positions we are holding against the maximum allowed 

   bool result=False;
   if(CountPosOrders(Magic,OP_BUY)+CountPosOrders(Magic,OP_SELL)>MaxPositions) 
     {
      result=True;
      if(Journaling)Print("Max Orders Exceeded");
        } else if(CountPosOrders(Magic,OP_BUY)+CountPosOrders(Magic,OP_SELL)==MaxPositions) {
      result=True;
     }

   return(result);

/* Definitions: Position vs Orders
   
   Position describes an opened trade
   Order is a pending trade
   
   How to use in a sentence: Jim has 5 buy limit orders pending 10 minutes ago. The market just crashed. The orders were executed and he has 5 losing positions now lol.

*/
  }
//+------------------------------------------------------------------+
//| End of MAX ORDERS                                                
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| OPEN FROM MARKET
//+------------------------------------------------------------------+
int OpenPositionMarket(int TYPE,double LOT,double SL,double TP,int Magic,int Slip,bool Journaling,int K,bool ECN,int Max_Retries_Per_Tick,int Retry_Interval)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function submits new orders

   int tries=0;
   string symbol=Symbol();
   int cmd=TYPE;
   double volume=CheckLot(LOT,Journaling);
   if(MarketInfo(symbol,MODE_MARGINREQUIRED)*volume>AccountFreeMargin())
     {
      Print("Can not open a trade. Not enough free margin to open "+(string)volume+" on "+symbol);
      return(-1);
     }
   int slippage=Slip*K; // Slippage is in points. 1 point = 0.0001 on 4 digit broker and 0.00001 on a 5 digit broker
   string comment=" "+(string)TYPE+"(#"+(string)Magic+")";
   int magic=Magic;
   datetime expiration=0;
   color arrow_color=0;if(TYPE==OP_BUY)arrow_color=Blue;if(TYPE==OP_SELL)arrow_color=Green;
   double stoploss=0;
   double takeprofit=0;
   double initTP = TP;
   double initSL = SL;
   int Ticket=-1;
   double price=0;
   if(!ECN)
     {
      while(tries<Max_Retries_Per_Tick) // Edits stops and take profits before the market order is placed
        {
         RefreshRates();
         if(TYPE==OP_BUY)price=Ask;if(TYPE==OP_SELL)price=Bid;

         // Sets Take Profits and Stop Loss. Check against Stop Level Limitations.
         if(TYPE==OP_BUY && SL!=0)
           {
            stoploss=NormalizeDouble(Ask-SL*K*Point,Digits);
            if(Bid-stoploss<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
              {
               stoploss=NormalizeDouble(Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
               if(Journaling)Print("EA Journaling: Stop Loss changed from "+(string)initSL+" to "+string(MarketInfo(Symbol(),MODE_STOPLEVEL)/K)+" pips");
              }
           }
         if(TYPE==OP_SELL && SL!=0)
           {
            stoploss=NormalizeDouble(Bid+SL*K*Point,Digits);
            if(stoploss-Ask<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
              {
               stoploss=NormalizeDouble(Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
               if(Journaling)Print("EA Journaling: Stop Loss changed from "+(string)initSL+" to "+string(MarketInfo(Symbol(),MODE_STOPLEVEL)/K)+" pips");
              }
           }
         if(TYPE==OP_BUY && TP!=0)
           {
            takeprofit=NormalizeDouble(Ask+TP*K*Point,Digits);
            if(takeprofit-Bid<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
              {
               takeprofit=NormalizeDouble(Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
               if(Journaling)Print("EA Journaling: Take Profit changed from "+(string)initTP+" to "+string(MarketInfo(Symbol(),MODE_STOPLEVEL)/K)+" pips");
              }
           }
         if(TYPE==OP_SELL && TP!=0)
           {
            takeprofit=NormalizeDouble(Bid-TP*K*Point,Digits);
            if(Ask-takeprofit<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
              {
               takeprofit=NormalizeDouble(Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
               if(Journaling)Print("EA Journaling: Take Profit changed from "+(string)initTP+" to "+string(MarketInfo(Symbol(),MODE_STOPLEVEL)/K)+" pips");
              }
           }
         if(Journaling)Print("EA Journaling: Trying to place a market order...");
         HandleTradingEnvironment(Journaling,Retry_Interval);
         Ticket=OrderSend(symbol,cmd,volume,price,slippage,stoploss,takeprofit,comment,magic,expiration,arrow_color);
         if(Ticket>0)break;
         tries++;
        }
     }
   if(ECN) // Edits stops and take profits after the market order is placed
     {
      HandleTradingEnvironment(Journaling,Retry_Interval);
      if(TYPE==OP_BUY)price=Ask;if(TYPE==OP_SELL)price=Bid;
      if(Journaling)Print("EA Journaling: Trying to place a market order...");
      Ticket=OrderSend(symbol,cmd,volume,price,slippage,0,0,comment,magic,expiration,arrow_color);
      if(Ticket>0)
         if(Ticket>0 && OrderSelect(Ticket,SELECT_BY_TICKET)==true && (SL!=0 || TP!=0))
           {
            // Sets Take Profits and Stop Loss. Check against Stop Level Limitations.
            if(TYPE==OP_BUY && SL!=0)
              {
               stoploss=NormalizeDouble(OrderOpenPrice()-SL*K*Point,Digits);
               if(Bid-stoploss<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
                 {
                  stoploss=NormalizeDouble(Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
                  if(Journaling)Print("EA Journaling: Stop Loss changed from "+(string)initSL+" to "+string((OrderOpenPrice()-stoploss)/(K*Point))+" pips");
                 }
              }
            if(TYPE==OP_SELL && SL!=0)
              {
               stoploss=NormalizeDouble(OrderOpenPrice()+SL*K*Point,Digits);
               if(stoploss-Ask<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
                 {
                  stoploss=NormalizeDouble(Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
                  if(Journaling)Print("EA Journaling: Stop Loss changed from "+(string)initSL+" to "+string((stoploss-OrderOpenPrice())/(K*Point))+" pips");
                 }
              }
            if(TYPE==OP_BUY && TP!=0)
              {
               takeprofit=NormalizeDouble(OrderOpenPrice()+TP*K*Point,Digits);
               if(takeprofit-Bid<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
                 {
                  takeprofit=NormalizeDouble(Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
                  if(Journaling)Print("EA Journaling: Take Profit changed from "+(string)initTP+" to "+string((takeprofit-OrderOpenPrice())/(K*Point))+" pips");
                 }
              }
            if(TYPE==OP_SELL && TP!=0)
              {
               takeprofit=NormalizeDouble(OrderOpenPrice()-TP*K*Point,Digits);
               if(Ask-takeprofit<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
                 {
                  takeprofit=NormalizeDouble(Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
                  if(Journaling)Print("EA Journaling: Take Profit changed from "+(string)initTP+" to "+string((OrderOpenPrice()-takeprofit)/(K*Point))+" pips");
                 }
              }
            bool ModifyOpen=false;
            while(!ModifyOpen)
              {
               HandleTradingEnvironment(Journaling,Retry_Interval);
               ModifyOpen=OrderModify(Ticket,OrderOpenPrice(),stoploss,takeprofit,expiration,arrow_color);
               if(Journaling && !ModifyOpen)Print("EA Journaling: Take Profit and Stop Loss not set. Error Description: "+GetErrorDescription(GetLastError()));
              }
           }
     }
   if(Journaling && Ticket<0)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
   if(Journaling && Ticket>0)
     {
      Print("EA Journaling: Order successfully placed. Ticket: "+(string)Ticket);
     }
   return(Ticket);
  }
//+------------------------------------------------------------------+
//| End of OPEN FROM MARKET   
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| OPEN PENDING ORDERS
//+------------------------------------------------------------------+
int OpenPositionPending(int TYPE,double OpenPrice,datetime expiration,double LOT,double SL,double TP,int Magic,int Slip,bool Journaling,int K,bool ECN,int Max_Retries_Per_Tick,int Retry_Interval)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function submits new pending orders
   OpenPrice= NormalizeDouble(OpenPrice,Digits);
   int tries=0;
   string symbol=Symbol();
   int cmd=TYPE;
   double volume=CheckLot(LOT,Journaling);
   if(MarketInfo(symbol,MODE_MARGINREQUIRED)*volume>AccountFreeMargin())
     {
      Print("Can not open a trade. Not enough free margin to open "+(string)volume+" on "+symbol);
      return(-1);
     }
   int slippage=Slip*K; // Slippage is in points. 1 point = 0.0001 on 4 digit broker and 0.00001 on a 5 digit broker
   string comment=" "+(string)TYPE+"(#"+(string)Magic+")";
   int magic=Magic;
   color arrow_color=0;if(TYPE==OP_BUYLIMIT || TYPE==OP_BUYSTOP)arrow_color=Blue;if(TYPE==OP_SELLLIMIT || TYPE==OP_SELLSTOP)arrow_color=Green;
   double stoploss=0;
   double takeprofit=0;
   double initTP = TP;
   double initSL = SL;
   int Ticket=-1;
   double price=0;

   while(tries<Max_Retries_Per_Tick) // Edits stops and take profits before the market order is placed
     {
      RefreshRates();

      // We are able to send in TP and SL when we open our orders even if we are using ECN brokers

      // Sets Take Profits and Stop Loss. Check against Stop Level Limitations.
      if((TYPE==OP_BUYLIMIT || TYPE==OP_BUYSTOP) && SL!=0)
        {
         stoploss=NormalizeDouble(OpenPrice-SL*K*Point,Digits);
         if(OpenPrice-stoploss<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
           {
            stoploss=NormalizeDouble(OpenPrice-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
            if(Journaling)Print("EA Journaling: Stop Loss changed from "+(string)initSL+" to "+string((OpenPrice-stoploss)/(K*Point))+" pips");
           }
        }
      if((TYPE==OP_BUYLIMIT || TYPE==OP_BUYSTOP) && TP!=0)
        {
         takeprofit=NormalizeDouble(OpenPrice+TP*K*Point,Digits);
         if(takeprofit-OpenPrice<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
           {
            takeprofit=NormalizeDouble(OpenPrice+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
            if(Journaling)Print("EA Journaling: Take Profit changed from "+(string)initTP+" to "+string((takeprofit-OpenPrice)/(K*Point))+" pips");
           }
        }
      if((TYPE==OP_SELLLIMIT || TYPE==OP_SELLSTOP) && SL!=0)
        {
         stoploss=NormalizeDouble(OpenPrice+SL*K*Point,Digits);
         if(stoploss-OpenPrice<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
           {
            stoploss=NormalizeDouble(OpenPrice+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
            if(Journaling)Print("EA Journaling: Stop Loss changed from " + (string)initSL + " to " + string((stoploss-OpenPrice)/(K*Point)) + " pips");
           }
        }
      if((TYPE==OP_SELLLIMIT || TYPE==OP_SELLSTOP) && TP!=0)
        {
         takeprofit=NormalizeDouble(OpenPrice-TP*K*Point,Digits);
         if(OpenPrice-takeprofit<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
           {
            takeprofit=NormalizeDouble(OpenPrice-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
            if(Journaling)Print("EA Journaling: Take Profit changed from " + (string)initTP + " to " + string((OpenPrice-takeprofit)/(K*Point)) + " pips");
           }
        }
      if(Journaling)Print("EA Journaling: Trying to place a pending order...");
      HandleTradingEnvironment(Journaling,Retry_Interval);

      //Note: We did not modify Open Price if it breaches the Stop Level Limitations as Open Prices are sensitive and important. It is unsafe to change it automatically.
      Ticket=OrderSend(symbol,cmd,volume,OpenPrice,slippage,stoploss,takeprofit,comment,magic,expiration,arrow_color);
      if(Ticket>0)break;
      tries++;
     }

   if(Journaling && Ticket<0)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
   if(Journaling && Ticket>0)
     {
      Print("EA Journaling: Order successfully placed. Ticket: "+(string)Ticket);
     }
   return(Ticket);
  }
//+------------------------------------------------------------------+
//| End of OPEN PENDING ORDERS 
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| CLOSE/DELETE ORDERS AND POSITIONS
//+------------------------------------------------------------------+
bool CloseOrderPosition(int TYPE,bool Journaling,int Magic,int Slip,int K,int Retry_Interval)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function closes all positions of type TYPE or Deletes pending orders of type TYPE
   int ordersPos=OrdersTotal();

   for(int i=ordersPos-1; i>=0; i--)
     {
      // Note: Once pending orders become positions, OP_BUYLIMIT AND OP_BUYSTOP becomes OP_BUY, OP_SELLLIMIT and OP_SELLSTOP becomes OP_SELL
      if(TYPE==OP_BUY || TYPE==OP_SELL)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==TYPE)
           {
            bool Closing=false;
            double Price=0;
            color arrow_color=0;if(TYPE==OP_BUY)arrow_color=Blue;if(TYPE==OP_SELL)arrow_color=Green;
            if(Journaling)Print("EA Journaling: Trying to close position "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            if(TYPE==OP_BUY)Price=Bid; if(TYPE==OP_SELL)Price=Ask;
            Closing=OrderClose(OrderTicket(),OrderLots(),Price,Slip*K,arrow_color);
            if(Journaling && !Closing)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Closing)Print("EA Journaling: Position successfully closed.");
           }
        }
      else
        {
         bool Delete=false;
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==TYPE)
           {
            if(Journaling)Print("EA Journaling: Trying to delete order "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Delete=OrderDelete(OrderTicket(),CLR_NONE);
            if(Journaling && !Delete)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Delete)Print("EA Journaling: Order successfully deleted.");
           }
        }
     }
   if(CountPosOrders(Magic, TYPE)==0)return(true); else return(false);
  }
//+------------------------------------------------------------------+
//| End of CLOSE/DELETE ORDERS AND POSITIONS 
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| CLOSE/DELETE ORDERS AND POSITIONS
//+------------------------------------------------------------------+
void CloseOrderPositionTimer(int TYPE,bool Journaling,int Magic, int & infoArray [][], int Slip,int K,int Retry_Interval)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function closes all 'expired' positions of type TYPE 


     for(int i=0;i<ArrayRange(infoArray,0);i++)
       {
         
         
         // We check only tickets that have a ticket!
         if((TYPE==OP_BUY || TYPE==OP_SELL) && infoArray[i][0] != 0)
           {
            if(OrderSelect(infoArray[i][0],SELECT_BY_TICKET,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==TYPE)
              {
               //bringing more info from this order to decide if this should be closed
               int CurrOrderHoldTime = int((TimeCurrent() - OrderOpenTime())/60);
                     if(CurrOrderHoldTime >= infoArray[i][1])
                     {
                        bool Closing=false;
                        double Price=0;
                        color arrow_color=0;if(TYPE==OP_BUY)arrow_color=Blue;if(TYPE==OP_SELL)arrow_color=Green;
                        if(Journaling)Print("EA Journaling: Trying to close position "+(string)OrderTicket()+" ...");
                        HandleTradingEnvironment(Journaling,Retry_Interval);
                        if(TYPE==OP_BUY)Price=Bid; if(TYPE==OP_SELL)Price=Ask;
                        Closing=OrderClose(OrderTicket(),OrderLots(),Price,Slip*K,arrow_color);
                        if(Journaling && !Closing)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                        if(Journaling && Closing)Print("EA Journaling: Position successfully closed.");
                     }
              }
           }

     }

  }
//+------------------------------------------------------------------+
//| End of CLOSE/DELETE ORDERS AND POSITIONS 
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| CLOSE/DELETE ORDERS AND POSITIONS
//+------------------------------------------------------------------+
void CloseOrderPositionTimerBars(int TYPE,bool Journaling,int Magic, int BarTimeframeMin, int & infoArray [][], int Slip,int K,int Retry_Interval)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function closes all 'expired' positions of type TYPE 
   int RequiredOrderTimeBars;
   int CurrOrderHoldTimeBars = 0;

     for(int i=0;i<ArrayRange(infoArray,0);i++)
       {
         RequiredOrderTimeBars = infoArray[i][1]/BarTimeframeMin;
         
         // We check only tickets that have a ticket!
         if((TYPE==OP_BUY || TYPE==OP_SELL) && infoArray[i][0] != 0)
           {
            if(OrderSelect(infoArray[i][0],SELECT_BY_TICKET,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==TYPE)
              {
               //bringing more info from this order to decide if this should be closed
               CurrOrderHoldTimeBars = iBarShift(Symbol(), BarTimeframeMin,OrderOpenTime(),true);
                     if(CurrOrderHoldTimeBars >= RequiredOrderTimeBars)
                     {
                        bool Closing=false;
                        double Price=0;
                        color arrow_color=0;if(TYPE==OP_BUY)arrow_color=Blue;if(TYPE==OP_SELL)arrow_color=Green;
                        if(Journaling)Print("EA Journaling: Trying to close position "+(string)OrderTicket()+" ...");
                        HandleTradingEnvironment(Journaling,Retry_Interval);
                        if(TYPE==OP_BUY)Price=Bid; if(TYPE==OP_SELL)Price=Ask;
                        Closing=OrderClose(OrderTicket(),OrderLots(),Price,Slip*K,arrow_color);
                        if(Journaling && !Closing)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                        if(Journaling && Closing)Print("EA Journaling: Position successfully closed.");
                     }
              }
           }

     }

  }
//+------------------------------------------------------------------+
//| End of CLOSE/DELETE ORDERS AND POSITIONS 
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| CLOSE/DELETE ORDERS AND POSITIONS CloseOrderPositionDRL
//+------------------------------------------------------------------+
void CloseOrderPositionDRL(int TYPE,bool Journaling,int Magic, int Slip,int K,int Retry_Interval)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function closes all positions of type TYPE which ticket numbers are listed in the file
/*
Approx Algorithm

- read file for the symbol
- while loop for each line read
- try to select order mentioned in each line
- compare value of the ticket with value in the file
- implement decision - close position if value predict is CLOSE
- close file once everything was read
*/

//begin of fun Restore DSSInfoList
int handle;
int tikt; //reserved for the ticket value in the file
int CurrOrderHoldTime; //order time in minutes
string str;

//Read content of the file, store content into the array 'result[]'
handle=FileOpen("RLUnitOut"+Symbol()+"Exit.csv",FILE_READ|FILE_SHARE_READ);
if(handle==-1){
   Comment("Error - file - File RLUnitOutxxxxxxExit does not exist");
   Sleep(200); //attempt to read again
   handle=FileOpen("RLUnitOut"+Symbol()+"Exit.csv",FILE_READ|FILE_SHARE_READ);
   if(handle == -1){Comment("Tried 2 times, file with log does not exists!"); str = "-1"; }
   } 
if(FileSize(handle)==0){FileClose(handle); Comment("Error - File RLUnitOutxxxxxxExit is empty"); }

       // analyse the content of each string line by line
      while(!FileIsEnding(handle))
      {
            str=FileReadString(handle); //storing content of the current line
            tikt = (int)StringToInteger(str); //convert content of the string to the integer containing ticket number to be closed
            
            // We check only tickets that have a ticket!
         if((TYPE==OP_BUY || TYPE==OP_SELL) && tikt != 0)
           {
            if(OrderSelect(tikt,SELECT_BY_TICKET,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==TYPE)
              {
               //closing this order (however don't close if the time is too short
               CurrOrderHoldTime = int((TimeCurrent() - OrderOpenTime())/60);
               if(CurrOrderHoldTime > 480)
                 {
                  bool Closing=false;
                        double Price=0;
                        color arrow_color=0;if(TYPE==OP_BUY)arrow_color=Blue;if(TYPE==OP_SELL)arrow_color=Green;
                        if(Journaling)Print("EA Journaling: Trying to close position "+(string)OrderTicket()+" ...");
                        HandleTradingEnvironment(Journaling,Retry_Interval);
                        if(TYPE==OP_BUY)Price=Bid; if(TYPE==OP_SELL)Price=Ask;
                        Closing=OrderClose(OrderTicket(),OrderLots(),Price,Slip*K,arrow_color);
                        if(Journaling && !Closing)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                        if(Journaling && Closing)Print("EA Journaling: Position successfully closed.");
                 }
                        
              }
           }
            
            
      }
      FileClose(handle);


  }
//+------------------------------------------------------------------+
//| End of CLOSE/DELETE ORDERS AND POSITIONS CloseOrderPositionDRL
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Check for 4/5 Digits Broker              
//+------------------------------------------------------------------+ 
int GetP() 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function returns P, which is used for converting pips to decimals/points

   int output;
   if(Digits==5 || Digits==3) output=10;else output=1;
   return(output);

/* Some definitions: Pips vs Point

1 pip = 0.0001 on a 4 digit broker and 0.00010 on a 5 digit broker
1 point = 0.0001 on 4 digit broker and 0.00001 on a 5 digit broker
  
*/

  }
//+------------------------------------------------------------------+
//| End of Check for 4/5 Digits Broker               
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Yen Adjustment Factor             
//+------------------------------------------------------------------+ 
int GetYenAdjustFactor() 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function returns a constant factor, which is used for position sizing for Yen pairs

   int output= 1;
   if(Digits == 3|| Digits == 2) output = 100;
   return(output);
  }
//+------------------------------------------------------------------+
//| End of Yen Adjustment Factor             
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Volatility-Based Stop Loss                                             
//+------------------------------------------------------------------+
double VolBasedStopLoss(bool isVolatilitySwitchOn,double fixedStop,double VolATR,double volMultiplier,int K)
  { // K represents our P multiplier to adjust for broker digits
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function calculates stop loss amount based on volatility

   double StopL;
   if(!isVolatilitySwitchOn)
     {
      StopL=fixedStop; // If Volatility Stop Loss not activated. Stop Loss = Fixed Pips Stop Loss
        } else {
      StopL=volMultiplier*VolATR/(K*Point); // Stop Loss in Pips
     }
   return(StopL);
  }
//+------------------------------------------------------------------+
//| End of Volatility-Based Stop Loss                  
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Volatility-Based Take Profit                                     
//+------------------------------------------------------------------+

double VolBasedTakeProfit(bool isVolatilitySwitchOn,double fixedTP,double VolATR,double volMultiplier,int K)
  { // K represents our P multiplier to adjust for broker digits
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function calculates take profit amount based on volatility

   double TakeP;
   if(!isVolatilitySwitchOn)
     {
      TakeP=fixedTP; // If Volatility Take Profit not activated. Take Profit = Fixed Pips Take Profit
        } else {
      TakeP=volMultiplier*VolATR/(K*Point); // Take Profit in Pips
     }
   return(TakeP);
  }
//+------------------------------------------------------------------+
//| End of Volatility-Based Take Profit                 
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
// Cross1                                                             
//+------------------------------------------------------------------+

// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function determines if a cross happened between 2 lines/data set

/* 

If Output is 0: No cross happened
If Output is 1: Line 1 crossed Line 2 from Bottom
If Output is 2: Line 1 crossed Line 2 from top 

*/

int Crossed1(double line1,double line2)
  {

   static int CurrentDirection1=0;
   static int LastDirection1=0;
   static bool FirstTime1=true;

//----
   if(line1>line2)
      CurrentDirection1=1;  // line1 above line2
   if(line1<line2)
      CurrentDirection1=2;  // line1 below line2
//----
   if(FirstTime1==true) // Need to check if this is the first time the function is run
     {
      FirstTime1=false; // Change variable to false
      LastDirection1=CurrentDirection1; // Set new direction
      return (0);
     }

   if(CurrentDirection1!=LastDirection1 && FirstTime1==false) // If not the first time and there is a direction change
     {
      LastDirection1=CurrentDirection1; // Set new direction
      return(CurrentDirection1); // 1 for up, 2 for down
     }
   else
     {
      return(0);  // No direction change
     }
  }
//+------------------------------------------------------------------+
// End of Cross                                                      
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
// Cross2                                                             
//+------------------------------------------------------------------+

// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function determines if a cross happened between 2 lines/data set

/* 

If Output is 0: No cross happened
If Output is 1: Line 1 crossed Line 2 from Bottom
If Output is 2: Line 1 crossed Line 2 from top 

*/

int Crossed2(double line1,double line2)
  {

   static int CurrentDirection1=0;
   static int LastDirection1=0;
   static bool FirstTime1=true;

//----
   if(line1>line2)
      CurrentDirection1=1;  // line1 above line2
   if(line1<line2)
      CurrentDirection1=2;  // line1 below line2
//----
   if(FirstTime1==true) // Need to check if this is the first time the function is run
     {
      FirstTime1=false; // Change variable to false
      LastDirection1=CurrentDirection1; // Set new direction
      return (0); // there is no cross happened
     }

   if(CurrentDirection1!=LastDirection1 && FirstTime1==false) // If not the first time and there is a direction change
     {
      LastDirection1=CurrentDirection1; // Set new direction
      return(CurrentDirection1); // 1 for up, 2 for down
     }
   else
     {
      return(0);  // No direction change
     }
  }
//+------------------------------------------------------------------+
// End of Cross                                                      
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
// Cross3                                                          
//+------------------------------------------------------------------+

// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function determines if a cross happened between 2 lines/data set

/* 

If Output is 0: No cross happened
If Output is 1: Line 1 crossed Line 2 from Bottom
If Output is 2: Line 1 crossed Line 2 from top 

*/

int Crossed3(double line1,double line2)
  {

   static int CurrentDirection1=0;
   static int LastDirection1=0;
   static bool FirstTime1=true;

//----
   if(line1>line2)
      CurrentDirection1=1;  // line1 above line2
   if(line1<line2)
      CurrentDirection1=2;  // line1 below line2
//----
   if(FirstTime1==true) // Need to check if this is the first time the function is run
     {
      FirstTime1=false; // Change variable to false
      LastDirection1=CurrentDirection1; // Set new direction
      return (0);
     }

   if(CurrentDirection1!=LastDirection1 && FirstTime1==false) // If not the first time and there is a direction change
     {
      LastDirection1=CurrentDirection1; // Set new direction
      return(CurrentDirection1); // 1 for up, 2 for down
     }
   else
     {
      return(0);  // No direction change
     }
  }
//+------------------------------------------------------------------+
// End of Cross                                                      
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Is Loss Limit Breached                                       
//+------------------------------------------------------------------+
bool IsLossLimitBreached(bool LossLimitActivated,double LossLimitPercentage,bool Journaling,int EntrySignalTrigger)
  {

// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function determines if our maximum loss threshold is breached

   static bool firstTick=False;
   static double initialCapital=0;
   double profitAndLoss=0;
   double profitAndLossPrint=0;
   bool output=False;

   if(LossLimitActivated==False) return(output);

   if(firstTick==False)
     {
      initialCapital=AccountEquity();
      firstTick=True;
     }

   profitAndLoss=(AccountEquity()/initialCapital)-1;

   if(profitAndLoss<-LossLimitPercentage/100)
     {
      output=True;
      profitAndLossPrint=NormalizeDouble(profitAndLoss,4)*100;
      if(Journaling)if(EntrySignalTrigger!=0) Print("Entry trade triggered but not executed. Loss threshold breached. Current Loss: "+(string)profitAndLossPrint+"%");
     }

   return(output);
  }
//+------------------------------------------------------------------+
//| End of Is Loss Limit Breached                                     
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Is Volatility Limit Breached                                       
//+------------------------------------------------------------------+
bool IsVolLimitBreached(bool VolLimitActivated,double VolMulti,int ATR_Timeframe, int ATR_per)
  {

// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function determines if our maximum volatility threshold is breached

// 2 steps to this function: 
// 1) It checks the price movement between current time and the closing price of the last completed 1min bar (shift 1 of 1min timeframe).
// 2) Return True if this price movement > VolLimitMulti * VolATR

   bool output = False;
   if(VolLimitActivated==False) return(output);
   
   double priceMovement = MathAbs(Bid-iClose(NULL,PERIOD_M1,1)); // Not much difference if we use bid or ask prices here. We can also use iOpen at shift 0 here, it will be similar to using iClose at shift 1.
   double VolATR = iATR(NULL, ATR_Timeframe, ATR_per, 1);
   
   if(priceMovement > VolMulti*VolATR) output = True;

   return(output);
  }
//+------------------------------------------------------------------+
//| End of Is Volatility Limit Breached                                         
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Set Hidden Stop Loss                                     
//+------------------------------------------------------------------+

void SetStopLossHidden(bool Journaling,bool isVolatilitySwitchOn,double fixedSL,double VolATR,double volMultiplier,int K,int OrderNum, int & HiddenSLListArray [][])
  { // K represents our P multiplier to adjust for broker digits
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function calculates hidden stop loss amount and tags it to the appropriate order using an array

   double StopL;

   if(!isVolatilitySwitchOn)
     {
      StopL=fixedSL; // If Volatility Stop Loss not activated. Stop Loss = Fixed Pips Stop Loss
        } else {
      StopL=volMultiplier*VolATR/(K*Point); // Stop Loss in Pips
     }

   for(int x=0; x<ArrayRange(HiddenSLListArray,0); x++) 
     { // Number of elements in column 1
      if(HiddenSLListArray[x,0]==0) 
        { // Checks if the element is empty
         HiddenSLListArray[x,0] = OrderNum;
         HiddenSLListArray[x,1] = (int)StopL;
         if(Journaling)Print("EA Journaling: Order "+(string)HiddenSLListArray[x,0]+" assigned with a hidden SL of "+(string)NormalizeDouble(HiddenSLListArray[x,1],2)+" pips.");
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Set Hidden Stop Loss                   
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Trigger Hidden Stop Loss                                      
//+------------------------------------------------------------------+
void TriggerStopLossHidden(bool Journaling,int Retry_Interval,int Magic,int Slip,int K, int & HiddenSLListArray [][]) 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

/* This function does two 2 things:
1) Clears appropriate elements of your HiddenSLList if positions has been closed
2) Closes positions based on its hidden stop loss levels
*/

   int ordersPos=OrdersTotal();
   int orderTicketNumber;
   double orderSL;
   int doesOrderExist;

// 1) Check the HiddenSLList, match with current list of positions. Make sure the all the positions exists. 
// If it doesn't, it means there are positions that have been closed

   for(int x=0; x<ArrayRange(HiddenSLListArray,0); x++) 
     { // Looping through all order number in list

      doesOrderExist=False;
      orderTicketNumber=(int)HiddenSLListArray[x,0];

      if(orderTicketNumber!=0) 
        { // Order exists
         for(int y=ordersPos-1; y>=0; y--) 
           { // Looping through all current open positions
            if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
              {
               if(orderTicketNumber==OrderTicket()) 
                 { // Checks order number in list against order number of current positions
                  doesOrderExist=True;
                  break;
                 }
              }
           }

         if(doesOrderExist==False) 
           { // Deletes elements if the order number does not match any current positions
            HiddenSLListArray[x, 0] = 0;
            HiddenSLListArray[x, 1] = 0;
           }
        }

     }

// 2) Check each position against its hidden SL and close the position if hidden SL is hit

   for(int z=0; z<ArrayRange(HiddenSLListArray,0); z++) 
     { // Loops through elements in the list

      orderTicketNumber=(int)HiddenSLListArray[z,0]; // Records order numner
      orderSL=HiddenSLListArray[z,1]; // Records SL

      if(OrderSelect(orderTicketNumber,SELECT_BY_TICKET)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
        {
         bool Closing=false;
         if(OrderType()==OP_BUY && OrderOpenPrice() -(orderSL*K*Point)>=Bid) 
           { // Checks SL condition for closing long orders

            if(Journaling)Print("EA Journaling: Trying to close position "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Closing=OrderClose(OrderTicket(),OrderLots(),Bid,Slip*K,Blue);
            if(Journaling && !Closing)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Closing)Print("EA Journaling: Position successfully closed.");

           }
         if(OrderType()==OP_SELL && OrderOpenPrice()+(orderSL*K*Point)<=Ask) 
           { // Checks SL condition for closing short orders

            if(Journaling)Print("EA Journaling: Trying to close position "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Closing=OrderClose(OrderTicket(),OrderLots(),Ask,Slip*K,Red);
            if(Journaling && !Closing)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Closing)Print("EA Journaling: Position successfully closed.");

           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Trigger Hidden Stop Loss                                          
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Set Hidden Take Profit                                     
//+------------------------------------------------------------------+

void SetTakeProfitHidden(bool Journaling,bool isVolatilitySwitchOn,double fixedTP,double VolATR,double volMultiplier,int K,int OrderNum, int & HiddenTPListArray [][])
  { // K represents our P multiplier to adjust for broker digits
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function calculates hidden take profit amount and tags it to the appropriate order using an array

   double TakeP;

   if(!isVolatilitySwitchOn)
     {
      TakeP=fixedTP; // If Volatility Take Profit not activated. Take Profit = Fixed Pips Take Profit
        } else {
      TakeP=volMultiplier*VolATR/(K*Point); // Take Profit in Pips
     }

   for(int x=0; x<ArrayRange(HiddenTPListArray,0); x++) 
     { // Number of elements in column 1
      if(HiddenTPListArray[x,0]==0) 
        { // Checks if the element is empty
         HiddenTPListArray[x,0] = OrderNum;
         HiddenTPListArray[x,1] = (int)TakeP;
         if(Journaling)Print("EA Journaling: Order "+(string)HiddenTPListArray[x,0]+" assigned with a hidden TP of "+(string)NormalizeDouble(HiddenTPListArray[x,1],2)+" pips.");
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Set Hidden Take Profit                  
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Trigger Hidden Take Profit                                        
//+------------------------------------------------------------------+
void TriggerTakeProfitHidden(bool Journaling,int Retry_Interval,int Magic,int Slip,int K, int & HiddenTPListArray [][]) 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

/* This function does two 2 things:
1) Clears appropriate elements of your HiddenTPList if positions has been closed
2) Closes positions based on its hidden take profit levels
*/

   int ordersPos=OrdersTotal();
   int orderTicketNumber;
   double orderTP;
   int doesOrderExist;

// 1) Check the HiddenTPList, match with current list of positions. Make sure the all the positions exists. 
// If it doesn't, it means there are positions that have been closed

   for(int x=0; x<ArrayRange(HiddenTPListArray,0); x++) 
     { // Looping through all order number in list

      doesOrderExist=False;
      orderTicketNumber=(int)HiddenTPListArray[x,0];

      if(orderTicketNumber!=0) 
        { // Order exists
         for(int y=ordersPos-1; y>=0; y--) 
           { // Looping through all current open positions
            if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
              {
               if(orderTicketNumber==OrderTicket()) 
                 { // Checks order number in list against order number of current positions
                  doesOrderExist=True;
                  break;
                 }
              }
           }

         if(doesOrderExist==False) 
           { // Deletes elements if the order number does not match any current positions
            HiddenTPListArray[x, 0] = 0;
            HiddenTPListArray[x, 1] = 0;
           }
        }

     }

// 2) Check each position against its hidden TP and close the position if hidden TP is hit

   for(int z=0; z<ArrayRange(HiddenTPListArray,0); z++) 
     { // Loops through elements in the list

      orderTicketNumber=(int)HiddenTPListArray[z,0]; // Records order numner
      orderTP=HiddenTPListArray[z,1]; // Records TP

      if(OrderSelect(orderTicketNumber,SELECT_BY_TICKET)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
        {
         bool Closing=false;
         if(OrderType()==OP_BUY && OrderOpenPrice()+(orderTP*K*Point)<=Bid) 
           { // Checks TP condition for closing long orders

            if(Journaling)Print("EA Journaling: Trying to close position "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Closing=OrderClose(OrderTicket(),OrderLots(),Bid,Slip*K,Blue);
            if(Journaling && !Closing)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Closing)Print("EA Journaling: Position successfully closed.");

           }
         if(OrderType()==OP_SELL && OrderOpenPrice() -(orderTP*K*Point)>=Ask) 
           { // Checks TP condition for closing short orders 

            if(Journaling)Print("EA Journaling: Trying to close position "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Closing=OrderClose(OrderTicket(),OrderLots(),Ask,Slip*K,Red);
            if(Journaling && !Closing)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Closing)Print("EA Journaling: Position successfully closed.");

           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Trigger Hidden Take Profit                                       
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Breakeven Stop
//+------------------------------------------------------------------+
void BreakevenStopAll(bool Journaling,int Retry_Interval,double Breakeven_Buffer,int Magic,int K)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function sets breakeven stops for all positions

   double SecureProfitPips = Breakeven_Buffer/3; //using 1/3 of Breakeven buffer to secure min profit on that trade

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      bool Modify=false;
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
        {
         RefreshRates();
         if(OrderType()==OP_BUY && (Bid-OrderOpenPrice())>((Breakeven_Buffer+SecureProfitPips)*K*Point))
           {
               if(OrderOpenPrice() > OrderStopLoss()) //Only modify the order once!
                 {
                  if(Journaling)Print("EA Journaling: Trying to modify Buy order "+(string)OrderTicket()+" ...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Modify=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+(SecureProfitPips*K*Point),OrderTakeProfit(),0,CLR_NONE);
                  if(Journaling && !Modify)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Modify)Print("EA Journaling: Order successfully modified, breakeven stop updated.");
                 }
           }
         if(OrderType()==OP_SELL && (OrderOpenPrice()-Ask)>((Breakeven_Buffer-SecureProfitPips)*K*Point))
           {
                if(OrderOpenPrice() < OrderStopLoss())
                 {  
                  if(Journaling)Print("EA Journaling: Trying to modify Sell order "+(string)OrderTicket()+" ...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Modify=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-(SecureProfitPips*K*Point),OrderTakeProfit(),0,CLR_NONE);
                  if(Journaling && !Modify)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Modify)Print("EA Journaling: Order successfully modified, breakeven stop updated.");
                 } 
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Breakeven Stop
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Update Hidden Breakeven Stops List                                     
//+------------------------------------------------------------------+

void UpdateHiddenBEList(bool Journaling,int Retry_Interval,int Magic, int & HiddenBEListArray []) 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function clears the elements of your HiddenBEList if the corresponding positions has been closed

   int ordersPos=OrdersTotal();
   int orderTicketNumber;
   bool doesPosExist;

// Check the HiddenBEList, match with current list of positions. Make sure the all the positions exists. 
// If it doesn't, it means there are positions that have been closed

   for(int x=0; x<ArrayRange(HiddenBEListArray,0); x++)
     { // Looping through all order number in list

      doesPosExist=False;
      orderTicketNumber=(int)HiddenBEListArray[x];

      if(orderTicketNumber!=0)
        { // Order exists
         for(int y=ordersPos-1; y>=0; y--)
           { // Looping through all current open positions
            if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
              {
               if(orderTicketNumber==OrderTicket())
                 { // Checks order number in list against order number of current positions
                  doesPosExist=True;
                  break;
                 }
              }
           }

         if(doesPosExist==False)
           { // Deletes elements if the order number does not match any current positions
            HiddenBEListArray[x]=0;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Update Hidden Breakeven Stops List                                         
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Set and Trigger Hidden Breakeven Stops                                  
//+------------------------------------------------------------------+

void SetAndTriggerBEHidden(bool Journaling,double Breakeven_Buffer,int Magic,int Slip,int K,int Retry_Interval, int & HiddenBEListArray [])
  { // K represents our P multiplier to adjust for broker digits
// Type: Fixed Template 
// Do not edit unless you know what you're doing

/* 
This function scans through the current positions and does 2 things:
1) If the position is in the hidden breakeven list, it closes it if the appropriate conditions are met
2) If the positon is not the hidden breakeven list, it adds it to the list if the appropriate conditions are met
*/

   bool isOrderInBEList=False;
   int orderTicketNumber;

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      bool Modify=false;
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
        { // Loop through list of current positions
         RefreshRates();
         orderTicketNumber=OrderTicket();
         for(int x=0; x<ArrayRange(HiddenBEListArray,0); x++)
           { // Loops through hidden BE list
            if(orderTicketNumber==HiddenBEListArray[x])
              { // Checks if the current position is in the list 
               isOrderInBEList=True;
               break;
              }
           }
         if(isOrderInBEList==True)
           { // If current position is in the list, close it if hidden breakeven stop is breached
            bool Closing=false;
            if(OrderType()==OP_BUY && OrderOpenPrice()>=Bid) 
              { // Checks BE condition for closing long orders    
               if(Journaling)Print("EA Journaling: Trying to close position "+(string)OrderTicket()+" using hidden breakeven stop...");
               HandleTradingEnvironment(Journaling,Retry_Interval);
               Closing=OrderClose(OrderTicket(),OrderLots(),Bid,Slip*K,Blue);
               if(Journaling && !Closing)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
               if(Journaling && Closing)Print("EA Journaling: Position successfully closed due to hidden breakeven stop.");
              }
            if(OrderType()==OP_SELL && OrderOpenPrice()<=Ask) 
              { // Checks BE condition for closing short orders
               if(Journaling)Print("EA Journaling: Trying to close position "+(string)OrderTicket()+" using hidden breakeven stop...");
               HandleTradingEnvironment(Journaling,Retry_Interval);
               Closing=OrderClose(OrderTicket(),OrderLots(),Ask,Slip*K,Red);
               if(Journaling && !Closing)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
               if(Journaling && Closing)Print("EA Journaling: Position successfully closed due to hidden breakeven stop.");
              }
              } else { // If current position is not in the hidden BE list. We check if we need to add this position to the hidden BE list.
            if((OrderType()==OP_BUY && (Bid-OrderOpenPrice())>(Breakeven_Buffer*K*Point)) || (OrderType()==OP_SELL && (OrderOpenPrice()-Ask)>(Breakeven_Buffer*K*Point)))
              {
               for(int y=0; y<ArrayRange(HiddenBEListArray,0); y++)
                 { // Loop through of elements in column 1
                  if(HiddenBEListArray[y]==0)
                    { // Checks if the element is empty
                     HiddenBEListArray[y]= orderTicketNumber;
                     if(Journaling)Print("EA Journaling: Order "+(string)HiddenBEListArray[y]+" assigned with a hidden breakeven stop.");
                     break;
                    }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Set and Trigger Hidden Breakeven Stops                      
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Trailing Stop
//+------------------------------------------------------------------+

void TrailingStopAll(bool Journaling,double TrailingStopDist,double TrailingStopBuff,int Retry_Interval,int Magic,int K)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 
/*
@descr Function is waiting until distance from act.price <> stop loss is greater than TrailingStopDist +  TrailingStopBuff
       Once this is true, then new stop loss will be maintained to be Bid-TrailingStopDist

@param TrailingStopDist - distance 

*/


// This function sets trailing stops for all positions

   for(int i=OrdersTotal()-1; i>=0; i--) // Looping through all orders
     {
      bool Modify=false;
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
        {
         RefreshRates();
         if(OrderType()==OP_BUY && (Bid-OrderStopLoss()>(TrailingStopDist+TrailingStopBuff)*K*Point))
           {
            if(Journaling)Print("EA Journaling: Trying to modify order "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TrailingStopDist*K*Point,OrderTakeProfit(),0,CLR_NONE);
            if(Journaling && !Modify)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Modify)Print("EA Journaling: Order successfully modified, trailing stop changed.");
           }
         if(OrderType()==OP_SELL && ((OrderStopLoss()-Ask>((TrailingStopDist+TrailingStopBuff)*K*Point)) || (OrderStopLoss()==0)))
           {
            if(Journaling)Print("EA Journaling: Trying to modify order "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Ask+TrailingStopDist*K*Point,OrderTakeProfit(),0,CLR_NONE);
            if(Journaling && !Modify)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Modify)Print("EA Journaling: Order successfully modified, trailing stop changed.");
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End Trailing Stop
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Update Hidden Trailing Stops List                                     
//+------------------------------------------------------------------+

void UpdateHiddenTrailingList(bool Journaling,int Retry_Interval,int Magic, int & HiddenTrailingListArray [][]) 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function clears the elements of your HiddenTrailingList if the corresponding positions has been closed

   int ordersPos=OrdersTotal();
   int orderTicketNumber;
   bool doesPosExist;

// Check the HiddenTrailingList, match with current list of positions. Make sure the all the positions exists. 
// If it doesn't, it means there are positions that have been closed

   for(int x=0; x<ArrayRange(HiddenTrailingListArray,0); x++)
     { // Looping through all order number in list

      doesPosExist=False;
      orderTicketNumber=(int)HiddenTrailingListArray[x,0];

      if(orderTicketNumber!=0)
        { // Order exists
         for(int y=ordersPos-1; y>=0; y--)
           { // Looping through all current open positions
            if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
              {
               if(orderTicketNumber==OrderTicket())
                 { // Checks order number in list against order number of current positions
                  doesPosExist=True;
                  break;
                 }
              }
           }

         if(doesPosExist==False)
           { // Deletes elements if the order number does not match any current positions
            HiddenTrailingListArray[x,0] = 0;
            HiddenTrailingListArray[x,1] = 0;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Update Hidden Trailing Stops List                                       
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Set and Trigger Hidden Trailing Stop
//+------------------------------------------------------------------+

void SetAndTriggerHiddenTrailing(bool Journaling,double TrailingStopDist,double TrailingStopBuff,int Slip,int Retry_Interval,int Magic,int K, int & HiddenTrailingListArray [][])
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function does 2 things. 1) It sets hidden trailing stops for all positions 2) It closes the positions if hidden trailing stops levels are breached

   bool doesHiddenTrailingRecordExist;
   int posTicketNumber;

   for(int i=OrdersTotal()-1; i>=0; i--) 
     { // Looping through all orders

      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
        {

         doesHiddenTrailingRecordExist=False;
         posTicketNumber=OrderTicket();

         // Step 1: Check if there is any hidden trailing stop records pertaining to this order. If yes, check if we need to close the order.

         for(int x=0; x<ArrayRange(HiddenTrailingListArray,0); x++) 
           { // Looping through all order number in list 

            if(posTicketNumber==HiddenTrailingListArray[x,0]) 
              { // If condition holds, it means the position have a hidden trailing stop level attached to it

               doesHiddenTrailingRecordExist=True;
               bool Closing=false;
               RefreshRates();

               if(OrderType()==OP_BUY && HiddenTrailingListArray[x,1]>=Bid) 
                 {

                  if(Journaling)Print("EA Journaling: Trying to close position "+(string)OrderTicket()+" using hidden trailing stop...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Closing=OrderClose(OrderTicket(),OrderLots(),Bid,Slip*K,Blue);
                  if(Journaling && !Closing)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Closing)Print("EA Journaling: Position successfully closed due to hidden trailing stop.");

                    } else if(OrderType()==OP_SELL && HiddenTrailingListArray[x,1]<=Ask) {

                  if(Journaling)Print("EA Journaling: Trying to close position "+(string)OrderTicket()+" using hidden trailing stop...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Closing=OrderClose(OrderTicket(),OrderLots(),Ask,Slip*K,Red);
                  if(Journaling && !Closing)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Closing)Print("EA Journaling: Position successfully closed due to hidden trailing stop.");

                    }  else {

                  // Step 2: If there are hidden trailing stop records and the position was not closed in Step 1. We update the hidden trailing stop record.

                  if(OrderType()==OP_BUY && (Bid-HiddenTrailingListArray[x,1]>(TrailingStopDist+TrailingStopBuff)*K*Point)) 
                    {
                     HiddenTrailingListArray[x,1]=(int)(Bid-TrailingStopDist*K*Point); // Assigns new hidden trailing stop level
                     if(Journaling)Print("EA Journaling: Order "+(string)posTicketNumber+" successfully modified, hidden trailing stop updated to "+(string)NormalizeDouble(HiddenTrailingListArray[x,1],Digits)+".");
                    }
                  if(OrderType()==OP_SELL && (HiddenTrailingListArray[x,1]-Ask>((TrailingStopDist+TrailingStopBuff)*K*Point))) 
                    {
                     HiddenTrailingListArray[x,1]=(int)(Ask+TrailingStopDist*K*Point); // Assigns new hidden trailing stop level
                     if(Journaling)Print("EA Journaling: Order "+(string)posTicketNumber+" successfully modified, hidden trailing stop updated "+(string)NormalizeDouble(HiddenTrailingListArray[x,1],Digits)+".");
                    }
                 }
               break;
              }
           }

         // Step 3: If there are no hidden trailing stop records, add new record.

         if(doesHiddenTrailingRecordExist==False) 
           {

            for(int y=0; y<ArrayRange(HiddenTrailingListArray,0); y++) 
              { // Looping through list 

               if(HiddenTrailingListArray[y,0]==0) 
                 { // Slot is empty

                  RefreshRates();
                  HiddenTrailingListArray[y,0]=posTicketNumber; // Assigns Order Number
                  if(OrderType()==OP_BUY) 
                    {
                     HiddenTrailingListArray[y,1]=(int)(MathMax(Bid,OrderOpenPrice())-TrailingStopDist*K*Point); // Hidden trailing stop level = Higher of Bid or OrderOpenPrice - Trailing Stop Distance
                     if(Journaling)Print("EA Journaling: Order "+(string)posTicketNumber+" successfully modified, hidden trailing stop added. Trailing Stop = "+(string)NormalizeDouble(HiddenTrailingListArray[y,1],Digits)+".");
                    }
                  if(OrderType()==OP_SELL) 
                    {
                     HiddenTrailingListArray[y,1]=(int)(MathMin(Ask,OrderOpenPrice())+TrailingStopDist*K*Point); // Hidden trailing stop level = Lower of Ask or OrderOpenPrice + Trailing Stop Distance
                     if(Journaling)Print("EA Journaling: Order "+(string)posTicketNumber+" successfully modified, hidden trailing stop added. Trailing Stop = "+(string)NormalizeDouble(HiddenTrailingListArray[y,1],Digits)+".");
                    }
                  break;
                 }
              }
           }

        }
     }
  }
//+------------------------------------------------------------------+
//| End of Set and Trigger Hidden Trailing Stop
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Update Volatility Trailing Stops List                                     
//+------------------------------------------------------------------+

void UpdateVolTrailingList(bool Journaling,int Retry_Interval,int Magic, int & VolTrailingListArray [][]) 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function clears the elements of your VolTrailingList if the corresponding positions has been closed

   int ordersPos=OrdersTotal();
   int orderTicketNumber;
   bool doesPosExist;

// Check the VolTrailingList, match with current list of positions. Make sure the all the positions exists. 
// If it doesn't, it means there are positions that have been closed

   for(int x=0; x<ArrayRange(VolTrailingListArray,0); x++)
     { // Looping through all order number in list

      doesPosExist=False;
      orderTicketNumber=(int)VolTrailingListArray[x,0];

      if(orderTicketNumber!=0)
        { // Order exists
         for(int y=ordersPos-1; y>=0; y--)
           { // Looping through all current open positions
            if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
              {
               if(orderTicketNumber==OrderTicket())
                 { // Checks order number in list against order number of current positions
                  doesPosExist=True;
                  break;
                 }
              }
           }

         if(doesPosExist==False)
           { // Deletes elements if the order number does not match any current positions
            VolTrailingListArray[x,0] = 0;
            VolTrailingListArray[x,1] = 0;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Update Volatility Trailing Stops List                                          
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Update DSS Info List                                     
//+------------------------------------------------------------------+

void UpdateDSSInfoList(bool Journaling,int Retry_Interval,int Magic, int & infoArray [][]) 
  {
// This function clears the elements of our DSSInfoList if the corresponding positions have been closed

   //int ordersPos=OrdersTotal();
   int orderTicketNumber;

// Check the DSSInfoList, match with current list of closed positions.
// If there is a match then array element is set to 0

   for(int x=0; x<ArrayRange(infoArray,0); x++)
     { // Looping through all order number in list

      orderTicketNumber=infoArray[x,0];
      

      if(orderTicketNumber!=0)
        { // Ticket exists inside array
         
           if(OrderSelect(orderTicketNumber,SELECT_BY_TICKET,MODE_HISTORY)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic &&
                                            OrderCloseTime() > 0)
              {
               if(Journaling)Print("EA Journaling: For Magic Number... " + (string)Magic + " and the Order "+(string)infoArray[x,0]+
                             " corresponding order was closed. The element "+(string)x+" of array will be set to zero");
               //clear up elements of that array
               infoArray[x,0] = 0;
               infoArray[x,1] = 0;
               infoArray[x,2] = 0;
               //show error if array was not cleared
               if(infoArray[x,0] != 0)
                {
                 if(Journaling)Print("EA Journaling: Error, array element " + (string)x + " was not cleared!" + 
                                     " the value is " + (string)infoArray[x,0]);
                }   
              }
           
              
        }
  
     }
     
  }
//+------------------------------------------------------------------+
//| End of Update DSS Info List                                           
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Set DSSInfoList
//+------------------------------------------------------------------+

void SetDSSInfoList(bool Journaling, int MyTimeHold, int MyMT, int tkt, int Magic, int & infoArray [][])
  {
// Type: Fixed Template 

//SetDSSInfoList(OnJournaling,AItimehold,MyMarketType, OrderNumber, MagicNumber);
if(tkt > 0)
  {
   
// This function adds new elements into array:
// Ticket, Time to hold order, market type records

   for(int x=0; x<ArraySize(infoArray); x++) // Loop through elements in DSSInfoList
     { 
      if(infoArray[x,0]==0)  // Checks if the element is empty
        { 
         infoArray[x,0] = tkt; // Add order number
         infoArray[x,1] = MyTimeHold; // Add Time to hold the order in Hours 
         infoArray[x,2] = MyMT; // Add predicted Market Type
         if(Journaling)Print("EA Journaling: For Magic Number... " + (string)Magic + " and the Order "+(string)infoArray[x,0]+
                             " we assign a Time to hold the order in Minutes "+(string)infoArray[x,1]+";"+" predicted MarketType is: "+(string)infoArray[x,2]);
         break;
        } else
            {
             if(Journaling)Print("EA Journaling: Array element: " + (string)x +" was not empty... " + 
                                 " we will check another element... ");
            }
     }
    
  } 
  }
//+------------------------------------------------------------------+
//| End of Set DSSInfoList
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Restore DSSInfoList
//+------------------------------------------------------------------+

void RestoreDSSInfoList(bool Journaling, string symbol, int magic, int & infoArray [][])
  {
/* 
@purpose: Function is needed to restore position of DSSInfoList Arrays in case of abrupt EA closure. In cases when there will be some open orders we will 
want to restore this array using information from the flat file

@description Need to:
- read file and read content: ticket and other info
- read open orders and retrieve their tickets, filter by magic number and symbol
- compare: if ticket number match is found then populate the array 

@detail: a very complicated function containing several for-loops

*/
int handle;
string str;
string sep=",";              // A separator as a character 
ushort u_sep;                // The code of the separator character 
string result[];             // An array to get string elements
string full_line;            // String reserved for a file string

//Read content of the file, store content into the array 'result[]'
handle=FileOpen("MarketTypeLog"+IntegerToString(magic)+".csv",FILE_READ|FILE_SHARE_READ);
if(handle==-1){
   Comment("Error - file MarketTypeLog does not exist");
   Sleep(200); //attempt to read again
   handle=FileOpen("MarketTypeLog"+IntegerToString(magic)+".csv",FILE_READ|FILE_SHARE_READ);
   if(handle == -1){Comment("Tried 2 times, file MarketTypeLog with log does not exists!"); str = "-1"; }
   } 
if(FileSize(handle)==0){FileClose(handle); Comment("Error - File MarketTypeLog is empty"); }

       // analyse the content of each string line by line
      while(!FileIsEnding(handle))
      {
            str=FileReadString(handle); //storing content of the current line
            //full current line
            full_line = StringSubstr(str,0);
            //--- Get the separator code 
            u_sep=StringGetCharacter(sep,0); 
            //--- Split the string to substrings and store to the array result[] 
            int k = StringSplit(str,u_sep,result); 
            // array result will contain only 1 line, we must perform data manipulation for each line and only then to close file
               //Go trough all open orders, filter and get the ticket number
                for(int i=OrdersTotal()-1; i>=0; i--) 
                 {
                  if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES)==true && OrderSymbol() == symbol && OrderMagicNumber() == magic)
                    {
                     //extract ticket number
                     int tkt = OrderTicket();
                     //create another for loop to scroll through the content of the array result
                     for(int y=0;y<ArraySize(result);y++)
                       {
                        //check if array result contains tkt
                        if(StringToInteger(result[y])== tkt) //this is a condition to restore the array! --> open position and log file...
                          {
                           //find if element of array equals to 0 (free to use)
                           for(int j=0;j<ArrayRange(infoArray,0);j++)
                             {
                              if(infoArray[j,0] == 0 && infoArray[j,1] == 0 && infoArray[j,2] == 0)
                                {
                                 //store this ticket in array
                                 infoArray[j,0] = tkt;
                                 //store next element (time to hold) in the same array
                                 infoArray[j,1] = (int)StringToInteger(result[y+2]);
                                 //store next element (market type) in the same array
                                 infoArray[j,2] = (int)StringToInteger(result[y+1]);
                                 if(Journaling)Print("EA Journaling: Restoring array DSS Info List. For Magic Number... " + 
                                    (string)magic + " and the Order "+(string)tkt+
                                    " we are updating those values into array! "+(string)j+
                                    ";"+" The array ticket element now contains value: "+(string)infoArray[j,0]);
                                 break; //exit this for loop as we have already populated free element of array
                                }
                             } //end of for loop to scroll through DSSListArray
                          }
                       } //end of for loop to scroll through array result
                    }
                 } //end of for loop to scroll through order position
            
            
            
      }
      FileClose(handle);




  }
//+------------------------------------------------------------------+
//| End of Restore DSSInfoList
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Set Volatility Trailing Stop
//+------------------------------------------------------------------+

void SetVolTrailingStop(bool Journaling,int Retry_Interval,double VolATR,double VolTrailingDistMulti,int Magic,int K,int OrderNum, int & VolTrailingListArray [][])
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function adds new volatility trailing stop level using OrderModify()

   double VolTrailingStopDist;
   bool Modify=False;
   bool IsVolTrailingStopAdded=False;
   
   VolTrailingStopDist=VolTrailingDistMulti*VolATR/(K*Point); // Volatility trailing stop amount in Pips

   if(OrderSelect(OrderNum,SELECT_BY_TICKET)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
     {
      RefreshRates();
      if(OrderType()==OP_BUY)
        {
         if(Journaling)Print("EA Journaling: Trying to modify order "+(string)OrderTicket()+" ...");
         HandleTradingEnvironment(Journaling,Retry_Interval);
         Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Bid-VolTrailingStopDist*K*Point,OrderTakeProfit(),0,CLR_NONE);
         IsVolTrailingStopAdded=True;   
         if(Journaling && !Modify)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
         if(Journaling && Modify)Print("EA Journaling: Order successfully modified, volatility trailing stop changed.");
        }
      if(OrderType()==OP_SELL)
        {
         if(Journaling)Print("EA Journaling: Trying to modify order "+(string)OrderTicket()+" ...");
         HandleTradingEnvironment(Journaling,Retry_Interval);
         Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Ask+VolTrailingStopDist*K*Point,OrderTakeProfit(),0,CLR_NONE);
         IsVolTrailingStopAdded=True;
         if(Journaling && !Modify)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
         if(Journaling && Modify)Print("EA Journaling: Order successfully modified, volatility trailing stop changed.");
        } 
     
      // Records volatility measure (ATR value) for future use
      if(IsVolTrailingStopAdded==True) 
         {
         for(int x=0; x<ArrayRange(VolTrailingListArray,0); x++) // Loop through elements in VolTrailingList
           { 
            if(VolTrailingListArray[x,0]==0)  // Checks if the element is empty
              { 
               VolTrailingListArray[x,0]=OrderNum; // Add order number
               VolTrailingListArray[x,1]=(int)(VolATR/(K*Point)); // Add volatility measure aka 1 unit of ATR
               break;
              }
           }
         }
     }     
  }
//+------------------------------------------------------------------+
//| End of Set Volatility Trailing Stop
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Review Hidden Volatility Trailing Stop
//+------------------------------------------------------------------+

void ReviewVolTrailingStop(bool Journaling, double VolTrailingDistMulti, double VolTrailingBuffMulti, int Retry_Interval, int Magic, int K, int & VolTrailingListArray [][])
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function updates volatility trailing stops levels for all positions (using OrderModify) if appropriate conditions are met

   bool doesVolTrailingRecordExist;
   int posTicketNumber;

   for(int i=OrdersTotal()-1; i>=0; i--) 
     { // Looping through all orders

      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
        {
         doesVolTrailingRecordExist = False;
         posTicketNumber=OrderTicket();

         for(int x=0; x<ArrayRange(VolTrailingListArray,0); x++) 
           { // Looping through all order number in list 

            if(posTicketNumber==VolTrailingListArray[x,0]) 
              { // If condition holds, it means the position have a volatility trailing stop level attached to it

               doesVolTrailingRecordExist = True; 
               bool Modify=false;
               RefreshRates();

               // We update the volatility trailing stop record using OrderModify.
               if(OrderType()==OP_BUY && (Bid-OrderStopLoss()>(VolTrailingDistMulti*VolTrailingListArray[x,1]+VolTrailingBuffMulti*VolTrailingListArray[x,1])*K*Point))
                 {
                  if(Journaling)Print("EA Journaling: Trying to modify order "+(string)OrderTicket()+" ...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Bid-VolTrailingDistMulti*VolTrailingListArray[x,1]*K*Point,OrderTakeProfit(),0,CLR_NONE);
                  if(Journaling && !Modify)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Modify)Print("EA Journaling: Order successfully modified, volatility trailing stop changed.");
                 }
               if(OrderType()==OP_SELL && ((OrderStopLoss()-Ask>((VolTrailingDistMulti*VolTrailingListArray[x,1]+VolTrailingBuffMulti*VolTrailingListArray[x,1])*K*Point)) || (OrderStopLoss()==0)))
                 {
                  if(Journaling)Print("EA Journaling: Trying to modify order "+(string)OrderTicket()+" ...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Ask+VolTrailingDistMulti*VolTrailingListArray[x,1]*K*Point,OrderTakeProfit(),0,CLR_NONE);
                  if(Journaling && !Modify)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Modify)Print("EA Journaling: Order successfully modified, volatility trailing stop changed.");
                 }
               break;
              }
           }
        // If order does not have a record attached to it. Alert the trader.
        if(!doesVolTrailingRecordExist && Journaling) Print("EA Journaling: Error. Order "+(string)posTicketNumber+" has no volatility trailing stop attached to it.");
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Review Volatility Trailing Stop
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Update Hidden Volatility Trailing Stops List                                     
//+------------------------------------------------------------------+

void UpdateHiddenVolTrailingList(bool Journaling,int Retry_Interval,int Magic, int & HiddenVolTrailingListArray [][]) 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function clears the elements of your HiddenVolTrailingList if the corresponding positions has been closed

   int ordersPos=OrdersTotal();
   int orderTicketNumber;
   bool doesPosExist;

// Check the HiddenVolTrailingList, match with current list of positions. Make sure the all the positions exists. 
// If it doesn't, it means there are positions that have been closed

   for(int x=0; x<ArrayRange(HiddenVolTrailingListArray,0); x++)
     { // Looping through all order number in list

      doesPosExist=False;
      orderTicketNumber=(int)HiddenVolTrailingListArray[x,0];

      if(orderTicketNumber!=0)
        { // Order exists
         for(int y=ordersPos-1; y>=0; y--)
           { // Looping through all current open positions
            if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
              {
               if(orderTicketNumber==OrderTicket())
                 { // Checks order number in list against order number of current positions
                  doesPosExist=True;
                  break;
                 }
              }
           }

         if(doesPosExist==False)
           { // Deletes elements if the order number does not match any current positions
            HiddenVolTrailingListArray[x,0] = 0;
            HiddenVolTrailingListArray[x,1] = 0;
            HiddenVolTrailingListArray[x,2] = 0;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Update Hidden Volatility Trailing Stops List                                          
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Set Hidden Volatility Trailing Stop
//+------------------------------------------------------------------+

void SetHiddenVolTrailing(bool Journaling,double VolATR,double VolTrailingDistMultiplierHidden,int Magic,int K,int OrderNum, int & HiddenVolTrailingListArray [][])
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function adds new hidden volatility trailing stop record 

   double VolTrailingStopLevel = 0;
   double VolTrailingStopDist;

   VolTrailingStopDist=VolTrailingDistMultiplierHidden*VolATR/(K*Point); // Volatility trailing stop amount in Pips

   if(OrderSelect(OrderNum,SELECT_BY_TICKET)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
     {
      RefreshRates();
      if(OrderType()==OP_BUY)  VolTrailingStopLevel = MathMax(Bid, OrderOpenPrice()) - VolTrailingStopDist*K*Point; // Volatility trailing stop level of buy trades
      if(OrderType()==OP_SELL) VolTrailingStopLevel = MathMin(Ask, OrderOpenPrice()) + VolTrailingStopDist*K*Point; // Volatility trailing stop level of sell trades
     
     }

   for(int x=0; x<ArrayRange(HiddenVolTrailingListArray,0); x++) // Loop through elements in HiddenVolTrailingList
     { 
      if(HiddenVolTrailingListArray[x,0]==0)  // Checks if the element is empty
        { 
         HiddenVolTrailingListArray[x,0] = OrderNum; // Add order number
         HiddenVolTrailingListArray[x,1] = (int)VolTrailingStopLevel; // Add volatility trailing stop level 
         HiddenVolTrailingListArray[x,2] = (int)(VolATR/(K*Point)); // Add volatility measure aka 1 unit of ATR
         if(Journaling)Print("EA Journaling: Order "+(string)HiddenVolTrailingListArray[x,0]+" assigned with a hidden volatility trailing stop level of "+(string)NormalizeDouble(HiddenVolTrailingListArray[x,1],Digits)+".");
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Set Hidden Volatility Trailing Stop
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Trigger and Review Hidden Volatility Trailing Stop
//+------------------------------------------------------------------+

void TriggerAndReviewHiddenVolTrailing(bool Journaling, double VolTrailingDistMultiplierHidden, double VolTrailingBuffMultiplierHidden, int Slip, int Retry_Interval, int Magic, int K, int & HiddenVolTrailingListArray [][])
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function does 2 things. 1) It closes the positions if hidden volatility trailing stops levels are breached. 2) It updates hidden volatility trailing stops for all positions if appropriate conditions are met

   bool doesHiddenVolTrailingRecordExist;
   int posTicketNumber;

   for(int i=OrdersTotal()-1; i>=0; i--) 
     { // Looping through all orders

      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
        {
         doesHiddenVolTrailingRecordExist = False;
         posTicketNumber=OrderTicket();

         // 1) Check if we need to close the order.

         for(int x=0; x<ArrayRange(HiddenVolTrailingListArray,0); x++) 
           { // Looping through all order number in list 

            if(posTicketNumber==HiddenVolTrailingListArray[x,0]) 
              { // If condition holds, it means the position have a hidden volatility trailing stop level attached to it

               doesHiddenVolTrailingRecordExist = True; 
               bool Closing=false;
               RefreshRates();

               if(OrderType()==OP_BUY && HiddenVolTrailingListArray[x,1]>=Bid) 
                 {

                  if(Journaling)Print("EA Journaling: Trying to close position "+(string)OrderTicket()+" using hidden volatility trailing stop...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Closing=OrderClose(OrderTicket(),OrderLots(),Bid,Slip*K,Blue);
                  if(Journaling && !Closing)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Closing)Print("EA Journaling: Position successfully closed due to hidden volatility trailing stop.");

                    } else if (OrderType()==OP_SELL && HiddenVolTrailingListArray[x,1]<=Ask) {

                  if(Journaling)Print("EA Journaling: Trying to close position "+(string)OrderTicket()+" using hidden volatility trailing stop...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Closing=OrderClose(OrderTicket(),OrderLots(),Ask,Slip*K,Red);
                  if(Journaling && !Closing)Print("EA Journaling: Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Closing)Print("EA Journaling: Position successfully closed due to hidden volatility trailing stop.");

                    }  else {

                  // 2) If orders was not closed in 1), we update the hidden volatility trailing stop record.

                  if(OrderType()==OP_BUY && (Bid-HiddenVolTrailingListArray[x,1]>(VolTrailingDistMultiplierHidden*HiddenVolTrailingListArray[x,2]+VolTrailingBuffMultiplierHidden*HiddenVolTrailingListArray[x,2])*K*Point)) 
                    {
                     HiddenVolTrailingListArray[x,1]=(int)(Bid-VolTrailingDistMultiplierHidden*HiddenVolTrailingListArray[x,2]*K*Point); // Assigns new hidden trailing stop level
                     if(Journaling)Print("EA Journaling: Order "+(string)posTicketNumber+" successfully modified, hidden volatility trailing stop updated to "+(string)NormalizeDouble(HiddenVolTrailingListArray[x,1],Digits)+".");
                    }
                  if(OrderType()==OP_SELL && (HiddenVolTrailingListArray[x,1]-Ask>(VolTrailingDistMultiplierHidden*HiddenVolTrailingListArray[x,2]+VolTrailingBuffMultiplierHidden*HiddenVolTrailingListArray[x,2])*K*Point))
                    {
                     HiddenVolTrailingListArray[x,1]=(int)(Ask+VolTrailingDistMultiplierHidden*HiddenVolTrailingListArray[x,2]*K*Point); // Assigns new hidden trailing stop level
                     if(Journaling)Print("EA Journaling: Order "+(string)posTicketNumber+" successfully modified, hidden volatility trailing stop updated "+(string)NormalizeDouble(HiddenVolTrailingListArray[x,1],Digits)+".");
                    }
                 }
               break;
              }
           }
        // If order does not have a record attached to it. Alert the trader.
        if(!doesHiddenVolTrailingRecordExist && Journaling) Print("EA Journaling: Error. Order "+(string)posTicketNumber+" has no hidden volatility trailing stop attached to it.");
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Trigger and Review Hidden Volatility Trailing Stop
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| HANDLE TRADING ENVIRONMENT                                       
//+------------------------------------------------------------------+
void HandleTradingEnvironment(bool Journaling,int Retry_Interval)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function checks for errors

   if(IsTradeAllowed()==true)return;
   if(!IsConnected())
     {
      if(Journaling)Print("EA Journaling: Terminal is not connected to server...");
      return;
     }
   if(!IsTradeAllowed() && Journaling)Print("EA Journaling: Trade is not alowed for some reason...");
   if(IsConnected() && !IsTradeAllowed())
     {
      while(IsTradeContextBusy()==true)
        {
         if(Journaling)Print("EA Journaling: Trading context is busy... Will wait a bit...");
         Sleep(Retry_Interval);
        }
     }
   RefreshRates();
  }
//+------------------------------------------------------------------+
//| End of HANDLE TRADING ENVIRONMENT                                
//+------------------------------------------------------------------+  
//+------------------------------------------------------------------+
//| ERROR DESCRIPTION                                                
//+------------------------------------------------------------------+
string GetErrorDescription(int error)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function returns the exact error

   string ErrorDescription="";
//---
   switch(error)
     {
      case 0:     ErrorDescription = "NO Error. Everything should be good.";                                    break;
      case 1:     ErrorDescription = "No error returned, but the result is unknown";                            break;
      case 2:     ErrorDescription = "Common error";                                                            break;
      case 3:     ErrorDescription = "Invalid trade parameters";                                                break;
      case 4:     ErrorDescription = "Trade server is busy";                                                    break;
      case 5:     ErrorDescription = "Old version of the client terminal";                                      break;
      case 6:     ErrorDescription = "No connection with trade server";                                         break;
      case 7:     ErrorDescription = "Not enough rights";                                                       break;
      case 8:     ErrorDescription = "Too frequent requests";                                                   break;
      case 9:     ErrorDescription = "Malfunctional trade operation";                                           break;
      case 64:    ErrorDescription = "Account disabled";                                                        break;
      case 65:    ErrorDescription = "Invalid account";                                                         break;
      case 128:   ErrorDescription = "Trade timeout";                                                           break;
      case 129:   ErrorDescription = "Invalid price";                                                           break;
      case 130:   ErrorDescription = "Invalid stops";                                                           break;
      case 131:   ErrorDescription = "Invalid trade volume";                                                    break;
      case 132:   ErrorDescription = "Market is closed";                                                        break;
      case 133:   ErrorDescription = "Trade is disabled";                                                       break;
      case 134:   ErrorDescription = "Not enough money";                                                        break;
      case 135:   ErrorDescription = "Price changed";                                                           break;
      case 136:   ErrorDescription = "Off quotes";                                                              break;
      case 137:   ErrorDescription = "Broker is busy";                                                          break;
      case 138:   ErrorDescription = "Requote";                                                                 break;
      case 139:   ErrorDescription = "Order is locked";                                                         break;
      case 140:   ErrorDescription = "Long positions only allowed";                                             break;
      case 141:   ErrorDescription = "Too many requests";                                                       break;
      case 145:   ErrorDescription = "Modification denied because order too close to market";                   break;
      case 146:   ErrorDescription = "Trade context is busy";                                                   break;
      case 147:   ErrorDescription = "Expirations are denied by broker";                                        break;
      case 148:   ErrorDescription = "Too many open and pending orders (more than allowed)";                    break;
      case 4000:  ErrorDescription = "No error";                                                                break;
      case 4001:  ErrorDescription = "Wrong function pointer";                                                  break;
      case 4002:  ErrorDescription = "Array index is out of range";                                             break;
      case 4003:  ErrorDescription = "No memory for function call stack";                                       break;
      case 4004:  ErrorDescription = "Recursive stack overflow";                                                break;
      case 4005:  ErrorDescription = "Not enough stack for parameter";                                          break;
      case 4006:  ErrorDescription = "No memory for parameter string";                                          break;
      case 4007:  ErrorDescription = "No memory for temp string";                                               break;
      case 4008:  ErrorDescription = "Not initialized string";                                                  break;
      case 4009:  ErrorDescription = "Not initialized string in array";                                         break;
      case 4010:  ErrorDescription = "No memory for array string";                                              break;
      case 4011:  ErrorDescription = "Too long string";                                                         break;
      case 4012:  ErrorDescription = "Remainder from zero divide";                                              break;
      case 4013:  ErrorDescription = "Zero divide";                                                             break;
      case 4014:  ErrorDescription = "Unknown command";                                                         break;
      case 4015:  ErrorDescription = "Wrong jump (never generated error)";                                      break;
      case 4016:  ErrorDescription = "Not initialized array";                                                   break;
      case 4017:  ErrorDescription = "DLL calls are not allowed";                                               break;
      case 4018:  ErrorDescription = "Cannot load library";                                                     break;
      case 4019:  ErrorDescription = "Cannot call function";                                                    break;
      case 4020:  ErrorDescription = "Expert function calls are not allowed";                                   break;
      case 4021:  ErrorDescription = "Not enough memory for temp string returned from function";                break;
      case 4022:  ErrorDescription = "System is busy (never generated error)";                                  break;
      case 4050:  ErrorDescription = "Invalid function parameters count";                                       break;
      case 4051:  ErrorDescription = "Invalid function parameter value";                                        break;
      case 4052:  ErrorDescription = "String function internal error";                                          break;
      case 4053:  ErrorDescription = "Some array error";                                                        break;
      case 4054:  ErrorDescription = "Incorrect series array using";                                            break;
      case 4055:  ErrorDescription = "Custom indicator error";                                                  break;
      case 4056:  ErrorDescription = "Arrays are incompatible";                                                 break;
      case 4057:  ErrorDescription = "Global variables processing error";                                       break;
      case 4058:  ErrorDescription = "Global variable not found";                                               break;
      case 4059:  ErrorDescription = "Function is not allowed in testing mode";                                 break;
      case 4060:  ErrorDescription = "Function is not confirmed";                                               break;
      case 4061:  ErrorDescription = "Send mail error";                                                         break;
      case 4062:  ErrorDescription = "String parameter expected";                                               break;
      case 4063:  ErrorDescription = "Integer parameter expected";                                              break;
      case 4064:  ErrorDescription = "Double parameter expected";                                               break;
      case 4065:  ErrorDescription = "Array as parameter expected";                                             break;
      case 4066:  ErrorDescription = "Requested history data in updating state";                                break;
      case 4067:  ErrorDescription = "Some error in trading function";                                          break;
      case 4099:  ErrorDescription = "End of file";                                                             break;
      case 4100:  ErrorDescription = "Some file error";                                                         break;
      case 4101:  ErrorDescription = "Wrong file name";                                                         break;
      case 4102:  ErrorDescription = "Too many opened files";                                                   break;
      case 4103:  ErrorDescription = "Cannot open file";                                                        break;
      case 4104:  ErrorDescription = "Incompatible access to a file";                                           break;
      case 4105:  ErrorDescription = "No order selected";                                                       break;
      case 4106:  ErrorDescription = "Unknown symbol";                                                          break;
      case 4107:  ErrorDescription = "Invalid price";                                                           break;
      case 4108:  ErrorDescription = "Invalid ticket";                                                          break;
      case 4109:  ErrorDescription = "EA is not allowed to trade is not allowed. ";                             break;
      case 4110:  ErrorDescription = "Longs are not allowed. Check the expert properties";                      break;
      case 4111:  ErrorDescription = "Shorts are not allowed. Check the expert properties";                     break;
      case 4200:  ErrorDescription = "Object exists already";                                                   break;
      case 4201:  ErrorDescription = "Unknown object property";                                                 break;
      case 4202:  ErrorDescription = "Object does not exist";                                                   break;
      case 4203:  ErrorDescription = "Unknown object type";                                                     break;
      case 4204:  ErrorDescription = "No object name";                                                          break;
      case 4205:  ErrorDescription = "Object coordinates error";                                                break;
      case 4206:  ErrorDescription = "No specified subwindow";                                                  break;
      case 4207:  ErrorDescription = "Some error in object function";                                           break;
      case 5001:  ErrorDescription = "ERR_FILE_TOO_MANY_OPENED || Too many opened files";                       break;
      case 5002:  ErrorDescription = "ERR_FILE_WRONG_FILENAME || Wrong file name";                              break;
      case 5003:  ErrorDescription = "ERR_FILE_TOO_LONG_FILENAME || Too long file name";                        break;
      case 5004:  ErrorDescription = "ERR_FILE_CANNOT_OPEN || Cannot open file";                                break;
      case 5005:  ErrorDescription = "ERR_FILE_BUFFER_ALLOCATION_ERROR || Text file buffer allocation error";   break;
      case 5006:  ErrorDescription = "ERR_FILE_CANNOT_DELETE || Cannot delete file";                            break;
      case 5007:  ErrorDescription = "ERR_FILE_INVALID_HANDLE || File closed or was not opened";                break;
      case 5008:  ErrorDescription = "ERR_FILE_WRONG_HANDLE || Handle index is out of handle table";            break;
      case 5009:  ErrorDescription = "ERR_FILE_NOT_TOWRITE || File must be opened with FILE_WRITE flag";        break;
      case 5010:  ErrorDescription = "ERR_FILE_NOT_TOREAD || File must be opened with FILE_READ flag";          break;
      case 5011:  ErrorDescription = "ERR_FILE_NOT_BIN || File must be opened with FILE_BIN flag";              break;
      case 5012:  ErrorDescription = "ERR_FILE_NOT_TXT || File must be opened with FILE_TXT flag";              break;
      case 5013:  ErrorDescription = "File must be opened with FILE_TXT or FILE_CSV flag";                      break;
      case 5014:  ErrorDescription = "ERR_FILE_NOT_CSV || File must be opened with FILE_CSV flag";              break;
      case 5015:  ErrorDescription = "ERR_FILE_READ_ERROR || File read error";                                  break;
      case 5016:  ErrorDescription = "ERR_FILE_WRITE_ERROR || File write error";                                break;
      case 5017:  ErrorDescription = "ERR_FILE_BIN_STRINGSIZE||String size must be specified for binary file";  break;
      case 5018:  ErrorDescription = "Incompatible file (for string arrays-TXT, for others-BIN)";               break;
      case 5019:  ErrorDescription = "ERR_FILE_IS_DIRECTORY || File is directory not file";                     break;
      case 5020:  ErrorDescription = "ERR_FILE_NOT_EXIST || File does not exist";                               break;
      case 5021:  ErrorDescription = "ERR_FILE_CANNOT_REWRITE || File cannot be rewritten";                     break;
      case 5022:  ErrorDescription = "ERR_FILE_WRONG_DIRECTORYNAME || Wrong directory name";                    break;
      case 5023:  ErrorDescription = "ERR_FILE_DIRECTORY_NOT_EXIST || Directory does not exist";                break;
      case 5024:  ErrorDescription = "ERR_FILE_NOT_DIRECTORY || Specified file is not directory";               break;
      case 5025:  ErrorDescription = "ERR_FILE_CANNOT_DELETE_DIRECTORY || Cannot delete directory";             break;
      case 5026:  ErrorDescription = "ERR_FILE_CANNOT_CLEAN_DIRECTORY || Cannot clean directory";               break;
      case 5027:  ErrorDescription = "ERR_FILE_ARRAYRESIZE_ERROR || Array resize error";                        break;
      case 5028:  ErrorDescription = "ERR_FILE_STRINGRESIZE_ERROR || String resize error";                      break;
      case 5029:  ErrorDescription = "Structure contains strings or dynamic arrays";                            break;
      case 5200:  ErrorDescription = "ERR_WEBREQUEST_INVALID_ADDRESS || Invalid URL";                           break;
      case 5201:  ErrorDescription = "ERR_WEBREQUEST_CONNECT_FAILED || Failed to connect to specified URL";     break;
      case 5202:  ErrorDescription = "ERR_WEBREQUEST_TIMEOUT || Timeout exceeded";                              break;      
      case 5203:  ErrorDescription = "ERR_WEBREQUEST_REQUEST_FAILED || HTTP request failed";                    break;
      case 65536: ErrorDescription = "ERR_USER_ERROR_FIRST || User defined errors start with this code";        break;
      default:    ErrorDescription = "No error or error is unknown";
     }
   return(ErrorDescription);
  }
//+------------------------------------------------------------------+
//| End of ERROR DESCRIPTION                                         
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| GetTradeFlagCondition                                              
//+------------------------------------------------------------------+
/*
New condition 2021-01-18
*/
bool GetTradeFlagConditionDSS_Bot(double ExpectedMoveLF, //predicted change from DSS
                           double ExpectedMoveHF,
                           double EntryTradeTriggerLF,//absolute value to enter trade
                           double EntryTradeTriggerHF,
                           double ModelQualityLF, //achieved model quality
                           double ModelQualityHF,
                           double MinModQualityLF, //min model performance to use value of 1st quantile from StrTest- files
                           double MinModQualityHF,
                           int    MT, //Market Type
                           double MTConfidence,  // Achieved prediction confidence for Market Type
                           string DirectionCheck,  //which direction to check "buy" "sell"
                           bool   OptTwoModels)    //option to use two models for trading decision
  {
// This function checks trade flag based on hard coded logic and return either false or true



   bool result=False;
   bool Bull = False;
   bool Bear = False;
   if( (MT == 3) || (MT == 4) || (MT == 5) || (MT == 6)) Bear = True;
   if( (MT == 1) || (MT == 2) || (MT == 5) || (MT == 6) ) Bull = True;
   
   
   if(OptTwoModels)
     {
      if(DirectionCheck == "buy" && 
      ExpectedMoveLF > EntryTradeTriggerLF && ExpectedMoveHF > EntryTradeTriggerHF &&
      ModelQualityHF > MinModQualityHF &&
      MinModQualityHF > 0 &&
      MinModQualityLF > 0 &&
      MTConfidence > 0.97) result = True; 
   else if(DirectionCheck == "sell" && 
      ExpectedMoveLF < (-1*EntryTradeTriggerLF) && ExpectedMoveHF < (-1*EntryTradeTriggerHF) && 
      ModelQualityHF > MinModQualityHF &&
      MinModQualityHF > 0 &&
      MinModQualityLF > 0 &&
      MTConfidence > 0.97) result = True;
     }
   if(!OptTwoModels)
     {
      if(DirectionCheck == "buy" && ExpectedMoveHF > EntryTradeTriggerHF && ModelQualityHF > MinModQualityHF && MTConfidence > 0.97) result = True; 
      else if(DirectionCheck == "sell" && ExpectedMoveHF < (-1*EntryTradeTriggerHF) && ModelQualityHF > MinModQualityHF && MTConfidence > 0.97) result = True;
     }
      
   return(result);

/* description: 
   Function will use provided information to decide whether to flag buy or sell condition as true or false
   DSS will also provide an output to the strategy test, this value is used as a filter to use this pair for trading
 
*/
  }
//+------------------------------------------------------------------+
//| End of GetTradeFlagCondition                                                
//+------------------------------------------------------------------+    
//+------------------------------------------------------------------+
//| GetTradePrediction                                              
//+------------------------------------------------------------------+
double GetTradePrediction(double stopFactorm60,    //stoploss or take profit factor
                          double AIPriceChangem60)
  {
// Type: Customizeable
// Do not edit unless you know what you're doing 

// This function checks robot type and return the predicted take profit or stop loss level
// let the trader decide which strategy to use (short/medium/long) and automatically changes trading behaviour 

   double result=0;
   
   result = stopFactorm60*MathAbs(AIPriceChangem60);  

   return(result);

/* Definitions: 
 
*/
  }
//+------------------------------------------------------------------+
//| End of GetTradePrediction                                                
//+------------------------------------------------------------------+    
//+------------------------------------------------------------------+
//| Dashboard - Comment Version                                    
//+------------------------------------------------------------------+
/*
ShowDashboard("Magic Number ", MagicNumber,
              "Market Type ", MyMarketType,
              "MyMarketTypeConf ", MyMarketTypeConf,
              
              "AI PriceChange Lower Period", int(AIChangeLP),
              "AI PriceChange Higher Period", int(AIChangeHP),
              "AItrigger L Period", AItriggerLP,
              "AItimehold L Period M15 Bars", int(AItimeholdLP),
              
              "AImaxperf LP", AImaxperfLP,
              "AIminperf LP", int(AIminperfLP),
              "AImaxperf HP", AImaxperfHP,
              "AIminperf HP", int(AIminperfHP)); 
*/

void ShowDashboardDSS_Bot(string Descr0, int Int1,
                   string Descr1, int my_market_type,
                   string Descr2, double Doubl1,
                   string Descr3, double Doubl2,
                   string Descr4, double Doubl3,
                   string Descr5, double Doubl4,
                   string Descr6, double Doubl5,
                   string Descr7, double Doubl6,
                   string Descr8, double Doubl7,
                   string Descr9, double Doubl8,
                   string Descr10, double Doubl9,
                   string Descr11, double Doubl10) 
  {
// Purpose: This function creates a dashboard showing information on your EA using comments function
// Type: Customisable 
// Modify this function to suit your trading robot
//----
/*
Conversion of Market Types
if(res == "0" || res == "-1") {marketType = MARKET_NONE; return(marketType); }
   if(res == "1" || res == "BUN"){marketType = MARKET_BUN;  return(marketType); }
   if(res == "2" || res == "BUV"){marketType = MARKET_BUV;  return(marketType); }
   if(res == "3" || res == "BEN"){marketType = MARKET_BEN;  return(marketType); }
   if(res == "4" || res == "BEV"){marketType = MARKET_BEV;  return(marketType); }
   if(res == "5" || res == "RAN"){marketType = MARKET_RAN;  return(marketType); }
   if(res == "6" || res == "RAV"){marketType = MARKET_RAV;  return(marketType); }
*/

string new_line = "\n"; // "\n" or "\n\n" will move the comment to new line
string space = ": ";    // generate space
string underscore = "________________________________";
string market_type;

//Convert Integer value of Market Type to String value
if(my_market_type == 0) market_type = "ERR";
if(my_market_type == 1) market_type = "BUN";
if(my_market_type == 2) market_type = "BUV";
if(my_market_type == 3) market_type = "BEN";
if(my_market_type == 4) market_type = "BEV";
if(my_market_type == 5) market_type = "RAN";
if(my_market_type == 6) market_type = "RAV";


Comment(
        new_line 
      + Descr0 + space + IntegerToString(Int1)
      + new_line      
      + Descr1 + space + market_type
      + new_line 
      + Descr2 + space + DoubleToString(Doubl1, 2)
      + new_line      
      + underscore  
      + new_line
      + Descr3 + space + DoubleToString(Doubl2, 2)
      + new_line        
      + Descr4 + space + DoubleToString(Doubl3, 2)
      + new_line
      + Descr5 + space + DoubleToString(Doubl4, 2)
      + new_line
      + Descr6 + space + DoubleToString(Doubl5, 2)
      + new_line
      + underscore  
      + new_line
      + Descr7 + space + DoubleToString(Doubl6, 2)
      + new_line
      + underscore  
      + new_line 
      + Descr8 + space + DoubleToString(Doubl7, 2)
      + new_line
      + Descr9 + space + DoubleToString(Doubl8, 2)
      + new_line        
      + Descr10 + space + DoubleToString(Doubl9, 2)
      + new_line
      + Descr11 + space + DoubleToString(Doubl10, 2)
      + new_line        
      + underscore  
      + "");
      
      
  }

//+------------------------------------------------------------------+
//| End of Dashboard - Comment Version                                     
//+------------------------------------------------------------------+   






//+------------------------------------------------------------------+
//| GetTradeFlagCondition                                              
//+------------------------------------------------------------------+
bool GetTradeFlagConditionDSS_Rule(int FastMAPeriod, //14 x M15
                                   int SlowMAPeriod,//150 x M15
                                   int KeltnerPeriod, //20
                                   double KeltnerMulti, //2
                                   int    MT, //Market Type
                                   string DirectionCheck) //which direction to check "buy" "sell" "exitbuy" "exitsell"
  {
// This function checks trade flag based on hard coded logic and return either false or true
/*
Arbitrary Rules with default parameters:
Enter Buy:  FastMA1 < SlowMA1 && Ask < KeltnerLower1 && CrossStoch[StMainSh1 > StSnglSh1 & StMainSh2 < StSnglSh2] && StMainSh1 < 20
Exit Buy:   FastMA1 > SlowMA1 && Bid >  KeltnerUpper1 && StMainSh1 > 80

Enter Sell:  FastMA1 > SlowMA1 && Bid > KeltnerUpper1 && CrossStoch[StMainSh1 < StSnglSh1 & StMainSh2 > StSnglSh2] && StMainSh1 > 80
Exit Sell:   FastMA1 < SlowMA1 && Ask < KeltnerLower1  && StMainSh1 < 20

*/
   double FastMA1=iMA(Symbol(),PERIOD_M15,FastMAPeriod,0, MODE_SMA, PRICE_CLOSE,1); // Shift 1
   double SlowMA1=iMA(Symbol(),PERIOD_M15,SlowMAPeriod,0, MODE_SMA, PRICE_CLOSE,1); // Shift 1

   double KeltnerUpper1 = iCustom(Symbol(), PERIOD_M15, "Keltner_Channels", KeltnerPeriod, 0, 0, KeltnerPeriod, KeltnerMulti, True, 0, 1); // Shift 1
   double KeltnerLower1 = iCustom(Symbol(), PERIOD_M15, "Keltner_Channels", KeltnerPeriod, 0, 0, KeltnerPeriod, KeltnerMulti, True, 2, 1); // Shift 1

   double StMainSh1 = iStochastic(Symbol(), PERIOD_M15, 34, 13, 8, MODE_SMA, 0, MODE_MAIN, 1);
   double StSnglSh1 = iStochastic(Symbol(), PERIOD_M15, 34, 13, 8, MODE_SMA, 0, MODE_SIGNAL, 1);
   double StMainSh2 = iStochastic(Symbol(), PERIOD_M15, 34, 13, 8, MODE_SMA, 0, MODE_MAIN, 2);
   double StSnglSh2 = iStochastic(Symbol(), PERIOD_M15, 34, 13, 8, MODE_SMA, 0, MODE_SIGNAL, 2);
   
   bool result=False;
   bool Bull = False;
   bool Bear = False;
   
   if( (MT == 3) || (MT == 4) || (MT == 5) || (MT == 6)) Bear = True;
   if( (MT == 1) || (MT == 2) || (MT == 5) || (MT == 6) ) Bull = True;
   
   if(DirectionCheck == "buy" && FastMA1 < SlowMA1 && StMainSh1 > StSnglSh1 && StMainSh2 < StSnglSh2 && StMainSh1 < 20 && Bull) result = True; 
   else if(DirectionCheck == "sell" && FastMA1 > SlowMA1 && StMainSh1 < StSnglSh1 && StMainSh2 > StSnglSh2 && StMainSh1 > 80 && Bear) result = True;
   else if(DirectionCheck == "exitbuy" && FastMA1 > SlowMA1 && Bid > KeltnerUpper1 && StMainSh1 > 80) result = True;
   else if(DirectionCheck == "exitsell" && FastMA1 < SlowMA1 && Ask < KeltnerLower1 && StMainSh1 < 20) result = True;
      
   return(result);

/* description: 
   Function will use provided information to decide whether to flag buy or sell condition as true or false
    
*/
  }
//+------------------------------------------------------------------+
//| End of GetTradeFlagCondition                                                
//+------------------------------------------------------------------+    

   
//+------------------------------------------------------------------+
//| Dashboard - Comment Version                                    
//+------------------------------------------------------------------+
void ShowDashboardDSS_Rule(string Descr0, int magic,
                   string Descr1, int my_market_type,
                   string Descr2, int Param1,
                   string Descr3, double Param2,
                   string Descr4, int Param3,
                   string Descr5, double Param4,
                   string Descr6, int Param5,
                   string Descr7, double Param6
                     ) 
  {
// Purpose: This function creates a dashboard showing information on your EA using comments function
// Type: Customisable 
// Modify this function to suit your trading robot
//----
/*
Conversion of Market Types
if(res == "0" || res == "-1") {marketType = MARKET_NONE; return(marketType); }
   if(res == "1" || res == "BUN"){marketType = MARKET_BUN;  return(marketType); }
   if(res == "2" || res == "BUV"){marketType = MARKET_BUV;  return(marketType); }
   if(res == "3" || res == "BEN"){marketType = MARKET_BEN;  return(marketType); }
   if(res == "4" || res == "BEV"){marketType = MARKET_BEV;  return(marketType); }
   if(res == "5" || res == "RAN"){marketType = MARKET_RAN;  return(marketType); }
   if(res == "6" || res == "RAV"){marketType = MARKET_RAV;  return(marketType); }
*/

string new_line = "\n"; // "\n" or "\n\n" will move the comment to new line
string space = ": ";    // generate space
string underscore = "________________________________";
string market_type;

//Convert Integer value of Market Type to String value
if(my_market_type == 0) market_type = "ERR";
if(my_market_type == 1) market_type = "BUN";
if(my_market_type == 2) market_type = "BUV";
if(my_market_type == 3) market_type = "BEN";
if(my_market_type == 4) market_type = "BEV";
if(my_market_type == 5) market_type = "RAN";
if(my_market_type == 6) market_type = "RAV";


Comment(
        new_line 
      + Descr0 + space + IntegerToString(magic)
      + new_line      
      + Descr1 + space + market_type
      + new_line 
      + underscore  
      + new_line
      + new_line
      + Descr2 + space + IntegerToString(Param1)
      + new_line
      + Descr3 + space + DoubleToString(Param2, 1)
      + new_line        
      + underscore  
      + new_line 
      + new_line
      + Descr4 + space + IntegerToString(Param3)
      + new_line
      + Descr5 + space + DoubleToString(Param4, 1)
      + new_line        
      + underscore  
      + new_line 
      + new_line
      + Descr6 + space + IntegerToString(Param5)
      + new_line
      + Descr7 + space + DoubleToString(Param6, 1)
      + new_line        
      + underscore  
      + "");
      
      
  }

//+------------------------------------------------------------------+
//| End of Dashboard - Comment Version                                     
//+------------------------------------------------------------------+   

//+------------------------------------------------------------------+
//| Dashboard - Comment Version                                    
//+------------------------------------------------------------------+
/*
ShowDashboard("Magic Number ", MagicNumber,
              "Market Type ", MyMarketType,
              "MyMarketTypeConf ", MyMarketTypeConf,
              
              "AI PriceChange Lower Period", int(AIChangeLP),
              "AI PriceChange Higher Period", int(AIChangeHP),
              "AItrigger L Period", AItriggerLP,
              "AItimehold L Period M15 Bars", int(AItimeholdLP),
              
              "AImaxperf LP", AImaxperfLP,
              "AIminperf LP", int(AIminperfLP),
              "AImaxperf HP", AImaxperfHP,
              "AIminperf HP", int(AIminperfHP)); 
*/

void ShowDashboardDSS_Hybrid(string Descr0, int Int1,
                   string Descr1, int my_market_type,
                   string Descr2, double Doubl1,
                   string Descr3, double Doubl2,
                   string Descr4, double Doubl3,
                   string Descr5, double Doubl4,
                   string Descr6, double Doubl5,
                   string Descr7, double Doubl6,
                   string Descr8, double Doubl7,
                   string Descr9, double Doubl8,
                   string Descr10, double Doubl9,
                   string Descr11, double Doubl10) 
  {
// Purpose: This function creates a dashboard showing information on your EA using comments function
// Type: Customisable 
// Modify this function to suit your trading robot
//----
/*
Conversion of Market Types
if(res == "0" || res == "-1") {marketType = MARKET_NONE; return(marketType); }
   if(res == "1" || res == "BUN"){marketType = MARKET_BUN;  return(marketType); }
   if(res == "2" || res == "BUV"){marketType = MARKET_BUV;  return(marketType); }
   if(res == "3" || res == "BEN"){marketType = MARKET_BEN;  return(marketType); }
   if(res == "4" || res == "BEV"){marketType = MARKET_BEV;  return(marketType); }
   if(res == "5" || res == "RAN"){marketType = MARKET_RAN;  return(marketType); }
   if(res == "6" || res == "RAV"){marketType = MARKET_RAV;  return(marketType); }
*/

string new_line = "\n"; // "\n" or "\n\n" will move the comment to new line
string space = ": ";    // generate space
string underscore = "________________________________";
string market_type;

//Convert Integer value of Market Type to String value
if(my_market_type == 0) market_type = "ERR";
if(my_market_type == 1) market_type = "BUN";
if(my_market_type == 2) market_type = "BUV";
if(my_market_type == 3) market_type = "BEN";
if(my_market_type == 4) market_type = "BEV";
if(my_market_type == 5) market_type = "RAN";
if(my_market_type == 6) market_type = "RAV";


Comment(
        new_line 
      + Descr0 + space + IntegerToString(Int1)
      + new_line      
      + Descr1 + space + market_type
      + new_line 
      + Descr2 + space + DoubleToString(Doubl1, 2)
      + new_line      
      + underscore  
      + new_line
      + Descr3 + space + DoubleToString(Doubl2, 2)
      + new_line        
      + Descr4 + space + DoubleToString(Doubl3, 2)
      + new_line
      + Descr5 + space + DoubleToString(Doubl4, 2)
      + new_line
      + Descr6 + space + DoubleToString(Doubl5, 2)
      + new_line
      + underscore  
      + new_line
      + Descr7 + space + DoubleToString(Doubl6, 2)
      + new_line
      + underscore  
      + new_line 
      + Descr8 + space + DoubleToString(Doubl7, 2)
      + new_line
      + Descr9 + space + DoubleToString(Doubl8, 2)
      + new_line        
      + Descr10 + space + DoubleToString(Doubl9, 2)
      + new_line
      + Descr11 + space + DoubleToString(Doubl10, 2)
      + new_line        
      + underscore  
      + "");
      
      
  }

//+------------------------------------------------------------------+
//| End of Dashboard - Comment Version                                     
//+------------------------------------------------------------------+   
//+------------------------------------------------------------------+
//| GetTradeFlagCondition                                              
//+------------------------------------------------------------------+
bool GetTradeFlagConditionDSS_Hybrid(double ExpectedMoveLF, //predicted change from DSS
                           double ExpectedMoveHF,
                           double EntryTradeTriggerLF,//absolute value to enter trade
                           double EntryTradeTriggerHF,
                           double ModelQualityLF, //achieved model quality
                           double ModelQualityHF,
                           double MinModQualityLF, //min model performance to use value of 1st quantile from StrTest- files
                           double MinModQualityHF,
                           int    MT, //Market Type
                           string DirectionCheck,
                           bool   OptTwoModels) //which direction to check "buy" "sell"
  {
// This function checks trade flag based on hard coded logic and return either false or true

   bool result=False;
   bool Bull = False;
   bool Bear = False;
   if( (MT == 3) || (MT == 4) || (MT == 5) || (MT == 6)) Bear = True;
   if( (MT == 1) || (MT == 2) || (MT == 5) || (MT == 6)) Bull = True;
   
   if(OptTwoModels)
     {
      if(DirectionCheck == "buy" && 
      ExpectedMoveLF > EntryTradeTriggerLF && ExpectedMoveHF > EntryTradeTriggerHF &&
      ModelQualityLF > MinModQualityLF && ModelQualityHF > MinModQualityHF &&
      Bull == True) result = True; 
   else if(DirectionCheck == "sell" && 
      ExpectedMoveLF < (-1*EntryTradeTriggerLF) && ExpectedMoveHF < (-1*EntryTradeTriggerHF) && 
      ModelQualityLF > MinModQualityLF && ModelQualityHF > MinModQualityHF &&
      Bear == True) result = True;
     }
   if(!OptTwoModels)
     {
      if(DirectionCheck == "buy" && ExpectedMoveHF > EntryTradeTriggerHF && ModelQualityHF > MinModQualityHF && Bear == True) result = True; 
      else if(DirectionCheck == "sell" && ExpectedMoveHF < (-1*EntryTradeTriggerHF) && ModelQualityHF > MinModQualityHF && Bull == True) result = True;
     }
      
   
   return(result);

/* description: 
   Function will use provided information to decide whether to flag buy or sell condition as true or false
   DSS will also provide an output to the strategy test, this value is used as a filter to use this pair for trading
 
*/
  }
//+------------------------------------------------------------------+
//| End of GetTradeFlagCondition                                                
//+------------------------------------------------------------------+    
//+------------------------------------------------------------------+
//| GetTradeFlagConditionDSS_DRL_Bot                                              
//+------------------------------------------------------------------+
/*
New condition 2021-01-18
*/
bool GetTradeFlagConditionDSS_DRL_Bot(int ExpectedMove, //predicted direction from DSS
                           double MTConfidence,  // Achieved prediction confidence for Market Type
                           string DirectionCheck,  //which direction to check "buy" "sell"
                           bool   OptDRLModel)    //option to use two models for trading decision
  {
// This function checks trade flag based on hard coded logic and return either false or true

   bool result=False;
   
   if(OptDRLModel)
     {
      if(DirectionCheck == "buy" && 
      ExpectedMove == 777 &&
      MTConfidence > 0.97) result = True; 
   else if(DirectionCheck == "sell" && 
      ExpectedMove == 333 && 
      MTConfidence > 0.97) result = True;
     }
      
   return(result);

/* description: 
   Function will use provided information to decide whether to flag buy or sell condition as true or false
   DSS will also provide an output to the strategy test, this value is used as a filter to use this pair for trading
 
*/
  }
//+------------------------------------------------------------------+
//| End of GetTradeFlagConditionDSS_DRL_Bot                                                
//+------------------------------------------------------------------+    
//+------------------------------------------------------------------+
//| CheckActiveHours                                              
//+------------------------------------------------------------------+
/*
Function to check server time is in one or more trading sessions
Tested 2023-01-15
Tokyo T London F NewYork F - ok
Tokyo F London T NewYork F - ok
Tokyo F London F NewYork T - ok
Tokyo F London F NewYork F - ok
Tokyo T London T NewYork T - ok
Tokyo T London F NewYork T - ok
Tokyo F London T NewYork T - ok
Tokyo F London F NewYork T - ok
*/
bool CheckActiveHours(bool InTokyo, //should system be active in Tokyo Session?
                      bool InLondon, //should system be active in London Session?
                      bool InNewYork) //should system be active in NewYork Session?
                      
  {
// This function checks for a condition based on hard coded logic and return either false or true

   // Set operations disabled by default.
   bool result = false;
   bool resT = false; 
   bool resL = false;
   bool resN = false;
   int TokSt = 22; int TokEnd = 8;
   int LondSt = 8; int LondEnd = 16;
   int NYSt = 13; int NYEnd = 22;
   
   // Check if the current hour is between the allowed hours of operations. If so, return true.
   if(InTokyo)
     {
      if (((Hour() >= TokSt) && (Hour() <= 23)) || ((Hour() <= TokEnd) && (Hour() >= 0)))
      resT = true;
     }
    if(InLondon)
      {
      if ((Hour() >= LondSt) && (Hour() <= LondEnd))
         resL = true;
     }
    if(InNewYork)
      {
      if ((Hour() >= NYSt) && (Hour() <= NYEnd))
         resN = true;
     } 
     
   if(resT || resL || resN)
     {
      result = true;
     }
        
   return result;

/* description: 
   Function will check if trading should be active at any given time by checking if the system
   is in specific trading sessions (Tokyo, London, New York)
   Note: Assumed trading server is in UTC + 2
    
*/
  }
//+------------------------------------------------------------------+
//| End of CheckActiveHours                                                
//+------------------------------------------------------------------+    
//+------------------------------------------------------------------+
//| Dashboard - ShowDashboardDSS_DRL_Bot                                   
//+------------------------------------------------------------------+
/*
ShowDashboard("Magic Number ", MagicNumber,
              "Market Type ", MyMarketType,
              "MyMarketTypeConf ", MyMarketTypeConf,
              
              "AI PriceChange Lower Period", int(AIChangeLP),
              "AI PriceChange Higher Period", int(AIChangeHP),
              "AItrigger L Period", AItriggerLP,
              "AItimehold L Period M15 Bars", int(AItimeholdLP),
              
              "AImaxperf LP", AImaxperfLP,
              "AIminperf LP", int(AIminperfLP),
              "AImaxperf HP", AImaxperfHP,
              "AIminperf HP", int(AIminperfHP)); 
*/

void ShowDashboardDSS_DRL_Bot(string Descr0, int Int1,
                   string Descr1, int my_market_type,
                   string Descr2, double Doubl1) 
  {
// Purpose: This function creates a dashboard showing information on your EA using comments function
// Type: Customisable 
// Modify this function to suit your trading robot
//----
/*
Conversion of Market Types
if(res == "0" || res == "-1") {marketType = MARKET_NONE; return(marketType); }
   if(res == "1" || res == "BUN"){marketType = MARKET_BUN;  return(marketType); }
   if(res == "2" || res == "BUV"){marketType = MARKET_BUV;  return(marketType); }
   if(res == "3" || res == "BEN"){marketType = MARKET_BEN;  return(marketType); }
   if(res == "4" || res == "BEV"){marketType = MARKET_BEV;  return(marketType); }
   if(res == "5" || res == "RAN"){marketType = MARKET_RAN;  return(marketType); }
   if(res == "6" || res == "RAV"){marketType = MARKET_RAV;  return(marketType); }
*/

string new_line = "\n"; // "\n" or "\n\n" will move the comment to new line
string space = ": ";    // generate space
string underscore = "________________________________";
string market_type;

//Convert Integer value of Market Type to String value
if(my_market_type == 0) market_type = "ERR";
if(my_market_type == 777) market_type = "BUY";
if(my_market_type == 333) market_type = "SELL";

Comment(
        new_line 
      + Descr0 + space + IntegerToString(Int1)
      + new_line      
      + Descr1 + space + market_type
      + new_line 
      + Descr2 + space + DoubleToString(Doubl1, 2)
      + new_line 
      + "");
      
      
  }

//+------------------------------------------------------------------+
//| End of Dashboard - ShowDashboardDSS_DRL_Bot                                     
//+------------------------------------------------------------------+   

//+------------------------------------------------------------------+
//| ReadMarketFromIND                                              
//+------------------------------------------------------------------+
/*
User guide:
1. Add global bool variable to EA: e.g.:                     int     MyMarketType;
2. Add function call inside start function to EA: e.g.: MyMarketType = ReadMarketFromCSV(Symbol());
3. Adapt Trading Robot conditions to change trading strategy parameters eg.: see Falcon_C
4. Add include call to this file  to EAe.g.:            #include <096_ReadMarketTypeFromCSV.mqh>
*/


#define MT_BUN  1       //Market with bullish character
#define MT_BEN  3       //Market with bearish character
#define MT_RAN  5       //Market with Ranging character

int ReadMarketFromIND(string symbol)
{
/*
- Function uses the manual rule

Identify 3 Market Types: BUN, RAN, BEV
  Use 2 indicators: MA and Bears as follows:
  BUN: D1 MA950 < D1 MA10 && D1 Bears24 > 0 
  BEV: D1 MA950 > D1 MA10 && D1 Bears24 < 0
  RAN: D1 MA950 < D1 MA10 && D1 Bears24 > 0 || D1 MA950 > D1 MA10 && D1 Bears24 > 0
 
*/
   //define internal variables needed
   int marketType = -1;         //Variable to store and return the market type
   string res = "0";            //Variable to return result of the function
   

   //define indicator values
   double D1MA950 = iMA(symbol, PERIOD_D1, 950, 0, 0, 0, 1);
   double  D1MA10 = iMA(symbol, PERIOD_D1, 10, 0, 0, 0, 1);
   double D1BE24 = iBearsPower(symbol, PERIOD_D1, 24, 0, 1);
   
   //Assign market variable based on result
   //if(res == "0" || res == "-1") {marketType = MARKET_NONE; return(marketType); }
   if(((D1MA950 < D1MA10) && (D1BE24 > 0))){marketType = MT_BUN;  return(marketType); }
   //if(res == "2" || res == "BUV"){marketType = MARKET_BUV;  return(marketType); }
   if(((D1MA950 > D1MA10) && (D1BE24 < 0))){marketType = MT_BEN;  return(marketType); }
   //if(res == "4" || res == "BEV"){marketType = MARKET_BEV;  return(marketType); }
   if((((D1MA950 < D1MA10) && (D1BE24 < 0)) || ((D1MA950 > D1MA10) && (D1BE24 > 0)))){marketType = MT_RAN;  return(marketType); }
   //if(res == "6" || res == "RAV"){marketType = MARKET_RAV;  return(marketType); }
   
   return(marketType); //in anomalous case function will return error '-1'
 
} 
//+------------------------------------------------------------------+
//| End of ReadMarketFromIND                                                
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| Start of WriteDataSetRLUnit
//+------------------------------------------------------------------+ 
double bar_type(string sym, int peri, int shiftbar)
{
                     //bars characterization
                     double iHg = iHigh(sym, peri,shiftbar);
                     double iLw = iLow(sym, peri,shiftbar);
                     double iOp = iOpen(sym, peri,shiftbar);
                     double iCs = iClose(sym, peri,shiftbar);
                     //bar type +10 bull; -10 bear
                     double bartype = 0;
                     if(iOp < iCs) bartype = 100;
                     if(iOp > iCs) bartype = 0;
                     if(iOp == iCs)bartype = 50;
                       
                     return(bartype);
}

double high_whisk(string sym, int peri, int shiftbar)
{
                     //bars characterization
                     double iHg = iHigh(sym, peri,shiftbar);
                     double iLw = iLow(sym, peri,shiftbar);
                     double iOp = iOpen(sym, peri,shiftbar);
                     double iCs = iClose(sym, peri,shiftbar);
                     //% of the higher whisker
                     double hWisk = 0;
                     // bullish
                     if(iOp < iCs) hWisk = 100*((iHg-iCs)/(iHg-iLw));
                     // bearish
                     if(iOp > iCs) hWisk = 100*((iHg-iOp)/(iHg-iLw));;
                     return(hWisk);
}

double low_whisk(string sym, int peri, int shiftbar)
{
                     //bars characterization
                     double iHg = iHigh(sym, peri,shiftbar);
                     double iLw = iLow(sym, peri,shiftbar);
                     double iOp = iOpen(sym, peri,shiftbar);
                     double iCs = iClose(sym, peri,shiftbar);
                     //% of the lower whisker
                     double lWisk = 0;
                     // bullish
                     if(iOp < iCs) lWisk = 100*((iOp-iLw)/(iHg-iLw));
                     // bearish
                     if(iOp > iCs) lWisk = 100*((iCs-iLw)/(iHg-iLw));;
                     return(lWisk);
}


double bar_body(string sym, int peri, int shiftbar)
{
                     //bars characterization
                     double iHg = iHigh(sym, peri,shiftbar);
                     double iLw = iLow(sym, peri,shiftbar);
                     double iOp = iOpen(sym, peri,shiftbar);
                     double iCs = iClose(sym, peri,shiftbar);
                     //% of the lower whisker
                     double bBody = 0;
                     // bullish
                     if(iOp < iCs) bBody = 100*((iCs-iOp)/(iHg-iLw));
                     // bearish
                     if(iOp > iCs) bBody = 100*((iOp-iCs)/(iHg-iLw));
                     if(iOp == iCs) bBody = 0;
                     return(bBody);
}

void WriteDataSetRLUnit(string symboll, string foldname, string filename, int charPer1, int barsCollect, bool dssInput)
// function to record 28 currencies pairs close price to the file (file to be used by all R scripts)
 {
 

 int digits = (int)MarketInfo(symboll, MODE_DIGITS);
 int shift = 30;
   
string data;    //identifier that will be used to collect data string
string filepath;
datetime TIME;  //Time index
               if(!dssInput)filepath = foldname+"\\"+filename; //dss_input == False creates sub folders with simulation data
               if(dssInput)filepath = filename; //dss_input == True creates files in the sandbox
                 
               // delete file if it's exist
               FileDelete(filepath);
               // open file handle
               int handle = FileOpen(filepath,FILE_CSV|FILE_READ|FILE_WRITE);
                FileSeek(handle,0,SEEK_SET);
               // generate data now using for loop

  
               // ===================================================================================================
               // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               // ===================================================================================================

               if(StringCompare(foldname, "6_06")== 0)
                 {
                        //loop j calculates surfaces and angles from beginning of the day
                     for(int j = 1; j < barsCollect; j++)    //j scrolls through bars of the day
                       {
                         TIME = iTime(symboll, charPer1, j);  //Time of the bar of the applied chart symbol
                         data = string(TIME); 
                          
                           string ind[40];
                           
                           //ind[0] acts as a label
                           if((iClose(symboll,charPer1,j+34)-iClose(symboll,charPer1,j)) < 0){ind[0] = "BUY";}else{ind[0] = "SELL";}
                           
                           //ind[1-3] will act like a reward results
                           ind[1]  = DoubleToStr((iClose(symboll,charPer1,j)-iClose(symboll,charPer1,j+10)),digits);
                           ind[2]  = DoubleToStr((iClose(symboll,charPer1,j)-iClose(symboll,charPer1,j+20)),digits);
                           ind[3]  = DoubleToStr((iClose(symboll,charPer1,j)-iClose(symboll,charPer1,j+30)),digits);
                           
                           //ind[4-39] act like an indicator pattern
                           ind[4] = DoubleToStr(bar_type(symboll, charPer1, j+shift));
                           ind[5] = DoubleToStr(high_whisk(symboll, charPer1, j+shift));
                           ind[6] = DoubleToStr(low_whisk(symboll, charPer1, j+shift));
                           ind[7] = DoubleToStr(bar_body(symboll, charPer1, j+shift));
                           
                           ind[8] = DoubleToStr(bar_type(symboll, charPer1, j+1+shift));
                           ind[9] = DoubleToStr(high_whisk(symboll, charPer1, j+1+shift));
                           ind[10] = DoubleToStr(low_whisk(symboll, charPer1, j+1+shift));
                           ind[11] = DoubleToStr(bar_body(symboll, charPer1, j+1+shift));
                           
                           ind[12] = DoubleToStr(bar_type(symboll, charPer1, j+2+shift));
                           ind[13] = DoubleToStr(high_whisk(symboll, charPer1, j+2+shift));
                           ind[14] = DoubleToStr(low_whisk(symboll, charPer1, j+2+shift));
                           ind[15] = DoubleToStr(bar_body(symboll, charPer1, j+2+shift));
                           
                           ind[16] = DoubleToStr(bar_type(symboll, charPer1, j+3+shift));
                           ind[17] = DoubleToStr(high_whisk(symboll, charPer1, j+3+shift));
                           ind[18] = DoubleToStr(low_whisk(symboll, charPer1, j+3+shift));
                           ind[19] = DoubleToStr(bar_body(symboll, charPer1, j+3+shift));
                           
                           ind[20] = DoubleToStr(bar_type(symboll, charPer1, j+5+shift));
                           ind[21] = DoubleToStr(high_whisk(symboll, charPer1, j+5+shift));
                           ind[22] = DoubleToStr(low_whisk(symboll, charPer1, j+5+shift));
                           ind[23] = DoubleToStr(bar_body(symboll, charPer1, j+5+shift));
                           
                           ind[24] = DoubleToStr(bar_type(symboll, charPer1, j+8+shift));
                           ind[25] = DoubleToStr(high_whisk(symboll, charPer1, j+8+shift));
                           ind[26] = DoubleToStr(low_whisk(symboll, charPer1, j+8+shift));
                           ind[27] = DoubleToStr(bar_body(symboll, charPer1, j+8+shift));
                           
                           ind[28] = DoubleToStr(bar_type(symboll, charPer1, j+13+shift));
                           ind[29] = DoubleToStr(high_whisk(symboll, charPer1, j+13+shift));
                           ind[30] = DoubleToStr(low_whisk(symboll, charPer1, j+13+shift));
                           ind[31] = DoubleToStr(bar_body(symboll, charPer1, j+13+shift));
                           
                           ind[32] = DoubleToStr(bar_type(symboll, charPer1, j+21+shift));
                           ind[33] = DoubleToStr(high_whisk(symboll, charPer1, j+21+shift));
                           ind[34] = DoubleToStr(low_whisk(symboll, charPer1, j+21+shift));
                           ind[35] = DoubleToStr(bar_body(symboll, charPer1, j+21+shift));
                           
                           ind[36] = DoubleToStr(bar_type(symboll, charPer1, j+34+shift));
                           ind[37] = DoubleToStr(high_whisk(symboll, charPer1, j+34+shift));
                           ind[38] = DoubleToStr(low_whisk(symboll, charPer1, j+34+shift));
                           ind[39] = DoubleToStr(bar_body(symboll, charPer1, j+34+shift));
                           
                           
                           for(int i=0;i<ArraySize(ind);i++) data = data + ","+ind[i];   
                           
                           FileWrite(handle,data);   //write data to the file during each for loop iteration
                       }
                     
                     //             
                      FileClose(handle);        //close file when data write is over
                     //---------------------------------------------------------------------------------------------
                 }           
               // ===================================================================================================
               // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               // ===================================================================================================
      
  }


//+------------------------------------------------------------------+
//| End of WriteDataSetRLUnit                                                
//+------------------------------------------------------------------+ 

//+------------------------------------------------------------------+
//| Start of WriteDataSetRLUnitExit
//+------------------------------------------------------------------+ 
void WriteDataSetRLUnitExit(int magic, string foldname, string filename, bool dssInput)
// function to record information about the current open positions and indicators to the file (file to be used by R scripts)
/*
 purpose: build the DRL model in R that will dynamically decide whether to close or keep working trade
 function will write information about the open order since it's opening to it's closure
 this information will be updated at every bar and appended
 such information will be joined with the order result
 final result will be converted to eithe 'keep' or 'close' class and mapped to the previous rows that were generated
 input will also be reinforced by actual profit loss of the system
 information will be used to train the model that will be able to decide whether to keep trades or close them
 
 function will also be handling the real-time data input provided to the model
 r script will run in between of every bar

          parameters to be used [brainstorming]:
- current profit/loss
- distance to TP in pips
- distance to SL in pips
- number of positions opened by this symbol
- time of this order since opening
- some indicators

NOTE: Function will only be activated if there are opened positions for this magic number

*/
 {
  int digits = (int)MarketInfo(Symbol(), MODE_DIGITS);
 double ticks = MarketInfo(Symbol(), MODE_TICKSIZE);
 int nposSELL = CountPosOrders(magic, OP_SELL);
 int nposBUY = CountPosOrders(magic, OP_BUY);
 string rsi32, rsi14, rsi8, profit;  
 int ordTicket, CurrOrderHoldTime,ordTyp;
 string distTP, distSL;
 rsi32 = DoubleToStr(iRSI(Symbol(), 0, 32, PRICE_CLOSE, 1),digits);
 rsi14 = DoubleToStr(iRSI(Symbol(), 0, 14, PRICE_CLOSE, 1),digits);
 rsi8 = DoubleToStr(iRSI(Symbol(), 0, 8, PRICE_CLOSE, 1),digits);
string data;    //identifier that will be used to collect data string
string filepath;

               if(!dssInput)filepath = foldname+"\\"+filename; //dss_input == False creates sub folders with simulation data
               if(dssInput)filepath = filename; //dss_input == True creates files in the sandbox
                 
               // delete file if it's exist
               FileDelete(filepath);
               // open file handle
               int handle = FileOpen(filepath,FILE_CSV|FILE_READ|FILE_WRITE);
                FileSeek(handle,0,SEEK_SET);
               // generate data now using for loop

  
               // ===================================================================================================
               // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               // ===================================================================================================

               if(StringCompare(foldname, "6_06")== 0)
                 {
                    
                    
                    
                    
                    //going through the orders that are opened
                      for(int i=OrdersTotal()-1; i>=0; i--) 
                       {
                        //select opened SELL order and write to the file
                        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true &&
                                        OrderSymbol()==Symbol() &&
                                        OrderMagicNumber()==magic && 
                                        OrderType()==OP_SELL) 
                           {//writing info about such opened order into the file
                             profit  = DoubleToStr(OrderProfit() + OrderSwap() + OrderCommission(),2);  
                                ordTyp  = OrderType();
                                 distTP = DoubleToStr((iOpen(Symbol(), 0, 0)-OrderTakeProfit())/ticks,2);  //in pips
                                 distSL = DoubleToStr((OrderStopLoss()-iOpen(Symbol(), 0, 0))/ticks,2);    //in pips
                               ordTicket  = OrderTicket();
                             CurrOrderHoldTime = int((TimeCurrent() - OrderOpenTime())/60);
                             data = string(profit) + "," + string(ordTyp) + "," + string(nposSELL) + "," + string(nposBUY) + "," +
                                      string(distTP) +"," +string(distSL) +"," +string(ordTicket) +","+string(CurrOrderHoldTime) +"," +
                                      string(rsi32) + "," + string(rsi14) +","+string(rsi8);
                        FileWrite(handle,data);   //write data to the file during each for loop iteration
                             
                             
                             
                            }
                        //select opened BUY order and write to the file
                        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true &&
                                        OrderSymbol()==Symbol() &&
                                        OrderMagicNumber()==magic && 
                                        OrderType()==OP_BUY) 
                           {//writing info about such opened order into the file
                             profit  = DoubleToStr(OrderProfit() + OrderSwap() + OrderCommission(),2);  
                                ordTyp  = OrderType();
                                 distTP = DoubleToStr((OrderTakeProfit()-iOpen(Symbol(), 0, 0))/ticks,2);  //in pips
                                 distSL = DoubleToStr((iOpen(Symbol(), 0, 0)-OrderStopLoss())/ticks,2);    //in pips
                               ordTicket  = OrderTicket();
                             CurrOrderHoldTime = int((TimeCurrent() - OrderOpenTime())/60);
                             data = string(profit) + "," + string(ordTyp) + "," + string(nposSELL) + "," + string(nposBUY) + "," +
                                      string(distTP) +"," +string(distSL) +"," +string(ordTicket) +","+string(CurrOrderHoldTime) +"," +
                                      string(rsi32) + "," + string(rsi14) +","+string(rsi8);
                        FileWrite(handle,data);   //write data to the file during each for loop iteration
                            }
                               
                       }
                     //             
                      FileClose(handle);        //close file when data write is over
                     //---------------------------------------------------------------------------------------------
                 }           
               // ===================================================================================================
               // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               // ===================================================================================================
      
  }


//+------------------------------------------------------------------+
//| End of WriteDataSetRLUnitExit                                                
//+------------------------------------------------------------------+ 