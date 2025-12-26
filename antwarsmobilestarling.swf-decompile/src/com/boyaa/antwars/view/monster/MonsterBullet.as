package com.boyaa.antwars.view.monster
{
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.element.bullet.Bullet;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.Event;
   
   public class MonsterBullet extends Bullet
   {
      
      protected var _flyAltasName:String = "";
      
      protected var _explosionAltasName:String = "";
      
      protected var _direction:int = 0;
      
      protected var _bulletSize:int = 90;
      
      protected var _monsterBombRange:int = 140;
      
      protected var _blowOutPoint:Point = new Point(0,0);
      
      protected var _bulletScale:Number = 1;
      
      protected var _explosionAniScale:Number = 1.2;
      
      public function MonsterBullet(param1:ICharacterCtrl, param2:int = 0)
      {
         super(param1,param2);
         initMonsterBullet();
         this.bulletDisplay = new MovieClip(Assets.sAsset.getTextures(_flyAltasName));
         this.bulletDisplay.pivotX = this.bulletDisplay.width;
         this.bulletDisplay.scaleX = _direction;
         this.size = _bulletSize;
         this.bombRange = _monsterBombRange;
         this.setHitModel();
         _scale = _bulletScale;
         Starling.juggler.add(this.bulletDisplay as MovieClip);
         this.bulletDisplay.addEventListener("removedFromStage",onRemoveFromStage);
      }
      
      protected function initMonsterBullet() : void
      {
         _flyAltasName = "石头子弹b";
         _explosionAltasName = "石头爆炸b";
         _direction = -1;
         _bulletSize = 90;
         _monsterBombRange = 140;
      }
      
      override protected function initBlowoutAnimation() : void
      {
         blowoutAnimation = new MovieClip(Assets.sAsset.getTextures(_explosionAltasName),30);
         blowoutAnimation.pivotX = blowoutAnimation.width >> 1;
         blowoutAnimation.pivotY = blowoutAnimation.height >> 1;
         blowoutAnimation.scaleX = blowoutAnimation.scaleY = _explosionAniScale;
         blowoutAnimation.x = _blowOutPoint.x;
         blowoutAnimation.y = _blowOutPoint.y;
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
      
      protected function onRemoveFromStage(param1:Event) : void
      {
         removeEventListener("removedFromStage",onRemoveFromStage);
         Starling.juggler.remove(this.bulletDisplay as MovieClip);
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

