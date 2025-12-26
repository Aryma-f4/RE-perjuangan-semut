package com.boyaa.antwars.view.screen.fresh
{
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   
   public class CreateWeaponBox extends Sprite
   {
      
      private var _boxMC:MovieClip;
      
      private var _type:int;
      
      private var _frame:int;
      
      private var _weaponBox:Image;
      
      public function CreateWeaponBox(param1:int, param2:int)
      {
         super();
         _type = param1;
         _frame = param2;
         animation();
      }
      
      private function animation() : void
      {
         var _loc2_:TextureAtlas = Assets.sAsset.getTextureAtlas("monsterskill");
         var _loc1_:Vector.<Texture> = _loc2_.getTextures("star00");
         _boxMC = new MovieClip(_loc1_,15);
         _boxMC.blendMode = "screen";
         _boxMC.touchable = false;
         _boxMC.loop = false;
         _boxMC.pivotX = 0;
         _boxMC.pivotY = 0;
         _boxMC.play();
         Starling.juggler.add(_boxMC);
         _boxMC.addEventListener("complete",showWeaponBox);
         addChild(_boxMC);
      }
      
      private function showWeaponBox(param1:Event) : void
      {
         _boxMC.removeFromParent(true);
         _weaponBox = Assets.sAsset.getGoodsImage(_type,_frame);
         _weaponBox.touchable = false;
         _weaponBox.scaleX = _weaponBox.scaleY = 1;
         _weaponBox.x = 20;
         _weaponBox.y = 30;
         addChild(_weaponBox);
      }
      
      public function get hitPoint() : Point
      {
         return new Point(x - 20,y + 30);
      }
   }
}

