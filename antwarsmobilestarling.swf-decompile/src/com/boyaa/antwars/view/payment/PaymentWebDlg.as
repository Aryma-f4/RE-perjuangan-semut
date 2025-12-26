package com.boyaa.antwars.view.payment
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.LoginData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.mission.MissionManager;
   import flash.display.Stage;
   import flash.geom.Rectangle;
   import flash.media.StageWebView;
   import starling.core.Starling;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class PaymentWebDlg extends Sprite
   {
      
      private var webView:StageWebView;
      
      private var markbg:DlgMark;
      
      private var appid:int = 0;
      
      private var sid:int = 0;
      
      private var amt:int = 1;
      
      private var count:int = 1;
      
      public function PaymentWebDlg(param1:int, param2:int)
      {
         super();
         this.addEventListener("addedToStage",onAddedToStage);
         this.amt = param1;
         this.count = param2;
         if(Application.instance.iOS)
         {
            sid = 5;
            appid = 278;
         }
         else
         {
            sid = 7;
            appid = 243;
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener("addedToStage",onAddedToStage);
         markbg = new DlgMark();
         parent.addChild(markbg);
         parent.swapChildren(markbg,this);
         webView = new StageWebView();
         var _loc6_:Stage = Starling.current.nativeStage;
         var _loc4_:Number = Number(Constants.isPC ? _loc6_.stageWidth : _loc6_.fullScreenWidth);
         var _loc2_:Number = Number(Constants.isPC ? _loc6_.stageHeight : _loc6_.fullScreenHeight);
         var _loc5_:Number = _loc4_ * 0.1;
         var _loc3_:Number = _loc2_ * 0.1;
         webView.stage = Starling.current.nativeStage;
         webView.viewPort = new Rectangle(_loc5_,_loc3_,_loc4_ - 2 * _loc5_,_loc2_ - 2 * _loc3_);
         var _loc7_:String = "https://paycn.boyaa.com/payweb/index.php?c=index&m=pay&sid=" + sid + "&appid=" + appid + "&ptype=1&sitemid=" + LoginData.instance.mkSiteMid() + "&amt=" + amt + "&desc=" + count + "%e5%8d%9a%e9%9b%85%e5%b8%81" + "&clientTime=" + new Date().getTime();
         webView.loadURL(_loc7_);
         markbg.addEventListener("touch",onTouch);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var e:TouchEvent = param1;
         var myTouch:Touch = e.getTouch(markbg,"ended");
         if(myTouch)
         {
            if(!Constants.debug)
            {
               Application.instance.systemAlert(LangManager.t("systemTip"),LangManager.t("recharge"),[LangManager.t("yes"),LangManager.t("no")],[function():void
               {
                  markbg.removeEventListener("touch",onTouch);
                  markbg.removeFromParent(true);
                  webView.stage = null;
                  webView.dispose();
                  removeFromParent(true);
                  Remoting.instance.getAccount(function(param1:Object):void
                  {
                     var _loc2_:int = 0;
                     if(param1.ret == 0)
                     {
                        _loc2_ = param1.account[3] - AccountData.instance.boyaaCoin;
                        if(_loc2_ > 0)
                        {
                           MissionManager.instance.updateMissionData(112,_loc2_);
                        }
                        AccountData.instance.updateAccountAry(param1.account);
                     }
                  });
               },function():void
               {
               }]);
            }
            else
            {
               markbg.removeEventListener("touch",onTouch);
               markbg.removeFromParent(true);
               webView.stage = null;
               webView.dispose();
               removeFromParent(true);
               Remoting.instance.getAccount(function(param1:Object):void
               {
                  var _loc2_:int = 0;
                  if(param1.ret == 0)
                  {
                     _loc2_ = param1.account[3] - AccountData.instance.boyaaCoin;
                     if(_loc2_ > 0)
                     {
                        MissionManager.instance.updateMissionData(112,_loc2_);
                     }
                     AccountData.instance.updateAccountAry(param1.account);
                  }
               });
            }
         }
      }
   }
}

