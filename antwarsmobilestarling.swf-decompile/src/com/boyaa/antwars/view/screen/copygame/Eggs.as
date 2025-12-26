package com.boyaa.antwars.view.screen.copygame
{
   import com.boyaa.antwars.view.monster.Animation;
   import com.boyaa.tool.TweenQueue;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Sprite;
   
   public class Eggs extends Animation
   {
      
      private var eggImage:Image;
      
      private var glowImage:Image;
      
      private var star:Image;
      
      private var tween1:Tween;
      
      private var tween2:Tween;
      
      private var tween3:Tween;
      
      private var tween4:Tween;
      
      private var tween5:Tween;
      
      private var glowTween:TweenQueue;
      
      private var starArr:Array;
      
      private var pointArr:Array;
      
      public function Eggs(param1:int = 1)
      {
         var _loc2_:int = 0;
         starArr = [];
         pointArr = [[80,-17],[55,-80],[-110,-20],[-10,-110],[-65,-80]];
         super();
         _display = new Sprite();
         glowImage = new Image(Assets.sAsset.getTexture("光egg" + param1));
         glowImage.pivotX = glowImage.width / 2;
         glowImage.pivotY = glowImage.height / 2;
         glowImage.scaleX = glowImage.scaleY = 0.7;
         eggImage = new Image(Assets.sAsset.getTexture("egg" + param1));
         eggImage.pivotX = eggImage.width / 2;
         eggImage.pivotY = eggImage.height / 2;
         eggImage.scaleX = eggImage.scaleY = 0.7;
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            star = new Image(Assets.sAsset.getTexture("星星"));
            star.scaleX = star.scaleY = 0.4;
            star.pivotX = star.pivotY = star.width / 2;
            star.x = (star.x - eggImage.x) / 2 - star.width / 2;
            star.y = (star.y - eggImage.y) / 2 - star.height / 2;
            _display.addChild(star);
            starArr.push(star);
            _loc2_++;
         }
         _display.addChild(eggImage);
         _display.addChild(glowImage);
         _display.touchable = false;
         eggGlow();
         starTween();
      }
      
      override public function get display() : Object
      {
         return _display;
      }
      
      private function eggGlow() : void
      {
         glowImage.alpha = 0;
         glowTween = new TweenQueue();
         glowTween.repeatCount = 0;
         glowTween.add(glowImage,1.5,{"alpha":1},"easeInOut");
         glowTween.add(glowImage,1.5,{"alpha":0});
         glowTween.start();
      }
      
      private function starTween() : void
      {
         tween1 = new Tween(starArr[0],3,"easeInOut");
         tween2 = new Tween(starArr[1],3,"easeInOut");
         tween3 = new Tween(starArr[2],3,"easeInOut");
         tween4 = new Tween(starArr[3],3,"easeInOut");
         tween5 = new Tween(starArr[4],3,"easeInOut");
         tween1.moveTo(pointArr[0][0],pointArr[0][1]);
         tween2.moveTo(pointArr[1][0],pointArr[1][1]);
         tween3.moveTo(pointArr[2][0],pointArr[2][1]);
         tween4.moveTo(pointArr[3][0],pointArr[3][1]);
         tween5.moveTo(pointArr[4][0],pointArr[4][1]);
         tween1.fadeTo(0);
         tween2.fadeTo(0);
         tween3.fadeTo(0);
         tween4.fadeTo(0);
         tween5.fadeTo(0);
         tween1.repeatCount = tween2.repeatCount = tween3.repeatCount = tween4.repeatCount = tween5.repeatCount = 0;
         Starling.juggler.add(tween1);
         Starling.juggler.add(tween2);
         Starling.juggler.add(tween3);
         Starling.juggler.add(tween4);
         Starling.juggler.add(tween5);
      }
      
      override public function dispose() : void
      {
         trace("[...dispose Egg...]");
         starArr = [];
         Starling.juggler.remove(tween1);
         Starling.juggler.remove(tween2);
         Starling.juggler.remove(tween3);
         Starling.juggler.remove(tween4);
         Starling.juggler.remove(tween5);
         glowTween.stop();
         glowTween.dispose();
         _display.removeFromParent();
      }
   }
}

