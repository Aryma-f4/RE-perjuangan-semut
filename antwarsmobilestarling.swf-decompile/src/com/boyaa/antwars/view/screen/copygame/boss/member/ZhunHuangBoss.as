package com.boyaa.antwars.view.screen.copygame.boss.member
{
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.monster.Animation.CobWebBullet;
   import com.boyaa.antwars.view.monster.Animation.StabBullet;
   import com.boyaa.antwars.view.screen.copygame.boss.BossWorld;
   import com.boyaa.antwars.view.screen.copygame.boss.ZhunhuangWorld;
   import dragonBones.events.AnimationEvent;
   import flash.geom.Point;
   import starling.core.Starling;
   
   public class ZhunHuangBoss extends BossMonster
   {
      
      private var _fireArr:Array = ["landimpale","hangfire","wildimpale","hangflash","landflash","wildflash"];
      
      public function ZhunHuangBoss()
      {
         super();
      }
      
      override protected function onAnimationComplete(param1:AnimationEvent) : void
      {
         var flag:Boolean;
         var item:String;
         var e:AnimationEvent = param1;
         super.onAnimationComplete(e);
         flag = false;
         for each(item in _fireArr)
         {
            if(_status == item)
            {
               flag = true;
            }
         }
         if(_status.indexOf("bite") != -1)
         {
            if(bossMonsterCtrl.gameworld is ZhunhuangWorld)
            {
               Starling.juggler.delayCall(function():void
               {
                  x = ZhunhuangWorld(bossMonsterCtrl.gameworld).currentPosition.x;
                  y = ZhunhuangWorld(bossMonsterCtrl.gameworld).currentPosition.y;
                  icharacterCtrl.gameworld.camera.swapFocus(_bossMonsterCtrl.attackTarget);
               },0.1);
            }
         }
         if(!flag)
         {
            animationCompleteSignal.dispatch(_status);
         }
      }
      
      override public function setStatus(param1:String) : void
      {
         var _loc2_:Array = ["hangflash","landflash","wildflash"];
         super.setStatus(param1);
         if(armature)
         {
            armature.animation.gotoAndPlay(param1);
         }
         if(param1 == "hangfire")
         {
            Starling.juggler.delayCall(UseCobWebBullet,0.5);
         }
         if(param1 == "landimpale" || param1 == "wildimpale")
         {
            Starling.juggler.delayCall(UseStabBullet,1);
         }
         if(_loc2_.indexOf(param1) != -1)
         {
            Starling.juggler.delayCall(ZhunHuangBossCtrl(bossMonsterCtrl).flashAndKill,0.5);
         }
         playActSound();
      }
      
      override protected function initSoundDictionary() : void
      {
         _soundDictionary["hangcall"] = "sound 52";
         _soundDictionary["hangflash"] = "sound 53";
         _soundDictionary["landflash"] = "sound 53";
         _soundDictionary["hangbuff"] = "sound 51";
         _soundDictionary["landimpale"] = "sound 55";
         _soundDictionary["wildimpale"] = "sound 57";
         _soundDictionary["hangfire"] = "sound 61";
         _soundDictionary["wildbite"] = "sound 58";
         _soundDictionary["hangbite"] = "sound 58";
         _soundDictionary["landbite"] = "sound 58";
         _soundDictionary["wilddizzy"] = "sound 50";
         _soundDictionary["hangdizzy"] = "sound 50";
         _soundDictionary["landdizzy"] = "sound 50";
         _soundDictionary["angel"] = "sound 62";
         _soundDictionary["hangdropAndSike"] = "sound 60";
         _soundDictionary["hangdrop"] = "sound 59";
      }
      
      protected function UseCobWebBullet() : void
      {
         _bossMonsterCtrl.direction = x < _bossMonsterCtrl.attackTarget.x;
         var _loc7_:CobWebBullet = new CobWebBullet(icharacterCtrl);
         var _loc3_:Point = new Point(x,y - 30);
         _loc3_.x = _bossMonsterCtrl.direction ? _loc3_.x + 60 : _loc3_.x - 60;
         var _loc1_:Number = _bossMonsterCtrl.attackTarget.x - _loc3_.x;
         var _loc2_:Number = _loc3_.y - _bossMonsterCtrl.attackTarget.y + 20;
         var _loc5_:Number = rotation * 180 / 3.141592653589793;
         var _loc6_:Number = _bossMonsterCtrl.direction ? 30 - _loc5_ : 180 - (30 + _loc5_);
         var _loc4_:Number = MathHelper.getVelocity(_loc1_,_loc2_,_loc6_);
         _loc7_.init(_loc3_,_loc6_,_loc4_);
         icharacterCtrl.gameworld.getGameLayer().addChild(_loc7_);
         _loc7_.start();
         _loc7_.blowoutCompleteSignal.addOnce(shootComplete);
         SoundManager.playSound("sound 41");
         icharacterCtrl.gameworld.cameraFocusCtrlByTouch(false);
         icharacterCtrl.gameworld.camera.swapFocus(_loc7_);
      }
      
      protected function UseStabBullet() : void
      {
         var _loc3_:int = 0;
         var _loc1_:StabBullet = null;
         _bossMonsterCtrl.direction = x < _bossMonsterCtrl.attackTarget.x;
         if(BossWorld(bossMonsterCtrl.gameworld).otherCtrls)
         {
            _loc3_ = 0;
            while(_loc3_ < BossWorld(bossMonsterCtrl.gameworld).otherCtrls.length)
            {
               if(BossWorld(bossMonsterCtrl.gameworld).otherCtrls[_loc3_].hp > 0)
               {
                  _loc1_ = new StabBullet(BossWorld(bossMonsterCtrl.gameworld).otherCtrls[_loc3_].character);
                  icharacterCtrl.gameworld.getGameLayer().addChild(_loc1_);
                  _loc1_.start();
               }
               _loc3_++;
            }
         }
         var _loc2_:StabBullet = new StabBullet(BossWorld(bossMonsterCtrl.gameworld).selfCharacterCtrl.icharacter);
         icharacterCtrl.gameworld.getGameLayer().addChild(_loc2_);
         _loc2_.start();
         _loc2_.completeSignal.addOnce(shootComplete);
         icharacterCtrl.gameworld.cameraFocusCtrlByTouch(false);
         icharacterCtrl.gameworld.camera.swapFocus(_bossMonsterCtrl.attackTarget);
      }
   }
}

