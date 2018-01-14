//+------------------------------------------------------------------+
//|                                           01_GetHistoryOrder.mqh |
//|                                 Copyright 2018, Vladimir Zhbanko |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property strict
// function to handle history in EA's
// source: https://www.mql5.com/en/forum/138127

//+---------------------------------------------------+//
//Function returning n of orders in history            //
//+---------------------------------------------------+//
/*
This function goes to the past orders and finds the number of closed orders in the history
It returns the number of orders in the history that will be used for the caller variable
User guide:
1. Add extern variable to EA: e.g.:                     extern int     MagicNumber   = 6100100;
2. Add global variable to EA: e.g.:                     datetime ReferenceTime;
3. Add code inside init() function e.g.:                ReferenceTime = TimeCurrent(); 
4. Add function call inside start function to EA: e.g.: OrderProfitToCSV(TradeTermNumber);
5. Add include call to this file  to EAe.g.:            #include <01_HistoryFunction.mqh>
6. Add include call to this file  to EAe.g.:            #include <02_OrderProfitToCSV.mqh>


*/
int GetHistoryOrderByCloseTime(int& tickets[], int Magic, int dsc=1){  #define ASCENDING -1
    /* https://forum.mql4.com/46182 zzuegg says history ordering "is not reliable
     * (as said in the doc)" [not in doc] dabbler says "the order of entries is
     * mysterious (by actual test)" */
    int nOrders = 0, iOrders;    datetime OCTs[];                                   // defining needed variables
    for (int iPos=OrdersHistoryTotal()-1; iPos >= 0; iPos--)                        // for loop to scrol through all positions in history
       {
          if (OrderSelect(iPos, SELECT_BY_POS, MODE_HISTORY) &&                     // Only orders w/
              OrderMagicNumber()  == Magic &&                                       // my magic number
              OrderType()         <= OP_SELL)                                       // Avoid cr/bal forum.mql4.com/32363#325360
             {
                int      nextTkt = OrderTicket();                                   // Once the ticket is selected we save it's number to nextTkt var
                datetime nextOCT = OrderCloseTime();                                // We also select the time this order was closed
                nOrders++;                                                          // Our objective was to have number of orders done by this EA...
                ArrayResize(tickets,nOrders);                                       // Increase array size containing the tickets numbers
                ArrayResize(OCTs,nOrders);                                          // Increase array size containing the tickets close timings
                  for (iOrders = nOrders - 1; iOrders > 0; iOrders--)               // This for loop need to manipulate through the "previous" ticket
                     {  // Insertn sort.
                          datetime    prevOCT     = OCTs[iOrders-1];                // Define the time when previous order was closed using the info from array
                          if ((prevOCT - nextOCT) * dsc >= 0)     break;            // interrupt when we deal with the order that is last one
                          int  prevTkt = tickets[iOrders-1];                        // Define the previous ticket number using info from array
                          tickets[iOrders] = prevTkt;                               // Save ticket number to array
                          OCTs[iOrders]    = prevOCT;                               // Save ticket time to array
                     }
                tickets[iOrders] = nextTkt;                                         // Finally insert the next ticket number
                OCTs[iOrders] = nextOCT;                                            // Insert the next ticket close time
             }
       }            
    return(nOrders); 
}

