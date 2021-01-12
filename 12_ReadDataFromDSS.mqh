//+-------------------------------------------------------------------+
//|                                            12_ReadDataFromDSS.mqh |
//|                                  Copyright 2020, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2020, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "1.001"  
#property strict
// function to recieve information from csv files
// version 1.001 date 05.09.2020
//
//+---------------------------------------------------------------------------------+//
//Universal function to read different numeric files from the Decision Support System//
//+---------------------------------------------------------------------------------+//
/*



User guide:
1. Add global variable to EA: e.g.:                     double    AIPriceTriggerPredictionH1;
2. Add function call inside start function to EA: e.g.: AIPriceTriggerPredictionH1 = ReadPriceChangeTriggerFromAI(predictor_periodH1);
3. Adapt Trading Robot conditions to change trading strategy parameters eg.: see Falcon_C
4. Add include call to this file  to EAe.g.:            #include <12_ReadDataFromDSS.mqh>

Parameters:
@param symbol string, specifying the symbol of the asset
@param chart_period int, specifying the chart period
@param mode string, specifying the file type that needs to be read

@options
mode = "read_change"    read predicted price change
mode = "read_trigger"   read optimal trigger value
mode = "read_timehold"  read optimal time hold in hour bars
mode = "read_maxperf"   read achieved model performance value
mode = "read_mt_conf"   read confidence value of market type prediction
mode = "read_quantile"  read first quantile from all model performances

*/
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
      
      
         handle=FileOpen(f_name+IntegerToString(chart_period)+"_Change"+symbol+".csv",FILE_SHARE_READ|FILE_CSV,"@");
      if(handle==-1){Comment("Error - file does not exist"); str = "-1"; } 
      if(FileSize(handle)==0){FileClose(handle); Comment("Error - File is empty"); }
         
          //this will bring the last element
         while(!FileIsEnding(handle)) { str=FileReadString(handle);  }
         
         FileClose(handle);
      //Interpret the file
      if(str == "-1"){output = StringToDouble(str); return(output); } //in anomalous case function will return error '-1'
      else
        {
         output = StringToDouble(str);
        }
      return(output); 
      
      
      //tested pass: OK      
      
      
     }
   
   
   if(mode == "read_trigger" || mode == "read_timehold" || mode == "read_maxperf" || mode == "read_quantile")
     {
      f_name = "StrTest-";
         
      handle=FileOpen(f_name+symbol+"M"+IntegerToString(chart_period)+".csv",FILE_SHARE_READ|FILE_CSV,"@");
      if(handle==-1){Comment("Error - file does not exist"); str = "-1"; } 
      if(FileSize(handle)==0){FileClose(handle); Comment("Error - File is empty"); }
         
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
      //Interpret the file
      if(mode == "read_trigger") // test passed?  OK ;
        {
         if(result[0] == "-1"){output = StringToDouble(str); return(output); } //in anomalous case function will return error '-1'
         else output = StringToDouble(result[0]);
        }
      else if(mode == "read_timehold") // test passed?  OK ;
        {
         if(result[1] == "-1"){output = StringToDouble(str); return(output); } //in anomalous case function will return error '-1'
         else output = StringToDouble(result[1]);
        }
      else if(mode == "read_maxperf") // test passed?  OK ;
        {
         if(result[3] == "-1"){output = StringToDouble(str); return(output); } //in anomalous case function will return error '-1'
         else output = StringToDouble(result[3]);
        }
      else if(mode == "read_quantile") // test passed? OK  ;
        {
         if(result[4] == "-1"){output = StringToDouble(str); return(output); } //in anomalous case function will return error '-1'
         else output = StringToDouble(result[4]);
        }
       
      
      
     }
     
   if(mode == "read_mt_conf")
     {
      
      f_name = "AI_MarketType_";
      
      
         handle=FileOpen(f_name+symbol+IntegerToString(chart_period)+".csv",FILE_SHARE_READ|FILE_CSV,"@");
      if(handle==-1){Comment("Error - file does not exist"); str = "-1"; } 
      if(FileSize(handle)==0){FileClose(handle); Comment("Error - File is empty"); }
         
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
      
         if(result[0] == "-1"){output = StringToDouble(str); return(output); } //in anomalous case function will return error '-1'
         else if(result[0] == "BUN" ||
                 result[0] == "BUV" ||
                 result[0] == "BEN" ||
                 result[0] == "BEV" ||
                 result[0] == "RAN" ||
                 result[0] == "RAV") output = StringToDouble(result[1]);
      
      //tested pass: Ok
      
      
     }  
   
   
      
 return(output);
 
} 

