package com.boyaa.antwars.view.screen.endlessTower
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.CopyMonsterRoleList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.CopyMonsterRole;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.sound.GameConfigDlg;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.game.GameWorld;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.monster.Monster;
   import com.boyaa.antwars.view.monster.MonsterBass;
   import com.boyaa.antwars.view.monster.MonsterCtrl;
   import com.boyaa.antwars.view.monster.MonsterData;
   import com.boyaa.antwars.view.monster.MonsterFactory;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.copygame.boss.member.BossCtrl;
   import com.boyaa.antwars.view.screen.copygame.boss.member.BossMonster;
   import com.boyaa.antwars.view.screen.copygame.boss.member.LeienBossCtrl;
   import com.boyaa.antwars.view.screen.copygame.boss.member.ZhunHuangBossCtrl;
   import com.boyaa.antwars.view.vipSystem.VipManager;
   import starling.core.Starling;
   import starling.utils.formatString;
   
   public class EndlessTowerWorld extends GameWorld
   {
      
      public static const PLAYER:int = 0;
      
      public static const MONSTER:int = 1;
      
      private static const RELIVE_COST:Number = 10;
      
      private static const WINANDNEXT:int = 0;
      
      private static const WINANDBACK:int = 1;
      
      private static const LOSSANDBACK:int = 2;
      
      private var _currentCtrl:int = 1;
      
      private var _endlessTip:EndlessTip;
      
      private var _currentLevel:int;
      
      private var _giftLevel:int;
      
      private var _randNum:int;
      
      private var _shopDataArr:Array = [0,0];
      
      protected var monsters:Vector.<ICharacterCtrl>;
      
      private const mapID:int = 209;
      
      private var _monsterSite:int = 4;
      
      private var _bornPosArr:Array = [[400,400],[550,300],[600,450],[650,200],[700,400],[900,600],[1100,500],[1150,200]];
      
      private var _bossSkillArr:Array = [];
      
      private var _gameOver:Boolean = false;
      
      private var _monsterComplete:int = 0;
      
      private var _lossOrWin:Boolean = false;
      
      public function EndlessTowerWorld()
      {
         super();
         _bossSkillArr[13] = 2;
         _bossSkillArr[22] = 0;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         loadAssets();
      }
      
      private function bindNet() : void
      {
         CopyServer.instance.onEndlessMonsterData(onFlushMonsters);
         CopyServer.instance.onWinAndGoNext(onWinAndGoNext);
         CopyServer.instance.onEndlessRelive(onReliveSelf);
         GameConfigDlg.exitSignal.addOnce(exitGame);
      }
      
      private function unBindNet() : void
      {
         CopyServer.instance.disposeRecvFun(onFlushMonsters);
         CopyServer.instance.disposeRecvFun(onWinAndGoNext);
         CopyServer.instance.disposeRecvFun(onReliveSelf);
      }
      
      private function loadAssets() : void
      {
         Application.instance.currentGame.showLoading();
         Assets.btAsset = Assets.sAsset;
         Assets.btAsset.enqueueMap(209,"map_209");
         var _loc1_:ResManager = Application.instance.resManager;
         Assets.btAsset.enqueue(_loc1_.getResFile(formatString("textures/{0}x/BT/battlefieldSpritesheet.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/battlefieldSpritesheet.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/BattlefieldUI.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/BattlefieldUI.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYGAME/monsterskill.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYGAME/monsterskill.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/emoticon.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/emoticon.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/LeienSkillEffect.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/LeienSkillEffect.xml",Assets.sAsset
         .scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_LeienSkillEffect.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/Leien.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/Leien.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_Leien.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYGAME/monsterskill2.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYGAME/monsterskill2.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYGAME/spriteMonsterSkill.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYGAME/spriteMonsterSkill.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/zhunhuang.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/zhunhuang.xml"
         ,Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_zhunhuang.xml",Assets.sAsset.scaleFactor)));
         if(!EndlessTowerScreen.isFightToWorld)
         {
            Assets.btAsset.enqueue(_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/spider.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/spider.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_spider.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/sprite.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/sprite.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_sprite.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/worm.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/worm.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_worm.xml",Assets.sAsset.scaleFactor)));
         }
         Assets.btAsset.loadQueue(loading);
      }
      
      private function loading(param1:Number) : void
      {
         var ratio:Number = param1;
         if(ratio == 1)
         {
            Starling.juggler.delayCall((function():*
            {
               var delay:Function;
               return delay = function():void
               {
                  init();
                  buildWorld(209);
                  startGame();
                  Application.instance.currentGame.hiddenLoading();
               };
            })(),0.5);
         }
      }
      
      override protected function init() : void
      {
         SoundManager.playBgSound("Music 9");
         super.init();
         bindNet();
         _endlessTip = new EndlessTip((function():*
         {
            var yes:Function;
            return yes = function():void
            {
               sendResult(0);
            };
         })(),(function():*
         {
            var no:Function;
            return no = function():void
            {
               if(_lossOrWin)
               {
                  sendResult(1);
               }
               else
               {
                  sendResult(2);
               }
               Application.instance.currentGame.navigator.showScreen("ENDLESSTOWER");
            };
         })());
      }
      
      private function onWinAndGoNext(param1:Object) : void
      {
         var _loc2_:Array = null;
         Application.instance.log("onWinAndGoNext",JSON.stringify(param1));
         if(param1.data.flag == 0)
         {
            _currentLevel = param1.data.challenge_level;
            _giftLevel = param1.data.gift_level;
            _shopDataArr[0] = param1.data.gift_pcate;
            _shopDataArr[1] = param1.data.gift_pframe;
            _loc2_ = param1.data.monsterArr;
            _randNum = param1.randNum;
            _gameOver = false;
            _currentCtrl == 1;
            clearMonsters();
            monsters = new Vector.<ICharacterCtrl>();
            _monsterSite = 4;
            maxPlayerHp();
            flushMonsters(_loc2_);
         }
      }
      
      private function maxPlayerHp() : void
      {
         selfCharacterCtrl.hp += PlayerDataList.instance.selfData.HP;
         UILayer.updateCharHP(PlayerDataList.instance.selfData.siteID,selfCharacterCtrl.hp);
      }
      
      private function onReliveSelf(param1:Object) : void
      {
         Application.instance.log("onReliveSelf",JSON.stringify(param1));
         var _loc2_:int = int(param1.data.flag);
         var _loc3_:int = int(param1.data.coin);
         if(_loc2_ == 0)
         {
            reliveSelfPlayer();
         }
         else
         {
            TextTip.instance.showByLang("boyaabz");
            sendResult(2);
         }
      }
      
      private function onFlushMonsters(param1:Object) : void
      {
         Application.instance.log("flushMonsters",JSON.stringify(param1));
         _currentLevel = param1.data.challenge_level;
         _giftLevel = param1.data.gift_level;
         _shopDataArr[0] = param1.data.gift_pcate;
         _shopDataArr[1] = param1.data.gift_pframe;
         var _loc2_:Array = param1.data.monsterArr;
         _randNum = param1.randNum;
         flushMonsters(_loc2_);
      }
      
      private function flushMonsters(param1:Array) : void
      {
         var _loc11_:int = 0;
         var _loc10_:Array = null;
         var _loc6_:Array = null;
         var _loc3_:CopyMonsterRole = null;
         var _loc8_:MonsterData = null;
         var _loc4_:Monster = null;
         var _loc7_:MonsterCtrl = null;
         var _loc5_:BossMonster = null;
         var _loc2_:BossCtrl = null;
         var _loc9_:Array = [13,22];
         _loc11_ = 0;
         while(_loc11_ < param1.length)
         {
            _loc10_ = _bornPosArr[Math.floor(Math.random() * _bornPosArr.length)];
            _loc6_ = param1[_loc11_];
            if(_loc9_.indexOf(_loc6_[0]) == -1)
            {
               _loc3_ = CopyMonsterRoleList.instance.getRoleBySpieceType(_loc6_[0]);
               _loc8_ = new MonsterData(_loc3_);
               _loc4_ = MonsterFactory.instance.create(_loc3_.remake,_loc8_);
               _loc8_.setRolAttr([_loc6_[2],_loc6_[1],_loc6_[4],_loc6_[3],_loc6_[6],_loc6_[5],_loc6_[7]],true);
               _loc4_.data.move_speed = 60;
               _loc7_ = new MonsterCtrl(this,_loc4_,_monsterSite);
               _loc7_.actionCompleteSignal.add(monsterActionCompelteHandle);
               _loc7_.attackSignal.add(monsterAttackHandle);
               _loc4_.x = _loc10_[0];
               _loc4_.y = _loc10_[1];
               this.charatersLayer.addChild(_loc4_);
               monsters.push(_loc7_);
               Starling.juggler.add(_loc7_);
            }
            else
            {
               _loc3_ = CopyMonsterRoleList.instance.getRoleBySpieceType(_loc6_[0]);
               _loc8_ = new MonsterData(_loc3_);
               _loc8_.setRolAttr([_loc6_[2],_loc6_[1],_loc6_[4],_loc6_[3],_loc6_[6],_loc6_[5],_loc6_[7]],true);
               _loc5_ = BossMonster(MonsterFactory.instance.createBoss(_loc3_.remake,_loc8_));
               switch(_loc6_[0])
               {
                  case 13:
                     _loc2_ = new ZhunHuangBossCtrl(this,_loc5_,_monsterSite);
                     break;
                  case 22:
                     _loc5_.data.isfly = true;
                     _loc2_ = new LeienBossCtrl(this,_loc5_,_monsterSite);
               }
               _loc2_.actionCompleteSignal.add(monsterActionCompelteHandle);
               _loc2_.attackSignal.add(monsterAttackHandle);
               _loc5_.x = _loc10_[0];
               _loc5_.y = _loc10_[1];
               this.charatersLayer.addChild(_loc5_);
               monsters.push(_loc2_);
               Starling.juggler.add(_loc2_);
            }
            _monsterSite = _monsterSite + 1;
            _loc11_++;
         }
         switchCtrl();
         showLeftMonsterCount();
      }
      
      private function sendResult(param1:int) : void
      {
         CopyServer.instance.sendEndlessResult(param1,_currentLevel,_randNum);
      }
      
      private function switchCtrl() : void
      {
         if(_gameOver)
         {
            return;
         }
         _monsterComplete = 0;
         Application.instance.log("EndlessTowerWorld","切换回合, _currentCtrl:" + _currentCtrl);
         Starling.juggler.delayCall(function():void
         {
            var item:ICharacterCtrl;
            var skill:int;
            if(_currentCtrl == 1)
            {
               cameraFocusCtrlByTouch(true);
               camera.swapFocus(selfCharacterCtrl.icharacter);
               playMyGo(function():void
               {
                  selfCharacterCtrl.ctrlStart(true);
                  _currentCtrl = 0;
               });
            }
            else if(_currentCtrl == 0)
            {
               for each(item in monsters)
               {
                  if(item is MonsterCtrl)
                  {
                     MonsterCtrl(item).attackTarget = selfCharacterCtrl.icharacter;
                     MonsterCtrl(item).ctrlStart();
                  }
                  if(item is BossCtrl)
                  {
                     BossCtrl(item).attackTarget = selfCharacterCtrl.icharacter;
                     skill = int(_bossSkillArr[MonsterBass(BossCtrl(item).icharacter).data.spiece_type]);
                     BossCtrl(item).setAttackSkill(skill);
                     if(item as LeienBossCtrl)
                     {
                        LeienBossCtrl(item).setPosition(SmallCodeTools.instance.getRandItemInArr(_bornPosArr) as Array);
                     }
                     BossCtrl(item).ctrlStart();
                  }
               }
               _currentCtrl = 1;
            }
         },2);
         if(isAllMonsterDead())
         {
            gameOver(true);
         }
      }
      
      private function isAllMonsterDead() : Boolean
      {
         var _loc2_:Boolean = true;
         for each(var _loc1_ in monsters)
         {
            if((_loc1_.icharacter as MonsterBass).data.influ_through != 0 && _loc1_.hp > 0)
            {
               _loc2_ = false;
               break;
            }
         }
         return _loc2_;
      }
      
      override protected function isMyCtrl() : Boolean
      {
         return _currentCtrl == 0;
      }
      
      private function startGame() : void
      {
         getMap().mapSolid = true;
         monsters = new Vector.<ICharacterCtrl>();
         sHelperPoint.setTo(200,200);
         this.addSelfToWorld(sHelperPoint);
         selfCharacterCtrl.downStart();
         selfCharacterCtrl.slottingCompleteSignal.add(slottingCompleteSignalHandle);
         selfCharacterCtrl.actionCompeleteSignal.add(actionCompleteHandle);
         selfCharacterCtrl.dieSignal.add(dieSignalHandle);
         showLeftMonsterCount();
         this.UILayer.showTopInfo(false);
         CopyServer.instance.getEndlessMonsterData();
      }
      
      private function slottingCompleteSignalHandle(param1:int, param2:Array) : void
      {
         var _loc5_:int = 0;
         var _loc4_:int = int(param2[0]);
         if(_loc4_ == 2 || _loc4_ == 3)
         {
            return;
         }
         var _loc3_:Array = param2[4];
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_][0] == 0)
            {
               dropHp(selfCharacterCtrl,selfCharacterCtrl,_loc3_[_loc5_][1]);
            }
            else
            {
               dropHp(selfCharacterCtrl,getMonsterCtrlBySite(_loc3_[_loc5_][0]),_loc3_[_loc5_][1]);
            }
            _loc5_++;
         }
         showLeftMonsterCount();
      }
      
      private function getMonsterCtrlBySite(param1:int) : ICharacterCtrl
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < monsters.length)
         {
            if(monsters[_loc2_].siteID == param1)
            {
               return monsters[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function actionCompleteHandle(param1:int = 0) : void
      {
         cameraFocusCtrlByTouch(true);
         switchCtrl();
      }
      
      private function dieSignalHandle(param1:int, param2:String) : void
      {
         if(param1 == PlayerDataList.instance.selfData.siteID)
         {
            gameOver(false);
         }
      }
      
      private function monsterActionCompelteHandle() : void
      {
         _monsterComplete = _monsterComplete + 1;
         Application.instance.log("monsterActionCompelteHandle",_monsterComplete.toString());
         if(_monsterComplete >= getMonsterCount())
         {
            switchCtrl();
         }
      }
      
      private function monsterAttackHandle(param1:String, param2:ICharacterCtrl) : void
      {
         switch(param1)
         {
            case "attack":
            case "chain":
            case "palsy":
            case "hangfire":
               dropHp(param2,selfCharacterCtrl);
         }
      }
      
      override public function onPassBtnHandle() : void
      {
         super.onPassBtnHandle();
         if(_currentCtrl == 0)
         {
            switchCtrl();
         }
      }
      
      override protected function update(param1:Number) : void
      {
         super.update(param1);
         if(!_gameOver)
         {
            MonsterCtrl.monsterAttrQueue.start();
         }
      }
      
      private function gameOver(param1:Boolean) : void
      {
         if(!_gameOver)
         {
            _gameOver = true;
            selfCharacterCtrl.ctrlStart(false);
            _lossOrWin = param1;
            if(param1)
            {
               MissionManager.instance.updateMissionData(181);
               gameOverAnimation(param1,winCallBack);
            }
            else
            {
               SoundManager.playSound("sound 28");
               gameOverAnimation(param1,loseCallBack);
            }
         }
      }
      
      private function winCallBack() : void
      {
         _endlessTip.showShopData(ShopDataList.instance.getSingleData(_shopDataArr[0],_shopDataArr[1]));
         _endlessTip.currentLevel = _currentLevel;
         _endlessTip.giftLevel = _giftLevel - _currentLevel;
         _endlessTip.show();
      }
      
      private function loseCallBack() : void
      {
         var str:String = LangManager.getLang.getreplaceLang("reliveTip",EndlessTowerScreen.ReliveCost);
         if(VipManager.instance.vipPowerData.endlessReliveTime > 0)
         {
            str = LangManager.getLang.getreplaceLang("vipReliveInEndless",VipManager.instance.vipPowerData.endlessReliveTime);
         }
         SystemTip.instance.showSystemAlert(str,(function():*
         {
            var yes:Function;
            return yes = function():void
            {
               if(VipManager.instance.vipPowerData.endlessReliveTime > 0)
               {
                  CopyServer.instance.vipFreeRelive(_currentLevel,_randNum,(function():*
                  {
                     var callBack:Function;
                     return callBack = function(param1:Object):void
                     {
                        Application.instance.log("vipFreeRelive",JSON.stringify(param1));
                        if(param1.data.flag == 0)
                        {
                           VipManager.instance.vipPowerData.endlessReliveTime--;
                           reliveSelfPlayer();
                        }
                        else
                        {
                           TextTip.instance.showByLang("vipReliveFail");
                           loseCallBack();
                        }
                     };
                  })());
                  return;
               }
               if(AccountData.instance.boyaaCoin < EndlessTowerScreen.ReliveCost)
               {
                  TextTip.instance.showByLang("boyyabz");
                  sendResult(2);
                  Application.instance.currentGame.navigator.showScreen("ENDLESSTOWER");
                  return;
               }
               CopyServer.instance.endlessRelive(_currentLevel,_randNum);
            };
         })(),(function():*
         {
            var no:Function;
            return no = function():void
            {
               sendResult(2);
               Application.instance.currentGame.navigator.showScreen("ENDLESSTOWER");
            };
         })());
      }
      
      private function exitGame(param1:String) : void
      {
         if(param1 == "ENDLESSTOWERWORLD")
         {
            sendResult(2);
            dispatchEventWith("complete");
         }
      }
      
      private function showLeftMonsterCount() : void
      {
         txtLeftNum.text = LangManager.t("leftMonster") + getMonsterCount();
      }
      
      private function getMonsterCount() : int
      {
         var _loc1_:int = 0;
         for each(var _loc2_ in monsters)
         {
            if(_loc2_.hp > 0)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      override protected function reliveSelfPlayer() : void
      {
         super.reliveSelfPlayer();
         selfCharacterCtrl.downStart();
         selfCharacterCtrl.slottingCompleteSignal.add(slottingCompleteSignalHandle);
         selfCharacterCtrl.actionCompeleteSignal.add(actionCompleteHandle);
         selfCharacterCtrl.dieSignal.add(dieSignalHandle);
         _currentCtrl = 1;
         _gameOver = false;
         Starling.juggler.delayCall(switchCtrl,2);
         UILayer.showTopInfo(false);
      }
      
      private function clearMonsters() : void
      {
         for each(var _loc1_ in monsters)
         {
            if(_loc1_ is MonsterCtrl)
            {
               Starling.juggler.remove(MonsterCtrl(_loc1_));
               MonsterCtrl(_loc1_).dispose();
            }
            if(_loc1_ is BossCtrl)
            {
               Starling.juggler.remove(BossCtrl(_loc1_));
               BossCtrl(_loc1_).dispose();
            }
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         clearMonsters();
         monsters = null;
         MonsterCtrl.monsterAttrQueue.clear();
         Starling.juggler.remove(selfCharacterCtrl);
         Assets.btAsset.removeTextureAtlas("monsterskill");
         Assets.btAsset.removeTextureAtlas("monsterskill2");
         Assets.btAsset.removeTextureAtlas("spriteMonsterSkill");
         Assets.btAsset.removeTextureAtlas("emoticon");
         Assets.btAsset.removeMapTexture(209);
         Assets.btAsset.removeMapTexture(209,"bg");
         Assets.btAsset.removeTextureAtlas("battlefieldSpritesheet");
         Assets.btAsset.removeTextureAtlas("LeienSkillEffect");
         Assets.btAsset.removeSkeletonsAndBoneAtlases("LeienSkillEffect");
         Assets.btAsset.removeTextureAtlas("Leien");
         Assets.btAsset.removeSkeletonsAndBoneAtlases("Leien");
         Assets.btAsset.removeTextureAtlas("zhunhuang");
         Assets.btAsset.removeSkeletonsAndBoneAtlases("zhunhuang");
         unBindNet();
      }
   }
}

