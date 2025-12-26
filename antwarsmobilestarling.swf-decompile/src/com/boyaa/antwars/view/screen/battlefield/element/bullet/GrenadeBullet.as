package com.boyaa.antwars.view.screen.battlefield.element.bullet
{
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import starling.display.Image;
   import starling.display.MovieClip;
   
   public class GrenadeBullet extends Bullet
   {
      
      public function GrenadeBullet(param1:ICharacterCtrl, param2:int = 0)
      {
         super(param1);
         this.bulletDisplay = new Image(Assets.sAsset.getTextureAtlas("wqSpritesheet").getTexture("grenade" + param2));
         this.size = 40;
         this.bombRange = 150;
         this.setParticle();
         this.setHitModel();
      }
      
      override public function advanceTime(param1:Number) : void
      {
         super.advanceTime(param1);
         if(!_start)
         {
            return;
         }
         this.rotation += 1;
      }
      
      override protected function initBlowoutAnimation() : void
      {
         blowoutAnimation = new MovieClip(Assets.sAsset.getTextureAtlas("wqSpritesheet").getTextures("l00"),13);
         blowoutAnimation.pivotX = blowoutAnimation.width >> 1;
         blowoutAnimation.pivotY = blowoutAnimation.height >> 1;
         blowoutAnimation.x = 30;
         blowoutAnimation.y = 80;
         blowoutAnimation.scaleX = blowoutAnimation.scaleY = 3;
      }
      
      override protected function initCrater() : void
      {
         hole = new Image(Assets.sAsset.getTextureAtlas("wqSpritesheet").getTexture("k1"));
         hole.pivotX = hole.width >> 1;
         hole.pivotY = hole.height >> 1;
         holeBitmapModel = Assets.sAsset.getBitmapData("k1");
         brink = new Image(Assets.sAsset.getTextureAtlas("wqSpritesheet").getTexture("k0"));
         brink.pivotX = brink.width >> 1;
         brink.pivotY = brink.height >> 1;
      }
   }
}

