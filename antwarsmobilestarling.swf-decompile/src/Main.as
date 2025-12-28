package
{
   import com.boyaa.antwars.control.DataInit;
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.Constants;
   import com.boyaa.antwars.data.LoginData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.view.screen.fresh.FreshGuide;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   // import flash.filesystem.File; // REMOVED
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import starling.core.Starling;
   
   public class Main extends Sprite
   {
      
      private var _starling:Starling;
      
      public function Main()
      {
         super();
         if(stage)
         {
            init();
         }
         else
         {
            addEventListener("addedToStage",onAddedToStage);
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener("addedToStage",onAddedToStage);
         init();
      }
      
      private function init() : void
      {
         var _loc2_:Rectangle = null;
         stage.scaleMode = "noScale";
         stage.align = "topLeft";
         if(Constants.isPC)
         {
            _loc2_ = new Rectangle(0,0,Constants.STAGE_WIDTH,Constants.STAGE_HEIGHT);
         }
         else
         {
            _loc2_ = new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight);
         }
         Application.instance.init(stage,_loc2_);
         Application.instance.setCurrentMain(this);
         // REMOVED FILE CHECK
         Starling.multitouchEnabled = true;
         Starling.handleLostContext = !Application.instance.iOS;
         _starling = new Starling(Game,stage,_loc2_);
         _starling.stage.stageWidth = Constants.STAGE_WIDTH;
         _starling.stage.stageHeight = Constants.STAGE_HEIGHT;
         _starling.simulateMultitouch = false;
         _starling.enableErrorChecking = false;
         _starling.start();
         if(Constants.debugShowScreen)
         {
            _starling.showStats = true;
         }
         Application.instance.resManager.update(onUpdate);
      }
      
      private function onUpdate(param1:Number) : void
      {
         if(param1 == 1)
         {
            (_starling.root as Game).start();
         }
      }
   }
}
