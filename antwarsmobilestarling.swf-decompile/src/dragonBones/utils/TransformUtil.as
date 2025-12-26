package dragonBones.utils
{
   import dragonBones.objects.DBTransform;
   import flash.geom.Matrix;
   
   public final class TransformUtil
   {
      
      private static const HALF_PI:Number = 1.5707963267948966;
      
      private static const DOUBLE_PI:Number = 6.283185307179586;
      
      private static const _helpMatrix:Matrix = new Matrix();
      
      public function TransformUtil()
      {
         super();
      }
      
      public static function transformPointWithParent(param1:DBTransform, param2:DBTransform) : void
      {
         transformToMatrix(param2,_helpMatrix);
         _helpMatrix.invert();
         var _loc4_:Number = param1.x;
         var _loc3_:Number = param1.y;
         param1.x = _helpMatrix.a * _loc4_ + _helpMatrix.c * _loc3_ + _helpMatrix.tx;
         param1.y = _helpMatrix.d * _loc3_ + _helpMatrix.b * _loc4_ + _helpMatrix.ty;
         param1.skewX = formatRadian(param1.skewX - param2.skewX);
         param1.skewY = formatRadian(param1.skewY - param2.skewY);
      }
      
      public static function transformToMatrix(param1:DBTransform, param2:Matrix) : void
      {
         param2.a = param1.scaleX * Math.cos(param1.skewY);
         param2.b = param1.scaleX * Math.sin(param1.skewY);
         param2.c = -param1.scaleY * Math.sin(param1.skewX);
         param2.d = param1.scaleY * Math.cos(param1.skewX);
         param2.tx = param1.x;
         param2.ty = param1.y;
      }
      
      public static function formatRadian(param1:Number) : Number
      {
         param1 %= 6.283185307179586;
         if(param1 > 3.141592653589793)
         {
            param1 -= 6.283185307179586;
         }
         if(param1 < -3.141592653589793)
         {
            param1 += 6.283185307179586;
         }
         return param1;
      }
   }
}

