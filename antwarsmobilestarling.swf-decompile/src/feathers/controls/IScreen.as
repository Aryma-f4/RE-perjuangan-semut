package feathers.controls
{
   import feathers.core.IFeathersControl;
   
   public interface IScreen extends IFeathersControl
   {
      
      function get screenID() : String;
      
      function set screenID(param1:String) : void;
      
      function get owner() : ScreenNavigator;
      
      function set owner(param1:ScreenNavigator) : void;
   }
}

