package com.boyaa.antwars.view.screen.forge
{
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.view.display.ClickSprite;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import org.osflash.signals.Signal;
   import starling.display.Image;
   import starling.text.TextField;
   
   public class ForgeGoodsBox extends ClickSprite
   {
      
      public static var updateSignal:Signal = new Signal();
      
      private var _bg:Image;
      
      private var _goodsImg:Image;
      
      private var _amountText:TextField;
      
      private var _good:GoodsData;
      
      private var _triggerFunction:Function;
      
      public function ForgeGoodsBox(param1:GoodsData, param2:Function)
      {
         super();
         _good = param1;
         _triggerFunction = param2;
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Image = null;
         _bg = new Image(Assets.sAsset.getTexture("forgebg11"));
         this.addChild(_bg);
         _goodsImg = Assets.sAsset.getGoodsImageByRect(_good.typeID,_good.frameID,new Rectangle(0,0,_bg.width - 10,_bg.height - 10));
         _goodsImg.touchable = false;
         this.addChild(_goodsImg);
         this.name = _good.onlyID.toString();
         this.addEventListener("triggered",_triggerFunction);
         if(_good.place == 1)
         {
            _loc1_ = new Image(Assets.sAsset.getTexture("bb-17"));
            _loc1_.touchable = false;
            this.addChild(_loc1_);
         }
         _amountText = new TextField(70,40,"","Verdana",28,16776960,true);
         _amountText.nativeFilters = [new GlowFilter(4660230,1,6,6,10)];
         _amountText.autoScale = true;
         _amountText.hAlign = "right";
         _amountText.vAlign = "center";
         _amountText.x = 70;
         _amountText.y = 100;
         _amountText.touchable = false;
         this.addChild(_amountText);
         updateShow();
         updateSignal.add(updateShow);
      }
      
      private function updateShow() : void
      {
         if(_good.strengthenNum > 0)
         {
            _amountText.text = "+" + _good.strengthenNum.toString();
            _amountText.color = 16776960;
         }
         if(!_good.isEquipment)
         {
            _amountText.text = "x" + _good.amount.toString();
            _amountText.color = 16777215;
            if(_good.amount == 0)
            {
               this.removeFromParent(true);
            }
         }
      }
   }
}

