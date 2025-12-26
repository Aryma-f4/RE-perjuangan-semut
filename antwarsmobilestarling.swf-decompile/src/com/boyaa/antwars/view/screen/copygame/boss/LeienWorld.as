package com.boyaa.antwars.view.screen.copygame.boss
{
   import com.boyaa.antwars.data.CopyMonsterRoleList;
   import com.boyaa.antwars.data.model.CopyMonster;
   import com.boyaa.antwars.data.model.CopyMonsterRole;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.monster.MonsterData;
   import com.boyaa.antwars.view.monster.MonsterFactory;
   import com.boyaa.antwars.view.screen.copygame.boss.member.BossCtrl;
   import com.boyaa.antwars.view.screen.copygame.boss.member.LeienBoss;
   import com.boyaa.antwars.view.screen.copygame.boss.member.LeienBossCtrl;
   import starling.core.Starling;
   import starling.utils.formatString;
   
   public class LeienWorld extends BossWorld
   {
      
      private var _lastId:int = 4;
      
      private var _isInit:Boolean = true;
      
      public function LeienWorld()
      {
         super();
         playBgSound("Music 6");
      }
      
      override protected function loadAssets(param1:ResManager) : void
      {
         super.loadAssets(param1);
         Assets.btAsset.enqueue(param1.getResFile(formatString("textures/{0}x/COPYGAME/energyLight.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/LeienSkillEffect.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/LeienSkillEffect.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_LeienSkillEffect.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/Leien.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/Leien.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_Leien.xml",Assets.sAsset.scaleFactor)));
      }
      
      override protected function flushBoss() : void
      {
         var _loc2_:int = 0;
         var _loc5_:LeienBossCtrl = null;
         var _loc1_:CopyMonsterRole = null;
         var _loc7_:MonsterData = null;
         var _loc3_:LeienBoss = null;
         if(!_isInit)
         {
            return;
         }
         super.flushBoss();
         allMonsters = 1;
         var _loc6_:int = 0;
         _lastId = 4;
         for each(var _loc4_ in copyData.monsterList)
         {
            _loc2_ = _loc4_.roleid;
            _loc1_ = CopyMonsterRoleList.instance.getRoleById(_loc2_);
            _loc7_ = new MonsterData(_loc1_);
            _loc7_.isfly = true;
            _loc3_ = LeienBoss(MonsterFactory.instance.createBoss(_loc1_.remake,_loc7_));
            this.charatersLayer.addChild(_loc3_);
            _loc5_ = new LeienBossCtrl(this,_loc3_,_lastId + _loc6_);
            Starling.juggler.add(_loc5_);
            _loc5_.actionCompleteSignal.add(monsterActionCompleteHandle);
            _loc5_.attackSignal.add(bossAttackHandle);
            monsterCtrlVector.push(_loc5_);
            bossCtrl = _loc5_;
            _loc3_.x = 1300;
            _loc3_.y = 400;
            _loc6_++;
            camera.swapFocus(_loc3_,20);
         }
         _isInit = false;
         showLeftNumText();
      }
      
      override protected function bossAttackHandle(param1:String, param2:BossCtrl) : void
      {
         var _loc3_:Array = null;
         var _loc6_:int = 0;
         var _loc4_:ICharacterCtrl = null;
         super.bossAttackHandle(param1,param2);
         if(param1.indexOf("dizzy") != -1)
         {
            return;
         }
         var _loc7_:int = 0;
         var _loc5_:int = 0;
         switch(bossSkill)
         {
            case 0:
               dropHpByServer(param2,getCtrlBySiteID(dizzySite),lossHpHitByBoss,Boolean(isPow));
               break;
            case 1:
               _loc3_ = bossHitObject.data.playerHitArr;
               _loc6_ = 0;
               while(_loc6_ < _loc3_.length)
               {
                  getCtrlBySiteID(_loc3_[_loc6_][0]).playCry();
                  dropHpByServer(param2,getCtrlBySiteID(_loc3_[_loc6_][0]),_loc3_[_loc6_][1],_loc3_[_loc6_][2]);
                  _loc6_++;
               }
               break;
            case 2:
               _loc3_ = bossHitObject.data.newPos;
               _loc4_ = getCtrlBySiteID(dizzySite);
               Character(_loc4_.icharacter).x = _loc3_[0];
               Character(_loc4_.icharacter).y = _loc3_[1];
               _loc4_.downStatus = true;
               camera.swapFocus(Character(_loc4_.icharacter));
               dropHpByServer(param2,getCtrlBySiteID(dizzySite),lossHpHitByBoss,Boolean(isPow));
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Assets.btAsset.removeTextureAtlas("energyLight");
         Assets.btAsset.removeTextureAtlas("LeienSkillEffect");
         Assets.btAsset.removeSkeletonsAndBoneAtlases("LeienSkillEffect");
         Assets.btAsset.removeTextureAtlas("Leien");
         Assets.btAsset.removeSkeletonsAndBoneAtlases("Leien");
      }
   }
}

