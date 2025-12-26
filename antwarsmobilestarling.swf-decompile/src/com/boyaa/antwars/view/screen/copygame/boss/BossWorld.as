package com.boyaa.antwars.view.screen.copygame.boss
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.CopyMonsterRoleList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.CopyDetailData;
   import com.boyaa.antwars.data.model.CopyMonsterRole;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterCtrl;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.game.GameWorld;
   import com.boyaa.antwars.view.game.ICharacter;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.monster.MonsterCtrl;
   import com.boyaa.antwars.view.monster.MonsterData;
   import com.boyaa.antwars.view.monster.MonsterFactory;
   import com.boyaa.antwars.view.monster.MonsterInfoDlg;
   import com.boyaa.antwars.view.screen.PersonnalInfoDlg;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.battlefield.element.CharBox;
   import com.boyaa.antwars.view.screen.battlefield.element.OtherCharacterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.element.PokerView;
   import com.boyaa.antwars.view.screen.battlefield.element.TimerView;
   import com.boyaa.antwars.view.screen.copygame.CopyGameTips;
   import com.boyaa.antwars.view.screen.copygame.ReliveControl;
   import com.boyaa.antwars.view.screen.copygame.boss.member.BossCtrl;
   import com.boyaa.antwars.view.screen.copygame.boss.member.ZhunHuangBossCtrl;
   import com.boyaa.antwars.view.screen.copygame.element.CountDownTimer;
   import com.boyaa.antwars.view.screen.copygame.team.TeamRoom;
   import com.boyaa.antwars.view.vipSystem.VipManager;
   import com.boyaa.debug.Logging.LevelLogger;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.utils.formatString;
   
   public class BossWorld extends GameWorld
   {
      
      protected var currentCtrl:int = 0;
      
      protected var monsterCtrlVector:Vector.<ICharacterCtrl>;
      
      public var allMonsters:int = 0;
      
      protected var timePass:Number = 0;
      
      protected var _gameOver:Boolean = false;
      
      protected var timeLimit:Number = 5;
      
      protected var copyData:CopyDetailData;
      
      public var monsterAttack:Boolean = true;
      
      protected var monstersCount:Object = {};
      
      protected var flushMonstersCount:Object = {};
      
      protected var _monsterCDCount:int = 0;
      
      private var _monsterSelfCDCount:Object = {};
      
      private var _monsterRoleIdArr:Array = [];
      
      private var monsterDlg:MonsterInfoDlg;
      
      private var aboutme:PersonnalInfoDlg;
      
      private var aboutmeData:Object;
      
      private var isInit:Boolean = true;
      
      protected var _alldie:Boolean = true;
      
      public var otherCtrls:Vector.<OtherCharacterCtrl>;
      
      protected var bossCtrl:BossCtrl;
      
      protected var timer:TimerView;
      
      protected var _allPlayer:uint = 0;
      
      protected var _bossImagePath:String;
      
      private var deadSite:uint;
      
      private var deadUid:uint;
      
      protected var lossHpByMonster:uint = 0;
      
      protected var _isMonsterPow:int = 0;
      
      protected var dizzySite:int = 0;
      
      protected var bossSkill:int = 0;
      
      protected var lossHpHitByBoss:uint = 0;
      
      protected var isPow:uint = 0;
      
      protected var bossHitObject:Object = {};
      
      private var bulletHitArr:Array = [];
      
      private var _currentSite:int = 0;
      
      private var _progress:Number = 0;
      
      protected var _playerBornPoint:Array = [];
      
      private var _serverHpArr:Array = [];
      
      private var _isOtherShow:Boolean = false;
      
      protected var _monster_complete_count:int = 0;
      
      private var _firstRun:Boolean = true;
      
      protected var starNum:int = 0;
      
      protected var winExp:int = 0;
      
      protected var vipExp:int = 0;
      
      protected var goodsDataVector:Vector.<Object>;
      
      protected var pokerView:PokerView;
      
      protected var tips:CopyGameTips = new CopyGameTips();
      
      private var _countDownTimer:CountDownTimer;
      
      private var _ovarFlopCount:int;
      
      private var _disposeTime:int = 0;
      
      public function BossWorld()
      {
         super();
         Assets.btAsset = Assets.sAsset;
         bindNet();
      }
      
      public static function goBossFight() : void
      {
         var _loc2_:CopyDetailData = CopyList.instance.currentCopyData;
         var _loc1_:Array = [];
         _loc1_[2] = "ZHUNHUANGWORLD";
         _loc1_[3] = "LEIENTWORLD";
         if(_loc2_.cpid != 1)
         {
            Application.instance.currentGame.navigator.showScreen(_loc1_[_loc2_.cpid]);
         }
         else
         {
            Error("class:BossWorld--------没有副本信息，加载失败！");
         }
      }
      
      protected function playBgSound(param1:String, param2:Number = 0.1) : void
      {
         SoundManager.playBgSound(param1);
         SoundManager.bgVol = param2;
      }
      
      public function getBossHitObject() : Object
      {
         return bossHitObject;
      }
      
      override protected function init() : void
      {
         super.init();
         UILayer.copyTimeLimit = false;
         switch(copyData.cpid - 2)
         {
            case 0:
               _bossImagePath = "s1";
               break;
            case 1:
               _bossImagePath = "boss3";
         }
      }
      
      private function playerOverTimer() : void
      {
         UILayer.timer.visible = false;
         selfCharacterCtrl.ctrlStart(false);
         CopyServer.instance.sendPlayerGiveUp();
      }
      
      private function bindNet() : void
      {
         CopyServer.instance.onPlayerExitCopyGame(removePlayerFromCopyGame);
         CopyServer.instance.otherLeaveRoom(removePlayerFromCopyGame);
         CopyServer.instance.onPlayerMove(onOtherPlayerMove);
         CopyServer.instance.onBindUseProp(onOtherPlayerUseProp);
         CopyServer.instance.onRecvShooter(onSetShooter);
         CopyServer.instance.onPlayerGiverUp(onOtherPlayerGiveUp);
         CopyServer.instance.onCannonballBomb(onBombPoint);
         CopyServer.instance.onPlayerTimeout(onTimeOut);
         CopyServer.instance.onBossAttack(onCopyGameBossAttack);
         CopyServer.instance.onSwitchCtrl(onTurn);
         CopyServer.instance.onPlayerDead(onOtherPlayerDead);
         CopyServer.instance.onMonsterAttack(onMonsterAttackPlayer);
         CopyServer.instance.onGameOver(onCopyGameOver);
         CopyServer.instance.onRecvMonsterCount(onMonsterCount);
         CopyServer.instance.onLuckyDraw(onLuckyDraw);
         CopyServer.instance.monsterShootAttack(onCopyGameMonsterShootAttack);
         CopyServer.instance.playerRelivePublic(onCopyGamePublicRelive);
         CopyServer.instance.onChangeWeaponDone(onPlayerChangeWeapon);
      }
      
      private function unBindNet() : void
      {
         CopyServer.instance.disposeRecvFun(removePlayerFromCopyGame);
         CopyServer.instance.disposeRecvFun(onOtherPlayerMove);
         CopyServer.instance.disposeRecvFun(onOtherPlayerUseProp);
         CopyServer.instance.disposeRecvFun(onSetShooter);
         CopyServer.instance.disposeRecvFun(onOtherPlayerGiveUp);
         CopyServer.instance.disposeRecvFun(onBombPoint);
         CopyServer.instance.disposeRecvFun(onCopyGameBossAttack);
         CopyServer.instance.disposeRecvFun(onTurn);
         CopyServer.instance.disposeRecvFun(onOtherPlayerDead);
         CopyServer.instance.disposeRecvFun(onMonsterAttackPlayer);
         CopyServer.instance.disposeRecvFun(onCopyGameOver);
         CopyServer.instance.disposeRecvFun(onMonsterCount);
         CopyServer.instance.disposeRecvFun(onLuckyDraw);
         CopyServer.instance.disposeRecvFun(onCopyGameMonsterShootAttack);
         CopyServer.instance.disposeRecvFun(onCopyGamePublicRelive);
         CopyServer.instance.disposeRecvFun(onPlayerChangeWeapon);
      }
      
      protected function onMonsterCount(param1:Object) : void
      {
         allMonsters = param1.data.count;
      }
      
      protected function onCopyGameOver(param1:Object) : void
      {
         var flag:uint;
         var retData:Object = param1;
         Application.instance.log("BossWorld-onCopyGameOver",JSON.stringify(retData));
         flag = uint(retData.data.flag);
         winExp = retData.data.winExp;
         vipExp = retData.data.vipExp;
         PlayerDataList.instance.selfData.exp += winExp;
         if(flag)
         {
            Starling.juggler.delayCall(function():void
            {
               SoundManager.playSound("sound 27");
            },2.5);
         }
         else
         {
            UILayer.showReliveBtn(false);
         }
         Starling.juggler.delayCall((function():*
         {
            var winOrLost:Function;
            return winOrLost = function():void
            {
               gameOver(Boolean(flag));
            };
         })(),2);
      }
      
      private function onOtherPlayerDead(param1:Object) : void
      {
         deadUid = param1.data.uid;
         deadSite = param1.data.siteId;
      }
      
      private function onTurn(param1:Object) : void
      {
         Application.instance.log("BossWorld-onTurn",JSON.stringify(param1));
         currentCtrl = param1.data.currentCtrl;
         if(currentCtrl == 1)
         {
            selfCharacterCtrl.ctrlStart(false);
         }
         switchCtrl();
      }
      
      private function onMonsterAttackPlayer(param1:Object) : void
      {
         Application.instance.log("BossWorld-onMonsterAttackPlayer",JSON.stringify(param1));
         var _loc3_:uint = uint(param1.data.siteId);
         var _loc2_:uint = uint(param1.data.dropHp);
         var _loc5_:int = int(param1.data.isPow);
         var _loc4_:int = int(param1.data.attackSite);
         dropHpByServer(getCtrlBySiteID(_loc4_),getCtrlBySiteID(_loc3_),_loc2_,Boolean(_loc5_));
      }
      
      private function onCopyGameBossAttack(param1:Object) : void
      {
         Application.instance.log("BossWorld-onCopyGameBossAttack",JSON.stringify(param1));
         dizzySite = param1.data.siteId;
         bossSkill = param1.data.skill;
         lossHpHitByBoss = param1.data.dropHp;
         bossHitObject = param1;
      }
      
      private function onCopyGameMonsterShootAttack(param1:Object) : void
      {
         Application.instance.log("BossWorld-onCopyGameMonsterShootAttack",JSON.stringify(param1));
         dizzySite = param1.data.siteId;
      }
      
      private function onCopyGamePublicRelive(param1:Object) : void
      {
         Application.instance.log("BossWorld-onCopyGamePublicRelive",JSON.stringify(param1));
         sHelperPoint.setTo(param1.data.x,param1.data.y);
         reliveOtherPlayer(param1.data.siteID);
         _gameOver = false;
         removeCountDownTimeAndTips();
      }
      
      private function onPlayerChangeWeapon(param1:Object) : void
      {
         Application.instance.log("onPlayerChangeWeapon-Boss",JSON.stringify(param1));
         if(param1.data.uid == PlayerDataList.instance.selfData.uid)
         {
            return;
         }
         var _loc3_:PlayerData = PlayerDataList.instance.getDataByUID(param1.data.uid);
         var _loc2_:GoodsData = new GoodsData();
         _loc2_.updateGoodsInfo(param1.data.weaponArr);
         CharacterCtrl(getCtrlBySiteID(_loc3_.siteID)).changeWeapon(_loc2_);
      }
      
      private function onCopyGameSelfRelive(param1:Object) : void
      {
         Application.instance.log("BossWorld-onCopyGameSelfRelive",JSON.stringify(param1));
         if(param1.data.flag == 0)
         {
            return;
         }
         reliveSelfPlayer();
         _gameOver = false;
         AccountData.instance.updateBoyaaCoin(param1.data.boyaaCoin);
      }
      
      private function onTimeOut(param1:Object) : void
      {
         var _loc3_:ICharacterCtrl = null;
         Application.instance.log("BossWorld-onTimeOut",JSON.stringify(param1));
         var _loc2_:int = int(param1.data.uid);
         var _loc4_:int = int(param1.data.siteId);
         if(_loc4_ == selfCharacterCtrl.siteID)
         {
            trace("do nothing, selfCharacterCtrl site:",selfCharacterCtrl.siteID,"my site:",PlayerDataList.instance.selfData.siteID);
         }
         else
         {
            _loc3_ = getOtherPlayerBySiteID(_loc4_);
            if(!_loc3_)
            {
               throw new Error("onTimeOut 玩家超时异常，找不到其他玩家, siteid:" + _loc4_);
            }
            OtherCharacterCtrl(_loc3_).ctrlStart(false);
         }
      }
      
      protected function onBombPoint(param1:Object) : void
      {
         Application.instance.log("BossWorld-onBombPoint",JSON.stringify(param1));
         if(param1.data.senderSiteID == selfCharacterCtrl.siteID)
         {
            for each(var _loc2_ in param1.data.hitArr)
            {
               dropHpByServer(getCtrlBySiteID(_loc2_[7]),getCtrlBySiteID(_loc2_[0]),_loc2_[8],_loc2_[9]);
               if(getCtrlBySiteID(_loc2_[0]) is ZhunHuangBossCtrl)
               {
                  ZhunHuangBossCtrl(getCtrlBySiteID(_loc2_[0])).getHpPercentage();
               }
            }
         }
         else
         {
            bulletHitArr.push(param1.data);
         }
      }
      
      private function onOtherPlayerGiveUp(param1:Object) : void
      {
         var uid:int;
         var siteId:int;
         var other:ICharacterCtrl;
         var retData:Object = param1;
         Application.instance.log("BossWorld-onOtherPlayerGiveUp",JSON.stringify(retData));
         uid = int(retData.data.uid);
         siteId = int(retData.data.siteId);
         Starling.juggler.delayCall((function():*
         {
            var delay:Function;
            return delay = function():void
            {
               CopyServer.instance.sendOtherPlayerComplete();
            };
         })(),1);
         other = getCtrlBySiteID(siteId);
         if(other is OtherCharacterCtrl)
         {
            OtherCharacterCtrl(other).ctrlStart(false);
         }
      }
      
      private function onSetShooter(param1:Object) : void
      {
         Application.instance.log("BossWorld-onSetShooter",JSON.stringify(param1));
         var _loc4_:int = int(param1.data.prevSiteId);
         var _loc2_:int = int(param1.data.siteId);
         _currentSite = _loc2_;
         for each(var _loc3_ in otherCtrls)
         {
            _loc3_.ctrlStart(false);
         }
         switchCtrl();
      }
      
      private function onOtherPlayerUseProp(param1:Object) : void
      {
         Application.instance.log("BossWorld-onOtherPlayerUseProp",JSON.stringify(param1));
         var _loc2_:int = int(param1.data.siteID);
         var _loc4_:int = int(param1.data.uid);
         var _loc6_:int = int(param1.data.type);
         var _loc3_:ICharacterCtrl = getCtrlBySiteID(_loc2_);
         if(_loc3_.siteID != PlayerDataList.instance.selfData.siteID)
         {
            OtherCharacterCtrl(_loc3_).useProp(_loc6_);
         }
         if(_loc6_ == 12)
         {
            for each(var _loc5_ in PlayerDataList.instance.list)
            {
               if(_loc2_ != _loc5_.siteID)
               {
                  if(getCtrlBySiteID(_loc5_.siteID).hp > 0)
                  {
                     addHp([_loc5_.siteID,300]);
                  }
               }
            }
         }
      }
      
      private function onOtherPlayerMove(param1:Object) : void
      {
         var _loc2_:int = int(param1.data.siteID);
         var _loc4_:int = int(param1.data.uid);
         var _loc3_:OtherCharacterCtrl = getOtherPlayerBySiteID(_loc2_);
         if(_loc3_)
         {
            _loc3_.addSetpData(param1.data.data);
         }
      }
      
      private function getOtherPlayerBySiteID(param1:int) : OtherCharacterCtrl
      {
         var _loc2_:int = 0;
         if(!otherCtrls)
         {
            return null;
         }
         _loc2_ = 0;
         while(_loc2_ < otherCtrls.length)
         {
            if(param1 == otherCtrls[_loc2_].siteID)
            {
               return otherCtrls[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function removePlayerFromCopyGame(param1:Object) : void
      {
         Application.instance.log("BossWorld-removePlayerFromCopyGame",JSON.stringify(param1));
         var _loc2_:int = int(param1.data.uid);
         var _loc3_:int = int(param1.data.siteId);
         if(otherCtrls != null)
         {
            removeOtherPlayerBySiteId(_loc3_);
         }
         PlayerDataList.instance.removePlayerByUID(_loc2_);
         if(_loc3_ == PlayerDataList.instance.selfData.siteID)
         {
            Application.instance.currentGame.navigator.showScreen("TEAMLIST");
         }
      }
      
      override protected function initialize() : void
      {
         initData();
         Application.instance.currentGame.showLoading();
         Assets.btAsset.enqueueMap(copyData.mapid,"map_" + copyData.mapid);
         loadAssets(Application.instance.resManager);
         Assets.btAsset.loadQueue(onProgress);
      }
      
      protected function onProgress(param1:Number) : void
      {
         var ratio:Number = param1;
         if(ratio >= _progress)
         {
            CopyServer.instance.sendMapProgress(ratio);
            _progress += 0.25;
         }
         if(ratio == 1)
         {
            CopyServer.instance.sendMapComplete();
            CopyServer.instance.onBossFightPlay(function(param1:Object):void
            {
               var retData:Object = param1;
               Starling.juggler.delayCall(function():void
               {
                  init();
                  buildWorld(copyData.mapid);
                  startGame();
                  Application.instance.currentGame.hiddenLoading();
               },0.15);
            });
         }
      }
      
      protected function flushBoss() : void
      {
      }
      
      protected function ctrlStart() : void
      {
         var otherCtrl:OtherCharacterCtrl;
         var monsterCtrl:*;
         var item:int;
         if(_gameOver)
         {
            return;
         }
         if(_currentSite != selfCharacterCtrl.siteID)
         {
            selfCharacterCtrl.ctrlStart(false);
            UILayer.timer.visible = false;
            UILayer.timer.stop();
         }
         if(currentCtrl == 0 && _currentSite == selfCharacterCtrl.siteID)
         {
            cameraFocusCtrlByTouch(true);
            camera.swapFocus(selfCharacterCtrl.icharacter);
            playMyGo(function():void
            {
               if(selfCharacterCtrl)
               {
                  selfCharacterCtrl.ctrlStart(true);
               }
            });
            if(stateObject != null)
            {
               stateSignal.dispatch(selfCharacterCtrl);
            }
         }
         else if(currentCtrl == 0 && _currentSite != selfCharacterCtrl.siteID)
         {
            _isOtherShow = false;
            otherCtrl = getOtherPlayerBySiteID(_currentSite);
            if(otherCtrl)
            {
               camera.swapFocus(otherCtrl.icharacter);
               otherCtrl.ctrlStart(true);
               if(stateObject != null)
               {
                  stateSignal.dispatch(otherCtrl);
               }
            }
         }
         else if(currentCtrl == 1)
         {
            MonsterCtrl.monsterAttrQueue.clear();
            Application.instance.log("BossWorld-ctrlStart",JSON.stringify(bossHitObject));
            _monsterCDCount = _monsterCDCount + 1;
            _monster_complete_count = 0;
            for each(monsterCtrl in monsterCtrlVector)
            {
               monsterCtrl.attackTarget = getCtrlBySiteID(dizzySite).icharacter;
               if(!monsterCtrl.attackTarget)
               {
                  monsterCtrl.actionCompleteSignal.dispatch();
                  return;
               }
               if(monsterCtrl as BossCtrl)
               {
                  BossCtrl(monsterCtrl).setAttackSkill(bossSkill);
                  BossCtrl(monsterCtrl).ctrlStart();
               }
               else
               {
                  if(MonsterCtrl(monsterCtrl)._monster.data.attack_type == 1)
                  {
                     MonsterCtrl(monsterCtrl).attackTarget = MonsterCtrl(monsterCtrl).findNearestTarget();
                     trace("最近的目标是" + MonsterCtrl(monsterCtrl).attackTarget.icharacterCtrl.siteID);
                  }
                  MonsterCtrl(monsterCtrl).ctrlStart();
               }
            }
            trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            for each(item in _monsterRoleIdArr)
            {
               _monsterSelfCDCount[item]++;
            }
            currentCtrl = 2;
         }
      }
      
      protected function switchCtrl() : void
      {
         flushBoss();
         Starling.juggler.delayCall(ctrlStart,1);
      }
      
      protected function loadAssets(param1:ResManager) : void
      {
         Assets.btAsset.enqueue(param1.getResFile(formatString("textures/{0}x/BT/battlefieldSpritesheet.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/BT/battlefieldSpritesheet.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/BT/BattlefieldUI.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/BT/BattlefieldUI.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYGAME/monsterskill.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYGAME/monsterskill.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/BT/emoticon.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/BT/emoticon.xml",Assets.sAsset.scaleFactor)));
      }
      
      protected function initData() : void
      {
         copyData = CopyList.instance.currentCopyData;
         timeLimit = copyData.powerTips;
         MonsterFactory.dispose();
      }
      
      protected function startGame() : void
      {
         var i:int;
         getMap().mapSolid = true;
         UILayer.timer.timeoverSignal.add(playerOverTimer);
         UILayer.timer.visible = false;
         addBossHeadImg(_bossImagePath);
         monsterCtrlVector = new Vector.<ICharacterCtrl>();
         i = 0;
         while(i < copyData.monsterList.length)
         {
            monstersCount[copyData.monsterList[i].roleid] = 0;
            flushMonstersCount[copyData.monsterList[i].roleid] = 0;
            i = i + 1;
         }
         CopyServer.instance.getBornPointFromServer(function(param1:Object):void
         {
            var retData:Object = param1;
            _playerBornPoint = retData.data.arr;
            addPlayer();
            Starling.juggler.delayCall((function():*
            {
               var call:Function;
               return call = function():void
               {
                  CopyServer.instance.sendGetFirstShoot();
                  GameServer.instance.sentConsumeEnergy();
                  GameServer.instance.getConsumeEnergy((function():*
                  {
                     var call:Function;
                     return call = function(param1:Object):void
                     {
                        var _loc2_:int = int(param1.data.userId);
                        var _loc4_:int = int(param1.data.type);
                        var _loc3_:int = int(param1.data.energy);
                        PlayerDataList.instance.selfData.energy = _loc3_;
                     };
                  })());
               };
            })(),2);
         });
         CopyServer.instance.getFreeReliveTimes((function():*
         {
            var cb:Function;
            return cb = function(param1:Object):void
            {
               Application.instance.log("getFreeReliveTimes",JSON.stringify(param1));
               VipManager.instance.vipPowerData.copyReliveTime = param1.data.freeleft;
            };
         })());
      }
      
      protected function addPlayer() : void
      {
         var _loc1_:int = int(PlayerDataList.instance.selfData.siteID);
         var _loc2_:Point = new Point(_playerBornPoint[_loc1_][0],_playerBornPoint[_loc1_][1]);
         this.addSelfToWorld(_loc2_);
         selfCharacterCtrl.downStart();
         selfCharacterCtrl.slottingCompleteSignal.add(slottingCompleteSignalHandle);
         selfCharacterCtrl.actionCompeleteSignal.add(actionCompleteHandle);
         selfCharacterCtrl.ctrlStartSignal.add(myCtrlStartInit);
         selfCharacterCtrl.ctrlCompeleteSignal.add(ctrlEndSignalHandle);
         selfCharacterCtrl.dieSignal.addOnce(dieSignalHandle);
         selfCharacterCtrl.setServer(CopyServer.instance);
         CharBox.aboutMeSignal.add(aboutMe);
         UILayer.hiddenBottomBar();
         _serverHpArr = Application.instance.currentGame._copyModeOptionsData.playerInfoArr;
         selfCharacterCtrl.maxHp = _serverHpArr[_loc1_];
         selfCharacterCtrl.hp = selfCharacterCtrl.maxHp;
         _allPlayer = PlayerDataList.instance.list.length;
         addOtherPlayer();
         addEventListener("enterFrame",onEnterFrameHandler);
      }
      
      override protected function myCtrlStartInit(param1:Boolean) : void
      {
         super.myCtrlStartInit(param1);
         if(param1)
         {
            UILayer.timer.visible = true;
            UILayer.timer.start(17);
         }
      }
      
      private function ctrlEndSignalHandle(param1:int) : void
      {
         UILayer.timer.visible = false;
         UILayer.timer.stop();
      }
      
      protected function getCtrlBySiteID(param1:int) : ICharacterCtrl
      {
         var _loc2_:ICharacterCtrl = null;
         var _loc3_:ICharacterCtrl = null;
         if(selfCharacterCtrl.siteID == param1)
         {
            return selfCharacterCtrl;
         }
         _loc2_ = getOtherPlayerBySiteID(param1);
         if(_loc2_)
         {
            return _loc2_;
         }
         _loc3_ = getMonsterBySiteID(param1);
         if(_loc3_)
         {
            return _loc3_;
         }
         throw new Error("getCtrlBySiteID 出错，找不到该座位的控制者 sid:" + param1);
      }
      
      protected function getMonsterBySiteID(param1:int) : ICharacterCtrl
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < monsterCtrlVector.length)
         {
            if(param1 == monsterCtrlVector[_loc2_].siteID)
            {
               return monsterCtrlVector[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function onEnterFrameHandler(param1:EnterFrameEvent) : void
      {
         var _loc3_:Object = null;
         camera.update();
         if(!_gameOver)
         {
            while(bulletHitArr.length > 0)
            {
               _loc3_ = bulletHitArr.shift();
               for each(var _loc2_ in _loc3_.hitArr)
               {
                  dropHpByServer(getCtrlBySiteID(_loc2_[7]),getCtrlBySiteID(_loc2_[0]),_loc2_[8],_loc2_[9]);
                  if(getCtrlBySiteID(_loc2_[0]) is ZhunHuangBossCtrl)
                  {
                     ZhunHuangBossCtrl(getCtrlBySiteID(_loc2_[0])).getHpPercentage();
                  }
               }
            }
            if(bulletHitArr.length == 0 && !_isOtherShow)
            {
               _isOtherShow = true;
            }
         }
      }
      
      private function dieSignalHandle(param1:int, param2:String) : void
      {
         if(param2 == "drop" || param2 == "hp")
         {
            if(param1 == selfCharacterCtrl.siteID)
            {
               trace("玩家死亡！");
               if(param2 == "drop")
               {
                  CopyServer.instance.sendPlayerDead();
               }
               ReliveControl.instance.removeSignalFunc(reliveSignalHandle);
               if(Application.instance.getAppVersionNamber() != "1.14.0")
               {
                  if(getAlivePlayerArr() >= 1)
                  {
                     UILayer.showReliveBtn(true);
                  }
               }
               ReliveControl.instance.addSignalFunc(reliveSignalHandle,false);
            }
         }
      }
      
      private function reliveSignalHandle(param1:Array) : void
      {
         var arr:Array = param1;
         var flag:String = arr[0];
         if(flag == "pause")
         {
         }
         if(flag == "no")
         {
            _countDownTimer && _countDownTimer.setPause(false);
         }
         if(flag == "yes")
         {
            CopyServer.instance.selfReliveInBossRoom((function():*
            {
               var cb:Function;
               return cb = function(param1:Object):void
               {
                  LevelLogger.getLogger("BossWorld-reliveSignalHandle").info(JSON.stringify(param1));
                  if(param1.data.flag == 0)
                  {
                     TextTip.instance.showByLang("boyyabz");
                     _countDownTimer.setPause(false);
                     return;
                  }
                  if(param1.data.flag == 1)
                  {
                     _gameOver = false;
                     AccountData.instance.updateBoyaaCoin(param1.data.boyaaCoin);
                     sHelperPoint.setTo(param1.data.x,param1.data.y);
                     reliveSelfPlayer();
                     removeCountDownTimeAndTips();
                  }
               };
            })());
            if(VipManager.instance.vipPowerData.copyReliveTime > 0)
            {
               CopyServer.instance.useFreeRelive(1,(function():*
               {
                  var cb:Function;
                  return cb = function(param1:Object):void
                  {
                     Application.instance.log("useFreeReliveInBoss",JSON.stringify(param1));
                  };
               })());
               return;
            }
            if(AccountData.instance.boyaaCoin < arr[1])
            {
               TextTip.instance.showByLang("boyyabz");
               _countDownTimer.setPause(false);
               return;
            }
            CopyServer.instance.sendReliveInBossRoom();
         }
      }
      
      private function removeCountDownTimeAndTips() : void
      {
         if(_countDownTimer)
         {
            _countDownTimer.stop();
            _countDownTimer.removeFromParent(true);
         }
         if(tips)
         {
            tips.removeFromParent(false);
         }
      }
      
      protected function addOtherPlayer() : void
      {
         this.otherCtrls = new Vector.<OtherCharacterCtrl>();
         var _loc2_:int = 0;
         for each(var _loc1_ in PlayerDataList.instance.list)
         {
            trace("玩家的座位:" + _loc1_.siteID);
            if(_loc1_.uid != PlayerDataList.instance.selfData.uid)
            {
               sHelperPoint.setTo(_playerBornPoint[_loc1_.siteID][0],_playerBornPoint[_loc1_.siteID][1]);
               newOtherPlayer(_loc1_,sHelperPoint);
            }
         }
         LevelLogger.getLogger("addOtherPlayer").info("otherCtrl\'s length:" + otherCtrls.length);
      }
      
      protected function removeOtherPlayerBySiteId(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < otherCtrls.length)
         {
            if(param1 == otherCtrls[_loc2_].siteID)
            {
               otherCtrls[_loc2_].setBadState();
               otherCtrls[_loc2_].ctrlStart(false);
               if(otherCtrls[_loc2_].character)
               {
                  otherCtrls[_loc2_].character.removeFromParent(true);
                  otherCtrls[_loc2_].dispose();
               }
               LevelLogger.getLogger("removeOtherPlayerBySiteId").info("otherCtrl\'s name:" + otherCtrls[_loc2_].roleName.text);
               otherCtrls.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      override public function onPassBtnHandle() : void
      {
         super.onPassBtnHandle();
         if(isMyCtrl())
         {
            UILayer.timer.visible = false;
            UILayer.timer.stop();
            CopyServer.instance.sendPlayerGiveUp();
         }
      }
      
      override protected function isMyCtrl() : Boolean
      {
         return currentCtrl == 0;
      }
      
      private function actionCompleteHandle(param1:int = 0) : void
      {
         var _loc2_:OtherCharacterCtrl = null;
         if(param1 == selfCharacterCtrl.siteID)
         {
            CopyServer.instance.sendPlayerDone();
            trace(selfCharacterCtrl.roleName.text + "玩家操作完毕！");
         }
         else
         {
            _isOtherShow = true;
            _loc2_ = getOtherPlayerBySiteID(param1);
            _loc2_.ctrlStart(false);
            _loc2_.changeStatus("DOWN");
            CopyServer.instance.sendOtherPlayerComplete();
            trace(_loc2_.roleName.text + "玩家操作完毕！");
         }
         cameraFocusCtrlByTouch(true);
      }
      
      protected function slottingCompleteSignalHandle(param1:int, param2:Array) : void
      {
         var _loc5_:int = 0;
         var _loc4_:int = int(param2.shift());
         var _loc3_:* = param2;
         if(param1 == selfCharacterCtrl.siteID)
         {
            CopyServer.instance.sendCannonball(_loc3_[0],_loc3_[1],_loc3_[2],_loc3_[3]);
         }
         if(_loc4_ == 2 || _loc4_ == 3)
         {
            return;
         }
         selfCharacterCtrl.downStart();
         _loc5_ = 0;
         while(_loc5_ < otherCtrls.length)
         {
            otherCtrls[_loc5_].downStart();
            _loc5_++;
         }
      }
      
      protected function bossAttackHandle(param1:String, param2:BossCtrl) : void
      {
      }
      
      protected function monsterAttackHandle(param1:String, param2:MonsterCtrl) : void
      {
         var _loc3_:uint = uint(param2.attackTarget.icharacterCtrl.siteID);
         if(getCtrlBySiteID(_loc3_) != selfCharacterCtrl && param1 != "palsy")
         {
            return;
         }
         switch(param1)
         {
            case "attack":
               dropHp(param2,getCtrlBySiteID(_loc3_));
               break;
            case "palsy":
               stateOfParalysis(getCtrlBySiteID(_loc3_),"palsy");
               break;
            case "chain":
               stateOfParalysis(getCtrlBySiteID(_loc3_),"chain");
               break;
            default:
               dropHp(param2,getCtrlBySiteID(_loc3_));
         }
      }
      
      protected function removeMonsterDie() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < monsterCtrlVector.length)
         {
            if(monsterCtrlVector[_loc1_].hp < 0)
            {
               monsterCtrlVector.slice(_loc1_,1);
               _loc1_--;
            }
            _loc1_++;
         }
      }
      
      protected function monsterActionCompleteHandle() : void
      {
         _monster_complete_count = _monster_complete_count + 1;
         trace("BossWorld-monsterActionCompleteHandle 怪物完成操作 " + _monster_complete_count + " 次");
         if(_monster_complete_count >= getCurrentMonstersSum())
         {
            Application.instance.log("BossWorld","告知服务器怪物演示完成！！！！！");
            CopyServer.instance.sendMonsterShow();
            monsterAttack = false;
         }
      }
      
      protected function getCurrentMonstersSum() : int
      {
         var _loc2_:int = 0;
         for each(var _loc1_ in monsterCtrlVector)
         {
            if(_loc1_.hp > 0)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      override public function addHp(param1:Array) : void
      {
         super.addHp(param1);
         var _loc3_:ICharacterCtrl = getCtrlBySiteID(param1[0]);
         var _loc2_:ICharacter = _loc3_.icharacter;
         if(_loc3_.siteID != selfCharacterCtrl.siteID)
         {
            _loc3_.hp += param1[1];
            UILayer.updateCharHP(param1[0],_loc3_.hp);
         }
      }
      
      protected function aboutMe(param1:int) : void
      {
         var _loc2_:PlayerData = PlayerDataList.instance.getDataBySiteID(param1);
         if(aboutme == null)
         {
            aboutme = new PersonnalInfoDlg();
         }
         Remoting.instance.getMemStatus(_loc2_.uid,getPlayerInfo);
         this.UILayer.addChild(aboutme);
      }
      
      private function getPlayerInfo(param1:Object) : void
      {
         Application.instance.log("AboutMe显示人个信息:",JSON.stringify(param1));
         aboutmeData = param1;
         aboutme.showPlayerInfo(param1);
         aboutme.isFriend = true;
      }
      
      protected function addBossHeadImg(param1:String = "") : void
      {
         var _loc2_:Button = new Button(Assets.sAsset.getTexture("charbox0"),"",Assets.sAsset.getTexture("charbox1"));
         var _loc4_:Image = new Image(Assets.sAsset.getTexture(param1));
         _loc4_.height = 87;
         _loc4_.scaleX = _loc4_.scaleY;
         _loc4_.touchable = false;
         var _loc3_:Rectangle = Assets.getPosition("bfUILayer","charbox3");
         _loc2_.x = _loc3_.x;
         _loc2_.y = _loc3_.y;
         this.UILayer.addChild(_loc2_);
         this.UILayer.addChild(_loc4_);
         _loc4_.y = _loc3_.y + 5;
         _loc4_.x = _loc3_.x + 10;
         _loc2_.addEventListener("triggered",showMonsterInfo);
      }
      
      private function showMonsterInfo(param1:Event) : void
      {
      }
      
      public function gameOver(param1:Boolean) : void
      {
         var win:Boolean = param1;
         if(!_gameOver)
         {
            tips.setTipPosition();
            _gameOver = true;
            selfCharacterCtrl.ctrlStart(false);
            Starling.juggler.remove(selfCharacterCtrl);
            UILayer.timer.stop();
            if(win)
            {
               MissionManager.instance.updateMissionData(172,0,copyData.cpdtlid);
               getGrade();
               Remoting.instance.getMobileCopyPrize(copyData.cpdtlid,copyData.cpid,copyData.stage,copyData.difficulty,starNum,function(param1:Object):void
               {
               });
               gameOverAnimation(win,gameOverWinShow);
            }
            else
            {
               SoundManager.playSound("sound 28");
               gameOverAnimation(win,lostShow);
            }
         }
      }
      
      private function lostShow() : void
      {
         _countDownTimer = CountDownTimer.show(this,10,(function():*
         {
            var call:Function;
            return call = function():void
            {
               if(CopyServer.instance.isConnect)
               {
                  TeamRoom.fromCopyGame();
               }
            };
         })());
         addChild(tips);
         tips.showTip(1);
         if(Application.instance.getAppVersionNamber() != "1.14.0")
         {
            UILayer.showReliveBtn(true);
         }
      }
      
      private function gameOverWinShow() : void
      {
         pokerView = new PokerView();
         pokerView.showTimeView = false;
         pokerView.expText.text = winExp.toString();
         addChild(pokerView);
         pokerView.play(0);
         pokerView.star.updateStarNum(starNum);
         pokerView.clickPokerSignal.add(showPoker);
         Timepiece.instance.addDelayCall(backToTeamRoomTimeOut,10000);
      }
      
      private function backToTeamRoomTimeOut() : void
      {
         if(pokerView && Application.instance.currentGame.navigator.activeScreenID != "TEAMROOM")
         {
            TeamRoom.fromCopyGame();
         }
      }
      
      private function showPoker(param1:int) : void
      {
         CopyServer.instance.luckyDraw(param1);
      }
      
      private function onLuckyDraw(param1:Object) : void
      {
         var retData:Object = param1;
         LevelLogger.getLogger("BossWorld,onLuckyDraw").info(JSON.stringify(retData));
         if(pokerView)
         {
            pokerView.overturnPoker(retData.data.cardNum,retData.data,function():void
            {
               _ovarFlopCount = _ovarFlopCount - 1;
               if(_ovarFlopCount <= 0)
               {
                  Starling.juggler.delayCall(TeamRoom.fromCopyGame,3);
               }
            });
         }
      }
      
      protected function dispatchMessage() : void
      {
         switch(copyData.cpid - 1)
         {
            case 0:
               dispatchEventWith("complete");
               break;
            case 1:
               dispatchEventWith("showSpiderCity");
               break;
            default:
               dispatchEventWith("complete");
         }
      }
      
      protected function getGrade() : void
      {
         if(timePass < 300)
         {
            starNum = 3;
         }
         else if(timePass < 480)
         {
            starNum = 2;
         }
         else if(timePass < 600)
         {
            starNum = 1;
         }
         else
         {
            starNum = 1;
         }
         if(starNum > copyData.owner_grade)
         {
            copyData.owner_grade = starNum;
         }
      }
      
      override protected function update(param1:Number) : void
      {
         timePass += param1;
         if(!_gameOver)
         {
            MonsterCtrl.monsterAttrQueue.start();
         }
      }
      
      override public function get totalCDCount() : int
      {
         return _monsterCDCount;
      }
      
      override public function dispose() : void
      {
         Timepiece.instance.removeFun(backToTeamRoomTimeOut,2);
         ReliveControl.instance.removeSignalFunc(reliveSignalHandle);
         _disposeTime = _disposeTime + 1;
         Application.instance.log("BossWorld-dispose, disposeTime:",_disposeTime.toString());
         _gameOver = true;
         unBindNet();
         SystemTip.instance.hide();
         for each(var _loc2_ in monsterCtrlVector)
         {
            if(_loc2_ as BossCtrl)
            {
               BossCtrl(_loc2_).dispose();
               Starling.juggler.remove(BossCtrl(_loc2_));
            }
            else
            {
               MonsterCtrl(_loc2_).dispose();
               Starling.juggler.remove(MonsterCtrl(_loc2_));
            }
         }
         for each(var _loc1_ in otherCtrls)
         {
            removeOtherPlayerBySiteId(_loc1_.siteID);
         }
         MonsterCtrl.monsterAttrQueue.clear();
         monsterDlg && monsterDlg.removeFromParent(true);
         aboutme && aboutme.removeFromParent(true);
         SoundManager.stopBgSound();
         CharBox.aboutMeSignal.removeAll();
         UILayer.onPassBtnSignal.removeAll();
         Assets.btAsset.removeMapTexture(copyData.mapid);
         Assets.btAsset.removeMapTexture(copyData.mapid,"bg");
         Assets.btAsset.removeTextureAtlas("battlefieldSpritesheet");
         Assets.btAsset.removeTextureAtlas("emoticon");
         Assets.btAsset.removeTextureAtlas("monsterskill");
         super.dispose();
      }
      
      public function showLeftNumText() : void
      {
         switch(copyData.mapid)
         {
            case 202:
               txtLeftNum.text = LangManager.t("lastCount") + allMonsters;
               break;
            case 1002:
               txtLeftNum.text = LangManager.t("robotSelf") + allMonsters;
               break;
            default:
               txtLeftNum.text = LangManager.t("leftMonster") + allMonsters;
         }
      }
      
      private function getAlivePlayerArr() : int
      {
         var _loc1_:int = 0;
         if(!selfCharacterCtrl.isDie)
         {
            _loc1_++;
         }
         for each(var _loc2_ in otherCtrls)
         {
            if(!_loc2_.isDie)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      private function newOtherPlayer(param1:PlayerData, param2:Point) : void
      {
         var _loc4_:Character = CharacterFactory.instance.checkOutCharacter(param1.babySex);
         _loc4_.initData(param1.getPropData());
         LevelLogger.getLogger("BossWorld").info("buildOtherCharacter playerData.siteID:" + param1.siteID + " mid:" + param1.uid);
         var _loc3_:OtherCharacterCtrl = new OtherCharacterCtrl(this,_loc4_,param1.siteID,param1.HP,param1.babyName);
         _loc3_.actionCompeleteSignal.add(actionCompleteHandle);
         _loc3_.slottingCompleteSignal.add(slottingCompleteSignalHandle);
         _loc3_.dieSignal.addOnce(dieSignalHandle);
         _loc3_.setAttr();
         _loc3_.downStart();
         _loc3_.maxHp = _serverHpArr[_loc3_.siteID];
         _loc3_.hp = _loc3_.maxHp;
         this._charatersLayer.addChild(_loc4_);
         _loc4_.x = param2.x;
         _loc4_.y = param2.y;
         otherCtrls.push(_loc3_);
      }
      
      override protected function reliveOtherPlayer(param1:int) : void
      {
         super.reliveOtherPlayer(param1);
         removeOtherPlayerBySiteId(param1);
         var _loc2_:PlayerData = PlayerDataList.instance.getDataBySiteID(param1);
         newOtherPlayer(_loc2_,sHelperPoint);
         removeCountDownTimeAndTips();
      }
      
      override protected function reliveSelfPlayer() : void
      {
         UILayer.clearCharBySiteID(PlayerDataList.instance.selfData.siteID);
         if(selfCharacterCtrl)
         {
            if(selfCharacterCtrl.character)
            {
               selfCharacterCtrl.character.removeFromParent(true);
               CharacterFactory.instance.checkInCharacter(selfCharacterCtrl.character as Character);
            }
            selfCharacterCtrl.dispose();
         }
         addSelfToWorld(sHelperPoint);
         playerReliveCount = playerReliveCount + 1;
         selfCharacterCtrl.downStart();
         selfCharacterCtrl.slottingCompleteSignal.add(slottingCompleteSignalHandle);
         selfCharacterCtrl.actionCompeleteSignal.add(actionCompleteHandle);
         selfCharacterCtrl.ctrlStartSignal.add(myCtrlStartInit);
         selfCharacterCtrl.ctrlCompeleteSignal.add(ctrlEndSignalHandle);
         selfCharacterCtrl.dieSignal.addOnce(dieSignalHandle);
         selfCharacterCtrl.setServer(CopyServer.instance);
         selfCharacterCtrl.maxHp = _serverHpArr[selfCharacterCtrl.siteID];
         selfCharacterCtrl.hp = selfCharacterCtrl.maxHp;
         UILayer.showReliveBtn(false);
      }
   }
}

