package com.boyaa.antwars.view.screen.wedding
{
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.Timepiece;
   import dragonBones.Armature;
   import dragonBones.animation.WorldClock;
   import dragonBones.events.AnimationEvent;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   
   public class WeddingBeginAni extends Sprite
   {
      
      private var _bgImage:Image;
      
      private var _armature:Armature;
      
      public function WeddingBeginAni()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         _bgImage = new Image(Assets.sAsset.getTexture("weddingBegin"));
         var _loc1_:Rectangle = Assets.getPosition("wedding","bg");
         _bgImage.x = _loc1_.x;
         _bgImage.y = _loc1_.y;
         this.addChild(_bgImage);
         _armature = SmallCodeTools.instance.createArmature("weddingBeginAni","tmp");
         this.addChild(_armature.display as DisplayObject);
         this.touchable = false;
         if(Assets.sAsset.scaleFactor != 1)
         {
            DisplayObject(_armature.display).x = 170.5;
         }
         this.x = 170.5;
         Timepiece.instance.addDelayCall(fadeBgImage,2600);
         _armature.addEventListener("complete",onCompleteHandle);
      }
      
      private function onCompleteHandle(param1:AnimationEvent) : void
      {
         remove();
      }
      
      private function fadeBgImage() : void
      {
         WeddingAniManager.instance.aniSignal.dispatch("openAniDone");
         Starling.juggler.tween(_bgImage,0.5,{"alpha":0});
      }
      
      private function remove() : void
      {
         WorldClock.clock.remove(_armature);
         this.removeFromParent(true);
      }
   }
}

