package com.boyaa.antwars.view.screen.copygame.game
{
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterCtrl;
   import com.boyaa.antwars.view.game.ICharacter;
   import com.boyaa.antwars.view.game.IGameWorld;
   import starling.core.Starling;
   import starling.filters.ColorMatrixFilter;
   
   public class CopyGameRobotCtrl extends CharacterCtrl
   {
      
      public static const MAXPOWER:int = 15;
      
      public static const COUNT:int = 5;
      
      public static const USE:String = "use";
      
      private var _stepData:Array = [];
      
      private var _attackTarget:ICharacter;
      
      private var hpBottle:int = 3;
      
      private var _actionPoint:int = 15;
      
      private var usePlane:Boolean = false;
      
      private var colorFilter:ColorMatrixFilter;
      
      private var _shootMiss:int = 0;
      
      private var _time:Number = 0;
      
      public function CopyGameRobotCtrl(param1:IGameWorld, param2:Character, param3:int, param4:int, param5:String)
      {
         super(param1,param2,param3,param4,param5);
         direction = false;
      }
      
      public function setColorMatrixFilter(param1:Number = -1) : void
      {
         colorFilter = new ColorMatrixFilter();
         colorFilter.adjustSaturation(param1);
         this.character.filter = colorFilter;
      }
      
      override public function setAttr() : void
      {
         var _loc1_:PlayerData = PlayerDataList.instance.getDataBySiteID(_attackTarget.icharacterCtrl.siteID);
         if(_loc1_)
         {
            _roleAttr = _loc1_.ability();
         }
         else
         {
            _roleAttr = [100,50,261,60,237,183,340,253,0];
         }
      }
      
      override public function ctrlStart(param1:Boolean) : void
      {
         if(param1)
         {
            _actionPoint = 15;
            selectAction();
            if(!character)
            {
               return;
            }
            direction = _attackTarget.x > character.x;
         }
         super.ctrlStart(param1);
      }
      
      private function selectAction() : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = Math.abs(this.character.x - _attackTarget.x);
         var _loc1_:Number = Math.abs(this.character.y - _attackTarget.y);
         if(shootMiss >= 2)
         {
            addStepData([["use",10]]);
            shootMiss = 0;
         }
         else if(this.hp < this.maxHp * 0.5)
         {
            if(this.hp < this.maxHp * 0.2)
            {
               addStepData([["use",11,99,randNum(),randNum()]]);
            }
            else
            {
               addStepData([["use",11,randNum(),randNum()]]);
            }
         }
         else if(_loc2_ > 700)
         {
            if(CopyList.instance.currentCopyData.mapid == 1002)
            {
               if(_loc1_ > 300 && _loc2_ <= 100)
               {
                  addStepData([["use",10]]);
               }
               else
               {
                  addStepData([["use",randNum(8),randNum(8)]]);
               }
            }
            else
            {
               addStepData([["use",10]]);
            }
         }
         else if(_loc2_ <= 100)
         {
            _loc3_ = 100;
            if(this.character.x - _attackTarget.x > 0 || this.character.x <= 100)
            {
               _loc3_ = Math.abs(_loc3_);
            }
            else
            {
               _loc3_ = -Math.abs(_loc3_);
            }
            if(this.character.x >= 1200)
            {
               _loc3_ = -Math.abs(_loc3_);
            }
            addStepData([[MOVE,_attackTarget.x + _loc3_]]);
         }
         else if(this.hp > this.maxHp * 0.75)
         {
            addStepData([["use",randNum(8)]]);
         }
         else if(this.hp >= this.maxHp * 0.5 && this.hp <= this.maxHp * 0.75)
         {
            addStepData([["use",randNum(5),randNum(5),randNum(5)]]);
         }
      }
      
      public function addStepData(param1:Array) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _stepData.push(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      override protected function advanceTimeHook(param1:Number) : void
      {
         var step:Array;
         var i:int;
         var time:Number = param1;
         if(_stepData.length == 0 || !isCtrl)
         {
            return;
         }
         if(_time < 2)
         {
            _time += time;
            return;
         }
         dropPower();
         if(_actionPoint <= 0)
         {
            shootTarget();
            _actionPoint = 15;
            return;
         }
         _time = 0;
         step = _stepData.shift();
         switch(step[0])
         {
            case MOVE:
               if(this.status != MOVE)
               {
                  this.changeStatus(MOVE);
               }
               if(this.character.x > step[1] + 2 || this.character.x < step[1] - 2)
               {
                  _stepData.unshift(step);
               }
               break;
            case SHOOT:
               if(this.status != SHOOT)
               {
                  shootTarget();
               }
               _stepData.unshift(step);
               break;
            case "use":
               i = 1;
               while(i < step.length)
               {
                  if(_actionPoint <= -1)
                  {
                     break;
                  }
                  if(!(step[i] == 11 && hpBottle <= 0))
                  {
                     useSkill(step[i]);
                  }
                  i = i + 1;
               }
               Starling.juggler.delayCall(function():void
               {
                  shootTarget();
               },1.5);
         }
      }
      
      override protected function shootComplete() : void
      {
         changeStatus(TARGET);
         ctrlStart(false);
         _stepData.shift();
         super.shootComplete();
      }
      
      public function set attackTarget(param1:ICharacter) : void
      {
         _attackTarget = param1;
      }
      
      public function get shootMiss() : int
      {
         return _shootMiss;
      }
      
      public function set shootMiss(param1:int) : void
      {
         _shootMiss = param1;
      }
      
      public function countShoot(param1:int = 0) : void
      {
         if(param1 == 0)
         {
            shootMiss = shootMiss + 1;
         }
         else
         {
            shootMiss = 0;
         }
      }
      
      private function useSkill(param1:Number) : void
      {
         param1 = Math.round(param1);
         super.useProp(param1);
         switch(param1)
         {
            case 11:
               this.hp += 500;
               hpBottle = hpBottle - 1;
               break;
            case 12:
               this.hp += 300;
         }
         battlefield.UILayer.updateCharHP(this.siteID,this.hp);
         dropPower();
      }
      
      private function shootTarget() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc5_:Number = NaN;
         this.character.setFiringPoint();
         this.direction = this._attackTarget.x > this.character.x;
         _loc1_ = _attackTarget.x - character.firingPoint.x;
         _loc2_ = character.firingPoint.y - _attackTarget.y;
         var _loc4_:Number = character.rotation * 180 / 3.141592653589793;
         if(_loc2_ > 200)
         {
            _loc5_ = direction ? 75 - _loc4_ : 180 - (75 + _loc4_);
         }
         else
         {
            _loc5_ = direction ? 45 - _loc4_ : 180 - (45 + _loc4_);
         }
         var _loc3_:Number = MathHelper.getVelocity(_loc1_,_loc2_,_loc5_);
         _loc3_ = _loc3_ + MathHelper.randomWithinRange(0,5) - 2;
         this.character.angle = _loc5_;
         this.character.velocity = _loc3_;
         this.changeStatus(SHOOT);
         ctrlStart(false);
      }
      
      private function dropPower(param1:int = -1) : void
      {
         if(param1 == -1)
         {
            _actionPoint -= 5;
         }
         else
         {
            _actionPoint -= param1;
         }
      }
      
      private function randNum(param1:Number = 3, param2:Number = 0) : Number
      {
         var _loc3_:Number = 0;
         _loc3_ = Math.random() * param1 + param2;
         while(_loc3_ >= 3.5 && _loc3_ < 4.5 || _loc3_ >= 1.5 && _loc3_ < 2.5)
         {
            _loc3_ = Math.random() * param1 + param2;
         }
         return _loc3_;
      }
   }
}

