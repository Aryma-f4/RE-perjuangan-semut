package com.boyaa.antwars.view.screen.copygame.team
{
   public class RoomListData
   {
      
      private static var _instance:RoomListData = null;
      
      private var _list:Vector.<RoomData> = null;
      
      public function RoomListData()
      {
         super();
         _list = new Vector.<RoomData>();
      }
      
      public static function get instance() : RoomListData
      {
         if(_instance == null)
         {
            _instance = new RoomListData();
         }
         return _instance;
      }
      
      public function addListData(param1:Array) : void
      {
         var _loc2_:RoomData = new RoomData();
         _loc2_.readData(param1);
         _list.push(_loc2_);
         trace(_loc2_,_list.length);
      }
      
      public function get list() : Vector.<RoomData>
      {
         return _list;
      }
   }
}

