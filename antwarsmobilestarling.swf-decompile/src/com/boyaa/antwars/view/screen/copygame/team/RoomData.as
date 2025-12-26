package com.boyaa.antwars.view.screen.copygame.team
{
   public class RoomData
   {
      
      private var _roomId:int;
      
      private var _roomName:String;
      
      private var _roomOwner:String;
      
      private var _roomMember:String;
      
      private var _num:int = 0;
      
      private var _totalNum:int = 0;
      
      private var _roomState:int;
      
      public function RoomData()
      {
         super();
      }
      
      public function readData(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _roomId = param1[0];
            _roomName = param1[1];
            _roomOwner = param1[2];
            _num = param1[3];
            _totalNum = param1[4];
            _roomMember = param1[3] + "/" + param1[4];
            _roomState = param1[5];
            _loc3_++;
         }
      }
      
      public function get roomId() : Number
      {
         return _roomId;
      }
      
      public function set roomId(param1:Number) : void
      {
         _roomId = param1;
      }
      
      public function get roomName() : String
      {
         return _roomName;
      }
      
      public function set roomName(param1:String) : void
      {
         _roomName = param1;
      }
      
      public function get roomOwner() : String
      {
         return _roomOwner;
      }
      
      public function set roomOwner(param1:String) : void
      {
         _roomOwner = param1;
      }
      
      public function get roomMember() : String
      {
         return _roomMember;
      }
      
      public function set roomMember(param1:String) : void
      {
         _roomMember = param1;
      }
      
      public function get roomState() : int
      {
         return _roomState;
      }
      
      public function set roomState(param1:int) : void
      {
         _roomState = param1;
      }
      
      public function get totalNum() : int
      {
         return _totalNum;
      }
      
      public function set totalNum(param1:int) : void
      {
         _totalNum = param1;
      }
      
      public function get num() : int
      {
         return _num;
      }
      
      public function set num(param1:int) : void
      {
         _num = param1;
      }
   }
}

