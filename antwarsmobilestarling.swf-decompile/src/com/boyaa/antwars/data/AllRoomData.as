package com.boyaa.antwars.data
{
   import com.boyaa.antwars.data.model.ServerData;
   import com.boyaa.tool.RandomNum;
   
   public class AllRoomData
   {
      
      private static var _instance:AllRoomData = null;
      
      private var _serverList:Array;
      
      public var roomID:int = 0;
      
      public var mapID:int = 0;
      
      public var mapULR:String = "";
      
      public var key:String = "";
      
      public var serverRoom:int = 0;
      
      public var musicrul:String = "";
      
      public var musicULR:String = "";
      
      public var roomType:uint = 0;
      
      public var roomlevel:uint = 0;
      
      public var ticket:uint = 0;
      
      private var _gameServerList:Array = null;
      
      private var _matchServerList:Array = null;
      
      public var wellServer:int = 0;
      
      public var centerServer:Array = [];
      
      private var _curServer:int = -1;
      
      public var proxyServer:Array = [];
      
      public function AllRoomData(param1:Single)
      {
         super();
         _serverList = [];
         _gameServerList = [];
         _matchServerList = [];
      }
      
      public static function get instance() : AllRoomData
      {
         if(_instance == null)
         {
            _instance = new AllRoomData(new Single());
         }
         return _instance;
      }
      
      public function getcenterServer() : Array
      {
         if(_curServer == -1)
         {
            RandomNum.setNext(PlayerDataList.instance.selfData.uid);
            _curServer = RandomNum.myrand(0,centerServer.length - 1);
         }
         else
         {
            _curServer = _curServer + 1;
            if(_curServer >= centerServer.length)
            {
               _curServer = 0;
            }
         }
         return centerServer[_curServer];
      }
      
      public function addRoom(param1:XML) : void
      {
         var _loc3_:int = 0;
         var _loc2_:ServerData = null;
         _loc3_ = 0;
         while(_loc3_ < param1.server.length())
         {
            _loc2_ = new ServerData();
            if(_loc2_.updateForData(param1.server[_loc3_]))
            {
               _serverList.push(_loc2_);
            }
            _loc3_++;
         }
         param1 = null;
      }
      
      public function getDataByID(param1:int) : ServerData
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _serverList.length)
         {
            if((_serverList[_loc2_] as ServerData).serverID == param1)
            {
               return _serverList[_loc2_];
            }
            _loc2_++;
         }
         return new ServerData();
      }
      
      public function getDataByType(param1:int) : ServerData
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _serverList.length)
         {
            if((_serverList[_loc2_] as ServerData).svtype == param1)
            {
               return _serverList[_loc2_];
            }
            _loc2_++;
         }
         return new ServerData();
      }
      
      public function getSerByRoomID(param1:int, param2:int) : ServerData
      {
         var _loc4_:int = 0;
         var _loc3_:ServerData = null;
         _loc4_ = 0;
         while(_loc4_ < _serverList.length)
         {
            _loc3_ = _serverList[_loc4_] as ServerData;
            if(_loc3_.inRoomList(param1,param2))
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function addRoomInServer(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:ServerData = null;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = new ServerData();
            _loc2_.addData(param1[_loc3_]);
            _serverList.push(_loc2_);
            _loc3_++;
         }
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
