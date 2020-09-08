//+-------------------------------------------------------------------+
//|                                               18_EmailFromMT4.mqh |
//|                                  Copyright 2020, Vladimir Zhbanko |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2020, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property strict
// function to send email from the terminal
// version 01
// date 14.08.2020

//+-------------------------------------------------------------+//
// Aim of this function is to send email from the terminal
// do that weekly to check health of the system
//+-------------------------------------------------------------+//
/*
Function Functional Description:
Function is intended to fire email to the trader to reflect health of the terminal
1. Maintain un-secure google account
2. Confirm that the terminal work
3. To be used from the Watchdog EA

User guide:
1. #include this file to the folder Include
2. That function must be activated weekly on Monday Morning

*/

//+------------------------------------------------------------------+
//| FUNCTION EMAIL FROM MT4
//+------------------------------------------------------------------+
void EmailFromMT4(int Magic)
  {

      bool mailres = SendMail("Weekly Terminal Check",
                              "Hello,\n"
                              "If you recieve this email it means that MT4 Trading terminal works fine! \n"
                              "Server Time is :" + TimeToString(TimeCurrent()) + "\n"
                              "MagicNumber of sending Robot is: " + IntegerToString(Magic));
          if(mailres == false)
            {
             Alert("Error sending email");
            }

  }
//+------------------------------------------------------------------+
//| End of FUNCTION EMAIL FROM MT4                                        
//+------------------------------------------------------------------+