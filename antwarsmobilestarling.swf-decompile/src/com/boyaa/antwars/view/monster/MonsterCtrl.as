package com.boyaa.antwars.view.monster
{
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.game.ICharacter;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.game.IGameWorld;
   import com.boyaa.antwars.view.screen.battlefield.BtMap;
   import com.boyaa.antwars.view.screen.battlefield.element.HpBar;
   import flash.geom.Point;
   import org.osflash.signals.Signal;
   import starling.animation.IAnimatable;
   import starling.core.Starling;
   
   public class MonsterCtrl implements IAnimatable, ICharacterCtrl, IMonsterCtrl
   {
      
      public static const STAND:String = "stand";
      
      public static const MOVE:String = "move";
      
      public static const ATTACK:String = "attack";
      
      public static const DIZZY:String = "dizzy";
      
      public static const ANGEL:String = "angel";
      
      public static const ATTACK_PALSY:String = "palsy";
      
      public static const ATTACK_CHAIN:String = "chain";
      
      public static var isInFresh:Boolean = false;
      
      public static var monsterAttrQueue:MonsterAttrQueue = new MonsterAttrQueue();
      
      private static var sHelperPoint:Point = new Point();
      
      public var _gameWorld:IGameWorld;
      
      public var _monster:Monster;
      
      protected var _siteID:int;
      
      protected var _direction:Boolean = false;
      
      private var status:String = "stand";
      
      protected var _wantattack:Boolean = false;
      
      protected var _downStart:Boolean = true;
      
      protected var _attackTarget:ICharacter;
      
      public var attackSignal:Signal;
      
      protected var _actionCompleteSignal:Signal;
      
      protected var _hp:int;
      
      protected var _ctrlStart:Boolean = false;
      
      protected var isDie:Boolean = false;
      
      protected var actionPoint:int;
      
      protected var hpBar:HpBar;
      
      public var firstShowRunAction:Boolean = true;
      
      private var _specailRoleArr:Array;
      
      private var face_dist:Number;
      
      private var _moveFlag:int = 0;
      
      private var _moveStartPos:Number;
      
      private var attackCount:int;
      
      private var specialAttack:int = 0;
      
      private var dizzyCount:int;
      
      private var _timeToStop:Number;
      
      private var _tmpChangeVisualPoint:Point;
      
      private var _roleAttr:Array = null;
      
      public function MonsterCtrl(param1:IGameWorld, param2:Monster, param3:int)
      {
         var _loc4_:int = 0;
         _specailRoleArr = [23];
         _tmpChangeVisualPoint = new Point();
         super();
         _gameWorld = param1;
         _monster = param2;
         _siteID = param3;
         _monster.monsterCtrl = this;
         _monster.setStatus(status);
         _monster.animationCompleteSignal.add(animationComplete);
         attackTarget = findNearestTarget();
         attackSignal = new Signal(String,MonsterCtrl);
         _actionCompleteSignal = new Signal();
         hpBar = new HpBar(Assets.sAsset.getTexture("dz50"),108487,_monster.data.blood);
         gameworld.ctrlInfoLayer.addChild(hpBar);
         hpBar.scaleY = hpBar.scaleX = 0.8;
         hp = _monster.data.blood;
         if(_monster.data.influ_through == 0)
         {
            hpBar.visible = false;
         }
         if(_monster.data.attack_dist > 0 && _monster.data.spiece_type != 11)
         {
            _loc4_ = _monster.data.attack_dist * 0.2;
            _monster.data.attack_dist -= MathHelper.randomWithinRange(-_loc4_,_loc4_);
         }
         if(_monster.data.attack_type == 1)
         {
            face_dist = _monster.data.attack_dist - 10;
            if(_monster.data.spiece_type == 11)
            {
               face_dist = 0;
            }
         }
         else if(_monster.data.attack_type == 2 || _specailRoleArr.indexOf(_monster.data.spiece_type) != -1)
         {
            face_dist = MathHelper.randomWithinRange(100,200);
         }
      }
      
      public function ctrlStart() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:int = 0;
         trace(this._monster.data.roleid + " 进入了ctrlStart");
         _wantattack = false;
         _timeToStop = 0;
         attackCount = 0;
         dizzyCount = 0;
         if(isDie)
         {
            return;
         }
         if(!_monster)
         {
            return;
         }
         if(this._monster.data.spiece_type == 9)
         {
            face_dist = 0;
            _loc2_ = Math.abs(_monster.x - attackTarget.x);
            if(_loc2_ < 80)
            {
               _actionCompleteSignal.dispatch();
               return;
            }
         }
         actionPoint = _monster.data.max_move;
         _moveFlag = 0;
         _ctrlStart = true;
         trace(" 小怪进入了ctrlStart且ctrlStart的值已为TRUE");
         if(!firstShowRunAction)
         {
            direction = _monster.x < attackTarget.x;
            _actionCompleteSignal.dispatch();
            firstShowRunAction = !firstShowRunAction;
            _ctrlStart = false;
         }
         direction = _monster.x < attackTarget.x;
         var _loc3_:Number = Math.sqrt(MathHelper.getSquareOfDistAlongTwoPoint(_monster.x,_monster.y,attackTarget.x,attackTarget.y));
         monsterChangeDirection();
         if(_loc3_ <= face_dist)
         {
            if(this._gameWorld.getMap().getMapId() == 203)
            {
               _loc1_ = 1216;
            }
            else
            {
               _loc1_ = this._gameWorld.getMap().mapWidth;
            }
            if(Math.abs(_loc1_ - _monster.data.monster_width - attackTarget.x) < face_dist)
            {
               direction = false;
            }
            else if(Math.abs(attackTarget.x - _monster.data.monster_width) < face_dist)
            {
               direction = true;
            }
            else
            {
               direction = !direction;
            }
         }
      }
      
      public function monsterChangeDirection() : void
      {
         var _loc1_:Boolean = false;
         switch(this._monster.data.spiece_type - 11)
         {
            case 0:
            case 5:
            case 6:
            case 8:
            case 9:
            case 12:
               _loc1_ = true;
         }
         if(direction && _loc1_)
         {
            this._monster.scaleX = Math.abs(this._monster.scaleX);
         }
         else if(!direction && _loc1_)
         {
            this._monster.scaleX = -Math.abs(this._monster.scaleX);
         }
      }
      
      public function set hp(param1:int) : void
      {
         _hp = param1;
         hpBar.hp = _hp;
         if(_hp <= 0)
         {
            angelAction();
            isDie = true;
            _ctrlStart = false;
         }
      }
      
      public function get hp() : int
      {
         return _hp;
      }
      
      private function animationComplete(param1:String) : void
      {
         var status_ary:Array;
         var oldStatus:String;
         var status:String = param1;
         if(status == "angel")
         {
            Starling.juggler.tween(_monster,1,{
               "alpha":0,
               "onComplete":function():void
               {
                  _monster && _monster.removeFromParent(true);
                  hpBar && hpBar.removeFromParent(true);
               }
            });
            return;
         }
         status_ary = ["attack","dizzy","palsy","chain"];
         oldStatus = status;
         if(status_ary.indexOf(status) != -1)
         {
            if(status != "dizzy")
            {
               status = "attack";
            }
            this[status + "Count"]--;
            if(this[status + "Count"] > 0)
            {
               _monster.setStatus(status);
            }
            else
            {
               standAction();
            }
            if(status == "attack")
            {
               _ctrlStart = false;
               attackSignal.dispatch(oldStatus,this);
               if(oldStatus == "chain")
               {
                  _monster.spiderGeneralHit();
               }
               attackTarget.icharacterCtrl.playCry();
               if(this[status + "Count"] == 0)
               {
                  _wantattack = false;
                  _actionCompleteSignal.dispatch();
                  trace("type:",_monster.data.spiece_type,"site:",siteID,"怪物动画播放完成，派发信号");
               }
               standAction();
            }
         }
      }
      
      public function standAction() : void
      {
         if(status != "stand")
         {
            if(SoundManager.actChannel)
            {
               SoundManager.actChannel.stop();
            }
            _monster.setStatus("stand");
            status = "stand";
         }
      }
      
      public function moveAction() : void
      {
         if(status != "move" && !_wantattack)
         {
            _monster.setStatus("move");
            status = "move";
            _moveStartPos = _monster.x;
            _timeToStop = 0;
            attackCount = 0;
            dizzyCount = 0;
         }
      }
      
      public function wantAttack() : void
      {
         if(!_wantattack)
         {
            _wantattack = true;
            standAction();
            trace("小怪进入攻击的状态，它的类型是",_monster.data.spiece_type,"攻击次数:",attackCount,"status",status);
            monsterAttrQueue.push(this);
         }
      }
      
      public function attackAction() : void
      {
         var _loc2_:Character = Character(attackTarget);
         trace("小怪进入了attackAction!!!","status:",status);
         if(_loc2_ == null || attackTarget.icharacterCtrl && attackTarget.icharacterCtrl.hp <= 0)
         {
            _ctrlStart = false;
            standAction();
            _wantattack = false;
            _actionCompleteSignal.dispatch();
            trace("attackAction：目标不存在，派发信号！");
            return;
         }
         var _loc1_:int = this._monster.data.spiece_type;
         if(_loc1_ == 12 && !this._monster.specialHit)
         {
            status = "chain";
         }
         else
         {
            if(_loc1_ != 11)
            {
               gameworld.camera.swapFocus(_monster);
               _monster.setStatus("attack");
               status = "attack";
               attackCount = attackCount + 1;
               return;
            }
            if(_loc2_.badState == "")
            {
               status = "palsy";
            }
            else
            {
               status = "attack";
            }
         }
         gameworld.camera.swapFocus(_monster);
         _monster.setStatus(status);
         attackCount = attackCount + 1;
      }
      
      public function dizzyAction() : void
      {
         if(status != "dizzy")
         {
            _monster.setStatus("dizzy");
            status = "dizzy";
         }
         dizzyCount = dizzyCount + 1;
      }
      
      public function angelAction() : void
      {
         if(status != "angel")
         {
            _monster.setStatus("angel");
            status = "angel";
         }
      }
      
      public function advanceTime(param1:Number) : void
      {
         if(isDie)
         {
            return;
         }
         var _loc2_:String = status;
         if("move" === _loc2_)
         {
            move(param1);
         }
         actionRun();
         changeVisualAngle(_monster);
         updateHpBarPos();
      }
      
      protected function updateHpBarPos() : void
      {
         hpBar.x = _monster.x - (hpBar.width >> 1);
         hpBar.y = _monster.y + hpBar.height;
      }
      
      protected function findAttackTarget() : ICharacter
      {
         var _loc2_:int = 0;
         var _loc1_:ICharacter = null;
         _loc2_ = gameworld.charatersLayer.numChildren - 1;
         while(_loc2_ >= 0)
         {
            _loc1_ = gameworld.charatersLayer.getChildAt(_loc2_) as ICharacter;
            if(_loc1_ is Character)
            {
               return _loc1_;
            }
            _loc2_--;
         }
         return null;
      }
      
      public function findNearestTarget() : ICharacter
      {
         var _loc1_:ICharacter = null;
         var _loc3_:int = 0;
         var _loc5_:* = 9999;
         var _loc2_:int = 0;
         var _loc4_:* = 0;
         _loc3_ = gameworld.charatersLayer.numChildren - 1;
         while(_loc3_ >= 0)
         {
            _loc1_ = gameworld.charatersLayer.getChildAt(_loc3_) as ICharacter;
            if(_loc1_ is Character && _loc1_.icharacterCtrl.hp > 0)
            {
               _loc2_ = Math.abs(_loc1_.x - this._monster.x);
               if(_loc2_ < _loc5_)
               {
                  _loc4_ = _loc3_;
                  _loc5_ = _loc2_;
               }
            }
            _loc3_--;
         }
         _loc1_ = gameworld.charatersLayer.getChildAt(_loc4_) as ICharacter;
         if(_loc1_ is Character)
         {
            return _loc1_;
         }
         return null;
      }
      
      protected function actionRun() : void
      {
         if(!attackTarget || !attackTarget.icharacterCtrl)
         {
            trace("没有攻击目标就发呆");
            attackTarget = findNearestTarget();
            return;
         }
         if(!_ctrlStart)
         {
            return;
         }
         var _loc1_:Number = Math.sqrt(MathHelper.getSquareOfDistAlongTwoPoint(_monster.x,_monster.y,attackTarget.x,attackTarget.y));
         if(_monster.data.attack_type == 1)
         {
            if(_monster.data.spiece_type == 12 && !_monster.specialHit)
            {
               direction = _monster.x < attackTarget.x;
               if(attackTarget.icharacterCtrl.hp > 0)
               {
                  wantAttack();
               }
               else
               {
                  standAction();
               }
               return;
            }
            if(_loc1_ < _monster.data.attack_dist && (_loc1_ > face_dist || _monster.data.attack_dist < face_dist))
            {
               direction = _monster.x < attackTarget.x;
               if(attackTarget.icharacterCtrl.hp > 0)
               {
                  wantAttack();
               }
               else
               {
                  standAction();
               }
            }
            else if(actionPoint == 0)
            {
               _ctrlStart = false;
               standAction();
               _actionCompleteSignal.dispatch();
               trace("actionRun：没有体力值，派发信号");
            }
            else
            {
               moveAction();
            }
         }
         else if(_monster.data.attack_type == 2 || _specailRoleArr.indexOf(_monster.data.spiece_type) != -1)
         {
            if((_monster.data.attack_dist == 0 || _loc1_ < _monster.data.attack_dist) && _loc1_ > face_dist)
            {
               direction = _monster.x < attackTarget.x;
               if(attackTarget.icharacterCtrl.hp > 0)
               {
                  wantAttack();
               }
               else
               {
                  standAction();
               }
            }
            else
            {
               moveAction();
            }
         }
         if(attackTarget.icharacterCtrl && attackTarget.icharacterCtrl.hp <= 0)
         {
            _ctrlStart = false;
            standAction();
            _actionCompleteSignal.dispatch();
            trace("目标死亡，派发信号");
         }
         if(actionPoint <= Math.abs(_moveStartPos - _monster.x))
         {
            actionPoint = 0;
         }
         if(_timeToStop == Math.abs(_moveStartPos - _monster.x) && _moveFlag > 10)
         {
            actionPoint = 0;
         }
         _timeToStop = Math.abs(_moveStartPos - _monster.x);
         _moveFlag = _moveFlag + 1;
      }
      
      public function get gameworld() : IGameWorld
      {
         return _gameWorld;
      }
      
      public function get siteID() : int
      {
         return _siteID;
      }
      
      public function get icharacter() : ICharacter
      {
         return _monster as ICharacter;
      }
      
      public function playCry(param1:Number = 1) : void
      {
         dizzyAction();
      }
      
      public function get actionCompleteSignal() : Signal
      {
         return _actionCompleteSignal;
      }
      
      public function get downStatus() : Boolean
      {
         return _downStart;
      }
      
      public function set downStatus(param1:Boolean) : void
      {
         if(isDie)
         {
            _downStart = false;
         }
         _downStart = param1;
      }
      
      public function get direction() : Boolean
      {
         return _direction;
      }
      
      public function set direction(param1:Boolean) : void
      {
         if(param1 == _direction)
         {
            return;
         }
         if(param1)
         {
            _monster.scaleX = -Math.abs(_monster.scaleX);
         }
         else
         {
            _monster.scaleX = Math.abs(_monster.scaleX);
         }
         _direction = param1;
      }
      
      public function get attackTarget() : ICharacter
      {
         return _attackTarget;
      }
      
      public function set attackTarget(param1:ICharacter) : void
      {
         _attackTarget = param1;
      }
      
      protected function move(param1:Number) : void
      {
         sHelperPoint.setTo(_monster.x,_monster.y);
         if(direction)
         {
            sHelperPoint.x += _monster.data.move_speed * 0.03;
         }
         else
         {
            sHelperPoint.x -= _monster.data.move_speed * 0.03;
         }
         while(_monster.hitMap(sHelperPoint.x,sHelperPoint.y,this._gameWorld.getMap()))
         {
            sHelperPoint.y--;
         }
         sHelperPoint.y++;
         if(Math.abs(_monster.y - sHelperPoint.y) < _monster.bitmapModel.height / 2)
         {
            if(sHelperPoint.x < this._gameWorld.getMap().mapWidth - _monster.data.monster_width && sHelperPoint.x > _monster.data.monster_width)
            {
               _monster.y = sHelperPoint.y;
               _monster.x = sHelperPoint.x;
               downStatus = true;
            }
         }
      }
      
      protected function changeVisualAngle(param1:Monster) : Boolean
      {
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         if(_tmpChangeVisualPoint.x == param1.x && _tmpChangeVisualPoint.y == param1.y)
         {
            return false;
         }
         downStatus = true;
         var _loc4_:BtMap = this.gameworld.getMap();
         var _loc3_:Point = new Point(param1.x - 7,param1.y);
         var _loc2_:int = 15;
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
         _tmpChangeVisualPoint.x = param1.x;
         _tmpChangeVisualPoint.y = param1.y;
         return true;
      }
      
      public function dispose() : void
      {
         _monster && _monster.removeFromParent(true);
         hpBar && hpBar.removeFromParent(true);
         _gameWorld = null;
         _monster = null;
      }
      
      public function get roleAttr() : Array
      {
         if(_roleAttr == null)
         {
            _roleAttr = [_monster.data.attr[1],_monster.data.attr[0],_monster.data.attr[2],_monster.data.attr[3],_monster.data.attr[5],_monster.data.attr[4]];
         }
         return _roleAttr;
      }
      
      public function get hurtfactor() : int
      {
         return 1000;
      }
      
      public function get hurtplus() : int
      {
         return 1000;
      }
      
      public function get isUseAnger() : Boolean
      {
         return false;
      }
   }
}

