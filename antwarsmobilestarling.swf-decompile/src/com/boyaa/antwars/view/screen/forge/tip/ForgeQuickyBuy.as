package com.boyaa.antwars.view.screen.forge.tip
{
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.view.screen.forge.ForgeViewBase;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.screen.shop.ShopBuyDlg;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import org.osflash.signals.Signal;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class ForgeQuickyBuy extends UIExportSprite
   {
      
      public static const SYNTHESIS:int = 0;
      
      public static const ADDITION:int = 1;
      
      private static var _quickyBuyDoneSignal:Signal = new Signal(String);
      
      private var _currentBuyShopData:ShopData;
      
      private var _view:ForgeViewBase;
      
      private var _choice:int = 0;
      
      private var _synthesisStoneArr:Array = [[16,1051],[17,1051],[18,1051],[19,1051]];
      
      private var _additionStoneArr:Array = [[20,1011],[20,1021],[20,1031],[20,1041]];
      
      private var _stoneDataVec:Vector.<ShopData> = new Vector.<ShopData>();
      
      public function ForgeQuickyBuy(param1:int = 0)
      {
         super();
         _choice = param1;
         init();
      }
      
      public static function get quickyBuyDoneSignal() : Signal
      {
         return _quickyBuyDoneSignal;
      }
      
      private function init() : void
      {
         _layout = new LayoutUitl(Assets.sAsset.getOther("synthesisView"));
         _layout.buildLayout("forgeBuyButtonGroup",_displayObj);
         switch(_choice)
         {
            case 0:
               initSynthesis();
               break;
            case 1:
               initAddition();
         }
      }
      
      private function initAddition() : void
      {
         var _loc5_:int = 0;
         var _loc1_:Array = null;
         var _loc4_:ShopData = null;
         var _loc2_:Sprite = null;
         var _loc3_:Image = null;
         _loc5_ = 0;
         while(_loc5_ < _additionStoneArr.length)
         {
            _loc1_ = _additionStoneArr[_loc5_];
            _loc4_ = ShopDataList.instance.getSingleData(_loc1_[0],_loc1_[1]);
            _stoneDataVec.push(_loc4_);
            _loc2_ = getSpriteByName("btn" + _loc5_);
            _loc3_ = Assets.sAsset.getGoodsImageByRect(_loc4_.typeID,_loc4_.frameID,getDisplayObjectByName("stoneImg",_loc2_).bounds);
            _loc2_.addChildAt(_loc3_,1);
            getTextFieldByName("text",_loc2_).text = _loc4_.name.toString();
            _loc2_.addEventListener("touch",onQuickyBuy);
            _loc5_++;
         }
      }
      
      private function initSynthesis() : void
      {
         var _loc5_:int = 0;
         var _loc1_:Array = null;
         var _loc4_:ShopData = null;
         var _loc2_:Sprite = null;
         var _loc3_:Image = null;
         _loc5_ = 0;
         while(_loc5_ < _synthesisStoneArr.length)
         {
            _loc1_ = _synthesisStoneArr[_loc5_];
            _loc4_ = ShopDataList.instance.getSingleData(_loc1_[0],_loc1_[1]);
            _stoneDataVec.push(_loc4_);
            _loc2_ = getSpriteByName("btn" + _loc5_);
            _loc3_ = Assets.sAsset.getGoodsImageByRect(_loc4_.typeID,_loc4_.frameID,getDisplayObjectByName("stoneImg",_loc2_).bounds);
            _loc2_.addChildAt(_loc3_,1);
            getTextFieldByName("text",_loc2_).text = _loc4_.name.substr(0,_loc4_.name.indexOf("LV"));
            _loc2_.addEventListener("touch",onQuickyBuy);
            _loc5_++;
         }
      }
      
      private function onQuickyBuy(param1:TouchEvent) : void
      {
         var _loc2_:int = 0;
         var _loc5_:ShopData = null;
         var _loc6_:ShopBuyDlg = null;
         var _loc4_:Sprite = DisplayObject(param1.target).parent as Sprite;
         var _loc3_:Touch = param1.getTouch(_loc4_,"ended");
         if(_loc3_)
         {
            _loc2_ = int(_loc4_.name.substr(_loc4_.name.length - 1));
            _loc5_ = _stoneDataVec[_loc2_];
            _loc6_ = new ShopBuyDlg(true,_loc5_);
            _loc6_.buySignal.add(updateForgeImgData);
            Application.instance.currentGame.addChild(_loc6_);
            _currentBuyShopData = _loc5_;
         }
      }
      
      private function updateForgeImgData() : void
      {
         var _loc1_:GoodsData = GoodsList.instance.getGoodsById(_currentBuyShopData.typeID,_currentBuyShopData.frameID);
         if(_view.stoneImgInForge)
         {
            _view.stoneImgInForge.removeFromParent(true);
         }
         _view.stoneImgInForge = Assets.sAsset.getGoodsImageByRect(_currentBuyShopData.typeID,_currentBuyShopData.frameID,_view.getDisplayObjectByName("goodsbox1").bounds);
         _view.stoneImgInForge.name = _loc1_.onlyID.toString();
         _view.addChild(_view.stoneImgInForge);
         _view.stoneData = _loc1_;
         _quickyBuyDoneSignal.dispatch("buyDone");
      }
      
      private function remove() : void
      {
      }
      
      public function setForgeView(param1:ForgeViewBase) : void
      {
         _view = param1;
      }
      
      public function show() : void
      {
         if(stage)
         {
            return;
         }
         Application.instance.currentGame.addChild(this);
         Timepiece.instance.addDelayCall((function():*
         {
            var delay:Function;
            return delay = function():void
            {
               stage.addEventListener("touch",onTouch);
            };
         })(),1000);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(stage,"ended");
         if(_loc2_)
         {
            stage.removeEventListener("touch",onTouch);
            this.removeFromParent();
         }
      }
   }
}

