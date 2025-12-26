package com.boyaa.antwars.view.screen.battlefield.element
{
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class WinMovieClip extends Sprite
   {
      
      private var bg:Image;
      
      private var glow:Image;
      
      private var winMCS:Vector.<MovieClip>;
      
      private var textureAtlas:ResAssetManager;
      
      public var completeSignal:Signal;
      
      private var timer:int;
      
      public function WinMovieClip()
      {
         super();
         textureAtlas = Assets.sAsset;
         completeSignal = new Signal();
         winMCS = new Vector.<MovieClip>();
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc2_:MovieClip = null;
         this.removeEventListener("addedToStage",onAddedToStage);
         bg = new Image(textureAtlas.getTexture("win"));
         _loc3_ = 0;
         while(_loc3_ < 8)
         {
            _loc2_ = new MovieClip(textureAtlas.getTextures("star00"));
            _loc2_.loop = true;
            _loc2_.pivotY = _loc2_.height;
            _loc2_.pivotX = _loc2_.width >> 1;
            _loc2_.rotation = _loc3_ * 3.141592653589793 / 4;
            _loc2_.x = bg.width >> 1;
            _loc2_.y = bg.height >> 1;
            if(_loc3_ == 0)
            {
               _loc2_.addEventListener("complete",onPlayComplete);
            }
            winMCS.push(_loc2_);
            addChild(winMCS[_loc3_]);
            _loc3_++;
         }
         glow = new Image(textureAtlas.getTexture("glow"));
         glow.x = bg.width >> 1;
         glow.y = bg.height >> 1;
         glow.pivotX = glow.width >> 1;
         glow.pivotY = glow.height >> 1;
         addChild(glow);
         addChild(bg);
         glow.scaleX = glow.scaleY = 2;
         this.pivotX = bg.width >> 1;
         this.pivotY = bg.height >> 1;
         this.scaleX = this.scaleY = 0.5;
         this.alpha = 0.5;
      }
      
      public function play(param1:int = 1) : void
      {
         var timer:int = param1;
         this.timer = timer;
         Starling.juggler.tween(this,0.3,{
            "scaleX":1,
            "scaleY":1,
            "alpha":1,
            "onComplete":function():void
            {
               var _loc1_:int = 0;
               _loc1_ = 0;
               while(_loc1_ < 8)
               {
                  Starling.juggler.add(winMCS[_loc1_]);
                  _loc1_++;
               }
            }
         });
         Starling.juggler.tween(glow,2 * timer,{"rotation":2 * 3.141592653589793 * timer});
      }
      
      private function onPlayComplete(param1:Event) : void
      {
         var _loc2_:int = 0;
         this.timer--;
         if(this.timer == 0)
         {
            _loc2_ = 0;
            while(_loc2_ < 8)
            {
               Starling.juggler.remove(winMCS[_loc2_]);
               _loc2_++;
            }
            param1.currentTarget.removeEventListener("complete",onPlayComplete);
            completeSignal.dispatch();
         }
      }
      
      override public function dispose() : void
      {
         winMCS = null;
         completeSignal.removeAll();
         super.dispose();
      }
   }
}

