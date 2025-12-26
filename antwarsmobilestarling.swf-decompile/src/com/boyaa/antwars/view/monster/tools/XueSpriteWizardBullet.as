package com.boyaa.antwars.view.monster.tools
{
   import com.boyaa.antwars.view.game.ICharacter;
   
   public class XueSpriteWizardBullet extends AnimationBullet
   {
      
      public function XueSpriteWizardBullet(param1:ICharacter)
      {
         super(param1);
      }
      
      override protected function initBullet() : void
      {
         super.initBullet();
         _aniAltals = "血精灵巫师子弹爆炸00";
      }
   }
}

