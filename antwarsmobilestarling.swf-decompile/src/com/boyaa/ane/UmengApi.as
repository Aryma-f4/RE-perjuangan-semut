package com.boyaa.ane
{
   import flash.external.ExtensionContext;
   
   public class UmengApi
   {
      
      public static const REALTIME:int = 0;
      
      public static const BATCH:int = 1;
      
      public static const SENDDAILY:int = 4;
      
      public static const SENDWIFIONLY:int = 5;
      
      public static const SEND_INTERVAL:int = 6;
      
      public static const SEND_ON_EXIT:int = 7;
      
      public static const ONRESUME:int = 0;
      
      public static const ONPAUSE:int = 1;
      
      private var cxt:ExtensionContext = null;
      
      public function UmengApi()
      {
         super();
         cxt = SystemProperties.initExtension();
      }
      
      public function init(param1:String, param2:int, param3:String) : void
      {
         cxt.call("UMstartWithAppKeyAndReportPolicyAndChannelId",param1,param2,param3);
      }
      
      public function UMAnalytics(param1:int) : void
      {
         cxt.call("UMAnalytics",param1);
      }
      
      public function setLogSendInterval(param1:Number) : void
      {
         cxt.call("UMsetLogSendInterval",param1);
      }
      
      public function beginLogPageView(param1:String) : void
      {
         cxt.call("UMbeginLogPageView",param1);
      }
      
      public function endLogPageView(param1:String) : void
      {
         cxt.call("UMendLogPageView",param1);
      }
      
      public function event(param1:String) : void
      {
         cxt.call("UMevent",param1);
      }
      
      public function eventWithLabel(param1:String, param2:String) : void
      {
         cxt.call("UMeventWithLabel",param1,param2);
      }
      
      public function eventWithAccumulation(param1:String, param2:int) : void
      {
         cxt.call("UMeventWithAccumulation",param1,param2);
      }
      
      public function eventWithLabelAndAccumulation(param1:String, param2:String, param3:int) : void
      {
         cxt.call("UMeventWithLabelAndAccumulation",param1,param2,param3);
      }
      
      public function beginEvent(param1:String) : void
      {
         cxt.call("UMbeginEvent",param1);
      }
      
      public function endEvent(param1:String) : void
      {
         cxt.call("UMendEvent",param1);
      }
      
      public function beginEventWithLabel(param1:String, param2:String) : void
      {
         cxt.call("UMbeginEventWithLabel",param1,param2);
      }
      
      public function endEventWithLabel(param1:String, param2:String) : void
      {
         cxt.call("UMendEventWithLabel",param1,param2);
      }
      
      public function checkUpdate(param1:String, param2:String, param3:String) : void
      {
         cxt.call("UMcheckUpdate",param1,param2,param3);
      }
   }
}

