package com.boyaa.antwars.view.screen.shop
{
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class ShopItemRenderer extends ListItemRenderer
   {
      
      protected var shopData:ShopData;
      
      private var _asset:ResAssetManager;
      
      private var _layout:LayoutUitl;
      
      private var goodsImage:Image;
      
      private var image:GoodsDetailView;
      
      public function ShopItemRenderer()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         if(!this.bg)
         {
            _asset = Assets.sAsset;
            this.bgFocusTexture = _asset.getTexture("item_bg");
            this.bgNormalTexture = _asset.getTexture("item_bg");
            this.bg = new Image(this.bgNormalTexture);
            this.addChild(this.bg);
            _layout = new LayoutUitl(_asset.getOther("shop"),_asset);
            _layout.buildLayout("ShopItemRender",this);
            (this.getChildByName("btnS_buy") as Button).addEventListener("triggered",onbuyBtn);
            (this.getChildByName("btnS_intocart") as Button).addEventListener("triggered",onCartBtn);
         }
      }
      
      private function onCartBtn(param1:Event) : void
      {
         var goodsbg:DisplayObject;
         var pt:Point;
         var pos:Rectangle;
         var goodsImg:Image;
         var shopdata:ShopData;
         var e:Event = param1;
         if(ShopScreen.inGuide)
         {
            return;
         }
         goodsbg = getChildByName("goods_bg");
         pt = this.localToGlobal(new Point(goodsbg.x,goodsbg.y));
         pos = new Rectangle(pt.x,pt.y,140,140);
         goodsImg = Assets.sAsset.getGoodsImageByRect(shopData.typeID,shopData.frameID,pos);
         stage.addChild(goodsImg);
         goodsImg.x = pt.x;
         goodsImg.y = pt.y;
         shopdata = new ShopData();
         shopdata.buyTypeInCar = ShopScreen.buyType;
         shopdata.copyShopData(shopData);
         Starling.juggler.tween(goodsImg,1,{
            "x":1000,
            "y":700,
            "scaleX":0.3,
            "scaleY":0.3,
            "onComplete":function():void
            {
               goodsImg.removeFromParent();
               ShopManager.instance.intoShoppingCart(shopdata);
            }
         });
      }
      
      private function onbuyBtn(param1:Event) : void
      {
         if(ShopScreen.inGuide)
         {
            if(shopData.typeID != 15 || shopData.frameID != 1013)
            {
               return;
            }
         }
         ShopManager.instance.showBuyDlgByData(shopData);
      }
      
      override protected function commitData() : void
      {
         if(!this._data)
         {
            return;
         }
         shopData = this._data as ShopData;
         (this.getChildByName("txt_name") as TextField).text = shopData.name;
         if(this.image)
         {
            this.image.removeFromParent(true);
         }
         var _loc2_:Array = null;
         _loc2_ = shopData.getPrice(ShopScreen.buyType);
         if(ShopScreen.buyType == 3)
         {
            (this.getChildByName("coint_type0") as DisplayObject).visible = false;
            (this.getChildByName("coint_type1") as DisplayObject).visible = true;
         }
         else
         {
            (this.getChildByName("coint_type0") as DisplayObject).visible = true;
            (this.getChildByName("coint_type1") as DisplayObject).visible = false;
         }
         if(shopData.isEquipment)
         {
            (this.getChildByName("txt_num") as TextField).text = shopData.validperiod + "Day";
         }
         else
         {
            (this.getChildByName("txt_num") as TextField).text = "Senantiasa";
         }
         if(_loc2_)
         {
            (this.getChildByName("txt_coin") as TextField).text = _loc2_[0][1];
         }
         else
         {
            (this.getChildByName("txt_coin") as TextField).text = "";
         }
         var _loc1_:DisplayObject = getChildByName("goods_bg");
         var _loc3_:Rectangle = new Rectangle(_loc1_.x,_loc1_.y,140,140);
         if(!shopData.isEquipment)
         {
            image = new GoodsDetailView(_loc3_,shopData);
         }
         else
         {
            image = new GoodsDetailView(_loc3_,shopData,true);
         }
         image.addEvent();
         addChild(image);
         showStar(shopData.quality);
      }
      
      protected function showStar(param1:int) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:Array = [70,40,100];
         param1 = int(param1 > 3 ? 3 : param1);
         _loc4_ = 0;
         while(_loc4_ < 3)
         {
            _loc2_ = this.getChildByName("star" + _loc4_);
            _loc2_.visible = false;
            _loc2_.x = _loc5_[_loc4_];
            _loc4_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param1)
         {
            _loc2_ = this.getChildByName("star" + _loc3_);
            _loc2_.visible = true;
            this.setChildIndex(_loc2_,this.numChildren - 1);
            if(param1 == 2)
            {
               _loc2_.x += 18;
            }
            _loc3_++;
         }
      }
      
      private function setPosition(param1:int) : void
      {
         if(param1 == 2)
         {
         }
      }
   }
}

