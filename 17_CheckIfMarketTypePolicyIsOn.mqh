//+-------------------------------------------------------------------+
//|                                17_CheckIfMarketTypePolicyIsOn.mqh |
//|                                  Copyright 2018, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2018, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property strict
// function to recieve and analyse Reinforcement Learning Policy derived by Decision Support System
// version 01 date 17.09.2018

//+-------------------------------------------------------------+//
//Function requires       //
//+-------------------------------------------------------------+//
/*
User guide:
1. Define variable bool isMarketTypePolicyON. it should be True by default
2. Use this code to get the function result isMarketTypePolicyON = CheckIfMarketTypePolicyIsOn(MagicNumber, MyMarketType);
   only apply this code in case TerminalType is 0 meaning this working under supervision of Reinforcement learning policy
3. Add variable isMarketTypePolicyON as a condition to open orders into EA

*/
bool CheckIfMarketTypePolicyIsOn(int Magic, int MT)
{
/*
- Function reads the file SystemControlMTMagicNumber.csv. This file must contain RL model policy
- .. getting the current market type information from EA in the variable MT
- .. reading the RL model policy line by line
- .. splitting the string
- .. checking if the separated elements containing the same Market Type as in variable MT
- .. if yes they will look for the second element 
 
*/
//Declaring variables
int handle;      
bool MTPolicyIsOn = False;
string str, word1, word2, mt_val;
string sep=",";                // A separator as a character 
ushort u_sep;    // The code of the separator character 
string full_line, elem1, elem2;
string result[]; // An array to get strings 

// interpret MarketType information and define a string element for comparison
   if(MT == 0){mt_val = "NONE";}
   if(MT == 1){mt_val = "BUN"; }
   if(MT == 2){mt_val = "BUV"; }
   if(MT == 3){mt_val = "BEN"; }
   if(MT == 4){mt_val = "BEV"; }
   if(MT == 5){mt_val = "RAN"; }
   if(MT == 6){mt_val = "RAV"; }

// open the file   
handle=FileOpen("SystemControlMT"+string(Magic)+".csv",FILE_READ|FILE_CSV,"@");

// fail safe mechanism
if(handle==-1){Comment("Error - file does not exist"); MTPolicyIsOn = TRUE; } 
if(FileSize(handle)==0){FileClose(handle); Comment("Error - File is empty");  }
   
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
          if(elem2 == "ON")  MTPolicyIsOn = True;  return(MTPolicyIsOn);
          if(elem2 == "OFF") MTPolicyIsOn = False; return(MTPolicyIsOn);
        }
  
   }
   FileClose(handle);
   //in case file will not contain desired market type symbols function will still return false
   return(MTPolicyIsOn); 
} 