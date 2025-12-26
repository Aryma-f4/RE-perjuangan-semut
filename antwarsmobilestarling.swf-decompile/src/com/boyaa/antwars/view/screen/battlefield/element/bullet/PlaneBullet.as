package com.boyaa.antwars.view.screen.battlefield.element.bullet
{
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.tool.Draw;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.Event;
   
   public class PlaneBullet extends Bullet
   {
      
      public function PlaneBullet(param1:ICharacterCtrl, param2:int = 0)
      {
         super(param1);
         this.bulletDisplay = new MovieClip(Assets.sAsset.getTextureAtlas("battlefieldSpritesheet").getTextures("planeplay"),10);
         this.bulletDisplay.addEventListener("removedFromStage",onRemoveFromStage);
         this.size = 80;
         Starling.juggler.add(this.bulletDisplay as MovieClip);
         this.setHitModel();
      }
      
      override public function setHitModel(param1:BitmapData = null) : void
      {
         var _loc2_:Shape = null;
         if(!param1)
         {
            this.bitmapModel = new BitmapData(30,30,true,0);
            _loc2_ = Draw.doDrawCircle(bitmapModel.width / 2,16711680) as Shape;
            this.bitmapModel.draw(_loc2_,new Matrix(1,0,0,1,bitmapModel.width / 2,bitmapModel.height / 2));
         }
         else
         {
            this.bitmapModel = param1;
         }
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
         blowoutAnimation = new MovieClip(Assets.sAsset.getTextureAtlas("battlefieldSpritesheet").getTextures("ld000"),15);
         blowoutAnimation.pivotX = blowoutAnimation.width >> 1;
         blowoutAnimation.pivotY = blowoutAnimation.height >> 1;
         blowoutAnimation.x = 60;
         blowoutAnimation.y = 0;
      }
      
      override protected function slotting() : void
      {
         slottingCompleteSignal.dispatch([3,this.x,this.y,id,[],-vy]);
      }
      
      override protected function myHitTest() : Boolean
      {
         return false;
      }
      
      override protected function shockCharaters() : void
      {
      }
      
      private function onRemoveFromStage(param1:Event) : void
      {
         this.bulletDisplay.removeEventListener("removedFromStage",onRemoveFromStage);
         Starling.juggler.remove(this.bulletDisplay as MovieClip);
      }
   }
}

