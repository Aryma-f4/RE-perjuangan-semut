package com.boyaa.antwars.view.screen.battlefield.element
{
   import org.osflash.signals.Signal;
   import starling.animation.IAnimatable;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class TimerView extends Sprite implements IAnimatable
   {
      
      public var timeoverSignal:Signal;
      
      private var textureAtlas:ResAssetManager;
      
      private var bg:MovieClip;
      
      private var time:uint;
      
      private var numView:NumberView;
      
      private var __addtime:Number = 0;
      
      public function TimerView()
      {
         super();
         textureAtlas = Assets.sAsset;
         timeoverSignal = new Signal();
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         bg = new MovieClip(textureAtlas.getTextures("timebg"),3);
         addChild(bg);
         bg.stop();
         numView = new NumberView("num",bg.width,bg.height);
         addChild(numView);
      }
      
      public function advanceTime(param1:Number) : void
      {
         __addtime += param1;
         if(__addtime >= 1)
         {
            this.time -= 1;
            __addtime -= 1;
            drawView(this.time);
            if(this.time == 0)
            {
               trace("已派发时间结束消失-----------------------------------");
               timeoverSignal.dispatch();
               stop();
            }
         }
      }
      
      private function drawView(param1:uint) : void
      {
         if(param1 <= 5 && !bg.isPlaying && Starling.juggler.contains(this))
         {
            bg.play();
         }
         numView.number = param1;
      }
      
      public function start(param1:uint) : void
      {
         this.time = param1;
         drawView(param1);
         __addtime = 0;
         Starling.juggler.add(this);
         Starling.juggler.add(bg);
      }
      
      public function stop() : void
      {
         Starling.juggler.remove(this);
         Starling.juggler.remove(bg);
         bg.stop();
      }
      
      override public function dispose() : void
      {
         stop();
         if(timeoverSignal)
         {
            timeoverSignal.removeAll();
         }
         timeoverSignal = null;
         super.dispose();
      }
   }
}

