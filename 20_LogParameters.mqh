//+-------------------------------------------------------------------+
//|                                              20_LogParameters.mqh |
//|                                  Copyright 2018, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2024, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "1.001"  
#property strict
// function to record robot parameters to csv
// logs will be done at the moment of opening trades
// version 1.001 date 30.05.2024
 
//+-------------------------------------------------------------+//
//Function requires parameter input at the moment of trade opening
//+-------------------------------------------------------------+//
/*

example parameters from Falcon_D

extern int     StartHour                        = 10; 
extern int     MinPipLimit                      = 0;
extern bool    UseMAFilter                      = True;
extern int     FastMAPeriod                     = 1;
extern int     SlowMAPeriod                     = 950;
extern int     RSI_NoBuyFilter                  = 70;
extern int     RSI_NoSellFilter                 = 30;
extern int     TimeMaxHold                      = 1440; //max order close time in minutes
extern bool    Buy_True                         = True;
extern bool    Sell_True                        = True;

*/
void LogParameters(int magic, int order, datetime ordopentime,
                   int par1, int par2,
                   bool par3,
                   int par4, int par5, int par6, int par7, int par8,
                   bool par9, bool par10)
{
/*
- Function creates the file eg: ParemeterLog8134201.csv
- File will contain Order Number, Magic Number and parameters
*/
   
string fileName = "ParameterLog"+string(magic)+".csv";
// open file handle
int handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE);   
             FileSeek(handle,0,SEEK_END);
string data = string(magic) + "," + string(order) + "," + string(ordopentime)+ "," + string(par1)
+ "," + string(par2)
+ "," + string(par3)
+ "," + string(par4)
+ "," + string(par5)
+ "," + string(par6)
+ "," + string(par7)
+ "," + string(par8)
+ "," + string(par9)
+ "," + string(par10);
FileWrite(handle,data);   //write data to the file during each for loop iteration
FileClose(handle);        //close file when data write is over


}
