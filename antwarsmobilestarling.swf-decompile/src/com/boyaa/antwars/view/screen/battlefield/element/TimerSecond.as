package com.boyaa.antwars.view.screen.battlefield.element
{
   import org.osflash.signals.Signal;
   import starling.animation.IAnimatable;
   import starling.core.Starling;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class TimerSecond extends Sprite implements IAnimatable
   {
      
      public var timeoverSignal:Signal;
      
      private var textureAtlas:ResAssetManager;
      
      private var time:uint;
      
      private var numView:NumberView;
      
      private var __addtime:Number = 0;
      
      public function TimerSecond()
      {
         super();
         textureAtlas = Assets.sAsset;
         timeoverSignal = new Signal();
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         numView = new NumberView("num",97,57);
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
         }
      }
      
      private function drawView(param1:uint) : void
      {
         param1 = uint(param1 < 0 ? 0 : param1);
         numView.number = param1;
         if(param1 == 0)
         {
            stop();
            timeoverSignal.dispatch();
         }
      }
      
      public function start(param1:uint) : void
      {
         this.time = param1;
         drawView(param1);
         __addtime = 0;
         Starling.juggler.add(this);
      }
      
      public function pause() : void
      {
         stop();
      }
      
      public function play() : void
      {
         start(this.time);
      }
      
      public function stop() : void
      {
         Starling.juggler.remove(this);
         removeFromParent();
      }
      
      override public function dispose() : void
      {
         stop();
         timeoverSignal.removeAll();
         timeoverSignal = null;
         super.dispose();
      }
   }
}

