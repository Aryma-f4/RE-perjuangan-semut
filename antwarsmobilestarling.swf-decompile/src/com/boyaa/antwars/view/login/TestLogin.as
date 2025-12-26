package com.boyaa.antwars.view.login
{
   import com.adobe.crypto.MD5;
   import com.adobe.serialization.json.JSONDecoder;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.debug.Logging.LevelLogger;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import org.osflash.signals.Signal;
   
   public class TestLogin
   {
      
      public var loginStartSignal:Signal;
      
      public var loginCompleteSignal:Signal;
      
      public function TestLogin()
      {
         super();
         loginStartSignal = new Signal();
         loginCompleteSignal = new Signal(uint,String);
      }
      
      public function login() : void
      {
         var sid:String = "";
         var name:String = "";
         var _loader:URLLoader = new URLLoader();
         var _request:URLRequest = new URLRequest(Constants.TestLoginURL);
         var _variables:URLVariables = new URLVariables();
         _request.data = _variables;
         _request.method = "POST";
         _variables.sid = 1299721653;
         _variables.name = name;
         _variables.sign = MD5.hash(_variables.sid + _variables.name + "fcc2f629-817b-4955-94be-ba1da73b3164");
         _loader.addEventListener("complete",loginLoaderComplete);
         _loader.addEventListener("ioError",(function():*
         {
            var login_ioError:Function;
            return login_ioError = function(param1:IOErrorEvent):void
            {
               var _loc2_:URLLoader = param1.target as URLLoader;
               _loc2_.removeEventListener("ioError",login_ioError);
               Application.instance.systemAlert(LangManager.t("systemTip"),LangManager.t("loginFailure"),[LangManager.t("sure"),""]);
            };
         })());
         _loader.load(_request);
         loginStartSignal.dispatch();
      }
      
      private function loginLoaderComplete(param1:Event) : void
      {
         var _loc3_:String = param1.currentTarget.data as String;
         LevelLogger.getLogger("TestLogin").info(_loc3_);
         var _loc4_:JSONDecoder = new JSONDecoder(_loc3_);
         var _loc2_:Object = _loc4_.getValue() as Object;
         loginCompleteSignal.dispatch(parseInt(_loc2_.data.mid),_loc2_.data.key);
      }
   }
}

