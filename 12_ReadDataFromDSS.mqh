//+-------------------------------------------------------------------+
//|                                            12_ReadDataFromDSS.mqh |
//|                                  Copyright 2020, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2021, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "1.002"  
#property strict
// function to recieve information from csv files
// version 1.001 initial version
// version 1.002 add fail safe for file reading
//+---------------------------------------------------------------------------------+//
//Universal function to read different numeric files from the Decision Support System//
//+---------------------------------------------------------------------------------+//
/*

Purpose:
Read different numeric values from different files generated by Decision Support System

Parameters:
@param symbol string, specifying the symbol of the asset
@param chart_period int, specifying the chart period
@param mode string, specifying the file type that needs to be read

@options
mode = "read_change"    read predicted price change
mode = "read_trigger"   read optimal trigger value
mode = "read_timehold"  read optimal time hold in hour bars
mode = "read_maxperf"   read achieved model performance value
mode = "read_mt"        read value of market type prediction
mode = "read_mt_conf"   read confidence value of market type prediction
mode = "read_quantile"  read first quantile from all model performances

*/
#define MARKET_NONE 0       //Market not siutable for trading e.g. macroeconomic event or not properly defined
#define MARKET_BUN  1       //Market with bullish character
#define MARKET_BUV  2       //Market with volatile bullish character
#define MARKET_BEN  3       //Market with bearish character
#define MARKET_BEV  4       //Market with volatile bearish character
#define MARKET_RAN  5       //Market with Ranging character
#define MARKET_RAV  6       //Market with volatile Ranging character

double ReadDataFromDSS(string symbol, int chart_period, string mode)
{
/*
- Function reads the file eg: AI_M15_ChangeAUDCAD.csv
- It will output predicted value of asset change
 
*/
   //define internal variables needed
   double output = 0;           //Variable to store and return predicted price change written in the file
   string res = "0";            //Variable to return result of the function
   int handle;
   string str;
   string sep=",";              // A separator as a character 
   ushort u_sep;                // The code of the separator character 
   string f_name;               // File name prefix
   string result[];             // An array to get string elements
   string full_line;            // String reserved for a file string

   if(mode == "read_change")
     {
      
      f_name = "AI_M";
      
      handle=FileOpen(f_name+IntegerToString(chart_period)+"_Change"+symbol+".csv",FILE_READ|FILE_SHARE_READ|FILE_CSV,"@");
      if(handle==-1){Comment("Error - file does not exist"); return(output); } 
      if(FileSize(handle)==0){FileClose(handle); Comment("Error - File AI_M xx is empty"); return(output);}
         
      //this will bring the last element
      while(!FileIsEnding(handle)) { str=FileReadString(handle);  }
         
      FileClose(handle);
      //Interpret the file
      output = StringToDouble(str);
      
      return(output); 
      
      /*tested pass: 
      Read value: ok
      Missing File: ok 
      Empty File: ok
      */
      
      
     }
   
   
   if(mode == "read_trigger" || mode == "read_timehold" || mode == "read_maxperf" || mode == "read_quantile")
     {
      f_name = "StrTest-";
         
      handle=FileOpen(f_name+symbol+"M"+IntegerToString(chart_period)+".csv",FILE_READ|FILE_SHARE_READ|FILE_CSV,"@");
      if(handle==-1){Comment("Error - file does not exist"); return(output); } 
      if(FileSize(handle)==0){FileClose(handle); Comment("Error - File StrTest xx is empty"); return(output); }
         
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
               // extract content of the string array [for better clarify]
               
         }
      FileClose(handle);
      //Interpret the line content
      if(ArraySize(result) != 5) Print("Array size is "+(string)ArraySize(result)+ " but it must be 5!");
      if(mode == "read_trigger" && ArraySize(result) >= 1) {output = StringToDouble(result[0]); return(output);}// test passed?  
      if(mode == "read_timehold" && ArraySize(result) >= 2) {output = StringToDouble(result[1]); return(output);}// test passed?  
      if(mode == "read_maxperf" && ArraySize(result) >= 4) {output = StringToDouble(result[3]); return(output);}// test passed?
      if(mode == "read_quantile" && ArraySize(result) == 5) {output = StringToDouble(result[4]); return(output);}// test passed?

      /*tested pass: read_trigger
      Read value: ok
      Missing File: ok 
      Empty File: ok
      */
      /*tested pass: read_timehold
      Read value: ok
      Missing File:  
      Empty File:
      */
      /*tested pass: read_maxperf
      Read value: ok
      Missing File:  
      Empty File:
      */
      /*tested pass: read_quantile
      Read value: ok
      Missing File:  
      Empty File: ok
      */
     }
     
   if(mode == "read_mt_conf" || mode == "read_mt")
     {
      
      f_name = "AI_MarketType_";
      
      handle=FileOpen(f_name+symbol+IntegerToString(chart_period)+".csv",FILE_READ|FILE_SHARE_READ|FILE_CSV,"@");
      if(handle==-1){Comment("Error - file AI_MarketType_ does not exist"); return(output); } 
      if(FileSize(handle)==0){
               FileClose(handle); Comment("Error - File AI_MarketType_ xx is empty"); 
               Sleep(50);
               handle=FileOpen(f_name+symbol+IntegerToString(chart_period)+".csv",FILE_READ|FILE_SHARE_READ|FILE_CSV,"@");
               if(FileSize(handle)==0)
                 {
                  FileClose(handle);
                  Comment("Tried 2 times but File AI_MarketType_ xx is empty");
                  return(output);
                 }
               }
         
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
            // extract content of the string array [for better clarify]
            
              
   
      }
      FileClose(handle);
      
         if(mode == "read_mt_conf") {output = StringToDouble(result[1]); return(output);}
         if(mode == "read_mt") 
                 { 
                  //Assign market variable based on result
                  if(result[0] == "1" || result[0] == "BUN"){output = MARKET_BUN; return(output); }
                  else if(result[0] == "2" || result[0] == "BUV"){output = MARKET_BUV; return(output); }
                  else if(result[0] == "3" || result[0] == "BEN"){output = MARKET_BEN; return(output); }
                  else if(result[0] == "4" || result[0] == "BEV"){output = MARKET_BEV; return(output); }
                  else if(result[0] == "5" || result[0] == "RAN"){output = MARKET_RAN; return(output); }
                  else if(result[0] == "6" || result[0] == "RAV"){output = MARKET_RAV; return(output); }
                  else {output = MARKET_NONE; return(output);}
                 }
      
      /*tested pass:  read_mt_conf
      Read value: ok
      Missing File:  ok
      Empty File: ok
      */
      /*tested pass: read_mt
      Read value: ok
      Missing File:  
      Empty File:
      */
      
      
     }  
   
   
      
 return(output);
 
} 


