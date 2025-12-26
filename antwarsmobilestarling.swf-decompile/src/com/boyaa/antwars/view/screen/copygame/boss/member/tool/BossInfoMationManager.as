package com.boyaa.antwars.view.screen.copygame.boss.member.tool
{
   import com.boyaa.antwars.view.screen.copygame.boss.member.LeienBoss;
   import com.boyaa.antwars.view.screen.copygame.boss.member.ScorpionKind;
   import com.boyaa.antwars.view.screen.copygame.boss.member.ZhunHuangBoss;
   
   public class BossInfoMationManager
   {
      
      private static var _instance:BossInfoMationManager = null;
      
      private var _bossTypeArr:Array = [];
      
      private var _bossNameArr:Array = [];
      
      public function BossInfoMationManager(param1:Single)
      {
         super();
         init();
      }
      
      public static function get instance() : BossInfoMationManager
      {
         if(_instance == null)
         {
            _instance = new BossInfoMationManager(new Single());
         }
         return _instance;
      }
      
      private function init() : void
      {
         _bossTypeArr[13] = [ZhunHuangBoss];
         _bossTypeArr[22] = [LeienBoss];
         _bossTypeArr[27] = [ScorpionKind];
         _bossNameArr["Zhunhuang"] = [ZhunHuangBoss];
      }
      
      public function getBossClassByType(param1:int) : IBossMonster
      {
         var _loc2_:Class = _bossTypeArr[param1][0];
         if(_loc2_)
         {
            return new _loc2_() as IBossMonster;
         }
         return null;
      }
      
      public function getBossClassByName(param1:String) : IBossMonster
      {
         var _loc2_:Class = _bossNameArr[param1][0];
         if(_loc2_)
         {
            return new _loc2_() as IBossMonster;
         }
         return null;
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
