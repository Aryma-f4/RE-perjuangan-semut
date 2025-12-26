package com.boyaa.antwars.view.screen.battlefield.btRoomItem
{
   public class BtRoomData
   {
      
      private var _roomId:int;
      
      private var _isLock:Boolean;
      
      private var _password:String;
      
      private var _mode:int;
      
      private var _type:int;
      
      private var _roomName:String;
      
      private var _currentPlayer:int;
      
      private var _maxPlayer:int;
      
      private var _isJoin:int;
      
      private var _isFight:int;
      
      public function BtRoomData(param1:Array)
      {
         super();
         _roomId = param1[0];
         _mode = param1[3];
         _type = param1[4];
         _roomName = param1[2];
         _isJoin = param1[8];
         _password = param1[9];
         if(_password != "")
         {
            _isLock = true;
         }
         _isFight = param1[7];
         _currentPlayer = param1[5];
         _maxPlayer = param1[6];
      }
      
      public function get roomId() : int
      {
         return _roomId;
      }
      
      public function get isLock() : Boolean
      {
         return _isLock;
      }
      
      public function get mode() : int
      {
         return _mode;
      }
      
      public function set mode(param1:int) : void
      {
         _mode = param1;
      }
      
      public function get roomName() : String
      {
         return _roomName;
      }
      
      public function get isJoin() : int
      {
         return _isJoin;
      }
      
      public function get type() : int
      {
         return _type;
      }
      
      public function get isFight() : int
      {
         return _isFight;
      }
      
      public function get currentPlayer() : int
      {
         return _currentPlayer;
      }
      
      public function get maxPlayer() : int
      {
         return _maxPlayer;
      }
   }
}

