package com.boyaa.antwars.view.monster
{
   import com.boyaa.antwars.view.monster.Animation.EyeAnimation;
   import com.boyaa.antwars.view.screen.copygame.Eggs;
   import com.boyaa.antwars.view.screen.copygame.boss.member.BossMonster;
   import com.boyaa.antwars.view.screen.copygame.boss.member.tool.IBossMonster;
   
   public class MonsterFactory
   {
      
      private static var _instance:MonsterFactory = null;
      
      private var _assets:ResAssetManager;
      
      private var _bossArr:Array = ["Zhunhuang","Mengji","Leien"];
      
      public function MonsterFactory(param1:Single)
      {
         super();
         _assets = Assets.sAsset;
      }
      
      public static function get instance() : MonsterFactory
      {
         if(_instance == null)
         {
            _instance = new MonsterFactory(new Single());
         }
         return _instance;
      }
      
      public static function dispose() : void
      {
         _instance = null;
      }
      
      public function create(param1:String, param2:MonsterData) : Monster
      {
         var _loc3_:Monster = null;
         var _loc4_:int = Math.random() * 6 + 1;
         switch(param1)
         {
            case "Dishayan":
            case "Tianmoyan":
            case "Pomie":
               break;
            case "Dan":
               return Monster.createByAnimation(new Eggs(_loc4_),param2);
            default:
               return Monster.createByArmature(_assets.buildArmature(param1),param2);
         }
         param2.isfly = true;
         _loc3_ = Monster.createByAnimation(new EyeAnimation(),param2);
         _loc3_.canHit = false;
         return _loc3_;
      }
      
      public function createBoss(param1:String, param2:MonsterData) : IBossMonster
      {
         return BossMonster.createByArmature(_assets.buildArmature(param1),param2);
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
