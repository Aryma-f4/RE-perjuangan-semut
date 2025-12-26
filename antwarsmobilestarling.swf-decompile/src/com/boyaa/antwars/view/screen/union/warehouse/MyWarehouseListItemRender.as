package com.boyaa.antwars.view.screen.union.warehouse
{
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.filters.ColorMatrixFilter;
   
   public class MyWarehouseListItemRender extends ListItemRenderer
   {
      
      private var _asset:ResAssetManager;
      
      private var _layout:LayoutUitl;
      
      private var goodsImage:Image;
      
      public function MyWarehouseListItemRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         _asset = Assets.sAsset;
         this.bgFocusTexture = _asset.getTexture("btnS_grid2");
         this.bgNormalTexture = _asset.getTexture("btnS_grid1");
         this.bg = new Image(this.bgNormalTexture);
         this.addChild(this.bg);
         _layout = new LayoutUitl(_asset.getOther("warehouse"),_asset);
         _layout.buildLayout("GridLayout",this);
         this.getChildByName("renting").visible = false;
      }
      
      override protected function commitData() : void
      {
         super.commitData();
         if(!this._data)
         {
            return;
         }
         if(goodsImage)
         {
            goodsImage.removeFromParent();
         }
         var _loc1_:GoodsData = this._data as GoodsData;
         this.getChildByName("renting").visible = false;
         if(_loc1_.typeID == 0 && _loc1_.frameID == 0)
         {
            this.getChildByName("lock").visible = true;
            return;
         }
         this.getChildByName("lock").visible = false;
         if(_loc1_.typeID == -1)
         {
            return;
         }
         var _loc2_:Rectangle = new Rectangle(8,2,140,140);
         goodsImage = _asset.getGoodsImageByRect(_loc1_.typeID,_loc1_.frameID,_loc2_);
         if(goodsImage)
         {
            this.addChild(goodsImage);
         }
         if(_loc1_.rentStatus == 1)
         {
            this.setChildIndex(this.getChildByName("renting"),this.numChildren - 1);
            setGrayFitlers(goodsImage);
         }
         this.getChildByName("renting").visible = _loc1_.rentStatus == 1;
      }
      
      protected function setGrayFitlers(param1:Image) : void
      {
         var _loc2_:ColorMatrixFilter = new ColorMatrixFilter();
         _loc2_.adjustSaturation(-1);
         param1.filter = _loc2_;
      }
   }
}

