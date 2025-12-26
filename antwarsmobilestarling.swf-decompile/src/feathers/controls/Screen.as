package feathers.controls
{
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import flash.events.KeyboardEvent;
   import starling.core.Starling;
   import starling.events.Event;
   
   public class Screen extends LayoutGroup implements IScreen
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected var _screenID:String;
      
      protected var _owner:ScreenNavigator;
      
      protected var backButtonHandler:Function;
      
      protected var menuButtonHandler:Function;
      
      protected var searchButtonHandler:Function;
      
      public function Screen()
      {
         this.addEventListener("addedToStage",screen_addedToStageHandler);
         super();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Screen.globalStyleProvider;
      }
      
      public function get screenID() : String
      {
         return this._screenID;
      }
      
      public function set screenID(param1:String) : void
      {
         this._screenID = param1;
      }
      
      public function get owner() : ScreenNavigator
      {
         return this._owner;
      }
      
      public function set owner(param1:ScreenNavigator) : void
      {
         this._owner = param1;
      }
      
      protected function screen_addedToStageHandler(param1:Event) : void
      {
         if(param1.target != this)
         {
            return;
         }
         this.addEventListener("removedFromStage",screen_removedFromStageHandler);
         var _loc2_:int = -getDisplayObjectDepthFromStage(this);
         Starling.current.nativeStage.addEventListener("keyDown",screen_nativeStage_keyDownHandler,false,_loc2_,true);
      }
      
      protected function screen_removedFromStageHandler(param1:Event) : void
      {
         if(param1.target != this)
         {
            return;
         }
         this.removeEventListener("removedFromStage",screen_removedFromStageHandler);
         Starling.current.nativeStage.removeEventListener("keyDown",screen_nativeStage_keyDownHandler);
      }
      
      protected function screen_nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(this.backButtonHandler != null && param1.keyCode == 16777238)
         {
            param1.preventDefault();
            this.backButtonHandler();
         }
         if(this.menuButtonHandler != null && param1.keyCode == 16777234)
         {
            param1.preventDefault();
            this.menuButtonHandler();
         }
         if(this.searchButtonHandler != null && param1.keyCode == 16777247)
         {
            param1.preventDefault();
            this.searchButtonHandler();
         }
      }
   }
}

