package com.boyaa.antwars.view.activity
{
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideSprite;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class ActivityBase extends GuideSprite implements IActivityInterface
   {
      
      protected var _layout:LayoutUitl;
      
      protected var _displayObj:Sprite;
      
      protected var _mark:DlgMark;
      
      protected var _assetArr:Array = [];
      
      protected var _layoutInfoName:String = "";
      
      protected var _layoutName:String = "";
      
      public function ActivityBase()
      {
         super();
         _mark = new DlgMark();
         addChild(_mark);
         initLoadAsset();
         loadAssets();
      }
      
      protected function initLoadAsset() : void
      {
      }
      
      protected function init() : void
      {
         _displayObj = new Sprite();
         addChild(_displayObj);
         _layout = new LayoutUitl(Assets.sAsset.getOther(_layoutInfoName),Assets.sAsset);
         _layout.buildLayout(_layoutName,_displayObj);
         if(getDisplayObjectByName("btnS_close"))
         {
            (getDisplayObjectByName("btnS_close") as Button).addEventListener("triggered",onClose);
         }
      }
      
      protected function loadAssets() : void
      {
         var _loc3_:int = 0;
         Application.instance.currentGame.showLoading();
         var _loc1_:ResManager = Application.instance.resManager;
         var _loc2_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < _assetArr.length)
         {
            _loc2_.push(_loc1_.getResFile(formatString(_assetArr[_loc3_],Assets.sAsset.scaleFactor)));
            _loc3_++;
         }
         Assets.sAsset.enqueue(_loc2_);
         Assets.sAsset.loadQueue(queueLoading);
      }
      
      protected function queueLoading(param1:Number) : void
      {
         if(param1 >= 1)
         {
            Application.instance.currentGame.hiddenLoading();
            init();
            show();
         }
      }
      
      protected function loadData(param1:Function) : void
      {
      }
      
      public function show() : void
      {
         Guide.instance.stop();
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
         Application.instance.currentGame.frontLayer.addChild(this);
         _displayObj.alpha = 0;
         Starling.juggler.tween(_displayObj,0.5,{
            "alpha":1,
            "transition":"easeInOut"
         });
      }
      
      protected function getDisplayObjectByName(param1:String, param2:Sprite = null) : DisplayObject
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1);
         }
         return param2.getChildByName(param1);
      }
      
      protected function onClose(param1:Event) : void
      {
         Starling.juggler.tween(this,0.3,{
            "alpha":0,
            "transition":"easeInOut",
            "onComplete":remove
         });
      }
      
      protected function getTextFieldByName(param1:String, param2:Sprite = null) : TextField
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1) as TextField;
         }
         return param2.getChildByName(param1) as TextField;
      }
      
      protected function getButtonByName(param1:String, param2:Sprite = null) : Button
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1) as Button;
         }
         return param2.getChildByName(param1) as Button;
      }
      
      protected function getDisplayObjByName(param1:String, param2:Sprite = null) : DisplayObject
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1);
         }
         return param2.getChildByName(param1);
      }
      
      protected function getSpriteByName(param1:String, param2:Sprite = null) : Sprite
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1) as Sprite;
         }
         return param2.getChildByName(param1) as Sprite;
      }
      
      protected function remove() : void
      {
         this.removeFromParent(true);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Assets.sAsset.removeObject(_layoutInfoName);
         Assets.sAsset.removeTextureAtlas(_layoutInfoName);
      }
   }
}

