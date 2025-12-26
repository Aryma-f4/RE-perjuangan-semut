package com.boyaa.ane
{
   import flash.events.Event;
   
   public class NCApiEvent extends Event
   {
      
      private var _param:String;
      
      public function NCApiEvent(param1:String, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         _param = param2;
      }
      
      public function getParam() : String
      {
         return _param;
      }
   }
}

