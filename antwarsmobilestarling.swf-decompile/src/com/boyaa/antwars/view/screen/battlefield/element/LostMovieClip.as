package com.boyaa.antwars.view.screen.battlefield.element
{
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class LostMovieClip extends Sprite
   {
      
      private var bg:Image;
      
      private var lostMC:MovieClip;
      
      private var textureAtlas:ResAssetManager;
      
      public var completeSignal:Signal;
      
      private var timer:int;
      
      public function LostMovieClip()
      {
         super();
         textureAtlas = Assets.sAsset;
         completeSignal = new Signal();
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         bg = new Image(textureAtlas.getTexture("lost"));
         addChild(bg);
         lostMC = new MovieClip(textureAtlas.getTextures("lost00"));
         lostMC.loop = true;
         lostMC.y = 80;
         lostMC.x = bg.width - lostMC.width >> 1;
         lostMC.addEventListener("complete",onPlayComplete);
         this.pivotX = this.width >> 1;
         this.pivotY = this.height >> 1;
         this.scaleX = this.scaleY = 0.5;
      }
      
      public function play(param1:int = 1) : void
      {
         var timer:int = param1;
         this.timer = timer;
         Starling.juggler.tween(this,0.3,{
            "scaleX":1,
            "scaleY":1,
            "onComplete":function():void
            {
               if(lostMC)
               {
                  addChild(lostMC);
                  Starling.juggler.add(lostMC);
               }
            }
         });
      }
      
      private function onPlayComplete(param1:Event) : void
      {
         this.timer--;
         if(this.timer == 0)
         {
            Starling.juggler.remove(lostMC);
            param1.currentTarget.removeEventListener("complete",onPlayComplete);
            completeSignal.dispatch();
         }
      }
      
      override public function dispose() : void
      {
         Starling.juggler.remove(lostMC);
         completeSignal.removeAll();
         super.dispose();
      }
   }
}

