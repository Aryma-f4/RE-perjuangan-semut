package com.boyaa.antwars.view.screen.wedding
{
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.sound.SoundManager;
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   import starling.textures.Texture;
   
   public class WeddingAni extends Sprite
   {
      
      private var _bgImage:Image;
      
      private var _antsImage:Image;
      
      private var _type:int;
      
      private var _smallX:int;
      
      private var _maxX:int;
      
      private var _showTimeArr:Array = [1,2,3];
      
      private var _openAni:WeddingBeginAni;
      
      private var _textTip:TextField;
      
      public function WeddingAni()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         _textTip = new TextField(400,50,LangManager.t("weddingTip12"));
         _textTip.fontSize = 25;
         _textTip.fontName = "微软雅黑";
         _textTip.color = 16777215;
         _textTip.x = 600;
         _textTip.y = 700;
         _textTip.visible = false;
         _smallX = 170.5;
         _maxX = 1365 - _smallX;
         this.addEventListener("touch",onTouchHandle);
      }
      
      private function onTouchHandle(param1:TouchEvent) : void
      {
         var e:TouchEvent = param1;
         var myTouch:Touch = e.getTouch(e.target as DisplayObject,"ended");
         if(myTouch && _textTip.visible)
         {
            hide();
            return;
         }
         if(myTouch)
         {
            this.addChild(_textTip);
            _textTip.visible = true;
            Timepiece.instance.addDelayCall((function():*
            {
               var delay:Function;
               return delay = function():void
               {
                  _textTip.visible = false;
               };
            })(),3000);
         }
      }
      
      public function show(param1:int) : void
      {
         _type = param1;
         weddingBeginAni();
      }
      
      private function weddingBeginAni() : void
      {
         _openAni = new WeddingBeginAni();
         Application.instance.currentGame.addChild(_openAni);
         WeddingAniManager.instance.aniSignal.addOnce((function():*
         {
            var callBack:Function;
            return callBack = function(param1:String):void
            {
               if(param1 == "openAniDone")
               {
                  showWedding();
               }
            };
         })());
      }
      
      private function showWedding() : void
      {
         var _loc4_:Texture = null;
         var _loc1_:Texture = null;
         _loc4_ = Assets.sAsset.getTexture("jh" + _type);
         _loc1_ = Assets.sAsset.getTexture("jhman" + _type);
         _bgImage = new Image(_loc4_);
         _antsImage = new Image(_loc1_);
         var _loc3_:Rectangle = Assets.getPosition("wedding","bg");
         var _loc2_:Rectangle = Assets.getPosition("wedding","ant");
         _bgImage.x = _loc3_.x;
         _bgImage.y = _loc3_.y;
         _antsImage.x = _loc2_.x;
         _antsImage.y = _loc2_.y;
         this.addChild(_bgImage);
         this.addChild(_antsImage);
         this.x = 170.5;
         Application.instance.currentGame.addChild(this);
         Application.instance.currentGame.swapChildren(this,_openAni);
         Timepiece.instance.addDelayCall(timeToShow,2500);
         SoundManager.playBgSound("RiteMusic");
      }
      
      private function timeToShow() : void
      {
         SoundManager.actSoundVol = 1;
         SoundManager.playSound("lihuaAct",99);
         Timepiece.instance.addFun(showFireWork);
         Timepiece.instance.addFun(showColorPapers);
      }
      
      private function showFireWork() : void
      {
         var _loc1_:int = MathHelper.randomWithinRange(0,10);
         if(_loc1_ >= _showTimeArr[_type - 1])
         {
            return;
         }
         var _loc2_:WeddingFirework = new WeddingFirework(1);
         _loc2_.x = MathHelper.randomWithinRange(_smallX,_maxX);
         _loc2_.y = MathHelper.randomWithinRange(0,768);
         Application.instance.currentGame.addChild(_loc2_);
      }
      
      private function showColorPapers() : void
      {
         var _loc1_:int = MathHelper.randomWithinRange(0,30);
         if(_loc1_ >= _showTimeArr[_type - 1])
         {
            return;
         }
         var _loc2_:WeddingFirework = new WeddingFirework(2);
         _loc2_.x = MathHelper.randomWithinRange(_smallX,_maxX - _loc2_.width);
         _loc2_.y = Math.round(768 / 3.5);
         Application.instance.currentGame.addChild(_loc2_);
      }
      
      public function hide() : void
      {
         Timepiece.instance.removeFun(showFireWork);
         Timepiece.instance.removeFun(showColorPapers);
         Timepiece.instance.removeFun(timeToShow,2);
         this.removeFromParent(true);
         SoundManager.stopActSound();
         SoundManager.stopBgSound();
         WeddingAniManager.instance.aniSignal.dispatch("weddingAniComplete");
      }
   }
}

