package com.boyaa.antwars.view.screen.fresh
{
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.display.DlgMark;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class LevelUp extends Sprite
   {
      
      private var _level:String = "1";
      
      private var timer:Timer;
      
      private var star:StarTween;
      
      private var markBg:DlgMark;
      
      public function LevelUp(param1:int)
      {
         super();
         _level = param1.toString();
         init();
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function init() : void
      {
         var _loc5_:Image = null;
         var _loc6_:Array = null;
         var _loc4_:Image = null;
         var _loc1_:Image = null;
         var _loc8_:Rectangle = null;
         markBg = new DlgMark();
         var _loc7_:Image = new Image(Assets.sAsset.getTexture("bg3"));
         Assets.positionDisplay(_loc7_,"freshGifts","bg");
         addChild(_loc7_);
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("gift3"));
         Assets.positionDisplay(_loc3_,"freshGifts","title");
         addChild(_loc3_);
         var _loc9_:Image = new Image(Assets.sAsset.getTexture("gift2"));
         Assets.positionDisplay(_loc9_,"freshGifts","bg2");
         addChild(_loc9_);
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("gift5"));
         Assets.positionDisplay(_loc2_,"freshGifts","bg3");
         addChild(_loc2_);
         if(_level.length < 2)
         {
            _loc5_ = new Image(Assets.sAsset.getTexture("num" + _level));
            Assets.positionDisplay(_loc5_,"freshGifts","txt_level");
            addChild(_loc5_);
         }
         else
         {
            _loc6_ = _level.split("");
            _loc4_ = new Image(Assets.sAsset.getTexture("num" + _loc6_[0]));
            _loc1_ = new Image(Assets.sAsset.getTexture("num" + _loc6_[1]));
            _loc8_ = Assets.getPosition("freshGifts","txt_level");
            _loc4_.width = _loc1_.width = _loc8_.width;
            _loc4_.height = _loc1_.height = _loc8_.height;
            _loc4_.x = _loc8_.x - _loc4_.width / 2;
            _loc4_.y = _loc8_.y;
            addChild(_loc4_);
            _loc1_.x = _loc4_.x + _loc4_.width;
            _loc1_.y = _loc4_.y;
            addChild(_loc1_);
         }
         timer = new Timer(3000);
         timer.addEventListener("timer",onTimer);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         SoundManager.playSound("sound 27");
         this.removeEventListener("addedToStage",onAddedToStage);
         parent.addChild(markBg);
         parent.swapChildren(markBg,this);
         this.pivotX = this.width / 2;
         this.pivotY = this.height / 2;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.5,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeInOut"
         });
         timer.start();
         star = new StarTween(this);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         timer.stop();
         timer.removeEventListener("timer",onTimer);
         Starling.juggler.tween(this,0.2,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeIn",
            "onComplete":cleanUp
         });
      }
      
      private function cleanUp() : void
      {
         star.cleanUp();
         timer = null;
         Starling.juggler.removeTweens(this);
         markBg.removeFromParent();
         this.removeFromParent();
      }
   }
}

