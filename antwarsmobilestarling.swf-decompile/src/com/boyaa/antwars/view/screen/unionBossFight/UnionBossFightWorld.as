package com.boyaa.antwars.view.screen.unionBossFight
{
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.CopyMonsterRoleList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.CopyMonsterRole;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.game.GameWorld;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.monster.MonsterCtrl;
   import com.boyaa.antwars.view.monster.MonsterData;
   import com.boyaa.antwars.view.monster.MonsterFactory;
   import com.boyaa.antwars.view.screen.copygame.boss.member.BossCtrl;
   import com.boyaa.antwars.view.screen.copygame.boss.member.BossMonster;
   import com.boyaa.antwars.view.screen.copygame.boss.member.ScorpionKindCtrl;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.utils.formatString;
   
   public class UnionBossFightWorld extends GameWorld
   {
      
      private static const PLAYER:int = 0;
      
      private static const MONSTER:int = 1;
      
      private static const SHOWTIME:int = 2;
      
      public static var backToBossFight:Boolean = false;
      
      private var _mapId:int = 210;
      
      private var _bossType:int = 27;
      
      private var _gameOver:Boolean = false;
      
      private var _currentCtrl:int = 0;
      
      private var _optionObject:Object = {};
      
      private var _bossAttackObject:Object = {};
      
      private var _monsters:Vector.<ICharacterCtrl> = new Vector.<ICharacterCtrl>();
      
      public function UnionBossFightWorld()
      {
         super();
         initOptionData();
         loadAssets();
      }
      
      private function initOptionData() : void
      {
         _optionObject = Application.instance.currentGame._copyModeOptionsData;
         _mapId = _optionObject.data.mapId;
         _bossType = _optionObject.data.bossType;
      }
      
      protected function loadAssets() : void
      {
         Application.instance.currentGame.showLoading();
         Assets.btAsset = Assets.sAsset;
         Assets.btAsset.enqueueMap(_mapId,"map_" + _mapId);
         Assets.sAsset.enqueue(Application.instance.resManager.getResFile(formatString("textures/{0}x/BT/battlefieldSpritesheet.png",Assets.sAsset.scaleFactor)),Application.instance.resManager.getResFile(formatString("textures/{0}x/BT/battlefieldSpritesheet.xml",Assets.sAsset.scaleFactor)),Application.instance.resManager.getResFile(formatString("textures/{0}x/BT/BattlefieldUI.png",Assets.sAsset.scaleFactor)),Application.instance.resManager.getResFile(formatString("textures/{0}x/BT/BattlefieldUI.xml",Assets.sAsset.scaleFactor)),Application.instance.resManager.getResFile(formatString("textures/{0}x/BT/emoticon.png",Assets.sAsset.scaleFactor)),Application.instance.resManager.getResFile(formatString("textures/{0}x/BT/emoticon.xml",Assets.sAsset.scaleFactor)));
         Assets.sAsset.loadQueue(loadingComplete);
      }
      
      private function loadingComplete(param1:Number) : void
      {
         if(param1 == 1)
         {
            Application.instance.currentGame.hiddenLoading();
            init();
            buildWorld(_mapId);
            startGame();
         }
      }
      
      private function startGame() : void
      {
         UILayer.timer.timeoverSignal.add(playerOverTimer);
         getMap().mapSolid = true;
         sHelperPoint.setTo(400,200);
         this.addSelfToWorld(sHelperPoint);
         selfCharacterCtrl.setServer(CopyServer.instance);
         selfCharacterCtrl.downStart();
         selfCharacterCtrl.slottingCompleteSignal.add(slottingCompleteSignalHandle);
         selfCharacterCtrl.actionCompeleteSignal.add(actionCompleteHandle);
         selfCharacterCtrl.dieSignal.add(dieSignalHandle);
         flushMonster();
      }
      
      override protected function init() : void
      {
         super.init();
         backToBossFight = true;
         bindNet();
      }
      
      private function flushMonster() : void
      {
         var bossCtrl:BossCtrl;
         var monsterSite:int = 4;
         var pos:Point = new Point(1100,500);
         var copyRold:CopyMonsterRole = CopyMonsterRoleList.instance.getRoleBySpieceType(_bossType);
         var monsterData:MonsterData = new MonsterData(copyRold);
         var boss:BossMonster = BossMonster(MonsterFactory.instance.createBoss(copyRold.remake,monsterData));
         switch(monsterData.spiece_type - 27)
         {
            case 0:
               bossCtrl = new ScorpionKindCtrl(this,boss,monsterSite);
         }
         bossCtrl.actionCompleteSignal.add(monsterActionCompelteHandle);
         bossCtrl.attackSignal.add(monsterAttackHandle);
         boss.x = pos.x;
         boss.y = pos.y;
         this.charatersLayer.addChild(boss);
         Starling.juggler.add(bossCtrl);
         camera.focusTarget = boss;
         _currentCtrl = 1;
         bossCtrl.attackTarget = selfCharacterCtrl.icharacter;
         Starling.juggler.delayCall((function():*
         {
            var delay:Function;
            return delay = function():void
            {
               CopyServer.instance.sendUnionFightActionComplete();
            };
         })(),0.5);
         bossCtrl.hp = _optionObject.data.bossHp;
         _monsters.push(bossCtrl);
      }
      
      private function unBindNet() : void
      {
         CopyServer.instance.disposeRecvFun(onSetSender);
         CopyServer.instance.disposeRecvFun(onUseProp);
         CopyServer.instance.disposeRecvFun(onBossAttack);
         CopyServer.instance.disposeRecvFun(onBombPoint);
         CopyServer.instance.disposeRecvFun(onTimeOut);
         CopyServer.instance.disposeRecvFun(onBossDead);
         CopyServer.instance.disposeRecvFun(onAddDevote);
      }
      
      private function bindNet() : void
      {
         CopyServer.instance.onUnionFightSwitch(onSetSender);
         CopyServer.instance.onUnionFightUseProp(onUseProp);
         CopyServer.instance.onUnionFightBossAttack(onBossAttack);
         CopyServer.instance.onUnionFightBombPoint(onBombPoint);
         CopyServer.instance.onUnionFightTimeOut(onTimeOut);
         CopyServer.instance.onUnionFightBossDead(onBossDead);
         CopyServer.instance.onUnionFightDevoteMsg(onAddDevote);
      }
      
      override protected function isMyCtrl() : Boolean
      {
         return _currentCtrl == 0;
      }
      
      override public function onPassBtnHandle() : void
      {
         super.onPassBtnHandle();
         if(isMyCtrl())
         {
            UILayer.timer.stop();
            CopyServer.instance.sendUnionFightActionComplete();
         }
      }
      
      private function gameOver(param1:Boolean) : void
      {
         var win:Boolean = param1;
         if(!_gameOver)
         {
            _gameOver = true;
            selfCharacterCtrl.ctrlStart(false);
            Starling.juggler.remove(selfCharacterCtrl);
            UILayer.timer.stop();
            gameOverAnimation(win,(function():*
            {
               var gameDone:Function;
               return gameDone = function():void
               {
                  dispatchEventWith("complete");
               };
            })());
         }
      }
      
      private function playerOverTimer() : void
      {
         selfCharacterCtrl.ctrlStart(false);
         CopyServer.instance.sendUnionFightActionComplete();
      }
      
      private function onBossDead(param1:Object) : void
      {
         var retData:Object = param1;
         Application.instance.log("UnionBossFightWorld\'s onBossDead:",JSON.stringify(retData));
         Starling.juggler.delayCall((function():*
         {
            var delay:Function;
            return delay = function():void
            {
               gameOver(true);
            };
         })(),2);
         txtLeftNum.text = "HP:0";
      }
      
      private function onTimeOut(param1:Object) : void
      {
         Application.instance.log("UnionBossFightWorld\'s onTimeOut:",JSON.stringify(param1));
         gameOver(false);
      }
      
      private function onAddDevote(param1:Object) : void
      {
         Application.instance.log("UnionBossFightWorld\'s onAddDevote",JSON.stringify(param1));
         UnionManager.getInstance().myUnionModel.mdevote = UnionManager.getInstance().myUnionModel.mdevote + param1.data.devote;
         TextTip.instance.show(LangManager.replace("unionFightAddDevote",UnionManager.getInstance().myUnionModel.mdevote));
      }
      
      private function onBombPoint(param1:Object) : void
      {
         Application.instance.log("UnionBossFightWorld\'s onBombPoint:",JSON.stringify(param1));
         var _loc5_:int = int(param1.data.bulletId);
         var _loc6_:int = int(param1.data.isHit);
         var _loc2_:int = int(param1.data.isPow);
         var _loc3_:int = int(param1.data.lossHp);
         var _loc4_:int = int(param1.data.currentHp);
         if(_loc3_ != 0)
         {
            dropHPByServerAndSetHPView(selfCharacterCtrl,getMonsterBySiteID(4),_loc3_,Boolean(_loc2_),getBossHPViewPoint());
         }
         txtLeftNum.text = "HP:" + _loc4_;
      }
      
      private function onBossAttack(param1:Object) : void
      {
         Application.instance.log("UnionBossFightWorld\'s onBossAttack:",JSON.stringify(param1));
         var _loc3_:int = int(param1.data.lossHp);
         var _loc4_:int = int(param1.data.currentHp);
         var _loc2_:int = int(param1.data.isPow);
         if(_loc4_ == 0)
         {
            _loc3_ = selfCharacterCtrl.hp;
         }
         _bossAttackObject = {
            "lossHP":_loc3_,
            "curHp":_loc4_,
            "isPow":_loc2_
         };
      }
      
      private function onUseProp(param1:Object) : void
      {
         Application.instance.log("UnionBossFightWorld\'s onUseProp:",JSON.stringify(param1));
         var _loc2_:int = int(param1.data.flag);
         var _loc3_:int = int(param1.data.propId);
      }
      
      private function onSetSender(param1:Object) : void
      {
         Application.instance.log("UnionBossFightWorld\'s onSetSender:",JSON.stringify(param1));
         _currentCtrl = param1.data.ctrl;
         var _loc4_:int = int(param1.data.bossHp);
         var _loc2_:BossCtrl = getMonsterBySiteID(4) as BossCtrl;
         var _loc3_:int = _loc2_.hp - _loc4_;
         if(_loc3_ != 0)
         {
            dropHpByCharAndSetHPView(_loc2_,_loc3_,false,1,getBossHPViewPoint());
         }
         txtLeftNum.text = "HP:" + _loc4_;
         switchCtrl();
      }
      
      private function getBossHPViewPoint() : Point
      {
         var _loc1_:BossCtrl = getMonsterBySiteID(4) as BossCtrl;
         return new Point(_loc1_.icharacter.x + 30,_loc1_.icharacter.y - 200);
      }
      
      private function switchCtrl() : void
      {
         var switchFunc:* = function():void
         {
            var bossCtrl:BossCtrl;
            if(_currentCtrl == 0)
            {
               cameraFocusCtrlByTouch(true);
               camera.swapFocus(selfCharacterCtrl.icharacter);
               playMyGo(function():void
               {
                  selfCharacterCtrl.ctrlStart(true);
               });
            }
            else if(_currentCtrl == 1)
            {
               bossCtrl = getMonsterBySiteID(4) as BossCtrl;
               bossCtrl.attackTarget = selfCharacterCtrl.icharacter;
               if(!bossCtrl.attackTarget)
               {
                  bossCtrl.actionCompleteSignal.dispatch();
                  return;
               }
               bossCtrl.setAttackSkill(Math.floor(Math.random() * 3));
               bossCtrl.ctrlStart();
               _currentCtrl = 2;
            }
            UILayer.timer.start(35);
         };
         Application.instance.log("UnionBossFightWorld","切换回合, _currentCtrl:" + _currentCtrl);
         if(_currentCtrl != 0)
         {
            selfCharacterCtrl.ctrlStart(false);
            UILayer.timer.stop();
         }
         Starling.juggler.delayCall(switchFunc,2);
      }
      
      protected function slottingCompleteSignalHandle(param1:int, param2:Array) : void
      {
         var _loc4_:int = int(param2.shift());
         var _loc3_:* = param2;
         if(param1 == selfCharacterCtrl.siteID)
         {
            CopyServer.instance.sendUnionFightBombPoint(_loc3_[0],_loc3_[1],_loc3_[2],_loc3_[3]);
         }
         if(_loc4_ == 2 || _loc4_ == 3)
         {
            return;
         }
         selfCharacterCtrl.downStart();
      }
      
      private function actionCompleteHandle(param1:int = 0) : void
      {
         cameraFocusCtrlByTouch(true);
         CopyServer.instance.sendUnionFightActionComplete();
      }
      
      private function dieSignalHandle(param1:int, param2:String) : void
      {
         var siteId:int = param1;
         var type:String = param2;
         if(siteId == PlayerDataList.instance.selfData.siteID)
         {
            Starling.juggler.delayCall((function():*
            {
               var delay:Function;
               return delay = function():void
               {
                  gameOver(false);
               };
            })(),2);
         }
      }
      
      private function monsterActionCompelteHandle() : void
      {
         Application.instance.log("monsterActionCompelteHandle","done");
         CopyServer.instance.sendUnionFightActionComplete();
      }
      
      private function monsterAttackHandle(param1:String, param2:ICharacterCtrl) : void
      {
         switch(param1)
         {
            case "attack0":
            case "attack1":
            case "attack2":
               selfCharacterCtrl.playCry();
               dropHPByServerAndSetHPView(param2,selfCharacterCtrl,_bossAttackObject.lossHP,false);
         }
      }
      
      private function getMonsterBySiteID(param1:int) : ICharacterCtrl
      {
         for each(var _loc2_ in _monsters)
         {
            if(_loc2_.siteID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      override protected function update(param1:Number) : void
      {
         super.update(param1);
         if(!_gameOver)
         {
            MonsterCtrl.monsterAttrQueue.start();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         UILayer.timer.stop();
         unBindNet();
         Assets.sAsset.removeSkeletonsAndBoneAtlases("scorpionKind");
         Assets.sAsset.removeTextureAtlas("battlefieldSpritesheet");
         Assets.sAsset.removeTextureAtlas("emoticon");
         CopyServer.instance.close();
      }
   }
}

