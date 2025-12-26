package com.boyaa.antwars.view.login
{
   import com.adobe.crypto.MD5;
   import com.boyaa.debug.Logging.LevelLogger;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import org.osflash.signals.Signal;
   
   public class DeviceLogin
   {
      
      public var loginStartSignal:Signal;
      
      public var loginCompleteSignal:Signal;
      
      public function DeviceLogin()
      {
         super();
         loginStartSignal = new Signal();
         loginCompleteSignal = new Signal(uint,String);
      }
      
      public function login() : void
      {
         var _loc3_:String = "a55848a8c55ecfb02c9a64e9ed48cb37";
         var _loc5_:String = "test";
         var _loc2_:URLLoader = new URLLoader();
         var _loc4_:URLRequest = new URLRequest(Constants.DeviceLoginURL);
         var _loc1_:URLVariables = new URLVariables();
         _loc4_.data = _loc1_;
         _loc4_.method = "POST";
         _loc1_.sid = _loc3_;
         _loc1_.name = _loc5_;
         _loc1_.sign = MD5.hash(_loc1_.sid + _loc1_.name + "fcc2f629-817b-4955-94be-ba1da73b3164");
         _loc2_.addEventListener("complete",loginLoaderComplete);
         _loc2_.load(_loc4_);
         loginStartSignal.dispatch();
      }
      
      private function loginLoaderComplete(param1:Event) : void
      {
         var _loc3_:String = param1.currentTarget.data as String;
         LevelLogger.getLogger("DeviceLogin").info(_loc3_);
         var _loc2_:Object = JSON.parse(_loc3_);
         loginCompleteSignal.dispatch(parseInt(_loc2_.data.mid),_loc2_.data.key + "");
      }
   }
}

