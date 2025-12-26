package com.boyaa.tool.payment
{
   import com.boyaa.AntwarsMobileId.AntwarsMobileIdTool;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.freshplanet.ane.AirFacebook.Facebook;
   import flash.events.Event;
   import flash.events.StatusEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   import org.osflash.signals.Signal;
   
   public class PaymentManager
   {
      
      public static const GOOGLEPLAY:String = "12";
      
      public static const ZINGMOBILE:String = "147";
      
      public static const TELKOMSEL:String = "205";
      
      public static const FORTUMO:String = "239";
      
      public static const CODA_XL:String = "269";
      
      public static const CODA_INDOSAT:String = "269";
      
      private static var _instance:PaymentManager = null;
      
      private var _pmodeArr:Dictionary = new Dictionary();
      
      private var _tool:AntwarsMobileIdTool;
      
      private var _updateCoinSignal:Signal;
      
      private var _isPC:Boolean = false;
      
      public function PaymentManager(param1:Single)
      {
         super();
         init();
      }
      
      public static function get instance() : PaymentManager
      {
         if(_instance == null)
         {
            _instance = new PaymentManager(new Single());
         }
         return _instance;
      }
      
      private function init() : void
      {
         _pmodeArr["12"] = "CheckOut";
         _pmodeArr["147"] = "zingmobile";
         _pmodeArr["205"] = "Mimopay-Upoint";
         _pmodeArr["239"] = "fortumo2.0";
         _updateCoinSignal = new Signal();
         _tool = new AntwarsMobileIdTool();
         if(Facebook.isSupported)
         {
            _tool.init();
            _tool.dispather.addEventListener("status",onStatusEventHandle);
         }
         else
         {
            _isPC = true;
         }
      }
      
      private function onStatusEventHandle(param1:StatusEvent) : void
      {
         var _loc2_:Object = null;
         switch(param1.code)
         {
            case "GOOGLE_RESULT":
               _loc2_ = JSON.parse(param1.level);
               sendGoogleResultToPHP(_loc2_.base64SignedData,_loc2_.dataSignature);
               break;
            case "MIMOPAY_RESULT":
         }
      }
      
      public function getPaymentInfo(param1:String, param2:Function) : void
      {
         var pMode:String = param1;
         var callBack:Function = param2;
         var _loader:URLLoader = new URLLoader();
         var _request:URLRequest = new URLRequest(Constants.PaymentInfoUrl);
         var _variables:URLVariables = new URLVariables();
         _request.data = _variables;
         _request.method = "POST";
         _variables.mid = PlayerDataList.instance.selfData.uid;
         _variables.pmodes = "[" + pMode + "]";
         _loader.addEventListener("complete",(function():*
         {
            var onGetPaymentInfo:Function;
            return onGetPaymentInfo = function(param1:Event):void
            {
               _loader.removeEventListener("complete",onGetPaymentInfo);
               var _loc2_:String = param1.currentTarget.data as String;
               var _loc3_:Object = {};
               try
               {
                  Application.instance.log("getPaymentInfo",_loc2_);
                  _loc3_ = JSON.parse(_loc2_);
               }
               catch(error:Error)
               {
                  Application.instance.log("getPaymentInfo \'s error",error.message.toString());
               }
               if(_loc3_.hasOwnProperty("productInfo"))
               {
                  callBack(_loc3_);
               }
            };
         })());
         _loader.load(_request);
      }
      
      private function sendGoogleResultToPHP(param1:String, param2:String) : void
      {
         var base64SignedData:String = param1;
         var dataSignature:String = param2;
         var _loader:URLLoader = new URLLoader();
         var _request:URLRequest = new URLRequest(Constants.IpAddress + "mobile/check_pay_order.php?sid=" + Constants.sid);
         var _variables:URLVariables = new URLVariables();
         _request.data = _variables;
         _request.method = "POST";
         _variables.base64SignedData = base64SignedData;
         _variables.dataSignature = dataSignature;
         _loader.addEventListener("complete",(function():*
         {
            var onGetPaymentInfo:Function;
            return onGetPaymentInfo = function(param1:Event):void
            {
               _loader.removeEventListener("complete",onGetPaymentInfo);
               var _loc2_:String = param1.currentTarget.data as String;
               var _loc3_:Object = {};
               try
               {
                  Application.instance.log("getPaymentInfo",_loc2_);
                  _loc3_ = JSON.parse(_loc2_);
               }
               catch(error:Error)
               {
                  Application.instance.log("getPaymentInfo \'s error",error.message.toString());
                  updateCoinSignal.dispatch();
               }
               if(_loc3_.hasOwnProperty("ret"))
               {
                  if(_loc3_.ret == 0)
                  {
                     Application.instance.currentGame.getActivityState();
                     MissionManager.instance.updateMissionData(112,79);
                  }
                  else
                  {
                     TextTip.instance.show("pay error!");
                  }
               }
            };
         })());
         _loader.load(_request);
      }
      
      public function makePayment(param1:String) : void
      {
         var _loader:URLLoader;
         var _request:URLRequest;
         var _variables:URLVariables;
         var productId:String = param1;
         if(_isPC)
         {
            TextTip.instance.show("no support for PC!");
            return;
         }
         _loader = new URLLoader();
         _request = new URLRequest(Constants.IpAddress + "mobile/create_order.php?" + Constants.sid);
         _variables = new URLVariables();
         _request.data = _variables;
         _request.method = "POST";
         _variables.mid = PlayerDataList.instance.selfData.uid;
         _variables.id = productId;
         _loader.addEventListener("complete",(function():*
         {
            var onMankPayment:Function;
            return onMankPayment = function(param1:Event):void
            {
               _loader.removeEventListener("complete",onMankPayment);
               var _loc2_:String = param1.currentTarget.data as String;
               var _loc3_:Object = {};
               try
               {
                  Application.instance.log("makePayment",_loc2_);
                  _loc3_ = JSON.parse(_loc2_);
               }
               catch(error:Error)
               {
                  Application.instance.log("makePayment \'s error",error.message.toString());
               }
               trace(_loc3_.orderInfo);
               pay(_loc3_);
            };
         })());
         _loader.load(_request);
      }
      
      private function pay(param1:Object) : void
      {
         var _loc9_:String = null;
         var _loc11_:int = 0;
         var _loc10_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:String = null;
         var _loc5_:String = param1.orderInfo.ORDER;
         var _loc8_:String = param1.orderInfo.PMODE;
         var _loc6_:String = param1.orderInfo.PAMOUNT;
         var _loc7_:String = param1.orderInfo.PCOINS;
         var _loc12_:String = param1.orderInfo.PAYCONFID;
         var _loc3_:String = param1.orderInfo.SITEMID;
         Application.instance.log("pay","order:" + _loc5_ + " productId:" + _loc12_);
         switch(_loc8_)
         {
            case "12":
               _tool.googlePayment(_loc12_,_loc5_);
               break;
            case "147":
               trace("zingMobile");
               _tool.zingMobilePayment(_loc5_,int(_loc6_));
               break;
            case "205":
               _tool.mimoPayment(_loc3_,_loc12_,_loc5_,_loc6_);
               break;
            case "239":
               break;
            case "269":
            case "269":
               _loc9_ = param1.orderInfo.apiKey;
               _loc11_ = int(param1.orderInfo.country);
               _loc10_ = int(param1.orderInfo.currency);
               _loc4_ = param1.orderInfo.items[0];
               _loc2_ = _loc4_["code"] + "|" + _loc7_ + " BoyaaCash" + "|" + _loc4_["price"] + "|" + _loc4_["type"];
               _tool.codaPayment(_loc5_,_loc9_,_loc11_,_loc10_,_loc2_);
         }
      }
      
      public function get updateCoinSignal() : Signal
      {
         return _updateCoinSignal;
      }
   }
}

class Single
{
   
   public function Single()
   {
      super();
   }
}
