package com.coltware.airxzip
{
   import flash.events.ErrorEvent;
   
   public class ZipErrorEvent extends ErrorEvent
   {
      
      public static const ZIP_NO_SUCH_METHOD:String = "ZipNoSuchMethod";
      
      public static const ZIP_PASSWORD_ERROR:String = "ZipPasswordError";
      
      public function ZipErrorEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:String = null, param5:int = 0)
      {
         super(param1,param2,param3,param4,param5);
      }
   }
}

