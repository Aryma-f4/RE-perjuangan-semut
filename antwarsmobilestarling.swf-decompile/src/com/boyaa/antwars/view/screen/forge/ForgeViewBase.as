package com.boyaa.antwars.view.screen.forge
{
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.view.screen.forge.tip.ForgeDoneTip;
   import com.boyaa.antwars.view.screen.forge.tip.ForgeQuickyBuy;
   import org.osflash.signals.Signal;
   import starling.display.Image;
   
   public class ForgeViewBase extends UIExportSprite
   {
      
      protected var _equipData:GoodsData;
      
      protected var _stoneData:GoodsData;
      
      protected var _tip:ForgeDoneTip;
      
      protected var _doneSignal:Signal = new Signal();
      
      protected var _quickyBuy:FashionStarlingButton;
      
      protected var _quickyBuyLayout:ForgeQuickyBuy;
      
      protected var _shooseBtnArr:Vector.<FashionStarlingButton>;
      
      protected var _payChoose:int = 1;
      
      protected var _equipImgInForge:Image;
      
      protected var _stoneImgInForge:Image;
      
      public function ForgeViewBase()
      {
         super();
      }
      
      protected function init() : void
      {
      }
      
      public function clearData() : void
      {
         equipData = stoneData = null;
      }
      
      public function get payChoose() : int
      {
         return _payChoose;
      }
      
      public function get equipData() : GoodsData
      {
         return _equipData;
      }
      
      public function set equipData(param1:GoodsData) : void
      {
         _equipData = param1;
      }
      
      public function get stoneData() : GoodsData
      {
         return _stoneData;
      }
      
      public function set stoneData(param1:GoodsData) : void
      {
         _stoneData = param1;
      }
      
      public function get doneSignal() : Signal
      {
         return _doneSignal;
      }
      
      public function get equipImgInForge() : Image
      {
         return _equipImgInForge;
      }
      
      public function set equipImgInForge(param1:Image) : void
      {
         _equipImgInForge = param1;
      }
      
      public function get stoneImgInForge() : Image
      {
         return _stoneImgInForge;
      }
      
      public function set stoneImgInForge(param1:Image) : void
      {
         _stoneImgInForge = param1;
      }
   }
}

