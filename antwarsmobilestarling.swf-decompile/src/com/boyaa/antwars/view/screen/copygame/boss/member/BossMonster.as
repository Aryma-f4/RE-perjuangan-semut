package com.boyaa.antwars.view.screen.copygame.boss.member
{
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.monster.Animation;
   import com.boyaa.antwars.view.monster.MonsterBass;
   import com.boyaa.antwars.view.monster.MonsterData;
   import com.boyaa.antwars.view.monster.tools.ArmatureBullet;
   import com.boyaa.antwars.view.screen.copygame.boss.member.tool.BossInfoMationManager;
   import com.boyaa.antwars.view.screen.copygame.boss.member.tool.IBossMonster;
   import dragonBones.Armature;
   import flash.geom.Point;
   
   public class BossMonster extends MonsterBass implements IBossMonster
   {
      
      protected var _bossMonsterCtrl:BossCtrl;
      
      public function BossMonster()
      {
         super();
         initSoundDictionary();
      }
      
      public static function createByArmature(param1:Armature, param2:MonsterData = null) : IBossMonster
      {
         var _loc3_:IBossMonster = BossInfoMationManager.instance.getBossClassByType(param2.spiece_type);
         BossMonster(_loc3_).setArmature(param1);
         if(param2)
         {
            BossMonster(_loc3_).init(param2);
         }
         return _loc3_;
      }
      
      public static function createByAnimation(param1:Animation, param2:MonsterData) : IBossMonster
      {
         var _loc3_:IBossMonster = BossInfoMationManager.instance.getBossClassByType(param2.spiece_type);
         BossMonster(_loc3_).setAnimation(param1);
         BossMonster(_loc3_).init(param2);
         return _loc3_;
      }
      
      public function doNothing() : void
      {
      }
      
      override public function get icharacterCtrl() : ICharacterCtrl
      {
         return _bossMonsterCtrl as ICharacterCtrl;
      }
      
      public function get bossMonsterCtrl() : BossCtrl
      {
         return _bossMonsterCtrl;
      }
      
      public function set bossMonsterCtrl(param1:BossCtrl) : void
      {
         _bossMonsterCtrl = param1;
      }
      
      public function get bossName() : String
      {
         return this.armature.name;
      }
      
      protected function useArmatureBullet(param1:String, param2:int = 0, param3:int = 0, param4:int = -1, param5:Number = -1) : void
      {
         var _loc6_:ArmatureBullet = new ArmatureBullet(_bossMonsterCtrl.attackTarget,param1);
         _loc6_.setBulletPos(new Point(param2,param3));
         icharacterCtrl.gameworld.getGameLayer().addChild(_loc6_);
         _loc6_.aniCompleteSignal.addOnce(shootComplete);
         if(param5 != -1)
         {
            _loc6_.setCryTimeAndCount(param5);
         }
         if(param4 != -1)
         {
            _loc6_.setBulletSize(param4);
         }
         _loc6_.start();
         icharacterCtrl.gameworld.cameraFocusCtrlByTouch(false);
         icharacterCtrl.gameworld.camera.swapFocus(_loc6_);
      }
      
      protected function shootComplete() : void
      {
         animationCompleteSignal.dispatch(_status);
      }
   }
}

class Single
{
   
   public function Single()
   {
      super();
   }
}
