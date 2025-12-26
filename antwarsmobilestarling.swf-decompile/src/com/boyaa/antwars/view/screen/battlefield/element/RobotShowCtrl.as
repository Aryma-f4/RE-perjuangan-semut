package com.boyaa.antwars.view.screen.battlefield.element
{
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterCtrl;
   import com.boyaa.antwars.view.game.ICharacter;
   import com.boyaa.antwars.view.game.IGameWorld;
   import starling.core.Starling;
   import starling.display.Image;
   
   public class RobotShowCtrl extends CharacterCtrl
   {
      
      public static const USE:String = "use";
      
      public static const MAXPOWER:int = 15;
      
      public static const COUNT:int = 5;
      
      private var _actionPoint:int = 15;
      
      private var _offist:int = -1;
      
      protected var _setpData:Array = [];
      
      protected var focus:Image;
      
      protected var focusK:int = 0;
      
      protected var dk:Boolean = true;
      
      protected var _attackTarget:ICharacter;
      
      private var _round:int = 0;
      
      private var _bloodBox:int = 3;
      
      protected var _time:Number = 0;
      
      public function RobotShowCtrl(param1:IGameWorld, param2:Character, param3:int, param4:int, param5:String = "leoluo")
      {
         super(param1,param2,param3,param4,param5);
         initFocus();
      }
      
      private function initFocus() : void
      {
         focus = new Image(Assets.sAsset.getTexture("focus"));
         focus.scaleY = focus.scaleX = 0.5;
      }
      
      override public function ctrlStart(param1:Boolean) : void
      {
         isCtrl = param1;
         if(param1)
         {
            _round = _round + 1;
            _actionPoint = 15;
            this.gameworld.ctrlInfoLayer.addChild(focus);
            focus.visible = true;
            if(character)
            {
               direction = _attackTarget.x > character.x;
            }
         }
         else
         {
            this.gameworld.ctrlInfoLayer.removeChild(focus);
            focus.visible = false;
         }
         super.ctrlStart(param1);
      }
      
      public function addSetpData(param1:Array) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _setpData.push(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      protected function showFocusAni() : void
      {
         if(focus.parent)
         {
            focus.x = character.x - (focus.width >> 1);
            focus.y = character.y - character.height - focus.height - focusK;
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
         }
      }
      
      override protected function advanceTimeHook(param1:Number) : void
      {
         var step:Array;
         var i:int;
         var time:Number = param1;
         if(isCtrl)
         {
            showFocusAni();
         }
         if(_setpData.length == 0 || !isCtrl)
         {
            return;
         }
         if(_time < 2)
         {
            _time += time;
            return;
         }
         dropPower();
         _time = 0;
         step = _setpData.shift();
         switch(step[0])
         {
            case MOVE:
               if(this.status != MOVE)
               {
                  this.changeStatus(MOVE);
               }
               if(this.character.x > step[1] + 2 || this.character.x < step[1] - 2)
               {
                  _setpData.unshift(step);
               }
               break;
            case SHOOT:
               if(this.status != SHOOT)
               {
                  shootTarget();
               }
               _setpData.unshift(step);
               break;
            case "use":
               i = 1;
               while(i < step.length)
               {
                  if(_actionPoint <= -1)
                  {
                     break;
                  }
                  useSkill(step[i]);
                  i = i + 1;
               }
               Starling.juggler.delayCall(function():void
               {
                  shootTarget(offist);
               },1.5);
         }
      }
      
      override protected function shootComplete() : void
      {
         changeStatus(TARGET);
         ctrlStart(false);
         _setpData.shift();
         super.shootComplete();
      }
      
      private function shootTarget(param1:int = -1) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc6_:Number = NaN;
         this.character.setFiringPoint();
         this.direction = this._attackTarget.x > this.character.x;
         _loc2_ = _attackTarget.x - character.firingPoint.x;
         _loc3_ = character.firingPoint.y - _attackTarget.y;
         var _loc5_:Number = character.rotation * 180 / 3.141592653589793;
         if(_loc3_ > 200)
         {
            _loc6_ = direction ? 75 - _loc5_ : 180 - (75 + _loc5_);
         }
         else
         {
            _loc6_ = direction ? 45 - _loc5_ : 180 - (45 + _loc5_);
         }
         var _loc4_:Number = MathHelper.getVelocity(_loc2_,_loc3_,_loc6_);
         if(param1 == -1)
         {
            _loc4_ = _loc4_ + MathHelper.randomWithinRange(0,5) - 2;
         }
         else
         {
            _loc4_ = _loc4_ + param1 - 2;
         }
         this.character.angle = _loc6_;
         this.character.velocity = _loc4_;
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
      
      private function useSkill(param1:Number) : void
      {
         param1 = Math.round(param1);
         super.useProp(param1);
         switch(param1)
         {
            case 11:
               this.hp += 500;
               break;
            case 12:
               this.hp += 300;
         }
         battlefield.UILayer.updateCharHP(this.siteID,this.hp);
         dropPower();
      }
      
      public function getRobotFightData() : Array
      {
         var _loc3_:Number = Math.abs(this.character.x - _attackTarget.x);
         var _loc2_:Number = Math.abs(this.character.y - _attackTarget.y);
         offist = MathHelper.randomWithinRange(0,5);
         var _loc1_:Array = [[["use",randNum()]],offist];
         if(this.hp < this.maxHp * 0.5)
         {
            if(_bloodBox == 0)
            {
               _loc1_ = [[["use",randNum(),randNum(),randNum()]],offist];
            }
            else
            {
               _bloodBox = _bloodBox - 1;
               _loc1_ = [[["use",11,randNum()]],offist];
            }
         }
         else if(Math.random() <= 0.2 && _round % 2 == 0)
         {
            _loc1_ = [[["use",10]],offist];
         }
         return _loc1_;
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
      
      public function get offist() : int
      {
         return _offist;
      }
      
      public function set offist(param1:int) : void
      {
         _offist = param1;
      }
      
      public function get attackTarget() : ICharacter
      {
         return _attackTarget;
      }
      
      public function set attackTarget(param1:ICharacter) : void
      {
         _attackTarget = param1;
      }
   }
}

