package com.freshplanet.ane
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   import flash.system.Capabilities;
   
   public class AirDeviceId extends EventDispatcher
   {
      
      private static var _instance:AirDeviceId;
      
      private var extCtx:ExtensionContext = null;
      
      private var _id:String = null;
      
      private var _idfv:String = null;
      
      private var _idfa:String = null;
      
      public function AirDeviceId()
      {
         super();
         if(!_instance)
         {
            this.extCtx = ExtensionContext.createExtensionContext("com.freshplanet.ane.AirDeviceId",null);
            if(this.extCtx != null)
            {
               this.extCtx.addEventListener(StatusEvent.STATUS,this.onStatus);
            }
            else
            {
               trace("[AirDeviceId] Error - Extension Context is null.");
            }
            _instance = this;
            return;
         }
         throw Error("This is a singleton, use getInstance(), do not call the constructor directly.");
      }
      
      public static function getInstance() : AirDeviceId
      {
         return _instance ? _instance : new AirDeviceId();
      }
      
      public function get isOnDevice() : Boolean
      {
         return this.isOnIOS || this.isOnAndroid;
      }
      
      public function get isOnIOS() : Boolean
      {
         return Capabilities.manufacturer.indexOf("iOS") > -1;
      }
      
      public function get isOnAndroid() : Boolean
      {
         return Capabilities.manufacturer.indexOf("Android") > -1;
      }
      
      public function isSupported() : Boolean
      {
         return this.extCtx.call("isSupported");
      }
      
      public function getID(param1:String) : String
      {
         if(!this.isOnDevice)
         {
            return "simulator";
         }
         if(!this._id)
         {
            this._id = this.extCtx.call("getID",param1) as String;
         }
         return this._id;
      }
      
      public function getIDFV() : String
      {
         if(!this.isOnDevice)
         {
            return null;
         }
         if(!this._idfv)
         {
            this._idfv = this.extCtx.call("getIDFV") as String;
            if(this._idfv == "00000000-0000-0000-0000-000000000000")
            {
               this._idfv = null;
            }
         }
         return this._idfv;
      }
      
      public function getIDFA() : String
      {
         if(!this.isOnDevice)
         {
            return null;
         }
         if(!this._idfa)
         {
            this._idfa = this.extCtx.call("getIDFA") as String;
            if(this._idfa == "00000000-0000-0000-0000-000000000000")
            {
               this._idfa = null;
            }
         }
         return this._idfa;
      }
      
      private function onStatus(param1:StatusEvent) : void
      {
         if(param1.code == "LOGGING")
         {
            trace("[AirDeviceId] " + param1.level);
         }
      }
   }
}

