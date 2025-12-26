package com.boyaa.antwars.data.model
{
   import com.boyaa.antwars.data.AllRoomData;
   
   public class ServerData
   {
      
      private var _serverID:int = 0;
      
      private var _ipArr:Array = [];
      
      private var _port:int = 0;
      
      private var _svtype:int = 0;
      
      private var _startRoomId:int = 0;
      
      private var _endRoomId:int = 0;
      
      private var _mgid:int = 0;
      
      private const DATA_TYPE:Array = ["serverID","ip","port","svtype","startRoomId","endRoomId","mgid"];
      
      private const DATA_XML:Array = ["svid","svip","svport","svtype","startRoomId","endRoomId","mgid"];
      
      public function ServerData()
      {
         super();
      }
      
      public function addData(param1:Array) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _serverID = param1[0];
            _svtype = param1[1];
            _ipArr.push(param1[2]);
            _port = param1[3];
            _startRoomId = param1[4];
            _endRoomId = param1[5];
            _loc2_++;
         }
      }
      
      public function inRoomList(param1:int, param2:int) : Boolean
      {
         if(_svtype != param2)
         {
            return false;
         }
         if(_startRoomId <= param1)
         {
            if(_endRoomId >= param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function updateForData(param1:XML) : Boolean
      {
         var _loc2_:int = 0;
         if(int(param1[DATA_XML[6]]) != Constants.mgid)
         {
            return false;
         }
         _loc2_ = 0;
         while(_loc2_ < DATA_TYPE.length)
         {
            if(DATA_TYPE[_loc2_] == "ip")
            {
               _ipArr = String(param1[DATA_XML[_loc2_]]).split("|");
            }
            else if(this["_" + DATA_TYPE[_loc2_]] is int)
            {
               this["_" + DATA_TYPE[_loc2_]] = int(param1[DATA_XML[_loc2_]]);
            }
            else
            {
               this["_" + DATA_TYPE[_loc2_]] = param1[DATA_XML[_loc2_]];
            }
            _loc2_++;
         }
         return true;
      }
      
      public function get ip() : String
      {
         if(AllRoomData.instance.wellServer >= _ipArr.length)
         {
            return _ipArr[0];
         }
         return _ipArr[AllRoomData.instance.wellServer];
      }
      
      public function get port() : int
      {
         return _port;
      }
      
      public function get serverID() : int
      {
         return _serverID;
      }
      
      public function set port(param1:int) : void
      {
         _port = param1;
      }
      
      public function get svtype() : int
      {
         return _svtype;
      }
      
      public function set svtype(param1:int) : void
      {
         _svtype = param1;
      }
   }
}