/*Function to read files from DSS and create boolean output

Parameters:
@param symbol string, specifying the symbol of the asset
@param chart_period int, specifying the chart period
@param mode string, specifying the file type that needs to be read

@options
mode = "read_rlpolicy"    read Reinforcement Learning Policy
mode = "read_command"    read system control command


*/
bool BoolReadDataFromDSS(int magic, int MT, string mode)
{

//Declaring variables
int handle;      
bool output = False;
string str, mt_val;
string sep=",";                // A separator as a character 
ushort u_sep;    // The code of the separator character 
string full_line, elem1, elem2;
string f_name;               // File name prefix
string result[]; // An array to get strings 

if(mode == "read_rlpolicy")
     {
      
      f_name = "SystemControlMT";
      
      // interpret MarketType information and define a string element for comparison
      if(MT == 1){mt_val = "BUN"; }
      if(MT == 2){mt_val = "BUV"; }
      if(MT == 3){mt_val = "BEN"; }
      if(MT == 4){mt_val = "BEV"; }
      if(MT == 5){mt_val = "RAN"; }
      if(MT == 6){mt_val = "RAV"; }

      // open the file   
      handle=FileOpen(f_name+string(magic)+".csv",FILE_READ|FILE_CSV,"@");

      // fail safe mechanism
      if(handle==-1){Comment("Error - file SystemControlMTxx does not exist"); return(output);} 
      if(FileSize(handle)==0){
         FileClose(handle); Comment("Error - File SystemControlMTxx is empty"); 
         Sleep(50);
          handle=FileOpen(f_name+string(magic)+".csv",FILE_READ|FILE_CSV,"@");
         if(FileSize(handle)==0)
           {
            FileClose(handle);
            Comment("Tried 2 times but File AI_MarketType_ xx is empty");
            return(output);
           }
         }

      

   // analyse the content of each string line by line
   while(!FileIsEnding(handle))
   {
   str=FileReadString(handle); //storing content of the current line
   
      //defines variables for this operation
      
      
      //full current line
      full_line = StringSubstr(str,0);
      //--- Get the separator code 
      u_sep=StringGetCharacter(sep,0); 
      //--- Split the string to substrings and store to the array result[] 
      int k = StringSplit(str,u_sep,result); 
      // extract content of the string array [for better clarify]
      elem1 = result[0];
      elem2 = result[1];
      // check if current element is corresponding to the market type we are checking
      if(elem1 == mt_val)
        {
          // analyse the second element [policy], convert to boolean and return the result
          if(elem2 == "ON")  output = True;  
          if(elem2 == "OFF") output = False;
          FileClose(handle);
          //in case file will not contain desired market type symbols function will still return false
          return(output); 
          
           
        }
  
   }
   FileClose(handle);


      /*tested pass: 
      Read value: 
      Missing File:  
      Empty File:
      */


     }
   if(mode == "read_command")
     {
      f_name = "SystemControl";
      
      // open the file   
      handle=FileOpen(f_name+string(magic)+".csv",FILE_READ|FILE_CSV,"@");

      // fail safe mechanism
      if(handle==-1){Comment("Error - file SystemControl xx does not exist"); return(output);} 
      if(FileSize(handle)==0){
         FileClose(handle); Comment("Error - File SystemControlxx is empty"); 
         Sleep(50);
          handle=FileOpen(f_name+string(magic)+".csv",FILE_READ|FILE_CSV,"@");
         if(FileSize(handle)==0)
           {
            FileClose(handle);
            Comment("Tried 2 times but File SystemControlxx_ xx is empty");
            return(output);
           }
         }
      
         // analyse the content of each string line by line
         while(!FileIsEnding(handle))
         {
         str=FileReadString(handle); //storing content of the current line
         
            //defines variables for this operation
            
            
            //full current line
            full_line = StringSubstr(str,0);
            //--- Get the separator code 
            u_sep=StringGetCharacter(sep,0); 
            //--- Split the string to substrings and store to the array result[] 
            int k = StringSplit(str,u_sep,result); 
            // extract content of the string array [for better clarify]
            elem1 = result[0];
            elem2 = result[1];
            // check if current element is corresponding to the market type we are checking
            if(elem1 == (string)magic)
              {
                // analyse the second element [policy], convert to boolean and return the result
                if(elem2 == "1")  output = True;  
                if(elem2 == "0") output = False;
                FileClose(handle);
                //in case file will not contain desired market type symbols function will still return false
                return(output); 
                
                 
              }
        
         }
         FileClose(handle);
      
      /*tested pass: 
      Read value: ok
      Missing File: ok 
      Empty File: ok
      */
      
     }
   //in case file will not contain desired market type symbols function will still return false
   return(output); 

}


