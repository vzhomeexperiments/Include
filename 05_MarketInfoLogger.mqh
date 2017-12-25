//+-------------------------------------------------------------------+
//|                                           05_MarketInfoLogger.mqh |
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
// Aim of this function is to log Market/Inefficiency data to csv file
// Further purpose is to derive regression model and base trading decisions
// using obtained model 
//+-------------------------------------------------------------+//
/*

User guide:
1. #include this file to the folder Include
2. Define parameters inside the EA part:
A. inside Global variables:
//----------------------------------// 
// parameters to use with Lucy 4.0: //
//----------------------------------//
double Par_1, Par_2, Par_3, Par_4, Par_5, Par_6, Par_7, Par_8, Par_9, Par_10; 
string Header; //define a header to manually specify parameter names
// ------------ END ----------------//
B. Initialize those parameters:
   // Parameters to log
   // *** Action *** -> specify the indicators, derived values, etc
   //                   in case parameters are not current symbol only use demo account to derive and record values
   Par_1 = 0;
   Par_2 = 0;
   Par_3 = 0;
   Par_4 = 0;
   Par_5 = 0;
   Par_6 = 0;
   Par_7 = 0;
   Par_8 = 0;
   Par_9 = 0;
   Par_10 = 0;
   
   // Parameters Name: Header = "ParameterName1, ParamterName2, ParmeterName3..."
   Header = "Magic,Ticket,ParameterName1,ParameterName2,ParameterName3,ParameterName4,ParameterName5,ParameterName6,ParameterName7,ParameterName8,ParameterName9,ParameterName10";
            

3. From EA call this function by placing the next code after ticket generation:
         MarketOrderDataToCSV(Ticket, MagicNumber, Header, Par_1, Par_2, Par_3, Par_4, Par_5, Par_6, Par_7, Par_8, Par_9, Par_10);
4. #include file 

*/

//+-------------------------------------------+//
//Function MARKET ORDER DATA LOG TO CSV        //
//+-------------------------------------------+//
void MarketOrderDataToCSV(int ticket, int magic, string header,
                          double Par1, double Par2, double Par3, double Par4, double Par5, 
                          double Par6, double Par7, double Par8, double Par9, double Par10)
{
   //*3*_Logging market info at the moment when trade is opened to the file csv for further order management in R
     static bool isFirstLog = true; // Define flag for writing a header supplied
                   if(isFirstLog) 
                     {
                       string fileName = "MarketOrderData"+string(magic)+".csv";//create the name of the file same for all symbols...
                       // open file handle
                       int handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE);
                                    FileSeek(handle,0,SEEK_END);
                       FileWrite(handle, header);    // Get the column names once!
                       FileClose(handle);        //close file when data write is over
                       isFirstLog = false;
                     }
                   
                   if(!isFirstLog)
                     {
                       // record info to the file csv
                       string fileName = "MarketOrderData"+string(magic)+".csv";//create the name of the file same for all symbols...
                       // open file handle
                       int handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE);
                                    FileSeek(handle,0,SEEK_END);
                       string data = string(magic) + "," + string(ticket) + ","
                       + string(Par1) + "," + string(Par2) + ","
                       + string(Par3) + "," + string(Par4) + ","
                       + string(Par5) + "," + string(Par6) + ","
                       + string(Par7) + "," + string(Par8) + ","
                       + string(Par9) + "," + string(Par10);
                       FileWrite(handle,data);   //write data to the file during each for loop iteration
                       FileClose(handle);        //close file when data write is over
                     }  
}  
      

//+-----------------------------------------------+//
//Function End MARKET ORDER DATA LOG TO CSV        //
//+-----------------------------------------------+//