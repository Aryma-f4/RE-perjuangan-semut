package com.boyaa.antwars.net.server
{
   import com.boyaa.antwars.data.LoginData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.net.net.mySocket;
   import com.boyaa.debug.Logging.LevelLogger;
   import flash.utils.ByteArray;
   
   public class SendCmd
   {
      
      private var _socket:mySocket = null;
      
      public function SendCmd(param1:mySocket)
      {
         super();
         _socket = param1;
      }
      
      public function login() : void
      {
         var _loc1_:int = PlayerDataList.instance.selfData.win * 2 - PlayerDataList.instance.selfData.fail;
         _socket.writeBegin(1001);
         _socket.writeInt(LoginData.instance.mid);
         _socket.writeString(LoginData.instance.key);
         _socket.writeInt(PlayerDataList.instance.selfData.level);
         _socket.writeString(PlayerDataList.instance.selfData.babyName);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function heartbeat() : void
      {
         _socket.writeBegin(30001);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getAllGoods() : void
      {
         _socket.writeBegin(3014);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getMemBody() : void
      {
         _socket.writeBegin(3016);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function setMemBody(param1:Array) : void
      {
         _socket.writeBegin(3005);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeString(param1[0]);
         if(param1[1] == 0)
         {
            _socket.writeShort(0);
            _socket.writeInt(param1[2]);
         }
         else
         {
            _socket.writeShort(1);
            _socket.writeInt(param1[2]);
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sellGoods(param1:int, param2:int) : void
      {
         _socket.writeBegin(3004);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeInt(param1);
         _socket.writeShort(param2);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function toBuy(param1:int, param2:Array) : void
      {
         var _loc3_:int = 0;
         _socket.writeBegin(3013);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeShort(param1);
         _socket.writeShort(param2.length);
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            _socket.writeInt(param2[_loc3_][0]);
            _socket.writeInt(param2[_loc3_][1]);
            _socket.writeInt(param2[_loc3_][2]);
            _socket.writeInt(param2[_loc3_][3]);
            _socket.writeInt(param2[_loc3_][4]);
            _socket.writeString(param2[_loc3_][5]);
            _loc3_++;
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function useGoods(param1:int) : void
      {
         _socket.writeBegin(3006);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getServerList() : void
      {
         _socket.writeBegin(1);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getServerIDByType(param1:int) : void
      {
         _socket.writeBegin(4);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeInt(PlayerDataList.instance.selfData.level);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendChatToFriend(param1:int, param2:int, param3:String) : void
      {
         _socket.writeBegin(1002);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeString(param3);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendLoudSpeaker(param1:int, param2:String, param3:int) : void
      {
         _socket.writeBegin(1007);
         _socket.writeInt(param1);
         _socket.writeString(param2);
         _socket.writeInt(param3);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function inviteNoUnionPlayers() : void
      {
         _socket.writeBegin(1016);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendScreenPlace(param1:int) : void
      {
         _socket.writeBegin(1101);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function strenthen(param1:int, param2:Array) : void
      {
         var _loc3_:int = 0;
         _socket.writeBegin(3008);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeInt(param1);
         _socket.writeShort(param2.length);
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            _socket.writeInt(param2[_loc3_][0]);
            _socket.writeShort(param2[_loc3_][1]);
            _loc3_++;
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function transfer(param1:int, param2:int, param3:Array = null) : void
      {
         var _loc4_:int = 0;
         _socket.writeBegin(3009);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         if(param3)
         {
            _socket.writeShort(param3.length);
            _loc4_ = 0;
            while(_loc4_ < param3.length)
            {
               _socket.writeInt(param3[_loc4_][0]);
               _socket.writeShort(param3[_loc4_][1]);
               _loc4_++;
            }
         }
         else
         {
            _socket.writeShort(0);
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendLogin() : void
      {
         var _loc1_:PlayerData = PlayerDataList.instance.selfData;
         _socket.writeBegin(0);
         _socket.writeUint(LoginData.instance.mid);
         _socket.writeString(LoginData.instance.key);
         _socket.writeString(PlayerDataList.instance.selfData.toString());
         _socket.writeString(PlayerDataList.instance.selfData.babyName);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendUnionMsg(param1:String) : void
      {
         _socket.writeBegin(1008);
         _socket.writeString(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendmsg(param1:String) : void
      {
         _socket.writeBegin(3);
         _socket.writeString(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function SendFace(param1:int) : void
      {
         _socket.writeBegin(4);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function quickJoin(param1:int) : void
      {
         _socket.writeBegin(6);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function createRoom(param1:int, param2:int, param3:String = "") : void
      {
         _socket.writeBegin(3008);
         _socket.writeString(param3);
         _socket.writeInt(param2);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function seekRoom(param1:int, param2:String) : void
      {
         _socket.writeBegin(13);
         _socket.writeInt(param1);
         _socket.writeString(param2);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function netDelayTest() : void
      {
         _socket.writeBegin(37);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function updateDelayTime(param1:int) : void
      {
         _socket.writeBegin(38);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function selfReady(param1:int) : void
      {
         LevelLogger.getLogger("SendCmd").info(" selfReady: " + param1);
         _socket.writeBegin(7);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function changeRoom() : void
      {
         LevelLogger.getLogger("SendCmd").info("changeRoom");
         _socket.writeBegin(31);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendMapPROGRESS(param1:int) : void
      {
         _socket.writeBegin(34);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendLoadMapComplete() : void
      {
         _socket.writeBegin(1001);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendMove(param1:Array, param2:int, param3:int) : void
      {
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeObject(param1);
         _loc4_.compress();
         _socket.writeBegin(1002);
         _socket.writeBinary(_loc4_);
         _socket.writeInt(param2);
         _socket.writeInt(param3);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendCannonball(param1:int, param2:int, param3:int, param4:Array, param5:int = 0) : void
      {
         var _loc6_:int = 0;
         _socket.writeBegin(1005);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeInt(param3);
         _socket.writeInt(param5);
         _socket.writeInt(param4.length);
         _loc6_ = 0;
         while(_loc6_ < param4.length)
         {
            _socket.writeInt(param4[_loc6_][0]);
            _socket.writeInt(param4[_loc6_][1]);
            _socket.writeInt(param4[_loc6_][2]);
            _socket.writeInt(param4[_loc6_][3]);
            _socket.writeInt(param4[_loc6_][4]);
            _socket.writeInt(param4[_loc6_][5]);
            _socket.writeInt(param4[_loc6_][6]);
            _loc6_++;
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendLand() : void
      {
         _socket.writeBegin(39);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendOvertime() : void
      {
         _socket.writeBegin(1007);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendComplete() : void
      {
         _socket.writeBegin(1006);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function giveUp() : void
      {
         _socket.writeBegin(1014);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function luckyDraw(param1:int) : void
      {
         _socket.writeBegin(1011);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendDeductionHP() : void
      {
         _socket.writeBegin(1009);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function overFlop() : void
      {
         _socket.writeBegin(1024);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function btRoomChangeCloths(param1:int) : void
      {
         _socket.writeBegin(1206);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function buyPayProp(param1:int) : void
      {
         _socket.writeBegin(29);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function cancelPayProp(param1:int) : void
      {
         _socket.writeBegin(30);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function renew(param1:Array) : void
      {
         var _loc2_:int = 0;
         _socket.writeBegin(3007);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeShort(param1.length);
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _socket.writeInt(param1[_loc2_][0]);
            _socket.writeInt(param1[_loc2_][1]);
            _socket.writeInt(param1[_loc2_][2]);
            _loc2_++;
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendUseProp(param1:int) : void
      {
         _socket.writeBegin(1010);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getInviteList() : void
      {
         _socket.writeBegin(1009);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function acceptFriendInvite(param1:int) : void
      {
         _socket.writeBegin(1012);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function refuseFriendInvite(param1:int) : void
      {
         _socket.writeBegin(1011);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function inviteFriend(param1:int, param2:int, param3:int, param4:int, param5:String) : void
      {
         _socket.writeBegin(1010);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeInt(param3);
         _socket.writeInt(param4);
         _socket.writeString(param5);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function robotOver(param1:Array) : void
      {
         _socket.writeBegin(41);
         _socket.writeInt(param1[0]);
         _socket.writeInt(param1[1]);
         _socket.writeInt(param1[2]);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sentMsgToGetEnergy() : void
      {
         _socket.writeBegin(3051);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function consumeEnergy() : void
      {
         _socket.writeBegin(3052);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameConnectServer() : void
      {
         _socket.writeBegin(4001);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeString(LoginData.instance.key);
         _socket.writeString(PlayerDataList.instance.selfData.babyName);
         _socket.writeEnd();
         _socket.sendcmd();
         trace("copyGameConnectServer:" + PlayerDataList.instance.selfData.uid + "----------" + LoginData.instance.key + "-------------" + PlayerDataList.instance.selfData.babyName);
      }
      
      public function copyGameQuickGetIn() : void
      {
         sendOnlyCommand(4004);
      }
      
      public function copyGameLeaveRoom() : void
      {
         sendOnlyCommand(4009);
      }
      
      public function copyGameCreateRoom(param1:int) : void
      {
         _socket.writeBegin(4003);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameJoinRoom(param1:int) : void
      {
         _socket.writeBegin(4005);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameGetRoomList(param1:uint) : void
      {
         _socket.writeBegin(4008);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameCloseSite(param1:int) : void
      {
         _socket.writeBegin(4010);
         _socket.writeShort(0);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameOpenSite(param1:int) : void
      {
         _socket.writeBegin(4010);
         _socket.writeShort(1);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameKickPlayer(param1:int) : void
      {
         _socket.writeBegin(4011);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameFindRoom(param1:int, param2:uint) : void
      {
         _socket.writeBegin(4013);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGamePlayerReady(param1:int = 0) : void
      {
         _socket.writeBegin(4012);
         _socket.writeShort(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameQuickMatch(param1:uint) : void
      {
         _socket.writeBegin(4004);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGamestartGameInRoom(param1:uint) : void
      {
         _socket.writeBegin(4006);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameCreateRoomDone() : void
      {
         sendOnlyCommand(4016);
      }
      
      public function copyGameChangeClothes() : void
      {
         sendOnlyCommand(4018);
      }
      
      public function copyGameBackToRoom() : void
      {
         sendOnlyCommand(4017);
      }
      
      private function sendOnlyCommand(param1:uint) : void
      {
         _socket.writeBegin(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      private function sendOnlyParamCommand(param1:uint, param2:int) : void
      {
         _socket.writeBegin(param1);
         _socket.writeInt(param2);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getRankTop50(param1:int) : void
      {
         sendOnlyParamCommand(3053,param1);
      }
      
      public function getRankTop50WithMe(param1:int) : void
      {
         sendOnlyParamCommand(3054,param1);
      }
      
      public function getRankIsCanFight(param1:int) : void
      {
         sendOnlyParamCommand(3055,param1);
      }
      
      public function sendRankFightResult(param1:int, param2:int, param3:int, param4:String) : void
      {
         _socket.writeBegin(3056);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeInt(param3);
         _socket.writeString(param4);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getRankFightHistory(param1:int) : void
      {
         sendOnlyParamCommand(3057,param1);
      }
      
      public function getRankReward(param1:int, param2:uint) : void
      {
         _socket.writeBegin(3058);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getRankSomeOneEquip(param1:int) : void
      {
         sendOnlyParamCommand(3059,param1);
      }
      
      public function readMail(param1:int) : void
      {
         _socket.writeBegin(8002);
         _socket.writeInt(LoginData.instance.mid);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function delMail(param1:Array) : void
      {
         _socket.writeBegin(8005);
         _socket.writeInt(LoginData.instance.mid);
         _socket.writeInt(param1.length);
         for each(var _loc2_ in param1)
         {
            _socket.writeInt(_loc2_);
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendMail(param1:int, param2:String, param3:String, param4:Array) : void
      {
         _socket.writeBegin(8001);
         _socket.writeInt(LoginData.instance.mid);
         _socket.writeInt(param1);
         _socket.writeString(param2);
         _socket.writeString(param3);
         _socket.writeInt(param4.length);
         for each(var _loc5_ in param4)
         {
            _socket.writeInt(_loc5_);
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getMailList() : void
      {
         _socket.writeBegin(8003);
         _socket.writeInt(LoginData.instance.mid);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getMailFile(param1:Array) : void
      {
         _socket.writeBegin(8004);
         _socket.writeInt(LoginData.instance.mid);
         _socket.writeInt(param1.length);
         for each(var _loc2_ in param1)
         {
            _socket.writeInt(_loc2_);
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameBornPoint() : void
      {
         sendOnlyCommand(4055);
      }
      
      public function copyGameBossBornPoint() : void
      {
         sendOnlyCommand(4056);
      }
      
      public function copyGameShowComplete() : void
      {
         sendOnlyCommand(4110);
      }
      
      public function copyGamePlayerDone() : void
      {
         sendOnlyCommand(4117);
      }
      
      public function copyGamePlayerStatus(param1:int) : void
      {
         _socket.writeBegin(4105);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGamePlayerTimeout() : void
      {
         sendOnlyCommand(4108);
      }
      
      public function copyGamePlayerGiveUp() : void
      {
         sendOnlyCommand(4111);
      }
      
      public function copyGamePlayerDead() : void
      {
         sendOnlyCommand(4106);
      }
      
      public function copyGamePlayerExit() : void
      {
         sendOnlyCommand(4112);
      }
      
      public function copyGamePlayerMove(param1:Array, param2:int, param3:int) : void
      {
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeObject(param1);
         _loc4_.compress();
         _socket.writeBegin(4102);
         _socket.writeBinary(_loc4_);
         _socket.writeInt(param2);
         _socket.writeInt(param3);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGamePlayerUseProp(param1:int) : void
      {
         _socket.writeBegin(4100);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameBombPoint(param1:int, param2:int, param3:int, param4:Array, param5:int = 1) : void
      {
         var _loc6_:int = 0;
         _socket.writeBegin(4114);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeInt(param3);
         _socket.writeInt(param5);
         _socket.writeInt(param4.length);
         _loc6_ = 0;
         while(_loc6_ < param4.length)
         {
            _socket.writeInt(param4[_loc6_][0]);
            _socket.writeInt(param4[_loc6_][1]);
            _socket.writeInt(param4[_loc6_][2]);
            _socket.writeInt(param4[_loc6_][3]);
            _socket.writeInt(param4[_loc6_][4]);
            _socket.writeInt(param4[_loc6_][5]);
            _socket.writeInt(param4[_loc6_][6]);
            _socket.writeInt(param4[_loc6_][7]);
            _loc6_++;
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameMonsterAttack(param1:int, param2:int, param3:uint, param4:uint = 0) : void
      {
         _socket.writeBegin(4180);
         _socket.writeShort(param1);
         _socket.writeShort(param2);
         _socket.writeInt(param3);
         _socket.writeShort(param4);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameMapProgress(param1:Number) : void
      {
         var _loc2_:int = param1 * 100;
         _socket.writeBegin(4054);
         _socket.writeInt(_loc2_);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameMapLoadComplete() : void
      {
         _socket.writeBegin(4050);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function copyGameGetFirstShoot() : void
      {
         sendOnlyCommand(4052);
      }
      
      public function copyGameSendMonsterShow() : void
      {
         sendOnlyCommand(4116);
      }
      
      public function copyGameSendUseEnergy() : void
      {
         sendOnlyCommand(4118);
      }
      
      public function copyGameSendReliveInNormal() : void
      {
         sendOnlyCommand(4120);
      }
      
      public function CopyGameSendReliveInBossRoom() : void
      {
         sendOnlyCommand(4119);
      }
      
      public function sendFightData(param1:Array) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.compress();
         _socket.writeBegin(1204);
         _socket.writeBinary(_loc2_);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendGameOver(param1:int, param2:Array) : void
      {
         var _loc3_:int = 0;
         _socket.writeBegin(1203);
         _socket.writeInt(param1);
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            _socket.writeInt(param2[_loc3_]);
            _loc3_++;
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getEndlessData() : void
      {
         sendOnlyCommand(4300);
      }
      
      public function getEndlessMonsterData() : void
      {
         sendOnlyCommand(4301);
      }
      
      public function endlessWinAndGoNext(param1:int, param2:int) : void
      {
         _socket.writeBegin(4302);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function endlessWinAndGoBack(param1:int, param2:int) : void
      {
         _socket.writeBegin(4303);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function endlessRelive(param1:int, param2:int) : void
      {
         _socket.writeBegin(4304);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function endlessLossAndBack(param1:int, param2:int) : void
      {
         _socket.writeBegin(4305);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function endlessFlyToTop(param1:int) : void
      {
         _socket.writeBegin(4306);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function endlessGetRankList() : void
      {
         sendOnlyCommand(4307);
      }
      
      public function endlessBuyTime() : void
      {
         sendOnlyCommand(4308);
      }
      
      public function weddingSendPopMsg(param1:uint, param2:uint, param3:String) : void
      {
         _socket.writeBegin(6001);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeString(param3);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function weddingSendAnswerToPop(param1:int, param2:int) : void
      {
         _socket.writeBegin(6004);
         _socket.writeInt(param2);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function weddingSendMarryMe(param1:int) : void
      {
         _socket.writeBegin(6038);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function weddingGetWeddingMsg() : void
      {
         sendOnlyCommand(6039);
      }
      
      public function weddingSendDivorceMsg(param1:int, param2:uint, param3:String) : void
      {
         _socket.writeBegin(6040);
         _socket.writeInt(param1);
         if(param1 == 1)
         {
            _socket.writeInt(param2);
            _socket.writeString(param3);
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function weddingSendDivorceAnswer(param1:int) : void
      {
         _socket.writeBegin(6042);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function weddingSendExchangeRing(param1:int, param2:Array) : void
      {
         var _loc3_:int = 0;
         _socket.writeBegin(6043);
         _socket.writeInt(param1);
         _socket.writeShort(param2.length);
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            _socket.writeInt(param2[_loc3_][0]);
            _loc3_++;
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function unionFightGameStart() : void
      {
         sendOnlyCommand(5301);
      }
      
      public function unionFightUseProp(param1:int) : void
      {
         _socket.writeBegin(5302);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function unionFightActionComplete() : void
      {
         sendOnlyCommand(5305);
      }
      
      public function unionFightBombPoint(param1:int, param2:int, param3:int, param4:Array, param5:int = 1) : void
      {
         _socket.writeBegin(5306);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeInt(param3);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function unionFightGetRank() : void
      {
         sendOnlyCommand(5309);
      }
      
      public function unionFightGetInfo() : void
      {
         sendOnlyCommand(5310);
      }
      
      public function unionFightGetReward() : void
      {
         sendOnlyCommand(5312);
      }
      
      public function exchangePropMessage(param1:int, param2:int, param3:Array) : void
      {
         var _loc4_:int = 0;
         _socket.writeBegin(3053);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeInt(param3.length);
         _loc4_ = 0;
         while(_loc4_ < param3.length)
         {
            _socket.writeInt(param3[_loc4_][0]);
            _socket.writeInt(param3[_loc4_][1]);
            _loc4_++;
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function sendCmdForRankActLevel() : void
      {
         sendOnlyCommand(3063);
      }
      
      public function sendCmdForRankActFight() : void
      {
         sendOnlyCommand(3062);
      }
      
      public function useVipRelive(param1:int, param2:int) : void
      {
         _socket.writeBegin(4310);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function vipLuckyDraw(param1:int) : void
      {
         _socket.writeBegin(3005);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function someOneVipLevel(param1:int) : void
      {
         trace("someOneVipLevel:",param1);
         _socket.writeBegin(3110);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getVipViewInfo(param1:int) : void
      {
         _socket.writeBegin(3111);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function rewardVipLevelGifts(param1:int) : void
      {
         _socket.writeBegin(3112);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getAutoFightTimes() : void
      {
         _socket.writeBegin(3114);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function useFreeAutoFight() : void
      {
         _socket.writeBegin(3115);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getFreeReliveTimesInCopy() : void
      {
         sendOnlyCommand(4122);
      }
      
      public function useFreeReliveInCopy(param1:int) : void
      {
         _socket.writeBegin(4123);
         _socket.writeInt(param1);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function toSynthesis(param1:Array) : void
      {
         var _loc2_:int = 0;
         _socket.writeBegin(3010);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(_loc2_ < 3)
            {
               _socket.writeInt(param1[_loc2_]);
            }
            else
            {
               _socket.writeShort(param1[_loc2_]);
            }
            _loc2_++;
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function toAddition(param1:Array) : void
      {
         var _loc2_:int = 0;
         _socket.writeBegin(3116);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(_loc2_ < 3)
            {
               _socket.writeInt(param1[_loc2_]);
            }
            else
            {
               _socket.writeShort(param1[_loc2_]);
            }
            _loc2_++;
         }
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function tostorage(param1:Array) : void
      {
         _socket.writeBegin(3018);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeInt(param1[0]);
         _socket.writeShort(param1[1]);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function rentGoods(param1:Array) : void
      {
         _socket.writeBegin(3109);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeInt(param1[0]);
         _socket.writeInt(param1[1]);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function getAllRentingGoods() : void
      {
         _socket.writeBegin(3117);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function toRentalStorage(param1:Array) : void
      {
         _socket.writeBegin(3107);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeInt(param1[0]);
         _socket.writeInt(param1[1]);
         _socket.writeInt(param1[2]);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function toMywarehouseFromUnionStroage(param1:Array) : void
      {
         _socket.writeBegin(3108);
         _socket.writeInt(PlayerDataList.instance.selfData.uid);
         _socket.writeInt(param1[0]);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function btGetFightList(param1:int = 0) : void
      {
         sendOnlyParamCommand(3007,param1);
      }
      
      public function btCreateRoom(param1:int, param2:int, param3:String = "") : void
      {
         _socket.writeBegin(3008);
         _socket.writeString(param3);
         _socket.writeInt(param2);
         _socket.writeInt(param1);
      }
      
      public function getPlayerBattleWeapon() : void
      {
         sendOnlyCommand(3009);
      }
      
      public function playerChangeWeaponInBox(param1:int, param2:int) : void
      {
         _socket.writeBegin(3010);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function playerChangeWeaponInBattle(param1:int, param2:int) : void
      {
         _socket.writeBegin(3011);
         _socket.writeInt(param1);
         _socket.writeInt(param2);
         _socket.writeEnd();
         _socket.sendcmd();
      }
      
      public function changeWeaponDone(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               sendOnlyCommand(3012);
               break;
            case 1:
               sendOnlyCommand(4124);
               break;
            case 2:
               sendOnlyCommand(5315);
         }
      }
   }
}

