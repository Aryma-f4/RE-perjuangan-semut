package com.boyaa.antwars.view.screen.rankList
{
   import com.boyaa.antwars.helper.AntwarsPictureLoader;
   import flash.geom.Rectangle;
   import starling.display.Sprite;
   
   public class FacebookHeadPicture
   {
      
      private var _container:Sprite;
      
      private var _playerHead:Sprite;
      
      private var _rect:Rectangle;
      
      private var _url:String;
      
      public function FacebookHeadPicture(param1:Sprite, param2:Rectangle)
      {
         super();
         _container = param1;
         _rect = param2;
         _playerHead = new Sprite();
         _container.addChild(_playerHead);
      }
      
      public function update(param1:String) : void
      {
         clear();
         new AntwarsPictureLoader().load(param1,_rect,_playerHead);
      }
      
      public function clear() : void
      {
         _playerHead.removeChildren();
      }
   }
}

