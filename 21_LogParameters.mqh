//+-------------------------------------------------------------------+
//|                                              20_LogParameters.mqh |
//|                                  Copyright 2018, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2024, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "1.002"  
#property strict
// function to record robot parameters to csv
// logs will be done at the moment of opening trades
// version 1.001 date 30.05.2024
// version 1.002 date 21.07.2024 - log only 4 integers values
 
//+-------------------------------------------------------------+//
//Function requires parameter input at the moment of trade opening
//+-------------------------------------------------------------+//
/*

example parameters from DSS_Bot_Rule


# This is a typical log for the #Strategy57

extern int     SlowMAPer                        = 70;   //Moving Average, default 150 for M15
extern double  VolBasedSLMultiplier             = 8; // Stop Loss Amount in units of Volatility
extern double  VolBasedTPMultiplier             = 8; // Take Profit Amount in units of Volatility

*/
void LogParametersS57(int magic, int order, datetime ordopentime,
                   int par1, 
                   double par2, double par3)
{
/*
- Function creates the file eg: ParemeterLog8134201.csv
- File will contain Order Number, Magic Number and parameters
*/
   
string fileName = "ParameterLog"+string(magic)+".csv";
// open file handle
int handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE);   
             FileSeek(handle,0,SEEK_END);
string data = string(magic) + "," + string(order) + "," + string(ordopentime)
+ "," + string(par1)
+ "," + string(par2)
+ "," + string(par3);
FileWrite(handle,data);   //write data to the file during each for loop iteration
FileClose(handle);        //close file when data write is over


}

/*

example parameters from DSS_Bot_Rule


# This is a typical log for the #Strategy58
extern int     SlowMAPer                        = 70;   //Moving Average, default 150 for M15
extern int     RSIPer                           = 14;   //Oscillator value, typical 14 
extern double  VolBasedSLMultiplier             = 8; // Stop Loss Amount in units of Volatility
extern double  VolBasedTPMultiplier             = 8; // Take Profit Amount in units of Volatility

*/
void LogParametersS58(int magic, int order, datetime ordopentime,
                   int par1, int par2,
                   double par3, double par4)
{
/*
- Function creates the file eg: ParemeterLog8134201.csv
- File will contain Order Number, Magic Number and parameters
*/
   
string fileName = "ParameterLog"+string(magic)+".csv";
// open file handle
int handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE);   
             FileSeek(handle,0,SEEK_END);
string data = string(magic) + "," + string(order) + "," + string(ordopentime)
+ "," + string(par1)
+ "," + string(par2)
+ "," + string(par3)
+ "," + string(par4);
FileWrite(handle,data);   //write data to the file during each for loop iteration
FileClose(handle);        //close file when data write is over


}

/*

example parameters from DSS_Bot_Rule


# This is a typical log for the #Strategy46
extern int     FastMAPer                        = 14;  //Moving Average, default 14 for M15
extern int     SlowMAPer                        = 70;   //Moving Average, default 150 for M15
extern int     KeltnerPer                       = 20;  //Keltner Channel Mov.Average Period, default 20
extern double  KeltnerMul                       = 2;   //Keltner Channel Multiplier, default 2
extern double  VolBasedSLMultiplier             = 8; // Stop Loss Amount in units of Volatility
extern double  VolBasedTPMultiplier             = 8; // Take Profit Amount in units of Volatility

*/
void LogParametersS46(int magic, int order, datetime ordopentime,
                   int par1, int par2,int par3,
                   double par4, double par5, double par6)
{
/*
- Function creates the file eg: ParemeterLog8134201.csv
- File will contain Order Number, Magic Number and parameters
*/
   
string fileName = "ParameterLog"+string(magic)+".csv";
// open file handle
int handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE);   
             FileSeek(handle,0,SEEK_END);
string data = string(magic) + "," + string(order) + "," + string(ordopentime)
+ "," + string(par1)
+ "," + string(par2)
+ "," + string(par3)
+ "," + string(par4)
+ "," + string(par5)
+ "," + string(par6);
FileWrite(handle,data);   //write data to the file during each for loop iteration
FileClose(handle);        //close file when data write is over


}



/*

example parameters from DSS_Bot_Rule

# This is a typical log for the #Strategy77 - Supply and Demand


// int FastMAPer - variable for a Num bars pattern (4 or 5)
// int RSIPer - variable for a pattern size in pips (15-20-25)
// int KeltnerPer - variable for a FVG size in pips (3-5-7)
extern double  VolBasedSLMultiplier             = 8; // Stop Loss Amount in units of Volatility
extern double  VolBasedTPMultiplier             = 8; // Take Profit Amount in units of Volatility

*/
void LogParametersS77(int magic, int order, datetime ordopentime,
                   int par1, int par2,int par3,
                   double par4, double par5)
{
/*
- Function creates the file eg: ParemeterLog8177201.csv
- File will contain Order Number, Magic Number and parameters
*/
   
string fileName = "ParameterLog"+string(magic)+".csv";
// open file handle
int handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE);   
             FileSeek(handle,0,SEEK_END);
string data = string(magic) + "," + string(order) + "," + string(ordopentime)
+ "," + string(par1)
+ "," + string(par2)
+ "," + string(par3)
+ "," + string(par4)
+ "," + string(par5);
FileWrite(handle,data);   //write data to the file during each for loop iteration
FileClose(handle);        //close file when data write is over


}
