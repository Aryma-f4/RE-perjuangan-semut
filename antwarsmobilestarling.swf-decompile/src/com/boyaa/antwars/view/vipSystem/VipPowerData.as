package com.boyaa.antwars.view.vipSystem
{
   import com.boyaa.antwars.data.PlayerDataList;
   
   public class VipPowerData
   {
      
      private var _endlessReliveTime:int = 0;
      
      private var _freeEnterEndlessTime:int = 0;
      
      private var _unionWorShipTime:int = 0;
      
      private var _copyReliveTime:int = 0;
      
      private var _autoFightTime:int = 0;
      
      public function VipPowerData()
      {
         super();
      }
      
      public function get endlessReliveTime() : int
      {
         return _endlessReliveTime;
      }
      
      public function set endlessReliveTime(param1:int) : void
      {
         _endlessReliveTime = param1;
      }
      
      public function get freeEnterEndlessTime() : int
      {
         return _freeEnterEndlessTime;
      }
      
      public function set freeEnterEndlessTime(param1:int) : void
      {
         _freeEnterEndlessTime = param1;
      }
      
      public function get unionWorShipTime() : int
      {
         return _unionWorShipTime;
      }
      
      public function set unionWorShipTime(param1:int) : void
      {
         _unionWorShipTime = param1;
      }
      
      public function get copyReliveTime() : int
      {
         return _copyReliveTime;
      }
      
      public function set copyReliveTime(param1:int) : void
      {
         _copyReliveTime = param1;
      }
      
      public function get myVipLevel() : int
      {
         return PlayerDataList.instance.selfData.vipLevel;
      }
      
      public function get autoFightTime() : int
      {
         return _autoFightTime;
      }
      
      public function set autoFightTime(param1:int) : void
      {
         _autoFightTime = param1;
      }
   }
}

