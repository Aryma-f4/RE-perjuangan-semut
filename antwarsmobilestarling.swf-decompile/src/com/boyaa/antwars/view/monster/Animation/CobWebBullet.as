package com.boyaa.antwars.view.monster.Animation
{
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import starling.display.MovieClip;
   
   public class CobWebBullet extends StoneBullet
   {
      
      public function CobWebBullet(param1:ICharacterCtrl, param2:int = 0)
      {
         super(param1,param2);
         this.bulletDisplay = new MovieClip(Assets.sAsset.getTextures("蜘蛛网子弹"));
      }
      
      override protected function initBlowoutAnimation() : void
      {
         blowoutAnimation = new MovieClip(Assets.sAsset.getTextures("蜘蛛网爆炸"),10);
         blowoutAnimation.pivotX = blowoutAnimation.width >> 1;
         blowoutAnimation.pivotY = blowoutAnimation.height >> 1;
         blowoutAnimation.scaleX = blowoutAnimation.scaleX = 2;
         blowoutAnimation.x = 20;
         blowoutAnimation.y = -20;
      }
   }
}

