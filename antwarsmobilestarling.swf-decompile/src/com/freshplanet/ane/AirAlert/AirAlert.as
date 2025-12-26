package com.freshplanet.ane.AirAlert
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   import flash.system.Capabilities;
   
   public class AirAlert extends EventDispatcher
   {
      
      private static var _instance:AirAlert;
      
      private static const EXTENSION_ID:String = "com.freshplanet.AirAlert";
      
      private var _context:ExtensionContext;
      
      private var _callback1:Function = null;
      
      private var _callback2:Function = null;
      
      public function AirAlert()
      {
         super();
         if(!_instance)
         {
            this._context = ExtensionContext.createExtensionContext(EXTENSION_ID,null);
            if(!this._context)
            {
               throw Error("ERROR - Extension context is null. Please check if extension.xml is setup correctly.");
            }
            this._context.addEventListener(StatusEvent.STATUS,this.onStatus);
            _instance = this;
            return;
         }
         throw Error("This is a singleton, use getInstance(), do not call the constructor directly.");
      }
      
      public static function get isSupported() : Boolean
      {
         return Capabilities.manufacturer.indexOf("iOS") != -1 || Capabilities.manufacturer.indexOf("Android") != -1;
      }
      
      public static function getInstance() : AirAlert
      {
         return _instance ? _instance : new AirAlert();
      }
      
      public function showAlert(param1:String, param2:String, param3:String = "OK", param4:Function = null, param5:String = null, param6:Function = null) : void
      {
         if(!isSupported)
         {
            return;
         }
         this._callback1 = param4;
         this._callback2 = param6;
         if(param5 == null)
         {
            this._context.call("AirAlertShowAlert",param1,param2,param3);
         }
         else
         {
            this._context.call("AirAlertShowAlert",param1,param2,param3,param5);
         }
      }
      
      private function onStatus(param1:StatusEvent) : void
      {
         var _loc2_:Function = null;
         if(param1.code == "CLICK")
         {
            _loc2_ = null;
            if(param1.level == "0")
            {
               _loc2_ = this._callback1;
            }
            else if(param1.level == "1")
            {
               _loc2_ = this._callback2;
            }
            this._callback1 = null;
            this._callback2 = null;
            if(_loc2_ != null)
            {
               _loc2_();
            }
         }
      }
   }
}

