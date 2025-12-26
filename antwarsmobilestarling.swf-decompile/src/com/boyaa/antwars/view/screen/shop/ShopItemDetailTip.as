package com.boyaa.antwars.view.screen.shop
{
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.lang.LangManager;
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class ShopItemDetailTip extends Sprite
   {
      
      private static var _instance:ShopItemDetailTip;
      
      private var buyBtn:Button;
      
      private var btnTakeoff:Button;
      
      private var btnSale:Button;
      
      private var btnUse:Button;
      
      private var btnTakeOn:Button;
      
      private var btnRenew:Button;
      
      private var goodsBox:Image;
      
      protected var priceType:Image;
      
      private var goodsName:TextField;
      
      private var levelTxt:TextField;
      
      private var typeTxt:TextField;
      
      private var gradeTxt:TextField;
      
      private var descTxt:TextField;
      
      public var priceKey:TextField;
      
      public var priceValue:TextField;
      
      public var containerBtns:Sprite;
      
      private var starSprite:Sprite;
      
      private var valueTextArr:Vector.<TextField>;
      
      private var pos:Rectangle;
      
      private var _synValueTextArr:Vector.<TextField> = new Vector.<TextField>();
      
      private var _strengthAddValueText:TextField;
      
      public var buySignal:Signal = new Signal();
      
      public var takeoffSignal:Signal = new Signal();
      
      public var takeOnSignal:Signal = new Signal();
      
      public var saleSignal:Signal = new Signal();
      
      public var useSignal:Signal = new Signal();
      
      public var renewSignal:Signal = new Signal();
      
      private var _shopData:ShopData;
      
      public function ShopItemDetailTip()
      {
         super();
         if(_instance)
         {
            throw new Error("只能用getInstance()来获取实例");
         }
         addEventListener("addedToStage",onStage);
         init();
      }
      
      public static function getInstance() : ShopItemDetailTip
      {
         if(_instance == null)
         {
            _instance = new ShopItemDetailTip();
         }
         return _instance;
      }
      
      private function init() : void
      {
         var _loc7_:Image = null;
         var _loc8_:Image = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc9_:int = 0;
         var _loc13_:TextField = null;
         var _loc14_:* = 0;
         var _loc11_:TextField = null;
         var _loc3_:int = 0;
         var _loc1_:TextField = null;
         containerBtns = new Sprite();
         valueTextArr = new Vector.<TextField>();
         var _loc10_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("tips_scale9"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         Assets.sAsset.positionDisplay(_loc10_,"checkDetail","bg");
         addChild(_loc10_);
         pos = Assets.getPosition("checkDetail","goodsName");
         this.goodsName = new TextField(pos.width,pos.height,"","Verdana",26,16777215,true);
         this.goodsName.hAlign = "left";
         goodsName.autoScale = true;
         this.goodsName.x = pos.x;
         this.goodsName.y = pos.y;
         this.goodsName.touchable = false;
         addChild(this.goodsName);
         pos = Assets.getPosition("checkDetail","level");
         this.levelTxt = new TextField(pos.width,pos.height,LangManager.t("level") + ":","Verdana",24,16777215,true);
         this.levelTxt.hAlign = "left";
         this.levelTxt.x = pos.x;
         this.levelTxt.y = pos.y;
         this.levelTxt.touchable = false;
         levelTxt.autoScale = true;
         addChild(this.levelTxt);
         pos = Assets.getPosition("checkDetail","type");
         this.typeTxt = new TextField(pos.width,pos.height,LangManager.t("goodType"),"Verdana",24,16777215,true);
         this.typeTxt.hAlign = "left";
         this.typeTxt.x = pos.x;
         this.typeTxt.y = pos.y;
         this.typeTxt.touchable = false;
         typeTxt.autoScale = true;
         addChild(this.typeTxt);
         pos = Assets.getPosition("checkDetail","grade");
         gradeTxt = new TextField(pos.width,pos.height,"Star:","Verdana",24,16777215,true);
         gradeTxt.hAlign = "left";
         gradeTxt.x = pos.x;
         gradeTxt.y = pos.y;
         gradeTxt.touchable = false;
         gradeTxt.autoScale = true;
         addChild(gradeTxt);
         starSprite = new Sprite();
         _loc5_ = 0;
         while(_loc5_ < 5)
         {
            _loc7_ = new Image(Assets.sAsset.getTexture("star2"));
            _loc7_.x = _loc5_ * _loc7_.width + 5;
            starSprite.addChild(_loc7_);
            _loc5_++;
         }
         _loc6_ = 0;
         while(_loc6_ < 5)
         {
            _loc8_ = new Image(Assets.sAsset.getTexture("star"));
            _loc8_.x = _loc6_ * _loc8_.width + 5;
            _loc8_.visible = false;
            starSprite.addChild(_loc8_);
            _loc6_++;
         }
         pos = Assets.getPosition("checkDetail","star");
         starSprite.x = pos.x;
         starSprite.y = pos.y;
         addChild(starSprite);
         var _loc4_:TextField = new TextField(pos.width,pos.height,"----- " + LangManager.t("attr") + " ------","Verdana",24,16777215,true);
         Assets.sAsset.positionDisplay(_loc4_,"checkDetail","property");
         _loc4_.hAlign = "center";
         addChild(_loc4_);
         pos = Assets.getPosition("checkDetail","key0");
         var _loc15_:Array = LangManager.ta("detailsNameArr");
         var _loc12_:Array = [_loc15_[0],_loc15_[1],_loc15_[2],_loc15_[3]];
         _loc9_ = 0;
         while(_loc9_ < 4)
         {
            _loc13_ = new TextField(pos.width,pos.height,_loc12_[_loc9_] + ":","Verdana",24,16777215,true);
            Assets.sAsset.positionDisplay(_loc13_,"checkDetail","key" + _loc9_);
            _loc13_.hAlign = "left";
            addChild(_loc13_);
            _loc9_++;
         }
         pos = Assets.getPosition("checkDetail","value0");
         _loc14_ = 0;
         while(_loc14_ < 5)
         {
            _loc11_ = new TextField(pos.width,pos.height,"","Verdana",22,6749952);
            _loc11_.touchable = false;
            _loc11_.hAlign = "left";
            _loc11_.autoScale = true;
            Assets.sAsset.positionDisplay(_loc11_,"checkDetail","value" + _loc14_);
            valueTextArr.push(_loc11_);
            addChild(_loc11_);
            _loc14_++;
         }
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            _loc1_ = new TextField(pos.width,pos.height,"+10","Verdana",22,16711680);
            _loc1_.touchable = false;
            _loc1_.hAlign = "left";
            _loc1_.autoScale = true;
            _loc1_.bold = true;
            Assets.sAsset.positionDisplay(_loc1_,"checkDetail","synValue" + _loc3_);
            _synValueTextArr.push(_loc1_);
            addChild(_loc1_);
            _loc3_++;
         }
         pos = Assets.getPosition("checkDetail","strengthAddValue");
         _strengthAddValueText = new TextField(pos.width,pos.height,"","Verdana",22,16711680);
         _strengthAddValueText.bold = true;
         Assets.sAsset.positionDisplay(_strengthAddValueText,"checkDetail","strengthAddValue");
         addChild(_strengthAddValueText);
         pos = Assets.getPosition("checkDetail","line");
         var _loc2_:TextField = new TextField(pos.width,pos.height,"-----------------------------","Verdana",24,16777215,true);
         _loc2_.x = pos.x;
         _loc2_.y = pos.y;
         _loc2_.autoScale = true;
         addChild(_loc2_);
         pos = Assets.getPosition("checkDetail","desc");
         descTxt = new TextField(pos.width,pos.height,"","Verdana",24,16777215);
         descTxt.hAlign = "left";
         descTxt.autoScale = true;
         Assets.sAsset.positionDisplay(descTxt,"checkDetail","desc");
         addChild(descTxt);
         pos = Assets.getPosition("checkDetail","priceKey");
         priceKey = new TextField(pos.width,pos.height,LangManager.t("sprice") + ":","Verdana",24,16777215,true);
         priceKey.hAlign = "left";
         Assets.sAsset.positionDisplay(priceKey,"checkDetail","priceKey");
         priceKey.autoScale = true;
         addChild(priceKey);
         pos = Assets.getPosition("checkDetail","priceValue");
         priceValue = new TextField(pos.width,pos.height,"","Verdana",24,16763904,true);
         priceValue.hAlign = "left";
         Assets.sAsset.positionDisplay(priceValue,"checkDetail","priceValue");
         priceValue.autoScale = true;
         addChild(priceValue);
         priceType = new Image(Assets.sAsset.getTexture("boyaaCoinIcon"));
         priceType.x = priceValue.x + priceType.width * 2 + 20;
         priceType.y = priceValue.y;
         addChild(this.priceType);
         buyBtn = new Button(Assets.sAsset.getTexture("buybig0"),"",Assets.sAsset.getTexture("buybig1"));
         Assets.positionDisplay(buyBtn,"checkDetail","bntBuy");
         buyBtn.addEventListener("triggered",onBuy);
         containerBtns.addChild(buyBtn);
         btnTakeoff = new Button(Assets.sAsset.getTexture("bb_takeoff_0"),"",Assets.sAsset.getTexture("bb_takeoff_1"));
         Assets.positionDisplay(btnTakeoff,"checkDetail","bntBuy");
         btnTakeoff.addEventListener("triggered",onTakeOff);
         containerBtns.addChild(btnTakeoff);
         btnSale = new Button(Assets.sAsset.getTexture("bb-10"),"",Assets.sAsset.getTexture("bb-11"));
         Assets.positionDisplay(btnSale,"checkDetail","btn0");
         btnSale.addEventListener("triggered",onSale);
         btnSale.visible = false;
         containerBtns.addChild(btnSale);
         btnUse = new Button(Assets.sAsset.getTexture("bb-13"),"",Assets.sAsset.getTexture("bb-14"));
         Assets.positionDisplay(btnUse,"checkDetail","btn1");
         btnUse.addEventListener("triggered",onUse);
         btnUse.visible = false;
         containerBtns.addChild(btnUse);
         btnTakeOn = new Button(Assets.sAsset.getTexture("bb-15"),"",Assets.sAsset.getTexture("bb-16"));
         Assets.positionDisplay(btnTakeOn,"checkDetail","btn1");
         btnTakeOn.addEventListener("triggered",onTakeOn);
         btnTakeOn.visible = false;
         containerBtns.addChild(btnTakeOn);
         btnRenew = new Button(Assets.sAsset.getTexture("bb26"),"",Assets.sAsset.getTexture("bb27"));
         Assets.positionDisplay(btnRenew,"checkDetail","btn1");
         btnRenew.addEventListener("triggered",onRenew);
         btnRenew.visible = false;
         containerBtns.addChild(btnRenew);
         addChild(containerBtns);
      }
      
      public function showButtonById(param1:int = 0) : void
      {
         switch(param1)
         {
            case 0:
               buyBtn.visible = true;
               btnTakeoff.visible = false;
               btnSale.visible = btnUse.visible = false;
               btnTakeOn.visible = btnRenew.visible = false;
               break;
            case 1:
               btnTakeoff.visible = true;
               buyBtn.visible = false;
               btnSale.visible = btnUse.visible = false;
               btnTakeOn.visible = btnRenew.visible = false;
               break;
            case 2:
               btnTakeoff.visible = false;
               buyBtn.visible = false;
               btnSale.visible = btnUse.visible = true;
               btnTakeOn.visible = btnRenew.visible = false;
               break;
            case 3:
               btnTakeoff.visible = false;
               buyBtn.visible = false;
               btnSale.visible = btnTakeOn.visible = true;
               btnUse.visible = btnRenew.visible = false;
               break;
            case 4:
               btnTakeoff.visible = false;
               buyBtn.visible = false;
               btnSale.visible = btnRenew.visible = true;
               btnUse.visible = btnTakeOn.visible = false;
               break;
            case 5:
               btnTakeoff.visible = false;
               buyBtn.visible = false;
               btnSale.visible = btnRenew.visible = false;
               btnUse.visible = btnTakeOn.visible = false;
         }
      }
      
      private function showStar(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < 5)
         {
            starSprite.getChildAt(_loc3_ + 5).visible = false;
            _loc3_++;
         }
         _loc2_ = 0;
         while(_loc2_ < param1)
         {
            starSprite.getChildAt(_loc2_ + 5).visible = true;
            _loc2_++;
         }
      }
      
      private function showGoodsAttrInfo(param1:ShopData) : void
      {
         var _loc7_:int = 0;
         var _loc4_:Array = LangManager.ta("detailsNameArr");
         var _loc2_:Array = [_loc4_[4],_loc4_[5],_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3]];
         var _loc6_:Object = {};
         if(param1.damage)
         {
            _loc6_[_loc4_[4]] = param1.damage;
            if(param1.damage_high != 0)
            {
               var _loc8_:* = _loc4_[4];
               var _loc9_:* = _loc6_[_loc8_] + ("-" + param1.damage_high);
               _loc6_[_loc8_] = _loc9_;
            }
         }
         if(param1.armor)
         {
            _loc6_[_loc4_[5]] = param1.armor;
            if(param1.armor_high != 0)
            {
               _loc9_ = _loc4_[5];
               _loc8_ = _loc6_[_loc9_] + ("-" + param1.armor_high);
               _loc6_[_loc9_] = _loc8_;
            }
         }
         if(param1.attack)
         {
            _loc6_[_loc4_[0]] = param1.attack;
            if(param1.attack_high != 0)
            {
               _loc8_ = _loc4_[0];
               _loc9_ = _loc6_[_loc8_] + ("-" + param1.attack_high);
               _loc6_[_loc8_] = _loc9_;
            }
         }
         if(param1.defense)
         {
            _loc6_[_loc4_[1]] = param1.defense;
            if(param1.defense_high != 0)
            {
               _loc9_ = _loc4_[1];
               _loc8_ = _loc6_[_loc9_] + ("-" + param1.defense_high);
               _loc6_[_loc9_] = _loc8_;
            }
         }
         if(param1.nimble)
         {
            _loc6_[_loc4_[2]] = param1.nimble;
            if(param1.nimble_high != 0)
            {
               _loc8_ = _loc4_[2];
               _loc9_ = _loc6_[_loc8_] + ("-" + param1.nimble_high);
               _loc6_[_loc8_] = _loc9_;
            }
         }
         if(param1.lucky)
         {
            _loc6_[_loc4_[3]] = param1.lucky;
            if(param1.lucky_high != 0)
            {
               _loc9_ = _loc4_[3];
               _loc8_ = _loc6_[_loc9_] + ("-" + param1.lucky_high);
               _loc6_[_loc9_] = _loc8_;
            }
         }
         if(param1.typeID == 11 || param1.typeID == 12)
         {
            valueTextArr[4].text = LangManager.t("reduceBlood") + ":" + param1.damage + "";
         }
         else if(param1.typeID == 1 || param1.typeID == 6)
         {
            valueTextArr[4].text = LangManager.t("defense") + param1.armor + "";
         }
         else
         {
            valueTextArr[4].text = "";
         }
         var _loc5_:Array = LangManager.ta("detailsNameArr");
         var _loc3_:Array = [_loc6_[_loc5_[0]],_loc6_[_loc5_[1]],_loc6_[_loc5_[2]],_loc6_[_loc5_[3]]];
         _loc7_ = 0;
         while(_loc7_ < 4)
         {
            valueTextArr[_loc7_].text = _loc3_[_loc7_];
            _loc7_++;
         }
         updateSynthesisAndStrenthData();
      }
      
      private function updateSynthesisAndStrenthData() : void
      {
         var _loc2_:GoodsData = shopData as GoodsData;
         var _loc3_:int = 0;
         if(!_loc2_)
         {
            _loc3_ = 0;
            while(_loc3_ < _synValueTextArr.length)
            {
               _synValueTextArr[_loc3_].text = "";
               _loc3_++;
            }
            _strengthAddValueText.text = "";
            return;
         }
         var _loc1_:Array = [_loc2_.attackLevel,_loc2_.defenseLevel,_loc2_.nimbleLevel,_loc2_.luckyLevel];
         _loc3_ = 0;
         while(_loc3_ < _synValueTextArr.length)
         {
            if(_loc1_[_loc3_] <= 0)
            {
               _synValueTextArr[_loc3_].text = "";
            }
            else
            {
               _synValueTextArr[_loc3_].text = "+" + _loc1_[_loc3_] * 10;
            }
            _loc3_++;
         }
         if(_loc2_.strengthenNum > 0)
         {
            _strengthAddValueText.x = valueTextArr[4].x + valueTextArr[4].textBounds.width;
            if(_loc2_.isWeapon)
            {
               _strengthAddValueText.text = "+" + Math.floor(_loc2_.damage * Math.pow(1.1,_loc2_.strengthenNum) - _loc2_.damage).toString();
            }
            else
            {
               _strengthAddValueText.text = "+" + Math.floor(_loc2_.armor * Math.pow(1.1,_loc2_.strengthenNum) - _loc2_.armor).toString();
            }
         }
         else
         {
            _strengthAddValueText.text = "";
         }
      }
      
      public function setData(param1:ShopData) : void
      {
         var _loc2_:Array = null;
         shopData = param1;
         this.goodsName.text = shopData.name;
         typeTxt.text = LangManager.t("goodType") + shopData.getType(shopData.typeID);
         showStar(shopData.quality);
         showGoodsAttrInfo(param1);
         this.descTxt.text = shopData.dec;
         this.levelTxt.text = LangManager.t("level") + ":" + shopData.lowerlevel;
         if(Application.instance.currentGame.navigator.activeScreenID == "SHOP")
         {
            _loc2_ = null;
            if(ShopScreen.buyType == 1)
            {
               _loc2_ = shopData.getPrice(1);
               priceType.texture = Assets.sAsset.getTexture("gameGoldIcon");
            }
            else
            {
               priceType.texture = Assets.sAsset.getTexture("boyaaCoinIcon");
               _loc2_ = shopData.getPrice(3);
            }
            priceKey.text = LangManager.t("bprice");
            priceValue.text = _loc2_[0][1];
         }
         else
         {
            priceKey.text = LangManager.t("sprice");
            priceValue.text = shopData.getSellPrice(shopData.quality).toString();
            priceType.texture = Assets.sAsset.getTexture("gameGoldIcon");
         }
         if(this.goodsBox)
         {
            this.goodsBox.removeFromParent();
         }
         pos = Assets.getPosition("checkDetail","goodsImg");
         this.goodsBox = Assets.sAsset.getGoodsImageByRect(shopData.typeID,shopData.frameID,pos);
         if(this.goodsBox)
         {
            this.addChild(this.goodsBox);
         }
      }
      
      private function onStage(param1:Event) : void
      {
         removeEventListener("addedToStage",init);
         stage.addEventListener("touch",onTouch);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Touch = null;
         var _loc4_:Vector.<Touch> = param1.getTouches(stage,"began");
         if(_loc4_.length > 0)
         {
            _loc2_ = param1.getTouch(this,"began");
            if(_loc2_)
            {
               _loc3_ = param1.getTouch(containerBtns,"began");
               if(!_loc3_)
               {
                  if(this.visible)
                  {
                     remove();
                  }
               }
            }
            else if(this.visible)
            {
               clear();
            }
         }
      }
      
      public function remove() : void
      {
         Starling.juggler.tween(_instance,0.5,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeInBack",
            "onComplete":clear
         });
      }
      
      private function onTakeOff(param1:Event) : void
      {
         takeoffSignal.dispatch();
         clear();
      }
      
      private function onTakeOn(param1:Event) : void
      {
         takeOnSignal.dispatch();
         clear();
      }
      
      private function onSale(param1:Event) : void
      {
         saleSignal.dispatch();
         clear();
      }
      
      private function onUse(param1:Event) : void
      {
         useSignal.dispatch();
         clear();
      }
      
      private function onRenew(param1:Event) : void
      {
         renewSignal.dispatch();
         clear();
      }
      
      private function onBuy(param1:Event) : void
      {
         this.visible = false;
         buySignal.dispatch();
      }
      
      private function clear() : void
      {
         this.visible = false;
      }
      
      public function get shopData() : ShopData
      {
         return _shopData;
      }
      
      public function set shopData(param1:ShopData) : void
      {
         _shopData = param1;
      }
   }
}

