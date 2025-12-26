package com.boyaa.antwars.view.screen.shop
{
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
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
   
   public class SmallTip extends Sprite
   {
      
      private static var _instance:SmallTip;
      
      private var goodsName:TextField;
      
      private var price:TextField;
      
      private var typeTxt:TextField;
      
      private var priceValue:TextField;
      
      private var descTxt:TextField;
      
      private var goodsBox:Image;
      
      protected var priceType:Image;
      
      private var buyBtn:Button;
      
      private var btnSale:Button;
      
      private var btnUse:Button;
      
      private var containerBtns:Sprite;
      
      private var pos:Rectangle;
      
      public var buySignal:Signal = new Signal();
      
      public var useSignal:Signal = new Signal();
      
      public var saleSignal:Signal = new Signal();
      
      public function SmallTip()
      {
         super();
         if(_instance)
         {
            throw new Error("只能用getInstance()来获取实例");
         }
         init();
         addEventListener("addedToStage",onStage);
      }
      
      public static function getInstance() : SmallTip
      {
         if(_instance == null)
         {
            _instance = new SmallTip();
         }
         return _instance;
      }
      
      public function showButtonById(param1:int = 0, param2:GoodsData = null) : void
      {
         switch(param1)
         {
            case 0:
               buyBtn.visible = true;
               btnSale.visible = btnUse.visible = false;
               break;
            case 1:
               buyBtn.visible = false;
               btnSale.visible = btnUse.visible = true;
               if(param2.typeID)
               {
                  if(param2.typeID == 25 || param2.typeID == 26 || param2.typeID == 36 || param2.typeID == 42)
                  {
                     btnUse.enabled = true;
                     break;
                  }
                  btnUse.enabled = false;
               }
               break;
            case 2:
               buyBtn.visible = false;
               btnSale.visible = btnUse.visible = false;
         }
      }
      
      private function init() : void
      {
         containerBtns = new Sprite();
         var _loc1_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("tips_scale9"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         Assets.sAsset.positionDisplay(_loc1_,"shopSmallTip","bg");
         addChild(_loc1_);
         pos = Assets.getPosition("shopSmallTip","goodsName");
         this.goodsName = new TextField(pos.width,pos.height,"","Verdana",26,16777215,true);
         this.goodsName.hAlign = "left";
         goodsName.autoScale = true;
         this.goodsName.x = pos.x;
         this.goodsName.y = pos.y;
         goodsName.autoScale = true;
         this.goodsName.touchable = false;
         addChild(this.goodsName);
         pos = Assets.getPosition("shopSmallTip","price");
         this.price = new TextField(pos.width,pos.height,"出售价格:","Verdana",24,16777215,true);
         this.price.hAlign = "left";
         this.price.x = pos.x;
         this.price.y = pos.y;
         price.autoScale = true;
         this.price.touchable = false;
         addChild(this.price);
         pos = Assets.getPosition("shopSmallTip","value");
         this.priceValue = new TextField(pos.width,pos.height,"","Verdana",24,16711680,true);
         this.priceValue.hAlign = "left";
         this.priceValue.x = pos.x;
         this.priceValue.y = pos.y;
         priceValue.autoScale = true;
         this.priceValue.touchable = false;
         addChild(this.priceValue);
         priceType = new Image(Assets.sAsset.getTexture("boyaaCoinIcon"));
         Assets.positionDisplay(priceType,"shopSmallTip","img_buyType");
         addChild(this.priceType);
         pos = Assets.getPosition("shopSmallTip","type");
         this.typeTxt = new TextField(pos.width,pos.height,"类型:","Verdana",24,16777215,true);
         this.typeTxt.hAlign = "left";
         this.typeTxt.x = pos.x;
         this.typeTxt.y = pos.y;
         typeTxt.autoScale = true;
         this.typeTxt.touchable = false;
         addChild(this.typeTxt);
         pos = Assets.getPosition("shopSmallTip","desc");
         descTxt = new TextField(pos.width,pos.height,"","Verdana",24,16777215);
         descTxt.hAlign = "left";
         descTxt.autoScale = true;
         Assets.sAsset.positionDisplay(descTxt,"shopSmallTip","desc");
         descTxt.touchable = false;
         addChild(descTxt);
         buyBtn = new Button(Assets.sAsset.getTexture("buybig0"),"",Assets.sAsset.getTexture("buybig1"));
         Assets.positionDisplay(buyBtn,"shopSmallTip","btnBuy");
         buyBtn.addEventListener("triggered",onBuy);
         containerBtns.addChild(buyBtn);
         btnSale = new Button(Assets.sAsset.getTexture("bb-10"),"",Assets.sAsset.getTexture("bb-11"));
         Assets.positionDisplay(btnSale,"shopSmallTip","btn0");
         btnSale.addEventListener("triggered",onSale);
         btnSale.visible = false;
         containerBtns.addChild(btnSale);
         btnUse = new Button(Assets.sAsset.getTexture("bb-13"),"",Assets.sAsset.getTexture("bb-14"));
         Assets.positionDisplay(btnUse,"shopSmallTip","btn1");
         btnUse.addEventListener("triggered",onUse);
         btnUse.visible = false;
         containerBtns.addChild(btnUse);
         addChild(containerBtns);
      }
      
      public function setData(param1:ShopData, param2:ListItemRenderer = null) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = param1;
         this.goodsName.text = _loc4_.name;
         typeTxt.text = LangManager.t("goodType") + _loc4_.getType(_loc4_.typeID);
         this.descTxt.text = _loc4_.dec;
         if(Application.instance.currentGame.navigator.activeScreenID == "SHOP")
         {
            _loc3_ = null;
            if(_loc4_.canBuyType(1))
            {
               _loc3_ = _loc4_.getPrice(1);
               priceType.texture = Assets.sAsset.getTexture("gameGoldIcon");
            }
            else if(_loc4_.canBuyType(3))
            {
               priceType.texture = Assets.sAsset.getTexture("boyaaCoinIcon");
               _loc3_ = _loc4_.getPrice(3);
            }
            price.text = LangManager.t("sprice") + ":";
            priceValue.text = _loc3_[0][1];
         }
         else
         {
            price.text = LangManager.t("bprice") + ":";
            priceValue.text = _loc4_.getSellPrice(_loc4_.quality).toString();
            priceType.texture = Assets.sAsset.getTexture("gameGoldIcon");
         }
         if(this.goodsBox)
         {
            this.goodsBox.removeFromParent();
         }
         pos = Assets.getPosition("shopSmallTip","goodsBox");
         this.goodsBox = Assets.sAsset.getGoodsImageByRect(_loc4_.typeID,_loc4_.frameID,pos);
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
                     Starling.juggler.tween(_instance,0.5,{
                        "scaleX":0,
                        "scaleY":0,
                        "transition":"easeInBack",
                        "onComplete":clear
                     });
                  }
               }
            }
            else if(this.visible)
            {
               clear();
            }
         }
      }
      
      private function onBuy(param1:Event) : void
      {
         clear();
         buySignal.dispatch();
      }
      
      private function clear() : void
      {
         this.visible = false;
      }
   }
}

