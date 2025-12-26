package com.boyaa.antwars.view.screen.battlefield.element
{
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterCtrl;
   import com.boyaa.antwars.view.game.IGameWorld;
   import com.boyaa.antwars.view.screen.battlefield.element.bullet.BulletSlottingManager;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.Image;
   
   public class OtherCharacterCtrl extends CharacterCtrl
   {
      
      protected var _setpData:Array = [];
      
      private var focus:Image;
      
      private var focusK:int = 0;
      
      private var dk:Boolean = true;
      
      private var _shootArr:Dictionary = new Dictionary();
      
      private var _selfCount:int = -1;
      
      public function OtherCharacterCtrl(param1:IGameWorld, param2:Character, param3:int, param4:int, param5:String)
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
         if(!param1)
         {
            Starling.juggler.delayCall(super.ctrlStart,1,param1);
            this.gameworld.ctrlInfoLayer.removeChild(focus);
            focus.visible = false;
            BulletSlottingManager.instance.shootStartSignal.remove(beginShoot);
         }
         else
         {
            _selfCount = _selfCount + 1;
            super.ctrlStart(param1);
            this.gameworld.ctrlInfoLayer.addChild(focus);
            focus.visible = true;
            BulletSlottingManager.instance.shootStartSignal.addOnce(beginShoot);
         }
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
      
      override public function advanceTime(param1:Number) : void
      {
         var _loc2_:Array = null;
         if(_setpData.length != 0)
         {
            _loc2_ = _setpData.shift();
            if(_loc2_[0] == 0)
            {
               if(this.status != MOVE)
               {
                  this.changeStatus(MOVE);
               }
               character.x = _loc2_[1];
               character.y = _loc2_[2];
               this.direction = _loc2_[3];
            }
            else if(_loc2_[0] == 1)
            {
               if(this.status != TARGET)
               {
                  this.changeStatus(TARGET);
               }
               character.x = _loc2_[1];
               character.y = _loc2_[2];
               character.angle = _loc2_[3];
               character.velocity = _loc2_[4];
            }
            else if(_loc2_[0] == 2)
            {
               if(this.status != SHOOT)
               {
                  if(Application.instance.currentGame.navigator.activeScreenID == "BATTLEFIELD" || Application.instance.currentGame.navigator.activeScreenID == "ROBOT_2VS2_BATTLEFIELD")
                  {
                     _shootArr[_selfCount] = _loc2_;
                  }
                  else
                  {
                     character.setFiringPoint();
                     character.x = _loc2_[1];
                     character.y = _loc2_[2];
                     character.angle = _loc2_[3];
                     character.velocity = _loc2_[4];
                     changeStatus(SHOOT);
                     ctrlStart(false);
                  }
               }
            }
            this._downStart = true;
         }
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
         super.update(param1);
      }
      
      private function beginShoot(param1:Object) : void
      {
         var _loc2_:Array = _shootArr[_selfCount];
         character.setFiringPoint();
         character.x = _loc2_[1];
         character.y = _loc2_[2];
         character.angle = _loc2_[3];
         character.velocity = _loc2_[4];
         changeStatus(SHOOT);
         ctrlStart(false);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         BulletSlottingManager.instance.shootStartSignal.remove(beginShoot);
      }
   }
}

