package com.boyaa.antwars.view.character
{
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.game.ICharacter;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.BtMap;
   import dragonBones.Armature;
   import dragonBones.Bone;
   import dragonBones.animation.WorldClock;
   import dragonBones.events.AnimationEvent;
   import flash.display.BitmapData;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   
   public class Character extends Sprite implements ICharacter
   {
      
      private static var sHelperPoint:Point = new Point();
      
      private static var hitHelperPoint:Point = new Point();
      
      public var shootSignal:Signal;
      
      public var characterCtrl:CharacterCtrl;
      
      public var armature:Armature;
      
      private var armatureClip:Sprite;
      
      public var bitmapModel:BitmapData;
      
      private var _bitmapRectangle:Rectangle;
      
      private var hat:Bone;
      
      private var clothes:Bone;
      
      private var leftwing:Bone;
      
      private var rightwing:Bone;
      
      private var leftshoe:Bone;
      
      private var rightshoe:Bone;
      
      private var leftglove:Bone;
      
      private var rightglove:Bone;
      
      private var stone:Bone;
      
      private var pf:Bone;
      
      private var animationStart:Boolean = false;
      
      private var _angle:Number = 15;
      
      private var _velocity:Number = 0;
      
      private var _firingPoint:Point;
      
      private var _goodsList:Array;
      
      private var dieImage:Image;
      
      private var tombstone:Image;
      
      public var charWidth:int;
      
      public var charHeight:int;
      
      public var sex:int;
      
      public var wqGoods:GoodsData;
      
      protected var _badState:String = "";
      
      private var _assets:ResAssetManager;
      
      public function Character(param1:Armature)
      {
         super();
         this.armature = param1;
         param1.display.width /= Assets.sAsset.scaleFactor;
         param1.display.height /= Assets.sAsset.scaleFactor;
         armatureClip = param1.display as Sprite;
         hat = param1.getBone("hat");
         clothes = param1.getBone("clothes");
         leftwing = param1.getBone("wing").childArmature.getBone("leftwing");
         rightwing = param1.getBone("wing").childArmature.getBone("rightwing");
         leftshoe = param1.getBone("leftshoe");
         rightshoe = param1.getBone("rightshoe");
         leftglove = param1.getBone("leftglove");
         rightglove = param1.getBone("rightglove");
         stone = param1.getBone("stone");
         pf = param1.getBone("pfeng");
         shootSignal = new Signal();
         bitmapModel = new BitmapData(20,70,true,4294967295);
         _bitmapRectangle = new Rectangle(0,0,40,70);
         dieImage = new Image(Assets.sAsset.getTexture("die"));
         dieImage.pivotX = dieImage.width >> 1;
         dieImage.pivotY = dieImage.height;
         dieImage.scaleX = dieImage.scaleY = 2.5;
         tombstone = new Image(Assets.sAsset.getTexture("tombstone"));
         tombstone.pivotX = tombstone.width >> 1;
         tombstone.pivotY = tombstone.height;
         tombstone.scaleX = tombstone.scaleY = 2.5;
         _assets = Assets.sAsset;
      }
      
      private function allClothesclean() : void
      {
         showBone([hat,clothes,leftshoe,rightshoe,leftwing,rightwing,leftglove,rightglove,pf],false);
      }
      
      private function showBone(param1:Array, param2:Boolean = true) : void
      {
         for each(var _loc3_ in param1)
         {
            _loc3_.visible = param2;
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
      }
      
      public function initData(param1:Array) : void
      {
         allClothesclean();
         _goodsList = param1;
         pf.display.visible = false;
         wearAll([["Helm"],["Clothes"],["wing"],["Shoes"],["Glove"]]);
         for each(var _loc2_ in param1)
         {
            if(_loc2_.isWeapon)
            {
               wqGoods = _loc2_;
            }
            else
            {
               this.wearById(_loc2_.typeID,_loc2_.frameID);
            }
         }
         init();
      }
      
      private function changeWeaponShow() : void
      {
         var _loc1_:int = 0;
         if(stone)
         {
            _loc1_ = wqGoods.frameID / 10;
            stone.display.dispose();
            stone.display = _assets.getTextureDisplay("part/weapon_" + wqGoods.typeID + "_" + _loc1_) as Image;
            return;
         }
      }
      
      public function init() : void
      {
         standAnimation();
         if(this.getChildIndex(armatureClip) == -1)
         {
            addChild(armatureClip);
            WorldClock.clock.add(armature);
         }
      }
      
      public function get bitmapRectangle() : Rectangle
      {
         this._bitmapRectangle.x = this.x;
         this._bitmapRectangle.y = this.y;
         return _bitmapRectangle;
      }
      
      public function get centerY() : Number
      {
         return this.y - this.height / 2;
      }
      
      public function get firingPoint() : Point
      {
         if(!this._firingPoint)
         {
            throw new Error("没有设置发射点，不能获取");
         }
         return _firingPoint;
      }
      
      public function setFiringPoint() : void
      {
         if(this._firingPoint)
         {
            this._firingPoint.x = this.x;
            this._firingPoint.y = this.centerY;
         }
         else
         {
            this._firingPoint = new Point(this.x,this.centerY);
         }
      }
      
      public function set angle(param1:Number) : void
      {
         this._angle = param1;
      }
      
      public function get angle() : Number
      {
         return this._angle;
      }
      
      public function set velocity(param1:Number) : void
      {
         this._velocity = param1;
      }
      
      public function get velocity() : Number
      {
         return this._velocity;
      }
      
      private function onEnterFrameHandler(param1:EnterFrameEvent) : void
      {
      }
      
      public function runAnimation() : void
      {
         armature.animation.gotoAndPlay("run");
         startAnimation();
      }
      
      public function hitMap(param1:int, param2:int, param3:BtMap) : Boolean
      {
         sHelperPoint.setTo(0,0);
         hitHelperPoint.setTo(param1 - bitmapModel.width / 2,param2 - bitmapModel.height - 10);
         return param3.bitmapData.hitTest(sHelperPoint,255,bitmapModel,hitHelperPoint,255);
      }
      
      public function reverse(param1:int) : void
      {
         this.scaleX = param1 * Math.abs(this.scaleX);
      }
      
      public function standAnimation() : void
      {
         armature.animation.gotoAndPlay("stand");
         if(SoundManager.actChannel)
         {
            SoundManager.actChannel.stop();
         }
         startAnimation();
      }
      
      public function stoneAnimation() : void
      {
         trace("投射动画...");
         armature.animation.gotoAndPlay("shot2");
         armature.addEventListener("complete",onShoot);
         startAnimation();
      }
      
      public function gunAnimation() : void
      {
         trace("开炮动画...");
         armature.animation.gotoAndPlay("shot");
         armature.addEventListener("complete",onShoot);
         startAnimation();
      }
      
      public function cryAnimation() : void
      {
         SoundManager.playSound("sound 18");
         armature.animation.gotoAndPlay("cry");
         startAnimation();
      }
      
      public function dieAnimation() : void
      {
         removeChild(armatureClip);
         removeEventListener("enterFrame",onEnterFrameHandler);
         addChild(tombstone);
         addChild(dieImage);
         SoundManager.playSound("sound 19");
         Starling.juggler.tween(dieImage,3,{
            "alpha":0,
            "y":dieImage.y - 800,
            "onComplete":function():void
            {
               dieImage.removeFromParent();
            }
         });
         Starling.juggler.tween(tombstone,1,{
            "delay":3,
            "alpha":0,
            "onComplete":function():void
            {
               tombstone.removeFromParent();
            }
         });
      }
      
      private function onShoot(param1:AnimationEvent) : void
      {
         armature.removeEventListener("complete",onShoot);
         shootSignal.dispatch();
         standAnimation();
      }
      
      public function stopAnimation() : void
      {
         if(animationStart)
         {
            removeEventListener("enterFrame",onEnterFrameHandler);
            animationStart = false;
         }
      }
      
      public function wearAll(param1:Array) : void
      {
         for each(var _loc2_ in param1)
         {
            if(_loc2_.length == 3)
            {
               wear(_loc2_[0],_loc2_[1],_loc2_[2]);
            }
            else
            {
               if(_loc2_.length != 1)
               {
                  throw new Error("参数错误");
               }
               wear(_loc2_[0]);
            }
         }
      }
      
      public function wear(param1:String, param2:uint = 0, param3:uint = 0) : void
      {
         var _loc6_:* = null;
         var _loc4_:Array = ["Helm","Glove","Clothes","Shoes","wing"];
         if(_loc4_.indexOf(param1) == -1)
         {
            Application.instance.log("Character\'s wear","请添加相应的部位道具信息：" + param1);
            return;
         }
         param3 /= 10;
         var _loc5_:String = textureToBone(param1);
         if(param1.length == 0)
         {
            return;
         }
         _loc6_ = param1;
         if(param1 == "Shoes")
         {
            this.leftshoe.display && this.leftshoe.display.dispose();
            this.rightshoe.display && this.rightshoe.display.dispose();
            if(param2 == 0 || param3 == 0)
            {
               this.leftshoe.display = new Image(Assets.emptyTexture());
               this.rightshoe.display = new Image(Assets.emptyTexture());
            }
            else
            {
               this.leftshoe.display = _assets.getTextureDisplay("part/Shoes_" + param2 + "_" + param3) as Image;
               this.rightshoe.display = _assets.getTextureDisplay("part/Shoes_" + param2 + "_" + param3) as Image;
               showBone([leftshoe,rightshoe]);
            }
         }
         else if(param1 == "Glove")
         {
            this.leftglove.display && this.leftglove.display.dispose();
            this.rightglove.display && this.rightglove.display.dispose();
            if(param2 == 0 || param3 == 0)
            {
               this.leftglove.display = new Image(Assets.emptyTexture());
               this.rightglove.display = new Image(Assets.emptyTexture());
            }
            else
            {
               this.leftglove.display = _assets.getTextureDisplay("part/Glove_" + param2 + "_" + param3) as Image;
               this.rightglove.display = _assets.getTextureDisplay("part/Glove_Sec_" + param2 + "_" + param3) as Image;
               showBone([leftglove,rightglove]);
            }
         }
         else if(param1 == "wing")
         {
            this.leftwing.display && this.leftwing.display.dispose();
            this.rightwing.display && this.rightwing.display.dispose();
            if(param2 == 8 && (param3 == 101 || param3 == 102))
            {
               this.leftwing.display = new Image(Assets.emptyTexture());
               this.rightwing.display = new Image(Assets.emptyTexture());
               showBone([leftwing,rightwing],false);
               showBone([pf]);
               return;
            }
            if(param2 == 0 || param3 == 0)
            {
               this.leftwing.display = new Image(Assets.emptyTexture());
               this.rightwing.display = new Image(Assets.emptyTexture());
            }
            else
            {
               this.leftwing.display = _assets.getTextureDisplay("part/" + param1 + "_" + param2 + "_" + param3) as Image;
               this.rightwing.display = _assets.getTextureDisplay("part/" + param1 + "_" + param2 + "_" + param3) as Image;
               showBone([leftwing,rightwing]);
               showBone([pf],false);
            }
         }
         else
         {
            this[_loc5_].display && this[_loc5_].display.dispose();
            if(param2 == 0 || param3 == 0)
            {
               this[_loc5_].display = new Image(Assets.emptyTexture());
            }
            else
            {
               this[_loc5_].display = _assets.getTextureDisplay("part/" + param1 + "_" + param2 + "_" + param3) as Image;
               showBone([this[_loc5_]]);
            }
         }
      }
      
      public function wearById(param1:uint = 0, param2:uint = 0) : void
      {
         if(param1 == 8)
         {
            pf.display.visible = param2 == 1011 || param2 == 1021 ? true : false;
         }
         wear(getNameById(param1),param1,param2);
      }
      
      private function getNameById(param1:uint = 0) : String
      {
         return Constants.getGoodsNameById(param1);
      }
      
      private function textureToBone(param1:String) : String
      {
         var _loc2_:Dictionary = null;
         _loc2_ = new Dictionary();
         _loc2_["Helm"] = "hat";
         _loc2_["Clothes"] = "clothes";
         _loc2_["Shoes"] = "shoe";
         _loc2_["wing"] = "wing";
         return _loc2_[param1];
      }
      
      protected function startAnimation() : void
      {
         if(!animationStart)
         {
            addEventListener("enterFrame",onEnterFrameHandler);
            animationStart = true;
         }
      }
      
      override public function dispose() : void
      {
         stopAnimation();
         WorldClock.clock.remove(armature);
         armature.dispose();
         super.dispose();
      }
      
      public function avatar() : Character
      {
         var _loc1_:Character = CharacterFactory.instance.checkOutCharacter(sex);
         _loc1_.initData(_goodsList);
         _loc1_.armature.removeBone(_loc1_.armature.getBone("body"));
         _loc1_.armature.removeBone(_loc1_.armature.getBone("shadow"));
         _loc1_.armature.removeBone(_loc1_.armature.getBone("stone"));
         _loc1_.armature.animation.gotoAndPlay("stop");
         _loc1_.scaleX = _loc1_.scaleY = 0.3;
         return _loc1_;
      }
      
      public function get canHit() : Boolean
      {
         return true;
      }
      
      public function get icharacterCtrl() : ICharacterCtrl
      {
         return characterCtrl as ICharacterCtrl;
      }
      
      override public function get x() : Number
      {
         return super.x;
      }
      
      override public function get y() : Number
      {
         return super.y;
      }
      
      public function get badState() : String
      {
         return _badState;
      }
      
      public function set badState(param1:String) : void
      {
         _badState = param1;
      }
   }
}

