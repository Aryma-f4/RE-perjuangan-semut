package com.freshplanet.ane.AirFacebook
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   
   public class Facebook extends EventDispatcher
   {
      
      private static var _instance:Facebook;
      
      public function Facebook()
      {
         super();
      }
      
      public static function getInstance() : Facebook
      {
         if(!_instance)
         {
            _instance = new Facebook();
         }
         return _instance;
      }
      
      public static function isSupported() : Boolean
      {
         return false;
      }
      
      public function init(param1:String, param2:Boolean = true) : void
      {
      }
      
      public function closeSessionAndClearTokenInformation() : void
      {
      }
      
      public function get isSessionOpen() : Boolean
      {
         return false;
      }
      
      public function get accessToken() : String
      {
         return null;
      }
      
      public function get expirationTimestamp() : Number
      {
         return 0;
      }
      
      public function openSessionWithReadPermissions(param1:Array, param2:Function = null) : void
      {
      }
      
      public function openSessionWithPublishPermissions(param1:Array, param2:Function = null) : void
      {
      }
      
      public function requestWithGraphPath(param1:String, param2:Object = null, param3:String = "GET", param4:Function = null) : void
      {
      }
      
      public function dialog(param1:String, param2:Object = null, param3:Function = null) : void
      {
      }
      
      public function logEvent(param1:String, param2:Object = null) : void
      {
      }
   }
}
