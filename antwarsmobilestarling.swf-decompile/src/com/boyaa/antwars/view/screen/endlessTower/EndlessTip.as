package com.boyaa.antwars.view.screen.endlessTower
{
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class EndlessTip extends Sprite
   {
      
      private var _layout:LayoutUitl;
      
      private var _currentLevel:int;
      
      private var _giftLevel:int;
      
      private var _shopDataImg:Image;
      
      private var _box:Image;
      
      private var _yesCallBack:Function;
      
      private var _noCallBack:Function;
      
      private var _hideTime:int = 10;
      
      public function EndlessTip(param1:Function, param2:Function)
      {
         super();
         _yesCallBack = param1;
         _noCallBack = param2;
         init();
      }
      
      public function showShopData(param1:ShopData) : void
      {
         if(_shopDataImg)
         {
            _shopDataImg.removeFromParent(true);
         }
         _shopDataImg = Assets.sAsset.getGoodsImageByRect(param1.typeID,param1.frameID,getBounds(_box));
         SmallCodeTools.instance.setDisplayObjectToCenter(_box,_shopDataImg);
         addChild(_shopDataImg);
      }
      
      public function show() : void
      {
         _hideTime = 10;
         Timepiece.instance.addTimerFun(onCountDown,1000);
         Starling.current.stage.addChild(this);
         SmallCodeTools.instance.setDisplayObjectToCenter(this.parent,this);
         this.scaleX = this.scaleY = 0;
         var _loc1_:Tween = new Tween(this,0.5,"easeOut");
         _loc1_.scaleTo(1);
         Starling.juggler.add(_loc1_);
      }
      
      private function onCountDown() : void
      {
         _hideTime = _hideTime - 1;
         TextField(getChildByName("timeTip")).text = "0" + _hideTime.toString();
         if(_hideTime <= 0)
         {
            onCancelHandle(null);
         }
      }
      
      public function hide() : void
      {
         Timepiece.instance.removeFun(onCountDown,1);
         this.removeFromParent();
      }
      
      private function init() : void
      {
         _layout = new LayoutUitl(Assets.sAsset.getOther("endlessTower"),Assets.sAsset);
         _layout.buildLayout("tipLayout",this);
         Button(getChildByName("okBtn")).addEventListener("triggered",onOkHandle);
         Button(getChildByName("cancelBtn")).addEventListener("triggered",onCancelHandle);
         _box = getChildByName("giftBox") as Image;
      }
      
      private function onOkHandle(param1:Event) : void
      {
         hide();
         _yesCallBack && _yesCallBack();
      }
      
      private function onCancelHandle(param1:Event) : void
      {
         hide();
         _noCallBack && _noCallBack();
      }
      
      public function set currentLevel(param1:int) : void
      {
         _currentLevel = param1;
         TextField(getChildByName("currentLevelTxt")).text = LangManager.getLang.getreplaceLang("endless_txt0",param1);
      }
      
      public function set giftLevel(param1:int) : void
      {
         _giftLevel = param1;
         if(_giftLevel <= 0)
         {
            TextField(getChildByName("giftLevelTxt")).text = LangManager.t("endless_txt7");
         }
         else
         {
            TextField(getChildByName("giftLevelTxt")).text = LangManager.getLang.getreplaceLang("endless_txt1",param1);
         }
      }
   }
}

