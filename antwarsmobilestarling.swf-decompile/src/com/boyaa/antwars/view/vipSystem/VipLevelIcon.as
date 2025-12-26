package com.boyaa.antwars.view.vipSystem
{
   import starling.display.Image;
   import starling.display.Sprite;
   
   public class VipLevelIcon extends Sprite
   {
      
      private const TEXTURE_NAME:String = "vipLevelTitle";
      
      private var _image:Image;
      
      private var _level:int;
      
      public function VipLevelIcon(param1:int = 0)
      {
         super();
         _level = param1;
         init();
      }
      
      private function init() : void
      {
         _image = new Image(Assets.sAsset.getTexture("vipLevelTitle1"));
         addChild(_image);
         if(_level <= 0)
         {
            _image.visible = false;
         }
      }
      
      public function get level() : int
      {
         return _level;
      }
      
      public function set level(param1:int) : void
      {
         _image.visible = true;
         _level = param1;
         if(_level != 0)
         {
            _image.texture = Assets.sAsset.getTexture("vipLevelTitle" + _level);
         }
         if(_level <= 0)
         {
            _image.visible = false;
         }
      }
   }
}

