package com.boyaa.antwars.view.screen.backpack
{
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import flash.geom.Rectangle;
   import starling.display.Image;
   
   public class BagItemRender extends ListItemRenderer
   {
      
      private var goodsBox:Image;
      
      public function BagItemRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         if(!this.bg)
         {
            this.bgFocusTexture = Assets.sAsset.getTexture("bb50");
            this.bgNormalTexture = Assets.emptyTexture();
            this.bg = new Image(this.bgNormalTexture);
            this.bg.width = this.bg.height = 160;
            this.addChild(this.bg);
         }
      }
      
      override protected function commitData() : void
      {
         if(!this._data)
         {
            return;
         }
         var _loc1_:GoodsData = this._data as GoodsData;
         if(goodsBox)
         {
            goodsBox.removeFromParent();
         }
         var _loc2_:Rectangle = Assets.getPosition("backpackitem","box");
         this.goodsBox = Assets.sAsset.getGoodsImageByRect(_loc1_.typeID,_loc1_.frameID,_loc2_);
         this.addChild(this.goodsBox);
      }
   }
}

