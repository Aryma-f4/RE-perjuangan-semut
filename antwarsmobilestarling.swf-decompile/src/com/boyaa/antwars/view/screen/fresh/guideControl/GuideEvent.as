package com.boyaa.antwars.view.screen.fresh.guideControl
{
   import starling.events.Event;
   
   public class GuideEvent extends Event
   {
      
      public static const HALL_UI:String = "hallUI";
      
      public static const NEW_UI:String = "newUI";
      
      public function GuideEvent(param1:String, param2:Boolean = false, param3:Object = null)
      {
         super(param1,param2,param3);
      }
   }
}

