package com.boyaa.antwars.view.monster
{
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.game.GameWorld;
   import com.boyaa.antwars.view.game.IGameWorld;
   import com.boyaa.antwars.view.screen.copygame.game.CopyGameWorld;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.utils.deg2rad;
   
   public class EggCtrl extends MonsterCtrl
   {
      
      private var angleArr:Array = [5,-10,-5,20,13,20,-19,3,-1,7,-10];
      
      private var monsterPoint:Point;
      
      private var monsterWidth:int;
      
      public function EggCtrl(param1:IGameWorld, param2:Monster, param3:int)
      {
         super(param1,param2,param3);
         param2.rotation = deg2rad(angleArr[param2.monsterCtrl.siteID - 1]);
         hpBar.visible = false;
         monsterPoint = new Point();
         monsterWidth = _monster.width / 10;
      }
      
      override public function ctrlStart() : void
      {
         if(isDie)
         {
            return;
         }
      }
      
      override public function advanceTime(param1:Number) : void
      {
         if(isDie)
         {
            return;
         }
         actionRun();
         hitTestEgg();
      }
      
      override protected function actionRun() : void
      {
         if(!attackTarget)
         {
            return;
         }
         if(!_ctrlStart)
         {
            if((_gameWorld as CopyGameWorld).monsterAttack)
            {
               _actionCompleteSignal.dispatch();
            }
            return;
         }
      }
      
      public function hitTestEgg() : void
      {
         var _loc1_:Character = (_gameWorld as GameWorld).selfCharacterCtrl.character;
         if(_monster && _loc1_)
         {
            monsterPoint.x = _monster.x;
            monsterPoint.y = _monster.y;
            if(MathHelper.check_circleAndRectangle(monsterPoint,monsterWidth,_loc1_.bitmapRectangle))
            {
               Starling.juggler.tween(_monster,0.5,{
                  "alpha":0,
                  "onComplete":onTweenComplete
               });
            }
         }
      }
      
      private function onTweenComplete() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         Starling.juggler.removeTweens(_monster);
         if(_monster)
         {
            _loc1_ = (_gameWorld as CopyGameWorld).getMonsters();
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               if(_monster.monsterCtrl == _loc1_[_loc2_])
               {
                  _loc1_.splice(_loc2_,1);
                  (_gameWorld as CopyGameWorld).allMonsters--;
                  if(_loc1_.length == 0)
                  {
                     isDie = true;
                     SoundManager.playSound("sound 27");
                     (_gameWorld as CopyGameWorld).gameOver(true);
                  }
                  CopyGameWorld(_gameWorld).showLeftNumText();
               }
               _loc2_++;
            }
            _monster.removeFromParent(true);
         }
      }
   }
}

