package com.boyaa.tool
{
   import flash.utils.getTimer;
   
   public class SysTime
   {
      
      private static var _sysTime:Number = 0;
      
      private static var _delayTime:Number = 0;
      
      public function SysTime()
      {
         super();
      }
      
      public static function getSysTime() : Number
      {
         var _loc1_:Number = NaN;
         switch(Constants.lanVersion - 2)
         {
            case 0:
            case 2:
               _loc1_ = getTimer() / 1000 - 3600;
               break;
            default:
               _loc1_ = getTimer() / 1000;
         }
         return _sysTime + _loc1_ - _delayTime;
      }
      
      public static function setSysTime(param1:Number) : void
      {
         _sysTime = param1;
      }
      
      public static function setDelayTime(param1:Number) : void
      {
         _delayTime = param1;
      }
   }
}

