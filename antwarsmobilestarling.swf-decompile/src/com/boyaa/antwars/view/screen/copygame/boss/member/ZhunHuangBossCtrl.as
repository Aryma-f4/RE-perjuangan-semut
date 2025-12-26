package com.boyaa.antwars.view.screen.copygame.boss.member
{
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.model.CopyDetailData;
   import com.boyaa.antwars.view.game.IGameWorld;
   import com.boyaa.antwars.view.monster.MonsterCtrl;
   import com.boyaa.antwars.view.screen.copygame.boss.ZhunhuangWorld;
   import flash.utils.Dictionary;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   
   public class ZhunHuangBossCtrl extends BossCtrl
   {
      
      public static const STAND:String = "STAND";
      
      public static const IMPALE:String = "IMPALE";
      
      public static const ADDHP:String = "addHp";
      
      public static const DIZZY:String = "DIZZY";
      
      public static const BITE:String = "BITE";
      
      public static const FLASH:String = "FLASH";
      
      public static const LANDSTAND:String = "landstand";
      
      public static const LANDIMPALE:String = "landimpale";
      
      public static const LANDDIZZY:String = "landdizzy";
      
      public static const LANDBITE:String = "landbite";
      
      public static const LANDFLASH:String = "landflash";
      
      public static const HANGSTAND:String = "hangstand";
      
      public static const HANGATTACK:String = "hangfire";
      
      public static const HANGFLASH:String = "hangflash";
      
      public static const HANGCALL:String = "hangcall";
      
      public static const HANGBITE:String = "hangbite";
      
      public static const HANGBUFF:String = "hangbuff";
      
      public static const HANGDROPANDSICK:String = "hangdropAndSike";
      
      public static const HANGDROP:String = "hangdrop";
      
      public static const HANGDIZZY:String = "hangdizzy";
      
      public static const WILDSTAND:String = "wildstand";
      
      public static const WILDIMPALE:String = "wildimpale";
      
      public static const WILDBITE:String = "wildbite";
      
      public static const WILDFLASH:String = "wildflash";
      
      public static const WILDDIZZY:String = "wilddizzy";
      
      public static const ANGEL:String = "angel";
      
      public static const INIT:String = "INIT";
      
      public static const HANG:String = "HANG";
      
      public static const LAND:String = "LAND";
      
      public static const WILD:String = "WILD";
      
      public static const skillArr:Array = [["hangcall","hangflash"],["hangcall","hangflash"],["hangcall","landflash","hangfire","landimpale"],["hangcall","hangbuff","wildflash","hangfire","wildimpale"]];
      
      private var _callMonsterSignal:Signal;
      
      private var _hpArr:Array = [0.7,0.4,0.3,0];
      
      private var _spiderZhunHuangStatusArr:Array = ["INIT","HANG","LAND","WILD"];
      
      private var _currentState:String = "INIT";
      
      private var _dictionary:Dictionary;
      
      private var _colorFlag:uint = 1;
      
      private var _attackArr:Array = [];
      
      private var _oldAttackStatus:String = "INIT";
      
      private var _currentCD:int = 0;
      
      public function ZhunHuangBossCtrl(param1:IGameWorld, param2:BossMonster, param3:int)
      {
         super(param1,param2,param3);
         _monster.setStatus("hangstand");
         _skillArr = ["hangcall","hangflash","hangfire","hangbuff","landimpale","landflash","wildflash","wildimpale"];
         _attackState = "BITE";
         setDictionary();
      }
      
      private function setDictionary() : void
      {
         _dictionary = new Dictionary();
         _dictionary["hangflash"] = 1;
         _dictionary["landflash"] = 1;
         _dictionary["wildflash"] = 1;
         _dictionary["hangfire"] = 2;
         _dictionary["landimpale"] = 1;
         _dictionary["wildimpale"] = 1;
         _dictionary["hangcall"] = 4;
         _dictionary["hangbuff"] = 1;
      }
      
      override protected function standAction() : void
      {
         if(_currentState == "INIT" && _status != "hangstand")
         {
            _monster.setStatus("hangstand");
            _status = "hangstand";
         }
         else if(_status != ZhunHuangBossCtrl[_currentState + "STAND"])
         {
            _monster.setStatus(ZhunHuangBossCtrl[_currentState + "STAND"]);
            _status = ZhunHuangBossCtrl[_currentState + "STAND"];
         }
      }
      
      override protected function dizzyAction() : void
      {
         if(_currentState == "INIT")
         {
            _monster.setStatus("hangdizzy");
            _status = "hangdizzy";
         }
         else
         {
            _monster.setStatus(ZhunHuangBossCtrl[_currentState + "DIZZY"]);
            _status = ZhunHuangBossCtrl[_currentState + "DIZZY"];
         }
      }
      
      public function getHpPercentage() : Number
      {
         var _loc4_:int = 0;
         var _loc2_:Array = null;
         var _loc1_:Number = hp / maxHp;
         var _loc3_:CopyDetailData = CopyList.instance.currentCopyData;
         _loc4_ = 0;
         while(_loc4_ < _hpArr.length)
         {
            if(_loc1_ > _hpArr[_loc4_])
            {
               _currentState = _spiderZhunHuangStatusArr[_loc4_];
               if(_currentState == "WILD" && _loc3_.difficulty == 1)
               {
                  _currentState = "LAND";
               }
               if(_currentState == "WILD" && _colorFlag)
               {
                  _loc2_ = [1,0,0,0,96,0,1,0,0,-77,0,0,1,0,-118,0,0,0,1,0];
                  _monster.setMonsterColor(["head","headTop","body","leftProtect","rightProtect","leftLeg1","leftSmallLeg1","leftLeg2","leftSmallLeg2","leftLeg3","leftSmallLeg3","rightLeg1","rightLeg2","rightLeg3"],_loc2_);
                  _loc2_ = [0.34,0,0,0,91,0,0.26,0,0,-11,0,0,0.54,0,35,0,0,0,0.64,0];
                  _monster.setMonsterColor(["breath","breath"],_loc2_);
                  _colorFlag = 0;
               }
               return _hpArr[_loc4_];
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      override protected function wantAttack() : void
      {
         if(_oldAttackStatus != _currentState)
         {
            _oldAttackStatus = _currentState;
            _attackArr = [];
            cdCound = 0;
         }
         if(_attackArr.length == 0)
         {
            for each(var _loc1_ in skillArr[_spiderZhunHuangStatusArr.indexOf(_currentState)])
            {
               _attackArr.push(_loc1_);
            }
         }
         if(!_wantAttack)
         {
            _wantAttack = true;
            standAction();
            trace("尊皇进入了想要攻击的状态----------------------");
            MonsterCtrl.monsterAttrQueue.push(this);
         }
      }
      
      private function isSkillPlay(param1:Array) : String
      {
         return "";
      }
      
      public function flashAndKill() : void
      {
         gameworld.camera.swapFocus(_monster);
         var _loc1_:int = 1;
         _loc1_ = 1;
         _loc1_ = -1;
         direction ? _loc1_ : (_loc1_);
         var _loc2_:String = _status.substr(0,4);
         if(_loc2_ == "hang")
         {
            _monster.x = attackTarget.x + 15;
            _monster.y = attackTarget.y - attackTarget.bitmapRectangle.height - 20;
         }
         else
         {
            _monster.x = attackTarget.x + _loc1_ * (attackTarget.bitmapRectangle.width + _monster.bitmapRectangle.width / 3);
            _monster.y = attackTarget.y + attackTarget.bitmapRectangle.height / 3;
         }
         _monster.setStatus(_loc2_ + "bite");
      }
      
      override public function attackAction() : void
      {
         super.attackAction();
         if(_status == "hangcall")
         {
            Starling.juggler.delayCall((function():*
            {
               var call:Function;
               return call = function():void
               {
                  ZhunhuangWorld(gameworld).flushMonster();
               };
            })(),1);
         }
      }
      
      public function get currentState() : String
      {
         return _currentState;
      }
      
      public function setState(param1:int) : void
      {
         if(param1 > 3)
         {
            return;
         }
         _currentState = _spiderZhunHuangStatusArr[param1];
      }
      
      public function get spiderZhunHuangStatusArr() : Array
      {
         return _spiderZhunHuangStatusArr;
      }
   }
}

