package com.boyaa.antwars.view.screen.union.warehouse
{
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import flash.geom.Rectangle;
   import starling.display.Image;
   
   public class BagEquipListItemRender extends ListItemRenderer
   {
      
      private var goodsImage:Image;
      
      private var _asset:ResAssetManager;
      
      public function BagEquipListItemRender()
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
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:Rectangle = new Rectangle(8,2,140,140);
         goodsImage = _asset.getGoodsImageByRect(_loc1_.typeID,_loc1_.frameID,_loc2_);
         if(goodsImage)
         {
            this.addChild(goodsImage);
         }
      }
   }
}

