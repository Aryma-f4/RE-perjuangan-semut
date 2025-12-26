package com.boyaa.antwars.view.payment
{
   import com.boyaa.ane.SystemProperties;
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.LoginData;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.mission.MissionManager;
   import flash.filters.DropShadowFilter;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class PaymentDlg extends Sprite
   {
      
      private var posHelper:Rectangle;
      
      private var markbg:DlgMark;
      
      private var config_data:Array = [[10,1],[50,5],[110,10],[333,30],[560,50],[1150,100],[3510,300],[6000,500]];
      
      public function PaymentDlg()
      {
         super();
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         var _loc9_:int = 0;
         var _loc3_:Button = null;
         var _loc8_:TextField = null;
         var _loc7_:TextField = null;
         removeEventListener("addedToStage",onAddedToStage);
         markbg = new DlgMark();
         parent.addChild(markbg);
         parent.swapChildren(markbg,this);
         var _loc4_:Image = new Image(Assets.sAsset.getTexture("payment"));
         addChild(_loc4_);
         var _loc6_:Button = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         Assets.sAsset.positionDisplay(_loc6_,"paymentdlg","closeBtn");
         addChild(_loc6_);
         _loc6_.addEventListener("triggered",onCloseBtn);
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("testboyaaCoinIcon"));
         Assets.sAsset.positionDisplay(_loc5_,"paymentdlg","boyaaicon");
         addChild(_loc5_);
         posHelper = Assets.sAsset.getPosition("paymentdlg","boyaaCoin");
         var _loc2_:TextField = new TextField(posHelper.width,posHelper.height,AccountData.instance.boyaaCoin.toString(),"Verdana",30,16777215,true);
         _loc2_.vAlign = "center";
         _loc2_.hAlign = "left";
         _loc2_.x = posHelper.x;
         _loc2_.y = posHelper.y;
         _loc2_.autoScale = true;
         _loc2_.nativeFilters = [new DropShadowFilter(0,45,0,1,3.2,3.2,30)];
         addChild(_loc2_);
         _loc9_ = 1;
         while(_loc9_ < 9)
         {
            _loc3_ = new Button(Assets.sAsset.getTexture("bigboyaaicon"));
            Assets.sAsset.positionDisplay(_loc3_,"paymentdlg","icon" + _loc9_);
            _loc3_.name = _loc9_.toString();
            addChild(_loc3_);
            _loc3_.addEventListener("triggered",onIconBtn);
            posHelper = Assets.sAsset.getPosition("paymentdlg","by" + _loc9_);
            _loc8_ = new TextField(posHelper.width,posHelper.height,String(config_data[_loc9_ - 1][0]),"Verdana",30,16777215,true);
            _loc8_.x = posHelper.x;
            _loc8_.y = posHelper.y;
            _loc8_.autoScale = true;
            addChild(_loc8_);
            posHelper = Assets.sAsset.getPosition("paymentdlg","rmb" + _loc9_);
            _loc7_ = new TextField(posHelper.width,posHelper.height,"￥" + config_data[_loc9_ - 1][1],"Verdana",30,16777215,true);
            _loc7_.x = posHelper.x;
            _loc7_.y = posHelper.y;
            _loc7_.autoScale = true;
            addChild(_loc7_);
            _loc9_++;
         }
         showEffect();
      }
      
      private function showEffect() : void
      {
         this.pivotX = 400;
         this.pivotY = 350;
         this.x = 0;
         this.y = 0;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.4,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeInOut"
         });
      }
      
      private function onIconBtn(param1:Event) : void
      {
         var selectId:int;
         var e:Event = param1;
         var dsobj:DisplayObject = e.target as DisplayObject;
         dsobj.touchable = false;
         Starling.juggler.delayCall(function():void
         {
            if(dsobj)
            {
               dsobj.touchable = true;
            }
         },1);
         selectId = parseInt((e.target as Button).name);
         if(Application.instance.isAndroid() && !Constants.isPC)
         {
            SystemProperties.boyaaPay(config_data[selectId - 1][1],(7).toString(),"1",(243).toString(),LoginData.instance.mkSiteMid(),config_data[selectId - 1][0] + "博雅币","http://bypal.boyaa.com");
         }
         else
         {
            stage.addChild(new PaymentWebDlg(config_data[selectId - 1][1],config_data[selectId - 1][0]));
            removeFromParent(true);
            markbg.removeFromParent(true);
         }
      }
      
      public function updateAccount() : void
      {
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
      
      private function onCloseBtn(param1:Event) : void
      {
         updateAccount();
         param1.target.removeEventListener("triggered",onCloseBtn);
         Starling.juggler.tween(this,0.3,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeIn",
            "onComplete":onClear
         });
      }
      
      private function onClear() : void
      {
         removeFromParent(true);
         markbg.removeFromParent(true);
      }
   }
}

