package com.boyaa.antwars.view.screen.copygame.game.element
{
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   import starling.utils.formatString;
   
   public class StoneGate extends Sprite
   {
      
      private var asset:ResAssetManager;
      
      private var count:Number = 0;
      
      public function StoneGate()
      {
         super();
         asset = Assets.sAsset;
         var _loc1_:ResManager = Application.instance.resManager;
         asset.enqueue(_loc1_.getResFile(formatString("textures/{0}x/COPYGAME/stone.png",asset.scaleFactor)));
         asset.loadQueue(loading);
      }
      
      private function loading(param1:Number) : void
      {
         if(param1 >= 1)
         {
            init();
         }
      }
      
      protected function init() : void
      {
         var _loc1_:Image = new Image(asset.getTexture("stone"));
         addChild(_loc1_);
         var _loc2_:Rectangle = Assets.getPosition("map204","stonedoor");
         this.pivotX = this.width >> 1;
         this.pivotY = this.height >> 1;
         this.x = _loc2_.x;
         this.y = _loc2_.y;
         this.width = _loc2_.width;
         this.height = _loc2_.height;
         addEventListener("enterFrame",onEnterFrame);
      }
      
      protected function onEnterFrame(param1:EnterFrameEvent) : void
      {
         this.alpha = Math.sin(count);
         count += 0.2;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener("enterFrame",onEnterFrame);
         asset.removeTexture("stone");
      }
   }
}

