package com.boyaa.antwars.view.display
{
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class DlgMark extends Sprite
   {
      
      private var _callBack:Function = null;
      
      public function DlgMark()
      {
         super();
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("resultbg"));
         _loc1_.width = 1365 + 60;
         _loc1_.height = 768 + 60;
         addChild(_loc1_);
         _loc1_.x = -30;
         _loc1_.y = -30;
         _loc1_.alpha = 0.3;
         this.addEventListener("touch",onTouchHandle);
      }
      
      private function onTouchHandle(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(param1.target as DisplayObject,"ended");
         if(_loc2_)
         {
            if(_callBack != null)
            {
               _callBack();
            }
         }
      }
      
      public function setTouchHandle(param1:Function) : void
      {
         _callBack = param1;
      }
   }
}

