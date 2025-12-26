package com.boyaa.antwars.view.screen.copygame
{
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.text.TextField;
   
   public class CityWorldLevel extends Sprite
   {
      
      private static var _textureArr:Array = ["fb10","fb11","fb8","fb9","fb49","fb50","锁头"];
      
      protected var btnNormal:Button;
      
      protected var btnHero:Button;
      
      protected var txtLevel:TextField;
      
      protected var imgStarBg:Image;
      
      protected var starArr:Array = [];
      
      protected var lockImg:Image;
      
      private var _text:String = "";
      
      public const NORMAL:String = "normal";
      
      public const HERO:String = "hero";
      
      public const MAXSTARNUM:int = 3;
      
      private var _currentMode:String = "normal";
      
      public function CityWorldLevel(param1:String = "normal")
      {
         super();
         init(param1);
      }
      
      public static function get textureArr() : Array
      {
         return _textureArr;
      }
      
      public static function set textureArr(param1:Array) : void
      {
         _textureArr = param1;
      }
      
      protected function init(param1:String) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Image = null;
         imgStarBg = new Image(Assets.sAsset.getTexture(textureArr[0]));
         lockImg = new Image(Assets.sAsset.getTexture(textureArr[6]));
         txtLevel = new TextField(100,40,"1-1","Verdana",35,16777215);
         txtLevel.touchable = false;
         addChild(imgStarBg);
         imgStarBg.touchable = false;
         _currentMode = param1;
         _loc3_ = 0;
         while(_loc3_ < 3)
         {
            _loc2_ = new Image(Assets.sAsset.getTexture(textureArr[1]));
            starArr.push(_loc2_);
            _loc2_.visible = false;
            addChild(_loc2_);
            _loc3_++;
         }
         if(param1 == "normal")
         {
            initNormal();
         }
         else
         {
            initHero();
         }
         changeHeroAndNormalPos();
         addChild(txtLevel);
         addChild(lockImg);
         imgStarBg.visible = false;
      }
      
      protected function initNormal() : void
      {
         btnNormal = new Button(Assets.sAsset.getTexture(textureArr[2]),"",Assets.sAsset.getTexture(textureArr[3]));
         btnNormal.y = imgStarBg.y + imgStarBg.height - 10;
         addChild(btnNormal);
      }
      
      protected function initHero() : void
      {
         btnHero = new Button(Assets.sAsset.getTexture(textureArr[4]),"",Assets.sAsset.getTexture(textureArr[5]));
         btnHero.y = imgStarBg.y + imgStarBg.height - 10;
         addChild(btnHero);
      }
      
      protected function changeHeroAndNormalPos() : void
      {
      }
      
      protected function changePos(param1:Button, param2:int = 5, param3:int = 13, param4:int = 8, param5:int = 4) : void
      {
         var _loc6_:int = 0;
         imgStarBg.x = param1.width - imgStarBg.width >> 1;
         txtLevel.x = imgStarBg.x - param2;
         txtLevel.y = imgStarBg.y + imgStarBg.height + param3;
         _loc6_ = 0;
         while(_loc6_ < 3)
         {
            starArr[_loc6_].x = imgStarBg.x / 2 + _loc6_ * (starArr[_loc6_].width - 3) + param4;
            starArr[_loc6_].y = imgStarBg.y - param5;
            _loc6_++;
         }
         lockImg.x = param1.width - lockImg.width >> 1;
         lockImg.y = param1.y;
      }
      
      public function showLock(param1:Boolean = true) : void
      {
         if(param1)
         {
            lockImg.visible = true;
            this.touchable = false;
         }
         else
         {
            lockImg.visible = false;
            this.touchable = true;
         }
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
      
      public function get text() : String
      {
         return _text;
      }
      
      public function set text(param1:String) : void
      {
         _text = param1;
         txtLevel.text = param1;
      }
      
      public function get currentMode() : String
      {
         return _currentMode;
      }
   }
}

