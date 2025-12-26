package com.boyaa.antwars.view.screen.copygame.boss.member
{
   import com.boyaa.antwars.view.game.IGameWorld;
   import starling.core.Starling;
   
   public class ScorpionKindCtrl extends BossCtrl
   {
      
      public static const NORMAL_ATTACK:String = "attack0";
      
      public static const SHADOW_ATTACK:String = "attack1";
      
      public static const TAIL_ATTACK:String = "attack2";
      
      public static const SKILL0:int = 0;
      
      public static const SKILL1:int = 1;
      
      public static const SKILL2:int = 2;
      
      public function ScorpionKindCtrl(param1:IGameWorld, param2:BossMonster, param3:int)
      {
         super(param1,param2,param3);
         _monster.setStatus("stand");
         initSkillArr();
         monsterChangeDirection();
      }
      
      private function initSkillArr() : void
      {
         _skillArr[0] = "attack0";
         _skillArr[1] = "attack1";
         _skillArr[2] = "attack2";
      }
      
      override public function attackAction() : void
      {
         super.attackAction();
         _gameWorld.camera.swapFocus(_monster);
         monsterChangeDirection();
         Starling.juggler.delayCall((function():*
         {
            var delay:Function;
            return delay = function():void
            {
               _gameWorld.camera.swapFocus(attackTarget);
            };
         })(),0.7);
      }
      
      override protected function updateHpBarPos() : void
      {
         super.updateHpBarPos();
         _hpBar.y = _monster.y + _hpBar.height * 4;
      }
   }
}

