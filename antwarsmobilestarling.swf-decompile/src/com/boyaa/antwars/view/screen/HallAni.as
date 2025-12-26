package com.boyaa.antwars.view.screen
{
   import com.boyaa.antwars.helper.Timepiece;
   import dragonBones.Armature;
   import dragonBones.animation.WorldClock;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   
   public class HallAni
   {
      
      private var _forgeSmoke:Sprite = new Sprite();
      
      private var _copySmoke:Sprite = new Sprite();
      
      private var _copyEye:Sprite = new Sprite();
      
      private var _shopLight:Sprite = new Sprite();
      
      private var _fightAni:Sprite = new Sprite();
      
      private var _aniNameArr:Array = ["shopLight","copySmoke","copyEye","forgeSmoke"];
      
      private var _haiou:Sprite = new Sprite();
      
      private var _hall:Sprite;
      
      private var _armatureArr:Array = [];
      
      private const DISTANCE:int = 3;
      
      public function HallAni(param1:Sprite)
      {
         super();
         _hall = param1;
         init();
      }
      
      private function init() : void
      {
         var _loc3_:int = 0;
         var _loc2_:Sprite = null;
         var _loc1_:Armature = null;
         _loc3_ = 0;
         while(_loc3_ < _aniNameArr.length)
         {
            _loc2_ = this["_" + _aniNameArr[_loc3_]];
            _loc1_ = createArmature(_aniNameArr[_loc3_]);
            _loc2_.addChild(_loc1_.display as DisplayObject);
            Assets.sAsset.positionDisplay(_loc2_,"hall",_aniNameArr[_loc3_] + "Pos");
            _hall.addChild(_loc2_);
            _loc2_.touchable = false;
            _armatureArr.push(_loc1_);
            _loc3_++;
         }
         addHaiOu();
         _copySmoke.x -= _copySmoke.width / 2;
         _copySmoke.y -= _copySmoke.height / 2;
      }
      
      private function addHaiOu() : void
      {
         var _loc1_:Armature = createArmature("haiou");
         _haiou.addChild(_loc1_.display as DisplayObject);
         _haiou.touchable = false;
         _hall.addChild(_haiou);
         Timepiece.instance.addFun(onHaiOuFly);
         initHaiouPosition();
         _haiou.width = 100;
         _haiou.scaleY = _haiou.scaleX;
         _armatureArr.push(_loc1_);
      }
      
      private function initHaiouPosition() : void
      {
         _haiou.x = -50;
         _haiou.y = 768 + 50;
      }
      
      private function onHaiOuFly() : void
      {
         _haiou.x += Math.cos(3.141592653589793 / 6) * 3;
         _haiou.y -= Math.sin(3.141592653589793 / 7) * 3;
         if(_haiou.x >= 1365 * 1.5)
         {
            initHaiouPosition();
         }
      }
      
      private function createArmature(param1:String) : Armature
      {
         var _loc2_:Armature = Assets.sAsset.buildArmature(param1);
         _loc2_.animation.gotoAndPlay("tmp");
         WorldClock.clock.add(_loc2_);
         return _loc2_;
      }
      
      public function dispose() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Sprite = null;
         var _loc2_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _aniNameArr.length)
         {
            _loc1_ = this["_" + _aniNameArr[_loc3_]];
            _loc1_.removeFromParent(true);
            _loc3_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _armatureArr.length)
         {
            WorldClock.clock.remove(_armatureArr[_loc2_]);
            _loc2_++;
         }
         _haiou.removeFromParent(true);
         Timepiece.instance.removeFun(onHaiOuFly);
      }
   }
}

