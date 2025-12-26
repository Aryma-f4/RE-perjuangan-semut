package com.boyaa.antwars.data
{
   public class UnionShopData
   {
      
      private var _typeID:int = 0;
      
      private var _frameID:int = 0;
      
      private var _placelevel:int = 0;
      
      private const DATA_TYPE:Array = ["typeID","frameID","placelevel"];
      
      private const DATA_XML:Array = ["pcate","pframe","placelevel"];
      
      public function UnionShopData()
      {
         super();
      }
      
      public function updateForData(param1:XML) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < DATA_TYPE.length)
         {
            this["_" + DATA_TYPE[_loc2_]] = param1[DATA_XML[_loc2_]];
            _loc2_++;
         }
      }
      
      public function get typeID() : int
      {
         return _typeID;
      }
      
      public function get frameID() : int
      {
         return _frameID;
      }
      
      public function get placelevel() : int
      {
         return _placelevel;
      }
   }
}

