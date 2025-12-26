package com.boyaa.antwars.view.monster.Animation
{
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.monster.MonsterBullet;
   import flash.geom.Point;
   
   public class TouShiCheBullet extends MonsterBullet
   {
      
      public function TouShiCheBullet(param1:ICharacterCtrl, param2:int = 0)
      {
         super(param1,param2);
      }
      
      override protected function initMonsterBullet() : void
      {
         super.initMonsterBullet();
         _flyAltasName = "投石车子弹00";
         _explosionAltasName = "投石车子弹爆炸00";
         _blowOutPoint = new Point(100,0);
         _bulletScale = 0.3;
      }
   }
}

