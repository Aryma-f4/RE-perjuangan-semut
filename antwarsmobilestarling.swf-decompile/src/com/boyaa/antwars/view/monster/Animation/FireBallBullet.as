package com.boyaa.antwars.view.monster.Animation
{
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.monster.MonsterBullet;
   import flash.geom.Point;
   
   public class FireBallBullet extends MonsterBullet
   {
      
      public function FireBallBullet(param1:ICharacterCtrl, param2:int = 0)
      {
         super(param1,param2);
      }
      
      override protected function initMonsterBullet() : void
      {
         super.initMonsterBullet();
         _flyAltasName = "精灵巫师火球00";
         _explosionAltasName = "精灵巫师火球爆炸00";
         _blowOutPoint = new Point(30,20);
      }
   }
}

