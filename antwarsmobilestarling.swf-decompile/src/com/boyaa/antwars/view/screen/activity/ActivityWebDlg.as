package com.boyaa.antwars.view.screen.activity
{
   import com.adobe.crypto.MD5;
   import com.boyaa.ane.SystemProperties;
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.LoginData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideSprite;
   import com.freshplanet.ane.AirDeviceId;
   import com.hurlant.util.Base64;
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.events.LocationChangeEvent;
   import flash.geom.Rectangle;
   import flash.media.StageWebView;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class ActivityWebDlg extends GuideSprite
   {
      
      public static const SENDING_PROTOCOL:String = Application.instance.iOS ? "about:" : "tuoba:";
      
      private var webView:StageWebView;
      
      private var markbg:DlgMark;
      
      private var _serializeObject:Object;
      
      private var _callBacks:Array = [];
      
      private var _callBackFunction:Function;
      
      public function ActivityWebDlg()
      {
         super();
         this.addEventListener("addedToStage",onAddedToStage);
         addCallbackFunction();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener("addedToStage",onAddedToStage);
         markbg = new DlgMark();
         parent.addChild(markbg);
         parent.swapChildren(markbg,this);
         webView = new StageWebView();
         var _loc8_:Stage = Starling.current.nativeStage;
         var _loc4_:Number = Number(Constants.isPC ? _loc8_.stageWidth : _loc8_.fullScreenWidth);
         var _loc2_:Number = Number(Constants.isPC ? _loc8_.stageHeight : _loc8_.fullScreenHeight);
         var _loc5_:Number = _loc4_ * 0.05;
         var _loc3_:Number = _loc2_ * 0.05;
         webView.stage = Starling.current.nativeStage;
         webView.viewPort = new Rectangle(_loc5_,_loc3_,_loc4_ - 2 * _loc5_,_loc2_ - 2 * _loc3_);
         var _loc6_:String = "123456789";
         if(!Constants.debug)
         {
            if(Constants.lanVersion == 2)
            {
               _loc6_ = SystemProperties.getOpenUDID();
            }
            else if(Constants.lanVersion == 3)
            {
               _loc6_ = AirDeviceId.getInstance().getID("antwars");
            }
         }
         var _loc7_:Object = {
            "appid":1,
            "api":1,
            "mid":LoginData.instance.mid,
            "version":Application.instance.getAppVersionNamber(),
            "deviceno":MD5.hash(_loc6_),
            "sid":139,
            "sitemid":LoginData.instance.sid,
            "networkstate":Application.instance.getNetworkName()
         };
         var _loc9_:String = Constants.ActivityWebURL + JSON.stringify(_loc7_);
         trace(_loc9_);
         webView.loadURL(_loc9_);
         webView.addEventListener("locationChanging",onLocationChanging);
         markbg.addEventListener("touch",onTouch);
         Application.instance.application.removeEventListener("keyDown",Application.instance.currentMain.handleKeys);
         Application.instance.application.addEventListener("keyDown",handleKeys);
      }
      
      private function handleKeys(param1:KeyboardEvent) : void
      {
         if(Application.instance.iOS)
         {
            return;
         }
         if(param1.keyCode == 16777238)
         {
            param1.preventDefault();
            close();
            param1.stopImmediatePropagation();
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var e:TouchEvent = param1;
         var myTouch:Touch = e.getTouch(markbg,"ended");
         if(myTouch)
         {
            if(!Constants.debug)
            {
               Application.instance.systemAlert(LangManager.t("systemTip"),LangManager.t("activityQuit"),[LangManager.t("yes"),LangManager.t("no")],[close,function():void
               {
               }]);
            }
            else
            {
               close();
            }
         }
      }
      
      private function close() : void
      {
         Application.instance.application.addEventListener("keyDown",Application.instance.currentMain.handleKeys);
         Application.instance.application.removeEventListener("keyDown",handleKeys);
         markbg.removeEventListener("touch",onTouch);
         markbg.removeFromParent(true);
         webView.removeEventListener("locationChanging",onLocationChanging);
         webView.stage = null;
         webView.dispose();
         removeFromParent(true);
      }
      
      private function addCallbackFunction() : void
      {
         addCallback("gotoScreen",gotoScreen);
         addCallback("close",close);
         addCallback("openMenu",openMenu);
         addCallback("updateRole",updateRole);
      }
      
      public function updateRole(param1:String) : void
      {
         var _loc6_:Array = null;
         trace(param1);
         trace(Base64.decode(param1));
         var _loc3_:Object = JSON.parse(Base64.decode(param1));
         var _loc5_:PlayerData = PlayerDataList.instance.selfData;
         var _loc2_:Object = _loc3_[0];
         _loc5_.addOtherInfo(_loc2_);
         var _loc4_:Object = _loc3_[1];
         AccountData.instance.gameGold = _loc4_.currency;
         AccountData.instance.boyaaCoin = _loc4_.boyaacurrency;
         AccountData.instance.freeCoin = _loc4_.excertificate;
         if(_loc3_[2] != null)
         {
            _loc6_ = _loc3_[2];
            GoodsList.instance.addGoodsByAry(_loc6_);
         }
      }
      
      public function gotoScreen(param1:String) : void
      {
         close();
         Application.instance.currentGame.navigator.showScreen(param1);
      }
      
      public function openMenu(param1:String) : void
      {
         close();
         switch(param1)
         {
            case "Recharge":
               Application.instance.currentGame.mainMenu.onRechargeBtn();
               break;
            case "Mission":
               Application.instance.currentGame.mainMenu.onMissionBtn();
               break;
            case "Package":
               Application.instance.currentGame.mainMenu.onPackageBtn();
               break;
            case "Friends":
               Application.instance.currentGame.mainMenu.onFriendsBtn();
               break;
            case "Message":
               Application.instance.currentGame.mainMenu.onMessageBtn();
               break;
            case "Logout":
               Application.instance.currentGame.logout();
         }
      }
      
      private function addCallback(param1:String, param2:Function) : void
      {
         _callBacks[param1] = param2;
      }
      
      private function parseCallBack(param1:String) : void
      {
         trace(Base64.decode(param1).toString());
         _serializeObject = JSON.parse(Base64.decode(param1).toString());
         trace("_serializeObject =>" + _serializeObject["method"]);
         _callBackFunction = _callBacks[_serializeObject["method"]];
         if(_callBackFunction == null)
         {
            return;
         }
         var _loc2_:* = null;
         if(_serializeObject["arguments"].length != 0)
         {
            _loc2_ = _callBackFunction.apply(null,_serializeObject.arguments);
         }
         else
         {
            _loc2_ = _callBackFunction();
         }
      }
      
      private function onLocationChanging(param1:LocationChangeEvent) : void
      {
         var _loc2_:String = null;
         trace("onLocationChanging");
         trace((param1 as LocationChangeEvent).location);
         if(param1.type == "locationChanging")
         {
            _loc2_ = unescape((param1 as LocationChangeEvent).location);
            var _loc3_:Boolean = true;
            if(_loc2_.indexOf(SENDING_PROTOCOL + "[SWVData]") != -1 === _loc3_)
            {
               param1.preventDefault();
               parseCallBack(_loc2_.split(SENDING_PROTOCOL + "[SWVData]")[1]);
            }
         }
      }
   }
}

