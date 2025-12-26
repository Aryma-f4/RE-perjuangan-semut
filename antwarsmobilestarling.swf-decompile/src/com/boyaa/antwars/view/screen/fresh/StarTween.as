package com.boyaa.antwars.view.screen.fresh
{
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.utils.deg2rad;
   
   public class StarTween extends Sprite
   {
      
      private var tween1:Tween;
      
      private var tween2:Tween;
      
      private var tween3:Tween;
      
      private var tween4:Tween;
      
      private var tween5:Tween;
      
      private var tween6:Tween;
      
      private var tween7:Tween;
      
      private var starArr:Array;
      
      private var pointArr:Array;
      
      public function StarTween(param1:Sprite)
      {
         var _loc2_:Image = null;
         var _loc3_:int = 0;
         starArr = [];
         pointArr = [[-81,81],[-124,-70],[64,-115],[450,-110],[600,-90],[766,-62],[780,170]];
         super();
         _loc3_ = 0;
         while(_loc3_ < 7)
         {
            _loc2_ = new Image(Assets.sAsset.getTexture("gift6"));
            Assets.positionDisplay(_loc2_,"freshGifts","star" + _loc3_);
            _loc2_.pivotX = _loc2_.width / 2;
            _loc2_.pivotY = _loc2_.height / 2;
            starArr.push(_loc2_);
            addChild(_loc2_);
            _loc3_++;
         }
         param1.addChild(this);
         starTween();
      }
      
      private function starTween() : void
      {
         tween1 = new Tween(starArr[0],1.5,"linear");
         tween2 = new Tween(starArr[1],1.5,"linear");
         tween3 = new Tween(starArr[2],1.5,"linear");
         tween4 = new Tween(starArr[3],1.5,"linear");
         tween5 = new Tween(starArr[4],1.5,"linear");
         tween6 = new Tween(starArr[5],1.5,"linear");
         tween7 = new Tween(starArr[6],1.5,"linear");
         tween1.moveTo(pointArr[0][0],pointArr[0][1]);
         tween2.moveTo(pointArr[1][0],pointArr[1][1]);
         tween3.moveTo(pointArr[2][0],pointArr[2][1]);
         tween4.moveTo(pointArr[3][0],pointArr[3][1]);
         tween5.moveTo(pointArr[4][0],pointArr[4][1]);
         tween6.moveTo(pointArr[5][0],pointArr[5][1]);
         tween7.moveTo(pointArr[6][0],pointArr[6][1]);
         tween1.fadeTo(0);
         tween2.fadeTo(0);
         tween3.fadeTo(0);
         tween4.fadeTo(0);
         tween5.fadeTo(0);
         tween6.fadeTo(0);
         tween7.fadeTo(0);
         tween1.animate("rotation",deg2rad(360));
         tween2.animate("rotation",deg2rad(360));
         tween3.animate("rotation",deg2rad(360));
         tween4.animate("rotation",deg2rad(360));
         tween5.animate("rotation",deg2rad(360));
         tween6.animate("rotation",deg2rad(360));
         tween7.animate("rotation",deg2rad(360));
         tween1.repeatCount = tween2.repeatCount = tween3.repeatCount = tween4.repeatCount = tween5.repeatCount = tween6.repeatCount = tween7.repeatCount = 2;
         Starling.juggler.add(tween1);
         Starling.juggler.add(tween2);
         Starling.juggler.add(tween3);
         Starling.juggler.add(tween4);
         Starling.juggler.add(tween5);
         Starling.juggler.add(tween6);
         Starling.juggler.add(tween7);
      }
      
      public function cleanUp() : void
      {
         starArr = [];
         Starling.juggler.removeTweens(this);
         removeFromParent();
      }
   }
}

