package com.freshplanet.ane.AirFacebook
{
   import flash.desktop.NativeApplication;
   import flash.events.EventDispatcher;
   import flash.events.InvokeEvent;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   import flash.system.Capabilities;
   
   public class Facebook extends EventDispatcher
   {
      
      private static const EXTENSION_ID:String = "com.freshplanet.AirFacebook";
      
      private static var _instance:Facebook;
      
      private var _context:ExtensionContext;
      
      private var _logEnabled:Boolean = false;
      
      private var _openSessionCallback:Function;
      
      private var _reauthorizeSessionCallback:Function;
      
      private var _requestCallbacks:Object = {};
      
      public function Facebook()
      {
         super();
         if(!_instance)
         {
            _context = ExtensionContext.createExtensionContext("com.freshplanet.AirFacebook",null);
            if(!_context)
            {
               log("ERROR - Extension context is null. Please check if extension.xml is setup correctly.");
               return;
            }
            _context.addEventListener("status",onStatus);
            NativeApplication.nativeApplication.addEventListener("invoke",onInvoke);
            _instance = this;
            return;
         }
         throw Error("This is a singleton, use getInstance(), do not call the constructor directly.");
      }
      
      public static function get isSupported() : Boolean
      {
         return Capabilities.manufacturer.indexOf("iOS") > -1 || Capabilities.manufacturer.indexOf("Android") > -1;
      }
      
      public static function getInstance() : Facebook
      {
         return _instance ? _instance : new Facebook();
      }
      
      public function get logEnabled() : Boolean
      {
         return _logEnabled;
      }
      
      public function setUsingStage3D(param1:Boolean) : void
      {
         if(Capabilities.manufacturer.indexOf("Android") > -1)
         {
            _context.call("setUsingStage3D",param1);
         }
      }
      
      public function set logEnabled(param1:Boolean) : void
      {
         _logEnabled = param1;
      }
      
      public function init(param1:String, param2:String = null) : void
      {
         if(!isSupported)
         {
            return;
         }
         _context.call("init",param1,param2);
      }
      
      public function activateApp() : void
      {
         if(!isSupported)
         {
            return;
         }
         _context.call("activateApp");
      }
      
      public function get isSessionOpen() : Boolean
      {
         if(!isSupported)
         {
            return false;
         }
         return _context.call("isSessionOpen");
      }
      
      public function get accessToken() : String
      {
         if(!isSupported)
         {
            return null;
         }
         return _context.call("getAccessToken") as String;
      }
      
      public function get expirationTimestamp() : Number
      {
         if(!isSupported)
         {
            return 0;
         }
         return _context.call("getExpirationTimestamp") as Number;
      }
      
      public function openSessionWithReadPermissions(param1:Array, param2:Function = null, param3:Boolean = true) : void
      {
         openSessionWithPermissionsOfType(param1,"read",param2,param3);
      }
      
      public function openSessionWithPublishPermissions(param1:Array, param2:Function = null, param3:Boolean = true) : void
      {
         openSessionWithPermissionsOfType(param1,"publish",param2,param3);
      }
      
      public function reauthorizeSessionWithReadPermissions(param1:Array, param2:Function = null) : void
      {
         reauthorizeSessionWithPermissionsOfType(param1,"read",param2);
      }
      
      public function reauthorizeSessionWithPublishPermissions(param1:Array, param2:Function = null) : void
      {
         reauthorizeSessionWithPermissionsOfType(param1,"publish",param2);
      }
      
      public function closeSessionAndClearTokenInformation() : void
      {
         if(!isSupported)
         {
            return;
         }
         _context.call("closeSessionAndClearTokenInformation");
      }
      
      public function requestWithGraphPath(param1:String, param2:Object = null, param3:String = "GET", param4:Function = null) : void
      {
         var _loc7_:String = null;
         if(!isSupported)
         {
            return;
         }
         if(param3 != "GET" && param3 != "POST" && param3 != "DELETE")
         {
            log("ERROR - Invalid HTTP method: " + param3 + " (must be GET, POST or DELETE)");
            return;
         }
         var _loc6_:Array = [];
         var _loc5_:Array = [];
         for(var _loc8_ in param2)
         {
            _loc7_ = param2[_loc8_] as String;
            if(_loc7_)
            {
               _loc6_.push(_loc8_);
               _loc5_.push(_loc7_);
            }
         }
         var _loc9_:String = getNewCallbackName(param4);
         _context.call("requestWithGraphPath",param1,_loc6_,_loc5_,param3,_loc9_);
      }
      
      public function canPresentShareDialog() : Boolean
      {
         return _context.call("canPresentShareDialog");
      }
      
      public function shareStatusDialog(param1:Function) : void
      {
         _context.call("shareStatusDialog",getNewCallbackName(param1));
      }
      
      public function shareLinkDialog(param1:String = null, param2:String = null, param3:String = null, param4:String = null, param5:String = null, param6:Object = null, param7:Function = null) : void
      {
         var _loc10_:String = null;
         var _loc9_:Array = [];
         var _loc8_:Array = [];
         for(var _loc11_ in param6)
         {
            _loc10_ = param6[_loc11_] as String;
            if(_loc10_)
            {
               _loc9_.push(_loc11_);
               _loc8_.push(_loc10_);
            }
         }
         _context.call("shareLinkDialog",param1,param2,param3,param4,param5,_loc9_,_loc8_,getNewCallbackName(param7));
      }
      
      public function canPresentOpenGraphDialog(param1:String, param2:Object, param3:String = null) : Boolean
      {
         var _loc6_:String = null;
         var _loc5_:Array = [];
         var _loc4_:Array = [];
         for(var _loc7_ in param2)
         {
            _loc6_ = param2[_loc7_] as String;
            if(_loc6_)
            {
               _loc5_.push(_loc7_);
               _loc4_.push(_loc6_);
            }
         }
         return _context.call("canPresentOpenGraphDialog",param1,_loc5_,_loc4_,param3);
      }
      
      public function shareOpenGraphDialog(param1:String, param2:Object, param3:String = null, param4:Object = null, param5:Function = null) : void
      {
         var _loc8_:String = null;
         var _loc7_:Array = [];
         var _loc6_:Array = [];
         for(var _loc12_ in param2)
         {
            _loc8_ = param2[_loc12_] as String;
            if(_loc8_)
            {
               _loc7_.push(_loc12_);
               _loc6_.push(_loc8_);
            }
         }
         var _loc10_:Array = [];
         var _loc11_:Array = [];
         for(var _loc9_ in param4)
         {
            _loc8_ = param4[_loc12_] as String;
            if(_loc8_)
            {
               _loc10_.push(_loc12_);
               _loc11_.push(_loc8_);
            }
         }
         _context.call("shareOpenGraphDialog",param1,_loc7_,_loc6_,param3,_loc10_,_loc11_,getNewCallbackName(param5));
      }
      
      public function canPresentMessageDialog() : Boolean
      {
         return Boolean(_context.call("canPresentMessageDialog"));
      }
      
      public function presentMessageDialogWithLinkAndParams(param1:String, param2:String, param3:String, param4:String, param5:String, param6:Function) : void
      {
         var _loc8_:Array = ["link","name","caption","description","picture"];
         var _loc7_:Array = [param1,param2,param3,param4,param5];
         var _loc9_:String = getNewCallbackName(param6);
         _context.call("presentMessageDialogWithLinkAndParams",_loc8_,_loc7_,_loc9_);
      }
      
      public function webDialog(param1:String, param2:Object = null, param3:Function = null) : void
      {
         var _loc6_:String = null;
         var _loc5_:Array = [];
         var _loc4_:Array = [];
         for(var _loc7_ in param2)
         {
            _loc6_ = param2[_loc7_] as String;
            if(_loc6_)
            {
               _loc5_.push(_loc7_);
               _loc4_.push(_loc6_);
            }
         }
         var _loc8_:String = getNewCallbackName(param3);
         _context.call("webDialog",param1,_loc5_,_loc4_,_loc8_);
      }
      
      public function dialog(param1:String, param2:Object = null, param3:Function = null, param4:Boolean = true) : void
      {
         var _loc5_:* = param1 == "feed";
         var _loc7_:Boolean = Boolean(param2.hasOwnProperty("to"));
         var _loc6_:* = _loc5_ && param4 && !_loc7_;
         if(_loc6_)
         {
            _loc6_ = canPresentShareDialog();
         }
         if(_loc6_)
         {
            shareLinkDialog(param2["link"],param2["name"],param2["caption"],param2["description"],param2["picture"],param3);
         }
         else
         {
            webDialog(param1,param2,param3);
         }
      }
      
      public function publishInstall(param1:String) : void
      {
         if(!isSupported)
         {
            return;
         }
         _context.call("publishInstall",param1);
      }
      
      private function openSessionWithPermissionsOfType(param1:Array, param2:String, param3:Function = null, param4:Boolean = true) : void
      {
         if(!isSupported)
         {
            return;
         }
         _openSessionCallback = param3;
         _context.call("openSessionWithPermissions",param1,param2,param4);
      }
      
      private function reauthorizeSessionWithPermissionsOfType(param1:Array, param2:String, param3:Function = null) : void
      {
         if(!isSupported)
         {
            return;
         }
         if(!isSessionOpen)
         {
            param3(false,false,"No opened session");
            return;
         }
         _reauthorizeSessionCallback = param3;
         _context.call("reauthorizeSessionWithPermissions",param1,param2);
      }
      
      private function getNewCallbackName(param1:Function) : String
      {
         var _loc2_:Date = new Date();
         var _loc3_:String = _loc2_.time.toString();
         if(_requestCallbacks.hasOwnProperty(_loc3_))
         {
            delete _requestCallbacks[_loc3_];
         }
         _requestCallbacks[_loc3_] = param1;
         return _loc3_;
      }
      
      private function onInvoke(param1:InvokeEvent) : void
      {
         var _loc2_:String = null;
         if(Capabilities.manufacturer.indexOf("iOS") != -1)
         {
            if(param1.arguments != null && param1.arguments.length > 0)
            {
               _loc2_ = param1.arguments[0] as String;
               if(_loc2_ != null && _loc2_.indexOf("fb") == 0)
               {
                  _context.call("handleOpenURL",_loc2_);
               }
            }
         }
      }
      
      private function onStatus(param1:StatusEvent) : void
      {
         var _loc4_:Function = null;
         var _loc7_:* = false;
         var _loc6_:* = false;
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc5_:Date = new Date();
         if(param1.code.indexOf("SESSION") != -1)
         {
            _loc7_ = param1.code.indexOf("SUCCESS") != -1;
            _loc6_ = param1.code.indexOf("CANCEL") != -1;
            _loc2_ = param1.code.indexOf("ERROR") != -1 ? param1.level : null;
            if(param1.code.indexOf("OPEN") != -1)
            {
               _loc4_ = _openSessionCallback;
            }
            else if(param1.code.indexOf("REAUTHORIZE") != -1)
            {
               _loc4_ = _reauthorizeSessionCallback;
            }
            _openSessionCallback = null;
            _reauthorizeSessionCallback = null;
            if(_loc4_ != null)
            {
               _loc4_(_loc7_,_loc6_,_loc2_);
            }
         }
         else if(param1.code == "ACTION_REQUIRE_PERMISSION")
         {
            dispatchEvent(new FacebookPermissionEvent("com.freshplanet.ane.AirFacebook.FacebookPermissionEvent.PERMISSION_NEEDED",param1.level.split(",")));
         }
         else if(param1.code == "LOGGING")
         {
            log(param1.level);
         }
         else if(_requestCallbacks.hasOwnProperty(param1.code))
         {
            _loc4_ = _requestCallbacks[param1.code];
            if(_loc4_ != null)
            {
               try
               {
                  _loc3_ = JSON.parse(param1.level);
                  if(accessToken != null && accessToken != "")
                  {
                     _loc3_["accessToken"] = accessToken;
                  }
               }
               catch(e:Error)
               {
                  log("ERROR - " + e);
               }
               _loc4_(_loc3_);
               delete _requestCallbacks[param1.code];
            }
         }
      }
      
      private function log(param1:String) : void
      {
         if(_logEnabled)
         {
            trace("[Facebook] " + param1);
         }
      }
   }
}

