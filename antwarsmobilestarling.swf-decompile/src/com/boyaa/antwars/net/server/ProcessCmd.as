package com.boyaa.antwars.net.server
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.events.SocketEvent;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.net.mySocket;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.battlefield.element.bullet.BulletSlottingManager;
   import com.boyaa.antwars.view.screen.copygame.team.RoomListData;
   import com.boyaa.debug.Logging.LevelLogger;
   import com.boyaa.tool.Tiptext;
   import flash.utils.ByteArray;
   
   public class ProcessCmd
   {
      
      private var _cmdFunMap:Object = {};
      
      private var _userFunMapOnce:Object = {};
      
      private var _userFunMap:Object = {};
      
      private var _propArr:Array = [];
      
      private var _socket:mySocket = null;
      
      private var friendsArr:Array = [];
      
      public function ProcessCmd(param1:mySocket)
      {
         super();
         _socket = param1;
      }
      
      public function RegisterCMDFun(param1:String) : void
      {
         switch(param1)
         {
            case "GameServer":
               RegisterCMDFunForGameServer();
               break;
            case "BattleServer":
               RegisterCMDFunForBattleServer();
               break;
            case "CopyServer":
               RegisterCMDFunForCopyServer();
         }
      }
      
      private function RegisterCMDFunForGameServer() : void
      {
         _cmdFunMap[1008] = loginSuccessful;
         _cmdFunMap[1007] = loginRepeat;
         _cmdFunMap[3014] = getAllGoods;
         _cmdFunMap[3016] = getBobyGoods;
         _cmdFunMap[3005] = setMemBody;
         _cmdFunMap[3013] = toBuy;
         _cmdFunMap[1] = getServerList;
         _cmdFunMap[4] = getServerIDByType;
         _cmdFunMap[1002] = onChatToFriend;
         _cmdFunMap[1026] = onLoudSpeaker;
         _cmdFunMap[1001] = getLoudSpeakerFromServer;
         _cmdFunMap[1009] = getUnionSpeakerFromServer;
         _cmdFunMap[3004] = onDelGoods;
         _cmdFunMap[1013] = onFriendList;
         _cmdFunMap[1022] = onFriendList;
         _cmdFunMap[3007] = onRenew;
         _cmdFunMap[3024] = addGood;
         _cmdFunMap[3006] = onUseGoods;
         _cmdFunMap[2900] = onServerBusy;
         _cmdFunMap[3008] = onStrenthen;
         _cmdFunMap[3009] = onTransfer;
         _cmdFunMap[3051] = onEnergyValue;
         _cmdFunMap[3052] = onConsumeEnergy;
         _cmdFunMap[1017] = onBeInvited;
         _cmdFunMap[8001] = onSendMailDone;
         _cmdFunMap[8002] = onReadMailDone;
         _cmdFunMap[8003] = onGetMailListDone;
         _cmdFunMap[8004] = onGetMailFileDone;
         _cmdFunMap[8005] = onDelMailDone;
         _cmdFunMap[8006] = onNewMailCome;
         _cmdFunMap[8008] = updateBagItems;
         _cmdFunMap[6006] = onWeddingMarryState;
         _cmdFunMap[6002] = onWeddingReceivePopMarry;
         _cmdFunMap[6001] = onWeddingMarrySendIsDone;
         _cmdFunMap[6004] = onWeddingPopAnswer;
         _cmdFunMap[6039] = onWeddingEnterMsg;
         _cmdFunMap[6007] = onWeddingPushMarryMsg;
         _cmdFunMap[6038] = onWeddingMarryBack;
         _cmdFunMap[6040] = onWeddingSendDivorceMsgIsDone;
         _cmdFunMap[6041] = onWeddingDivorceMsgReceive;
         _cmdFunMap[6042] = onWeddingDivorceMsgAnswer;
         _cmdFunMap[3226] = onWeddingExchangeRing;
         _cmdFunMap[1023] = onHandleUnionInviteList;
         _cmdFunMap[1024] = onHandleUnionInviteListDone;
         _cmdFunMap[3018] = onHandleUnionTostorageDone;
         _cmdFunMap[3109] = onHandleUnionRentGoodsDone;
         _cmdFunMap[3117] = onHandleUnionRentlistDone;
         _cmdFunMap[3107] = onHandleUnionTorentalStorageDone;
         _cmdFunMap[3108] = onHandleFromeUnionToMyStorageDone;
         _cmdFunMap[3118] = onDelOvertimeRentalGoods;
         _cmdFunMap[3119] = getBagItemRentStatus;
         _cmdFunMap[3120] = nobodyRentAndBacktoMystor;
         _cmdFunMap[3053] = onExchangeResponse;
         _cmdFunMap[3110] = onSomeoneVipLevel;
         _cmdFunMap[3111] = onVipViewInfo;
         _cmdFunMap[3112] = onVipReward;
         _cmdFunMap[3114] = onAutoFightTimes;
         _cmdFunMap[3115] = onUseAutoFight;
         _cmdFunMap[3010] = onSynthesis;
         _cmdFunMap[3116] = onAddition;
      }
      
      private function RegisterCMDFunForBattleServer() : void
      {
         _cmdFunMap[1] = loginBTSuccessful;
         _cmdFunMap[2] = loginBTFail;
         _cmdFunMap[5] = enterRoom;
         _cmdFunMap[32] = netDelayTest;
         _cmdFunMap[6] = otherEnterRoom;
         _cmdFunMap[1001] = syncBody;
         _cmdFunMap[24] = allReadyGo;
         _cmdFunMap[30] = onMapPROGRESS;
         _cmdFunMap[1017] = onLoadMapOverTime;
         _cmdFunMap[1005] = onGameStart;
         _cmdFunMap[1007] = otherMove;
         _cmdFunMap[1008] = onSetSender;
         _cmdFunMap[1103] = syncAnger;
         _cmdFunMap[1010] = onBombPoint;
         _cmdFunMap[1006] = onGameOver;
         _cmdFunMap[7] = onPlayerLeave;
         _cmdFunMap[1015] = onLuckDraw;
         _cmdFunMap[1019] = onRecv_buy;
         _cmdFunMap[1014] = onUseProp;
         _cmdFunMap[3] = onChat;
         _cmdFunMap[4] = onExpression;
         _cmdFunMap[38] = onRobotCome;
         _cmdFunMap[39] = onStartRobot;
         _cmdFunMap[3024] = addLuckydrawGood;
         _cmdFunMap[8] = onPlayerReady;
         _cmdFunMap[27] = onChangeRoomError;
         _cmdFunMap[3006] = onPlayerDropDeadInBT;
         _cmdFunMap[1204] = onFightDataInRobot;
         _cmdFunMap[1205] = onPlayerLeaveInRobotFight;
         _cmdFunMap[9] = onChangeHouseOwner;
         _cmdFunMap[1201] = onChangeRoomFast;
         _cmdFunMap[1207] = on2v2RobotGameStart;
         _cmdFunMap[1208] = on2v2RobotTimeOut;
         _cmdFunMap[3053] = onRankTop50Player;
         _cmdFunMap[3054] = onRank50PlayerArrowMe;
         _cmdFunMap[3055] = onRankFightCount;
         _cmdFunMap[3056] = onRankFightResult;
         _cmdFunMap[3058] = onGetRankReward;
         _cmdFunMap[3057] = onRankFightHistory;
         _cmdFunMap[3059] = onGetRankPlayerEquip;
         _cmdFunMap[3062] = onRankActFightData;
         _cmdFunMap[3063] = onRankActLevelData;
         _cmdFunMap[12] = onBTFingRoomError;
         _cmdFunMap[3000] = onBTFingRoomEmpty;
         _cmdFunMap[3005] = onVipLuckyDraw;
         _cmdFunMap[3007] = onBTGetRoomList;
         _cmdFunMap[3012] = onPlayerChangeWeaponInFightDone;
      }
      
      private function RegisterCMDFunForCopyServer() : void
      {
         _cmdFunMap[4001] = onCopyGameLoginSuccessful;
         _cmdFunMap[4008] = onCopyGameShowRoomList;
         _cmdFunMap[4013] = onCopyGameFindRoom;
         _cmdFunMap[4003] = onCopyGameCreateRoom;
         _cmdFunMap[4005] = onCopyGameJoinRoom;
         _cmdFunMap[4004] = onCopyGameQuickMatch;
         _cmdFunMap[4010] = onCopyGameCloseSite;
         _cmdFunMap[4012] = onCopyGamePlayerReady;
         _cmdFunMap[4009] = onCopyGameLeaveRoom;
         _cmdFunMap[4011] = onCopyGameKickPlayer;
         _cmdFunMap[4006] = onCopyGameStart;
         _cmdFunMap[4014] = onCopyGameOtherJoinRoom;
         _cmdFunMap[4018] = copyGameChangeClothes;
         _cmdFunMap[4056] = onCopyGameBossBorning;
         _cmdFunMap[4055] = onCopyGameBorn;
         _cmdFunMap[4100] = onCopyGameUseProp;
         _cmdFunMap[4112] = onCopyGamePlayerExit;
         _cmdFunMap[4111] = onCopyGamePlayerGiveUp;
         _cmdFunMap[4115] = onCopyGamePlayerMove;
         _cmdFunMap[4105] = onCopyGamePlayerStatus;
         _cmdFunMap[4110] = onCopyGamePlayerShowComplete;
         _cmdFunMap[4054] = onCopyGameMapProgress;
         _cmdFunMap[4052] = onCopyGameFightBoss;
         _cmdFunMap[4113] = onCopyGameShooter;
         _cmdFunMap[4114] = onCopyGameBombPoint;
         _cmdFunMap[4108] = onCopyGamePlayerTimeOut;
         _cmdFunMap[4150] = onCopyGameBossAttack;
         _cmdFunMap[4007] = onCopyGameTurn;
         _cmdFunMap[4106] = onCopyGamePlayerDead;
         _cmdFunMap[4180] = onCopyGameMonsterAttack;
         _cmdFunMap[4053] = onCopyGameGameOver;
         _cmdFunMap[4202] = onCopyGameMonsterCount;
         _cmdFunMap[3024] = addLuckydrawGood;
         _cmdFunMap[1015] = onLuckDraw;
         _cmdFunMap[4017] = onCopyGameBackToRoom;
         _cmdFunMap[4118] = onCopyGameUseEnergy;
         _cmdFunMap[4184] = onCopyGameMonsterShooterAttack;
         _cmdFunMap[4119] = onCopyGameReliveInBossRoom;
         _cmdFunMap[4121] = onCopyGamePublicRelive;
         _cmdFunMap[4120] = onCopyGameReliveInNormal;
         _cmdFunMap[4300] = onEndlessGetData;
         _cmdFunMap[4301] = onEndlessGetMonsters;
         _cmdFunMap[4302] = onEndlessNextLevel;
         _cmdFunMap[4304] = onEndlessRelive;
         _cmdFunMap[4306] = onEndlessFlyToTop;
         _cmdFunMap[4307] = onEndlessRankList;
         _cmdFunMap[4308] = onEndlessBuyTime;
         _cmdFunMap[4310] = onVipReliveInEndless;
         _cmdFunMap[4309] = onEndlessItemReceive;
         _cmdFunMap[5301] = onUnionFightGameStart;
         _cmdFunMap[5306] = onUnionFightBombPoint;
         _cmdFunMap[5304] = onUnionFightBossAttack;
         _cmdFunMap[5308] = onUnionFightBossDead;
         _cmdFunMap[5310] = onUnionFightInfo;
         _cmdFunMap[5309] = onUnionFightGetRank;
         _cmdFunMap[5312] = onUnionFightGetReward;
         _cmdFunMap[5311] = onUnionFightDevoteMsg;
         _cmdFunMap[5303] = onUnionFightSwitch;
         _cmdFunMap[5307] = onUnionFightTimeOver;
         _cmdFunMap[5300] = onUnionFightState;
         _cmdFunMap[5302] = onUnionFightUseProp;
         _cmdFunMap[4122] = onFreeReliveTimesInCopy;
         _cmdFunMap[4123] = onUseFreeReliveInCopy;
         _cmdFunMap[4124] = onPlayerChangeWeaponInFightDone;
      }
      
      private function onHandleUnionInviteListDone(param1:int) : void
      {
         _socket.readbegin();
      }
      
      private function onExchangeResponse(param1:int) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = [];
         _socket.readbegin();
         var _loc4_:int = _socket.readInt();
         _loc3_.push(_socket.readShort());
         if(_loc3_[0])
         {
            _loc2_ = [];
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readString());
            _loc2_.push(_socket.readString());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readString());
            if(_loc3_[2] >= 61 && _loc3_[2] <= 63)
            {
               _loc2_.push(_socket.readString());
            }
            GoodsList.instance.addGoodsByStr(_loc2_);
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onHandleUnionInviteList(param1:int) : void
      {
         var _loc5_:int = 0;
         var _loc4_:Array = null;
         _socket.readbegin();
         var _loc3_:int = _socket.readInt();
         var _loc2_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = [];
            _loc4_.push(_socket.readInt());
            _loc4_.push(_socket.readString());
            _loc4_.push(_socket.readInt());
            _loc4_.push(_socket.readInt());
            _loc4_.push(_socket.readInt());
            _loc2_.push(_loc4_);
            _loc5_++;
         }
         EventCenter.SocketEvent.dispatchEvent(new SocketEvent("OnlineFriendList",_loc2_));
      }
      
      public function ProcessServerCMD(param1:uint) : void
      {
         if(_cmdFunMap[param1])
         {
            _cmdFunMap[param1](param1);
         }
      }
      
      public function bindFun(param1:uint, param2:Function, param3:Boolean = true) : void
      {
         if(param3)
         {
            if(!(_userFunMapOnce[param1] is Array))
            {
               _userFunMapOnce[param1] = [param2];
            }
            else
            {
               _userFunMapOnce[param1].push(param2);
            }
         }
         else if(!(_userFunMap[param1] is Array))
         {
            _userFunMap[param1] = [param2];
         }
         else if(_userFunMap[param1].indexOf(param2) == -1)
         {
            _userFunMap[param1].push(param2);
         }
      }
      
      public function disposeFunAll() : void
      {
         _userFunMapOnce = null;
         _userFunMap = null;
         _userFunMapOnce = {};
         _userFunMap = {};
      }
      
      public function disposeFun(param1:Function) : void
      {
         var _loc3_:int = 0;
         for(var _loc2_ in _userFunMap)
         {
            _loc3_ = int(_userFunMap[_loc2_].indexOf(param1));
            if(_loc3_ != -1)
            {
               _userFunMap[_loc2_].splice(_loc3_,1);
            }
         }
         for(var _loc4_ in _userFunMapOnce)
         {
            _loc3_ = int(_userFunMapOnce[_loc4_].indexOf(param1));
            if(_loc3_ != -1)
            {
               _userFunMapOnce[_loc4_].splice(_loc3_,1);
            }
         }
      }
      
      private function callUserFun(param1:uint, param2:Object) : void
      {
         if(_userFunMapOnce[param1] && _userFunMapOnce[param1].length > 0)
         {
            while(_userFunMapOnce[param1].length)
            {
               _userFunMapOnce[param1].shift()(param2);
            }
         }
         if(_userFunMap[param1] && _userFunMap[param1].length > 0)
         {
            for each(var _loc3_ in _userFunMap[param1])
            {
               _loc3_(param2);
            }
         }
      }
      
      private function loginSuccessful(param1:uint = 0) : void
      {
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         LevelLogger.getLogger("ProcessCmd").info("Server 登录成功");
         var _loc4_:Array = [];
         _socket.readbegin();
         var _loc5_:int = _socket.readInt();
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_ = _socket.readInt();
            _loc4_.push(_loc2_);
            _loc6_++;
         }
         var _loc3_:String = _socket.readString();
         MissionManager.instance.onLineTime = _socket.readInt() / 60;
         MissionManager.instance.countOnlineTimeStart();
         GameServer.instance.heartbeat();
      }
      
      private function loginRepeat(param1:uint = 0) : void
      {
         trace("重复登录处理");
         callUserFun(param1,{});
      }
      
      private function getAllGoods(param1:uint) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc4_:Object = null;
         _socket.readbegin();
         var _loc2_:int = _socket.readInt();
         var _loc3_:int = _socket.readShort();
         if(_loc3_ == 0 || _loc3_ == 2)
         {
            _loc5_ = _socket.readInt();
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _propArr.push(readGoods());
               _loc6_++;
            }
            if(_loc3_ == 2)
            {
               _loc4_ = {};
               _loc4_.ret = 0;
               _loc4_.uid = _loc2_;
               _loc4_.list = _propArr;
               callUserFun(param1,_loc4_);
               _propArr = [];
            }
         }
      }
      
      private function readGoods() : Array
      {
         var _loc1_:Array = [];
         _loc1_.push(_socket.readInt());
         _loc1_.push(_socket.readInt());
         _loc1_.push(_socket.readInt());
         _loc1_.push(_socket.readInt());
         _loc1_.push(_socket.readString());
         _loc1_.push(_socket.readString());
         _loc1_.push(_socket.readInt());
         _loc1_.push(_socket.readInt());
         _loc1_.push(_socket.readInt());
         _loc1_.push(_socket.readInt());
         _loc1_.push(_socket.readInt());
         _loc1_.push(_socket.readInt());
         _loc1_.push(_socket.readString());
         return _loc1_;
      }
      
      private function getBobyGoods(param1:uint) : void
      {
         var _loc6_:Object = null;
         var _loc2_:Array = null;
         _socket.readbegin();
         var _loc3_:int = _socket.readInt();
         var _loc4_:int = _socket.readShort();
         var _loc5_:Array = [];
         if(_loc4_ == 0)
         {
            _loc5_[0] = true;
            _loc6_ = {};
            _loc5_[1] = _loc6_;
            _loc6_.coat = _socket.readInt();
            _loc6_.shoes = _socket.readInt();
            _loc6_.glasses = _socket.readInt();
            _loc6_.leftring = _socket.readInt();
            _loc6_.rightleft = _socket.readInt();
            _loc6_.necklace = _socket.readInt();
            _loc6_.hat = _socket.readInt();
            _loc6_.glove = _socket.readInt();
            _loc6_.wing = _socket.readInt();
            _loc6_.chatframe = _socket.readInt();
            _loc6_.dbexpcard = _socket.readInt();
            _loc6_.weapon = _socket.readInt();
            _loc6_.weddingring = _socket.readInt();
            _loc5_[2] = [];
            _loc2_ = [];
            _loc2_.push(String(_loc6_.coat));
            _loc2_.push(String(_loc6_.shoes));
            _loc2_.push(String(_loc6_.glasses));
            _loc2_.push(String(_loc6_.leftring));
            _loc2_.push(String(_loc6_.rightleft));
            _loc2_.push(String(_loc6_.necklace));
            _loc2_.push(String(_loc6_.hat));
            _loc2_.push(String(_loc6_.glove));
            _loc2_.push(String(_loc6_.wing));
            _loc2_.push(String(_loc6_.chatframe));
            _loc2_.push(String(_loc6_.dbexpcard));
            _loc2_.push(String(_loc6_.weapon));
            _loc2_.push(String(_loc6_.weddingring));
            _loc5_[3] = _loc2_;
            _loc5_[4] = _socket.readString();
            _loc5_[5] = _loc3_;
         }
         else
         {
            _loc5_[0] = false;
         }
         callUserFun(param1,_loc5_);
      }
      
      private function setMemBody(param1:uint) : void
      {
         var _loc2_:Array = null;
         _socket.readbegin();
         _socket.readInt();
         var _loc3_:int = _socket.readShort();
         trace(_loc3_);
         var _loc4_:Array = [];
         if(_loc3_ == 0)
         {
            _loc4_[0] = true;
            _loc2_ = [];
            _loc2_.push(_socket.readString());
            _loc2_.push(_socket.readInt());
            _loc4_[1] = _loc2_;
            if(_loc2_[1] != 0)
            {
               _loc4_[2] = readGoods();
            }
            callUserFun(param1,_loc4_);
         }
         else
         {
            callUserFun(param1,null);
         }
      }
      
      private function toBuy(param1:uint) : void
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:Object = {};
         _socket.readbegin();
         _socket.readInt();
         var _loc2_:int = _socket.readShort();
         _loc4_.ret = _loc2_;
         _loc4_.data = {};
         if(_loc2_ == 0)
         {
            _loc4_.data.money = {};
            _loc4_.data.money["gameGold"] = _socket.readInt();
            _loc4_.data.money["freeGold"] = _socket.readInt();
            _loc4_.data.money["boyaaCoin"] = _socket.readInt();
            _loc4_.data.money["aucteCoin"] = _socket.readInt();
            _loc4_.data.money["contribute"] = _socket.readInt();
            _loc3_ = _socket.readInt();
            _loc4_.data.goodsAry = [];
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc4_.data.goodsAry.push(readGoods());
               _loc5_++;
            }
         }
         callUserFun(param1,_loc4_);
      }
      
      private function onRenew(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:Object = {};
         _socket.readbegin();
         _socket.readInt();
         _loc3_.ret = _socket.readShort();
         _loc3_.data = {};
         if(_loc3_.ret == 0)
         {
            _loc3_.data.gameGold = _socket.readInt();
            _socket.readInt();
            _loc3_.data.boyaaCoin = _socket.readInt();
            _socket.readInt();
            _socket.readInt();
            _loc2_ = _socket.readInt();
            _loc3_.data.prop = [];
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_.data.prop.push(readGoods());
               _loc4_++;
            }
         }
         else
         {
            _loc3_.ret = 1;
         }
         callUserFun(param1,_loc3_);
      }
      
      private function getServerList(param1:uint) : void
      {
         var _loc6_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Array = [];
         _socket.readbegin();
         _socket.readInt();
         var _loc2_:int = _socket.readInt();
         var _loc3_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < _loc2_)
         {
            _loc4_ = [];
            _loc4_.push(_socket.readInt());
            _loc4_.push(_socket.readInt());
            _loc4_.push(_socket.readString());
            _loc4_.push(_socket.readInt());
            _loc4_.push(_socket.readInt());
            _loc4_.push(_socket.readInt());
            _loc5_.push(_loc4_);
            _loc6_++;
         }
         callUserFun(param1,_loc5_);
      }
      
      private function getServerIDByType(param1:uint) : void
      {
         var _loc2_:Object = {};
         _socket.readbegin();
         _socket.readInt();
         _loc2_.ret = 0;
         _loc2_.svid = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onFriendList(param1:uint) : void
      {
         var _loc5_:Object = null;
         var _loc2_:int = 0;
         var _loc4_:Object = null;
         var _loc6_:int = 0;
         var _loc3_:Array = null;
         if(param1 == 1022)
         {
            _loc5_ = {};
            _loc5_.ret = 0;
            _loc5_.friendsArr = friendsArr;
            _socket.readbegin();
            callUserFun(param1,_loc5_);
            friendsArr.length = 0;
         }
         else
         {
            _socket.readbegin();
            _loc2_ = _socket.readInt();
            trace("count:",_loc2_);
            if(_loc2_ == 0)
            {
               _loc4_ = {};
               _loc4_.ret = 0;
               _loc4_.friendsArr = friendsArr;
               callUserFun(1022,_loc4_);
            }
            _loc6_ = 0;
            while(_loc6_ < _loc2_)
            {
               _loc3_ = [];
               _loc3_.push(_socket.readInt());
               _loc3_.push(_socket.readString());
               _loc3_.push(_socket.readInt());
               _loc3_.push(_socket.readInt());
               _loc3_.push(_socket.readInt());
               friendsArr.push(_loc3_);
               _loc6_++;
            }
         }
      }
      
      private function loginBTSuccessful(param1:uint) : void
      {
         LevelLogger.getLogger("ProcessCmd").info("BattleServer 登录成功");
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.versions = _socket.readString();
         _loc2_.data.exp = _socket.readInt();
         _loc2_.data.btprop = _socket.readString();
         _loc2_.data.goodsStr = _socket.readString();
         trace(_loc2_.data.goodsStr);
         PlayerDataList.instance.selfData.exp = _loc2_.data.exp;
         GoodsList.instance.resetBodyGoods(_loc2_.data.goodsStr);
         if(_loc2_.data.btprop.length > 0)
         {
            GoodsList.instance.setBTPropAndSkill(_loc2_.data.btprop.split("|"));
         }
         _loc2_.data.rank = _socket.readInt();
         PlayerDataList.instance.selfData.ranking = _loc2_.data.rank;
         callUserFun(param1,_loc2_);
      }
      
      private function loginBTFail(param1:uint) : void
      {
         LevelLogger.getLogger("ProcessCmd").info("BattleServer 登录失败");
         var _loc2_:Object = {};
         _loc2_.ret = 1;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.errCode = _socket.readInt();
         callUserFun(1,_loc2_);
      }
      
      private function enterRoom(param1:uint) : void
      {
         var _loc3_:Object = {};
         _loc3_.ret = 0;
         _loc3_.data = {};
         _socket.readbegin();
         _loc3_.data.roomid = _socket.readInt();
         _loc3_.data.siteID = _socket.readInt();
         _loc3_.data.team = _socket.readInt();
         _loc3_.data.isHouseOwner = _socket.readInt();
         _loc3_.data.pk_type = _socket.readInt();
         _loc3_.data.pk_mode = _socket.readInt();
         var _loc2_:int = _socket.readInt();
         _loc3_.data.siteStatusArr = [];
         while(_loc2_ > 0)
         {
            _loc3_.data.siteStatusArr.push(_socket.readInt());
            _loc2_--;
         }
         _loc3_.data.mapID = _socket.readInt();
         _loc3_.data.password = _socket.readString();
         callUserFun(param1,_loc3_);
      }
      
      private function netDelayTest(param1:uint) : void
      {
         _socket.readbegin();
         callUserFun(param1,{});
      }
      
      private function onDelGoods(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _socket.readInt();
         _loc2_.data.flag = _socket.readShort();
         _loc2_.data.only = _socket.readInt();
         _loc2_.data.count = _socket.readShort();
         _loc2_.data.money = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function otherEnterRoom(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.mid = _socket.readInt();
         _loc2_.data.siteID = _socket.readInt();
         _loc2_.data.team = _socket.readInt();
         _loc2_.data.ready = _socket.readInt();
         _loc2_.data.isHouseOwner = _socket.readInt();
         _loc2_.data.charInfo = _socket.readString();
         _loc2_.data.propInfo = _socket.readString();
         _loc2_.data.exp = _socket.readInt();
         _loc2_.data.fail = _socket.readInt();
         _loc2_.data.win = _socket.readInt();
         _loc2_.data.delay = _socket.readInt();
         PlayerDataList.instance.addPlayer(_loc2_.data);
         callUserFun(param1,_loc2_);
      }
      
      private function syncBody(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.siteID = _socket.readInt();
         _loc2_.data.propInfo = _socket.readString();
         callUserFun(param1,_loc2_);
      }
      
      private function allReadyGo(param1:uint) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.mapID = _socket.readInt();
         _loc2_.data.mapURL = _socket.readString();
         _loc2_.data.musicURL = _socket.readString();
         _loc2_.data.mapType = _socket.readInt();
         _loc2_.data.born = [];
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            _loc2_.data.born.push([_socket.readInt(),_socket.readInt()]);
            _loc3_++;
         }
         callUserFun(param1,_loc2_);
      }
      
      private function onMapPROGRESS(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.ret = 0;
         _loc2_.data.siteID = _socket.readInt();
         _loc2_.data.PROGRESS = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onGameStart(param1:uint) : void
      {
         var _loc5_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = {};
         _loc4_.ret = 0;
         _loc4_.data = {};
         _socket.readbegin();
         _loc4_.data.seed = _socket.readInt();
         _loc4_.data.hps = [];
         var _loc2_:int = _socket.readInt();
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            _loc3_ = {};
            _loc3_.siteID = _socket.readInt();
            _loc3_.HP = _socket.readInt();
            _loc4_.data.hps.push(_loc3_);
            _loc5_++;
         }
         callUserFun(param1,_loc4_);
      }
      
      private function otherMove(param1:uint) : void
      {
         var _loc3_:Object = {};
         _loc3_.ret = 0;
         _loc3_.data = {};
         _socket.readbegin();
         var _loc2_:ByteArray = _socket.readBinary() as ByteArray;
         _loc2_.uncompress();
         _loc3_.data.data = _loc2_.readObject() as Array;
         _loc3_.data.siteID = _socket.readInt();
         callUserFun(param1,_loc3_);
      }
      
      private function onSetSender(param1:uint) : void
      {
         var _loc5_:int = 0;
         var _loc2_:Object = null;
         var _loc4_:Object = {};
         _loc4_.ret = 0;
         _loc4_.data = {};
         _socket.readbegin();
         _loc4_.data.siteID = _socket.readInt();
         _loc4_.data.wind = _socket.readInt();
         _loc4_.data.siteData = [];
         var _loc3_:int = _socket.readInt();
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc2_ = {};
            _loc2_.siteID = _socket.readInt();
            _loc2_.HP = _socket.readInt();
            _loc2_.ACTIONPOINT = _socket.readInt();
            _loc4_.data.siteData.push(_loc2_);
            _loc5_++;
         }
         callUserFun(param1,_loc4_);
      }
      
      private function syncAnger(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _socket.readbegin();
         _loc2_.data = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onBombPoint(param1:uint) : void
      {
         var _loc5_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Object = {};
         _loc4_.ret = 0;
         _loc4_.data = {};
         _socket.readbegin();
         _loc4_.data.point_x = _socket.readInt();
         _loc4_.data.point_y = _socket.readInt();
         _loc4_.data.id = _socket.readInt();
         var _loc2_:int = _socket.readInt();
         _loc4_.data.hitArr = [];
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            _loc3_ = [];
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc4_.data.hitArr.push(_loc3_);
            _loc5_++;
         }
         _loc4_.data.senderSiteID = _socket.readInt();
         if(PlayerDataList.instance.selfData.siteID != _loc4_.data.senderSiteID)
         {
            BulletSlottingManager.instance.addBulletData([_loc4_.data.point_x,_loc4_.data.point_y,_loc4_.data.id,_loc4_.data.hitArr],_loc4_.data.senderSiteID);
         }
         callUserFun(param1,_loc4_);
      }
      
      private function onGameOver(param1:uint) : void
      {
         var _loc12_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc11_:Object = {};
         _loc11_.ret = 0;
         _loc11_.data = {};
         _socket.readbegin();
         _loc11_.data.winner = _socket.readInt();
         var _loc5_:int = _socket.readInt();
         _loc11_.data.list = [];
         _loc12_ = 0;
         while(_loc12_ < _loc5_)
         {
            _loc2_ = _socket.readInt();
            _loc3_ = _socket.readInt();
            _loc4_ = _socket.readInt();
            _loc8_ = _socket.readInt();
            _loc9_ = _socket.readInt();
            _loc10_ = _socket.readInt();
            _loc6_ = _socket.readInt();
            _loc7_ = _socket.readInt();
            _loc11_.data.list.push([_loc2_,_loc3_,_loc9_,_loc8_,_loc10_,_loc6_,0,_loc7_,_loc4_]);
            _loc12_++;
         }
         _loc11_.data.isDoubleExp = Boolean(_socket.readInt());
         callUserFun(param1,_loc11_);
      }
      
      private function onPlayerLeave(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onPlayerLeaveInRobotFight(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.siteID = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onChangeHouseOwner(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function on2v2RobotGameStart(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         callUserFun(param1,_loc2_);
      }
      
      private function on2v2RobotTimeOut(param1:uint) : void
      {
         callUserFun(param1,{});
      }
      
      private function onChangeRoomFast(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         callUserFun(param1,_loc2_);
      }
      
      private function onLuckDraw(param1:uint) : void
      {
         var _loc6_:Object = {};
         _loc6_.ret = 0;
         _loc6_.data = {};
         _socket.readbegin();
         _loc6_.data.uid = _socket.readInt();
         _loc6_.data.cardNum = _socket.readInt();
         if(_loc6_.data.cardNum == -1)
         {
            return;
         }
         var _loc5_:int = _socket.readInt();
         var _loc2_:int = _socket.readInt();
         var _loc4_:int = _socket.readInt();
         if(_loc4_ != 0)
         {
            _loc6_.data.prop = [_loc5_,_loc2_];
         }
         _loc6_.data.goldCount = _socket.readInt();
         if(_loc6_.data.uid == PlayerDataList.instance.selfData.uid && _loc6_.data.goldCount > 0)
         {
            AccountData.instance.gameGold += _loc6_.data.goldCount;
         }
         var _loc3_:PlayerData = PlayerDataList.instance.getDataByUID(_loc6_.data.uid);
         if(_loc3_)
         {
            _loc6_.data.uname = _loc3_.babyName;
         }
         callUserFun(param1,_loc6_);
      }
      
      private function onRecv_buy(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.propID = _socket.readInt();
         _loc2_.data.type = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onUseProp(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.type = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onLoadMapOverTime(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.err = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      protected function onChat(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.chat = _socket.readString();
         callUserFun(param1,_loc2_);
      }
      
      protected function onChatToFriend(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.userId = _socket.readInt();
         _loc2_.data.type = _socket.readInt();
         _loc2_.data.str = _socket.readString();
         _loc2_.data.name = _socket.readString();
         callUserFun(param1,_loc2_);
      }
      
      protected function getUnionSpeakerFromServer(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.userId = _socket.readInt();
         _loc2_.data.name = _socket.readString();
         _loc2_.data.str = _socket.readString();
         callUserFun(param1,_loc2_);
      }
      
      protected function onLoudSpeaker(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.userId = _socket.readInt();
         _loc2_.data.type = _socket.readInt();
         _loc2_.data.onlyId = _socket.readInt();
         _loc2_.data.name = _socket.readString();
         _loc2_.data.str = _socket.readString();
         callUserFun(param1,_loc2_);
      }
      
      protected function onEnergyValue(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.userId = _socket.readInt();
         _loc2_.data.type = _socket.readShort();
         _loc2_.data.energy = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      protected function onConsumeEnergy(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.userId = _socket.readInt();
         _loc2_.data.type = _socket.readShort();
         _loc2_.data.energy = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      protected function onBeInvited(param1:int) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.mid = _socket.readInt();
         _loc2_.roomId = _socket.readInt();
         _loc2_.pkType = _socket.readInt();
         _loc2_.serverId = _socket.readInt();
         _loc2_.name = _socket.readString();
         _loc2_.password = _socket.readString();
         callUserFun(param1,_loc2_);
      }
      
      protected function onCopyGameLoginSuccessful(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.ret = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      protected function onCopyGameShowRoomList(param1:int) : void
      {
         var _loc5_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Object = {};
         _loc4_.ret = 0;
         _loc4_.data = [];
         _socket.readbegin();
         var _loc2_:int = _socket.readInt();
         trace("房间列表数量" + _loc2_);
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            _loc3_ = [];
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readString());
            _loc3_.push(_socket.readString());
            _loc3_.push(_socket.readShort());
            _loc3_.push(_socket.readShort());
            _loc3_.push(_socket.readShort());
            _loc4_.data.push(_loc3_);
            RoomListData.instance.addListData(_loc3_);
            _loc5_++;
         }
         callUserFun(param1,_loc4_);
      }
      
      protected function onCopyGameFindRoom(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.flag = _socket.readShort();
         _loc2_.data.roomId = _socket.readInt();
         if(_loc2_.data.flag != 0)
         {
            _loc2_.data.status = _socket.readShort();
            _loc2_.data.maxPlayer = _socket.readShort();
         }
         callUserFun(param1,_loc2_);
      }
      
      protected function onCopyGameCreateRoom(param1:int) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Object = {};
         _loc4_.ret = 0;
         _loc4_.data = {};
         _socket.readbegin();
         _loc4_.data.flag = _socket.readShort();
         if(_loc4_.data.flag == 1)
         {
            _loc4_.data.roomId = _socket.readInt();
            _loc4_.data.roomName = _socket.readString();
            _loc4_.data.size = _socket.readShort();
            _loc4_.data.playerInfo = [];
            _loc2_ = [];
            copyGamePlayerInfo(_loc2_);
            _loc4_.data.playerInfo.push(_loc2_);
         }
         _loc4_.data.siteStatus = _socket.readShort();
         var _loc5_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < _loc4_.data.siteStatus)
         {
            _loc5_.push(_socket.readShort());
            _loc3_++;
         }
         _loc4_.data.siteArr = _loc5_;
         _loc4_.data.diff = _socket.readShort();
         callUserFun(param1,_loc4_);
      }
      
      protected function copyGameChangeClothes(param1:int) : void
      {
         var _loc3_:Object = {};
         _loc3_.ret = 0;
         _loc3_.data = {};
         _socket.readbegin();
         var _loc2_:Array = [];
         _loc2_[0] = _socket.readInt();
         _loc2_[1] = _socket.readShort();
         _loc2_[2] = _socket.readString();
         _loc3_.data.playerInfo = _loc2_;
         callUserFun(param1,_loc3_);
      }
      
      private function copyGamePlayerInfo(param1:Array) : void
      {
         param1.push(_socket.readInt());
         param1.push(_socket.readString());
         param1.push(_socket.readShort());
         param1.push(_socket.readShort());
         param1.push(_socket.readShort());
         param1.push(_socket.readString());
         param1.push(_socket.readShort());
         param1.push(_socket.readString());
         param1.push(_socket.readInt());
         param1.push(_socket.readShort());
         param1.push(_socket.readString());
         param1.push(_socket.readInt());
      }
      
      protected function onCopyGameOtherJoinRoom(param1:int) : void
      {
         var _loc3_:Object = {};
         _loc3_.ret = 0;
         _loc3_.data = {};
         _socket.readbegin();
         var _loc2_:Array = [];
         copyGamePlayerInfo(_loc2_);
         _loc3_.data.playerInfo = _loc2_;
         callUserFun(param1,_loc3_);
      }
      
      protected function onCopyGameJoinRoom(param1:int) : void
      {
         var _loc6_:int = 0;
         var _loc2_:Array = null;
         var _loc5_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Object = {};
         _loc4_.ret = 0;
         _loc4_.data = {};
         _socket.readbegin();
         _loc4_.data.flag = _socket.readShort();
         if(_loc4_.data.flag == 1)
         {
            _loc4_.data.roomId = _socket.readInt();
            _loc4_.data.roomName = _socket.readString();
            _loc4_.data.size = _socket.readShort();
            _loc4_.data.playerInfo = [];
            _loc6_ = 0;
            while(_loc6_ < _loc4_.data.size)
            {
               _loc2_ = [];
               copyGamePlayerInfo(_loc2_);
               _loc4_.data.playerInfo.push(_loc2_);
               _loc6_++;
            }
            _loc4_.data.siteStatus = _socket.readShort();
            _loc5_ = [];
            _loc3_ = 0;
            while(_loc3_ < _loc4_.data.siteStatus)
            {
               _loc5_.push(_socket.readShort());
               _loc3_++;
            }
            _loc4_.data.siteArr = _loc5_;
            _loc4_.data.diff = _socket.readShort();
         }
         callUserFun(param1,_loc4_);
      }
      
      protected function onCopyGameQuickMatch(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.flag = _socket.readShort();
         _loc2_.data.roomId = _socket.readInt();
         if(_loc2_.data.flag == 1)
         {
         }
         callUserFun(param1,_loc2_);
      }
      
      protected function onCopyGameCloseSite(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.flag = _socket.readShort();
         _loc2_.data.site = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      protected function onCopyGamePlayerReady(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.flag = _socket.readShort();
         _loc2_.data.site = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      protected function onCopyGameLeaveRoom(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.flag = _socket.readShort();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.siteId = _socket.readShort();
         _loc2_.data.ownerSite = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      protected function onCopyGameKickPlayer(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.site = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      protected function onCopyGameStart(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:Object = {};
         _loc3_.ret = 0;
         _loc3_.data = {};
         _socket.readbegin();
         _loc3_.data.length = _socket.readShort();
         _loc3_.data.playerInfoArr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.data.length)
         {
            _loc2_ = [];
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readShort());
            _loc2_.push(_socket.readInt());
            _loc3_.data.playerInfoArr.push(_loc2_);
            _loc4_++;
         }
         callUserFun(param1,_loc3_);
      }
      
      protected function onCopyGameMapProgress(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.siteID = _socket.readShort();
         _loc2_.data.ratio = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      protected function onCopyGameBorn(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc3_:Array = null;
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.length = _socket.readShort();
         _loc2_.data.arr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc2_.data.length)
         {
            _loc3_ = [];
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc2_.data.arr.push(_loc3_);
            _loc4_++;
         }
         callUserFun(param1,_loc2_);
      }
      
      protected function onCopyGameBossBorning(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc3_:Array = null;
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.length = _socket.readShort();
         _loc2_.data.arr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc2_.data.length)
         {
            _loc3_ = [];
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc2_.data.arr.push(_loc3_);
            _loc4_++;
         }
         callUserFun(param1,_loc2_);
      }
      
      protected function onCopyGameShooter(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.prevSiteId = _socket.readShort();
         _loc2_.data.siteId = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      protected function onCopyGameFightBoss(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         callUserFun(param1,_loc2_);
      }
      
      private function onCopyGamePlayerShowComplete(param1:uint) : void
      {
      }
      
      private function onCopyGamePlayerStatus(param1:uint) : void
      {
      }
      
      private function onCopyGamePlayerMove(param1:uint) : void
      {
         var _loc3_:Object = {};
         _loc3_.ret = 0;
         _loc3_.data = {};
         _socket.readbegin();
         var _loc2_:ByteArray = _socket.readBinary() as ByteArray;
         _loc2_.uncompress();
         _loc3_.data.data = _loc2_.readObject() as Array;
         _loc3_.data.uid = _socket.readInt();
         _loc3_.data.siteID = _socket.readShort();
         callUserFun(param1,_loc3_);
      }
      
      private function onCopyGamePlayerGiveUp(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.siteId = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      private function onCopyGamePlayerExit(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.siteId = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      private function onCopyGamePlayerTimeOut(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.siteId = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      private function onCopyGameUseProp(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.siteID = _socket.readShort();
         _loc2_.data.type = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      private function onCopyGameBombPoint(param1:uint) : void
      {
         var _loc5_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Object = {};
         _loc4_.ret = 0;
         _loc4_.data = {};
         _socket.readbegin();
         _loc4_.data.point_x = _socket.readInt();
         _loc4_.data.point_y = _socket.readInt();
         _loc4_.data.id = _socket.readInt();
         var _loc2_:int = _socket.readInt();
         _loc4_.data.hitArr = [];
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            _loc3_ = [];
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readShort());
            _loc4_.data.hitArr.push(_loc3_);
            _loc5_++;
         }
         _loc4_.data.senderSiteID = _socket.readShort();
         callUserFun(param1,_loc4_);
      }
      
      private function onCopyGameBossAttack(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.siteId = _socket.readShort();
         _loc2_.data.skill = _socket.readShort();
         _loc2_.data.dropHp = _socket.readInt();
         _loc2_.data.isPow = _socket.readInt();
         _loc2_.data.status = _socket.readShort();
         _loc2_.data.cpid = _socket.readShort();
         switch(_loc2_.data.cpid)
         {
            case 2:
               zhunHuangAttackData(_loc2_);
               break;
            case 3:
               leienAttackData(_loc2_);
         }
         callUserFun(param1,_loc2_);
      }
      
      private function leienAttackData(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:Array = null;
         var _loc2_:Array = [];
         param1.data.bossPos = [];
         param1.data.bossPos[0] = _socket.readInt();
         param1.data.bossPos[1] = _socket.readInt();
         switch(param1.data.skill)
         {
            case 0:
               break;
            case 1:
               _loc4_ = _socket.readShort();
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc3_ = [];
                  _loc3_.push(_socket.readShort());
                  _loc3_.push(_socket.readInt());
                  _loc3_.push(_socket.readInt());
                  _loc2_.push(_loc3_);
                  _loc5_++;
               }
               param1.data.playerHitArr = [];
               param1.data.playerHitArr = _loc2_;
               break;
            case 2:
               param1.data.newPos = [];
               param1.data.newPos[0] = _socket.readInt();
               param1.data.newPos[1] = _socket.readInt();
         }
      }
      
      private function zhunHuangAttackData(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:Array = null;
         var _loc2_:Array = [];
         switch(param1.data.skill)
         {
            case 0:
               param1.data.monsterArr = [];
               _loc4_ = _socket.readShort();
               param1.data.length = _loc4_;
               _loc6_ = 0;
               while(_loc6_ < _loc4_)
               {
                  _loc2_[_loc6_] = _socket.readShort();
                  _loc6_++;
               }
               param1.data.posX = _socket.readInt();
               param1.data.monsterArr = _loc2_;
               break;
            case 1:
            case 3:
               break;
            case 2:
            case 4:
            case 7:
               _loc4_ = _socket.readShort();
               param1.data.length = _loc4_;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc3_ = [];
                  _loc3_.push(_socket.readShort());
                  _loc3_.push(_socket.readInt());
                  _loc3_.push(_socket.readInt());
                  _loc2_.push(_loc3_);
                  _loc5_++;
               }
               param1.data.playerHitArr = [];
               param1.data.playerHitArr = _loc2_;
               break;
            case 5:
            case 6:
         }
      }
      
      private function onCopyGameMonsterCount(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.count = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      private function onCopyGameBackToRoom(param1:int) : void
      {
         var _loc6_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Object = {};
         _loc4_.ret = 0;
         _loc4_.data = {};
         _socket.readbegin();
         _loc4_.data.flag = _socket.readShort();
         _loc4_.data.size = _socket.readShort();
         _loc4_.data.playerInfo = [];
         _loc6_ = 0;
         while(_loc6_ < _loc4_.data.size)
         {
            _loc2_ = [];
            copyGamePlayerInfo(_loc2_);
            _loc4_.data.playerInfo.push(_loc2_);
            _loc6_++;
         }
         _loc4_.data.siteStatus = _socket.readShort();
         var _loc5_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < _loc4_.data.siteStatus)
         {
            _loc5_.push(_socket.readShort());
            _loc3_++;
         }
         _loc4_.data.siteArr = _loc5_;
         callUserFun(param1,_loc4_);
      }
      
      private function onCopyGameUseEnergy(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.siteId = _socket.readShort();
         _loc2_.data.energy = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onCopyGameMonsterShooterAttack(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.siteId = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      private function onCopyGameReliveInBossRoom(param1:int) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.flag = _socket.readInt();
         _loc2_.data.boyaaCoin = _socket.readInt();
         _loc2_.data.x = _socket.readInt();
         _loc2_.data.y = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onCopyGamePublicRelive(param1:int) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.siteID = _socket.readInt();
         _loc2_.data.x = _socket.readInt();
         _loc2_.data.y = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onCopyGameReliveInNormal(param1:int) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.flag = _socket.readInt();
         _loc2_.data.boyaaCoin = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onCopyGameTurn(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.currentCtrl = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      private function onCopyGamePlayerDead(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.siteId = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      private function onCopyGameMonsterAttack(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.attackSite = _socket.readShort();
         _loc2_.data.siteId = _socket.readShort();
         _loc2_.data.dropHp = _socket.readInt();
         _loc2_.data.isPow = _socket.readShort();
         callUserFun(param1,_loc2_);
      }
      
      private function onCopyGameGameOver(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.flag = _socket.readShort();
         _loc2_.data.winExp = _socket.readInt();
         _loc2_.data.vipExp = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onRankTop50Player(param1:uint) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:Object = {};
         _loc3_.ret = 0;
         _loc3_.data = {};
         _socket.readbegin();
         _loc3_.data.size = _socket.readInt();
         _loc3_.data.playerArr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.data.size)
         {
            _loc2_ = [];
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readString());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc3_.data.playerArr.push(_loc2_);
            _loc4_++;
         }
         _loc3_.data.selfData = {};
         _loc3_.data.selfData.rank = _socket.readInt();
         _loc3_.data.selfData.fightNum = _socket.readInt();
         _loc3_.data.selfData.vipLevel = _socket.readInt();
         callUserFun(param1,_loc3_);
      }
      
      private function onRank50PlayerArrowMe(param1:uint) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:Object = {};
         _loc3_.ret = 0;
         _loc3_.data = {};
         _socket.readbegin();
         _loc3_.data.size = _socket.readInt();
         _loc3_.data.playerArr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.data.size)
         {
            _loc2_ = [];
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readString());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc3_.data.playerArr.push(_loc2_);
            _loc4_++;
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onRankFightCount(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.canFightCount = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function getFormatRetData() : Object
      {
         var _loc1_:Object = {};
         _loc1_.ret = 0;
         _loc1_.data = {};
         return _loc1_;
      }
      
      private function onRankFightResult(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.win = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onGetRankReward(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.done = _socket.readInt();
         _loc2_.data.pcate = _socket.readInt();
         _loc2_.data.pframe = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onRankFightHistory(param1:uint) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:Object = getFormatRetData();
         _socket.readbegin();
         _loc3_.data.size = _socket.readInt();
         _loc3_.data.playerArr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.data.size)
         {
            _loc2_ = [];
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readString());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc3_.data.playerArr.push(_loc2_);
            _loc4_++;
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onGetRankPlayerEquip(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.mid = _socket.readInt();
         _loc2_.data.siteID = 2;
         _loc2_.data.team = 1;
         _loc2_.data.ready = 1;
         _loc2_.data.isHouseOwner = 0;
         _loc2_.data.charInfo = _socket.readString();
         _loc2_.data.propInfo = _socket.readString();
         _loc2_.data.exp = _socket.readInt();
         _loc2_.data.fail = _socket.readInt();
         _loc2_.data.win = _socket.readInt();
         _loc2_.data.babySex = _socket.readInt();
         _loc2_.data.delay = 0;
         callUserFun(param1,_loc2_);
      }
      
      private function onEndlessGetData(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.currentLevel = _socket.readInt();
         _loc2_.data.peakLevel = _socket.readInt();
         _loc2_.data.challengeTime = _socket.readInt();
         _loc2_.data.vipTime = _socket.readInt();
         _loc2_.data.nextGiftLevel = _socket.readInt();
         _loc2_.data.gift_pcate = _socket.readInt();
         _loc2_.data.gift_pframe = _socket.readInt();
         _loc2_.data.reliveCost = _socket.readInt();
         _loc2_.data.flyLevelCost = _socket.readInt();
         _loc2_.data.challengeCost = _socket.readInt();
         _loc2_.data.vipLevel = _socket.readInt();
         _loc2_.data.freeRelive = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onEndlessGetMonsters(param1:uint) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:Object = getFormatRetData();
         _socket.readbegin();
         _loc3_.data.challenge_level = _socket.readInt();
         _loc3_.data.gift_level = _socket.readInt();
         _loc3_.data.gift_pcate = _socket.readInt();
         _loc3_.data.gift_pframe = _socket.readInt();
         _loc3_.data.monsterCount = _socket.readInt();
         _loc3_.data.monsterArr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.data.monsterCount)
         {
            _loc2_ = [];
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc3_.data.monsterArr.push(_loc2_);
            _loc4_++;
         }
         _loc3_.randNum = _socket.readInt();
         callUserFun(param1,_loc3_);
      }
      
      private function onEndlessNextLevel(param1:uint) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:Object = getFormatRetData();
         _socket.readbegin();
         _loc3_.data.flag = _socket.readInt();
         _loc3_.data.challenge_level = _socket.readInt();
         if(_loc3_.data.flag == 0)
         {
            _loc3_.data.gift_level = _socket.readInt();
            _loc3_.data.gift_pcate = _socket.readInt();
            _loc3_.data.gift_pframe = _socket.readInt();
            _loc3_.data.monsterCount = _socket.readInt();
            _loc3_.data.monsterArr = [];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.data.monsterCount)
            {
               _loc2_ = [];
               _loc2_.push(_socket.readInt());
               _loc2_.push(_socket.readInt());
               _loc2_.push(_socket.readInt());
               _loc2_.push(_socket.readInt());
               _loc2_.push(_socket.readInt());
               _loc2_.push(_socket.readInt());
               _loc2_.push(_socket.readInt());
               _loc2_.push(_socket.readInt());
               _loc3_.data.monsterArr.push(_loc2_);
               _loc4_++;
            }
            _loc3_.randNum = _socket.readInt();
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onEndlessRelive(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.flag = _socket.readInt();
         _loc2_.data.coin = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onEndlessFlyToTop(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.flag = _socket.readInt();
         if(_loc2_.data.flag == 0)
         {
            _loc2_.data.currentLevel = _socket.readInt();
            _loc2_.data.coin = _socket.readInt();
            _loc2_.data.giftLevel = _socket.readInt();
         }
         callUserFun(param1,_loc2_);
      }
      
      private function onEndlessRankList(param1:uint) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Array = null;
         _socket.readbegin();
         var _loc3_:Object = getFormatRetData();
         _loc3_.data.count = _socket.readInt();
         _loc3_.data.playerArr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.data.count)
         {
            _loc2_ = [];
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readString());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc3_.data.playerArr.push(_loc2_);
            _loc4_++;
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onEndlessBuyTime(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.flag = _socket.readInt();
         _loc2_.data.challenge = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      protected function getLoudSpeakerFromServer(param1:uint) : void
      {
         var _loc4_:Object = {};
         _loc4_.ret = 0;
         _loc4_.data = {};
         _socket.readbegin();
         var _loc3_:Array = [];
         var _loc2_:String = "";
         _loc4_.data.type = _socket.readInt();
         switch(_loc4_.data.type)
         {
            case 1:
               _loc4_.data.name = _socket.readString();
               _loc2_ = _socket.readString();
               _loc3_ = _loc2_.split("|");
               _loc4_.data.typeID = int(_loc3_[0]);
               _loc4_.data.frameID = int(_loc3_[1]);
               _loc4_.data.propName = ShopDataList.instance.getSingleData(_loc4_.data.typeID,_loc4_.data.frameID).name;
               _loc4_.data.place = _socket.readString();
               switch(_loc4_.data.place)
               {
                  case "1":
                     _loc4_.data.place = LangManager.t("luckTurn");
                     break;
                  case "2":
                     _loc4_.data.place = LangManager.t("fightMode")[0];
                     break;
                  case "3":
                     _loc4_.data.place = LangManager.t("fightMode")[1];
                     break;
                  case "4":
                     _loc4_.data.place = LangManager.t("fightMode")[2];
                     break;
                  case "5":
                     _loc4_.data.place = LangManager.t("fightMode")[3];
                     break;
                  case "6":
                     _loc4_.data.place = LangManager.t("cjhd");
               }
               _loc4_.data.mid = _socket.readInt();
               break;
            case 2:
               _loc2_ = _socket.readString();
               _loc4_.data.arr = _loc3_;
               _loc4_.data.firstCopyKill = _socket.readInt();
               _loc4_.data.copyID = _socket.readInt();
               _loc4_.data.copyDif = _socket.readInt();
               _loc4_.data.unionName = _socket.readString();
               break;
            case 3:
               _loc4_.data.name = _socket.readString();
               _loc4_.data.ranking = _socket.readInt();
               _loc4_.data.mid = _socket.readInt();
               break;
            case 4:
               _loc4_.data.name = _socket.readString();
               _loc2_ = _socket.readString();
               _loc3_ = _loc2_.split("|");
               _loc4_.data.typeID = int(_loc3_[0]);
               _loc4_.data.frameID = int(_loc3_[1]);
               _loc4_.data.propName = ShopDataList.instance.getSingleData(_loc4_.data.typeID,_loc4_.data.frameID).name;
               _loc4_.data.level = _socket.readInt();
               _loc4_.data.min = _socket.readInt();
               break;
            case 5:
               _loc4_.data.name = _socket.readString();
               _loc2_ = _socket.readString();
               _loc3_ = _loc2_.split("|");
               _loc4_.data.typeID = int(_loc3_[0]);
               _loc4_.data.frameID = int(_loc3_[1]);
               _loc4_.data.propName = ShopDataList.instance.getSingleData(_loc4_.data.typeID,_loc4_.data.frameID).name;
               _loc4_.data.level = _socket.readInt();
               _loc4_.data.mid = _socket.readInt();
               break;
            case 6:
               _loc4_.data.str = _socket.readString();
               break;
            case 7:
               _loc2_ = _socket.readString();
               _loc3_ = _loc2_.split("|");
               switch(_loc3_[0])
               {
                  case "1":
                     _loc2_ = LangManager.getLang.getreplaceLang("upStorageInfo",_loc3_[1],int(_loc3_[2]));
                     break;
                  case "2":
                     _loc2_ = LangManager.getLang.getreplaceLang("welcomeJoinUnion",_loc3_[1]);
                     break;
                  case "3":
                     _loc2_ = LangManager.getLang.getreplaceLang("uplevelUnionPeople",_loc3_[1],int(_loc3_[2]));
                     break;
                  case "4":
                     _loc2_ = LangManager.getLang.getreplaceLang("assignUnionMember",_loc3_[1],_loc3_[2],_loc3_[3]);
                     break;
                  case "5":
                     _loc2_ = LangManager.getLang.getreplaceLang("appointVicechairmanInfo",_loc3_[1],_loc3_[2]);
                     break;
                  case "6":
                     _loc2_ = LangManager.getLang.getreplaceLang("welcomeJoinUnion",_loc3_[1]);
                     break;
                  case "7":
                     _loc2_ = LangManager.getLang.getreplaceLang("armShopUplevelInfo",_loc3_[1],int(_loc3_[2]));
                     break;
                  case "8":
                     _loc2_ = LangManager.getLang.getreplaceLang("uplevelUnionShopOK",_loc3_[1]);
               }
               _loc4_.data.str = _loc2_;
               break;
            case 8:
               _loc4_.data.name = _socket.readString();
               _loc4_.data.mid = _socket.readInt();
               _loc4_.data.multi = _socket.readByte();
               _loc4_.data.actName = _socket.readString();
               break;
            case 9:
               _loc4_.data.name = _socket.readString();
               _loc2_ = _socket.readString();
               _loc3_ = _loc2_.split("|");
               _loc4_.data.typeID = int(_loc3_[0]);
               _loc4_.data.frameID = int(_loc3_[1]);
               _loc4_.data.propName = ShopDataList.instance.getSingleData(_loc4_.data.typeID,_loc4_.data.frameID).name;
               break;
            case 10:
               _loc2_ = _socket.readString();
               _loc3_ = _loc2_.split("|");
               _loc4_.data.typeID = int(_loc3_[0]);
               _loc4_.data.frameID = int(_loc3_[1]);
               _loc4_.data.propName = ShopDataList.instance.getSingleData(_loc4_.data.typeID,_loc4_.data.frameID).name;
               break;
            case 11:
               _loc2_ = _socket.readString();
               _loc3_ = _loc2_.split("|");
               _loc4_.data.typeID = int(_loc3_[0]);
               _loc4_.data.frameID = int(_loc3_[1]);
               _loc4_.data.propName = ShopDataList.instance.getSingleData(_loc4_.data.typeID,_loc4_.data.frameID).name;
               break;
            case 12:
               _loc4_.data.name = _socket.readString();
               _loc2_ = _socket.readString();
               _loc3_ = _loc2_.split("|");
               _loc4_.data.typeID = int(_loc3_[0]);
               _loc4_.data.frameID = int(_loc3_[1]);
               _loc4_.data.propName = ShopDataList.instance.getSingleData(_loc4_.data.typeID,_loc4_.data.frameID).name;
         }
         callUserFun(param1,_loc4_);
      }
      
      protected function onExpression(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.type = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onRobotCome(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _loc2_.data = {};
         _socket.readbegin();
         _loc2_.data.mid = _socket.readInt();
         _loc2_.data.siteID = _socket.readInt();
         _loc2_.data.team = _socket.readInt();
         _loc2_.data.ready = _socket.readInt();
         _loc2_.data.isHouseOwner = _socket.readInt();
         _loc2_.data.charInfo = _socket.readString();
         _loc2_.data.propInfo = _socket.readString();
         _loc2_.data.exp = _socket.readInt();
         _loc2_.data.fail = _socket.readInt();
         _loc2_.data.win = 0;
         _loc2_.data.delay = 0;
         callUserFun(param1,_loc2_);
      }
      
      private function onStartRobot(param1:uint) : void
      {
         var _loc5_:int = 0;
         var _loc4_:Object = {};
         _loc4_.ret = 0;
         _loc4_.data = {};
         _socket.readbegin();
         _loc4_.data.mapID = _socket.readInt();
         _loc4_.data.mapURL = _socket.readString();
         _loc4_.data.musicURL = _socket.readString();
         _loc4_.data.mapType = _socket.readInt();
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < 4)
         {
            _loc3_ = [];
            _loc3_[0] = _socket.readInt();
            _loc3_[1] = _socket.readInt();
            _loc2_.push(_loc3_);
            _loc5_++;
         }
         _loc4_.data.born = _loc2_;
         callUserFun(param1,_loc4_);
      }
      
      private function addLuckydrawGood(param1:uint) : void
      {
         var _loc3_:Object = {};
         _loc3_.ret = 0;
         _socket.readbegin();
         var _loc2_:Array = [];
         _loc2_.push(_socket.readInt());
         _loc2_.push(_socket.readInt());
         _loc2_.push(_socket.readInt());
         _loc2_.push(_socket.readInt());
         _loc2_.push(_socket.readString());
         _loc2_.push(_socket.readString());
         _loc2_.push(_socket.readInt());
         _loc2_.push(_socket.readInt());
         _loc2_.push(_socket.readInt());
         _loc2_.push(_socket.readInt());
         _loc2_.push(_socket.readInt());
         _loc2_.push(_socket.readInt());
         _loc2_.push(_socket.readString());
         GoodsList.instance.addGoodsByStr(_loc2_);
         callUserFun(param1,_loc3_);
      }
      
      private function onPlayerReady(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.siteID = _socket.readInt();
         _loc2_.data.ready = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onChangeRoomError(param1:uint) : void
      {
         callUserFun(param1,{});
      }
      
      private function onPlayerDropDeadInBT(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.uid = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onFightDataInRobot(param1:uint) : void
      {
         var _loc4_:Object = getFormatRetData();
         _socket.readbegin();
         var _loc3_:ByteArray = _socket.readBinary() as ByteArray;
         _loc3_.uncompress();
         var _loc2_:Array = _loc3_.readObject() as Array;
         _loc4_.data.action = _loc2_[0];
         _loc4_.data.fightData = _loc2_[1];
         _loc4_.data.siteID = _loc2_[2];
         _loc4_.data.arr = [];
         _loc4_.data.arr = _loc2_;
         callUserFun(param1,_loc4_);
      }
      
      private function addGood(param1:uint) : void
      {
         var _loc4_:int = 0;
         var _loc3_:Array = null;
         _socket.readbegin();
         _socket.readInt();
         _socket.readShort();
         var _loc2_:int = _socket.readInt();
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = [];
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readString());
            _loc3_.push(_socket.readString());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readInt());
            _loc3_.push(_socket.readString());
            GoodsList.instance.addGoodsByStr(_loc3_);
            _loc4_++;
         }
      }
      
      private function onServerBusy(param1:uint) : void
      {
         new Tiptext("Server is busy now!");
         Application.instance.currentGame.logout();
      }
      
      private function onStrenthen(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.ret = 0;
         _socket.readbegin();
         _socket.readInt();
         if(_socket.readShort() != 1)
         {
            _loc2_.ret = 1;
         }
         else
         {
            _loc2_.onlyId = _socket.readInt();
            _loc2_.synthesis = _socket.readString();
            _loc2_.exp = _socket.readShort();
         }
         callUserFun(param1,_loc2_);
      }
      
      private function onTransfer(param1:uint) : void
      {
         var _loc3_:Object = {};
         _loc3_.ret = 0;
         _socket.readbegin();
         _socket.readInt();
         var _loc2_:int = _socket.readShort();
         if(_loc2_ <= 0)
         {
            _loc3_.ret = 1;
         }
         else if(_loc2_ == 2)
         {
            _loc3_.ret = 2;
         }
         else
         {
            _loc3_.fromOnlyId = _socket.readInt();
            _loc3_.fromSynthesis = _socket.readString();
            _loc3_.toOnlyId = _socket.readInt();
            _loc3_.toSynthesis = _socket.readString();
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onUseGoods(param1:uint) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc6_:GoodsData = null;
         var _loc5_:int = 0;
         var _loc8_:GoodsData = null;
         var _loc7_:Array = null;
         var _loc9_:Object = {};
         _loc9_.ret = 0;
         _socket.readbegin();
         _socket.readInt();
         var _loc10_:int = 0;
         var _loc3_:int = _socket.readShort();
         trace("flag:",_loc3_);
         if(_loc3_ != 1)
         {
            _loc9_.ret = 1;
         }
         else
         {
            _loc4_ = _socket.readInt();
            _loc2_ = _socket.readShort();
            _loc6_ = GoodsList.instance.getGoodsByOnlyID(_loc4_);
            _loc5_ = 0;
            if(_loc6_.typeID == 26)
            {
               _loc5_ = _socket.readInt();
               AccountData.instance.gameGold += _loc5_;
               _loc9_.gameGold = _loc5_;
            }
            else if(_loc6_.typeID == 25 || _loc6_.typeID == 36)
            {
               _loc9_.prop = [];
               _loc5_ = _socket.readShort();
               _loc10_ = 0;
               while(_loc10_ < _loc5_)
               {
                  _loc7_ = readGoods();
                  _loc8_ = GoodsList.instance.addGoodsByStr(_loc7_);
                  _loc9_.prop.push(_loc8_);
                  _loc10_++;
               }
            }
            else if(_loc6_.typeID == 42)
            {
               if(_loc2_ > 60)
               {
                  _loc5_ = 60 - PlayerDataList.instance.selfData.energy;
               }
               else
               {
                  _loc5_ = _loc2_ - PlayerDataList.instance.selfData.energy;
               }
               _loc9_.energy = _loc5_;
               PlayerDataList.instance.selfData.energy += _loc5_;
            }
            GoodsList.instance.removeGoodsByOnlyID(_loc4_);
         }
         callUserFun(param1,_loc9_);
      }
      
      private function updateBagItems(param1:uint) : void
      {
         var _loc4_:int = 0;
         var _loc3_:Array = null;
         _socket.readbegin();
         _socket.readInt();
         var _loc2_:int = _socket.readInt();
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = readGoods();
            GoodsList.instance.addGoodsByStr(_loc3_);
            _loc4_++;
         }
      }
      
      private function onSendMailDone(param1:uint) : void
      {
         _socket.readbegin();
         _socket.readInt();
         var _loc2_:int = _socket.readInt();
         switch(_loc2_)
         {
            case 0:
               TextTip.instance.showByLang("sendMailTipError_0");
               AccountData.instance.gameGold -= 200;
               break;
            case 1:
               TextTip.instance.showByLang("sendMailTipError_2");
               trace("附件数量不合法,1到4个");
               break;
            case 2:
               trace("不够金币");
               TextTip.instance.showByLang("sendMailTipError_3");
               break;
            case 3:
               trace("不是好友");
               TextTip.instance.showByLang("sendMailTipError_4");
         }
      }
      
      private function onReadMailDone(param1:uint) : void
      {
         var _loc6_:int = 0;
         _socket.readbegin();
         _socket.readInt();
         var _loc3_:String = _socket.readString();
         var _loc5_:int = _socket.readInt();
         var _loc4_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_.push({
               "pid":_socket.readInt(),
               "pcate":_socket.readInt(),
               "pframe":_socket.readInt()
            });
            _loc6_++;
         }
         var _loc2_:Object = {
            "content":_loc3_,
            "files":_loc4_
         };
         callUserFun(param1,_loc2_);
      }
      
      private function onGetMailListDone(param1:uint) : void
      {
         var _loc5_:int = 0;
         var _loc2_:Object = null;
         _socket.readbegin();
         _socket.readInt();
         var _loc4_:int = _socket.readInt();
         var _loc3_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = {};
            _loc2_.mail_id = _socket.readInt();
            _loc2_.from_mid = _socket.readInt();
            _loc2_.from_name = _socket.readString();
            _loc2_.title = _socket.readString();
            _loc2_.send_timestamp = _socket.readInt();
            _loc2_.file = _socket.readInt();
            _loc3_.push(_loc2_);
            _loc5_++;
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onGetMailFileDone(param1:uint) : void
      {
         _socket.readbegin();
         _socket.readInt();
         var _loc2_:int = _socket.readInt();
         switch(_loc2_)
         {
            case 0:
               TextTip.instance.showByLang("sendMailTipError_0");
               trace("成功");
               break;
            default:
               TextTip.instance.showByLang("sendMailTipError_100");
         }
      }
      
      private function onNewMailCome(param1:uint) : void
      {
         _socket.readbegin();
         var _loc3_:int = _socket.readInt();
         var _loc2_:int = _socket.readInt();
         var _loc4_:String = _socket.readString();
         Application.instance.currentGame.mainMenu.mailBtnHighLight(true);
      }
      
      private function onDelMailDone(param1:uint) : void
      {
         _socket.readbegin();
         _socket.readInt();
         var _loc2_:int = _socket.readInt();
         switch(_loc2_)
         {
            case 0:
               TextTip.instance.showByLang("sendMailTipError_0");
               trace("成功");
               break;
            default:
               TextTip.instance.showByLang("sendMailTipError_100");
         }
      }
      
      private function onWeddingReceivePopMarry(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.time = _socket.readInt();
         _loc2_.data.word = _socket.readString();
         callUserFun(param1,_loc2_);
      }
      
      private function onWeddingMarrySendIsDone(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.replyCode = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onWeddingPopAnswer(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.uid = _socket.readInt();
         _loc2_.data.replyCode = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onWeddingEnterMsg(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.mid = _socket.readInt();
         _loc2_.data.omid = _socket.readInt();
         _loc2_.data.weddingType = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onWeddingSendDivorceMsgIsDone(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.mid = _socket.readInt();
         _loc2_.data.replycode = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onWeddingDivorceMsgReceive(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.mid = _socket.readInt();
         _loc2_.data.word = _socket.readString();
         callUserFun(param1,_loc2_);
      }
      
      private function onWeddingDivorceMsgAnswer(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.mid = _socket.readInt();
         _loc2_.data.replyCode = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onWeddingPushMarryMsg(param1:uint) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Object = null;
         _socket.readbegin();
         var _loc3_:Object = getFormatRetData();
         _loc3_.data.count = _socket.readInt();
         _loc3_.data.marryArr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.data.count)
         {
            _loc2_ = {};
            _loc2_.uid = _socket.readInt();
            _loc2_.time = _socket.readInt();
            _loc2_.word = _socket.readString();
            _loc3_.data.marryArr.push(_loc2_);
            _loc4_++;
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onWeddingMarryBack(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.mid = _socket.readInt();
         _loc2_.data.replyCode = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onWeddingMarryState(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.omid = _socket.readInt();
         _loc2_.data.state = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onWeddingExchangeRing(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.mid = _socket.readInt();
         _loc2_.data.isSuccess = _socket.readShort();
         if(_loc2_.data.isSuccess == 1)
         {
            _loc2_.data.value = _socket.readInt();
            _loc2_.data.goods = GoodsList.instance.addGoodsByStr(readGoods());
         }
         callUserFun(param1,_loc2_);
      }
      
      private function onUnionFightState(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.reason = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onUnionFightGameStart(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.id = _socket.readInt();
         _loc2_.data.sex = _socket.readInt();
         _loc2_.data.level = _socket.readInt();
         _loc2_.data.energy = _socket.readInt();
         _loc2_.data.exp = _socket.readInt();
         _loc2_.data.name = _socket.readString();
         _loc2_.data.appearance = _socket.readString();
         _loc2_.data.equipInfo = _socket.readString();
         _loc2_.data.charInfo = _socket.readString();
         _loc2_.data.bossType = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onUnionFightSwitch(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.ctrl = _socket.readInt();
         _loc2_.data.bossHp = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onUnionFightUseProp(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.flag = _socket.readInt();
         _loc2_.data.propId = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onUnionFightBossAttack(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.lossHp = _socket.readInt();
         _loc2_.data.currentHp = _socket.readInt();
         _loc2_.data.isPow = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onUnionFightBombPoint(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.bulletId = _socket.readInt();
         _loc2_.data.isHit = _socket.readInt();
         _loc2_.data.isPow = _socket.readInt();
         _loc2_.data.lossHp = _socket.readInt();
         _loc2_.data.currentHp = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onUnionFightTimeOver(param1:uint) : void
      {
         _socket.readbegin();
         callUserFun(param1,{});
      }
      
      private function onUnionFightBossDead(param1:uint) : void
      {
         onUnionFightTimeOver(param1);
      }
      
      private function onUnionFightGetRank(param1:uint) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Array = null;
         _socket.readbegin();
         var _loc3_:Object = getFormatRetData();
         _loc3_.data.length = _socket.readInt();
         _loc3_.data.unionArr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.data.length)
         {
            _loc2_ = [];
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readString());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_loc4_ + 1);
            _loc3_.data.unionArr.push(_loc2_);
            _loc4_++;
         }
         _loc3_.data.isRank = _socket.readInt();
         if(_loc3_.data.isRank)
         {
            _loc3_.data.rankNum = _socket.readInt();
            _loc3_.data.isReward = _socket.readInt();
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onUnionFightInfo(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.flag = _socket.readInt();
         if(_loc2_.data.flag)
         {
            _loc2_.data.fighting = _socket.readInt();
            _loc2_.data.startTime = _socket.readInt();
            _loc2_.data.endTime = _socket.readInt();
            _loc2_.data.bossId = _socket.readInt();
            _loc2_.data.roleId = _socket.readInt();
            _loc2_.data.mapId = _socket.readInt();
            _loc2_.data.bossType = _socket.readInt();
            _loc2_.data.serverTime = _socket.readInt();
            _loc2_.data.bossHp = _socket.readInt();
         }
         callUserFun(param1,_loc2_);
      }
      
      private function onUnionFightDevoteMsg(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.hp = _socket.readInt();
         _loc2_.data.devote = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onUnionFightGetReward(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.flag = _socket.readInt();
         if(_loc2_.data.flag != 1)
         {
            _loc2_.data.devote = _socket.readInt();
         }
         callUserFun(param1,_loc2_);
      }
      
      private function onRankActLevelData(param1:uint) : void
      {
         var _loc7_:int = 0;
         var _loc2_:Array = null;
         var _loc5_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         _socket.readbegin();
         var _loc6_:Object = getFormatRetData();
         _loc6_.data.count = _socket.readInt();
         _loc6_.data.dataArr = [];
         _loc7_ = 0;
         while(_loc7_ < _loc6_.data.count)
         {
            _loc2_ = [];
            _loc5_ = _socket.readInt();
            _loc3_ = _socket.readString();
            _loc4_ = _socket.readInt();
            _loc2_.push(_loc7_ + 1);
            _loc2_.push(_loc3_);
            _loc2_.push(_loc4_);
            _loc2_.push(_loc5_);
            _loc6_.data.dataArr.push(_loc2_);
            _loc7_++;
         }
         callUserFun(param1,_loc6_);
      }
      
      private function onRankActFightData(param1:uint) : void
      {
         onRankActLevelData(param1);
      }
      
      private function onBTFingRoomError(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.ret = _socket.readInt();
         switch(_loc2_.data.ret)
         {
            case 1:
               TextTip.instance.showByLang("net_gamestart");
               break;
            case 2:
               TextTip.instance.showByLang("net_roomfull");
               break;
            case 4:
               TextTip.instance.showByLang("passwordWrong");
               break;
            case 7:
               TextTip.instance.showByLang("passwordWrong");
         }
         Application.instance.currentGame.hiddenLoading();
         Application.instance.log("查找房间错误","error type:" + _loc2_.data.ret);
         if(PlayerDataList.instance.selfData.inFight)
         {
            Application.instance.currentGame.navigator.showScreen("SHOW_BT_HALL");
         }
         callUserFun(param1,_loc2_);
      }
      
      private function onBTFingRoomEmpty(param1:uint) : void
      {
         _socket.readbegin();
         TextTip.instance.showByLang("net_notroom");
         Application.instance.log("房间为空","");
         callUserFun(param1,{});
      }
      
      private function onBTGetRoomList(param1:uint) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Array = null;
         _socket.readbegin();
         var _loc3_:Object = getFormatRetData();
         _loc3_.data.roomSize = _socket.readInt();
         _loc3_.data.roomArr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.data.roomSize)
         {
            _loc2_ = [];
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readString());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readString());
            _loc3_.data.roomArr.push(_loc2_);
            _loc4_++;
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onPlayerChangeWeaponInBox(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.type = _socket.readInt();
         _loc2_.data.code = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onPlayerWeaponState(param1:uint) : void
      {
         var _loc3_:int = 0;
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.ret = _socket.readInt();
         _loc2_.data.maxHoles = _socket.readInt();
         _loc2_.data.nowHoles = _socket.readInt();
         _loc2_.data.weaponArr = [];
         _loc3_ = 0;
         while(_loc3_ < _loc2_.data.nowHoles)
         {
            _loc2_.data.weaponArr.push(readGoods());
            _loc3_++;
         }
         callUserFun(param1,_loc2_);
      }
      
      private function onPlayerChangeWeaponInFightDone(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Object = getFormatRetData();
         _loc2_.data.ret = _socket.readInt();
         if(_loc2_.data.ret == 0)
         {
            _loc2_.data.uid = _socket.readInt();
            _loc2_.data.weaponArr = readGoods();
            callUserFun(param1,_loc2_);
         }
      }
      
      private function onSomeoneVipLevel(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.self = _socket.readInt();
         _loc2_.who = _socket.readInt();
         _loc2_.level = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onVipLuckyDraw(param1:uint) : void
      {
         var _loc6_:Object = {};
         _loc6_.ret = 0;
         _loc6_.data = {};
         _socket.readbegin();
         _loc6_.data.uid = _socket.readInt();
         _loc6_.data.cardNum = _socket.readInt();
         if(_loc6_.data.cardNum == -1)
         {
            return;
         }
         var _loc5_:int = _socket.readInt();
         var _loc2_:int = _socket.readInt();
         var _loc4_:int = _socket.readInt();
         if(_loc4_ != 0)
         {
            _loc6_.data.prop = [_loc5_,_loc2_];
         }
         _loc6_.data.goldCount = _socket.readInt();
         if(_loc6_.data.uid == PlayerDataList.instance.selfData.uid && _loc6_.data.goldCount > 0)
         {
            AccountData.instance.gameGold += _loc6_.data.goldCount;
         }
         var _loc3_:PlayerData = PlayerDataList.instance.getDataByUID(_loc6_.data.uid);
         if(_loc3_)
         {
            _loc6_.data.uname = _loc3_.babyName;
         }
         callUserFun(param1,_loc6_);
      }
      
      private function onVipViewInfo(param1:uint) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:Object = getFormatRetData();
         _socket.readbegin();
         _loc3_.data.mid = _socket.readInt();
         _loc3_.data.vipLevel = _socket.readInt();
         _loc3_.data.boyaaCoin = _socket.readInt();
         _loc3_.data.nextLevel = _socket.readInt();
         _loc3_.data.nextLevelCoin = _socket.readInt();
         _loc3_.data.request_level = _socket.readInt();
         _loc3_.data.isReward = _socket.readInt();
         _loc3_.data.failreason = _socket.readInt();
         _loc3_.data.giftNum = _socket.readInt();
         _loc3_.data.giftArr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.data.giftNum)
         {
            _loc2_ = [];
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc2_.push(_socket.readInt());
            _loc3_.data.giftArr.push(_loc2_);
            _loc4_++;
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onVipReward(param1:uint) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.mid = _socket.readInt();
         _loc2_.data.flag = _socket.readInt();
         if(_loc2_.data.flag)
         {
            _loc2_.data.giftNum = _socket.readInt();
            _loc2_.data.giftArr = [];
            _loc3_ = 0;
            while(_loc3_ < _loc2_.data.giftNum)
            {
               _loc2_.data.giftArr.push(_socket.readInt());
               _loc3_++;
            }
         }
         callUserFun(param1,_loc2_);
      }
      
      private function onAutoFightTimes(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.mid = _socket.readInt();
         _loc2_.data.todayCount = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onUseAutoFight(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.mid = _socket.readInt();
         _loc2_.data.todayCount = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onVipReliveInEndless(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.flag = _socket.readInt();
         if(_loc2_.data.flag == 1)
         {
            _loc2_.data.level = _socket.readInt();
         }
         callUserFun(param1,_loc2_);
      }
      
      private function onEndlessItemReceive(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Array = readGoods();
         GoodsList.instance.addGoodsByStr(_loc2_);
      }
      
      private function onFreeReliveTimesInCopy(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.freeleft = _socket.readInt();
         callUserFun(param1,_loc2_);
      }
      
      private function onUseFreeReliveInCopy(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.flag = _socket.readInt();
         if(_loc2_.data.flag == 0)
         {
            _loc2_.data.freeleft = _socket.readInt();
         }
         callUserFun(param1,_loc2_);
      }
      
      private function onSynthesis(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.mid = _socket.readInt();
         _loc2_.data.reply = _socket.readShort();
         if(_loc2_.data.reply == 1)
         {
            _loc2_.data.goodArr = [];
            _loc2_.data.goodArr = readGoods();
         }
         callUserFun(param1,_loc2_);
      }
      
      private function onAddition(param1:uint) : void
      {
         var _loc2_:Object = getFormatRetData();
         _socket.readbegin();
         _loc2_.data.mid = _socket.readInt();
         _loc2_.data.reply = _socket.readShort();
         if(_loc2_.data.reply == 1)
         {
            _loc2_.data.goodArr = [];
            _loc2_.data.goodArr = readGoods();
         }
         callUserFun(param1,_loc2_);
      }
      
      private function onHandleUnionTostorageDone(param1:uint) : void
      {
         var _loc4_:Array = ["刷新失败","找不到道具","原本位置不正确","物品已经被租了","服务器删除记录失败","更新背包失败"];
         _socket.readbegin();
         _socket.readInt();
         var _loc2_:int = _socket.readShort();
         var _loc3_:Array = [];
         if(_loc2_ == 0)
         {
            _loc3_[0] = true;
            _loc3_[1] = readGoods();
            _loc3_[2] = _socket.readInt();
         }
         else
         {
            TextTip.instance.show(_loc4_[Math.abs(_loc2_) - 1]);
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onHandleUnionRentGoodsDone(param1:uint) : void
      {
         var _loc5_:Array = ["刷新失败","找不到道具","原本位置不正确","物品已经被租了","贡献不足","服务器不能付钱给物主","发新道具失败","服务器记录出租条目失败","更新原道具失败","公会不匹配"];
         _socket.readbegin();
         var _loc3_:Array = [];
         var _loc4_:int = _socket.readInt();
         var _loc2_:int = _socket.readShort();
         if(_loc2_ == 0)
         {
            _loc3_[0] = true;
            _loc3_[1] = readGoods();
            _loc3_[2] = _socket.readInt();
         }
         else
         {
            TextTip.instance.show(_loc5_[Math.abs(_loc2_) - 1]);
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onHandleUnionRentlistDone(param1:uint) : void
      {
         var _loc6_:int = 0;
         var _loc2_:Array = null;
         var _loc4_:Object = null;
         var _loc3_:Array = [];
         _socket.readbegin();
         var _loc5_:int = _socket.readInt();
         var _loc7_:int = _socket.readInt();
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc2_ = [];
            _loc4_ = {};
            _loc4_.from_mid = _socket.readInt();
            _loc4_.flag = _socket.readInt();
            _loc4_.expire_time = _socket.readInt();
            _loc4_.rental_date = _socket.readInt();
            _loc4_.rental_period = _socket.readInt();
            _loc4_.rental_mppid = _socket.readInt();
            _loc4_.rental_price = _socket.readInt();
            _loc4_.unionid = _socket.readInt();
            _loc2_.push(_loc4_);
            _loc2_.push(readGoods());
            _loc3_.push(_loc2_);
            _loc6_++;
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onHandleUnionTorentalStorageDone(param1:uint) : void
      {
         var _loc3_:Array = ["刷新失败","找不到道具","原本位置不对","可消耗品不能放租","取道具时间信息失败","剩余时间不足","租期不合法，只能是3小时或者7小时","贡献不足，3小时要50贡献，7小时要100贡献","服务器不能记录出租物品","更新背包失败"];
         _socket.readbegin();
         var _loc4_:Array = [];
         var _loc5_:int = _socket.readInt();
         var _loc2_:int = _socket.readShort();
         if(_loc2_ == 0)
         {
            _loc4_[0] = true;
            _loc4_[1] = readGoods();
            _loc4_[2] = _socket.readInt();
         }
         else
         {
            TextTip.instance.show(_loc3_[Math.abs(_loc2_) - 1]);
         }
         callUserFun(param1,_loc4_);
      }
      
      private function onHandleFromeUnionToMyStorageDone(param1:uint) : void
      {
         var _loc5_:Array = ["刷新失败","找不到道具","原本位置不正确","物品已经被租了","服务器删除记录失败","更新背包失败"];
         _socket.readbegin();
         var _loc3_:Array = [];
         var _loc4_:int = _socket.readInt();
         var _loc2_:int = _socket.readShort();
         trace("3108返回：" + _loc2_);
         if(_loc2_ == 0)
         {
            _loc3_[0] = true;
            _loc3_[1] = readGoods();
            _loc3_[2] = _socket.readInt();
         }
         else
         {
            TextTip.instance.show(_loc5_[Math.abs(_loc2_) - 1]);
         }
         callUserFun(param1,_loc3_);
      }
      
      private function onDelOvertimeRentalGoods(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Array = [];
         _loc2_.push(_socket.readInt());
         _loc2_.push(_socket.readInt());
         callUserFun(param1,_loc2_);
      }
      
      private function getBagItemRentStatus(param1:uint) : void
      {
         var _loc5_:int = 0;
         _socket.readbegin();
         var _loc2_:Array = [];
         var _loc4_:int = _socket.readInt();
         var _loc3_:int = _socket.readInt();
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc2_.push(_socket.readInt());
            _loc5_++;
         }
         callUserFun(param1,_loc2_);
      }
      
      private function nobodyRentAndBacktoMystor(param1:uint) : void
      {
         _socket.readbegin();
         var _loc2_:Array = [];
         _loc2_.push(_socket.readInt());
         _loc2_.push(_socket.readInt());
         callUserFun(param1,_loc2_);
      }
   }
}

