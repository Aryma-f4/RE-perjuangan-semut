package feathers.controls.popups
{
   import starling.display.DisplayObject;
   
   public interface IPopUpContentManager
   {
      
      function get isOpen() : Boolean;
      
      function open(param1:DisplayObject, param2:DisplayObject) : void;
      
      function close() : void;
      
      function dispose() : void;
   }
}

