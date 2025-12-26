package com.boyaa.antwars.data
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.data.model.mission.MissionData;
   import com.boyaa.antwars.data.model.mission.RewardData;
   import com.boyaa.antwars.data.model.mission.SubMissionData;
   import com.boyaa.antwars.events.PHPEvent;
   
   public class MissionDataList
   {
      
      private static var instance:MissionDataList = null;
      
      private var _missionStore:Array = [];
      
      public var delID:int = 0;
      
      public var tempData:MissionData;
      
      public var dailyMissionArr:Array = null;
      
      public var mainMissionArr:Array = null;
      
      public var guildMissionArr:Array = null;
      
      public var activeMissionArr:Array = null;
      
      private var _doneMissionArr:Array = [];
      
      public var currentMission:MissionData = null;
      
      public var doneMission:Boolean = false;
      
      public var newMission:Boolean = false;
      
      public var hasDoneMission:Boolean = false;
      
      public var rawMissionDataList:Array;
      
      public function MissionDataList()
      {
         super();
         if(instance != null)
         {
            throw Error("there\'s no instance");
         }
         instance = this;
      }
      
      public static function getInstance() : MissionDataList
      {
         if(instance == null)
         {
            instance = new MissionDataList();
         }
         return instance;
      }
      
      public function loadData(param1:XML) : void
      {
         var _loc2_:MissionData = null;
         var _loc3_:SubMissionData = null;
         var _loc5_:RewardData = null;
         var _loc4_:ShopData = null;
         _missionStore = [];
         for each(var _loc8_ in param1.mission)
         {
            _loc2_ = new MissionData();
            _loc2_.mtype = int(_loc8_.@mtype);
            _loc2_.msid = int(_loc8_.@msid);
            _loc2_.msname = _loc8_.@msname;
            _loc2_.mdesc = _loc8_.@msdesc;
            _loc2_.experience = _loc8_.@experience;
            _loc2_.exCertificate = _loc8_.@excertificate;
            _loc2_.gxz = _loc8_.@cdevote;
            _loc2_.coin = _loc8_.@currency;
            _loc2_.hot = _loc8_.@hot;
            _loc2_.level = _loc8_.@missionlevel;
            for each(var _loc7_ in _loc8_.submissionids.submissionid)
            {
               _loc3_ = new SubMissionData();
               _loc3_.smsid = int(_loc7_.@smsid);
               _loc3_.actioncode = int(_loc7_.@actioncode);
               _loc2_.mtarget = _loc2_.mtarget + "\n" + _loc7_.@target;
               _loc3_.target = _loc7_.@target;
               _loc3_.pcate = int(_loc7_.@pcate);
               _loc3_.pframe = int(_loc7_.@pframe);
               _loc3_.times = int(_loc7_.@times);
               _loc3_.isdel = int(_loc7_.@isdel);
               _loc2_.submissions.push(_loc3_);
            }
            for each(var _loc6_ in _loc8_.missionprizes.missionprize)
            {
               _loc5_ = new RewardData();
               _loc5_.pcate = _loc6_.@pcate;
               _loc5_.pframe = _loc6_.@pframe;
               _loc5_.validperiod = _loc6_.@validperiod;
               _loc5_.quantity = _loc6_.@quantity;
               _loc5_.mgender = _loc6_.@mgender;
               _loc5_.goodName = ShopDataList.instance.getSingleData(_loc6_.@pcate,_loc6_.@pframe).name;
               _loc4_ = ShopDataList.instance.getSingleData(_loc6_.@pcate,_loc6_.@pframe);
               _loc5_.data = _loc4_;
               _loc2_.rewards.push(_loc5_);
            }
            missionStore.push(_loc2_);
         }
      }
      
      public function removeMissionGoods() : void
      {
         var _loc4_:int = 0;
         var _loc1_:SubMissionData = null;
         var _loc3_:MissionData = getMissionByID(delID);
         if(_loc3_ == null)
         {
            return;
         }
         var _loc2_:Array = _loc3_.submissions;
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc1_ = _loc2_[_loc4_];
            if(_loc1_.isdel == 1)
            {
               GoodsList.instance.reduceConsumeGoods(_loc1_.pcate,_loc1_.pframe,_loc1_.times);
            }
            _loc4_++;
         }
      }
      
      public function reviseData(param1:Array) : void
      {
         var _loc2_:MissionData = null;
         var _loc3_:SubMissionData = null;
         var _loc4_:int = 0;
         rawMissionDataList = param1;
         resetData();
         tempData = null;
         for each(var _loc6_ in param1)
         {
            _loc2_ = getMissionByID(int(_loc6_[1]));
            if(_loc2_)
            {
               if(_loc2_.msid == 2065)
               {
                  trace("");
               }
               _loc2_.dataBaseID = int(_loc6_[0]);
               _loc2_.isCurMission = true;
               _loc2_.isFinished = int(_loc6_[2]) == 1 ? true : false;
               _loc2_.isRewarded = int(_loc6_[2]) == 2 ? true : false;
               for each(var _loc5_ in _loc6_[4])
               {
                  _loc3_ = getSubMissionByID(_loc5_[1],_loc2_.submissions);
                  if(_loc3_ != null)
                  {
                     if(_loc3_.actioncode == 148)
                     {
                        if(PlayerDataList.instance.selfData.marryState == 1)
                        {
                           _loc3_.completed = 1;
                        }
                     }
                     else if(_loc3_.actioncode == 117)
                     {
                        _loc3_.completed = PlayerDataList.instance.selfData.level;
                        tempData = _loc2_;
                     }
                     else if(_loc3_.actioncode == 115)
                     {
                        _loc3_.completed = GoodsList.instance.getGoodsNumInMission(_loc3_.pcate,_loc3_.pframe);
                     }
                     else if(_loc3_.actioncode == 114)
                     {
                        _loc4_ = 0;
                        if(!(_loc3_.pcate != 0 && _loc3_.pframe != 0))
                        {
                           if(!(_loc3_.pcate == 11 || _loc3_.pcate == 12 || _loc3_.pcate == 0 && _loc3_.pframe == 0))
                           {
                              if(_loc3_.pcate == 1 || _loc3_.pcate == 6)
                              {
                              }
                           }
                        }
                        _loc3_.completed = _loc4_;
                     }
                     else
                     {
                        _loc3_.completed = int(_loc5_[2]);
                     }
                     _loc3_.isFinished = _loc3_.completed >= _loc3_.times ? true : false;
                     if(_loc2_.msid == 1006)
                     {
                     }
                  }
               }
            }
         }
         injectData();
      }
      
      public function resetData() : void
      {
         var _loc1_:String = null;
         for each(var _loc3_ in missionStore)
         {
            _loc3_.isCurMission = false;
            _loc3_.isFinished = false;
            _loc3_.isRewarded = false;
            _loc1_ = LocalData.instance.getData(String(PlayerDataList.instance.selfData.uid + _loc3_.msid));
            if(_loc1_)
            {
               if(_loc1_ == "true")
               {
                  _loc3_.isNew = true;
               }
               else
               {
                  _loc3_.isNew = false;
               }
            }
            LocalData.instance.setData(String(_loc3_.msid),String(_loc3_.isNew ? true : false));
            for each(var _loc2_ in _loc3_.submissions)
            {
               _loc2_.completed = 0;
               _loc2_.isFinished = false;
            }
         }
      }
      
      public function getMissionByID(param1:int) : MissionData
      {
         for each(var _loc2_ in missionStore)
         {
            if(_loc2_.msid == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getSubMissionByID(param1:int, param2:Array) : SubMissionData
      {
         for each(var _loc3_ in param2)
         {
            if(_loc3_.smsid == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function get missionStore() : Array
      {
         return _missionStore;
      }
      
      public function set missionStore(param1:Array) : void
      {
         _missionStore = param1;
      }
      
      public function get doneMissionArr() : Array
      {
         return _doneMissionArr;
      }
      
      public function injectData() : void
      {
         dailyMissionArr = [];
         mainMissionArr = [];
         guildMissionArr = [];
         activeMissionArr = [];
         _doneMissionArr = [];
         doneMission = false;
         newMission = false;
         hasDoneMission = false;
         for each(var _loc1_ in missionStore)
         {
            if(_loc1_.msid == 2070)
            {
               trace("");
            }
            if(_loc1_.isCurMission)
            {
               switch(_loc1_.mtype - 1)
               {
                  case 0:
                  case 2:
                     if(_loc1_.msid == 2070)
                     {
                        trace("");
                     }
                     mainMissionArr.push(_loc1_);
                     break;
                  case 1:
                     dailyMissionArr.push(_loc1_);
                     if(!doneMission)
                     {
                        if(_loc1_.isFinished && !_loc1_.isRewarded)
                        {
                           doneMission = true;
                        }
                     }
                     if(!newMission)
                     {
                        if(_loc1_.isNew && !_loc1_.isRewarded)
                        {
                           newMission = true;
                        }
                     }
                     break;
                  case 3:
                     guildMissionArr.push(_loc1_);
                     break;
                  case 4:
                  case 5:
                  case 6:
                  case 7:
                     activeMissionArr.push(_loc1_);
               }
               if(_loc1_.isFinished && !_loc1_.isRewarded)
               {
                  _doneMissionArr.push(_loc1_);
               }
            }
         }
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getMissionStatus"));
      }
      
      private function sortDailyMission() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < dailyMissionArr.length)
         {
            switch(dailyMissionArr[_loc2_].msid)
            {
               case 20001:
                  _loc1_[0] = dailyMissionArr[_loc2_];
                  break;
               case 20002:
                  _loc1_[1] = dailyMissionArr[_loc2_];
                  break;
               case 200101:
               case 200102:
                  _loc1_[2] = dailyMissionArr[_loc2_];
                  break;
               case 20008:
                  _loc1_[3] = dailyMissionArr[_loc2_];
                  break;
               case 200031:
               case 200032:
               case 200033:
                  _loc1_[4] = dailyMissionArr[_loc2_];
                  break;
               case 200041:
               case 200042:
               case 200043:
               case 200044:
                  _loc1_[5] = dailyMissionArr[_loc2_];
                  break;
               case 200061:
               case 200062:
               case 200063:
                  _loc1_[6] = dailyMissionArr[_loc2_];
                  break;
               case 200051:
               case 200052:
               case 200053:
                  _loc1_[7] = dailyMissionArr[_loc2_];
                  break;
               case 200071:
               case 200072:
               case 200073:
                  _loc1_[8] = dailyMissionArr[_loc2_];
                  break;
               case 20012:
                  _loc1_[9] = dailyMissionArr[_loc2_];
                  break;
               case 20011:
                  _loc1_[10] = dailyMissionArr[_loc2_];
                  break;
               case 200091:
               case 200092:
               case 200093:
                  _loc1_[11] = dailyMissionArr[_loc2_];
            }
            _loc2_++;
         }
         dailyMissionArr = [];
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_] != null)
            {
               dailyMissionArr.push(_loc1_[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      public function delSingleRawMissionDataByID(param1:int) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = int(rawMissionDataList.length);
         while(_loc3_--)
         {
            _loc2_ = rawMissionDataList[_loc3_];
            if(_loc2_[1] == param1)
            {
               rawMissionDataList.splice(_loc3_,1);
               break;
            }
         }
      }
      
      public function addSingleRawMissionData(param1:Array) : void
      {
         if(null != rawMissionDataList)
         {
            rawMissionDataList.push(param1);
         }
      }
   }
}

