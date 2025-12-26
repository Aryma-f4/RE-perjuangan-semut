package com.boyaa.antwars.view.screen.chatRoom
{
   public class ChatList
   {
      
      private static var _instance:ChatList = null;
      
      private var _list:Vector.<ChatData> = null;
      
      private var _listSystem:Vector.<ChatData> = null;
      
      private var _listUnion:Vector.<ChatData> = null;
      
      private var _listWorld:Vector.<ChatData> = null;
      
      private var _listSingle:Vector.<ChatData> = null;
      
      private var maxNum:int = 20;
      
      public function ChatList()
      {
         super();
         _list = new Vector.<ChatData>();
         _listSystem = new Vector.<ChatData>();
         _listWorld = new Vector.<ChatData>();
         _listSingle = new Vector.<ChatData>();
         _listUnion = new Vector.<ChatData>();
         var _loc2_:String = "[union]|this is a test message";
         var _loc1_:String = "[世界]|7个隆冬强:MM,你的QQ是多少?";
      }
      
      public static function get instance() : ChatList
      {
         if(_instance == null)
         {
            _instance = new ChatList();
         }
         return _instance;
      }
      
      public function addData(param1:String, param2:int = 1) : void
      {
         var _loc3_:ChatData = new ChatData();
         _loc3_.readData(param1,param2);
         _list.push(_loc3_);
      }
      
      public function addSystemData(param1:String) : void
      {
         var _loc2_:ChatData = new ChatData();
         _loc2_.readData(param1);
         _listSystem.push(_loc2_);
      }
      
      public function addUnionData(param1:String) : void
      {
         var _loc2_:ChatData = new ChatData();
         _loc2_.readData(param1);
         _listUnion.push(_loc2_);
      }
      
      public function addSingleData(param1:String, param2:int = 1) : void
      {
         var _loc3_:ChatData = new ChatData();
         _loc3_.readData(param1,param2);
         _listSingle.push(_loc3_);
      }
      
      public function addWorldData(param1:String, param2:int = 1) : void
      {
         var _loc3_:ChatData = new ChatData();
         _loc3_.readData(param1,param2);
         _listWorld.push(_loc3_);
      }
      
      public function getChatListData() : Vector.<ChatData>
      {
         if(_list.length > 20)
         {
            _list.shift();
         }
         return _list;
      }
      
      public function getSystemListData() : Vector.<ChatData>
      {
         if(_listSystem.length > 20)
         {
            _listSystem.shift();
         }
         return _listSystem;
      }
      
      public function getUnionListData() : Vector.<ChatData>
      {
         if(_listUnion.length > 20)
         {
            _listUnion.shift();
         }
         return _listUnion;
      }
      
      public function getWorldListData() : Vector.<ChatData>
      {
         if(_listWorld.length > 20)
         {
            _listWorld.shift();
         }
         return _listWorld;
      }
      
      public function getSingleListData() : Vector.<ChatData>
      {
         if(_listSingle.length > 20)
         {
            _listSingle.shift();
         }
         return _listSingle;
      }
   }
}

