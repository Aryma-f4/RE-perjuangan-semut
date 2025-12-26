package com.boyaa.ane
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   
   public class WeiboApi extends EventDispatcher
   {
      
      private var cxt:ExtensionContext = null;
      
      public function WeiboApi(param1:IEventDispatcher = null)
      {
         super(param1);
         cxt = SystemProperties.initExtension();
      }
      
      public function init(param1:String, param2:String, param3:String) : void
      {
         cxt.addEventListener("status",onExtCallBack);
         cxt.call("SWinitWithAppKey",param1,param2,param3);
      }
      
      protected function onExtCallBack(param1:StatusEvent) : void
      {
         dispatchEvent(new NCApiEvent(param1.code,param1.level));
      }
      
      public function login() : void
      {
         cxt.call("SWlogIn");
      }
      
      public function logOut() : void
      {
         cxt.call("SWlogOut");
      }
      
      public function isLoggedIn() : Boolean
      {
         return cxt.call("SWisLoggedIn") as Boolean;
      }
      
      public function isAuthorizeExpired() : Boolean
      {
         return cxt.call("SWisAuthorizeExpired") as Boolean;
      }
      
      public function isAuthValid() : Boolean
      {
         return cxt.call("SWisAuthValid") as Boolean;
      }
      
      public function handleOpenUrl(param1:String) : Boolean
      {
         return cxt.call("SWhandleOpenURL",param1) as Boolean;
      }
      
      public function applicationDidBecomeActive() : void
      {
         cxt.call("SWapplicationDidBecomeActive");
      }
      
      public function requestWithURL(param1:String, param2:String, param3:String = "POST") : void
      {
         cxt.call("SWrequestWithURL",param1,param2,param3);
      }
   }
}

