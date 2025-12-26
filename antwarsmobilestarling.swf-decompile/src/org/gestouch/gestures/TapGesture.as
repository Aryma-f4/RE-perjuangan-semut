package org.gestouch.gestures
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.gestouch.core.GestureState;
   import org.gestouch.core.Touch;
   
   public class TapGesture extends AbstractDiscreteGesture
   {
      
      public var numTouchesRequired:uint = 1;
      
      public var numTapsRequired:uint = 1;
      
      public var slop:Number = Gesture.DEFAULT_SLOP << 2;
      
      public var maxTapDelay:uint = 400;
      
      public var maxTapDuration:uint = 1500;
      
      protected var _timer:Timer;
      
      protected var _numTouchesRequiredReached:Boolean;
      
      protected var _tapCounter:uint = 0;
      
      public function TapGesture(param1:Object = null)
      {
         super(param1);
      }
      
      override public function reflect() : Class
      {
         return TapGesture;
      }
      
      override public function reset() : void
      {
         _numTouchesRequiredReached = false;
         _tapCounter = 0;
         _timer.reset();
         super.reset();
      }
      
      override public function canPreventGesture(param1:Gesture) : Boolean
      {
         if(param1 is TapGesture && (param1 as TapGesture).numTapsRequired > this.numTapsRequired)
         {
            return false;
         }
         return true;
      }
      
      override protected function preinit() : void
      {
         super.preinit();
         _timer = new Timer(maxTapDelay,1);
         _timer.addEventListener("timerComplete",timer_timerCompleteHandler);
      }
      
      override protected function onTouchBegin(param1:Touch) : void
      {
         if(touchesCount > numTouchesRequired)
         {
            failOrIgnoreTouch(param1);
            return;
         }
         if(touchesCount == 1)
         {
            _timer.reset();
            _timer.delay = maxTapDuration;
            _timer.start();
         }
         if(touchesCount == numTouchesRequired)
         {
            _numTouchesRequiredReached = true;
            updateLocation();
         }
      }
      
      override protected function onTouchMove(param1:Touch) : void
      {
         if(slop >= 0 && param1.locationOffset.length > slop)
         {
            setState(GestureState.FAILED);
         }
      }
      
      override protected function onTouchEnd(param1:Touch) : void
      {
         if(!_numTouchesRequiredReached)
         {
            setState(GestureState.FAILED);
         }
         else if(touchesCount == 0)
         {
            _numTouchesRequiredReached = false;
            _tapCounter = _tapCounter + 1;
            _timer.reset();
            if(_tapCounter == numTapsRequired)
            {
               setState(GestureState.RECOGNIZED);
            }
            else
            {
               _timer.delay = maxTapDelay;
               _timer.start();
            }
         }
      }
      
      protected function timer_timerCompleteHandler(param1:TimerEvent) : void
      {
         if(state == GestureState.POSSIBLE)
         {
            setState(GestureState.FAILED);
         }
      }
   }
}

