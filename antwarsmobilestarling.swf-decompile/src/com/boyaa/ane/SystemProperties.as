package com.boyaa.ane
{
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   
   public class SystemProperties
   {
      
      private static const EXTENSION_ID:String = "com.boyaa.ane";
      
      private static var context:ExtensionContext = null;
      
      public function SystemProperties()
      {
         super();
      }
      
      public static function initExtension() : ExtensionContext
      {
         if(!context)
         {
            context = ExtensionContext.createExtensionContext("com.boyaa.ane",null);
         }
         return context;
      }
      
      public static function getOpenUDID() : String
      {
         initExtension();
         return context.call("getOpenUDID") as String;
      }
      
      public static function getMacAddress(param1:String) : String
      {
         initExtension();
         return context.call("getMacAddress",param1) as String;
      }
      
      public static function getDeviceName() : String
      {
         initExtension();
         return context.call("getDeviceName") as String;
      }
      
      public static function boyaaPay(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String) : void
      {
         initExtension();
         context.call("BoyaaPay",param1,param2,param3,param4,param5,param6,param7);
      }
      
      public static function boyaaLogin(param1:String, param2:String, param3:String, param4:String, param5:Function) : void
      {
         var appkey:String = param1;
         var appsecret:String = param2;
         var appname:String = param3;
         var applogo:String = param4;
         var callback:Function = param5;
         initExtension();
         context.addEventListener("status",(function():*
         {
            var onExtCallBack:Function;
            return onExtCallBack = function(param1:StatusEvent):void
            {
               trace("ANEEvent ",param1.code," ",param1.level);
               if(param1.code == "BoyaaLoginEvent")
               {
                  context.removeEventListener("status",onExtCallBack);
                  trace("BoyaaLoginEvent");
                  callback(param1.level);
                  param1.stopImmediatePropagation();
               }
            };
         })());
         context.call("BoyaaLogin",appkey,appsecret,appname,applogo);
      }
      
      public static function boyaaLogout() : void
      {
         initExtension();
         context.call("BoyaaLogout");
      }
      
      public static function appotaInit(param1:String, param2:String, param3:String, param4:String, param5:Function) : void
      {
         var configUrl:String = param1;
         var noticeUrl:String = param2;
         var apiKey:String = param3;
         var sandboxApiKey:String = param4;
         var callback:Function = param5;
         initExtension();
         context.call("AppotaGameInit",configUrl,noticeUrl,apiKey,sandboxApiKey);
         context.addEventListener("status",(function():*
         {
            var onExtCallBack:Function;
            return onExtCallBack = function(param1:StatusEvent):void
            {
               if(param1.code == "AppotaLoginEvent" || param1.code == "AppotaLogoutEvent" || param1.code == "AppotaPaymentEvent")
               {
                  callback(param1.code,param1.level);
                  param1.stopImmediatePropagation();
               }
            };
         })());
      }
      
      public static function appotaIosInit(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:Function) : void
      {
         var clientId:String = param1;
         var clientSecret:String = param2;
         var apiKey:String = param3;
         var state:String = param4;
         var noticeUrl:String = param5;
         var configUrl:String = param6;
         var callback:Function = param7;
         initExtension();
         context.call("AppotaGameInit",clientId,clientSecret,apiKey,state,noticeUrl,configUrl);
         context.addEventListener("status",(function():*
         {
            var onExtCallBack:Function;
            return onExtCallBack = function(param1:StatusEvent):void
            {
               if(param1.code == "AppotaLoginEvent" || param1.code == "AppotaLogoutEvent" || param1.code == "AppotaPaymentEvent")
               {
                  callback(param1.code,param1.level);
                  param1.stopImmediatePropagation();
               }
            };
         })());
      }
      
      public static function appotaLogin() : void
      {
         initExtension();
         context.call("AppotaGameLogin");
      }
      
      public static function appotaLogout() : void
      {
         initExtension();
         context.call("AppotaGameLogout");
      }
      
      public static function appotaPayment(param1:uint) : void
      {
         initExtension();
         context.call("AppotaGamePayment",param1);
      }
      
      public static function appotaHandleOpenUrl(param1:String) : void
      {
         initExtension();
         context.call("AppotaGamehandleOpenURL",param1);
      }
   }
}

