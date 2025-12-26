package com.boyaa.antwars.data
{
   import com.boyaa.antwars.data.model.PlayerData;
   import flash.geom.Point;
   
   public class PlayerDataList
   {
      
      private static var _instance:PlayerDataList = null;
      
      private var _list:Array = null;
      
      public var selfData:PlayerData = null;
      
      public var copyArr:Array = [];
      
      public var now:Date;
      
      public var appid:int = 0;
      
      public var language:String = "hk";
      
      private var _fans:int = 1;
      
      public var loginDays:int = 1;
      
      public var luckTimes:int = 0;
      
      public var isHaveHome:Boolean = false;
      
      public var isGetVipDailyGift:Boolean = false;
      
      public var vip:int = 0;
      
      public var yearVip:int = 0;
      
      public var vipLevel:int = 0;
      
      public var firstLogTime:Number = 0;
      
      public var mySiteId:uint = 0;
      
      public var copysPrizeCount:int = 0;
      
      public var pk_type:int;
      
      private var _fightMode:int = 0;
      
      public var bornPoint:Vector.<Point>;
      
      public var mapId:int;
      
      public function PlayerDataList(param1:Single)
      {
         super();
         selfData = new PlayerData();
         _list = [];
         _list.push(selfData);
      }
      
      public static function get instance() : PlayerDataList
      {
         if(_instance == null)
         {
            _instance = new PlayerDataList(new Single());
         }
         return _instance;
      }
      
      public function getDataBySiteID(param1:int) : PlayerData
      {
         var _loc3_:int = 0;
         var _loc2_:PlayerData = null;
         _loc3_ = 0;
         while(_loc3_ < _list.length)
         {
            _loc2_ = _list[_loc3_];
            if(_loc2_.siteID == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getRobotData() : PlayerData
      {
         var _loc1_:PlayerData = null;
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _list.length)
         {
            _loc1_ = _list[_loc2_];
            if(_loc1_.isrobot)
            {
               return _loc1_;
            }
            _loc2_++;
         }
         _loc1_ = new PlayerData();
         _loc1_.siteID = 11111;
         return _loc1_;
      }
      
      public function getRobotTeam() : Array
      {
         var _loc2_:PlayerData = null;
         var _loc3_:int = 0;
         var _loc1_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < list.length)
         {
            _loc2_ = list[_loc3_];
            if(_loc2_.isrobot)
            {
               _loc1_.push(_loc2_);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function addPlayer(param1:Object) : void
      {
         var _loc2_:PlayerData = new PlayerData();
         _loc2_.uid = param1.mid;
         _loc2_.siteID = param1.siteID;
         _loc2_.team = param1.team;
         _loc2_.ready = param1.ready;
         _loc2_.houseOwner = param1.isHouseOwner;
         _loc2_.addInfo(param1.charInfo);
         _loc2_.addPropInfo(param1.propInfo);
         removePlayerByUID(param1.mid);
         _loc2_.exp = param1.exp;
         _loc2_.delay = param1.delay;
         _loc2_.energy = param1.energy;
         _loc2_.leaving = false;
         _list.push(_loc2_);
      }
      
      public function copyGameAddSinglePlayer(param1:Object) : void
      {
         var _loc2_:Array = param1.data.playerInfo;
         var _loc3_:PlayerData = new PlayerData();
         if(findInListByUID(_loc2_[0]))
         {
            return;
         }
         _loc3_.uid = _loc2_[0];
         _loc3_.babyName = _loc2_[1];
         _loc3_.babySex = _loc2_[2];
         _loc3_.level = _loc2_[3];
         _loc3_.houseOwner = _loc2_[4];
         _loc3_.siteID = _loc2_[6];
         _loc3_.addPropInfo(_loc2_[7]);
         _loc3_.energy = _loc2_[8];
         _loc3_.ready = _loc2_[9];
         _loc3_.addInfo(_loc2_[10]);
         _loc3_.exp = _loc2_[11];
         removePlayerByUID(_loc3_.uid);
         _list.push(_loc3_);
      }
      
      public function copyGameAddRoomPlayers(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc3_:PlayerData = null;
         var _loc2_:Array = param1.data.playerInfo;
         _loc4_ = 0;
         while(_loc4_ < param1.data.size)
         {
            if(!findInListByUID(_loc2_[_loc4_][0]))
            {
               _loc3_ = new PlayerData();
               _loc3_.uid = _loc2_[_loc4_][0];
               _loc3_.babyName = _loc2_[_loc4_][1];
               _loc3_.babySex = _loc2_[_loc4_][2];
               _loc3_.level = _loc2_[_loc4_][3];
               _loc3_.houseOwner = _loc2_[_loc4_][4];
               _loc3_.siteID = _loc2_[_loc4_][6];
               _loc3_.addPropInfo(_loc2_[_loc4_][7]);
               _loc3_.energy = _loc2_[_loc4_][8];
               _loc3_.ready = _loc2_[_loc4_][9];
               _loc3_.addInfo(_loc2_[_loc4_][10]);
               _loc3_.exp = _loc2_[_loc4_][11];
               _list.push(_loc3_);
            }
            _loc4_++;
         }
      }
      
      private function findInListByUID(param1:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:PlayerData = null;
         _loc3_ = 0;
         while(_loc3_ < _list.length)
         {
            _loc2_ = _list[_loc3_];
            if(param1 == _loc2_.uid)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function getMaxSiteId() : int
      {
         var _loc3_:int = 0;
         var _loc2_:PlayerData = null;
         var _loc1_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _list.length)
         {
            _loc2_ = _list[_loc3_];
            if(_loc2_.siteID > _loc1_)
            {
               _loc1_ = int(_loc2_.siteID);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function setSelfSite(param1:uint, param2:int) : void
      {
         selfData.siteID = param1;
         selfData.team = param2;
      }
      
      public function getDataByTeamId(param1:int) : Array
      {
         var _loc4_:int = 0;
         var _loc3_:PlayerData = null;
         var _loc2_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < _list.length)
         {
            _loc3_ = _list[_loc4_];
            if(_loc3_.team == param1)
            {
               _loc2_.push(_loc3_);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function getTeamPlayerData(param1:int) : PlayerData
      {
         var _loc3_:PlayerData = null;
         var _loc4_:int = 0;
         var _loc2_:Array = getDataByTeamId(param1);
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc4_];
            if(_loc3_ && _loc3_.uid != selfData.uid)
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getDataByUID(param1:int) : PlayerData
      {
         var _loc3_:int = 0;
         var _loc2_:PlayerData = null;
         _loc3_ = 0;
         while(_loc3_ < _list.length)
         {
            _loc2_ = _list[_loc3_];
            if(_loc2_.uid == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function isSameTem(param1:int) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc2_:PlayerData = getDataBySiteID(param1);
         if(_loc2_)
         {
            if(selfData.team == _loc2_.team)
            {
               return true;
            }
            return false;
         }
         _loc3_ = [0,1];
         _loc4_ = [2,3];
         if(_loc3_.indexOf(param1) != -1 && _loc3_.indexOf(selfData.siteID) != -1 || _loc4_.indexOf(param1) != -1 && _loc4_.indexOf(selfData.siteID) != -1)
         {
            return true;
         }
         return false;
      }
      
      public function removePlayerByUID(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:PlayerData = null;
         _loc3_ = 0;
         while(_loc3_ < _list.length)
         {
            _loc2_ = _list[_loc3_];
            if(_loc2_.uid == param1)
            {
               _list.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function removePlayers() : void
      {
         _list.splice(1,_list.length - 1);
      }
      
      public function removeLeavingPlayers() : void
      {
         var _loc2_:int = 0;
         var _loc1_:PlayerData = null;
         _loc2_ = 0;
         while(_loc2_ < list.length)
         {
            _loc1_ = list[_loc2_];
            if(_loc1_.leaving)
            {
               removePlayerByUID(_loc1_.uid);
               _loc2_--;
            }
            _loc2_++;
         }
      }
      
      public function removeOtherTeamPlayers(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:PlayerData = null;
         _loc3_ = 0;
         while(_loc3_ < list.length)
         {
            _loc2_ = list[_loc3_];
            if(_loc2_.team != param1)
            {
               removePlayerByUID(_loc2_.uid);
               _loc3_--;
            }
            _loc3_++;
         }
      }
      
      public function removeRobotPlayers() : void
      {
         var _loc2_:int = 0;
         var _loc1_:PlayerData = null;
         _loc2_ = 0;
         while(_loc2_ < list.length)
         {
            _loc1_ = list[_loc2_];
            if(_loc1_.isrobot)
            {
               removePlayerByUID(_loc1_.uid);
               _loc2_--;
            }
            _loc2_++;
         }
      }
      
      public function setTime(param1:uint) : void
      {
         now = new Date();
         now.setTime(param1 * 1000);
      }
      
      public function get list() : Array
      {
         return _list;
      }
      
      public function get fightMode() : int
      {
         return _fightMode;
      }
      
      public function set fightMode(param1:int) : void
      {
         _fightMode = param1;
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
