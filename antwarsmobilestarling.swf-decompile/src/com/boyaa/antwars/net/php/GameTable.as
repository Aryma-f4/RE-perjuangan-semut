package com.boyaa.antwars.net.php
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.events.PHPEvent;
   import flash.events.Event;
   import flash.net.URLLoader;
   
   public class GameTable extends PostBase
   {
      
      public function GameTable()
      {
         super();
      }
      
      public function limitMemIn() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameCopys.limitMemIn",[]]);
         _loc1_.addEventListener("complete",onLimitMemIn);
      }
      
      private function onLimitMemIn(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onLimitMemIn);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("IS_ALLOW_TO_ENTER_COPY",_loc2_));
      }
      
      public function getEnergy() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameCopys.getPower",[]]);
         _loc1_.addEventListener("complete",onGetEnergy);
      }
      
      private function onGetEnergy(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onGetEnergy);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("GET_COPYS_ENERGY",_loc2_));
      }
      
      public function getServer() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameSAR.getCenterSever",[]]);
         _loc1_.addEventListener("complete",onGetServer);
      }
      
      private function onGetServer(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onGetServer);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("GAME_TABLE_GETSERVER",_loc2_));
      }
      
      public function fastStart(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameSAR.getRoom",param1]);
         _loc2_.addEventListener("complete",onFastStart);
      }
      
      private function onFastStart(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onFastStart);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("GAME_TABLE_FASTSTART",_loc2_));
      }
      
      public function seekRoom(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameSAR.getSerByRid",param1]);
         _loc2_.addEventListener("complete",onSeekRoom);
      }
      
      private function onSeekRoom(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onSeekRoom);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("GAME_TABLE_SEEKROOM",_loc2_));
      }
      
      public function getMissionState() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameMember.getMission"]);
         _loc1_.addEventListener("complete",returnFromFHP);
      }
      
      private function returnFromFHP(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",returnFromFHP);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getMissionState",_loc2_));
      }
      
      public function gainReward(param1:int, param2:Array) : void
      {
         var _loc3_:URLLoader = loaderURL(["GameMember.getMissionPrize",[param1,param2]]);
         _loc3_.addEventListener("complete",returnFromFHP0);
      }
      
      private function returnFromFHP0(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",returnFromFHP0);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("gain_reward",_loc2_));
      }
      
      public function getMessages(param1:int) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameHouse.getDiarys",param1]);
         _loc2_.addEventListener("complete",returnFromFHP1);
      }
      
      private function returnFromFHP1(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",returnFromFHP1);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("get_messages",_loc2_));
      }
      
      public function getSingleMessage(param1:int) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameHouse.getDiary",param1]);
         _loc2_.addEventListener("complete",returnFromFHP2);
      }
      
      private function returnFromFHP2(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",returnFromFHP2);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("get_single_message",_loc2_));
      }
      
      public function getLuckyRound() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameHouse.luckyRound"]);
         _loc1_.addEventListener("complete",getLuckRoundHandler);
      }
      
      private function getLuckRoundHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getLuckRound",_loc3_));
      }
      
      public function addMessage(param1:Object) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameHouse.insertDiary",param1]);
         _loc2_.addEventListener("complete",returnFromFHP3);
      }
      
      private function returnFromFHP3(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",returnFromFHP3);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("add_message",_loc2_));
      }
      
      public function gainPremium(param1:int) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameHouse.stealMoney",param1]);
         _loc2_.addEventListener("complete",returnFromFHP4);
      }
      
      private function returnFromFHP4(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",returnFromFHP4);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("gain_premium",_loc2_));
      }
      
      public function createHome(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameHouse.create",param1]);
         _loc2_.addEventListener("complete",returnFromFHP5);
      }
      
      private function returnFromFHP5(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",returnFromFHP5);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("create_home",_loc2_));
      }
      
      public function getHomeData(param1:int) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameHouse.getHouse",param1]);
         _loc2_.addEventListener("complete",returnFromFHP6);
      }
      
      private function returnFromFHP6(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",returnFromFHP6);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("get_home_data",_loc2_));
      }
      
      public function visitFriend(param1:int) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameHouse.visitFriend",param1]);
         _loc2_.addEventListener("complete",returnFromFHP7);
      }
      
      private function returnFromFHP7(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",returnFromFHP7);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("visit_friend",_loc2_));
      }
      
      public function getNews() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameHouse.getNews"]);
         _loc1_.addEventListener("complete",getNewsHandler);
      }
      
      private function getNewsHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         if(_loc3_ != "false")
         {
            EventCenter.PHPEvent.dispatchEvent(new PHPEvent("logNews",_loc3_));
         }
      }
      
      public function getChatServerID(param1:Object) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameSAR.getSer",param1]);
         _loc2_.addEventListener("complete",getChatServerHandler);
      }
      
      private function getChatServerHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getChatServerID",_loc3_));
      }
      
      public function getDuplicateServer() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameSAR.getCopySar"]);
         _loc1_.addEventListener("complete",getDuplicateServerHandler);
      }
      
      private function getDuplicateServerHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getDuplicateServer",_loc3_));
      }
      
      public function getDuplicateRoomList(param1:Object) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameSAR.getCopyRoomList",param1]);
         _loc2_.addEventListener("complete",getDuplicateRoomListHandler);
      }
      
      private function getDuplicateRoomListHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getDuplicateRoomList",_loc3_));
      }
      
      public function getFightRoomList(param1:Object) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameSAR.getConsortionWarsRoomList",param1]);
         _loc2_.addEventListener("complete",getFightRoomListHandler);
      }
      
      private function getFightRoomListHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("GET_FIGHT_ROOMLIST",_loc3_));
      }
      
      public function enterWeeklyMatch() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameMatch.enterMatchByWeek"]);
         _loc1_.addEventListener("complete",enterWeeklyMatchHandler);
      }
      
      private function enterWeeklyMatchHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("ENTER_WEEKLY_MATCH_ROOM",_loc3_));
      }
      
      public function getWeeklyMatch() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameMatch.enterMatchHallByWeek"]);
         _loc1_.addEventListener("complete",getWeeklyMatchHandler);
      }
      
      private function getWeeklyMatchHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("GET_WEEKLY_MATCH",_loc3_));
      }
      
      public function getMatch() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameMatch.enterMatchHall"]);
         _loc1_.addEventListener("complete",getMatchHandler);
      }
      
      private function getMatchHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getMatch",_loc3_));
      }
      
      public function applicationFee(param1:uint, param2:uint) : void
      {
         var _loc3_:URLLoader = loaderURL(["GameMatch.enterMatch",[param1,param2]]);
         _loc3_.addEventListener("complete",applicationFeeHandler);
      }
      
      private function applicationFeeHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("APPLICATIONFEE",_loc3_));
      }
      
      public function txBuyTicket() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameMatch.txBuyTicket",[]]);
         _loc1_.addEventListener("complete",txBuyTicketHandler);
      }
      
      private function txBuyTicketHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("APPLICATIONFEE",_loc3_));
      }
      
      public function enterTxMatch() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameMatch.enterTxMatch"]);
         _loc1_.addEventListener("complete",enterTxMatchHandler);
      }
      
      private function enterTxMatchHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("APPLICATIONFEE",_loc3_));
      }
      
      public function checkUnionName(param1:String) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.checkConsortionName",param1]);
         _loc2_.addEventListener("complete",checkUnionNameHandler);
      }
      
      private function checkUnionNameHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("unionNameIsOK",_loc3_));
      }
      
      public function createUnion(param1:Object) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.createConsortion",param1]);
         _loc2_.addEventListener("complete",createUnionHandler);
      }
      
      private function createUnionHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("createUnion",_loc3_));
      }
      
      public function isHaveUnion() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameConsortion.getConsortion"]);
         _loc1_.addEventListener("complete",isHaveUnionHandler);
      }
      
      private function isHaveUnionHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("isHaveUnion",_loc3_));
      }
      
      public function getUnionMsgLists() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameConsortion.getConsortionMsgLists"]);
         _loc1_.addEventListener("complete",getUnionMsgListsDoneHandler);
      }
      
      private function getUnionMsgListsDoneHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getUnionMessageList",_loc3_));
      }
      
      public function leaveUnionMsg(param1:Object) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.leaveConsortionMsg",param1]);
         _loc2_.addEventListener("complete",leaveUnionMsgDone);
      }
      
      private function leaveUnionMsgDone(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("leaveUnionMessageDone",_loc3_));
      }
      
      public function getUnionList() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameConsortion.getConsortionList"]);
         _loc1_.addEventListener("complete",getUnionListHandler);
      }
      
      private function getUnionListHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getUnionList",_loc3_));
      }
      
      public function apply4Consortion(param1:int) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.apply4Consortion",param1]);
         _loc2_.addEventListener("complete",apply4ConsortionHandler);
      }
      
      private function apply4ConsortionHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("applyToUnion",_loc3_));
      }
      
      public function getApplyInfo() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameConsortion.getApplyInfo"]);
         _loc1_.addEventListener("complete",getApplyInfoHandler);
      }
      
      private function getApplyInfoHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getApplyUnionInfo",_loc3_));
      }
      
      public function cancelApplyUnion(param1:int) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.cancelApply",param1]);
         _loc2_.addEventListener("complete",cancelApplyHandler);
      }
      
      private function cancelApplyHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("cancelApplyUnion",_loc3_));
      }
      
      public function invitePlayerToUnion(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.invite",param1]);
         _loc2_.addEventListener("complete",invitePlayerToUnionHandler);
      }
      
      private function invitePlayerToUnionHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("invitePlayerToUnion",_loc3_));
      }
      
      public function dealInvite(param1:Object) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.dealInvite",param1]);
         _loc2_.addEventListener("complete",dealInviteHandler);
      }
      
      private function dealInviteHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("dealInvite",_loc3_));
      }
      
      public function editUnionNotice(param1:String) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.editPublicNotice",param1]);
         _loc2_.addEventListener("complete",editUnionNoticeHandler);
      }
      
      private function editUnionNoticeHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("editUnionNotice",_loc3_));
      }
      
      public function getUnionNotice() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameConsortion.getPublicNotice"]);
         _loc1_.addEventListener("complete",getUnionNoticeHandler);
      }
      
      private function getUnionNoticeHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getUnionNotice",_loc3_));
      }
      
      public function endowUnion(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.devoteConsortion",param1]);
         _loc2_.addEventListener("complete",endowUnionHandler);
      }
      
      private function endowUnionHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("endowUnion",_loc3_));
      }
      
      public function getWorshipInfo() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameConsortion.getWorship"]);
         _loc1_.addEventListener("complete",getWorshipInfoHandler);
      }
      
      private function getWorshipInfoHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getWorshipInfoDone",_loc3_));
      }
      
      public function worship(param1:int) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.worship",param1]);
         _loc2_.addEventListener("complete",worshipHandler);
      }
      
      private function worshipHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("worshipDone",_loc3_));
      }
      
      public function getWorshipReward() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameConsortion.receiveWorshipGifts"]);
         _loc1_.addEventListener("complete",getWorshipRewardHandel);
      }
      
      private function getWorshipRewardHandel(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getWorshipDone",_loc3_));
      }
      
      public function getUnionMember() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameConsortion.getConsortionMembers"]);
         _loc1_.addEventListener("complete",getUnionMemberHandler);
      }
      
      private function getUnionMemberHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getUnionMember",_loc3_));
      }
      
      public function editUnionPositionName(param1:Object) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.editPositionName",param1]);
         _loc2_.addEventListener("complete",editUnionPositionNameHandler);
      }
      
      private function editUnionPositionNameHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("editUnionPositionName",_loc3_));
      }
      
      public function getNoUnionPlayers() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameConsortion.getApplyMemList"]);
         _loc1_.addEventListener("complete",getNoUnionPlayersHandler);
      }
      
      private function getNoUnionPlayersHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getNoUnionPlayers",_loc3_));
      }
      
      public function dealUnionApply(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.dealApply",param1]);
         _loc2_.addEventListener("complete",dealUnionApplyHandler);
      }
      
      private function dealUnionApplyHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("dealUnionApply",_loc3_));
      }
      
      public function manageUnionMember(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.manageMember",param1]);
         _loc2_.addEventListener("complete",manageUnionMemberHandler);
      }
      
      private function manageUnionMemberHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("manageUnionMember",_loc3_));
      }
      
      public function combineUnionProp(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameProps.unionprop",param1]);
         _loc2_.addEventListener("complete",combineUnionPropHandler);
      }
      
      private function combineUnionPropHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("combineUnionProp",_loc3_));
      }
      
      public function upUnionLevel(param1:int) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.upConsortionLevel",param1]);
         _loc2_.addEventListener("complete",upUnionLevelHandler);
      }
      
      private function upUnionLevelHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("upUnionLevel",_loc3_));
      }
      
      public function unionThingsNote() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameConsortion.getcevents"]);
         _loc1_.addEventListener("complete",unionThingsNoteHandler);
      }
      
      private function unionThingsNoteHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("unionThingsNote",_loc3_));
      }
      
      public function editUnionCdesc(param1:String) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.editcdesc",param1]);
         _loc2_.addEventListener("complete",editUnionCdescHandler);
      }
      
      private function editUnionCdescHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("editUnionCdes",_loc3_));
      }
      
      public function editUnionlimit(param1:Object) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.editlimit",param1]);
         _loc2_.addEventListener("complete",editlimitHandler);
      }
      
      private function editlimitHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("editUnionLimit",_loc3_));
      }
      
      public function unionBuildRank() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameConsortion.consortionrank"]);
         _loc1_.addEventListener("complete",unionBuildRankHandler);
      }
      
      private function unionBuildRankHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("unionBuildRank",_loc3_));
      }
      
      public function unionHonorRank() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameConsortion.consortionhonorlist"]);
         _loc1_.addEventListener("complete",unionHonorRankHandler);
      }
      
      private function unionHonorRankHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("unionHonorRank",_loc3_));
      }
      
      public function changeUnionName(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameConsortion.editcname",param1]);
         _loc2_.addEventListener("complete",changeUnionNameHandler);
      }
      
      private function changeUnionNameHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("changeUnionName",_loc3_));
      }
      
      public function getMoonBox() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameActivity.getMoonBox"]);
         _loc1_.addEventListener("complete",getMoonBoxHandler);
      }
      
      private function getMoonBoxHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getMoonBox",_loc3_));
      }
      
      public function getHallowmasBox() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameActivity.getProgramBox"]);
         _loc1_.addEventListener("complete",getHallowmasBoxHandler);
      }
      
      private function getHallowmasBoxHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getHallowmasBox",_loc3_));
      }
      
      public function getDevoteDetail() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameConsortion.devoteDetail"]);
         _loc1_.addEventListener("complete",getDevoteDetailHandler);
      }
      
      private function getDevoteDetailHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("selfDevoteDetail",_loc3_));
      }
      
      public function getValentine() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameActivity.getValentinePoints"]);
         _loc1_.addEventListener("complete",getValentineHandler);
      }
      
      private function getValentineHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("VALENTINE",_loc3_));
      }
      
      public function getValentineBox(param1:int) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameActivity.receiveValentineGifts",param1]);
         _loc2_.addEventListener("complete",getValentineBoxHandler);
      }
      
      private function getValentineBoxHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("GET_VALENTINE_BOX",_loc3_));
      }
      
      public function getFreeSend(param1:int) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameTencent.getRequestLists",param1]);
         _loc2_.addEventListener("complete",getFreeSendHandler);
      }
      
      private function getFreeSendHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("GET_FREE_SEND",_loc3_));
      }
      
      public function getRose(param1:int) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameTencent.acceptGifts",[param1,2]]);
         _loc2_.addEventListener("complete",getRoseHandler);
      }
      
      private function getRoseHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("GET_ROSE",_loc3_));
      }
   }
}