/*Function to read files from DSS and create string output

Parameters:
@param mode string, specifying the file type that needs to be read

@options
mode = "read_dss_input"    read value of best input folder to use

*/
string StringReadDataFromDSS(string mode)
{

//Declaring variables
int handle;      
string output = "0_00";
string str, mt_val;
string sep=",";                // A separator as a character 
string full_line, elem1, elem2;
string f_name;               // File name prefix
string result[]; // An array to get strings 

if(mode == "read_dss_input")
     {
      
      f_name = "AccountBestInput";
      
      // open the file   
      handle=FileOpen(f_name+".csv",FILE_READ|FILE_SHARE_READ|FILE_CSV,"@");

      // fail safe mechanism
      if(handle==-1){Comment("Error - file AccountBestInput does not exist"); return(output);} 
      if(FileSize(handle)==0){
         FileClose(handle); Comment("Error - File AccountBestInput is empty"); 
         Sleep(50);
          handle=FileOpen(f_name+".csv",FILE_READ|FILE_SHARE_READ|FILE_CSV,"@");
         if(FileSize(handle)==0)
           {
            FileClose(handle);
            Comment("Tried 2 times but File AccountBestInput is empty");
            return(output);
           }
         }

      

   // analyse the content of each string line by line
   while(!FileIsEnding(handle))
   {
   output=FileReadString(handle); //storing content of the last line
     
   }
   FileClose(handle);


      /*tested pass: 
      Read value: ok
      Missing File: ok 
      Empty File: ok
      */


     }
      

   //in case file will not contain desired market type symbols function will still return "0_00"
   return(output); 

}