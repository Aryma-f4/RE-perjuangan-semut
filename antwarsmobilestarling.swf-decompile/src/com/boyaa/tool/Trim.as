package com.boyaa.tool
{
   public class Trim
   {
      
      private static var REMOVE_BLANK:RegExp = /^\s+|\s+$/g;
      
      public function Trim()
      {
         super();
      }
      
      public static function trim(param1:String) : String
      {
         return param1.replace(REMOVE_BLANK,"");
      }
   }
}

