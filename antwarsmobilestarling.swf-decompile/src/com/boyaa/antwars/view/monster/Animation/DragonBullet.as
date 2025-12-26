package com.boyaa.antwars.view.monster.Animation
{
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.element.bullet.Bullet;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.Event;
   
   public class DragonBullet extends Bullet
   {
      
      public function DragonBullet(param1:ICharacterCtrl, param2:int = 0)
      {
         super(param1);
         this.bulletDisplay = new MovieClip(Assets.sAsset.getTextures("qiu000"),12);
         this.bulletDisplay.pivotX = this.bulletDisplay.width;
         this.bulletDisplay.scaleX = -1;
         this.size = 40;
         this.bombRange = 140;
         this.setHitModel();
         _scale = 0.8;
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
      
      override public function init(param1:Point, param2:Number, param3:Number, param4:Number = 0) : void
      {
         this.firingPoint = param1;
         this.showBulletR = param4;
         this.x = param1.x;
         this.y = param1.y;
         var _loc6_:Number = param2 * 3.141592653589793 / 180;
         var _loc5_:Number = Math.cos(_loc6_);
         vy = param3 * Math.sin(_loc6_);
         vx = param3 * _loc5_;
         tanAngle = Math.tan(_loc6_);
         dK = 1.2 / (param3 * param3 * _loc5_ * _loc5_);
      }
      
      override protected function initBlowoutAnimation() : void
      {
         blowoutAnimation = new MovieClip(Assets.sAsset.getTextures("xsbz00"),10);
         blowoutAnimation.pivotX = blowoutAnimation.width >> 1;
         blowoutAnimation.pivotY = blowoutAnimation.height >> 1;
         blowoutAnimation.scaleX = blowoutAnimation.scaleY = 1.2;
         blowoutAnimation.x = 110;
         blowoutAnimation.y = 20;
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

