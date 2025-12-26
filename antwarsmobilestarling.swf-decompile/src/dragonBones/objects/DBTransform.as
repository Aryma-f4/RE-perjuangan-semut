package dragonBones.objects
{
   public class DBTransform
   {
      
      public var x:Number;
      
      public var y:Number;
      
      public var skewX:Number;
      
      public var skewY:Number;
      
      public var scaleX:Number;
      
      public var scaleY:Number;
      
      public function DBTransform()
      {
         super();
         x = 0;
         y = 0;
         skewX = 0;
         skewY = 0;
         scaleX = 1;
         scaleY = 1;
      }
      
      public function get rotation() : Number
      {
         return skewX;
      }
      
      public function set rotation(param1:Number) : void
      {
         skewX = skewY = param1;
      }
      
      public function copy(param1:DBTransform) : void
      {
         x = param1.x;
         y = param1.y;
         skewX = param1.skewX;
         skewY = param1.skewY;
         scaleX = param1.scaleX;
         scaleY = param1.scaleY;
      }
      
      public function toString() : String
      {
         return "x:" + x + " y:" + y + " skewX:" + skewX + " skewY:" + skewY + " scaleX:" + scaleX + " scaleY:" + scaleY;
      }
   }
}

