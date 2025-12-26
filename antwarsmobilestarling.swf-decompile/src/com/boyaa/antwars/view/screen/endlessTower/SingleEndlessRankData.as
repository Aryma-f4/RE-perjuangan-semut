package com.boyaa.antwars.view.screen.endlessTower
{
   public class SingleEndlessRankData
   {
      
      private var _rank:int;
      
      private var _playerName:String;
      
      private var _fightNum:uint;
      
      private var _levelNum:uint;
      
      private var _playerUID:int;
      
      public function SingleEndlessRankData(param1:int, param2:int, param3:String, param4:uint, param5:uint)
      {
         super();
         _playerUID = param1;
         _rank = param2;
         _playerName = param3;
         _fightNum = param4;
         _levelNum = param5;
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
      
      public function get levelNum() : uint
      {
         return _levelNum;
      }
      
      public function get playerUID() : int
      {
         return _playerUID;
      }
   }
}

