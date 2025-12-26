package com.boyaa.antwars.view.screen.union.commonBtn
{
   import starling.events.Event;
   
   public class UnionCheckBoxEvent extends Event
   {
      
      public static var SELECT:String = "UnionCheckBoxEvent::SELECT";
      
      public function UnionCheckBoxEvent(param1:String)
      {
         super(param1,false,null);
      }
   }
}

