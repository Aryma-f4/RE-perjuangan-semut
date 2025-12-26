package feathers.core
{
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   
   public class PopUpManager
   {
      
      protected static const _starlingToPopUpManager:Dictionary = new Dictionary(true);
      
      public static var popUpManagerFactory:Function = defaultPopUpManagerFactory;
      
      public function PopUpManager()
      {
         super();
      }
      
      public static function defaultPopUpManagerFactory() : IPopUpManager
      {
         return new DefaultPopUpManager();
      }
      
      public static function forStarling(param1:Starling) : IPopUpManager
      {
         var _loc2_:Function = null;
         if(!param1)
         {
            throw new ArgumentError("PopUpManager not found. Starling cannot be null.");
         }
         var _loc3_:IPopUpManager = _starlingToPopUpManager[param1];
         if(!_loc3_)
         {
            _loc2_ = PopUpManager.popUpManagerFactory;
            if(_loc2_ === null)
            {
               _loc2_ = PopUpManager.defaultPopUpManagerFactory;
            }
            _loc3_ = _loc2_();
            if(!_loc3_.root || !param1.stage.contains(_loc3_.root))
            {
               _loc3_.root = Starling.current.stage;
            }
            PopUpManager._starlingToPopUpManager[param1] = _loc3_;
         }
         return _loc3_;
      }
      
      public static function get overlayFactory() : Function
      {
         return PopUpManager.forStarling(Starling.current).overlayFactory;
      }
      
      public static function set overlayFactory(param1:Function) : void
      {
         PopUpManager.forStarling(Starling.current).overlayFactory = param1;
      }
      
      public static function defaultOverlayFactory() : DisplayObject
      {
         return DefaultPopUpManager.defaultOverlayFactory();
      }
      
      public static function get root() : DisplayObjectContainer
      {
         return PopUpManager.forStarling(Starling.current).root;
      }
      
      public static function set root(param1:DisplayObjectContainer) : void
      {
         PopUpManager.forStarling(Starling.current).root = param1;
      }
      
      public static function addPopUp(param1:DisplayObject, param2:Boolean = true, param3:Boolean = true, param4:Function = null) : DisplayObject
      {
         return PopUpManager.forStarling(Starling.current).addPopUp(param1,param2,param3,param4);
      }
      
      public static function removePopUp(param1:DisplayObject, param2:Boolean = false) : DisplayObject
      {
         return PopUpManager.forStarling(Starling.current).removePopUp(param1,param2);
      }
      
      public static function isPopUp(param1:DisplayObject) : Boolean
      {
         return PopUpManager.forStarling(Starling.current).isPopUp(param1);
      }
      
      public static function isTopLevelPopUp(param1:DisplayObject) : Boolean
      {
         return PopUpManager.forStarling(Starling.current).isTopLevelPopUp(param1);
      }
      
      public static function centerPopUp(param1:DisplayObject) : void
      {
         PopUpManager.forStarling(Starling.current).centerPopUp(param1);
      }
   }
}

