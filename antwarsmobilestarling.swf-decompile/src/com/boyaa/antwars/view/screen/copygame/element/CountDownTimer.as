package com.boyaa.antwars.view.screen.copygame.element
{
   import com.boyaa.antwars.view.screen.battlefield.element.NumberView;
   import org.osflash.signals.Signal;
   import starling.animation.IAnimatable;
   import starling.core.Starling;
   import starling.display.DisplayObjectContainer;
   import starling.display.Sprite;
   
   public class CountDownTimer extends Sprite implements IAnimatable
   {
      
      public static const TOP:uint = 0;
      
      public static const CENTER:uint = 1;
      
      public static const BOTTOM:uint = 2;
      
      private var _numView:NumberView;
      
      private var _timeOverSignal:Signal;
      
      private var _addtime:Number = 0;
      
      private var _totalTime:uint = 0;
      
      private var _pause:Boolean = false;
      
      public function CountDownTimer()
      {
         super();
         init();
      }
      
      public static function show(param1:DisplayObjectContainer, param2:uint, param3:Function, param4:uint = 1, param5:Number = 1.5) : CountDownTimer
      {
         var _loc6_:CountDownTimer = new CountDownTimer();
         _loc6_.scale(param5);
         param1.addChild(_loc6_);
         _loc6_.start(param2);
         _loc6_.timeOverSignal.addOnce(param3);
         _loc6_.position(param4);
         return _loc6_;
      }
      
      private function init() : void
      {
         _numView = new NumberView("num",400,400);
         addChild(_numView);
         _timeOverSignal = new Signal();
      }
      
      public function scale(param1:Number) : void
      {
         _numView.scaleX = _numView.scaleY = param1;
      }
      
      public function start(param1:uint) : void
      {
         _totalTime = param1 - 1;
         _addtime = 0;
         Starling.juggler.add(this);
         _numView.number = _totalTime;
         _numView.visible = true;
      }
      
      public function setPause(param1:Boolean) : void
      {
         _pause = param1;
      }
      
      public function stop() : void
      {
         Starling.juggler.remove(this);
         _numView.visible = false;
      }
      
      override public function dispose() : void
      {
         stop();
         if(_timeOverSignal)
         {
            _timeOverSignal.removeAll();
         }
         _timeOverSignal = null;
         super.dispose();
      }
      
      private function position(param1:uint) : void
      {
         switch(int(param1))
         {
            case 0:
               this.x = 1365 - this.width >> 1;
               break;
            case 1:
               this.x = 1365 - this.width >> 1;
               this.y = 768 - this.height >> 1;
               break;
            case 2:
               this.y = 768 - this.height >> 1;
         }
      }
      
      public function advanceTime(param1:Number) : void
      {
         var time:Number = param1;
         if(_pause)
         {
            return;
         }
         _addtime += time;
         if(_addtime >= 1)
         {
            if(_totalTime != 0)
            {
               _totalTime -= 1;
            }
            _addtime = 0;
            _numView.number = _totalTime;
            if(_totalTime <= 0)
            {
               Starling.juggler.delayCall((function():*
               {
                  var call:Function;
                  return call = function():void
                  {
                     _timeOverSignal.dispatch();
                     stop();
                  };
               })(),0.1);
            }
         }
      }
      
      public function get timeOverSignal() : Signal
      {
         return _timeOverSignal;
      }
   }
}

