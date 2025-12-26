package com.boyaa.antwars.view.screen.shop
{
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.union.office.UnionLittleBaseManager;
   import com.boyaa.antwars.view.ui.Radio;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class BuyDlg extends Sprite
   {
      
      private static var _closeSignal:Signal;
      
      public var buySignal:Signal;
      
      private var buyBtn:Button;
      
      private var closeBtn:Button;
      
      private var preBtn:Button;
      
      private var nextBtn:Button;
      
      private var goodsBox:Image;
      
      private var propName:TextField;
      
      private var propValidate:TextField;
      
      private var amountText:TextField;
      
      private var typeTxt:TextField;
      
      private var goldprice:TextField;
      
      private var boyaaprice:TextField;
      
      private var unionprice:TextField;
      
      private var accountData:AccountData;
      
      private var shopData:ShopData;
      
      private var posHelper:Rectangle;
      
      private var markbg:DlgMark;
      
      private var second:int = 0;
      
      private var num:int = 0;
      
      private var timer:Timer;
      
      private var timer1:Timer;
      
      private var _goldUnitPrice:uint = 0;
      
      private var _bCoinUnitPrice:uint = 0;
      
      private var _uCoinUnitPrice:uint = 0;
      
      private var radioListView:Vector.<Radio>;
      
      private const MAX_NUM:int = 999;
      
      private const TIMER:int = 100;
      
      private var _increaseNum:int = 4;
      
      private const INCREASE_TAG:int = 50;
      
      private var _isAnimate:Boolean;
      
      public function BuyDlg(param1:Boolean = true)
      {
         super();
         init();
         _isAnimate = param1;
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      public static function get closeSignal() : Signal
      {
         if(_closeSignal == null)
         {
            _closeSignal = new Signal();
         }
         return _closeSignal;
      }
      
      private function init() : void
      {
         accountData = AccountData.instance;
         markbg = new DlgMark();
         markbg.setTouchHandle(onClear);
         buySignal = new Signal();
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("find_create_system_bg"));
         Assets.sAsset.positionDisplay(_loc5_,"buyDlg","bg");
         addChild(_loc5_);
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("buy_title"));
         Assets.sAsset.positionDisplay(_loc2_,"buyDlg","title");
         _loc2_.touchable = false;
         addChild(_loc2_);
         posHelper = Assets.getPosition("buyDlg","line");
         var _loc4_:TextField = new TextField(644,90,"------------","Verdana",90,4531203,true);
         _loc4_.x = posHelper.x - 45;
         _loc4_.y = posHelper.y - 20;
         addChild(_loc4_);
         buyBtn = new Button(Assets.sAsset.getTexture("buybig0"),"",Assets.sAsset.getTexture("buybig1"));
         Assets.positionDisplay(buyBtn,"buyDlg","buyBtn");
         buyBtn.addEventListener("triggered",onBuy);
         addChild(buyBtn);
         closeBtn = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         Assets.positionDisplay(closeBtn,"buyDlg","closeBtn");
         closeBtn.addEventListener("triggered",onclose);
         addChild(closeBtn);
         closeBtn.y += 10;
         posHelper = Assets.getPosition("buyDlg","titletext1");
         var _loc1_:TextField = new TextField(posHelper.width,posHelper.height,"","Verdana",30,4660230,true);
         _loc1_.hAlign = "left";
         _loc1_.x = posHelper.x;
         _loc1_.y = posHelper.y;
         _loc1_.autoScale = true;
         _loc1_.touchable = false;
         _loc1_.text = LangManager.t("pleaseselectamount");
         addChild(_loc1_);
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("buydlgtextbg"));
         Assets.positionDisplay(_loc3_,"buyDlg","textbg");
         addChild(_loc3_);
         posHelper = Assets.getPosition("buyDlg","amount");
         amountText = new TextField(posHelper.width,posHelper.height,"","Verdana",50,16777215,true);
         amountText.nativeFilters = [new GlowFilter(4660230,1,6,6,10)];
         amountText.hAlign = "center";
         amountText.x = posHelper.x;
         amountText.y = posHelper.y;
         amountText.touchable = false;
         addChild(amountText);
         amountText.text = "1";
         preBtn = new Button(Assets.sAsset.getTexture("go0"),"",Assets.sAsset.getTexture("go1"));
         Assets.positionDisplay(preBtn,"buyDlg","preBtn");
         preBtn.addEventListener("triggered",onDown);
         preBtn.addEventListener("touch",onPreBtn);
         addChild(preBtn);
         preBtn.visible = false;
         nextBtn = new Button(Assets.sAsset.getTexture("go0"),"",Assets.sAsset.getTexture("go1"));
         nextBtn.pivotX = nextBtn.width;
         Assets.positionDisplay(nextBtn,"buyDlg","nextBtn");
         nextBtn.x -= 60;
         nextBtn.scaleX = -nextBtn.scaleX;
         nextBtn.addEventListener("triggered",onUp);
         nextBtn.addEventListener("touch",onNextBtn);
         addChild(nextBtn);
         posHelper = Assets.getPosition("buyDlg","propName");
         propName = new TextField(posHelper.width,posHelper.height,"","Verdana",26,4531203,true);
         propName.hAlign = "left";
         propName.x = posHelper.x;
         propName.y = posHelper.y;
         propName.autoScale = true;
         propName.touchable = false;
         addChild(propName);
         posHelper = Assets.getPosition("buyDlg","type");
         this.typeTxt = new TextField(posHelper.width,posHelper.height,"类型:","Verdana",24,4531203,true);
         this.typeTxt.hAlign = "left";
         this.typeTxt.x = posHelper.x;
         this.typeTxt.y = posHelper.y;
         this.typeTxt.autoScale = true;
         this.typeTxt.touchable = false;
         addChild(this.typeTxt);
         posHelper = Assets.getPosition("buyDlg","validate");
         propValidate = new TextField(posHelper.width,posHelper.height,"","Verdana",26,4531203,true);
         propValidate.hAlign = "left";
         propValidate.x = posHelper.x;
         propValidate.y = posHelper.y;
         propValidate.autoScale = true;
         propValidate.touchable = false;
         addChild(propValidate);
         radioListView = new Vector.<Radio>();
         timer = new Timer(100);
         timer1 = new Timer(100);
         timer.addEventListener("timer",onTimer);
         timer1.addEventListener("timer",onTimer1);
      }
      
      public function setData(param1:ShopData) : void
      {
         var _loc10_:int = 0;
         var _loc6_:Radio = null;
         var _loc3_:TextField = null;
         var _loc2_:Image = null;
         var _loc9_:TextField = null;
         shopData = param1;
         propName.text = shopData.name;
         typeTxt.text = LangManager.t("goodType") + shopData.getType(shopData.typeID);
         if(shopData.priceList.length == 0 || shopData.priceList[0][0] == 0)
         {
            propValidate.text = LangManager.t("validate") + LangManager.t("yjyx");
         }
         else
         {
            propValidate.text = LangManager.t("validate") + shopData.priceList[0][0] + LangManager.t("dayUnit");
         }
         var _loc5_:Array = shopData.getPrice(1);
         var _loc8_:Array = shopData.getPrice(3);
         var _loc7_:Array = shopData.getPrice(5);
         var _loc11_:Array = [];
         if(shopData.canBuyType(1) && _loc5_)
         {
            _goldUnitPrice = _loc5_[0][1];
            _loc11_.push({
               "name":LangManager.t("gold") + ":",
               "type":1,
               "price":_loc5_[0][1]
            });
         }
         else if(shopData.canBuyType(3) && _loc8_)
         {
            _bCoinUnitPrice = _loc8_[0][1];
            _loc11_.push({
               "name":LangManager.t("shop_paycoin") + ":",
               "type":2,
               "price":_loc8_[0][1]
            });
         }
         else if(shopData.canBuyType(5) && _loc7_)
         {
            _uCoinUnitPrice = _loc7_[0][1];
            _loc11_.push({
               "name":LangManager.t("contributor") + ":",
               "type":3,
               "price":_uCoinUnitPrice
            });
         }
         var _loc4_:Array = ["","gameGoldIcon","boyaaCoinIcon","unionDevoteIcon"];
         _loc10_ = 0;
         while(_loc10_ < _loc11_.length)
         {
            _loc6_ = new Radio(_loc11_[_loc10_]);
            radioListView.push(_loc6_);
            if(_loc10_ == 0)
            {
               _loc6_.data = true;
            }
            posHelper = Assets.getPosition("buyDlg","text" + (_loc10_ + 1));
            _loc3_ = new TextField(posHelper.width,posHelper.height,"","Verdana",25,4660230,true);
            _loc3_.autoScale = true;
            _loc3_.text = _loc11_[_loc10_].name;
            _loc3_.hAlign = "right";
            _loc3_.x = posHelper.x;
            _loc3_.y = posHelper.y;
            addChild(_loc3_);
            _loc3_.touchable = false;
            _loc2_ = new Image(Assets.sAsset.getTexture(_loc4_[_loc11_[_loc10_].type]));
            Assets.positionDisplay(_loc2_,"buyDlg","icon" + (_loc10_ + 1));
            addChild(_loc2_);
            posHelper = Assets.getPosition("buyDlg","price" + (_loc10_ + 1));
            _loc9_ = new TextField(posHelper.width,posHelper.height,"","Verdana",28,16776960,true);
            _loc9_.nativeFilters = [new GlowFilter(4660230,1,6,6,10)];
            _loc9_.text = _loc11_[_loc10_].price;
            _loc9_.hAlign = "left";
            _loc9_.x = posHelper.x;
            _loc9_.y = posHelper.y;
            addChild(_loc9_);
            _loc9_.touchable = false;
            trace("radioList[i].type" + _loc11_[_loc10_].type);
            if(_loc11_[_loc10_].type == 1)
            {
               goldprice = _loc9_;
            }
            else if(_loc11_[_loc10_].type == 2)
            {
               boyaaprice = _loc9_;
            }
            else
            {
               unionprice = _loc9_;
            }
            _loc10_++;
         }
         posHelper = Assets.getPosition("buyDlg","goodsbox");
         goodsBox = Assets.sAsset.getGoodsImageByRect(shopData.typeID,shopData.frameID,posHelper);
         addChild(goodsBox);
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
            if(this.parent as Shop)
            {
               Guide.instance.stop();
            }
            if(buySignal)
            {
               buySignal.dispatch();
            }
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
      
      private function updatePrice(param1:int) : void
      {
         trace(boyaaprice,goldprice,param1,_goldUnitPrice);
         if(goldprice)
         {
            goldprice.text = (param1 * _goldUnitPrice).toString();
         }
         if(boyaaprice)
         {
            boyaaprice.text = (param1 * _bCoinUnitPrice).toString();
         }
         if(unionprice)
         {
            unionprice.text = (param1 * _uCoinUnitPrice).toString();
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         parent.addChild(markbg);
         parent.swapChildren(markbg,this);
         if(_isAnimate)
         {
            this.pivotX = 322;
            this.pivotY = 294;
            this.x = 702;
            this.y = 384;
            this.scaleX = this.scaleY = 0;
            Starling.juggler.tween(this,0.5,{
               "scaleX":1,
               "scaleY":1,
               "transition":"easeOutBack",
               "onComplete":onCompleteHandler
            });
         }
      }
      
      private function onCompleteHandler() : void
      {
         if(this.parent as Shop)
         {
            if((this.parent as Shop).inGuide)
            {
               Guide.instance.guide(buyBtn,"",true);
               nextBtn.enabled = false;
            }
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
      
      private function onDown(param1:Event = null) : void
      {
         var _loc2_:int = int(amountText.text);
         if(_loc2_ > 1)
         {
            _loc2_--;
            amountText.text = _loc2_.toString();
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
         var _loc2_:int = int(amountText.text);
         if(_loc2_ < 999)
         {
            _loc2_++;
            amountText.text = _loc2_.toString();
            updatePrice(_loc2_);
            if(_loc2_ == 999)
            {
               nextBtn.visible = false;
            }
            preBtn.visible = true;
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
      
      private function onclose(param1:Event) : void
      {
         if(this.parent as Shop)
         {
            Guide.instance.stop();
            (this.parent as Shop).inGuide = false;
         }
         if(_isAnimate)
         {
            Starling.juggler.tween(this,0.5,{
               "scaleX":0,
               "scaleY":0,
               "transition":"easeInBack",
               "onComplete":onClear
            });
         }
         else
         {
            onClear();
         }
         closeBtn.removeEventListener("triggered",onclose);
      }
      
      private function onClear() : void
      {
         buyBtn.removeEventListener("triggered",onBuy);
         timer && timer.removeEventListener("timer",onTimer);
         timer1 && timer1.removeEventListener("timer",onTimer1);
         timer = null;
         timer1 = null;
         markbg.removeFromParent(true);
         removeFromParent(true);
         closeSignal.dispatch();
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
               _buy(shopData,radioListView[_loc2_].item.type,int(amountText.text));
            }
            _loc2_++;
         }
      }
      
      override public function dispose() : void
      {
         buySignal.removeAll();
         buySignal = null;
         super.dispose();
      }
   }
}

