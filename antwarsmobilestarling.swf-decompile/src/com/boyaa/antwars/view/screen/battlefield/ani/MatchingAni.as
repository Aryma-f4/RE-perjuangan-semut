package com.boyaa.antwars.view.screen.battlefield.ani
{
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   
   public class MatchingAni extends Sprite
   {
      
      private var _matchingImage:Image;
      
      private var _matchingImage2:Image;
      
      public function MatchingAni(param1:Rectangle = null)
      {
         super();
         init();
         if(param1)
         {
            setPosition(param1);
         }
      }
      
      private function init() : void
      {
         _matchingImage = new Image(Assets.sAsset.getTexture("charloop"));
         _matchingImage2 = new Image(Assets.sAsset.getTexture("charloop"));
         _matchingImage.visible = _matchingImage2.visible = false;
         this.addChild(_matchingImage);
         this.addChild(_matchingImage2);
      }
      
      public function setPosition(param1:Rectangle) : void
      {
         _matchingImage.x = param1.x;
         _matchingImage.y = param1.y;
         _matchingImage2.x = param1.x;
         _matchingImage2.y = param1.y + _matchingImage2.height;
         this.clipRect = param1;
      }
      
      public function start() : void
      {
         _matchingImage.visible = true;
         _matchingImage2.visible = true;
         this.addEventListener("enterFrame",onFrameHandle);
      }
      
      public function stop() : void
      {
         _matchingImage.visible = false;
         _matchingImage2.visible = false;
         this.removeEventListener("enterFrame",onFrameHandle);
      }
      
      private function onFrameHandle(param1:EnterFrameEvent) : void
      {
         _matchingImage.y -= 40;
         _matchingImage2.y -= 40;
         if(_matchingImage2.y < 160)
         {
            _matchingImage.y = 140;
            _matchingImage2.y = 1200;
         }
      }
   }
}

