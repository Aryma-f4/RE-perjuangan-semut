package com.boyaa.antwars.net.server
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.debug.Logging.LevelLogger;
   
   public class BattleServer extends BaseServer
   {
      
      private static var _instance:BattleServer = null;
      
      private var netDelayTime:Number;
      
      public function BattleServer(param1:Single)
      {
         super();
      }
      
      public static function get instance() : BattleServer
      {
         if(_instance == null)
         {
            _instance = new BattleServer(new Single());
         }
         return _instance;
      }
      
      override public function init(param1:String, param2:int) : void
      {
         super.init(param1,param2);
         socketSignal.add(closeErr);
         enterRoom(enterBtRoom);
      }
      
      private function closeErr(param1:String) : void
      {
         if(param1 == "Close" || param1 == "Error")
         {
            TextTip.instance.showByLang("connectFail");
            Application.instance.currentGame.hiddenLoading();
            Application.instance.currentGame.navigator.showScreen("HALL");
         }
      }
      
      private function enterBtRoom(param1:Object) : void
      {
         LevelLogger.getLogger("BattleServer").info(JSON.stringify(param1));
         PlayerDataList.instance.selfData.siteID = param1.data.siteID;
         PlayerDataList.instance.selfData.team = param1.data.team;
         PlayerDataList.instance.selfData.houseOwner = param1.data.isHouseOwner;
         var _loc2_:Object = Application.instance.currentGame._btRoomOptionsData;
         _loc2_.pk_mode = param1.data.pk_mode;
         _loc2_.mapID = param1.data.mapID;
         _loc2_.siteStatusArr = param1.data.siteStatusArr;
         _loc2_.roomid = param1.data.roomid;
         _loc2_.pk_type = param1.data.pk_type;
         _loc2_.isHouseOwner = param1.data.isHouseOwner;
         _loc2_.password = param1.data.password;
         if(Application.instance.currentGame.navigator.activeScreenID == "BTROOM")
         {
            Application.instance.currentGame.navigator.clearScreen();
         }
         Application.instance.currentGame.navigator.showScreen("BTROOM");
      }
      
      public function syncBody(param1:Function) : void
      {
         recv.bindFun(1001,param1,false);
      }
      
      public function otherComeOn(param1:Function) : void
      {
         recv.bindFun(6,param1,false);
      }
      
      public function onChangeRoomFast(param1:Function) : void
      {
         recv.bindFun(1201,param1,false);
      }
      
      public function changeCloths(param1:int) : void
      {
         send.btRoomChangeCloths(param1);
      }
      
      public function playerReady(param1:Function) : void
      {
         recv.bindFun(8,param1,false);
      }
      
      public function onChangeRoomError(param1:Function) : void
      {
         recv.bindFun(27,param1,false);
      }
      
      public function login(param1:Function) : void
      {
         send.sendLogin();
         recv.bindFun(1,param1);
      }
      
      public function quickJoin(param1:int) : void
      {
         send.quickJoin(param1);
      }
      
      public function createRoom(param1:int, param2:int, param3:String) : void
      {
         send.createRoom(param1,param2,param3);
      }
      
      public function seekRoom(param1:int, param2:String) : void
      {
         send.seekRoom(param1,param2);
      }
      
      public function enterRoom(param1:Function) : void
      {
         recv.bindFun(5,param1,false);
      }
      
      public function netDelayTest() : void
      {
         var starttime:Number = Number(new Date().getTime());
         send.netDelayTest();
         recv.bindFun(32,(function():*
         {
            var gettime:Function;
            return gettime = function(param1:Object):void
            {
               netDelayTime = new Date().getTime() - starttime;
               send.updateDelayTime(netDelayTime);
            };
         })());
      }
      
      public function allReadyGo(param1:Function) : void
      {
         recv.bindFun(24,param1,false);
      }
      
      public function sendMapPROGRESS(param1:int) : void
      {
         send.sendMapPROGRESS(param1);
      }
      
      public function mapPROGRESS(param1:Function) : void
      {
         recv.bindFun(30,param1,false);
      }
      
      public function sendLoadMapComplete() : void
      {
         send.sendLoadMapComplete();
      }
      
      public function gameStart(param1:Function) : void
      {
         recv.bindFun(1005,param1);
      }
      
      public function selfReady(param1:int) : void
      {
         send.selfReady(param1);
      }
      
      public function sendChangeRoom() : void
      {
         send.changeRoom();
      }
      
      public function otherMove(param1:Function) : void
      {
         recv.bindFun(1007,param1,false);
      }
      
      public function onSetSender(param1:Function) : void
      {
         recv.bindFun(1008,param1,false);
      }
      
      public function syncAnger(param1:Function) : void
      {
         recv.bindFun(1103,param1,false);
      }
      
      public function sendMove(param1:Array, param2:Number, param3:Number) : void
      {
         send.sendMove(param1,param2,param3);
      }
      
      public function sendCannonball(param1:int, param2:int, param3:int, param4:Array) : void
      {
         send.sendCannonball(param1,param2,param3,param4);
      }
      
      public function onBombPoint(param1:Function) : void
      {
         recv.bindFun(1010,param1,false);
      }
      
      public function sendLand() : void
      {
         send.sendLand();
      }
      
      public function sendOvertime() : void
      {
         send.sendOvertime();
      }
      
      public function sendComplete() : void
      {
         send.sendComplete();
      }
      
      public function giveUp() : void
      {
         send.giveUp();
      }
      
      public function onGameOver(param1:Function) : void
      {
         recv.bindFun(1006,param1,false);
      }
      
      public function onPlayerLeave(param1:Function) : void
      {
         recv.bindFun(7,param1,false);
      }
      
      public function luckyDraw(param1:int) : void
      {
         if(param1 < 6)
         {
            send.luckyDraw(param1);
         }
         else
         {
            send.vipLuckyDraw(param1);
         }
      }
      
      public function onVipLuckyDraw(param1:Function) : void
      {
         recv.bindFun(3005,param1,false);
      }
      
      public function onLuckyDraw(param1:Function) : void
      {
         recv.bindFun(1015,param1,false);
      }
      
      public function sendDeductionHP() : void
      {
         send.sendDeductionHP();
      }
      
      public function overFlop() : void
      {
         Application.instance.log("发送翻牌命令","----------");
         send.overFlop();
      }
      
      public function buyPayProp(param1:int) : void
      {
         send.buyPayProp(param1);
      }
      
      public function cancelPayProp(param1:int) : void
      {
         send.cancelPayProp(param1);
      }
      
      public function onRecv_buy(param1:Function) : void
      {
         recv.bindFun(1019,param1,false);
      }
      
      public function sendUseProp(param1:int) : void
      {
         send.sendUseProp(param1);
      }
      
      public function onUseProp(param1:Function) : void
      {
         recv.bindFun(1014,param1,false);
      }
      
      public function onLoadMapOverTime(param1:Function) : void
      {
         recv.bindFun(1017,param1,false);
      }
      
      public function onAntDropDead(param1:Function) : void
      {
         recv.bindFun(3006,param1,false);
      }
      
      public function sendMsg(param1:String) : void
      {
         send.sendmsg(param1);
      }
      
      public function onChatMsg(param1:Function) : void
      {
         recv.bindFun(3,param1,false);
      }
      
      public function sendFace(param1:int) : void
      {
         send.SendFace(param1);
      }
      
      public function onFace(param1:Function) : void
      {
         recv.bindFun(4,param1,false);
      }
      
      public function onRobotCome(param1:Function) : void
      {
         recv.bindFun(38,param1,false);
      }
      
      public function onStartRobot(param1:Function) : void
      {
         recv.bindFun(39,param1);
      }
      
      public function robotOver(param1:Array) : void
      {
         send.robotOver(param1);
      }
      
      private function addLuckydrawGood(param1:Function) : void
      {
         recv.bindFun(3024,param1,false);
      }
      
      public function rankTop50(param1:int) : void
      {
         send.getRankTop50(param1);
      }
      
      public function rankTop50ArrowMe(param1:int) : void
      {
         send.getRankTop50WithMe(param1);
      }
      
      public function getRankIsCanFight(param1:int) : void
      {
         send.getRankIsCanFight(param1);
      }
      
      public function sendRankFightWin(param1:int, param2:int, param3:int, param4:String) : void
      {
         send.sendRankFightResult(param1,param2,param3,param4);
      }
      
      public function getRankFightHistory(param1:int) : void
      {
         send.getRankFightHistory(param1);
      }
      
      public function getRankReward(param1:int, param2:uint) : void
      {
         send.getRankReward(param1,param2);
      }
      
      public function getRankSomeOneEquip(param1:int) : void
      {
         send.getRankSomeOneEquip(param1);
      }
      
      public function onRankTo50(param1:Function) : void
      {
         recv.bindFun(3053,param1,false);
      }
      
      public function onRankTo50ArrowMe(param1:Function) : void
      {
         recv.bindFun(3054,param1,false);
      }
      
      public function onRankIsCanFight(param1:Function) : void
      {
         recv.bindFun(3055,param1,false);
      }
      
      public function onRankFightResut(param1:Function) : void
      {
         recv.bindFun(3056,param1,false);
      }
      
      public function onRankFightHistory(param1:Function) : void
      {
         recv.bindFun(3057,param1,false);
      }
      
      public function onRankFightRewards(param1:Function) : void
      {
         recv.bindFun(3058,param1,false);
      }
      
      public function onRankSomeoneEquip(param1:Function) : void
      {
         recv.bindFun(3059,param1,false);
      }
      
      public function on2v2GameTimeOut(param1:Function) : void
      {
         recv.bindFun(1208,param1);
      }
      
      public function on2v2RobotGameStart(param1:Function) : void
      {
         recv.bindFun(1207,param1,false);
      }
      
      public function sendFightData(param1:Array) : void
      {
         send.sendFightData(param1);
      }
      
      public function onFightData(param1:Function) : void
      {
         recv.bindFun(1204,param1,false);
      }
      
      public function onPlayerLeaveInRobot(param1:Function) : void
      {
         recv.bindFun(1205,param1,false);
      }
      
      public function onChangeRoomOwner(param1:Function) : void
      {
         recv.bindFun(9,param1,false);
      }
      
      public function onFindRoomError(param1:Function) : void
      {
         recv.bindFun(12,param1,false);
      }
      
      public function onFindRoomEmpty(param1:Function) : void
      {
         recv.bindFun(3000,param1,false);
      }
      
      public function sendGameOverInRobot(param1:int, param2:Array) : void
      {
         send.sendGameOver(param1,param2);
      }
      
      public function getRankActivityLevelData(param1:Function) : void
      {
         _recv.bindFun(3063,param1);
         _send.sendCmdForRankActLevel();
      }
      
      public function getRankActivityFightData(param1:Function) : void
      {
         _recv.bindFun(3062,param1);
         _send.sendCmdForRankActFight();
      }
      
      public function getFightList(param1:Function, param2:int = 0) : void
      {
         _recv.bindFun(3007,param1);
         _send.btGetFightList(param2);
      }
      
      public function onPlayerChangeWeaponInFightDone(param1:Function) : void
      {
         _recv.bindFun(3011,param1,false);
      }
      
      public function sendChangeWeaponDone() : void
      {
         send.changeWeaponDone(0);
      }
      
      public function onChangeWeaponDone(param1:Function) : void
      {
         recv.bindFun(3012,param1,false);
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
