package com.boyaa.antwars.view.monster
{
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   
   public class Animation extends EventDispatcher
   {
      
      protected var _display:Sprite;
      
      protected var _stand:MovieClip;
      
      protected var _attack:MovieClip;
      
      protected var _move:MovieClip;
      
      protected var _dizzy:MovieClip;
      
      protected var _angel:MovieClip;
      
      protected var _status:String;
      
      public function Animation()
      {
         super();
      }
      
      public function get display() : Object
      {
         return {};
      }
      
      public function update() : void
      {
      }
      
      public function gotoAndPlay(param1:String) : void
      {
      }
      
      protected function onComplete(param1:Event = null) : void
      {
         dispatchEventWith("complete");
      }
      
      protected function changeStatus(param1:String, param2:String) : void
      {
         if(param1 == param2)
         {
            return;
         }
         this["_" + param1].removeFromParent();
         this["_" + param1].stop();
         Starling.juggler.remove(this["_" + param1]);
         _display.addChild(this["_" + param2]);
         this["_" + param2].play();
         Starling.juggler.add(this["_" + param2]);
      }
      
      public function dispose() : void
      {
      }
   }
}

