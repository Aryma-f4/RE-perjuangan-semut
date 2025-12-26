package com.boyaa.antwars.view.display
{
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class ClickSprite extends Sprite
   {
      
      public function ClickSprite()
      {
         super();
         addEventListener("touch",dispatchMouseEvent);
      }
      
      private function dispatchMouseEvent(param1:TouchEvent) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc3_:Point = null;
         var _loc2_:Touch = param1.getTouch(this,"ended");
         if(_loc2_)
         {
            _loc4_ = param1.currentTarget as DisplayObject;
            _loc3_ = _loc2_.getLocation(_loc4_);
            if(_loc4_.hitTest(_loc3_,true))
            {
               dispatchEventWith("triggered",true);
            }
         }
      }
   }
}

