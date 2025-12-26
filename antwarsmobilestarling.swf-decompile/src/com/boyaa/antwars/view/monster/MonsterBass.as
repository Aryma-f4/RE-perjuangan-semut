package com.boyaa.antwars.view.monster
{
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.game.ICharacter;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.BtMap;
   import dragonBones.Armature;
   import dragonBones.Bone;
   import dragonBones.animation.WorldClock;
   import dragonBones.events.AnimationEvent;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import org.osflash.signals.Signal;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.filters.ColorMatrixFilter;
   
   public class MonsterBass extends Sprite implements ICharacter
   {
      
      protected static var sHelperPoint:Point = new Point();
      
      protected static var hitHelperPoint:Point = new Point();
      
      protected var _data:MonsterData;
      
      protected var armature:Armature;
      
      protected var animation:Animation;
      
      protected var _characterCtrl:ICharacterCtrl;
      
      public var bitmapModel:BitmapData;
      
      protected var _bitmapRectangle:Rectangle;
      
      private var _canHit:Boolean = true;
      
      public var animationCompleteSignal:Signal;
      
      private var _channel:SoundChannel = null;
      
      protected var _soundDictionary:Dictionary = new Dictionary();
      
      private var _isAttack:Boolean = false;
      
      protected var _status:String;
      
      private var _soundTransFrom:SoundTransform = new SoundTransform();
      
      public function MonsterBass()
      {
         super();
      }
      
      public function getArmature() : Armature
      {
         return armature;
      }
      
      public function getAnimation() : Animation
      {
         return animation;
      }
      
      protected function initSoundDictionary() : void
      {
      }
      
      public function init(param1:MonsterData) : void
      {
         _data = param1;
         createBitmapModel();
         addEventListener("enterFrame",onEnterFrameHandler);
         animationCompleteSignal = new Signal(String);
         if(param1.monster_height != 0)
         {
            this.height = param1.monster_height;
         }
         this.scaleX = this.scaleY;
         WorldClock.clock.add(armature);
         initSoundDictionary();
      }
      
      protected function onEnterFrameHandler(param1:EnterFrameEvent) : void
      {
         if(animation)
         {
            animation.update();
         }
      }
      
      public function setAnimation(param1:Animation) : void
      {
         this.animation = param1;
         addChild(param1.display as DisplayObject);
         param1.addEventListener("complete",onAnimationComplete2);
      }
      
      protected function onAnimationComplete2(param1:Event) : void
      {
         animationCompleteSignal.dispatch(_status);
      }
      
      public function setArmature(param1:Armature) : void
      {
         this.armature = param1;
         addChild(param1.display as DisplayObject);
         param1.addEventListener("complete",onAnimationComplete);
      }
      
      protected function onAnimationComplete(param1:AnimationEvent) : void
      {
      }
      
      protected function createBitmapModel() : void
      {
         if(data.monster_width != 0 && data.monster_height != 0)
         {
            bitmapModel = new BitmapData(data.monster_width,data.monster_height,true,4294967295);
         }
         _bitmapRectangle = new Rectangle(0,0,data.monster_width,data.monster_height);
      }
      
      public function setStatus(param1:String) : void
      {
         _status = param1;
         trace("monster\'s type:" + data.spiece_type + " monster\'s status:" + param1);
      }
      
      public function get icharacterCtrl() : ICharacterCtrl
      {
         return _characterCtrl;
      }
      
      public function get bitmapRectangle() : Rectangle
      {
         _bitmapRectangle.x = this.x;
         _bitmapRectangle.y = this.y;
         return _bitmapRectangle;
      }
      
      public function get canHit() : Boolean
      {
         return _canHit;
      }
      
      public function set canHit(param1:Boolean) : void
      {
         _canHit = param1;
      }
      
      public function get data() : MonsterData
      {
         return _data;
      }
      
      public function get isAttack() : Boolean
      {
         return _isAttack;
      }
      
      public function set isAttack(param1:Boolean) : void
      {
         _isAttack = param1;
      }
      
      public function hitMap(param1:int, param2:int, param3:BtMap) : Boolean
      {
         if(!bitmapModel || _data.isfly)
         {
            return true;
         }
         sHelperPoint.setTo(0,0);
         hitHelperPoint.setTo(param1 - bitmapModel.width / 2,param2 - bitmapModel.height - 5);
         return param3.bitmapData.hitTest(sHelperPoint,255,bitmapModel,hitHelperPoint,255);
      }
      
      public function playActSound(param1:int = 1) : void
      {
         var _loc2_:Sound = Assets.sAsset.getSound(_soundDictionary[_status]);
         if(_status == "move")
         {
            param1 = 99;
         }
         else
         {
            param1 = 1;
            stopActSound();
         }
         if(!_loc2_ || !SoundManager.soundSwitch)
         {
            return;
         }
         stopActSound();
         _channel = _loc2_.play(0,param1);
         _soundTransFrom.volume = 0.5;
         if(_channel != null)
         {
            _channel.soundTransform = _soundTransFrom;
         }
      }
      
      public function stopActSound() : void
      {
         if(_channel)
         {
            _channel.stop();
         }
      }
      
      public function setMonsterColor(param1:Array, param2:Array = null) : void
      {
         var _loc10_:int = 0;
         var _loc4_:* = null;
         var _loc7_:int = 0;
         var _loc5_:Bone = null;
         var _loc8_:int = 0;
         var _loc6_:Vector.<Number> = new Vector.<Number>();
         var _loc3_:* = param2;
         if(!_loc3_)
         {
            _loc3_ = [0.34,0,0,0,91,0,0.26,0,0,-11,0,0,0.54,0,35,0,0,0,0.64,0];
         }
         _loc10_ = 0;
         while(_loc10_ < _loc3_.length)
         {
            _loc6_.push(_loc3_[_loc10_]);
            _loc10_++;
         }
         var _loc9_:ColorMatrixFilter = new ColorMatrixFilter(_loc6_);
         _loc7_ = 0;
         while(_loc7_ < param1.length)
         {
            if(param1[_loc7_] is Array)
            {
               _loc4_ = param1;
               _loc5_ = armature.getBone(_loc4_[0]);
               _loc8_ = 1;
               while(_loc8_ < _loc4_.length)
               {
                  _loc5_ = _loc5_.childArmature.getBone(_loc4_[_loc8_]);
                  _loc8_++;
               }
               _loc5_.display.filter = _loc9_;
            }
            else
            {
               armature.getBone(param1[_loc7_]).display.filter = _loc9_;
            }
            _loc7_++;
         }
      }
      
      override public function dispose() : void
      {
         animation && animation.dispose();
         WorldClock.clock.remove(armature);
         super.dispose();
      }
   }
}

