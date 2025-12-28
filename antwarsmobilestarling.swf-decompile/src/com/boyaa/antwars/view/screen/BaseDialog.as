package com.boyaa.antwars.view.screen
{
   import starling.display.Sprite;
   import starling.display.DisplayObject;

   public class BaseDialog extends Sprite
   {
      protected var _isClickStageClose:Boolean = false;
      protected var bgAlpha:Number = 0.5;

      public function BaseDialog()
      {
         super();
         initialize();
      }

      protected function initialize():void
      {
      }

      protected function addDialog(view:DisplayObject):void
      {
         addChild(view);
      }

      override public function dispose():void
      {
         super.dispose();
      }
   }
}
