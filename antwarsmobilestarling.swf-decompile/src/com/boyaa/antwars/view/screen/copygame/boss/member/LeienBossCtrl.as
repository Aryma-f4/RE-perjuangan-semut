package com.boyaa.antwars.view.screen.copygame.boss.member
{
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.game.IGameWorld;
   import com.boyaa.antwars.view.screen.copygame.boss.BossWorld;
   import starling.core.Starling;
   
   public class LeienBossCtrl extends BossCtrl
   {
      
      public static const SKILL:String = "skill0";
      
      public static const NORMALSKILL:int = 0;
      
      public static const STAR_RAIN:int = 1;
      
      public static const TORNADO:int = 2;
      
      public static const SKILL0:int = 0;
      
      public static const SKILL1:int = 1;
      
      public static const SKILL2:int = 2;
      
      private var _positionArr:Array = [0,0];
      
      public function LeienBossCtrl(param1:IGameWorld, param2:BossMonster, param3:int)
      {
         super(param1,param2,param3);
         _monster.setStatus("stand");
         initSkillArr();
      }
      
      private function initSkillArr() : void
      {
         _skillArr[0] = "attack";
         _skillArr[1] = "skill0";
         _skillArr[2] = "skill0";
      }
      
      public function setPosition(param1:Array) : void
      {
         _positionArr = param1;
      }
      
      override public function attackAction() : void
      {
         var retData:Object;
         var posArr:Array;
         var charcter:Character = attackTarget as Character;
         trace("Boss\'name ",_monster.bossName,"BossMonsterCtrl-attackAction，当前状态 " + _attackState + " !");
         _gameWorld.camera.swapFocus(_monster);
         if(_gameWorld as BossWorld)
         {
            retData = BossWorld(_gameWorld).getBossHitObject();
            posArr = retData.data.bossPos;
         }
         else
         {
            posArr = _positionArr;
         }
         trace("Leien\'s new position X:",posArr[0],"Y:",posArr[1]);
         if(posArr[0] != 0 && posArr[1] != 0)
         {
            setHpBarVisible(false);
            Starling.juggler.tween(_monster,0.5,{
               "alpha":0,
               "onComplete":(function():*
               {
                  var done:Function;
                  return done = function():void
                  {
                     BossMonster(_monster).x = posArr[0];
                     BossMonster(_monster).y = posArr[1];
                  };
               })()
            });
            Starling.juggler.tween(_monster,0.5,{
               "alpha":1,
               "delay":1
            });
            Starling.juggler.delayCall((function():*
            {
               var delay:Function;
               return delay = function():void
               {
                  setHpBarVisible();
                  setAttackStatus();
               };
            })(),1.5);
         }
         else
         {
            setAttackStatus();
         }
      }
      
      private function setAttackStatus() : void
      {
         _monster.setStatus(_attackState);
         _status = _attackState;
      }
   }
}

