package com.boyaa.antwars.view.screen.copygame.boss.member
{
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.game.ICharacter;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.game.IGameWorld;
   import com.boyaa.antwars.view.monster.IMonsterCtrl;
   import com.boyaa.antwars.view.monster.MonsterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.element.HpBar;
   import flash.geom.Point;
   import org.osflash.signals.Signal;
   import starling.animation.IAnimatable;
   import starling.core.Starling;
   
   public class BossCtrl implements IAnimatable, ICharacterCtrl, IMonsterCtrl
   {
      
      public static const ATTACK:String = "attack";
      
      public static const MOVE:String = "move";
      
      public static const DIZZY:String = "dizzy";
      
      public static const DEAD:String = "angel";
      
      public static const ANGEL:String = "angel";
      
      public static const STAND:String = "stand";
      
      protected static var sHelperPoint:Point = new Point();
      
      protected var _gameWorld:IGameWorld;
      
      protected var _monster:BossMonster;
      
      protected var _siteID:int;
      
      protected var _status:String = "stand";
      
      protected var _wantAttack:Boolean = false;
      
      private var _maxHp:int = 0;
      
      protected var _attackState:String = "attack";
      
      protected var _skillArr:Array = [];
      
      protected var _ctrlStart:Boolean = false;
      
      protected var _currentSkill:int = -1;
      
      private var _cdCound:int = 0;
      
      private var _downStatus:Boolean = true;
      
      private var _attackTarget:ICharacter;
      
      private var _attackSignal:Signal;
      
      private var _actionCompleteSignal:Signal;
      
      private var _hp:int;
      
      private var _isDie:Boolean = false;
      
      private var _actionPoint:int;
      
      protected var _hpBar:HpBar;
      
      private var _direction:Boolean = false;
      
      private var _hurtplus:int = 1000;
      
      private var _hurtfactor:int = 1000;
      
      private var _roleAttr:Array = null;
      
      public function BossCtrl(param1:IGameWorld, param2:BossMonster, param3:int)
      {
         super();
         _gameWorld = param1;
         _monster = param2;
         _siteID = param3;
         _monster.bossMonsterCtrl = this;
         _monster.setStatus(_status);
         _monster.animationCompleteSignal.add(animationComplete);
         _attackSignal = new Signal(String,BossCtrl);
         _actionCompleteSignal = new Signal();
         _attackTarget = findOneAttackTarget();
         _hpBar = new HpBar(Assets.sAsset.getTexture("dz50"),108487,_monster.data.blood);
         _gameWorld.ctrlInfoLayer.addChild(_hpBar);
         _hpBar.scaleX = _hpBar.scaleY = 0.8;
         _maxHp = hp = _monster.data.blood;
         if(_monster.data.influ_through == 0)
         {
            _hpBar.visible = false;
         }
      }
      
      public function ctrlStart() : void
      {
         if(_isDie || !_monster)
         {
            trace("角色死亡",_isDie," | 不存在",_monster);
            return;
         }
         _ctrlStart = true;
         direction = _monster.x < _attackTarget.x;
      }
      
      public function setAttackSkill(param1:int) : void
      {
         _currentSkill = param1;
         _attackState = _skillArr[param1];
      }
      
      public function removeMonster() : void
      {
         _monster && _monster.removeFromParent(true);
         _hpBar && _hpBar.removeFromParent(true);
      }
      
      protected function actionRun() : void
      {
         if(!_attackTarget || !_ctrlStart || !_attackTarget.icharacterCtrl)
         {
            return;
         }
         direction = _monster.x < _attackTarget.x;
         if(_attackTarget.icharacterCtrl.hp > 0)
         {
            wantAttack();
         }
         else
         {
            standAction();
         }
         if(_attackTarget.icharacterCtrl.hp <= 0)
         {
            _ctrlStart = false;
            standAction();
            _actionCompleteSignal.dispatch();
         }
      }
      
      protected function findOneAttackTarget() : ICharacter
      {
         var _loc2_:int = 0;
         var _loc1_:ICharacter = null;
         _loc2_ = 0;
         while(_loc2_ < _gameWorld.charatersLayer.numChildren - 1)
         {
            _loc1_ = _gameWorld.charatersLayer.getChildAt(_loc2_) as ICharacter;
            if(_loc1_ is Character)
            {
               return _loc1_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function setHpBarVisible(param1:Boolean = true) : void
      {
         _hpBar.visible = param1;
      }
      
      protected function updateHpBarPos() : void
      {
         _hpBar.x = _monster.x - (_hpBar.width >> 1);
         _hpBar.y = _monster.y + _hpBar.height * 2;
      }
      
      protected function animationComplete(param1:String) : void
      {
         if(param1 == "angel")
         {
            Starling.juggler.tween(_monster,1,{
               "alpha":0,
               "onComplete":removeMonster
            });
            return;
         }
         if(param1.indexOf("stand") != -1)
         {
            standAction();
         }
         else if(param1.indexOf("move") != -1)
         {
            moveAction();
         }
         else
         {
            _ctrlStart = false;
            _attackSignal.dispatch(param1,this);
            if(_wantAttack)
            {
               _wantAttack = false;
               _actionCompleteSignal.dispatch();
               trace("BOSS动作完成，派发攻击信号，World开始处理掉血");
               cdCound = cdCound + 1;
            }
            standAction();
         }
      }
      
      protected function angelAction() : void
      {
         if(_status != "angel")
         {
            _monster.setStatus("angel");
            _status = "angel";
         }
      }
      
      protected function wantAttack() : void
      {
         if(!_wantAttack)
         {
            _wantAttack = true;
            standAction();
            trace("BOSS进入攻击状态，它的类型是",_monster.data.spiece_type);
            MonsterCtrl.monsterAttrQueue.push(this);
         }
      }
      
      protected function dizzyAction() : void
      {
         if(_status != "dizzy")
         {
            _monster.setStatus("dizzy");
            _status = "dizzy";
         }
      }
      
      protected function standAction() : void
      {
         if(_status != "stand")
         {
            _monster.setStatus("stand");
            _status = "stand";
         }
      }
      
      protected function moveAction() : void
      {
         if(_status != "move")
         {
            _monster.setStatus("move");
            _status = "move";
         }
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
      
      public function get downStatus() : Boolean
      {
         return _downStatus;
      }
      
      public function set downStatus(param1:Boolean) : void
      {
         _downStatus = param1;
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
         return _hurtfactor;
      }
      
      public function get hurtplus() : int
      {
         return _hurtplus;
      }
      
      public function get isUseAnger() : Boolean
      {
         return false;
      }
      
      public function get attackSignal() : Signal
      {
         return _attackSignal;
      }
      
      public function get actionCompleteSignal() : Signal
      {
         return _actionCompleteSignal;
      }
      
      public function get hp() : int
      {
         return _hp;
      }
      
      public function set hp(param1:int) : void
      {
         _hp = param1;
         _hpBar.hp = _hp;
         if(_hp <= 0)
         {
            angelAction();
            _isDie = true;
            _ctrlStart = false;
         }
      }
      
      public function get cdCound() : int
      {
         return _cdCound;
      }
      
      public function set cdCound(param1:int) : void
      {
         _cdCound = param1;
      }
      
      public function get maxHp() : int
      {
         return _maxHp;
      }
      
      public function get direction() : Boolean
      {
         return _direction;
      }
      
      public function set direction(param1:Boolean) : void
      {
         if(_direction == param1)
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
      
      public function get currentSkill() : int
      {
         return _currentSkill;
      }
      
      public function get monster() : BossMonster
      {
         return _monster;
      }
      
      public function playCry(param1:Number = 1) : void
      {
         dizzyAction();
      }
      
      public function monsterChangeDirection() : void
      {
         var _loc1_:Boolean = false;
         switch(this._monster.data.spiece_type - 27)
         {
            case 0:
               _loc1_ = true;
         }
         if(!_loc1_)
         {
            return;
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
      
      public function advanceTime(param1:Number) : void
      {
         if(_isDie)
         {
            return;
         }
         actionRun();
         updateHpBarPos();
      }
      
      public function attackAction() : void
      {
         var _loc1_:Character = _attackTarget as Character;
         trace("Boss\'name ",_monster.bossName,"BossMonsterCtrl-attackAction，当前状态 " + _attackState + " !");
         _gameWorld.camera.swapFocus(_monster);
         _status = _attackState;
         _monster.isAttack = true;
         _monster.setStatus(_attackState);
      }
      
      public function dispose() : void
      {
      }
   }
}

