package org.gestouch.core
{
   import flash.display.InteractiveObject;
   import flash.geom.Point;
   
   public interface ITouchHitTester
   {
      
      function hitTest(param1:Point, param2:InteractiveObject) : Object;
   }
}

