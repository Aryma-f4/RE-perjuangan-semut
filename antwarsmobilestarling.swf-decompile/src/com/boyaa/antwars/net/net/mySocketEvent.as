package com.boyaa.antwars.net.net
{
   import flash.events.Event;
   
   public class mySocketEvent extends Event
   {
      
      public static const CONNECT:String = "connect";
      
      public static const CLOSE:String = "close";
      
      public static const SYNC:String = "sync";
      
      public static const ERROR:String = "error";
      
      public static const SECURITYERROR:String = "securityerror";
      
      public var data:Object;
      
      public function mySocketEvent(param1:String)
      {
         super(param1);
      }
   }
}

