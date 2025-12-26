package com.boyaa.antwars.view.screen.wedding
{
   import com.boyaa.antwars.helper.SmallCodeTools;
   import dragonBones.Armature;
   import dragonBones.animation.WorldClock;
   import dragonBones.events.AnimationEvent;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   
   public class WeddingFirework extends Sprite
   {
      
      private var _armature:Armature;
      
      private var _arr:Array = ["firework","colorpapers"];
      
      public function WeddingFirework(param1:int)
      {
         super();
         init(param1);
      }
      
      private function init(param1:int) : void
      {
         _armature = SmallCodeTools.instance.createArmature(_arr[param1 - 1],"tmp");
         this.addChild(_armature.display as DisplayObject);
         this.touchable = false;
         _armature.addEventListener("complete",onAnimationComplete);
      }
      
      private function onAnimationComplete(param1:AnimationEvent) : void
      {
         WorldClock.clock.remove(_armature);
         this.removeFromParent(true);
      }
   }
}

