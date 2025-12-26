package org.gestouch.extensions.native
{
   import flash.display.InteractiveObject;
   import flash.geom.Point;
   import org.gestouch.core.ITouchHitTester;
   
   public final class NativeTouchHitTester implements ITouchHitTester
   {
      
      public function NativeTouchHitTester()
      {
         super();
      }
      
      public function hitTest(param1:Point, param2:InteractiveObject) : Object
      {
         return param2;
      }
   }
}

