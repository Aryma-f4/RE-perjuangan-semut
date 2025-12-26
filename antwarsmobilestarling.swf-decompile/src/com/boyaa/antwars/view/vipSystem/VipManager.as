package com.boyaa.antwars.view.vipSystem
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.net.server.GameServer;
   
   public class VipManager
   {
      
      public static const SIGN_IN:int = 0;
      
      public static const OWER_PACK:int = 1;
      
      public static const LEVEL_PACK:int = 2;
      
      public static const AUTO_FIGHT:int = 3;
      
      public static const FIGHT_GOODS:int = 4;
      
      public static const UNION_WORSHIP:int = 5;
      
      public static const BT_EXP_ADD:int = 6;
      
      public static const BT_TURN_CARD:int = 7;
      
      public static const ENTER_ENDLESS:int = 8;
      
      public static const COPY_EXP_ADD:int = 9;
      
      public static const COPY_RELIVE:int = 10;
      
      public static const ENDLESS_RELIVE:int = 11;
      
      private static var _instance:VipManager = null;
      
      private var _levelPowerTipArr:Array = [];
      
      private var _levelRequreMoney:Array = [99,490,899,1799,2999,5999,9999,23999,49999,99999];
      
      private var _vipPowerData:VipPowerData = new VipPowerData();
      
      private var _MAX_VIP_LEVEL:int = 10;
      
      public function VipManager(param1:Single)
      {
         super();
         initPowerTip();
      }
      
      public static function get instance() : VipManager
      {
         if(_instance == null)
         {
            _instance = new VipManager(new Single());
         }
         return _instance;
      }
      
      private function initPowerTip() : void
      {
         _levelPowerTipArr[0] = [1,1,1,1,1,1,1,1,1,1];
         _levelPowerTipArr[1] = [1,1,1,1,1,1,1,1,1,1];
         _levelPowerTipArr[2] = [1,2,3,4,5,6,7,8,9,10];
         _levelPowerTipArr[3] = [5,8,10,12,15,18,25,32,36,40];
         _levelPowerTipArr[4] = [0,1,1,1,1,1,1,1,1,1];
         _levelPowerTipArr[5] = [0,1,2,3,3,4,4,5,5,6];
         _levelPowerTipArr[6] = [0,8,10,12,15,15,20,25,32,40];
         _levelPowerTipArr[7] = [0,0,1,1,1,1,1,1,1,1];
         _levelPowerTipArr[8] = [0,0,1,2,3,3,3,4,5,6];
         _levelPowerTipArr[9] = [0,0,5,5,8,12,15,18,21,26];
         _levelPowerTipArr[10] = [0,0,0,1,2,3,4,5,6,7];
         _levelPowerTipArr[11] = [0,0,0,0,1,2,3,4,5,6];
      }
      
      public function getLevelTipInfo(param1:int) : Array
      {
         var _loc7_:int = 0;
         var _loc3_:String = null;
         param1 -= 1;
         var _loc5_:int = int(_levelRequreMoney[param1]);
         var _loc4_:Array = [_loc5_];
         var _loc6_:String = "";
         var _loc2_:int = 1;
         _loc7_ = 0;
         while(_loc7_ < _levelPowerTipArr.length)
         {
            if(_levelPowerTipArr[_loc7_][param1] != 0)
            {
               _loc3_ = _loc2_ + "." + LangManager.replace("vipPowerTip" + _loc7_,_levelPowerTipArr[_loc7_][param1]);
               _loc6_ += _loc3_ + "\n";
               _loc2_++;
            }
            _loc7_++;
         }
         _loc4_.push(_loc6_);
         return _loc4_;
      }
      
      public function getVipPowerTimes(param1:int, param2:int = -1) : int
      {
         if(param2 == -1)
         {
            param2 = PlayerDataList.instance.selfData.vipLevel;
         }
         return _levelPowerTipArr[param1][param2 - 1];
      }
      
      public function reliveInEndless(param1:int, param2:int, param3:Function) : void
      {
         CopyServer.instance.vipFreeRelive(param1,param2,param3);
      }
      
      public function getSelfVipInfo() : void
      {
         GameServer.instance.onSomeOneVipLevel((function():*
         {
            var cb:Function;
            return cb = function(param1:Object):void
            {
               PlayerDataList.instance.selfData.vipLevel = param1.level;
            };
         })());
         GameServer.instance.getSomeOneVipLevel(PlayerDataList.instance.selfData.uid);
      }
      
      public function getVipViewInfo(param1:int, param2:Function) : void
      {
         GameServer.instance.getVipViewInfo(param1,param2);
      }
      
      public function get vipPowerData() : VipPowerData
      {
         return _vipPowerData;
      }
      
      public function get MAX_VIP_LEVEL() : int
      {
         return _levelRequreMoney.length;
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
