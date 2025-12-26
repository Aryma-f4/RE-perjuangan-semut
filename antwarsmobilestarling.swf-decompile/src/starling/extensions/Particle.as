package starling.extensions
{
   public class Particle
   {
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var rotation:Number;
      
      public var color:uint;
      
      public var alpha:Number;
      
      public var currentTime:Number;
      
      public var totalTime:Number;
      
      public function Particle()
      {
         super();
         x = y = rotation = currentTime = 0;
         totalTime = alpha = scale = 1;
         color = 16777215;
      }
   }
}

