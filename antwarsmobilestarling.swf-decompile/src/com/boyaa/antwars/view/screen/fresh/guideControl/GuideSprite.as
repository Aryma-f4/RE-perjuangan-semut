package com.boyaa.antwars.view.screen.fresh.guideControl
{
   import com.boyaa.antwars.view.display.ClickSprite;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import starling.events.Event;
   
   public class GuideSprite extends ClickSprite
   {
      
      public function GuideSprite()
      {
         super();
         addEventListener("addedToStage",onAddToStage);
         addEventListener("removedFromStage",onRemoveStage);
      }
      
      private function onRemoveStage(param1:Event) : void
      {
         GuideTipManager.instance.removeWindow(this);
      }
      
      private function onAddToStage(param1:Event) : void
      {
         GuideTipManager.instance.addWindow(this);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener("addedToStage",onAddToStage);
         removeEventListener("removedFromStage",onRemoveStage);
         GuideTipManager.instance.removeWindow(this);
      }
   }
}

