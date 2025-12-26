package dragonBones.display
{
   import dragonBones.objects.DBTransform;
   import flash.geom.Matrix;
   
   public interface IDisplayBridge
   {
      
      function get visible() : Boolean;
      
      function set visible(param1:Boolean) : void;
      
      function get display() : Object;
      
      function set display(param1:Object) : void;
      
      function dispose() : void;
      
      function updateTransform(param1:Matrix, param2:DBTransform) : void;
      
      function updateColor(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void;
      
      function addDisplay(param1:Object, param2:int = -1) : void;
      
      function removeDisplay() : void;
   }
}

