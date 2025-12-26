package org.gestouch.core
{
   import org.gestouch.gestures.Gesture;
   
   public interface IGestureDelegate
   {
      
      function gestureShouldReceiveTouch(param1:Gesture, param2:Touch) : Boolean;
      
      function gestureShouldBegin(param1:Gesture) : Boolean;
      
      function gesturesShouldRecognizeSimultaneously(param1:Gesture, param2:Gesture) : Boolean;
   }
}

