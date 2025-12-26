package com.boyaa.antwars.net.server
{
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.net.mySocketEvent;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.tool.Tiptext;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import starling.core.Starling;
   
   public class GameServer extends BaseServer
   {
      
      private static var _instance:GameServer = null;
      
      private var _ConnectFailCount:int = 0;
      
      private var _heartbeatTimer:Timer = null;
      
      public function GameServer(param1:Single)
      {
         super();
      }
      
      public static function get instance() : GameServer
      {
         if(_instance == null)
         {
            _instance = new GameServer(new Single());
         }
         return _instance;
      }
      
      override protected function onConnect(param1:mySocketEvent) : void
      {
         _ConnectFailCount = 0;
         send.login();
         super.onConnect(param1);
      }
      
      override protected function onClose(param1:mySocketEvent) : void
      {
         super.onClose(param1);
         if(!initiativeClose)
         {
            trace("initiativeClose:",initiativeClose);
            reConnect();
         }
      }
      
      override protected function onErr(param1:mySocketEvent) : void
      {
         if(_ConnectFailCount <= 3)
         {
            Timepiece.instance.addDelayCall(reConnect,3000);
         }
         else
         {
            super.onErr(param1);
         }
      }
      
      private function reConnect() : void
      {
         _ConnectFailCount = _ConnectFailCount + 1;
         connect();
      }
      
      public function heartbeat() : void
      {
         if(_heartbeatTimer != null)
         {
            _heartbeatTimer.stop();
            _heartbeatTimer.removeEventListener("timer",sendHeartbeat);
            _heartbeatTimer = null;
         }
         _heartbeatTimer = new Timer(9000);
         _heartbeatTimer.addEventListener("timer",sendHeartbeat);
         _heartbeatTimer.start();
      }
      
      private function sendHeartbeat(param1:TimerEvent) : void
      {
         if(!Constants.debug)
         {
            send.heartbeat();
         }
      }
      
      override public function close() : void
      {
         initiativeClose = true;
         if(_heartbeatTimer != null)
         {
            _heartbeatTimer.stop();
            _heartbeatTimer.removeEventListener("timer",sendHeartbeat);
            _heartbeatTimer = null;
         }
         super.close();
      }
      
      public function readMail(param1:int, param2:Function) : void
      {
         send.readMail(param1);
         recv.bindFun(8002,param2);
      }
      
      public function getMailList(param1:Function) : void
      {
         send.getMailList();
         recv.bindFun(8003,param1);
      }
      
      public function loginRepeat(param1:Function) : void
      {
         recv.bindFun(1007,param1);
      }
      
      public function getAllGoods(param1:Function) : void
      {
         send.getAllGoods();
         recv.bindFun(3014,param1);
      }
      
      public function getMemBody(param1:Function) : void
      {
         send.getMemBody();
         recv.bindFun(3016,param1);
      }
      
      public function setMemBody(param1:Array, param2:Function) : void
      {
         send.setMemBody(param1);
         recv.bindFun(3005,param2);
      }
      
      public function sellGoods(param1:int, param2:int, param3:Function) : void
      {
         send.sellGoods(param1,param2);
         recv.bindFun(3004,param3);
      }
      
      public function buy(param1:int, param2:Array, param3:Function) : void
      {
         trace("---props:" + param2);
         trace("props:  " + JSON.stringify(param2));
         send.toBuy(param1,param2);
         recv.bindFun(3013,param3);
      }
      
      public function useGoods(param1:int, param2:Function) : void
      {
         send.useGoods(param1);
         recv.bindFun(3006,param2);
      }
      
      public function renew(param1:Array, param2:Function) : void
      {
         send.renew(param1);
         recv.bindFun(3007,param2);
      }
      
      public function getServerList(param1:Function) : void
      {
         send.getServerList();
         recv.bindFun(1,param1);
      }
      
      public function getServerIDByType(param1:int, param2:Function) : void
      {
         send.getServerIDByType(param1);
         recv.bindFun(4,param2);
      }
      
      public function sendChatToFriend(param1:int, param2:String) : void
      {
         send.sendChatToFriend(param1,1,param2);
      }
      
      public function onChatToFriend(param1:Function) : void
      {
         recv.bindFun(1002,param1,false);
      }
      
      public function sendLoudSpeaker(param1:String, param2:int) : void
      {
         send.sendLoudSpeaker(0,param1,param2);
      }
      
      public function sendChatToUnion(param1:String) : void
      {
         send.sendUnionMsg(param1);
      }
      
      public function sendChatToRoom(param1:String) : void
      {
         send.sendLoudSpeaker(3,param1,0);
      }
      
      public function onLoudSpeaker(param1:Function) : void
      {
         recv.bindFun(1026,param1,false);
      }
      
      public function getLoudSpeakFromServer(param1:Function) : void
      {
         recv.bindFun(1001,param1,false);
      }
      
      public function onUnionSpeaker(param1:Function) : void
      {
         recv.bindFun(1009,param1,false);
      }
      
      public function sentConsumeEnergy() : void
      {
         send.consumeEnergy();
      }
      
      public function sentMsgToGetEnergy() : void
      {
         send.sentMsgToGetEnergy();
      }
      
      public function getPlayerEnergy(param1:Function) : void
      {
         recv.bindFun(3051,param1,true);
      }
      
      public function getConsumeEnergy(param1:Function) : void
      {
         recv.bindFun(3052,param1,true);
      }
      
      public function sendScreenPlace(param1:int) : void
      {
         send.sendScreenPlace(param1);
      }
      
      public function getOnlineUser(param1:Function) : void
      {
         send.getInviteList();
         recv.bindFun(1022,param1);
      }
      
      public function inviteFriend(param1:int, param2:int, param3:int, param4:int, param5:String) : void
      {
         send.inviteFriend(param1,param2,param3,param4,param5);
      }
      
      public function beInvite(param1:Function) : void
      {
         recv.bindFun(1017,param1,false);
      }
      
      public function acceptInvite(param1:int, param2:Boolean = true) : void
      {
         if(param2)
         {
            send.acceptFriendInvite(param1);
         }
         else
         {
            send.refuseFriendInvite(param1);
         }
      }
      
      public function strenthen(param1:int, param2:Array, param3:Function) : void
      {
         trace("stoneAry:",JSON.stringify(param2));
         send.strenthen(param1,param2);
         recv.bindFun(3008,param3);
      }
      
      public function transfer(param1:int, param2:int, param3:Array, param4:Function) : void
      {
         send.transfer(param1,param2,param3);
         recv.bindFun(3009,param4);
      }
      
      override public function init(param1:String, param2:int) : void
      {
         var host:String = param1;
         var port:int = param2;
         super.init(host,port);
         socketSignal.add(socketSignalHandle);
         loginRepeat(function(param1:Object):void
         {
            setClose();
            new Tiptext(LangManager.t("changePassword"));
            Application.instance.currentMain.logout();
         });
      }
      
      private function socketSignalHandle(param1:String) : void
      {
         switch(param1)
         {
            case "Connect":
               MissionManager.instance.countOnlineTimeStart();
               if(Starling.current)
               {
                  TextTip.instance.hidden();
               }
               break;
            case "Close":
               MissionManager.instance.countOnlineTimeStop();
               TextTip.instance.show(LangManager.t("reconnect"),false,false);
               break;
            case "Error":
               MissionManager.instance.countOnlineTimeStop();
               if(Starling.current)
               {
                  TextTip.instance.show(LangManager.t("netError"));
               }
               else
               {
                  new Tiptext(LangManager.t("netError"));
               }
               Application.instance.currentMain.logout();
               break;
            case "SecurityError":
               TextTip.instance.show(LangManager.t("netSafetyError"));
         }
      }
      
      public function weddingSendPopMarryMsg(param1:uint, param2:uint, param3:String) : void
      {
         send.weddingSendPopMsg(param1,param2,param3);
      }
      
      public function weddingSendDivorceMsg(param1:int, param2:int, param3:String) : void
      {
         send.weddingSendDivorceMsg(param1,param2,param3);
      }
      
      public function weddingSendPopAnswer(param1:int, param2:int) : void
      {
         send.weddingSendAnswerToPop(param1,param2);
      }
      
      public function weddingSendDivorceAnswer(param1:int) : void
      {
         send.weddingSendDivorceAnswer(param1);
      }
      
      public function weddingMarryMe(param1:int) : void
      {
         send.weddingSendMarryMe(param1);
      }
      
      public function onWeddingMarry(param1:uint, param2:Function, param3:Boolean = false) : void
      {
         _recv.bindFun(param1,param2,param3);
      }
      
      public function weddingGetWeddingMsg() : void
      {
         send.weddingGetWeddingMsg();
      }
      
      public function weddingExchangeRing(param1:int, param2:Array, param3:Function) : void
      {
         send.weddingSendExchangeRing(param1,param2);
         recv.bindFun(3226,param3);
      }
      
      public function exchangePropMessage(param1:int, param2:int, param3:Array, param4:Function) : void
      {
         send.exchangePropMessage(param1,param2,param3);
         recv.bindFun(3053,param4);
      }
      
      public function onSomeOneVipLevel(param1:Function, param2:Boolean = true) : void
      {
         recv.bindFun(3110,param1,param2);
      }
      
      public function getSomeOneVipLevel(param1:int) : void
      {
         send.someOneVipLevel(param1);
      }
      
      public function getVipLevelGift(param1:int, param2:Function) : void
      {
         recv.bindFun(3112,param2);
         send.rewardVipLevelGifts(param1);
      }
      
      public function getVipViewInfo(param1:int, param2:Function) : void
      {
         recv.bindFun(3111,param2);
         send.getVipViewInfo(param1);
      }
      
      public function getAutoFightTimes(param1:Function) : void
      {
         recv.bindFun(3114,param1);
         send.getAutoFightTimes();
      }
      
      public function useAutoFight(param1:Function) : void
      {
         recv.bindFun(3115,param1);
         send.useFreeAutoFight();
      }
      
      public function onSynthesis(param1:Array, param2:Function) : void
      {
         recv.bindFun(3010,param2);
         send.toSynthesis(param1);
      }
      
      public function onAddition(param1:Array, param2:Function) : void
      {
         recv.bindFun(3116,param2);
         send.toAddition(param1);
      }
      
      public function getUnionTostorage(param1:Array, param2:Function) : void
      {
         recv.bindFun(3018,param2);
         send.tostorage(param1);
      }
      
      public function getRentGoodsResult(param1:Array, param2:Function) : void
      {
         recv.bindFun(3109,param2);
         send.rentGoods(param1);
      }
      
      public function getAllRentingGoods(param1:Function) : void
      {
         recv.bindFun(3117,param1);
         send.getAllRentingGoods();
      }
      
      public function toRentalStorageResult(param1:Array, param2:Function) : void
      {
         recv.bindFun(3107,param2);
         send.toRentalStorage(param1);
      }
      
      public function toMyStorFromeUnionStorResult(param1:Array, param2:Function) : void
      {
         recv.bindFun(3108,param2);
         send.toMywarehouseFromUnionStroage(param1);
      }
      
      public function deleteOvertimeRentalGoods(param1:Function) : void
      {
         recv.bindFun(3118,param1);
      }
      
      public function getBagItemRentStatus(param1:Function) : void
      {
         recv.bindFun(3119,param1);
      }
      
      public function nobodyRentBacktoMystore(param1:Function) : void
      {
         recv.bindFun(3120,param1);
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
