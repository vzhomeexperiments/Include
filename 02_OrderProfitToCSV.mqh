//+-------------------------------------------------------------------+
//|                                           02_OrderProfitToCSV.mqh |
//|                                  Copyright 2018, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2020, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property strict
// function to write order profits to csv using EA
// version 01
// date 31.07.2016
// version 02 - added order symbol for ticket
// date 25.12.2016
// version 03 - added function DoubleToString
//+-------------------------------------------------------------+//
//Function requires just input of the trade terminal number      //
//+-------------------------------------------------------------+//
/*
This function scroll through the number of previously set orders by function GetHistoryOrderByCloseTime
User guide:
1. Add extern variable to EA: e.g.:                     extern int     TradeTermNumber   = 2;
2. Add function call inside start function to EA: e.g.: OrderProfitToCSV(TradeTermNumber);
3. Add include call to this file  to EAe.g.:            #include <02_OrderProfitToCSV.mqh>
*/
void OrderProfitToCSV(int terminalNumber)
{
   //*3*_Logging closed orders to the file csv for further order management in R
    int  tickets[], nTickets = GetHistoryOrderByCloseTime(tickets, MagicNumber);  // this define dyn. array with tickets, gets ticket num in history
    static int prevAmountTickets = 0;       // variable used for order history logging
    
    for(int iTicket = nTickets - prevAmountTickets - 1; iTicket >= 0; iTicket--)  // starting for loop in order to scroll through each ticket
      {
        if (OrderSelect(tickets[iTicket], SELECT_BY_TICKET))                      // getting ticket number by selecting elements of array
         {
           if (OrderCloseTime() < ReferenceTime ) break;                          // stop scrolling if time of order is less then reference time defined onInit()
                 // recover info needed
                 double  profit  = OrderProfit() + OrderSwap() + OrderCommission();    
                 int     ordTyp  = OrderType();
                 datetime ordOT  = OrderOpenTime();
                 datetime ordCT  = OrderCloseTime();
                 int  ordTicket  = OrderTicket();
                 string ordPair  = OrderSymbol();
                 // record info to the file csv
                 string fileName = "OrdersResultsT"+string(terminalNumber)+".csv";//create the name of the file same for all symbols...
                 // open file handle
                /* int handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_SHARE_READ|FILE_WRITE|FILE_SHARE_WRITE);*/
                 int handle=0; 
                 while( handle==0 || handle==-1 ){handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_SHARE_READ|FILE_WRITE|FILE_SHARE_WRITE);}
                 
                 FileSeek(handle,0,SEEK_END);
   
                 string data = string(MagicNumber) + "," + string(ordTicket) + "," + string(ordOT) + "," + string(ordCT) + ","
                 + DoubleToStr(profit,2)+ ","+ordPair+","+string(ordTyp);
                 FileWrite(handle,data);   //write data to the file during each for loop iteration
                 FileClose(handle);        //close file when data write is over
         }  
      }
          prevAmountTickets = nTickets; //defining previous amount of tickets to avoid double entries!
}
