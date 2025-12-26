package com.boyaa.antwars.view.screen.battlefield.element.bullet
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.game.GameWorld;
   import com.boyaa.antwars.view.game.ICharacter;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.monster.IMonsterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.BtMap;
   import com.boyaa.antwars.view.screen.battlefield.element.RobotCharacterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.element.RobotShowCtrl;
   import com.boyaa.antwars.view.screen.battlefield.element.SelfCharacterCtrl;
   import com.boyaa.antwars.view.screen.copygame.game.CopyGameRobotCtrl;
   import com.boyaa.tool.Draw;
   import feathers.controls.Screen;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import org.osflash.signals.Signal;
   import starling.animation.IAnimatable;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.extensions.PDParticleSystem;
   import starling.utils.MatrixUtil;
   
   public class Bullet extends Sprite implements IAnimatable
   {
      
      public static var type:String = "";
      
      private static const _screen:Array = ["BATTLEFIELD","ROBOT_2VS2_BATTLEFIELD"];
      
      protected static var pointHelper:Point = new Point();
      
      protected static var pointHelper2:Point = new Point();
      
      private var _id:int = 0;
      
      protected var _start:Boolean = false;
      
      public var blowoutCompleteSignal:Signal;
      
      public var slottingCompleteSignal:Signal;
      
      protected var bulletDisplay:DisplayObject;
      
      protected var _size:int = 14;
      
      protected var _scale:Number = 0.2;
      
      protected var bombRange:int = 140;
      
      protected var blowoutAnimation:MovieClip;
      
      protected var characterctrl:ICharacterCtrl;
      
      protected var vy:Number;
      
      protected var vx:Number;
      
      protected var bitmapModel:BitmapData;
      
      protected var holeBitmapModel:BitmapData;
      
      protected var hole:Image;
      
      protected var brink:Image;
      
      private var hitCharacterVectorHelper:Vector.<ICharacter>;
      
      private var startX:Number;
      
      protected var tanAngle:Number;
      
      protected var dK:Number;
      
      protected var slopeAngle:Number;
      
      protected var firingPoint:Point;
      
      protected var showBulletR:Number;
      
      protected var hitArr:Array = [];
      
      protected var particleCoffee:PDParticleSystem;
      
      protected var refraction:int = 1;
      
      protected var _maxSpeed:int = 46;
      
      public function Bullet(param1:ICharacterCtrl, param2:int = 0)
      {
         super();
         blowoutCompleteSignal = new Signal();
         slottingCompleteSignal = new Signal(Array);
         this.characterctrl = param1;
         hitCharacterVectorHelper = new Vector.<ICharacter>();
         this.addEventListener("addedToStage",onAddedToStage);
         if(param1 is IMonsterCtrl)
         {
            id = Screen(Application.instance.currentGame.navigator.activeScreen).numChildren - 1;
         }
         else
         {
            trace("手动设置子弹ID");
         }
      }
      
      public function init(param1:Point, param2:Number, param3:Number, param4:Number = 0) : void
      {
         if(param3 <= 0 || isNaN(param3))
         {
            trace("速度有问题:" + param3);
            param3 = 10;
         }
         if(isNaN(param2))
         {
            trace("角度有问题");
            param2 = 0;
         }
         this.firingPoint = param1;
         this.showBulletR = param4;
         this.x = param1.x;
         this.y = param1.y;
         var _loc6_:Number = param2 * 3.141592653589793 / 180;
         var _loc5_:Number = Math.cos(_loc6_);
         vy = param3 * Math.sin(_loc6_);
         vx = param3 * _loc5_;
         _maxSpeed = param3;
         tanAngle = Math.tan(_loc6_);
         dK = 1.2 / (param3 * param3 * _loc5_ * _loc5_);
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         if(!bulletDisplay)
         {
            bulletDisplay = new Image(Assets.sAsset.getTextureAtlas("wqSpritesheet").getTexture("grenade"));
         }
         addChild(bulletDisplay);
         this.pivotX = this.width >> 1;
         this.pivotY = this.height >> 1;
         this.scaleX = this.scaleY = _scale;
         _initBlowoutAnimation();
         initCrater();
      }
      
      public function setParticle(param1:PDParticleSystem = null) : void
      {
         if(!param1)
         {
            this.particleCoffee = ParticleAssets.checkOut();
         }
         else
         {
            this.particleCoffee = param1;
         }
      }
      
      public function setHitModel(param1:BitmapData = null) : void
      {
         var _loc2_:Shape = null;
         if(!param1)
         {
            this.bitmapModel = new BitmapData(size,size,true,0);
            _loc2_ = Draw.doDrawCircle(bitmapModel.width / 2,16711680) as Shape;
            this.bitmapModel.draw(_loc2_,new Matrix(1,0,0,1,bitmapModel.width / 2,bitmapModel.height / 2));
         }
         else
         {
            this.bitmapModel = param1;
         }
      }
      
      protected function set size(param1:int) : void
      {
         _size = param1;
         _scale = Math.min(param1 / bulletDisplay.width,param1 / bulletDisplay.height);
      }
      
      protected function get size() : int
      {
         return _size;
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function set id(param1:int) : void
      {
         _id = param1;
         trace("当前子弹ID：",id);
      }
      
      protected function initBlowoutAnimation() : void
      {
      }
      
      protected function initCrater() : void
      {
      }
      
      protected function _initBlowoutAnimation() : void
      {
         initBlowoutAnimation();
         if(!blowoutAnimation)
         {
            throw new Error("请初始话爆炸动画");
         }
         blowoutAnimation.addEventListener("complete",blowoutAnimationCompleteHandle);
      }
      
      private function blowoutAnimationCompleteHandle(param1:Event = null) : void
      {
         blowoutAnimation.removeEventListener("complete",blowoutAnimationCompleteHandle);
         Starling.juggler.remove(blowoutAnimation);
         disposeBullet();
      }
      
      private function disposeBullet(param1:int = 1) : void
      {
         var time:int = param1;
         this.characterctrl = null;
         trace("disposeBullet removeFromParent");
         this.removeFromParent();
         bitmapModel.dispose();
         holeBitmapModel = null;
         blowoutCompleteSignal.dispatch();
         blowoutCompleteSignal.removeAll();
         slottingCompleteSignal.removeAll();
         blowoutCompleteSignal = null;
         slottingCompleteSignal = null;
         Starling.juggler.delayCall(function():void
         {
            disposeParticle();
         },time);
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:BtMap = null;
         try
         {
            if(!characterctrl.gameworld)
            {
               return;
            }
            if(!_start)
            {
               return;
            }
            _loc2_ = this.scaleX > 0 ? 1 : -1;
            if(Math.abs(this.scaleX) <= _scale)
            {
               this.scaleX = this.scaleY = _loc2_ * Math.abs(this.scaleY) + 0.05;
            }
            this.x += vx;
            this.y -= vy;
            vy -= 1.2;
            if(particleCoffee)
            {
               particleCoffee.emitterX = this.x;
               particleCoffee.emitterY = this.y;
            }
            slopeAngle = Math.atan((this.x - startX) * dK - tanAngle);
            if(vx <= 0)
            {
               slopeAngle += 3.141592653589793;
            }
            pointHelper.setTo(this.x,this.y);
            if(!this.visible && MathHelper.check_circleAndPoint(firingPoint,showBulletR,pointHelper))
            {
               return;
            }
            this.visible = true;
            _loc3_ = characterctrl.gameworld.getMap();
            if(myHitTest() || hitMap() || hitEnergyLight())
            {
               shockCharaters();
               stop();
               slottingEvent();
            }
            else if(this.x < 0 || this.x > this.characterctrl.gameworld.getMap().mapWidth || this.y > this.characterctrl.gameworld.getMap().mapHeight)
            {
               stop();
               BulletSlottingManager.instance.getBulletData(id,characterctrl.siteID);
               slottingCompleteSignal.dispatch([2,this.x,this.y,id,[]]);
               this.disposeBullet();
            }
         }
         catch(err:Error)
         {
            Remoting.instance.gameLog(err.message + "|" + err.getStackTrace());
            throw new Error(err.message);
         }
      }
      
      private function slottingEvent() : void
      {
         var _loc1_:Array = null;
         Application.instance.log("TAG-slottingEvent","site:" + characterctrl.siteID);
         if(characterctrl.siteID != PlayerDataList.instance.selfData.siteID)
         {
            if(_screen.indexOf(Application.instance.currentGame.navigator.activeScreenID) != -1)
            {
               if(!(characterctrl is RobotShowCtrl))
               {
                  _loc1_ = BulletSlottingManager.instance.getBulletData(id,characterctrl.siteID);
                  if(_loc1_)
                  {
                     this.x = _loc1_[0];
                     this.y = _loc1_[1];
                  }
               }
            }
         }
         slotting();
         playBlowoutAnimation();
      }
      
      private function setRefractionBullet() : void
      {
         var _loc5_:int = Math.atan2(vy,vx) * 180 / 3.141592653589793;
         _maxSpeed = Math.sqrt(vx * vx + vy * vy) * 1.5;
         var _loc2_:int = Math.atan2(pointHelper.y - 870,pointHelper.x - 740) * 180 / 3.141592653589793 + 90;
         var _loc1_:int = _loc5_ - _loc2_;
         bulletDisplay.rotation = _loc5_ - 2 * _loc1_;
         vy = _maxSpeed * Math.sin(bulletDisplay.rotation * 3.141592653589793 / 180);
         vx = _maxSpeed * Math.cos(bulletDisplay.rotation * 3.141592653589793 / 180);
         if(this.refraction == 1)
         {
            this.refraction *= 2;
         }
         var _loc3_:Number = Math.max(Math.abs(vy),Math.abs(vx));
         var _loc4_:int = Math.ceil(_loc3_ / size);
         while(hitEnergyLight())
         {
            pointHelper.y += 1 / _loc4_ * vy;
            pointHelper.x += 1 / _loc4_ * vx;
            this.x = pointHelper.x;
            this.y = pointHelper.y;
         }
      }
      
      protected function isHitObject(param1:*) : Boolean
      {
         return param1 is ICharacter && (param1 as ICharacter).icharacterCtrl.hp > 0;
      }
      
      protected function myHitTest() : Boolean
      {
         var _loc9_:int = 0;
         var _loc1_:DisplayObject = null;
         var _loc5_:DisplayObject = null;
         var _loc3_:ICharacter = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc6_:int = 0;
         var _loc4_:Boolean = false;
         var _loc2_:Sprite = characterctrl.gameworld.charatersLayer;
         hitCharacterVectorHelper.length = 0;
         _loc9_ = _loc2_.numChildren - 1;
         while(_loc9_ >= 0)
         {
            _loc1_ = _loc2_.getChildAt(_loc9_);
            _loc5_ = _loc1_.hitTest(MatrixUtil.transformCoords(_loc2_.getTransformationMatrix(_loc1_),this.x,this.y));
            if(_loc5_ && _loc5_.parent && isHitObject(_loc5_.parent.parent))
            {
               _loc3_ = _loc5_.parent.parent as ICharacter;
               if(_loc3_.canHit)
               {
                  hitCharacterVectorHelper.push(_loc3_);
                  trace(_loc3_.icharacterCtrl.siteID,":被打中");
                  SoundManager.playSound("sound 15");
                  recodeHitArr(_loc3_.icharacterCtrl,0,0);
                  _loc3_.icharacterCtrl.playCry();
                  _loc4_ = true;
               }
            }
            _loc9_--;
         }
         if(_loc4_)
         {
            _loc7_ = 0;
            _loc8_ = 0;
            _loc6_ = 0;
            while(_loc6_ < hitCharacterVectorHelper.length)
            {
               _loc7_ += hitCharacterVectorHelper[_loc6_].x;
               2;
               _loc8_ += hitCharacterVectorHelper[_loc6_].y - 30;
               2;
               _loc6_++;
            }
            this.x = _loc7_ / hitCharacterVectorHelper.length;
            this.y = _loc8_ / hitCharacterVectorHelper.length;
         }
         return _loc4_;
      }
      
      protected function shockCharaters() : void
      {
         var _loc3_:int = 0;
         var _loc2_:ICharacter = null;
         var _loc1_:Sprite = characterctrl.gameworld.charatersLayer;
         _loc3_ = _loc1_.numChildren - 1;
         while(_loc3_ >= 0)
         {
            _loc2_ = _loc1_.getChildAt(_loc3_) as ICharacter;
            if(_loc2_.canHit)
            {
               if(hitCharacterVectorHelper.indexOf(_loc2_) == -1 && isHitObject(_loc2_))
               {
                  pointHelper.setTo(this.x,this.y);
                  if(MathHelper.check_circleAndRectangle(pointHelper,bombRange >> 1,_loc2_.bitmapRectangle))
                  {
                     _loc2_.icharacterCtrl.playCry();
                     trace(_loc2_.icharacterCtrl.siteID,":被震慑");
                     recodeHitArr(_loc2_.icharacterCtrl,1,0);
                  }
               }
            }
            _loc3_--;
         }
      }
      
      protected function hitEnergyLight() : Boolean
      {
         if(GameWorld.energyLight != null)
         {
            pointHelper.setTo(0,0);
            pointHelper2.setTo(this.x - bitmapModel.width / 2,this.y - bitmapModel.height / 2);
            if(GameWorld.energyLight.hitTest(pointHelper,255,bitmapModel,pointHelper2,255))
            {
               pointHelper.setTo(this.x,this.y);
               return true;
            }
         }
         return false;
      }
      
      protected function hitMap() : Boolean
      {
         var _loc1_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:BtMap = characterctrl.gameworld.getMap();
         pointHelper.setTo(0,0);
         pointHelper2.setTo(this.x - bitmapModel.width / 2,this.y - bitmapModel.height / 2);
         if(_loc2_.bitmapData.hitTest(pointHelper,255,bitmapModel,pointHelper2,255))
         {
            _loc1_ = vy + 1.2;
            _loc3_ = _loc1_ > 0 ? 1 : -1;
            _loc1_ = Math.abs(_loc1_);
            pointHelper.setTo(this.x,this.y);
            _loc4_ = 0;
            while(_loc4_ < _loc1_)
            {
               this.y += _loc3_;
               pointHelper.setTo(this.x,this.y);
               if(!_loc2_.hitPoint(pointHelper))
               {
                  break;
               }
               _loc4_++;
            }
            this.y -= _loc3_;
            return true;
         }
         return false;
      }
      
      public function start() : void
      {
         _start = true;
         Starling.juggler.add(this);
         if(particleCoffee)
         {
            Starling.juggler.add(particleCoffee);
            particleCoffee.start();
            characterctrl.gameworld.getGameLayer().addChild(particleCoffee);
         }
         startX = this.x;
         this.visible = false;
      }
      
      public function stop() : void
      {
         _start = false;
         Starling.juggler.remove(this);
         if(particleCoffee)
         {
            particleCoffee.pause();
         }
      }
      
      private function disposeParticle() : void
      {
         if(particleCoffee)
         {
            Starling.juggler.remove(particleCoffee);
            particleCoffee.removeFromParent();
            ParticleAssets.checkIn(particleCoffee);
            particleCoffee = null;
         }
      }
      
      protected function recodeHitArr(param1:ICharacterCtrl, param2:int, param3:int = 0, param4:int = 0, param5:int = 0) : void
      {
         if(characterctrl is SelfCharacterCtrl || characterctrl is RobotCharacterCtrl || characterctrl is RobotShowCtrl || characterctrl is CopyGameRobotCtrl)
         {
            hitArr.push([param1.siteID,param2,param3,param4,param5,param1.icharacter.x,param1.icharacter.y,characterctrl.siteID]);
         }
      }
      
      protected function playBlowoutAnimation() : void
      {
         Application.instance.log("playBlowoutAnimation","子弹ID：" + id);
         if(Bullet.type != "PlaneBullet")
         {
            SoundManager.playSound("sound 16");
         }
         this.rotation = 0;
         this.scaleX = this.scaleY = _scale;
         this.bulletDisplay.removeFromParent(true);
         blowoutAnimation.loop = false;
         addChild(blowoutAnimation);
         Starling.juggler.add(blowoutAnimation);
         blowoutAnimation.play();
      }
      
      protected function slotting() : void
      {
         pointHelper.setTo(this.x,this.y);
         this.characterctrl.gameworld.getMap().slotting(hole,holeBitmapModel,brink,int(bombRange / 2),pointHelper);
         slottingCompleteSignal.dispatch([1,this.x,this.y,id,hitArr]);
      }
      
      override public function dispose() : void
      {
         stop();
         disposeParticle();
         Starling.juggler.remove(blowoutAnimation);
         super.dispose();
      }
   }
}

