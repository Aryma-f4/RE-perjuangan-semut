package com.boyaa.antwars.data.model
{
   public class MapData
   {
      
      private var _mapId:int = 0;
      
      private var _mapName:String = "";
      
      private var _dLevel:int = 0;
      
      private var _type:int = 0;
      
      private const DATA_TYPE:Array = ["mapId","mapName","dLevel","type"];
      
      private const DATA_XML:Array = ["mapid","mapname","dlevel","type"];
      
      public function MapData()
      {
         super();
      }
      
      public function updateForData(param1:XML) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < DATA_TYPE.length)
         {
            if(this["_" + DATA_TYPE[_loc2_]] is int)
            {
               this["_" + DATA_TYPE[_loc2_]] = int(param1[DATA_XML[_loc2_]]);
            }
            else
            {
               this["_" + DATA_TYPE[_loc2_]] = param1[DATA_XML[_loc2_]];
            }
            _loc2_++;
         }
      }
      
      public function addData(param1:Array) : void
      {
         _mapId = param1[0];
         _mapName = param1[1];
         _dLevel = param1[2];
         _type = param1[3];
      }
      
      public function get id() : int
      {
         return _mapId;
      }
      
      public function get name() : String
      {
         return _mapName;
      }
      
      public function get level() : int
      {
         return _dLevel;
      }
      
      public function get type() : int
      {
         return _type;
      }
      
      public function set type(param1:int) : void
      {
         _type = param1;
      }
   }
}

