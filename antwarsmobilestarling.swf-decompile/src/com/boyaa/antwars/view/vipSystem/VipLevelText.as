package com.boyaa.antwars.view.vipSystem
{
   import starling.display.Image;
   import starling.display.Sprite;
   
   public class VipLevelText extends Sprite
   {
      
      private var _level:int;
      
      private var _vipIcon:Image;
      
      private var _numberView:PictureNumber;
      
      public function VipLevelText()
      {
         super();
         _vipIcon = new Image(Assets.sAsset.getTexture("img_public_vipIcon"));
         this.addChild(_vipIcon);
         _numberView = new PictureNumber();
         _numberView.x = _vipIcon.width + 2;
         _numberView.y -= 5;
         this.addChild(_numberView);
      }
      
      public function get level() : int
      {
         return _level;
      }
      
      public function set level(param1:int) : void
      {
         _level = param1;
         _numberView.number = _level;
         if(_level <= 0)
         {
            visible = false;
         }
         else
         {
            visible = true;
         }
      }
   }
}

