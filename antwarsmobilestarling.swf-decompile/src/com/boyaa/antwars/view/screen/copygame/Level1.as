package com.boyaa.antwars.view.screen.copygame
{
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.text.TextField;
   
   public class Level1 extends Sprite
   {
      
      private var btnNormalEntry:Button;
      
      private var btnHeroEntry:Button;
      
      private var txtLevel:TextField;
      
      private var imgStarBg:Image;
      
      private var starArr:Array;
      
      private var _text:String = "";
      
      public function Level1(param1:String = "normal")
      {
         var _loc5_:int = 0;
         var _loc2_:Image = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         starArr = [];
         super();
         imgStarBg = new Image(Assets.sAsset.getTexture("fb10"));
         txtLevel = new TextField(100,40,"1-1","Verdana",35,268435455);
         txtLevel.touchable = false;
         addChild(imgStarBg);
         imgStarBg.touchable = false;
         _loc5_ = 0;
         while(_loc5_ < 3)
         {
            _loc2_ = new Image(Assets.sAsset.getTexture("fb11"));
            starArr.push(_loc2_);
            _loc2_.visible = false;
            addChild(_loc2_);
            _loc5_++;
         }
         if(param1 == "normal")
         {
            initNormal();
            imgStarBg.x = btnNormalEntry.width - imgStarBg.width >> 1;
            txtLevel.x = imgStarBg.x - 5;
            txtLevel.y = imgStarBg.y + imgStarBg.height + 13;
            _loc3_ = 0;
            while(_loc3_ < 3)
            {
               starArr[_loc3_].x = imgStarBg.x / 2 + _loc3_ * (starArr[_loc3_].width - 3) + 8;
               starArr[_loc3_].y = imgStarBg.y - 4;
               _loc3_++;
            }
         }
         else
         {
            initHero();
            imgStarBg.x = btnHeroEntry.width - imgStarBg.width >> 1;
            txtLevel.x = imgStarBg.x - 5;
            txtLevel.y = imgStarBg.y + imgStarBg.height + 33;
            _loc4_ = 0;
            while(_loc4_ < 3)
            {
               starArr[_loc4_].x = imgStarBg.x / 2 + _loc4_ * (starArr[_loc4_].width - 3) + 18;
               starArr[_loc4_].y = imgStarBg.y - 4;
               _loc4_++;
            }
         }
         addChild(txtLevel);
         imgStarBg.visible = false;
      }
      
      private function initNormal() : void
      {
         btnNormalEntry = new Button(Assets.sAsset.getTexture("fb8"),"",Assets.sAsset.getTexture("fb9"));
         btnNormalEntry.y = imgStarBg.y + imgStarBg.height - 10;
         addChild(btnNormalEntry);
      }
      
      private function initHero() : void
      {
         btnHeroEntry = new Button(Assets.sAsset.getTexture("fb49"),"",Assets.sAsset.getTexture("fb50"));
         btnHeroEntry.y = imgStarBg.y + imgStarBg.height;
         btnHeroEntry.fontColor = 16777215;
         btnHeroEntry.fontSize = 35;
         btnHeroEntry.y = imgStarBg.y + imgStarBg.height - 10;
         addChild(btnHeroEntry);
      }
      
      public function updateStarNum(param1:int) : void
      {
         var _loc3_:int = 0;
         imgStarBg.visible = true;
         var _loc2_:int = param1;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            (starArr[_loc3_] as Image).visible = true;
            _loc3_++;
         }
      }
      
      public function isPlayed() : Boolean
      {
         return imgStarBg.visible;
      }
      
      override public function dispose() : void
      {
         parent && parent.removeChild(this);
         super.dispose();
      }
      
      public function set text(param1:String) : void
      {
         _text = param1;
         txtLevel.text = param1;
      }
      
      public function get text() : String
      {
         return _text;
      }
   }
}

