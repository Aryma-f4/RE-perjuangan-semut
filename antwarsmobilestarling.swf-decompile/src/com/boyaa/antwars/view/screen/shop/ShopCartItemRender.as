package com.boyaa.antwars.view.screen.shop
{
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import flash.geom.Rectangle;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class ShopCartItemRender extends ListItemRenderer
   {
      
      protected var shopData:ShopData;
      
      private var _asset:ResAssetManager;
      
      private var _layout:LayoutUitl;
      
      private var txtNum:TextField;
      
      private var goodsImage:GoodsDetailView;
      
      public function ShopCartItemRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         if(!this.bg)
         {
            _asset = Assets.sAsset;
            this.bgFocusTexture = _asset.getTexture("cart_item_bg");
            this.bgNormalTexture = _asset.getTexture("cart_item_bg");
            this.bg = new Image(this.bgNormalTexture);
            _layout = new LayoutUitl(_asset.getOther("shop"),_asset);
            _layout.buildLayout("ShopCartItem",this);
            txtNum = getChildByName("txt_num") as TextField;
            txtNum.nativeFilters = StarlingUITools.instance.getGlowFilter(16777215,1,4,4,10);
            (this.getChildByName("btn_close") as Button).addEventListener("triggered",onDelete);
         }
      }
      
      private function onDelete(param1:Event) : void
      {
         ShopManager.instance.deleteItem(shopData);
      }
      
      override protected function commitData() : void
      {
         if(!this._data)
         {
            return;
         }
         shopData = this._data as ShopData;
         (this.getChildByName("txt_name") as TextField).text = shopData.name;
         if(this.goodsImage)
         {
            this.goodsImage.removeFromParent(true);
         }
         var _loc2_:Array = null;
         if(shopData.buyTypeInCar == 1)
         {
            _loc2_ = shopData.getPrice(1);
            (this.getChildByName("coint_type0") as DisplayObject).visible = true;
            (this.getChildByName("coint_type1") as DisplayObject).visible = false;
         }
         else
         {
            (this.getChildByName("coint_type0") as DisplayObject).visible = false;
            (this.getChildByName("coint_type1") as DisplayObject).visible = true;
            _loc2_ = shopData.getPrice(3);
         }
         if(_loc2_)
         {
            (this.getChildByName("txt_coin") as TextField).text = _loc2_[0][1];
         }
         else
         {
            (this.getChildByName("txt_coin") as TextField).text = "";
         }
         if(shopData.isEquipment)
         {
            (this.getChildByName("txt_day") as TextField).text = shopData.validperiod + "Day";
         }
         else
         {
            (this.getChildByName("txt_day") as TextField).text = "Senantiasa";
         }
         var _loc1_:DisplayObject = getChildByName("goods_rect");
         var _loc3_:Rectangle = new Rectangle(_loc1_.x,_loc1_.y,100,100);
         goodsImage = new GoodsDetailView(_loc3_,shopData);
         goodsImage.addEvent();
         addChild(goodsImage);
         txtNum.visible = shopData.amount > 0;
         txtNum.text = "X" + (shopData.amount + 1);
         this.setChildIndex(txtNum,this.numChildren - 1);
      }
   }
}

