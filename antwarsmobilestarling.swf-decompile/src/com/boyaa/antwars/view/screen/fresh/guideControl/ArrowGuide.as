package com.boyaa.antwars.view.screen.fresh.guideControl
{
   import com.boyaa.antwars.view.screen.forge.tip.InfoTipBase;
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   
   public class ArrowGuide
   {
      
      public static const LEFTARROW:String = "left";
      
      public static const RIGHTARROW:String = "right";
      
      public static const UPARROW:String = "up";
      
      public static const DOWNARROW:String = "down";
      
      private var _circle:Scale9Image;
      
      private var _focusSprite:Sprite;
      
      private var _focus:Image;
      
      private var _focusK:int = 0;
      
      private var _dk:Boolean = true;
      
      private var _point:Point;
      
      private var _view:Sprite;
      
      private var _displayObjectDataArr:Array = [];
      
      private var _isCompulsory:Boolean = false;
      
      private var _tipText:InfoTipBase;
      
      public function ArrowGuide()
      {
         super();
         init();
      }
      
      private function resetDisplayObjectPosition() : void
      {
         if(_displayObjectDataArr.length == 0 || !_isCompulsory)
         {
            return;
         }
         _displayObjectDataArr[0].x = _displayObjectDataArr[2].x;
         _displayObjectDataArr[0].y = _displayObjectDataArr[2].y;
         _displayObjectDataArr[1].addChild(_displayObjectDataArr[0]);
         _displayObjectDataArr = [];
      }
      
      public function startShow(param1:DisplayObject, param2:String = "", param3:String = "up", param4:Boolean = false) : void
      {
         if(!param1)
         {
            Application.instance.log("GuideTip","没有传入要引导元件，不能引导");
            return;
         }
         if(param1.parent)
         {
            _point = param1.parent.localToGlobal(new Point(param1.x,param1.y));
            _circle.x = _point.x;
            _circle.y = _point.y;
         }
         _tipText.update(param2);
         resetDisplayObjectPosition();
         _isCompulsory = param4;
         if(_isCompulsory)
         {
            _displayObjectDataArr = [param1,param1.parent,new Point(param1.x,param1.y)];
            param1.x = _point.x;
            param1.y = _point.y;
            Application.instance.currentGame.stage.addChild(param1);
         }
         _circle.width = param1.width;
         _circle.height = param1.height;
         _focusSprite.x = (_circle.width - _focusSprite.width >> 1) + _circle.x;
         _focusSprite.y = _circle.y - _focusSprite.height + 20;
         Starling.current.stage.addEventListener("enterFrame",onFingerFrame);
         Starling.current.stage.addChild(_view);
      }
      
      public function stopShow() : void
      {
         resetDisplayObjectPosition();
         Starling.current.stage.removeEventListener("enterFrame",onFingerFrame);
         _view.removeFromParent();
      }
      
      private function onFingerFrame(param1:EnterFrameEvent) : void
      {
         _focus.y = -20 - _focusK;
         if(_focusK == 24 || _focusK == 0)
         {
            _dk = !_dk;
         }
         if(_dk)
         {
            _focusK -= 2;
         }
         else
         {
            _focusK += 2;
         }
      }
      
      private function init() : void
      {
         _focusSprite = new Sprite();
         _view = new Sprite();
         _circle = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("guide_dotLine"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         _circle.width = _circle.height = 100;
         _focus = new Image(Assets.sAsset.getTexture("focusFinger"));
         _focusSprite.addChild(_focus);
         _view.addChild(_circle);
         _view.addChild(_focusSprite);
         _view.touchable = false;
         _tipText = new InfoTipBase();
         _tipText.touchable = false;
      }
   }
}

