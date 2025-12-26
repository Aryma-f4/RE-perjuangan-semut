package com.boyaa.antwars.view.screen.shop
{
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.BaseDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.union.office.UnionLittleBaseManager;
   import com.boyaa.antwars.view.ui.Radio;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import org.osflash.signals.Signal;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class ShopBuyDlg extends BaseDlg
   {
      
      private static var _closeSignal:Signal;
      
      public var buySignal:Signal;
      
      private var _layout:LayoutUitl;
      
      private var accountData:AccountData;
      
      private var txtAmout:TextField;
      
      private var txtPrice:TextField;
      
      private var propName:TextField;
      
      private var closeBtn:Button;
      
      private var preBtn:Button;
      
      private var nextBtn:Button;
      
      private var buyBtn:Button;
      
      private var second:int = 0;
      
      private var num:int = 0;
      
      private var timer:Timer;
      
      private var timer1:Timer;
      
      private var _increaseNum:int = 4;
      
      private const INCREASE_TAG:int = 50;
      
      private const MAX_NUM:int = 999;
      
      private const TIMER:int = 100;
      
      private var _isAnimate:Boolean;
      
      private var _unitPice:uint = 0;
      
      private var _goldUnitPrice:uint = 0;
      
      private var _bCoinUnitPrice:uint = 0;
      
      private var _uCoinUnitPrice:uint = 0;
      
      private var radioListView:Vector.<Radio>;
      
      private var shopData:ShopData;
      
      private var goodsBox:Image;
      
      protected var _asset:ResAssetManager;
      
      protected var _rawAssets:Array = [];
      
      protected var rmger:ResManager;
      
      public function ShopBuyDlg(param1:Boolean = true, param2:ShopData = null)
      {
         super();
         _isAnimate = param1;
         _asset = Assets.sAsset;
         shopData = param2;
         buySignal = new Signal();
         loadAssetDone(1);
      }
      
      public static function get closeSignal() : Signal
      {
         if(_closeSignal == null)
         {
            _closeSignal = new Signal();
         }
         return _closeSignal;
      }
      
      protected function loadAssetDone(param1:int) : void
      {
         if(param1 == 1)
         {
            _layout = new LayoutUitl(Assets.sAsset.getOther("buyDlg"),Assets.sAsset);
            _layout.buildLayout("BuyDlg",_displayObj);
            SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
            init();
         }
      }
      
      private function init() : void
      {
         radioListView = new Vector.<Radio>();
         accountData = AccountData.instance;
         txtAmout = getTextFieldByName("amount");
         txtPrice = getTextFieldByName("txt_price0");
         propName = getTextFieldByName("txt_name");
         txtAmout.text = "1";
         preBtn = getButtonByName("preBtn");
         closeBtn = getButtonByName("btnS_Close");
         nextBtn = getButtonByName("nextBtn");
         buyBtn = getButtonByName("btnS_Buy");
         addEvent();
         setData(shopData);
         showGuide();
      }
      
      public function setData(param1:ShopData) : void
      {
         var _loc6_:int = 0;
         var _loc12_:Radio = null;
         var _loc2_:Image = null;
         var _loc8_:DisplayObject = null;
         var _loc13_:Point = null;
         shopData = param1;
         propName.text = shopData.name;
         var _loc3_:Array = shopData.getPrice(1);
         var _loc14_:Array = shopData.getPrice(3);
         var _loc11_:Array = shopData.getPrice(5);
         var _loc5_:Array = [];
         if(_loc11_ && _loc11_.length > 0)
         {
            _unitPice = _loc11_[0][1];
            _loc5_.push({
               "name":LangManager.t("contributor") + ":",
               "type":3,
               "price":_unitPice
            });
         }
         else
         {
            if(ShopScreen.buyType == 1)
            {
               _loc5_.push({
                  "name":LangManager.t("gold") + ":",
                  "type":1,
                  "price":_loc3_[0][1]
               });
            }
            else if(ShopScreen.buyType == 3)
            {
               _loc5_.push({
                  "name":LangManager.t("shop_paycoin") + ":",
                  "type":2,
                  "price":_loc14_[0][1]
               });
            }
            _unitPice = shopData.getPrice(ShopScreen.buyType)[0][1];
         }
         var _loc9_:Array = ["","gameGoldIcon","boyaaCoinIcon","unionDevoteIcon"];
         _loc6_ = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc12_ = new Radio(_loc5_[_loc6_]);
            radioListView.push(_loc12_);
            if(_loc6_ == 0)
            {
               _loc12_.data = true;
            }
            _loc2_ = new Image(Assets.sAsset.getTexture(_loc9_[_loc5_[_loc6_].type]));
            addChild(_loc2_);
            _loc8_ = getDisplayObjByName("icon_pos");
            _loc13_ = _loc8_.parent.localToGlobal(new Point(_loc8_.x,_loc8_.y));
            _loc2_.x = _loc13_.x;
            _loc2_.y = _loc13_.y;
            _loc2_.width = _loc8_.width;
            _loc2_.height = _loc8_.height;
            trace("radioList[i].type" + _loc5_[_loc6_].type);
            _loc6_++;
         }
         var _loc7_:DisplayObject = getDisplayObjByName("goodsbox");
         var _loc10_:Point = _loc7_.parent.localToGlobal(new Point(_loc7_.x,_loc7_.y));
         var _loc4_:Rectangle = new Rectangle(_loc10_.x,_loc10_.y,_loc7_.width,_loc7_.height);
         goodsBox = Assets.sAsset.getGoodsImageByRect(shopData.typeID,shopData.frameID,_loc4_);
         addChild(goodsBox);
         updatePrice(1);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         if(_isAnimate)
         {
         }
      }
      
      private function showGuide() : void
      {
         if(ShopScreen.inGuide)
         {
            Guide.instance.guide(buyBtn,"",true);
            closeBtn.enabled = false;
            nextBtn.enabled = false;
         }
      }
      
      private function onPreBtn(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(preBtn);
         if(_loc2_ && _loc2_.phase == "began")
         {
            timer1.start();
         }
         else if(_loc2_ && _loc2_.phase == "ended")
         {
            timer1.reset();
            preBtn.removeEventListener("enterFrame",onDecrease);
         }
      }
      
      private function onNextBtn(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(nextBtn);
         if(_loc2_ && _loc2_.phase == "began")
         {
            timer.start();
         }
         else if(_loc2_ && _loc2_.phase == "ended")
         {
            timer.reset();
            nextBtn.removeEventListener("enterFrame",onIncrease);
            _increaseNum = 4;
            num = 0;
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         second = second + 1;
         if(second >= 1)
         {
            nextBtn.addEventListener("enterFrame",onIncrease);
            timer.reset();
            second = 0;
         }
      }
      
      private function onTimer1(param1:TimerEvent) : void
      {
         second = second + 1;
         if(second >= 1)
         {
            preBtn.addEventListener("enterFrame",onDecrease);
            timer1.reset();
            second = 0;
         }
      }
      
      private function onIncrease(param1:EnterFrameEvent) : void
      {
         num = num + 1;
         if(num % _increaseNum == 0)
         {
            onUp();
         }
         if(num % 50 == 0)
         {
            _increaseNum = _increaseNum - 1;
         }
         if(_increaseNum <= 1)
         {
            _increaseNum = 1;
         }
      }
      
      private function onDecrease(param1:EnterFrameEvent) : void
      {
         num = num + 1;
         if(num % _increaseNum == 0)
         {
            onDown();
         }
         if(num % 50 == 0)
         {
            _increaseNum = _increaseNum - 1;
         }
         if(_increaseNum <= 1)
         {
            _increaseNum = 1;
         }
      }
      
      private function onDown(param1:Event = null) : void
      {
         var _loc2_:int = int(txtAmout.text);
         if(_loc2_ > 1)
         {
            _loc2_--;
            txtAmout.text = _loc2_.toString();
            updatePrice(_loc2_);
            nextBtn.visible = true;
            if(_loc2_ <= 1)
            {
               preBtn.visible = false;
            }
         }
      }
      
      private function onUp(param1:Event = null) : void
      {
         var _loc2_:int = int(txtAmout.text);
         if(_loc2_ < 999)
         {
            _loc2_++;
            txtAmout.text = _loc2_.toString();
            updatePrice(_loc2_);
            if(_loc2_ == 999)
            {
               nextBtn.visible = false;
            }
            preBtn.visible = true;
         }
      }
      
      private function updatePrice(param1:int) : void
      {
         txtPrice.text = (param1 * _unitPice).toString();
      }
      
      private function addEvent() : void
      {
         buyBtn.addEventListener("triggered",onBuy);
         closeBtn.addEventListener("triggered",onclose);
         preBtn.addEventListener("triggered",onDown);
         preBtn.addEventListener("touch",onPreBtn);
         nextBtn.addEventListener("triggered",onUp);
         nextBtn.addEventListener("touch",onNextBtn);
         timer = new Timer(100);
         timer1 = new Timer(100);
         timer.addEventListener("timer",onTimer);
         timer1.addEventListener("timer",onTimer1);
      }
      
      private function onBuy(param1:Event) : void
      {
         var _loc2_:int = 0;
         buyBtn.enabled = false;
         _loc2_ = 0;
         while(_loc2_ < radioListView.length)
         {
            trace(radioListView[_loc2_].data);
            if(radioListView[_loc2_].data)
            {
               _buy(shopData,radioListView[_loc2_].item.type,int(txtAmout.text));
            }
            _loc2_++;
         }
      }
      
      private function _buy(param1:ShopData, param2:uint, param3:uint) : void
      {
         var price:Array;
         var ary:Array;
         var i:uint;
         var item:ShopData = param1;
         var buyType:uint = param2;
         var buyNum:uint = param3;
         var serverBuyType:uint = 0;
         if(buyType == 1)
         {
            serverBuyType = 1;
            trace("购买类型:[金币]" + buyType,AccountData.instance.gameGold,serverBuyType);
         }
         else if(buyType == 2)
         {
            serverBuyType = 3;
            trace("购买类型:[博雅币]" + buyType,AccountData.instance.boyaaCoin,serverBuyType);
         }
         else if(buyType == 3)
         {
            serverBuyType = 5;
            trace("购买类型:[贡献值]" + buyType,UnionManager.getInstance().myUnionModel.mdevote,serverBuyType);
         }
         trace("[shopData]typeId:",item.typeID," frameId:",item.frameID);
         price = item.getPrice(serverBuyType);
         if(serverBuyType == 1 && AccountData.instance.gameGold < price[0][1] * buyNum)
         {
            buyBtn.enabled = true;
            SystemTip.instance.showSystemAlert(LangManager.t("rechargeBoyaaGold"),function():void
            {
               Application.instance.currentGame.mainMenu.onRechargeBtn();
            },function():void
            {
            });
            return;
         }
         if(serverBuyType == 3 && AccountData.instance.boyaaCoin < price[0][1] * buyNum)
         {
            buyBtn.enabled = true;
            SystemTip.instance.showSystemAlert(LangManager.t("rechargeBoyaaGold"),function():void
            {
               Application.instance.currentGame.mainMenu.onRechargeBtn();
            },function():void
            {
            });
            return;
         }
         if(serverBuyType == 5 && UnionManager.getInstance().myUnionModel.mdevote < price[0][1] * buyNum)
         {
            buyBtn.enabled = true;
            SystemTip.instance.showSystemAlert(LangManager.t("unionShopFailTip0"),function():void
            {
               UnionLittleBaseManager.instance.showLittleDlg("DONATE_DLG");
            },function():void
            {
            });
            return;
         }
         ary = [];
         if(!item.isconsum)
         {
            i = 0;
            while(i < buyNum)
            {
               ary.push([serverBuyType,item.typeID,item.frameID,price[0][0],1,""]);
               i = i + 1;
            }
         }
         else
         {
            ary.push([serverBuyType,item.typeID,item.frameID,price[0][0],buyNum,""]);
         }
         if(item.vipGood)
         {
            GameServer.instance.buy(2,ary,function(param1:Object):void
            {
               buyBtn.enabled = true;
               buyCallBack(param1);
            });
            return;
         }
         if(buyType == 3)
         {
            GameServer.instance.buy(1,ary,function(param1:Object):void
            {
               buyBtn.enabled = true;
               buyCallBack(param1);
            });
         }
         else
         {
            GameServer.instance.buy(0,ary,function(param1:Object):void
            {
               buyBtn.enabled = true;
               buyCallBack(param1);
            });
         }
      }
      
      public function buyCallBack(param1:Object) : void
      {
         trace("[buyCallBack]",JSON.stringify(param1));
         if(param1.ret == 0)
         {
            GoodsList.instance.addGoodsByAry(param1.data.goodsAry);
            if(param1.data.money.gameGold != 0)
            {
               accountData.gameGold -= param1.data.money.gameGold;
               MissionManager.instance.updateMissionData(106);
            }
            if(param1.data.money.boyaaCoin != 0)
            {
               accountData.boyaaCoin -= param1.data.money.boyaaCoin;
               MissionManager.instance.updateMissionData(176,1,0);
            }
            if(param1.data.money.contribute != 0)
            {
               UnionManager.getInstance().myUnionModel.mdevote = UnionManager.getInstance().myUnionModel.mdevote - param1.data.money.contribute;
            }
            if(ShopScreen.inGuide)
            {
               Guide.instance.stop();
            }
            if(buySignal)
            {
               buySignal.dispatch();
            }
            ShopManager.instance.buySignal.dispatch();
            TextTip.instance.show(LangManager.t("shop_success"));
            onClear();
            closeBtn.removeEventListener("triggered",onclose);
         }
         else if(shopData.vipGood)
         {
            TextTip.instance.show(LangManager.t("noVipCannotBuy"));
         }
         else
         {
            TextTip.instance.show(LangManager.t("shop_fail"));
         }
      }
      
      private function onclose(param1:Event) : void
      {
         if(ShopScreen.inGuide)
         {
            Guide.instance.stop();
         }
         onClear();
         closeBtn.removeEventListener("triggered",onclose);
      }
      
      private function onClear() : void
      {
         buyBtn.removeEventListener("triggered",onBuy);
         timer && timer.removeEventListener("timer",onTimer);
         timer1 && timer1.removeEventListener("timer",onTimer1);
         timer = null;
         timer1 = null;
         removeFromParent(true);
         closeSignal.dispatch();
      }
      
      override public function dispose() : void
      {
         buySignal.removeAll();
         buySignal = null;
         super.dispose();
      }
   }
}

