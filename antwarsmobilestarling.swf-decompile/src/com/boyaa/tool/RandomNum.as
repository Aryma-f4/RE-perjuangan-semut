package com.boyaa.tool
{
   public class RandomNum
   {
      
      private static var _next:int;
      
      public function RandomNum()
      {
         super();
      }
      
      public static function myrand(param1:int, param2:int) : int
      {
         _next = _next * 1103515245 + 12345;
         var _loc3_:int = param2 - param1 + 1;
         return uint(_next / 65536) % _loc3_ + param1;
      }
      
      public static function setNext(param1:int) : void
      {
         _next = param1;
      }
   }
}

