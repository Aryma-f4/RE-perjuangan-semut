package com.boyaa.antwars.view.monster
{
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.monster.Animation.CobWebBullet;
   import com.boyaa.antwars.view.monster.Animation.DragonBullet;
   import com.boyaa.antwars.view.monster.Animation.FireBallBullet;
   import com.boyaa.antwars.view.monster.Animation.SpittleBullet;
   import com.boyaa.antwars.view.monster.Animation.StoneBullet;
   import com.boyaa.antwars.view.monster.Animation.TouShiCheBullet;
   import com.boyaa.antwars.view.monster.tools.ArmatureBullet;
   import com.boyaa.antwars.view.monster.tools.XueSpriteWizardBullet;
   import dragonBones.Armature;
   import dragonBones.events.AnimationEvent;
   import flash.geom.Point;
   
   public class Monster extends MonsterBass
   {
      
      private var _monsterCtrl:MonsterCtrl;
      
      private var _specialHit:Boolean = false;
      
      public function Monster(param1:Single)
      {
         super();
      }
      
      public static function createByArmature(param1:Armature, param2:MonsterData = null) : Monster
      {
         var _loc3_:Monster = new Monster(new Single());
         _loc3_.setArmature(param1);
         if(param2)
         {
            _loc3_.init(param2);
         }
         return _loc3_;
      }
      
      public static function createByAnimation(param1:Animation, param2:MonsterData) : Monster
      {
         var _loc3_:Monster = new Monster(new Single());
         _loc3_.setAnimation(param1);
         _loc3_.init(param2);
         return _loc3_;
      }
      
      override protected function onAnimationComplete(param1:AnimationEvent) : void
      {
         trace("monster\'s type",data.spiece_type,"animationComplete");
         if(_status == "attack")
         {
            switch(data.spiece_type)
            {
               case 4:
               case 9:
               case 16:
               case 19:
               case 23:
                  break;
               default:
                  animationCompleteSignal.dispatch(_status);
            }
         }
         else if(_status != "chain")
         {
            animationCompleteSignal.dispatch(_status);
         }
      }
      
      override public function setStatus(param1:String) : void
      {
         var _loc2_:Array = null;
         super.setStatus(param1);
         if(monsterCtrl)
         {
            this.monsterCtrl.monsterChangeDirection();
         }
         if(armature)
         {
            _loc2_ = ["chain","palsy"];
            if(_loc2_.indexOf(param1) != -1)
            {
               armature.animation.gotoAndPlay("attack");
            }
            else
            {
               armature.animation.gotoAndPlay(param1);
            }
         }
         if(animation)
         {
            animation.gotoAndPlay(param1);
         }
         if(_status == "attack")
         {
            switch(data.spiece_type)
            {
               case 4:
                  Timepiece.instance.addDelayCall(UseSpittleBullet,700);
                  break;
               case 9:
                  Timepiece.instance.addDelayCall(UseStoneBullet,1200);
                  break;
               case 16:
                  Timepiece.instance.addDelayCall(UseFireBallBullet,2600);
                  break;
               case 19:
                  Timepiece.instance.addDelayCall(useEffectBullet,1200);
                  break;
               case 23:
                  Timepiece.instance.addDelayCall(useTouShiCheBullet,500);
                  break;
               case 100:
                  Timepiece.instance.addDelayCall(UseDragonBullet,1200);
            }
         }
         if(_status == "chain")
         {
            Timepiece.instance.addDelayCall(UseCobWebBullet,700);
         }
         playActSound();
      }
      
      override public function get icharacterCtrl() : ICharacterCtrl
      {
         return monsterCtrl as ICharacterCtrl;
      }
      
      protected function UseDragonBullet() : void
      {
         monsterCtrl.direction = x < monsterCtrl.attackTarget.x;
         var _loc7_:DragonBullet = new DragonBullet(icharacterCtrl);
         var _loc4_:Point = new Point(x - 200,y - 150);
         var _loc2_:Number = monsterCtrl.attackTarget.x - _loc4_.x;
         var _loc3_:Number = _loc4_.y - monsterCtrl.attackTarget.y;
         var _loc1_:Number = rotation * 180 / 3.141592653589793;
         var _loc6_:Number = 0;
         var _loc5_:Number = MathHelper.getVelocity(_loc2_,_loc3_,_loc6_);
         _loc7_.init(_loc4_,_loc6_,_loc5_);
         icharacterCtrl.gameworld.getGameLayer().addChild(_loc7_);
         _loc7_.start();
         _loc7_.blowoutCompleteSignal.addOnce(shootComplete);
         icharacterCtrl.gameworld.cameraFocusCtrlByTouch(false);
         icharacterCtrl.gameworld.camera.swapFocus(_loc7_);
         SoundManager.playSound("sound 33");
      }
      
      protected function UseCobWebBullet() : void
      {
         monsterCtrl.direction = x < monsterCtrl.attackTarget.x;
         var _loc7_:CobWebBullet = new CobWebBullet(icharacterCtrl);
         var _loc3_:Point = new Point(x,y - 30);
         _loc3_.x = monsterCtrl.direction ? _loc3_.x + 60 : _loc3_.x - 60;
         var _loc1_:Number = monsterCtrl.attackTarget.x - _loc3_.x;
         var _loc2_:Number = _loc3_.y - monsterCtrl.attackTarget.y + 20;
         var _loc5_:Number = rotation * 180 / 3.141592653589793;
         var _loc6_:Number = monsterCtrl.direction ? 45 - _loc5_ : 180 - (45 + _loc5_);
         var _loc4_:Number = MathHelper.getVelocity(_loc1_,_loc2_,_loc6_);
         _loc7_.init(_loc3_,_loc6_,_loc4_);
         icharacterCtrl.gameworld.getGameLayer().addChild(_loc7_);
         _loc7_.start();
         _loc7_.blowoutCompleteSignal.addOnce(shootComplete);
         SoundManager.playSound("sound 41");
         icharacterCtrl.gameworld.cameraFocusCtrlByTouch(false);
         icharacterCtrl.gameworld.camera.swapFocus(_loc7_);
      }
      
      protected function UseStoneBullet() : void
      {
         var _loc6_:Number = NaN;
         monsterCtrl.direction = x < monsterCtrl.attackTarget.x;
         var _loc7_:StoneBullet = new StoneBullet(icharacterCtrl);
         var _loc3_:Point = new Point(x,y - 30);
         _loc3_.x = monsterCtrl.direction ? _loc3_.x + 60 : _loc3_.x - 60;
         var _loc1_:Number = monsterCtrl.attackTarget.x - _loc3_.x;
         var _loc2_:Number = _loc3_.y - monsterCtrl.attackTarget.y;
         var _loc5_:Number = rotation * 180 / 3.141592653589793;
         if(Math.abs(_loc1_) <= 50 || _loc2_ >= 200)
         {
            _loc6_ = monsterCtrl.direction ? 85 - _loc5_ : 180 - (85 + _loc5_);
         }
         else
         {
            _loc6_ = monsterCtrl.direction ? 45 - _loc5_ : 180 - (45 + _loc5_);
         }
         var _loc4_:Number = MathHelper.getVelocity(_loc1_,_loc2_,_loc6_);
         _loc7_.init(_loc3_,_loc6_,_loc4_);
         icharacterCtrl.gameworld.getGameLayer().addChild(_loc7_);
         _loc7_.start();
         _loc7_.blowoutCompleteSignal.addOnce(shootComplete);
         icharacterCtrl.gameworld.cameraFocusCtrlByTouch(false);
         icharacterCtrl.gameworld.camera.swapFocus(_loc7_);
      }
      
      private function createBullet(param1:Class, param2:Point = null) : void
      {
         var _loc8_:Number = NaN;
         if(!icharacterCtrl.gameworld)
         {
            return;
         }
         monsterCtrl.direction = x < monsterCtrl.attackTarget.x;
         var _loc9_:MonsterBullet = new param1(icharacterCtrl);
         var _loc5_:* = param2;
         if(_loc5_ == null)
         {
            _loc5_ = new Point(x,y - 30);
         }
         _loc5_.x = monsterCtrl.direction ? _loc5_.x + 60 : _loc5_.x - 60;
         var _loc3_:Number = monsterCtrl.attackTarget.x - _loc5_.x;
         var _loc4_:Number = _loc5_.y - monsterCtrl.attackTarget.y;
         var _loc7_:Number = rotation * 180 / 3.141592653589793;
         if(Math.abs(_loc3_) <= 50 || _loc4_ >= 200)
         {
            _loc8_ = monsterCtrl.direction ? 85 - _loc7_ : 180 - (85 + _loc7_);
         }
         else
         {
            _loc8_ = monsterCtrl.direction ? 45 - _loc7_ : 180 - (45 + _loc7_);
         }
         var _loc6_:Number = MathHelper.getVelocity(_loc3_,_loc4_,_loc8_);
         _loc9_.init(_loc5_,_loc8_,_loc6_);
         icharacterCtrl.gameworld.getGameLayer().addChild(_loc9_);
         _loc9_.start();
         _loc9_.blowoutCompleteSignal.addOnce(shootComplete);
         icharacterCtrl.gameworld.cameraFocusCtrlByTouch(false);
         icharacterCtrl.gameworld.camera.swapFocus(_loc9_);
      }
      
      protected function UseFireBallBullet() : void
      {
         createBullet(FireBallBullet);
      }
      
      protected function useTouShiCheBullet() : void
      {
         createBullet(TouShiCheBullet,new Point(x - 30,y - 100));
      }
      
      protected function useArmatureBullet() : void
      {
         var _loc1_:ArmatureBullet = new ArmatureBullet(monsterCtrl.attackTarget,"tornado");
         _loc1_.setBulletPos(new Point(70,0));
         icharacterCtrl.gameworld.getGameLayer().addChild(_loc1_);
         _loc1_.aniCompleteSignal.addOnce(shootComplete);
         _loc1_.start();
         icharacterCtrl.gameworld.cameraFocusCtrlByTouch(false);
         icharacterCtrl.gameworld.camera.swapFocus(_loc1_);
      }
      
      protected function useEffectBullet() : void
      {
         monsterCtrl.direction = x < monsterCtrl.attackTarget.x;
         var _loc1_:XueSpriteWizardBullet = new XueSpriteWizardBullet(monsterCtrl.attackTarget);
         icharacterCtrl.gameworld.getGameLayer().addChild(_loc1_);
         _loc1_.start();
         _loc1_.completeSignal.addOnce(shootComplete);
         icharacterCtrl.gameworld.cameraFocusCtrlByTouch(false);
         icharacterCtrl.gameworld.camera.swapFocus(monsterCtrl.attackTarget);
      }
      
      protected function UseSpittleBullet() : void
      {
         monsterCtrl.direction = x < monsterCtrl.attackTarget.x;
         var _loc7_:SpittleBullet = new SpittleBullet(icharacterCtrl);
         var _loc3_:Point = new Point(x,y - 30);
         _loc3_.x = monsterCtrl.direction ? _loc3_.x + 60 : _loc3_.x - 60;
         var _loc1_:Number = monsterCtrl.attackTarget.x - _loc3_.x;
         var _loc2_:Number = _loc3_.y - monsterCtrl.attackTarget.y;
         var _loc5_:Number = rotation * 180 / 3.141592653589793;
         var _loc6_:Number = monsterCtrl.direction ? 45 - _loc5_ : 180 - (45 + _loc5_);
         var _loc4_:Number = MathHelper.getVelocity(_loc1_,_loc2_,_loc6_);
         _loc7_.init(_loc3_,_loc6_,_loc4_);
         icharacterCtrl.gameworld.getGameLayer().addChild(_loc7_);
         _loc7_.start();
         _loc7_.blowoutCompleteSignal.addOnce(shootComplete);
         SoundManager.playSound("sound 35");
         icharacterCtrl.gameworld.cameraFocusCtrlByTouch(false);
         icharacterCtrl.gameworld.camera.swapFocus(_loc7_);
      }
      
      override protected function initSoundDictionary() : void
      {
         var _loc1_:Array = null;
         super.initSoundDictionary();
         switch(this.data.spiece_type)
         {
            case 1:
            case 3:
               _loc1_ = ["sound 31","sound 29","","sound 32"];
               break;
            case 4:
               _loc1_ = ["sound 31","","","sound 32"];
               break;
            case 5:
            case 6:
               _loc1_ = ["","sound 33","",""];
               break;
            case 9:
               _loc1_ = ["","Zhizhusheshou_attack","Zhizhusheshou_dizzy","Zhizhushouwei_angel"];
               break;
            case 10:
               _loc1_ = ["Zhizhushouwei_move","Zhizhushouwei_attack","Zhizhushouwei_dizzy","Zhizhushouwei_angel"];
               break;
            case 11:
               _loc1_ = ["Zhizhucike_move","Zhizhucike_attack","Zhizhucike_dizzy","Zhizhucike_angel"];
               _soundDictionary["palsy"] = "sound 38";
               break;
            case 12:
               _loc1_ = ["Zhizhushouwei_move","Zhizhushouwei_attack","Zhizhushouwei_dizzy","Zhizhushouwei_angel"];
               _soundDictionary["chain"] = "Zhizhushouwei_attack";
               break;
            case 100:
               _loc1_ = ["","dragon_fire_ball","dragon_attacked","dragon_die"];
               break;
            default:
               _loc1_ = ["","","",""];
         }
         _soundDictionary["move"] = _loc1_.shift();
         _soundDictionary["attack"] = _loc1_.shift();
         _soundDictionary["dizzy"] = _loc1_.shift();
         _soundDictionary["angel"] = _loc1_.shift();
      }
      
      private function shootComplete() : void
      {
         animationCompleteSignal.dispatch(_status);
         icharacterCtrl.gameworld.cameraFocusCtrlByTouch(true);
      }
      
      public function get specialHit() : Boolean
      {
         return _specialHit;
      }
      
      public function get monsterCtrl() : MonsterCtrl
      {
         return _monsterCtrl;
      }
      
      public function set monsterCtrl(param1:MonsterCtrl) : void
      {
         _monsterCtrl = param1;
      }
      
      public function spiderGeneralHit() : void
      {
         _specialHit = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Timepiece.instance.removeFun(UseSpittleBullet,2);
         Timepiece.instance.removeFun(UseStoneBullet,2);
         Timepiece.instance.removeFun(UseFireBallBullet,2);
         Timepiece.instance.removeFun(useEffectBullet,2);
         Timepiece.instance.removeFun(useTouShiCheBullet,2);
         Timepiece.instance.removeFun(UseDragonBullet,2);
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
