package com.boyaa.antwars.net.server
{
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.net.mySocketEvent;
   import com.boyaa.antwars.view.TextTip;
   import starling.core.Starling;
   
   public class CopyServer extends BaseServer
   {
      
      private static var _instance:CopyServer = null;
      
      public var serverType:int = 0;
      
      public function CopyServer(param1:Single)
      {
         super();
      }
      
      public static function get instance() : CopyServer
      {
         if(_instance == null)
         {
            _instance = new CopyServer(new Single());
         }
         return _instance;
      }
      
      override protected function onConnect(param1:mySocketEvent) : void
      {
         super.onConnect(param1);
         send.copyGameConnectServer();
      }
      
      public function loginSuccessful(param1:Function) : void
      {
         recv.bindFun(4001,param1);
      }
      
      public function onGameStart(param1:Function) : void
      {
         recv.bindFun(4006,param1,false);
      }
      
      public function otherJoinInRoom(param1:Function) : void
      {
         recv.bindFun(4014,param1,false);
      }
      
      public function joinInRoom(param1:int, param2:Function) : void
      {
         send.copyGameJoinRoom(param1);
         recv.bindFun(4005,param2);
      }
      
      public function backToRoomFromCopyGame(param1:Function) : void
      {
         send.copyGameBackToRoom();
         recv.bindFun(4017,param1);
      }
      
      public function leaveRoom() : void
      {
         send.copyGameLeaveRoom();
      }
      
      public function monsterShootAttack(param1:Function) : void
      {
         recv.bindFun(4184,param1,false);
      }
      
      public function otherLeaveRoom(param1:Function) : void
      {
         recv.bindFun(4009,param1,false);
      }
      
      public function onGameOver(param1:Function) : void
      {
         recv.bindFun(4053,param1,false);
      }
      
      public function createRoom(param1:int, param2:Function) : void
      {
         send.copyGameCreateRoom(param1);
         recv.bindFun(4003,param2);
      }
      
      public function closeSite(param1:int) : void
      {
         send.copyGameCloseSite(param1);
      }
      
      public function openSite(param1:int) : void
      {
         send.copyGameOpenSite(param1);
      }
      
      public function onOpenCloseSite(param1:Function) : void
      {
         recv.bindFun(4010,param1,false);
      }
      
      public function kickPlayer(param1:int) : void
      {
         send.copyGameKickPlayer(param1);
      }
      
      public function onKickOut(param1:Function) : void
      {
         recv.bindFun(4011,param1,false);
      }
      
      public function changeClothes() : void
      {
         send.copyGameChangeClothes();
      }
      
      public function onChangeClothes(param1:Function) : void
      {
         recv.bindFun(4018,param1,false);
      }
      
      public function findRoom(param1:int, param2:Function, param3:uint) : void
      {
         send.copyGameFindRoom(param1,param3);
         recv.bindFun(4013,param2);
      }
      
      public function playerReady(param1:int) : void
      {
         send.copyGamePlayerReady(param1);
      }
      
      public function onPlayerReady(param1:Function) : void
      {
         recv.bindFun(4012,param1,false);
      }
      
      public function quickMatch(param1:Function, param2:uint) : void
      {
         send.copyGameQuickMatch(param2);
         recv.bindFun(4004,param1);
      }
      
      public function showRoomList(param1:uint, param2:Function) : void
      {
         send.copyGameGetRoomList(param1);
         recv.bindFun(4008,param2);
      }
      
      public function startGameInRoom(param1:uint) : void
      {
         send.copyGamestartGameInRoom(param1);
      }
      
      public function sendCannonball(param1:int, param2:int, param3:int, param4:Array, param5:int = 0) : void
      {
         send.copyGameBombPoint(param1,param2,param3,param4,param5);
      }
      
      public function onCannonballBomb(param1:Function) : void
      {
         recv.bindFun(4114,param1,false);
      }
      
      public function sendMapProgress(param1:Number) : void
      {
         send.copyGameMapProgress(param1);
      }
      
      public function bindMapProgress(param1:Function) : void
      {
         recv.bindFun(4054,param1,false);
      }
      
      public function sendMapComplete() : void
      {
         send.copyGameMapLoadComplete();
      }
      
      public function onBossFightPlay(param1:Function) : void
      {
         recv.bindFun(4052,param1);
      }
      
      public function getBornPointFromServer(param1:Function) : void
      {
         send.copyGameBornPoint();
         recv.bindFun(4055,param1);
      }
      
      public function playerReliveInNormal(param1:Function) : void
      {
         recv.bindFun(4120,param1);
      }
      
      public function sendReliveInNormal() : void
      {
         send.copyGameSendReliveInNormal();
      }
      
      public function selfReliveInBossRoom(param1:Function) : void
      {
         recv.bindFun(4119,param1);
      }
      
      public function sendReliveInBossRoom() : void
      {
         send.CopyGameSendReliveInBossRoom();
      }
      
      public function playerRelivePublic(param1:Function) : void
      {
         recv.bindFun(4121,param1,false);
      }
      
      public function getBossBorning(param1:Function) : void
      {
         send.copyGameBossBornPoint();
         recv.bindFun(4056,param1);
      }
      
      public function sendGetFirstShoot() : void
      {
         send.copyGameGetFirstShoot();
      }
      
      public function onPlayerExitCopyGame(param1:Function) : void
      {
         recv.bindFun(4112,param1,false);
      }
      
      public function sendPlayerDead() : void
      {
         send.copyGamePlayerDead();
      }
      
      public function sendMonsterAttack(param1:int, param2:int, param3:uint, param4:int) : void
      {
         send.copyGameMonsterAttack(param1,param2,param3,param4);
      }
      
      public function onMonsterAttack(param1:Function) : void
      {
         recv.bindFun(4180,param1,false);
      }
      
      public function onPlayerDead(param1:Function) : void
      {
         recv.bindFun(4106,param1,false);
      }
      
      public function onPlayerTimeout(param1:Function) : void
      {
         recv.bindFun(4108,param1,false);
      }
      
      public function sendPlayerTimeout() : void
      {
         send.copyGamePlayerTimeout();
      }
      
      public function sendPlayerExit() : void
      {
         send.copyGamePlayerExit();
      }
      
      public function sendPlayerGiveUp() : void
      {
         send.copyGamePlayerGiveUp();
      }
      
      public function onPlayerGiverUp(param1:Function) : void
      {
         recv.bindFun(4111,param1,false);
      }
      
      public function sendPlayerDone() : void
      {
         send.copyGamePlayerDone();
      }
      
      public function sendOtherPlayerComplete() : void
      {
         send.copyGameShowComplete();
      }
      
      public function onRecvShooter(param1:Function) : void
      {
         recv.bindFun(4113,param1,false);
      }
      
      public function onRecvMonsterCount(param1:Function) : void
      {
         recv.bindFun(4202,param1,false);
      }
      
      public function sendUseProp(param1:int) : void
      {
         send.copyGamePlayerUseProp(param1);
      }
      
      public function onBindUseProp(param1:Function) : void
      {
         recv.bindFun(4100,param1,false);
      }
      
      public function sendMove(param1:Array, param2:Number, param3:Number) : void
      {
         send.copyGamePlayerMove(param1,param2,param3);
      }
      
      public function onPlayerMove(param1:Function) : void
      {
         recv.bindFun(4115,param1,false);
      }
      
      public function sendPlayerUseEnergy() : void
      {
         send.copyGameSendUseEnergy();
      }
      
      public function onPlayerUseEnergy(param1:Function) : void
      {
         recv.bindFun(4118,param1,false);
      }
      
      public function onBossAttack(param1:Function) : void
      {
         recv.bindFun(4150,param1,false);
      }
      
      public function onSwitchCtrl(param1:Function) : void
      {
         recv.bindFun(4007,param1,false);
      }
      
      public function sendMonsterShow() : void
      {
         send.copyGameSendMonsterShow();
      }
      
      public function luckyDraw(param1:int) : void
      {
         send.luckyDraw(param1);
      }
      
      public function onLuckyDraw(param1:Function) : void
      {
         recv.bindFun(1015,param1,false);
      }
      
      public function sendCreateRoomDone() : void
      {
         send.copyGameCreateRoomDone();
      }
      
      public function getEndlessData(param1:Function) : void
      {
         send.getEndlessData();
         recv.bindFun(4300,param1);
      }
      
      public function getEndlessMonsterData() : void
      {
         send.getEndlessMonsterData();
      }
      
      public function onEndlessMonsterData(param1:Function) : void
      {
         recv.bindFun(4301,param1);
      }
      
      public function sendEndlessResult(param1:int, param2:int, param3:int) : void
      {
         switch(param1)
         {
            case 0:
               send.endlessWinAndGoNext(param2,param3);
               break;
            case 1:
               send.endlessWinAndGoBack(param2,param3);
               break;
            case 2:
               send.endlessLossAndBack(param2,param3);
         }
      }
      
      public function endlessRelive(param1:int, param2:int) : void
      {
         send.endlessRelive(param1,param2);
      }
      
      public function onEndlessRelive(param1:Function) : void
      {
         recv.bindFun(4304,param1,false);
      }
      
      public function onWinAndGoNext(param1:Function) : void
      {
         recv.bindFun(4302,param1,false);
      }
      
      public function sendFlyToTop(param1:int) : void
      {
         send.endlessFlyToTop(param1);
      }
      
      public function onFlyToTop(param1:Function) : void
      {
         recv.bindFun(4306,param1,false);
      }
      
      public function getEndlessRankList() : void
      {
         send.endlessGetRankList();
      }
      
      public function onEndlessRankList(param1:Function) : void
      {
         recv.bindFun(4307,param1,false);
      }
      
      public function sendEndlessBuyTime(param1:Function) : void
      {
         send.endlessBuyTime();
         recv.bindFun(4308,param1);
      }
      
      public function vipFreeRelive(param1:int, param2:int, param3:Function) : void
      {
         recv.bindFun(4310,param3);
         send.useVipRelive(param1,param2);
      }
      
      public function sendUnionFightStart(param1:Function) : void
      {
         recv.bindFun(5301,param1);
         send.unionFightGameStart();
      }
      
      public function onUnionFightSwitch(param1:Function) : void
      {
         recv.bindFun(5303,param1,false);
      }
      
      public function sendUnionFightUseProp(param1:int) : void
      {
         send.unionFightUseProp(param1);
      }
      
      public function onUnionFightUseProp(param1:Function) : void
      {
         recv.bindFun(5302,param1,false);
      }
      
      public function onUnionFightBossAttack(param1:Function) : void
      {
         recv.bindFun(5304,param1,false);
      }
      
      public function sendUnionFightActionComplete() : void
      {
         send.unionFightActionComplete();
      }
      
      public function sendUnionFightBombPoint(param1:int, param2:int, param3:int, param4:Array, param5:int = 1) : void
      {
         send.unionFightBombPoint(param1,param2,param3,param4,param5);
      }
      
      public function onUnionFightBombPoint(param1:Function) : void
      {
         recv.bindFun(5306,param1,false);
      }
      
      public function onUnionFightTimeOut(param1:Function) : void
      {
         recv.bindFun(5307,param1,false);
      }
      
      public function onUnionFightBossDead(param1:Function) : void
      {
         recv.bindFun(5308,param1,false);
      }
      
      public function sendUnionFightRankList(param1:Function) : void
      {
         recv.bindFun(5309,param1);
         send.unionFightGetRank();
      }
      
      public function sendUnionFightInfo() : void
      {
         send.unionFightGetInfo();
      }
      
      public function onUnionFightInfo(param1:Function) : void
      {
         recv.bindFun(5310,param1,false);
      }
      
      public function onUnionFightDevoteMsg(param1:Function) : void
      {
         recv.bindFun(5311,param1,false);
      }
      
      public function sendUnionFightGetReward(param1:Function) : void
      {
         recv.bindFun(5312,param1);
         send.unionFightGetReward();
      }
      
      public function onUnionFightState(param1:Function) : void
      {
         recv.bindFun(5300,param1,false);
      }
      
      public function sendChangeWeaponDone(param1:int) : void
      {
         send.changeWeaponDone(param1);
      }
      
      public function onChangeWeaponDone(param1:Function) : void
      {
         recv.bindFun(4124,param1,false);
      }
      
      public function getFreeReliveTimes(param1:Function) : void
      {
         recv.bindFun(4122,param1);
         send.getFreeReliveTimesInCopy();
      }
      
      public function useFreeRelive(param1:int, param2:Function) : void
      {
         recv.bindFun(4123,param2);
         send.useFreeReliveInCopy(param1);
      }
      
      override protected function onClose(param1:mySocketEvent) : void
      {
         var e:mySocketEvent = param1;
         super.onClose(e);
         TextTip.instance.show(LangManager.t("netSafetyError"));
         if(!CopyList.instance.currentCopyData)
         {
            Starling.juggler.delayCall((function():*
            {
               var delay:Function;
               return delay = function():void
               {
                  Application.instance.currentGame.navigator.showScreen("HALL");
               };
            })(),0.5);
            return;
         }
         Starling.juggler.delayCall((function():*
         {
            var call:Function;
            return call = function():void
            {
               var _loc1_:String = "SPIDERCITY";
               switch(CopyList.instance.currentCopyData.cpid - 2)
               {
                  case 0:
                     _loc1_ = "SPIDERCITY";
                     break;
                  case 1:
                     _loc1_ = "SPRITECITY";
               }
               Application.instance.currentGame.navigator.showScreen(_loc1_);
            };
         })(),5);
      }
      
      override protected function onErr(param1:mySocketEvent) : void
      {
         super.onErr(param1);
         TextTip.instance.show(LangManager.t("netSafetyError"));
         Application.instance.currentGame.hiddenLoading();
         Application.instance.currentGame.navigator.showScreen("HALL");
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
