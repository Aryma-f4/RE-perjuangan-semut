package com.boyaa.antwars.view.monster.Animation
{
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.element.bullet.Bullet;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.Event;
   
   public class StoneBullet extends Bullet
   {
      
      public function StoneBullet(param1:ICharacterCtrl, param2:int = 0)
      {
         super(param1);
         this.bulletDisplay = new MovieClip(Assets.sAsset.getTextures("石头子弹b"));
         this.bulletDisplay.pivotX = this.bulletDisplay.width;
         this.bulletDisplay.scaleX = -1;
         this.size = 90;
         this.bombRange = 140;
         this.setHitModel();
         _scale = 1;
         Starling.juggler.add(this.bulletDisplay as MovieClip);
         this.bulletDisplay.addEventListener("removedFromStage",onRemoveFromStage);
      }
      
      private function onRemoveFromStage(param1:Event) : void
      {
         removeEventListener("removedFromStage",onRemoveFromStage);
         Starling.juggler.remove(this.bulletDisplay as MovieClip);
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
         blowoutAnimation = new MovieClip(Assets.sAsset.getTextures("石头爆炸b"),30);
         blowoutAnimation.pivotX = blowoutAnimation.width >> 1;
         blowoutAnimation.pivotY = blowoutAnimation.height >> 1;
         blowoutAnimation.scaleX = blowoutAnimation.scaleX = 1.2;
         blowoutAnimation.x = 20;
         blowoutAnimation.y = -10;
      }
      
      override protected function isHitObject(param1:*) : Boolean
      {
         return param1 is Character;
      }
      
      override protected function hitMap() : Boolean
      {
         return false;
      }
      
      override protected function slotting() : void
      {
         slottingCompleteSignal.dispatch([3,this.x,this.y,id,[]]);
      }
   }
}

