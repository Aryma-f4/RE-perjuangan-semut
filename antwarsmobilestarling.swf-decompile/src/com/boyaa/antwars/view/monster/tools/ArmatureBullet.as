package com.boyaa.antwars.view.monster.tools
{
   import com.boyaa.antwars.view.game.ICharacter;
   import dragonBones.Armature;
   import dragonBones.animation.WorldClock;
   import flash.events.Event;
   import flash.geom.Point;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   
   public class ArmatureBullet extends Sprite
   {
      
      protected var _charcter:ICharacter;
      
      protected var _aniCompleteSignal:Signal;
      
      protected var _startSignal:Signal;
      
      protected var _armatureName:String;
      
      protected var _armature:Armature;
      
      protected var _cryTime:Number = 0.3;
      
      public function ArmatureBullet(param1:ICharacter, param2:String)
      {
         super();
         _charcter = param1;
         _aniCompleteSignal = new Signal();
         _startSignal = new Signal();
         _armature = Assets.sAsset.buildArmature(param2);
         init();
      }
      
      public function setBulletPos(param1:Point, param2:Boolean = false) : void
      {
         if(param2)
         {
            this.x = param1.x;
            this.y = param1.y;
         }
         else
         {
            this.x = _charcter.x + param1.x;
            this.y = _charcter.y + param1.y;
         }
      }
      
      public function setCryTimeAndCount(param1:Number) : void
      {
         _cryTime = param1;
      }
      
      private function init() : void
      {
         this.addChild(_armature.display as DisplayObject);
         WorldClock.clock.add(_armature);
         this.x = _charcter.x;
         this.y = _charcter.y;
         _armature.addEventListener("complete",onAniPlayComplete);
      }
      
      private function onAniPlayComplete(param1:Event) : void
      {
         _aniCompleteSignal.dispatch();
         WorldClock.clock.remove(_armature);
         remove();
      }
      
      private function remove() : void
      {
         _armature.removeEventListener("complete",onAniPlayComplete);
         this.removeFromParent(true);
      }
      
      public function start() : void
      {
         _armature.animation.gotoAndPlay("attack");
         _startSignal.dispatch();
         Starling.juggler.delayCall((function():*
         {
            var charcterCry:Function;
            return charcterCry = function():void
            {
               _charcter.icharacterCtrl.playCry();
            };
         })(),_cryTime);
      }
      
      public function get aniCompleteSignal() : Signal
      {
         return _aniCompleteSignal;
      }
      
      public function get startSignal() : Signal
      {
         return _startSignal;
      }
      
      public function setBulletSize(param1:int) : void
      {
         var _loc2_:DisplayObject = _armature.display as DisplayObject;
         _loc2_.width = param1;
         _loc2_.scaleY = _loc2_.scaleX;
      }
   }
}

