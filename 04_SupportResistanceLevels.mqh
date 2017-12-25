//+-------------------------------------------------------------------+
//|                                    04_SupportResistanceLevels.mqh |
//|                                  Copyright 2016, Vladimir Zhbanko |
//|                                        vladimir.zhbanko@gmail.com |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2016, Vladimir Zhbanko"
#property link      "vladimir.zhbanko@gmail.com"
#property strict
// function to return price levels of Resistance and Support
// version 01
// date 07.08.2016

//+-------------------------------------------------------------+//
//   Text     //
//+-------------------------------------------------------------+//
/*

User guide:
1. #include this file to the folder Include
2. Make sure that chart have HLines ! Both Resistance and Support
3. From EA call function GetLevels and assign variable the price level:
  example: 
   double ResistanceLevel1 = GetLevels(0, "Resistance"); Most closer line
   double ResistanceLevel2 = GetLevels(1, "Resistance"); Least closer line
   
   double SupportLevel1 = GetLevels(0, "Support"); Most closer line
   double SupportLevel2 = GetLevels(1, "Support"); Least closer line    
*/

//+-------------------------------------------+//
//Function GET SUPPORT AND RESISTANCE LEVELS   //
//+-------------------------------------------+//

   // Nota Bene: Required running indicator 01_FindLevels
   
double GetLevels(int index, string levelMode)
   {
   // Declaration of variables
   double PRICE[];                                          // Declaring the array that will containing prices of HLINE object
   double priceResistance[];                                // Array with only Resistance levels
   double priceSupport[];                                   // Array with only Support levels
   int k, numResistance, numSupport;                        // Declaring auxiliary variables
   string Obj_N;                                            
   
   // Initialize variables
   ArrayResize(PRICE, ObjectsTotal());                      // Initializing this array filling values 0 to that
   ArrayResize(priceResistance, ObjectsTotal());            // Set dimension of array by using how many linece that
   ArrayResize(priceSupport, ObjectsTotal());   
   numResistance = 0;                                       // Required for resizing of arrays to exclude extra zeroes
   numSupport = 0;
   
   // Working with objects in the Chart
   for(k = ObjectsTotal() - 1;k >= 0; k--)                  // Starting for loop scrolling through objects
     {
       Obj_N = ObjectName(k);                               // Writing name of object to string
       if(ObjectType(Obj_N) != OBJ_HLINE) continue;         // Checking all objects paying attention only to HLINEs! continue means we continue to the next for loop index
       PRICE[k] = NormalizeDouble(ObjectGet(Obj_N, OBJPROP_PRICE1),Digits); // Saving price to array PRICE[index]. Price we get from function ObjectGet, using property 
                                                                            // OBJPROP_PRICE1 meaning coordinate price Y , while OBJPROP_TIME1 giving coordinate of time X
       // Finding how many element there for Resistance levels as required for sorting and storing the price information
       if(PRICE[k] - Ask > 0) {numResistance++; priceResistance[k] = PRICE[k];}
       if(PRICE[k] - Ask < 0) {numSupport++;    priceSupport[k]    = PRICE[k];}                   
     }

   // Sorting priceResistance Array to find !closest! levels around the price in order
   ArraySort(priceResistance, WHOLE_ARRAY, 0, MODE_DESCEND);             
   ArrayResize(priceResistance, numResistance);
   ArraySort(priceResistance, WHOLE_ARRAY, 0, MODE_ASCEND);    // It's above the Ask Price!
   
   // Sorting priceSupport Array to find !closest! levels around the price in order
   ArraySort(priceSupport, WHOLE_ARRAY, 0, MODE_DESCEND);               
   ArrayResize(priceSupport, numSupport);
      
   // Function should only return 2 arrays back to the user!   
   if(levelMode == "Resistance") return(priceResistance[index]);
   if(levelMode == "Support") return(priceSupport[index]);

   return(0);
   }


//+-----------------------------------------------+//
//Function End GET SUPPORT AND RESISTANCE LEVELS   //
//+-----------------------------------------------+//