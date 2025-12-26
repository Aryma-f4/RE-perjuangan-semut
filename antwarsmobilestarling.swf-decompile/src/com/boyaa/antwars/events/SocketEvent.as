package com.boyaa.antwars.events
{
   import flash.events.Event;
   
   public class SocketEvent extends Event
   {
      
      public static const CONNECT_SUCCESS:String = "ConnectSuccess";
      
      public static const CONNECT_FAILED:String = "ConnectFailed";
      
      public static const ONLINE_FRIENDLIST:String = "OnlineFriendList";
      
      public static const UNION_ONLINE_PLAYERS:String = "unionOnlinePlayers";
      
      public static const UN_REQUEST_FRIEND:String = "UN_REQUEST_FRIEND";
      
      private var _param:Object = null;
      
      public function SocketEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         _param = param2;
         super(param1,param3,param4);
      }
      
      override public function clone() : Event
      {
         return new SocketEvent(type,param,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("SocketEvent","param","type","bubbles","cancelable","eventPhase");
      }
      
      public function get param() : Object
      {
         return _param;
      }
   }
}

