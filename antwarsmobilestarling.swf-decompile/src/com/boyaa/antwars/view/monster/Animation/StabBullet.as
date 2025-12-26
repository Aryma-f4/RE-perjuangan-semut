package com.boyaa.antwars.view.monster.Animation
{
   import com.boyaa.antwars.view.game.ICharacter;
   import com.boyaa.antwars.view.monster.tools.AnimationBullet;
   
   public class StabBullet extends AnimationBullet
   {
      
      public function StabBullet(param1:ICharacter)
      {
         super(param1);
      }
      
      override protected function initBullet() : void
      {
         super.initBullet();
         _aniAltals = "地刺效果";
         _soundStr = "sound 54";
      }
   }
}

