package com.boyaa.antwars.view.screen.copygame.boss.member
{
   import com.boyaa.antwars.helper.Timepiece;
   import dragonBones.events.AnimationEvent;
   
   public class ScorpionKind extends BossMonster
   {
      
      public static const SPIECE_TYPE:int = 27;
      
      public function ScorpionKind()
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
         if(isAttack)
         {
            switch(int(BossCtrl(icharacterCtrl).currentSkill))
            {
               case 0:
                  Timepiece.instance.addDelayCall(normalHit,1500);
                  break;
               case 1:
                  Timepiece.instance.addDelayCall(shadowHit,1000);
                  break;
               case 2:
                  Timepiece.instance.addDelayCall(shadowHit,1100);
            }
         }
      }
      
      override protected function onAnimationComplete(param1:AnimationEvent) : void
      {
         super.onAnimationComplete(param1);
         if(isAttack)
         {
            isAttack = !isAttack;
            animationCompleteSignal.dispatch(_status);
         }
      }
      
      private function normalHit() : void
      {
         useArmatureBullet("scropionBullet",0,0,150);
      }
      
      private function shadowHit() : void
      {
         animationCompleteSignal.dispatch(_status);
      }
      
      private function tailHit() : void
      {
         animationCompleteSignal.dispatch(_status);
      }
   }
}

