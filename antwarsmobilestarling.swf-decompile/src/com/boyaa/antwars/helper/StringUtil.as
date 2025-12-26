package com.boyaa.antwars.helper
{
   public class StringUtil
   {
      
      public function StringUtil()
      {
         super();
      }
      
      public static function getQueryStringVar(param1:String, param2:String) : String
      {
         var _loc4_:Array = null;
         if(!param1)
         {
            return "";
         }
         var _loc3_:Array = param1.split("&");
         for(var _loc5_ in _loc3_)
         {
            _loc4_ = _loc3_[_loc5_].split("=");
            if(_loc4_[0] == param2)
            {
               return _loc4_[1];
            }
         }
         return "";
      }
      
      public static function trim(param1:String) : String
      {
         return param1.replace(/^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm,"$2");
      }
   }
}

