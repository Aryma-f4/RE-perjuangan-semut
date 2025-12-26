package com.boyaa.AntwarsMobileId
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   
   public class AntwarsMobileIdTool
   {
      
      public static const EXTENSION_ID:String = "com.boyaa.antwars";
      
      public static const MIMOPAY:String = "mimopayment";
      
      public static const GOOGLEPAY:String = "googlepayment";
      
      public static const CODAPAY:String = "codePay";
      
      public static const CODA_INDOSAT:String = "codaIndosat";
      
      public static const CODA_XL:String = "codaXL";
      
      public static const ZING_MOBILE:String = "zingmobile";
      
      private var _context:ExtensionContext = null;
      
      private var _dispather:EventDispatcher = new EventDispatcher();
      
      public function AntwarsMobileIdTool()
      {
         super();
      }
      
      public function init() : void
      {
         if(this._context == null)
         {
            this._context = ExtensionContext.createExtensionContext(EXTENSION_ID,null);
            this.addEvents();
         }
      }
      
      private function addEvents() : void
      {
         this._context.addEventListener(StatusEvent.STATUS,this.onContextStatusHandle);
      }
      
      private function onContextStatusHandle(param1:StatusEvent) : void
      {
         trace("type:",param1.type,"code:",param1.code,"level:",param1.level);
         this._dispather.dispatchEvent(param1);
      }
      
      public function mimoPayment(param1:String, param2:String, param3:String, param4:String) : void
      {
         this._context.call(MIMOPAY,param1,param2,param3,param4);
      }
      
      public function googlePayment(param1:String, param2:String) : void
      {
         this._context.call(GOOGLEPAY,param1,param2);
      }
      
      public function codaPayment(param1:String, param2:String, param3:int, param4:int, param5:String) : void
      {
         this._context.call(CODAPAY,CODA_INDOSAT,param1,param2,param3,param4,param5);
      }
      
      public function zingMobilePayment(param1:String, param2:int) : void
      {
         this._context.call(ZING_MOBILE,param1,param2);
      }
      
      public function test(param1:String) : String
      {
         return this._context.call("sayhello",param1) as String;
      }
      
      public function get dispather() : EventDispatcher
      {
         return this._dispather;
      }
   }
}

