package com.boyaa.antwars.view.screen.rankList
{
   public class SingleRankData
   {
      
      private var _rank:int;
      
      private var _playerName:String;
      
      private var _fightNum:uint;
      
      private var _isCanReward:Boolean = false;
      
      private var _isReward:Boolean = false;
      
      private var _playerUID:int;
      
      private var _vipLevel:int;
      
      public function SingleRankData(param1:int, param2:int, param3:String, param4:uint, param5:Boolean = false, param6:Boolean = false, param7:int = 0)
      {
         super();
         _rank = param2;
         _playerName = param3;
         _fightNum = param4;
         _isCanReward = param5;
         _isReward = param6;
         _playerUID = param1;
         _vipLevel = param7;
      }
      
      public function get rank() : int
      {
         return _rank;
      }
      
      public function get playerName() : String
      {
         return _playerName;
      }
      
      public function get fightNum() : uint
      {
         return _fightNum;
      }
      
      public function get isReward() : Boolean
      {
         return _isReward;
      }
      
      public function get isCanReward() : Boolean
      {
         return _isCanReward;
      }
      
      public function get playerUID() : int
      {
         return _playerUID;
      }
      
      public function get vipLevel() : int
      {
         return _vipLevel;
      }
   }
}

