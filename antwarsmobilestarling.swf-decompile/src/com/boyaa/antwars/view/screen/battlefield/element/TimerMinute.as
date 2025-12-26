package com.boyaa.antwars.view.screen.battlefield.element
{
   import org.osflash.signals.Signal;
   import starling.animation.IAnimatable;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class TimerMinute extends Sprite implements IAnimatable
   {
      
      public var timeoverSignal:Signal;
      
      private var textureAtlas:ResAssetManager;
      
      private var minuteView:NumberView;
      
      private var secondView:NumberView;
      
      private var timeSecond:uint;
      
      private var timeMinute:int;
      
      private var __addSecondtime:Number = 0;
      
      private var min:uint = 0;
      
      private var _totalTime:uint = 5;
      
      public function TimerMinute()
      {
         super();
         timeoverSignal = new Signal();
         textureAtlas = Assets.sAsset;
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         minuteView = new NumberView("num",97,57);
         addChild(minuteView);
         secondView = new NumberView("num",97,57);
         secondView.x = minuteView.width + 35;
         addChild(secondView);
         var _loc2_:Image = new Image(textureAtlas.getTexture("fb60"));
         _loc2_.x = minuteView.width + 5;
         _loc2_.y = 5;
         addChild(_loc2_);
      }
      
      public function startMinute(param1:uint) : void
      {
         this.timeMinute = param1;
         this._totalTime = param1;
         if(param1 == 5)
         {
            startSecond(0);
         }
         drawMinView(param1);
         Starling.juggler.add(this);
      }
      
      public function startSecond(param1:uint) : void
      {
         this.timeSecond = param1;
         drawSecondView(param1);
      }
      
      public function pause() : void
      {
         stop();
      }
      
      public function play() : void
      {
         Starling.juggler.add(this);
      }
      
      public function stop() : void
      {
         Starling.juggler.remove(this);
      }
      
      public function timeOver() : void
      {
         stop();
      }
      
      private function drawMinView(param1:int) : void
      {
         minuteView.number = param1;
      }
      
      private function drawSecondView(param1:uint) : void
      {
         param1 = uint(param1 < 0 ? 0 : param1);
         secondView.number = param1;
      }
      
      public function advanceTime(param1:Number) : void
      {
         __addSecondtime += param1;
         if(__addSecondtime >= 1)
         {
            if(this.timeSecond == 0)
            {
               min = min + 1;
               if(this.timeMinute <= 0)
               {
                  this.timeMinute = 0;
               }
               else
               {
                  this.timeMinute -= 1;
               }
               drawMinView(this.timeMinute);
               if(min > _totalTime)
               {
                  stop();
                  min = 0;
                  timeoverSignal.dispatch();
                  trace("timer over...");
               }
               this.timeSecond = 60;
               return;
            }
            this.timeSecond -= 1;
            __addSecondtime -= 1;
            drawSecondView(this.timeSecond);
         }
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

