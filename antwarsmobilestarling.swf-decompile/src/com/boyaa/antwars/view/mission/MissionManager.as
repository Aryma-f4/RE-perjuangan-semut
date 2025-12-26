package com.boyaa.antwars.view.mission
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.MissionDataList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.data.model.mission.MissionData;
   import com.boyaa.antwars.data.model.mission.SubMissionData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.AntiAddictionTip;
   import com.boyaa.tool.LoadData;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import starling.core.Starling;
   
   public class MissionManager
   {
      
      private static var _instance:MissionManager = null;
      
      private var _accountData:AccountData;
      
      private var _data:MissionData = null;
      
      public var onLineTime:int = 0;
      
      private var _timer:Timer = new Timer(60000);
      
      private var _antiAddiction:AntiAddictionTip;
      
      private var _countOnlineTimeStart:Boolean = false;
      
      private var selfExp:int = -1;
      
      public function MissionManager()
      {
         super();
         if(_instance != null)
         {
            throw Error("there\'s no instance");
         }
         _instance = this;
         init();
      }
      
      public static function get instance() : MissionManager
      {
         if(_instance == null)
         {
            _instance = new MissionManager();
         }
         return _instance;
      }
      
      public function init() : void
      {
         _accountData = AccountData.instance;
         _timer.addEventListener("timer",countOnLineTime);
      }
      
      public function countOnlineTimeStart() : void
      {
         trace("onLineTime start:",onLineTime);
         updateMissionData(143,onLineTime);
         _timer.start();
      }
      
      public function countOnlineTimeStop() : void
      {
         _timer.stop();
      }
      
      private function countOnLineTime(param1:TimerEvent) : void
      {
         onLineTime = onLineTime + 1;
         trace("countOnLineTime:" + onLineTime);
         updateMissionData(143,onLineTime);
         if((onLineTime == 285 || onLineTime == 290 || onLineTime == 295) && !PlayerDataList.instance.selfData.isAdult)
         {
            if(!_antiAddiction)
            {
               _antiAddiction = new AntiAddictionTip();
            }
            _antiAddiction.btnClose.enabled = true;
            _antiAddiction.btnClose.visible = true;
            _antiAddiction.x = 1365 - _antiAddiction.width >> 1;
            _antiAddiction.y = 768 - _antiAddiction.height >> 1;
            if(onLineTime == 290)
            {
               _antiAddiction.tipMin.text = 10 + LangManager.t("tipMin");
               _antiAddiction.tipHour.text = "4:50" + LangManager.t("tipHour");
            }
            else if(onLineTime == 295)
            {
               _antiAddiction.tipMin.text = 5 + LangManager.t("tipMin");
               _antiAddiction.tipHour.text = "4:55" + LangManager.t("tipHour");
            }
            if(!_antiAddiction.parent)
            {
               Starling.current.stage.addChild(_antiAddiction);
            }
         }
         if(onLineTime >= 300 && !PlayerDataList.instance.selfData.isAdult)
         {
            if(!_antiAddiction)
            {
               _antiAddiction = new AntiAddictionTip();
            }
            _antiAddiction.tipHour.text = 5 + LangManager.t("tipHour");
            _antiAddiction.tipMin.visible = false;
            _antiAddiction.tipText2.text = LangManager.t("antiAddiction6");
            _antiAddiction.tipText2.x = _antiAddiction.tipMin.x;
            _antiAddiction.btnClose.enabled = false;
            _antiAddiction.btnClose.visible = false;
            _antiAddiction.x = 1365 - _antiAddiction.width >> 1;
            _antiAddiction.y = 768 - _antiAddiction.height >> 1;
            if(!_antiAddiction.parent)
            {
               Starling.current.stage.addChild(_antiAddiction);
            }
         }
      }
      
      public function updateMissionData(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0) : void
      {
         var _loc5_:Boolean = false;
         for each(var _loc7_ in MissionDataList.getInstance().missionStore)
         {
            if(_loc7_.isCurMission)
            {
               for each(var _loc6_ in _loc7_.submissions)
               {
                  switch(param1)
                  {
                     case 102:
                        break;
                     case 115:
                        if(_loc6_.actioncode == param1 && _loc6_.pcate == param2 && _loc6_.pframe == param3)
                        {
                           trace("获取物品的数量:",param2,":",param3);
                           _loc6_.completed = GoodsList.instance.getGoodsNumInMission(param2,param3);
                           _loc6_.isFinished = _loc6_.completed >= _loc6_.times ? true : false;
                           Application.instance.log("missionComplete",_loc6_.target + "(" + _loc6_.completed + "/" + _loc6_.times + ")");
                        }
                        break;
                     case 176:
                     case 180:
                        if(_loc6_.actioncode == param1)
                        {
                           _loc6_.isFinished = true;
                           _loc6_.completed = param2;
                           Application.instance.log("missionComplete",_loc6_.target + "(" + _loc6_.completed + "/" + _loc6_.times + ")");
                        }
                        break;
                     case 112:
                     case 123:
                     case 133:
                     case 143:
                        if(_loc6_.actioncode == param1)
                        {
                           _loc6_.completed = param2;
                           _loc6_.isFinished = _loc6_.completed >= _loc6_.times ? true : false;
                           Application.instance.log("missionComplete",_loc6_.target + "(" + _loc6_.completed + "/" + _loc6_.times + ")");
                        }
                        break;
                     default:
                        if(_loc6_.actioncode == param1)
                        {
                           trace("");
                        }
                        if(_loc6_.actioncode == param1 && (_loc6_.pcate == param2 || _loc6_.pcate == 0) && (_loc6_.pframe == param3 || _loc6_.pframe == 0))
                        {
                           if(!_loc6_.isFinished)
                           {
                              if(param4 > 0)
                              {
                                 _loc6_.completed = param4;
                              }
                              else
                              {
                                 _loc6_.completed++;
                              }
                              Application.instance.log("missionComplete",_loc6_.target + "(" + _loc6_.completed + "/" + _loc6_.times + ")");
                              _loc6_.isFinished = _loc6_.completed >= _loc6_.times ? true : false;
                           }
                        }
                  }
               }
            }
         }
         MissionDataList.getInstance().injectData();
         if(Application.instance.currentGame && Application.instance.currentGame.mainMenu)
         {
            Application.instance.currentGame.mainMenu.missionBtnHightLight(MissionDataList.getInstance().hasDoneMission);
            Application.instance.currentGame.mainMenu.showMissionFinishNum(MissionDataList.getInstance().doneMissionArr.length);
         }
      }
      
      public function getMissionState() : void
      {
         Remoting.instance.getMissionState(result1);
      }
      
      public function beRewarded(param1:MissionData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc5_:int = 0;
         var _loc4_:SubMissionData = null;
         if(param1)
         {
            _data = param1;
            MissionDataList.getInstance().delID = param1.msid;
            _loc2_ = 0;
            _loc3_ = [];
            _loc5_ = 0;
            while(_loc5_ < _data.submissions.length)
            {
               _loc4_ = _data.submissions[_loc5_] as SubMissionData;
               if(_loc4_.actioncode != 114)
               {
                  if(_loc4_.actioncode == 115)
                  {
                     _loc3_ = _loc3_.concat(GoodsList.instance.getOnlyIDArr(_loc4_.pcate,_loc4_.pframe));
                  }
               }
               _loc5_++;
            }
            LoadData.show();
            Remoting.instance.gainReward(_data.dataBaseID,_loc3_,onGainReward);
         }
         else
         {
            TextTip.instance.show(LangManager.t("noMissionData"));
         }
      }
      
      private function onGainReward(param1:Object) : void
      {
         var _loc6_:Array = null;
         Application.instance.log("onMissionReward",JSON.stringify(param1));
         LoadData.hide();
         if(param1.hasOwnProperty("error"))
         {
            TextTip.instance.show(LangManager.t("missionerror"));
            getMissionState();
            return;
         }
         var _loc7_:String = LangManager.t("gain") + LangManager.t("gold") + ":" + _data.coin + "," + LangManager.t("exp") + _data.experience;
         var _loc3_:Array = param1 as Array;
         var _loc5_:PlayerData = PlayerDataList.instance.selfData;
         var _loc2_:Object = _loc3_[0];
         _loc5_.addOtherInfo(_loc2_);
         var _loc4_:Object = _loc3_[1];
         _accountData.gameGold = _loc4_.currency;
         _accountData.boyaaCoin = _loc4_.boyaacurrency;
         _accountData.freeCoin = _loc4_.excertificate;
         if(_loc3_[2] != null)
         {
            _loc6_ = _loc3_[2];
            GoodsList.instance.addGoodsByAry(_loc6_);
         }
         TextTip.instance.show(_loc7_);
         MissionDataList.getInstance().removeMissionGoods();
         getMissionState();
      }
      
      private function result1(param1:Object) : void
      {
         trace(JSON.stringify(param1));
         MissionDataList.getInstance().reviseData(param1 as Array);
         updateMissionData(143,onLineTime);
      }
   }
}

