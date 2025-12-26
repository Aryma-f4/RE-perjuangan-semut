package com.boyaa.antwars.view.screen.union.warehouse
{
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.text.TextField;
   
   public class RentGoodsListItemRender extends ListItemRenderer
   {
      
      private var _asset:ResAssetManager;
      
      private var _layout:LayoutUitl;
      
      private var goodsImage:Image;
      
      public function RentGoodsListItemRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         _asset = Assets.sAsset;
         this.bgFocusTexture = _asset.getTexture("btnS_rentGoods_bg2");
         this.bgNormalTexture = _asset.getTexture("btnS_rentGoods_bg1");
         this.bg = new Image(this.bgNormalTexture);
         this.addChild(this.bg);
         _layout = new LayoutUitl(_asset.getOther("warehouse"),_asset);
         _layout.buildLayout("RentGoodsListLayout",this);
      }
      
      override protected function commitData() : void
      {
         super.commitData();
         if(!this._data)
         {
            return;
         }
         var _loc1_:GoodsData = this._data as GoodsData;
         if(goodsImage)
         {
            goodsImage.removeFromParent();
         }
         (this.getChildByName("txt_name") as TextField).text = _loc1_.name;
         (this.getChildByName("txt_level") as TextField).text = LangManager.t("goods_0") + _loc1_.rental_price.toString();
         (this.getChildByName("txt_price") as TextField).text = LangManager.t("goods_1") + _loc1_.lowerlevel + "";
         (this.getChildByName("txt_time") as TextField).text = LangManager.t("goods_2") + _loc1_.rental_period / 60 + "jam";
         var _loc2_:Rectangle = new Rectangle(8,2,140,140);
         try
         {
            this.goodsImage = Assets.sAsset.getGoodsImageByRect(_loc1_.typeID,_loc1_.frameID,_loc2_);
            addChild(this.goodsImage);
         }
         catch(e:Error)
         {
            trace("显示物品图片失败:" + JSON.stringify(_loc1_));
         }
         getChildByName("renting").visible = _loc1_.stutas == 20;
         this.setChildIndex(getChildByName("renting"),this.numChildren - 1);
      }
   }
}

