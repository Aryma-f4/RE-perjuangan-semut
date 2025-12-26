package com.boyaa.antwars.view.screen.chatRoom
{
   public class FriendData
   {
      
      private static const DATA_TYPE_SERVER:Array = ["antId","nickName","level","invited","marrayState"];
      
      private static const DATA_TYPE_PHP:Array = ["antId","level","nickName","sex","marrayState"];
      
      private var _antId:int;
      
      private var _nickName:String;
      
      private var _level:int;
      
      private var _sex:int;
      
      private var _invited:int;
      
      private var _marrayState:int = 3;
      
      private var _enbale:Boolean = true;
      
      public function FriendData()
      {
         super();
      }
      
      public function readData(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:String = null;
         _loc3_ = 0;
         while(_loc3_ < DATA_TYPE_SERVER.length)
         {
            _loc2_ = DATA_TYPE_SERVER[_loc3_];
            if(param1[_loc3_])
            {
               this["_" + _loc2_] = param1[_loc3_];
            }
            else
            {
               this["_" + _loc2_] = false;
            }
            _loc3_++;
         }
      }
      
      public function readPHPData(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:String = null;
         _loc3_ = 0;
         while(_loc3_ < DATA_TYPE_PHP.length)
         {
            _loc2_ = DATA_TYPE_PHP[_loc3_];
            this["_" + _loc2_] = param1[_loc3_];
            _loc3_++;
         }
      }
      
      public function get antId() : int
      {
         return _antId;
      }
      
      public function set antId(param1:int) : void
      {
         _antId = param1;
      }
      
      public function get nickName() : String
      {
         return _nickName;
      }
      
      public function set nickName(param1:String) : void
      {
         _nickName = param1;
      }
      
      public function get level() : int
      {
         return _level;
      }
      
      public function set level(param1:int) : void
      {
         _level = param1;
      }
      
      public function get invited() : int
      {
         return _invited;
      }
      
      public function set invited(param1:int) : void
      {
         _invited = param1;
      }
      
      public function get enbale() : Boolean
      {
         return _enbale;
      }
      
      public function set enbale(param1:Boolean) : void
      {
         _enbale = param1;
      }
      
      public function get marrayState() : int
      {
         return _marrayState;
      }
      
      public function get sex() : int
      {
         return _sex;
      }
   }
}

