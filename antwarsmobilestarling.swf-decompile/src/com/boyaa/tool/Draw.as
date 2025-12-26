package com.boyaa.tool
{
   import flash.display.Shape;
   
   public class Draw
   {
      
      public function Draw()
      {
         super();
      }
      
      public static function doDrawCircle(param1:int, param2:uint = 16777215) : Shape
      {
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.beginFill(param2);
         _loc3_.graphics.drawCircle(0,0,param1);
         _loc3_.graphics.endFill();
         return _loc3_;
      }
      
      public static function doDrawRectangle(param1:uint, param2:uint, param3:uint = 16777215, param4:uint = 0) : Shape
      {
         var _loc5_:Shape = new Shape();
         _loc5_.graphics.beginFill(param3);
         if(param4 != 0)
         {
            _loc5_.graphics.lineStyle(1,param4);
         }
         _loc5_.graphics.drawRect(-param1 / 2,-param2 / 2,param1,param2);
         _loc5_.graphics.endFill();
         return _loc5_;
      }
      
      public static function doDrawEllipse(param1:int, param2:int, param3:uint = 16777215) : Shape
      {
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.beginFill(param3);
         _loc4_.graphics.drawEllipse(0,0,param1,param2);
         _loc4_.graphics.endFill();
         return _loc4_;
      }
   }
}

