package com.boyaa.antwars.view.screen.copygame.boss.member
{
   import dragonBones.events.AnimationEvent;
   import starling.core.Starling;
   
   public class LeienBoss extends BossMonster
   {
      
      public static const STAR_RAIN:String = "starRain";
      
      public static const LEIENBULLET:String = "LeienBullet";
      
      public static const TORNADO:String = "tornado";
      
      public static const SKILL:String = "skill0";
      
      public function LeienBoss()
      {
         super();
      }
      
      override public function setStatus(param1:String) : void
      {
         super.setStatus(param1);
         if(armature)
         {
            armature.animation.gotoAndPlay(param1);
         }
         if(_status == "attack" || _status == "skill0")
         {
            switch(int(BossCtrl(icharacterCtrl).currentSkill))
            {
               case 0:
                  Starling.juggler.delayCall(useNormalSkill,1.2);
                  break;
               case 1:
                  Starling.juggler.delayCall(useStarRain,1.8);
                  break;
               case 2:
                  Starling.juggler.delayCall(useTornado,1.8);
            }
         }
         playActSound();
      }
      
      override protected function onAnimationComplete(param1:AnimationEvent) : void
      {
         super.onAnimationComplete(param1);
         if(_status != "attack" && _status != "skill0")
         {
            animationCompleteSignal.dispatch(_status);
         }
      }
      
      override protected function initSoundDictionary() : void
      {
         super.initSoundDictionary();
      }
      
      private function useStarRain() : void
      {
         useArmatureBullet("starRain");
      }
      
      private function useNormalSkill() : void
      {
         useArmatureBullet("LeienBullet",0,0,300);
      }
      
      private function useTornado() : void
      {
         useArmatureBullet("tornado",70);
      }
   }
}

