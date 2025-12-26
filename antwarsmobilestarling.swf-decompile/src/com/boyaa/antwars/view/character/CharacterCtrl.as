package com.boyaa.antwars.view.character
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.display.MovieClipTimes;
   import com.boyaa.antwars.view.game.ICharacter;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.game.IGameWorld;
   import com.boyaa.antwars.view.screen.battlefield.BtMap;
   import com.boyaa.antwars.view.screen.battlefield.element.AngerMovieClip;
   import com.boyaa.antwars.view.screen.battlefield.element.HpBar;
   import com.boyaa.antwars.view.screen.battlefield.element.SkillBox;
   import com.boyaa.antwars.view.screen.battlefield.element.bullet.*;
   import com.boyaa.antwars.view.screen.copygame.game.CopyGameRobotCtrl;
   import com.boyaa.antwars.view.vipSystem.VipLevelIcon;
   import com.boyaa.debug.Logging.LevelLogger;
   import com.greensock.TweenLite;
   import flash.geom.Point;
   import org.osflash.signals.Signal;
   import starling.animation.IAnimatable;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.textures.Texture;
   
   public class CharacterCtrl implements IAnimatable, ICharacterCtrl
   {
      
      public static var MOVE:String = "MOVE";
      
      public static var TARGET:String = "TARGET";
      
      public static var DOWN:String = "DOWN";
      
      public static var SHOOT:String = "SHOOT";
      
      public static var CRY:String = "CRY";
      
      private static var MOVE_V:Number = 100;
      
      private static var sHelperPoint:Point = new Point();
      
      protected var status:String = DOWN;
      
      public var character:Character;
      
      private var _battlefield:IGameWorld;
      
      protected var _hurtfactor:int = 1000;
      
      protected var _hurtplus:int = 1000;
      
      protected var _isUseAnger:Boolean = false;
      
      private var typeId:int = 0;
      
      protected var _siteID:int;
      
      private var _hp:int;
      
      protected var hpBar:HpBar;
      
      public var bulletType:String = "0";
      
      public var roleName:TextField;
      
      private var propSprite:Sprite;
      
      private var usePropMC:MovieClipTimes;
      
      private var coreMC:MovieClip;
      
      private var usePropTime:int = 0;
      
      public var isCtrl:Boolean = false;
      
      public var actionCompeleteSignal:Signal;
      
      public var ctrlCompeleteSignal:Signal;
      
      public var slottingCompleteSignal:Signal;
      
      public var dieSignal:Signal;
      
      public var downOkSignal:Signal;
      
      protected var _direction:Boolean = true;
      
      private var _isDie:Boolean = false;
      
      protected var _downStart:Boolean = false;
      
      protected var bulletClass:String;
      
      protected var _maxHp:int = 0;
      
      protected var _canMove:Boolean = true;
      
      protected var _canControlAngel:Boolean = true;
      
      protected var _canUseProp:Boolean = true;
      
      protected var _vipIcon:VipLevelIcon = new VipLevelIcon();
      
      protected var _angleText:TextField;
      
      protected var _isUsePlane:Boolean = false;
      
      private var _isCry:Boolean = false;
      
      private var angerMovieClip:AngerMovieClip;
      
      private var bulletTimes:int = 1;
      
      private var bulletCount:int = 1;
      
      private var planeLandPoint:Point = new Point(0,0);
      
      private var _lastBulletNum:int = 1;
      
      private var _countSlotting:int = 0;
      
      private var _tmpChangeVisualPoint:Point = new Point();
      
      protected var _roleAttr:Array = null;
      
      private var showBad:ShowBadState = new ShowBadState(ICharacterCtrl(this));
      
      public function CharacterCtrl(param1:IGameWorld, param2:Character, param3:int, param4:int, param5:String = "leoluo")
      {
         super();
         this.character = param2;
         this._siteID = param3;
         _maxHp = param4;
         this._hp = param4;
         this.battlefield = param1;
         param2.shootSignal.add(onShoot);
         actionCompeleteSignal = new Signal(int);
         slottingCompleteSignal = new Signal(int,Array);
         ctrlCompeleteSignal = new Signal(int);
         dieSignal = new Signal(int,String);
         downOkSignal = new Signal();
         param2.characterCtrl = this;
         hpBar = new HpBar(Assets.sAsset.getTexture("dz50"),108487,param4);
         this.battlefield.ctrlInfoLayer.addChild(hpBar);
         hpBar.scaleY = hpBar.scaleX = 0.8;
         roleName = new TextField(hpBar.width,hpBar.height * 4,param5,"Verdana",18,16777215,true);
         roleName.autoScale = true;
         this.battlefield.ctrlInfoLayer.addChild(roleName);
         _isDie = false;
         Starling.juggler.add(this);
         usePropMC = new MovieClipTimes(Assets.sAsset.getTextures("jntx000"),20);
         Starling.juggler.add(usePropMC);
         usePropMC.pivotX = 122;
         usePropMC.pivotY = 155;
         usePropMC.scaleX = usePropMC.scaleY = 1.6;
         usePropMC.playCompleteSignal.add(onUsePropMCPlayEnd);
         propSprite = new Sprite();
         this.battlefield.charatersBGLayer.addChild(propSprite);
         coreMC = new MovieClip(Assets.sAsset.getTextures("glow00"),10);
         coreMC.loop = true;
         coreMC.stop();
         coreMC.addEventListener("complete",onCoreMCComplete);
         coreMC.pivotX = coreMC.width >> 1;
         coreMC.pivotY = coreMC.height - 50;
         Starling.juggler.add(coreMC);
         _angleText = new TextField(100,100,"","Verdana",15,16777215,false);
         this.battlefield.ctrlInfoLayer.addChild(_angleText);
         _angleText.visible = false;
         GameServer.instance.onSomeOneVipLevel(onVipLevel,false);
         if(!this is CopyGameRobotCtrl)
         {
            GameServer.instance.getSomeOneVipLevel(PlayerDataList.instance.getDataBySiteID(param3).uid);
         }
      }
      
      private function onVipLevel(param1:Object) : void
      {
         var _loc2_:PlayerData = PlayerDataList.instance.getDataByUID(param1.who);
         if(_loc2_.siteID == siteID)
         {
            showVipIcon(param1.level);
         }
      }
      
      public function showVipIcon(param1:int) : void
      {
         _vipIcon.level = param1;
         battlefield.ctrlInfoLayer.addChild(_vipIcon);
         PlayerDataList.instance.getDataBySiteID(siteID).vipLevel = param1;
      }
      
      public function ctrlStart(param1:Boolean) : void
      {
         if(_isDie || !this.character)
         {
            return;
         }
         isCtrl = param1;
         LevelLogger.getLogger("CharacterCtrl").info(" - ctrlStrat: " + isCtrl.toString());
         if(this.status == MOVE)
         {
            this.character.standAnimation();
         }
         if(isCtrl)
         {
            usePropTime = 0;
            bulletTimes = 1;
            bulletCount = 1;
            _isUseAnger = false;
            _hurtfactor = 1000;
            _hurtplus = 1000;
            _isUsePlane = false;
            isWeaponChange();
         }
         propSprite.removeChildren();
      }
      
      protected function changeWeaponAni() : void
      {
         var complete:* = function():void
         {
            image.removeFromParent(true);
         };
         var image:Image = Assets.sAsset.getGoodsImage(character.wqGoods.typeID,character.wqGoods.frameID);
         var pt:Point = character.parent.localToGlobal(new Point(character.x,character.y));
         image.x = pt.x;
         image.y = pt.y - 100;
         image.width = 100;
         image.scaleY = image.scaleX;
         Application.instance.currentGame.stage.addChild(image);
         TweenLite.to(image,1.5,{
            "alpha":0,
            "y":image.y - 100,
            "onComplete":complete
         });
      }
      
      public function changeWeapon(param1:GoodsData) : void
      {
         character.wqGoods = param1;
         isWeaponChange();
         if(_isUsePlane)
         {
            changeBullet("PlaneBullet");
         }
         changeWeaponAni();
      }
      
      protected function isWeaponChange() : void
      {
         var _loc1_:int = 0;
         if(character.wqGoods)
         {
            _loc1_ = character.wqGoods.frameID / 10;
            switch(_loc1_ - 101)
            {
               case 0:
                  typeId = 1;
                  changeBullet("WatermelonBullet");
                  break;
               case 1:
                  typeId = 1;
                  changeBullet("PineappleBullet");
                  break;
               case 2:
                  typeId = 1;
                  changeBullet("GrenadeBullet");
                  break;
               case 3:
                  typeId = 1;
                  changeBullet("MissileBullet");
                  break;
               case 4:
                  typeId = 0;
                  changeBullet("WatermelonBullet");
                  break;
               case 5:
                  typeId = 0;
                  changeBullet("PineappleBullet");
                  break;
               case 6:
                  typeId = 0;
                  changeBullet("GrenadeBullet");
                  break;
               case 7:
                  typeId = 0;
                  changeBullet("MissileBullet");
                  break;
               case 8:
                  typeId = 0;
                  changeBullet("MalletBullet");
                  break;
               case 9:
                  typeId = 0;
                  changeBullet("SnowballBullet");
                  break;
               case 10:
                  typeId = 1;
                  changeBullet("BowBullet");
                  break;
               default:
                  if(Constants.debug)
                  {
                     throw new Error("没有武器资源 " + character.wqGoods.typeID + ":" + character.wqGoods.frameID);
                  }
                  changeBullet("MalletBullet");
            }
         }
         else
         {
            changeBullet("MalletBullet");
         }
         if(siteID == PlayerDataList.instance.selfData.siteID)
         {
            Application.instance.log("changeMyBullet",_loc1_.toString());
         }
      }
      
      public function downStart() : void
      {
         downStatus = true;
      }
      
      public function set hp(param1:int) : void
      {
         _hp = param1;
         if(_hp > _maxHp)
         {
            _hp = _maxHp;
         }
         hpBar.hp = _hp;
         if(_hp <= 0)
         {
            _isDie = true;
            this.character.dieAnimation();
            dieSignal.dispatch(siteID,"hp");
            hpBar.removeFromParent(false);
            roleName.removeFromParent(false);
            _vipIcon.removeFromParent(false);
            _angleText.removeFromParent(false);
            ctrlStart(false);
            setBadState();
         }
         else
         {
            _isDie = false;
            this.battlefield.ctrlInfoLayer.addChild(hpBar);
            this.battlefield.ctrlInfoLayer.addChild(roleName);
            this.battlefield.ctrlInfoLayer.addChild(_vipIcon);
            this.battlefield.ctrlInfoLayer.addChild(_angleText);
         }
      }
      
      public function get hp() : int
      {
         return _hp;
      }
      
      public function advanceTime(param1:Number) : void
      {
         advanceTimeHook(param1);
         if(this.status == MOVE && !_isDie)
         {
            move(param1);
         }
         update(param1);
      }
      
      protected function update(param1:Number) : void
      {
         down(param1);
         changeVisualAngle(character);
         updateHpBarPos();
         updatePropSprite();
         checkDropDie();
      }
      
      protected function checkDropDie() : Boolean
      {
         if(!_isDie && this.character.y > this.battlefield.getMap().mapHeight + 20)
         {
            dieSignal.dispatch(siteID,"drop");
            this.character.y = this.battlefield.getMap().mapHeight;
            this.character.dieAnimation();
            _isDie = true;
            _hp = 0;
            hpBar.hp = _hp;
            _downStart = false;
            ctrlStart(false);
            return true;
         }
         return false;
      }
      
      protected function updateHpBarPos() : void
      {
         hpBar.x = this.character.x - (hpBar.width >> 1);
         hpBar.y = this.character.y + hpBar.height;
         roleName.x = hpBar.x;
         roleName.y = hpBar.y + hpBar.height * 1.5;
         _vipIcon.x = this.character.x - (_vipIcon.width >> 1);
         _vipIcon.y = this.character.y - 160;
         updateAngleText();
      }
      
      private function updateAngleText() : void
      {
         if(direction)
         {
            _angleText.x = this.character.x + 20;
         }
         else
         {
            _angleText.x = this.character.x - 120;
         }
         _angleText.y = this.character.y - 140;
         if(character.angle > 90)
         {
            _angleText.text = int(180 - character.angle) + "°";
         }
         else
         {
            _angleText.text = int(this.character.angle) + "°";
         }
      }
      
      protected function updatePropSprite() : void
      {
         this.propSprite.x = character.x;
         this.propSprite.y = character.y;
      }
      
      protected function advanceTimeHook(param1:Number) : void
      {
      }
      
      public function playCry(param1:Number = 1) : void
      {
         var time:Number = param1;
         if(!_isCry)
         {
            this.character.cryAnimation();
            _isCry = true;
            Starling.juggler.delayCall(function():void
            {
               _isCry = false;
               if(character)
               {
                  character.standAnimation();
               }
            },time);
         }
      }
      
      public function changeStatus(param1:String) : void
      {
         var status:String = param1;
         this.status = status;
         LevelLogger.getLogger("CharacterCtrl").info(this.status);
         switch(status)
         {
            case MOVE:
               this.character.runAnimation();
               SoundManager.playSound("sound 20",10);
               break;
            case TARGET:
               this.character.standAnimation();
               break;
            case DOWN:
               this.character.standAnimation();
               break;
            case SHOOT:
               ctrlCompeleteSignal.dispatch(siteID);
               if(_isUseAnger)
               {
                  trace("useAnger");
                  this.battlefield.getMap().dark();
                  this.battlefield.camera.focusTarget = this.character;
                  coreMC.x = this.character.x;
                  coreMC.y = this.character.y;
                  coreMC.rotation = character.rotation;
                  coreMC.play();
                  SoundManager.playSound("sound 23");
                  this.battlefield.charatersBGLayer.addChild(coreMC);
                  Starling.juggler.delayCall(function():void
                  {
                     SoundManager.playSound("sound 24");
                  },3.5);
                  break;
               }
               if(bulletClass == "MissileBullet")
               {
                  this.character.gunAnimation();
               }
               else
               {
                  this.character.stoneAnimation();
               }
               if(bulletClass == "PlaneBullet")
               {
                  Starling.juggler.delayCall(function():void
                  {
                     SoundManager.playSound("sound 21");
                  },0.6);
                  break;
               }
               if(bulletClass == "MissileBullet")
               {
                  Starling.juggler.delayCall(function():void
                  {
                     SoundManager.playSound("sound 14");
                  },0.6);
                  break;
               }
               Starling.juggler.delayCall(function():void
               {
                  SoundManager.playSound("sound 14");
               },1.6);
               break;
            case CRY:
               this.character.cryAnimation();
         }
      }
      
      private function onCoreMCComplete(param1:Event) : void
      {
         var e:Event = param1;
         coreMC.stop();
         coreMC.removeFromParent();
         angerMovieClip = new AngerMovieClip();
         Starling.current.stage.addChild(angerMovieClip);
         Starling.juggler.delayCall(function():void
         {
            angerMovieClip.remove(function():void
            {
               angerMovieClip = null;
               character.gunAnimation();
            });
         },2);
      }
      
      protected function set direction(param1:Boolean) : void
      {
         if(param1 != this._direction)
         {
            this._direction = param1;
            if(this._direction)
            {
               character.reverse(1);
               if(character.angle > 90 || character.angle < -90)
               {
                  if(character.angle > 0)
                  {
                     character.angle = 180 - character.angle;
                  }
                  else
                  {
                     character.angle = 180 + character.angle;
                  }
               }
            }
            else
            {
               character.reverse(-1);
               if(character.angle <= 90 && character.angle > -90)
               {
                  if(character.angle > 0)
                  {
                     character.angle = 180 - character.angle;
                  }
                  else
                  {
                     character.angle = 180 + character.angle;
                  }
               }
            }
         }
      }
      
      protected function get direction() : Boolean
      {
         return this._direction;
      }
      
      protected function down(param1:Number) : void
      {
         if(_downStart)
         {
            sHelperPoint.setTo(this.character.x,this.character.y);
            while(!character.hitMap(sHelperPoint.x,sHelperPoint.y,this.battlefield.getMap()))
            {
               sHelperPoint.y++;
               if(sHelperPoint.y > this.battlefield.getMap().mapHeight + 20)
               {
                  break;
               }
            }
            character.y = sHelperPoint.y;
            if(downOkSignal)
            {
               downOkSignal.dispatch();
            }
            _downStart = false;
         }
      }
      
      public function get downStatus() : Boolean
      {
         return _downStart;
      }
      
      public function set downStatus(param1:Boolean) : void
      {
         if(_isDie)
         {
            _downStart = false;
         }
         _downStart = param1;
      }
      
      protected function move(param1:Number) : void
      {
         sHelperPoint.setTo(this.character.x,this.character.y);
         if(direction)
         {
            sHelperPoint.x += MOVE_V * param1;
         }
         else
         {
            sHelperPoint.x -= MOVE_V * param1;
         }
         while(this.character.hitMap(sHelperPoint.x,sHelperPoint.y,this.battlefield.getMap()))
         {
            sHelperPoint.y--;
         }
         sHelperPoint.y++;
         if(Math.abs(character.y - sHelperPoint.y) < character.bitmapModel.height / 2)
         {
            if(sHelperPoint.x < this.battlefield.getMap().mapWidth - character.charWidth && sHelperPoint.x > character.charWidth)
            {
               this.character.y = sHelperPoint.y;
               this.character.x = sHelperPoint.x;
               downStart();
            }
         }
      }
      
      protected function onShoot() : void
      {
         propSprite.removeChildren();
         _lastBulletNum = bulletTimes * bulletCount;
         try
         {
            bulletStart();
         }
         catch(err:Error)
         {
            Remoting.instance.gameLog(err.message + "|" + err.getStackTrace());
            Application.instance.log("shoot\'s error:",err.message + "|" + err.getStackTrace());
         }
      }
      
      protected function createBullet() : Bullet
      {
         switch(bulletClass)
         {
            case "GrenadeBullet":
               return new GrenadeBullet(this,this.typeId);
            case "PlaneBullet":
               return new PlaneBullet(this,this.typeId);
            case "WatermelonBullet":
               return new WatermelonBullet(this,this.typeId);
            case "MalletBullet":
               return new MalletBullet(this,this.typeId);
            case "SnowballBullet":
               return new SnowballBullet(this,this.typeId);
            case "PineappleBullet":
               return new PineappleBullet(this,this.typeId);
            case "MissileBullet":
               return new MissileBullet(this,this.typeId);
            case "BowBullet":
               return new BowBullet(this,this.typeId);
            default:
               return new MalletBullet(this,this.typeId);
         }
      }
      
      protected function bulletStart() : void
      {
         var _loc3_:int = 0;
         var _loc2_:Bullet = null;
         var _loc1_:Number = NaN;
         if(bulletTimes <= 0)
         {
            return;
         }
         if(isPlane())
         {
            bulletTimes = bulletCount = 1;
         }
         bulletTimes = bulletTimes - 1;
         Bullet.type = bulletClass;
         _countSlotting = 0;
         _loc3_ = 0;
         while(_loc3_ < bulletCount)
         {
            _loc2_ = createBullet();
            _loc1_ = (_loc3_ - (bulletCount - 1) / 2) * 10;
            _loc2_.id = bulletTimes * bulletCount + _loc3_ + this.siteID * 100;
            _loc2_.init(character.firingPoint,character.angle + _loc1_,character.velocity,130 / 2);
            this.battlefield.getGameLayer().addChild(_loc2_);
            _loc2_.start();
            _loc2_.blowoutCompleteSignal.addOnce(shootComplete);
            _loc2_.slottingCompleteSignal.addOnce(slottingComplete);
            if(_loc1_ == 0)
            {
               this.battlefield.cameraFocusCtrlByTouch(false);
               this.battlefield.camera.swapFocus(_loc2_);
            }
            _loc3_++;
         }
      }
      
      protected function shootComplete() : void
      {
         if(isPlane() && (planeLandPoint.x != 0 || planeLandPoint.y != 0))
         {
            this.character.x = planeLandPoint.x;
            this.character.y = planeLandPoint.y;
            this.downStart();
         }
         _lastBulletNum = _lastBulletNum - 1;
         if(_lastBulletNum <= 0)
         {
            if(_isUseAnger)
            {
               this.battlefield.getMap().unDark();
            }
            actionCompeleteSignal.dispatch(siteID);
            changeStatus("DOWN");
         }
         planeLandPoint.x = 0;
         planeLandPoint.y = 0;
      }
      
      public function isPlane() : Boolean
      {
         return bulletClass == "PlaneBullet";
      }
      
      protected function slottingComplete(param1:Array) : void
      {
         var _loc2_:Point = null;
         if(param1[0] == 3 && param1[1] > 0 && param1[1] < battlefield.getMap().mapWidth)
         {
            if(param1[1] < character.charWidth)
            {
               param1[1] = character.charWidth;
            }
            if(param1[1] > battlefield.getMap().mapWidth - character.charWidth)
            {
               param1[1] = battlefield.getMap().mapWidth - character.charWidth;
            }
            _loc2_ = planeHitCheck(param1[1],param1[2],param1[5]);
            planeLandPoint.setTo(_loc2_.x,_loc2_.y);
         }
         slottingCompleteSignal.dispatch(siteID,param1);
         _countSlotting = _countSlotting + 1;
         if(_countSlotting >= bulletCount)
         {
            bulletStart();
         }
      }
      
      protected function changeVisualAngle(param1:Character) : Boolean
      {
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         if(_tmpChangeVisualPoint.x == this.character.x && _tmpChangeVisualPoint.y == this.character.y)
         {
            return false;
         }
         var _loc4_:BtMap = this.battlefield.getMap();
         var _loc3_:Point = new Point(param1.x - 7,param1.y);
         var _loc2_:int = 18;
         _loc7_ = 0;
         while(_loc7_ < _loc2_)
         {
            if(_loc4_.hitPoint(new Point(_loc3_.x,_loc3_.y + _loc7_)))
            {
               break;
            }
            _loc7_++;
         }
         var _loc5_:Point = new Point(param1.x + 7,param1.y);
         _loc6_ = 0;
         while(_loc6_ < _loc2_)
         {
            if(_loc4_.hitPoint(new Point(_loc5_.x,_loc5_.y + _loc6_)))
            {
               break;
            }
            _loc6_++;
         }
         param1.rotation = Math.atan2(_loc6_ - _loc7_,14);
         _tmpChangeVisualPoint.x = this.character.x;
         _tmpChangeVisualPoint.y = this.character.y;
         return true;
      }
      
      public function stagePointToGamePoint(param1:Point) : Point
      {
         return this.battlefield.getGameLayer().globalToLocal(param1);
      }
      
      public function gamePointToStagePoint(param1:Point) : Point
      {
         return this.battlefield.getGameLayer().localToGlobal(param1);
      }
      
      public function onUsePropMCPlayEnd(param1:int) : void
      {
         var skillbox:SkillBox;
         var endX:int;
         var skillId:int = param1;
         var skillBoxTextTures:Vector.<Texture> = new Vector.<Texture>();
         skillBoxTextTures.push(Assets.sAsset.getTexture("jndbox"),Assets.sAsset.getTexture("jndbox"),Assets.sAsset.getTexture("jndbox"));
         skillbox = new SkillBox(false,skillBoxTextTures);
         skillbox.touchable = false;
         skillbox.setSkill(skillId);
         skillbox.pivotX = skillbox.width >> 1;
         skillbox.pivotY = skillbox.height >> 1;
         skillbox.scaleX = 0.8;
         skillbox.scaleY = 0.8;
         skillbox.x = usePropMC.x;
         skillbox.y = usePropMC.y;
         this.propSprite.addChild(skillbox);
         usePropTime = usePropTime + 1;
         endX = usePropMC.x + skillbox.width * usePropTime - usePropMC.width * 0.35;
         Starling.juggler.tween(skillbox,0.2,{
            "y":usePropMC.y - usePropMC.height * 0.3,
            "onComplete":function():void
            {
               skillbox.x = endX;
            }
         });
      }
      
      public function useProp(param1:int) : void
      {
         if(param1 == 4)
         {
            param1 = 10;
         }
         switch(param1)
         {
            case 0:
               bulletTimes += 2;
               _hurtfactor *= 0.6;
               break;
            case 1:
               bulletTimes += 1;
               _hurtfactor *= 0.9;
               break;
            case 2:
               bulletCount += 2;
               _hurtfactor *= 0.5;
               break;
            case 3:
               _hurtplus += 500;
               break;
            case 5:
               _hurtplus += 400;
               break;
            case 6:
               _hurtplus += 300;
               break;
            case 7:
               _hurtplus += 200;
               break;
            case 8:
               _hurtplus += 100;
               break;
            case 11:
               this.battlefield.addHp([siteID,500]);
               break;
            case 12:
               this.battlefield.addHp([siteID,300]);
               break;
            case 10:
               changeBullet("PlaneBullet");
               _isUsePlane = true;
               break;
            case 99:
               _hurtfactor *= 1.4;
               break;
            case 15:
         }
         if(param1 == 99)
         {
            _isUseAnger = true;
            return;
         }
         if(!this.battlefield.charatersBGLayer.contains(usePropMC))
         {
            this.propSprite.addChild(usePropMC);
         }
         usePropMC.pushPlay(param1);
         usePropMC.x = Math.cos(3.141592653589793 / 2 - this.character.rotation) * (this.character.charHeight / 2);
         usePropMC.y = -Math.sin(3.141592653589793 / 2 - this.character.rotation) * (this.character.charHeight / 2);
      }
      
      public function changeBullet(param1:String) : void
      {
         if(param1 != bulletClass)
         {
            bulletClass = param1;
         }
      }
      
      public function planeHitCheck(param1:Number, param2:Number, param3:int) : Point
      {
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc9_:int = 0;
         var _loc8_:Point = new Point();
         var _loc7_:int = character.x - param1 > 0 ? 1 : -1;
         if(character.hitMap(param1,param2,this.gameworld.getMap()))
         {
            trace("planeHitCheck vy:",param3);
            _loc6_ = param3 > 0 ? -1 : 1;
            _loc5_ = param2;
            _loc9_ = 0;
            while(_loc9_ < 100)
            {
               _loc5_ += _loc6_;
               if(!character.hitMap(param1,_loc5_,this.gameworld.getMap()))
               {
                  _loc8_.x = param1;
                  _loc8_.y = _loc5_;
                  return _loc8_;
               }
               _loc9_++;
            }
            _loc5_ = param2;
            _loc9_ = 0;
            while(_loc9_ < 100)
            {
               _loc5_ -= _loc6_;
               if(!character.hitMap(param1,_loc5_,this.gameworld.getMap()))
               {
                  _loc8_.x = param1;
                  _loc8_.y = _loc5_;
                  return _loc8_;
               }
               _loc9_++;
            }
            _loc4_ = param1;
            _loc5_ = param2;
            _loc9_ = 0;
            while(_loc9_ < 110)
            {
               _loc4_ += _loc7_;
               _loc5_ += _loc6_;
               if(!character.hitMap(_loc4_,_loc5_,this.gameworld.getMap()))
               {
                  _loc8_.x = _loc4_;
                  _loc8_.y = _loc5_;
                  return _loc8_;
               }
               _loc9_++;
            }
            return _loc8_;
         }
         _loc8_.x = param1;
         _loc8_.y = param2;
         return _loc8_;
      }
      
      public function dispose() : void
      {
         Starling.juggler.remove(this);
         Starling.juggler.remove(usePropMC);
         Starling.juggler.remove(coreMC);
         character.characterCtrl = null;
         battlefield = null;
         character = null;
         hpBar.removeFromParent(true);
         roleName.removeFromParent(true);
         _vipIcon.removeFromParent(true);
         _angleText.removeFromParent(true);
         usePropMC.dispose();
         actionCompeleteSignal.removeAll();
         slottingCompleteSignal.removeAll();
         ctrlCompeleteSignal.removeAll();
         dieSignal.removeAll();
         downOkSignal && downOkSignal.removeAll();
         GameServer.instance.disposeRecvFun(onVipLevel);
      }
      
      public function get roleAttr() : Array
      {
         if(_roleAttr == null)
         {
            setAttr();
         }
         return _roleAttr;
      }
      
      public function setAttr() : void
      {
         var _loc1_:PlayerData = PlayerDataList.instance.getDataBySiteID(_siteID);
         if(_loc1_ && _loc1_.getWeapon())
         {
            _roleAttr = _loc1_.ability();
         }
         else
         {
            _roleAttr = [74,40,261,60,207,143,340,253,0];
         }
      }
      
      public function get gameworld() : IGameWorld
      {
         return battlefield as IGameWorld;
      }
      
      public function get siteID() : int
      {
         return _siteID;
      }
      
      public function get icharacter() : ICharacter
      {
         return character as ICharacter;
      }
      
      public function get hurtfactor() : int
      {
         return _hurtfactor;
      }
      
      public function get hurtplus() : int
      {
         return _hurtplus;
      }
      
      public function get isUseAnger() : Boolean
      {
         return _isUseAnger;
      }
      
      public function get canUseProp() : Boolean
      {
         return _canUseProp;
      }
      
      public function get canControlAngel() : Boolean
      {
         return _canControlAngel;
      }
      
      public function get canMove() : Boolean
      {
         return _canMove;
      }
      
      public function get maxHp() : int
      {
         return _maxHp;
      }
      
      public function set maxHp(param1:int) : void
      {
         _maxHp = param1;
      }
      
      public function get isDie() : Boolean
      {
         return _isDie;
      }
      
      public function get battlefield() : IGameWorld
      {
         return _battlefield;
      }
      
      public function set battlefield(param1:IGameWorld) : void
      {
         _battlefield = param1;
      }
      
      public function setWhatCanIDo(param1:int = 1, param2:int = 1, param3:int = 1) : void
      {
         _canMove = Boolean(param1);
         _canControlAngel = Boolean(param2);
         _canUseProp = Boolean(param3);
      }
      
      public function setBadState(param1:String = "") : void
      {
         character.badState = param1;
         showBad.showBadStateImg(param1);
      }
   }
}

