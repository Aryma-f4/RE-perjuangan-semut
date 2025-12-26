package com.boyaa.antwars.view.screen.battlefield.element
{
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterCtrl;
   import com.boyaa.antwars.view.game.ICharacter;
   import com.boyaa.antwars.view.game.IGameWorld;
   import starling.display.Image;
   
   public class RobotCharacterCtrl extends CharacterCtrl
   {
      
      protected var _setpData:Array = [];
      
      protected var focus:Image;
      
      protected var focusK:int = 0;
      
      protected var dk:Boolean = true;
      
      protected var _attackTarget:ICharacter;
      
      protected var _time:Number = 0;
      
      public function RobotCharacterCtrl(param1:IGameWorld, param2:Character, param3:int, param4:int, param5:String)
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
         if(param1)
         {
            this.gameworld.ctrlInfoLayer.addChild(focus);
            focus.visible = true;
            addSetpData([[SHOOT]]);
            if(!character)
            {
               return;
            }
            direction = _attackTarget.x > character.x;
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
      
      override protected function advanceTimeHook(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc5_:Number = NaN;
         if(_setpData.length == 0 || !isCtrl)
         {
            return;
         }
         showFocusAni();
         if(_time < 3)
         {
            _time += param1;
            return;
         }
         _time = 0;
         var _loc4_:Array;
         switch((_loc4_ = _setpData.shift())[0])
         {
            case MOVE:
               if(this.status != MOVE)
               {
                  this.changeStatus(MOVE);
               }
               if(this.character.x > _loc4_[1])
               {
                  this.direction = false;
               }
               else
               {
                  this.direction = true;
               }
               if(this.character.x > _loc4_[1] + 2 || this.character.x < _loc4_[1] - 2)
               {
                  _setpData.unshift(_loc4_);
               }
               break;
            case SHOOT:
               if(this.status != SHOOT)
               {
                  this.character.setFiringPoint();
                  _loc2_ = _attackTarget.x - character.firingPoint.x;
                  _loc3_ = character.firingPoint.y - _attackTarget.y;
                  _loc6_ = character.rotation * 180 / 3.141592653589793;
                  _loc7_ = direction ? 45 - _loc6_ : 180 - (45 + _loc6_);
                  _loc5_ = MathHelper.getVelocity(_loc2_,_loc3_,_loc7_);
                  _loc5_ = _loc5_ + MathHelper.randomWithinRange(0,5) - 2;
                  this.character.angle = _loc7_;
                  this.character.velocity = _loc5_;
                  this.changeStatus(SHOOT);
                  ctrlStart(false);
               }
               _setpData.unshift(_loc4_);
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
      
      override protected function shootComplete() : void
      {
         changeStatus(TARGET);
         ctrlStart(false);
         _setpData.shift();
         super.shootComplete();
      }
      
      public function set attackTarget(param1:ICharacter) : void
      {
         _attackTarget = param1;
      }
   }
}

