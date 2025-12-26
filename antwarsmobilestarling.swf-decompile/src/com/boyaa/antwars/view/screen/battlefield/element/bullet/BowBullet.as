package com.boyaa.antwars.view.screen.battlefield.element.bullet
{
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import starling.display.Image;
   import starling.display.MovieClip;
   
   public class BowBullet extends Bullet
   {
      
      public function BowBullet(param1:ICharacterCtrl, param2:int = 0)
      {
         super(param1,param2);
         this.bulletDisplay = new Image(Assets.sAsset.getTextureAtlas("wqSpritesheet").getTexture("jian" + param2));
         this.size = 70;
         this.bombRange = 200;
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
         this.rotation = this.slopeAngle;
         if(vx < 0)
         {
            this.scaleY = -Math.abs(this.scaleX);
         }
      }
      
      override protected function initBlowoutAnimation() : void
      {
         super.initBlowoutAnimation();
         blowoutAnimation = new MovieClip(Assets.sAsset.getTextureAtlas("wqSpritesheet").getTextures("ddbz00"),13);
         blowoutAnimation.pivotX = blowoutAnimation.width >> 1;
         blowoutAnimation.pivotY = blowoutAnimation.height >> 1;
         blowoutAnimation.x = 30;
         blowoutAnimation.y = 80;
         blowoutAnimation.scaleX = blowoutAnimation.scaleY = 4;
      }
      
      override protected function initCrater() : void
      {
         super.initCrater();
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

