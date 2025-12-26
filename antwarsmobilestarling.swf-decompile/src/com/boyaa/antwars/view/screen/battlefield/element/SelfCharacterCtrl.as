package com.boyaa.antwars.view.screen.battlefield.element
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.FightGoodsData;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterCtrl;
   import com.boyaa.antwars.view.game.IGameWorld;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.battlefield.ui.BtCharcterCtrlCircle;
   import com.boyaa.antwars.view.screen.battlefield.ui.NewDirectionControl;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.UseSkillManager;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.WeaponChangeManager;
   import com.boyaa.antwars.view.screen.fresh.FreshGuideVlaue;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.QuadBatch;
   import starling.display.Sprite;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class SelfCharacterCtrl extends CharacterCtrl
   {
      
      private var textureAtlas:ResAssetManager;
      
      private var target:Image;
      
      private var firingPoint:Point;
      
      private var dottBatch:QuadBatch;
      
      private var dott:Image;
      
      private var focus:Image;
      
      private var focusK:int = 0;
      
      private var dk:Boolean = true;
      
      private var _moveModel:Boolean = false;
      
      private var startPoint:Point;
      
      private var moveTimer:Timer;
      
      public var star:MovieClip;
      
      private var _ctrlInfoLayer:Sprite;
      
      private var touchInCharacter:Boolean = false;
      
      protected var server:* = null;
      
      public var ctrlStartSignal:Signal;
      
      public var isInFresh:Boolean = false;
      
      public var round:int = 0;
      
      public var physicalBar:HpBar;
      
      private var _controlCircle:BtCharcterCtrlCircle;
      
      private var _list:Vector.<Array> = new Vector.<Array>();
      
      private var _actionPoint:int;
      
      private var usePlaneInFresh:Boolean = false;
      
      protected var _data:Array = [];
      
      private var _tempArr:Array = [];
      
      private var _tempTargetArr:Array = [];
      
      private var _tempShootArr:Array = [];
      
      private var _sendCountTime:Number = 0;
      
      private var _moveInautoDistance:Number;
      
      private var _velocity:Number;
      
      private var _angle:Number;
      
      public function SelfCharacterCtrl(param1:IGameWorld, param2:Character, param3:uint, param4:int, param5:String)
      {
         super(param1,param2,param3,param4,param5);
         textureAtlas = Assets.sAsset;
         moveTimer = new Timer(500,1);
         moveTimer.addEventListener("timer",onMoveTimer);
         ctrlStartSignal = new Signal(Boolean);
         physicalBar = new HpBar(Assets.sAsset.getTexture("dz50"),16776960,actionPoint);
         physicalBar.scaleX = physicalBar.scaleY = hpBar.scaleX;
         this.battlefield.ctrlInfoLayer.addChild(physicalBar);
         physicalBar.visible = false;
         EventCenter.GameEvent.addEventListener("moveControl",moveByDirectionIcon);
         _controlCircle = new BtCharcterCtrlCircle(this);
         WeaponChangeManager.instance.setUsePlayer(this);
      }
      
      public function setServer(param1:*) : void
      {
         server = param1;
      }
      
      public function set ctrlInfoLayer(param1:Sprite) : void
      {
         this._ctrlInfoLayer = param1;
         dottBatch = new QuadBatch();
         dott = new Image(textureAtlas.getTexture("linedot0"));
         this._ctrlInfoLayer.addChild(dottBatch);
         focus = new Image(textureAtlas.getTexture("focus"));
         focus.scaleY = focus.scaleX = 0.5;
         star = new MovieClip(textureAtlas.getTextures("cstar"));
         star.pivotX = star.width >> 1;
         star.pivotY = star.height - 20;
         star.height = 130;
         star.scaleX = star.scaleY;
         Starling.juggler.add(star);
      }
      
      override public function ctrlStart(param1:Boolean) : void
      {
         this.touchInCharacter = false;
         _controlCircle.visible = false;
         _angleText.visible = param1;
         if(param1)
         {
            if(!this.battlefield)
            {
               return;
            }
            UseSkillManager.instance.initSkillState();
            this.battlefield.getMoveButton().addEventListener("touch",characterMoveHandle);
            this.star.addEventListener("touch",characterShootHandle);
            this._ctrlInfoLayer.addChild(focus);
            if(_isUsePlane)
            {
               _controlCircle.changeWeapon();
            }
            star.rotation = character.rotation;
            star.play();
            focus.visible = false;
            star.visible = false;
            physicalBar.visible = true;
            _controlCircle.visible = true;
         }
         else
         {
            sendData();
            if(!this.battlefield)
            {
               return;
            }
            this._ctrlInfoLayer.removeChild(focus);
            star.stop();
            this._ctrlInfoLayer.removeChild(star);
            this.battlefield.getMoveButton().removeEventListener("touch",characterMoveHandle);
            this.star.removeEventListener("touch",characterShootHandle);
            if(this.status == MOVE)
            {
               this.changeStatus(TARGET);
            }
            moveModel = false;
            physicalBar.visible = false;
         }
         super.ctrlStart(param1);
         ctrlStartSignal.dispatch(param1);
         if(param1)
         {
            trace("actionPoint" + actionPoint);
            physicalBar.setAllhp(actionPoint);
         }
         this.battlefield.UILayer.disable = !param1;
      }
      
      override protected function advanceTimeHook(param1:Number) : void
      {
         var _loc2_:Array = null;
         if(touchInCharacter)
         {
            _list.push([_angle,_velocity]);
            if(_list.length == 1)
            {
               updateVelocityAndAngle(_angle,_velocity);
            }
            if(_list.length > 6)
            {
               _loc2_ = _list.shift();
               updateVelocityAndAngle(_loc2_[0],_loc2_[1]);
            }
         }
         if(focus.parent)
         {
            focus.x = character.x - (focus.width >> 1);
            focus.y = character.y - star.height - focus.height - focusK;
            if(focusK == 24 || focusK == 0)
            {
               dk = !dk;
            }
            if(dk)
            {
               focusK -= 2;
            }
            else
            {
               focusK += 2;
            }
            focus.visible = !isInFresh;
         }
         if(star.parent)
         {
            star.x = character.x;
            star.y = character.y;
            star.visible = true;
         }
         if(this.status == MOVE)
         {
            recodePosition();
         }
         else if(this.status == TARGET)
         {
            recodeTarget();
         }
      }
      
      private function moveByDirectionIcon(param1:GameEvent) : void
      {
         if(!isCtrl)
         {
            return;
         }
         var _loc3_:Array = param1.param as Array;
         var _loc2_:int = int(_loc3_[1]);
         if(_loc3_[0] == "start")
         {
            if(2 == _loc2_)
            {
               this.direction = false;
               changeStatus(MOVE);
            }
            if(3 == _loc2_)
            {
               this.direction = true;
               changeStatus(MOVE);
            }
         }
         else
         {
            changeStatus(TARGET);
            _controlCircle.angle += 0;
         }
         trace("当前玩家角度：",character.angle);
      }
      
      override protected function move(param1:Number) : void
      {
         if(actionPoint <= 0)
         {
            return;
         }
         super.move(param1);
      }
      
      override protected function changeVisualAngle(param1:Character) : Boolean
      {
         if(super.changeVisualAngle(param1))
         {
            if(star.parent)
            {
               star.rotation = param1.rotation;
            }
            return true;
         }
         return false;
      }
      
      private function changeAngelByDirectionControl() : void
      {
         if(!isCtrl)
         {
            return;
         }
         var _loc1_:Number = 0.5;
         if(FreshGuideVlaue.inFreshGame && "changeAngle" != FreshGuideVlaue.currentStepData[0])
         {
            return;
         }
         if(NewDirectionControl.getDirectionValue(0) == 1)
         {
            _controlCircle.angle += _loc1_;
         }
         if(NewDirectionControl.getDirectionValue(1) == 1)
         {
            _controlCircle.angle -= _loc1_;
         }
      }
      
      override public function advanceTime(param1:Number) : void
      {
         super.advanceTime(param1);
         changeAngelByDirectionControl();
         sendData(param1);
      }
      
      public function set actionPoint(param1:int) : void
      {
         if(_actionPoint != param1)
         {
            if(!isInFresh)
            {
               this.battlefield.UILayer.updateSkillBoxsByActionPoint(param1);
            }
            _actionPoint = param1;
            if(this.battlefield.UILayer.bomb.bombValue < 100 && actionPoint < GoodsList.instance.getMyFightGoodsMinActionPoint())
            {
               if(!isInFresh)
               {
                  this.battlefield.UILayer.hiddenBottomBar();
               }
            }
            physicalBar.hp = actionPoint;
            if(actionPoint <= 0)
            {
               if(!isInFresh)
               {
                  TextTip.instance.show(LangManager.t("tired"));
               }
            }
         }
      }
      
      public function get actionPoint() : int
      {
         return _actionPoint;
      }
      
      public function useSkillById(param1:int) : void
      {
         var data:FightGoodsData;
         var id:int = param1;
         if(server)
         {
            if(id != 0)
            {
               if(id == 4)
               {
                  MissionManager.instance.updateMissionData(101,0,10);
               }
               else
               {
                  MissionManager.instance.updateMissionData(101,0,id);
               }
            }
            server.sendUseProp(id);
            if(server is CopyServer && CopyServer(server).serverType == 1)
            {
               CopyServer(server).sendUnionFightUseProp(id);
            }
         }
         if(!(server is BattleServer))
         {
            Remoting.instance.useBTProp([id],function(param1:Object):void
            {
               trace("use Prop:",JSON.stringify(param1));
            });
         }
         data = GoodsList.instance.getFightDataByID(id);
         super.useProp(data.frame);
         if(data.frame == 10)
         {
            _controlCircle.changeToPlaneAngle();
         }
         if(data.type == 2)
         {
            GoodsList.instance.payPorpIdArr.splice(GoodsList.instance.payPorpIdArr.indexOf(data.frame),1);
         }
         if(!isInFresh)
         {
            actionPoint -= data.expendForce;
         }
         EventCenter.GameEvent.dispatchEvent(new GameEvent("useSkillComplete",{
            "ep":actionPoint,
            "id":id
         }));
      }
      
      public function usePropBySkillBox(param1:SkillBox) : void
      {
         var data:FightGoodsData;
         var skillBox:SkillBox = param1;
         if(server)
         {
            if(skillBox.skillId != 0)
            {
               if(skillBox.skillId == 4)
               {
                  MissionManager.instance.updateMissionData(101,0,10);
               }
               else
               {
                  MissionManager.instance.updateMissionData(101,0,skillBox.skillId);
               }
            }
            server.sendUseProp(skillBox.skillId);
            if(server is CopyServer && CopyServer(server).serverType == 1)
            {
               CopyServer(server).sendUnionFightUseProp(skillBox.skillId);
            }
         }
         if(!(server is BattleServer))
         {
            Remoting.instance.useBTProp([skillBox.skillId],function(param1:Object):void
            {
            });
         }
         data = GoodsList.instance.getFightDataByID(skillBox.skillId);
         super.useProp(data.frame);
         if(data.type == 2)
         {
            skillBox.setSkill(-1);
            GoodsList.instance.payPorpIdArr.splice(GoodsList.instance.payPorpIdArr.indexOf(data.frame),1);
         }
         if(!isInFresh)
         {
            actionPoint -= data.expendForce;
         }
      }
      
      public function usePlane() : void
      {
         server && server.sendUseProp(4);
         if(server is CopyServer && CopyServer(server).serverType == 1)
         {
            CopyServer(server).sendUnionFightUseProp(4);
         }
         var _loc1_:FightGoodsData = GoodsList.instance.getFightDataByID(4);
         if(!isInFresh)
         {
            usePlaneInFresh = false;
            actionPoint -= _loc1_.expendForce;
         }
         else
         {
            usePlaneInFresh = true;
         }
         super.useProp(4);
         MissionManager.instance.updateMissionData(101,0,10);
         if(_isUsePlane)
         {
            _controlCircle.changeToPlaneAngle();
         }
      }
      
      public function useAnger() : void
      {
         server && server.sendUseProp(99);
         if(server is CopyServer && CopyServer(server).serverType == 1)
         {
            CopyServer(server).sendUnionFightUseProp(99);
         }
         var _loc1_:FightGoodsData = GoodsList.instance.getFightDataByID(4);
         super.useProp(99);
         MissionManager.instance.updateMissionData(101,0,99);
      }
      
      public function recodePosition() : void
      {
         if(actionPoint != 0)
         {
            if(isInFresh)
            {
               return;
            }
         }
         if(!(_tempArr[0] == character.x && _tempArr[1] == character.y && _tempArr[2] == this.direction))
         {
            actionPoint -= int(Math.abs(_tempArr[0] - character.x));
            _data.push([0,character.x,character.y,this.direction]);
            _tempArr[0] = character.x;
            _tempArr[1] = character.y;
            _tempArr[2] = this.direction;
         }
      }
      
      public function recodeTarget() : void
      {
         if(!(_tempTargetArr[0] == character.angle && _tempTargetArr[1] == character.velocity && _tempTargetArr[2] == character.x && _tempTargetArr[3] == character.y))
         {
            _data.push([1,character.x,character.y,character.angle,character.velocity]);
            _tempTargetArr[0] = character.angle;
            _tempTargetArr[1] = character.velocity;
            _tempTargetArr[2] = character.x;
            _tempTargetArr[3] = character.y;
         }
      }
      
      public function recodeShoot() : void
      {
         _data.push([2,character.x,character.y,character.angle,character.velocity]);
         _tempShootArr[0] = character.angle;
         _tempShootArr[1] = character.velocity;
         sendData();
      }
      
      public function sendData(param1:Number = 0) : void
      {
         var _loc3_:Number = 0.1;
         var _loc2_:Boolean = false;
         _sendCountTime += param1;
         if(_sendCountTime >= _loc3_)
         {
            _sendCountTime -= _loc3_;
            _loc2_ = true;
         }
         if(param1 == 0)
         {
            _loc2_ = true;
         }
         if(!_loc2_)
         {
            return;
         }
         if(_data.length == 0)
         {
            return;
         }
         server && server.sendMove(_data,character.x,character.y);
         if(server is BattleServer && PlayerDataList.instance.pk_type == 1)
         {
            BattleServer(server).sendFightData([0,_data,siteID]);
         }
         _data = [];
      }
      
      public function sendMoveToServer() : void
      {
         if(this.isPlane())
         {
            _tempArr[0] = character.x;
            _tempArr[1] = character.y;
            _tempArr[2] = this.direction;
         }
         _data.push([10000]);
         sendData();
      }
      
      override public function changeStatus(param1:String) : void
      {
         super.changeStatus(param1);
      }
      
      public function get self() : Character
      {
         return character;
      }
      
      private function shoot() : void
      {
         ctrlStart(false);
         this.changeStatus(SHOOT);
      }
      
      private function characterShootHandle(param1:TouchEvent) : void
      {
         var _loc5_:Touch = null;
         var _loc4_:* = null;
         var _loc2_:Point = null;
         if(this._downStart)
         {
            return;
         }
         var _loc3_:Vector.<Touch> = param1.touches;
         if(_loc3_.length == 1)
         {
            _loc5_ = _loc3_[0];
            if(_loc5_.phase == "began")
            {
               touchInCharacter = true;
               this.changeStatus(TARGET);
               character.setFiringPoint();
               _loc2_ = character.firingPoint;
               focus.visible = false;
               this.battlefield.mapCtrlByTouch = false;
            }
            else if(_loc5_.phase == "ended")
            {
               if(touchInCharacter)
               {
                  if(isInFresh)
                  {
                     if(usePlaneInFresh)
                     {
                        usePlaneInFresh = false;
                        this.character.angle = 100;
                        this.character.velocity = 38;
                     }
                     else
                     {
                        this.character.angle = 30;
                        this.character.velocity = 50;
                     }
                  }
                  shoot();
                  recodeShoot();
                  _list.length = 0;
               }
            }
            else if(_loc5_.phase == "moved")
            {
               if(!canControlAngel)
               {
                  TextTip.instance.show(LangManager.t(character.badState + "Info"));
                  return;
               }
               if(touchInCharacter)
               {
                  backChengeAngle(_loc5_);
               }
            }
         }
      }
      
      public function shootTargetInAuto(param1:DisplayObject) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc7_:Number = NaN;
         if(!isCtrl)
         {
            return;
         }
         character.setFiringPoint();
         var _loc8_:Number = 45;
         var _loc6_:Number = 25;
         if(param1)
         {
            this.direction = param1.x > this.character.x;
            _loc4_ = param1.x - character.firingPoint.x;
            _loc5_ = character.firingPoint.y - param1.y;
            _loc2_ = _controlCircle.minAngle <= 45 ? 45 : _controlCircle.minAngle;
            _loc3_ = _controlCircle.maxAngle >= 75 ? 75 : _controlCircle.maxAngle;
            _loc7_ = character.rotation * 180 / 3.141592653589793;
            if(_loc5_ > 100)
            {
               _loc8_ = _loc3_ - _loc7_;
            }
            else
            {
               _loc8_ = _loc2_ - _loc7_;
            }
            _loc6_ = MathHelper.getVelocity(_loc4_,_loc5_,_loc8_);
         }
         else
         {
            trace("targer is null");
         }
         this.changeStatus(TARGET);
         _controlCircle.angle = _loc8_;
         this.character.velocity = _loc6_;
         Application.instance.log("autoFight","angle:" + _loc8_ + "|" + "velocity:" + _loc6_);
         shoot();
         recodeShoot();
         _list.length = 0;
      }
      
      public function shootInControlBar() : void
      {
         character.setFiringPoint();
         shoot();
         recodeShoot();
         _list.length = 0;
      }
      
      private function characterMoveHandle(param1:TouchEvent) : void
      {
         var _loc5_:Touch = null;
         var _loc2_:Point = null;
         var _loc4_:Number = NaN;
         var _loc3_:Vector.<Touch> = param1.touches;
         if(_loc3_.length >= 2)
         {
            touchInCharacter = false;
            focus.visible = true;
            _list.length = 0;
         }
         if(touchInCharacter)
         {
            return;
         }
         if(_loc3_.length == 1)
         {
            _loc5_ = _loc3_[0];
            if(_loc5_.phase == "began")
            {
               if(!canMove)
               {
                  TextTip.instance.show(LangManager.t(character.badState + "Info"));
                  return;
               }
               startPoint = this.stagePointToGamePoint(new Point(_loc5_.globalX,_loc5_.globalY));
               moveModel = false;
               moveTimer.start();
               trace(_loc5_.phase);
            }
            if(_loc5_.phase == "moved")
            {
               trace(_loc5_.phase);
               _loc2_ = _loc5_.getMovement(Starling.current.stage);
               _loc4_ = _loc2_.x * _loc2_.x + _loc2_.y * _loc2_.y;
               if(!_moveModel && _loc4_ > 100)
               {
                  moveTimer.stop();
               }
            }
            if(_loc5_.phase == "ended")
            {
               trace(_loc5_.phase);
               if(_moveModel)
               {
                  this.changeStatus(TARGET);
               }
               moveTimer.stop();
               moveModel = false;
            }
         }
         else if(!_moveModel)
         {
            moveTimer.stop();
         }
         else
         {
            this.changeStatus(TARGET);
            moveModel = false;
         }
      }
      
      public function moveInAutoFight(param1:int) : void
      {
         this.direction = param1 >= 0 ? true : false;
         _moveInautoDistance = param1 + this.self.x;
         this.changeStatus(MOVE);
         Timepiece.instance.addFun(onMoveInAutoFrame);
         Timepiece.instance.addDelayCall(onStopMoveInAuto,2000);
      }
      
      private function onStopMoveInAuto() : void
      {
         Timepiece.instance.removeFun(onMoveInAutoFrame,0);
         this.changeStatus(TARGET);
      }
      
      private function onMoveInAutoFrame() : void
      {
         if(this.direction)
         {
            if(this.self.x >= _moveInautoDistance)
            {
               Timepiece.instance.removeFun(onMoveInAutoFrame,0);
               Timepiece.instance.removeFun(onStopMoveInAuto,2);
               this.changeStatus(TARGET);
            }
         }
         else if(this.self.x <= _moveInautoDistance)
         {
            Timepiece.instance.removeFun(onMoveInAutoFrame,0);
            this.changeStatus(TARGET);
         }
      }
      
      private function set moveModel(param1:Boolean) : void
      {
         _moveModel = param1;
         this.battlefield.mapCtrlByTouch = !_moveModel;
      }
      
      private function onMoveTimer(param1:TimerEvent) : void
      {
         moveModel = true;
         if(this.self.x > startPoint.x)
         {
            this.direction = false;
            this.self.reverse(-1);
         }
         else
         {
            this.direction = true;
            this.self.reverse(1);
         }
         this.changeStatus(MOVE);
      }
      
      private function chengeAngle(param1:Touch) : void
      {
         var _loc3_:Point = this.stagePointToGamePoint(new Point(param1.globalX,param1.globalY));
         var _loc6_:Number = _loc3_.x - this.self.firingPoint.x;
         var _loc5_:Number = this.self.firingPoint.y - _loc3_.y;
         var _loc4_:Number = Math.atan2(_loc5_,_loc6_ - _loc6_ / 2) * 180 / 3.141592653589793;
         this.self.angle = _loc4_;
         trace("angle:",this.self.angle);
         var _loc2_:Number = getVelocity(_loc5_,this.self.angle);
         trace("v:",_loc2_);
         drawDottBatch(_loc2_,this.self.angle);
         this.self.velocity = _loc2_;
      }
      
      private function backChengeAngle(param1:Touch) : void
      {
         var _loc4_:Point = new Point(character.x,character.centerY);
         var _loc3_:Point = this.stagePointToGamePoint(new Point(param1.globalX,param1.globalY));
         var _loc2_:Number = 0;
         var _loc5_:Number = 0;
         _loc2_ = (Math.sqrt(MathHelper.getSquareOfDistAlongTwoPoint(_loc4_.x,_loc4_.y,_loc3_.x,_loc3_.y)) - 130 / 4) * 0.5;
         if(_loc2_ <= 0)
         {
            _loc2_ = 1;
         }
         if(_loc2_ > 50)
         {
            _loc2_ = 50;
         }
         _loc5_ = Math.atan2(_loc3_.y - _loc4_.y,_loc3_.x - _loc4_.x) * (180 / 3.141592653589793);
         _velocity = _loc2_;
         _angle = 180 - _loc5_;
      }
      
      private function updateVelocityAndAngle(param1:Number, param2:Number) : void
      {
         this.self.velocity = param2;
         this.self.angle = param1;
         drawDottBatch(this.self.velocity,this.self.angle);
         recodeTarget();
      }
      
      private function getVelocity(param1:Number, param2:Number) : Number
      {
         return Math.sqrt(Math.abs(2 * param1 * 1.2 / Math.pow(Math.sin(param2 * 3.141592653589793 / 180),2)));
      }
      
      private function drawDottBatch(param1:Number, param2:Number) : void
      {
         var _loc7_:Point = null;
         var _loc9_:int = 0;
         var _loc5_:Number = param1 * Math.sin(param2 * 3.141592653589793 / 180);
         var _loc6_:Number = param1 * Math.cos(param2 * 3.141592653589793 / 180);
         dottBatch.reset();
         var _loc8_:Number = 0;
         var _loc4_:Number = 0;
         var _loc3_:Number = 0.8;
         _loc9_ = 0;
         while(_loc9_ < 20)
         {
            _loc4_ = _loc8_ / _loc6_;
            _loc7_ = new Point(this.self.firingPoint.x + _loc8_,this.self.firingPoint.y - _loc5_ * _loc4_ + 1.2 * _loc4_ * _loc4_ / 2);
            if(!MathHelper.check_circleAndPoint(this.self.firingPoint,130 / 2,_loc7_))
            {
               dott.x = _loc7_.x;
               dott.y = _loc7_.y;
               dott.scaleX = dott.scaleY = _loc3_;
               dottBatch.addImage(dott);
            }
            _loc8_ += _loc6_;
            _loc3_ *= 0.96;
            _loc9_++;
         }
      }
      
      override public function changeWeapon(param1:GoodsData) : void
      {
         super.changeWeapon(param1);
         _controlCircle.changeWeapon();
      }
      
      override public function setAttr() : void
      {
         var _loc1_:PlayerData = PlayerDataList.instance.selfData;
         _roleAttr = _loc1_.ability();
      }
      
      override protected function updateHpBarPos() : void
      {
         super.updateHpBarPos();
         physicalBar.y = hpBar.y + hpBar.height + 2;
         physicalBar.x = hpBar.x;
      }
      
      override public function dispose() : void
      {
         ctrlStartSignal.removeAll();
         Starling.juggler.remove(star);
         moveTimer.removeEventListener("timer",onMoveTimer);
         dottBatch.removeFromParent(true);
         EventCenter.GameEvent.removeEventListener("moveControl",moveByDirectionIcon);
         super.dispose();
      }
   }
}

