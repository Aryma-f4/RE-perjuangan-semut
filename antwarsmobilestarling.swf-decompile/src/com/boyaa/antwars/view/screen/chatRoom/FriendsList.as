package com.boyaa.antwars.view.screen.chatRoom
{
   import com.boyaa.antwars.net.Remoting;
   
   public class FriendsList
   {
      
      private static var _instance:FriendsList = null;
      
      private var _list:Vector.<FriendData> = null;
      
      private var _listAboutme:Array = [];
      
      public var needLoad:Boolean = true;
      
      private var _isLoadedAboutMe:Boolean = false;
      
      private var _onlineList:Vector.<FriendData>;
      
      public function FriendsList()
      {
         super();
         _list = new Vector.<FriendData>();
      }
      
      public static function get instance() : FriendsList
      {
         if(_instance == null)
         {
            _instance = new FriendsList();
         }
         return _instance;
      }
      
      public function isFriend(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _list.length)
         {
            if(_list[_loc2_].antId == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function addDataAboutme(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = int(_listAboutme.length);
         if(_loc2_ == 0)
         {
            _listAboutme.push(param1);
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(param1 != _listAboutme[_loc3_])
               {
                  _listAboutme.push(param1);
               }
               _loc3_++;
            }
         }
      }
      
      public function addData(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:FriendData = null;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = new FriendData();
            _loc2_.readPHPData(param1[_loc3_]);
            _list.push(_loc2_);
            _loc3_++;
         }
      }
      
      public function resetMyFriendsList(param1:Function) : void
      {
         var callBack:Function = param1;
         Remoting.instance.getFirends(1,(function():*
         {
            var delay:Function;
            return delay = function(param1:Object):void
            {
               _list.length = 0;
               FriendsList.instance.addData(param1 as Array);
               FriendsList.instance.needLoad = false;
               if(callBack != null)
               {
                  callBack();
               }
            };
         })());
      }
      
      public function addFriends(param1:FriendData) : void
      {
         _list.push(param1);
      }
      
      public function removeFriends(param1:FriendData) : void
      {
         var _loc2_:int = int(_list.indexOf(param1));
         if(_loc2_ != -1)
         {
            _list.splice(_loc2_,1);
         }
      }
      
      public function getFriendByUID(param1:int) : FriendData
      {
         var _loc3_:int = 0;
         var _loc2_:FriendData = null;
         _loc3_ = 0;
         while(_loc3_ < _list.length)
         {
            _loc2_ = _list[_loc3_];
            if(_loc2_.antId == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function aryToList(param1:Array) : Vector.<FriendData>
      {
         var _loc3_:int = 0;
         var _loc2_:FriendData = null;
         _onlineList = new Vector.<FriendData>();
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = new FriendData();
            _loc2_.readData(param1[_loc3_]);
            _onlineList.push(_loc2_);
            _loc3_++;
         }
         return _onlineList;
      }
      
      public function getOnlinePlayerByUID(param1:int) : FriendData
      {
         var _loc2_:int = 0;
         if(_onlineList == null)
         {
            return null;
         }
         _loc2_ = 0;
         while(_loc2_ < _onlineList.length)
         {
            if(_onlineList[_loc2_].antId == param1)
            {
               return _onlineList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getFriendListData() : Vector.<FriendData>
      {
         return _list;
      }
      
      public function getNoMarryFriendListData(param1:int = -1) : Vector.<FriendData>
      {
         var _loc4_:int = 0;
         var _loc3_:FriendData = null;
         var _loc2_:Vector.<FriendData> = new Vector.<FriendData>();
         _loc4_ = 0;
         while(_loc4_ < _list.length)
         {
            _loc3_ = _list[_loc4_];
            if(_loc3_.marrayState == 3 && _loc3_.sex != param1)
            {
               _loc2_.push(_loc3_);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function getListAboutme() : Array
      {
         return _listAboutme;
      }
      
      public function getDataAboutme(param1:int) : Object
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _listAboutme.length)
         {
            if(param1 == (_listAboutme[_loc2_] as Array)[0])
            {
               return _listAboutme[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function isLoadedAboutMe(param1:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Array = null;
         _loc3_ = 0;
         while(_loc3_ < _listAboutme.length)
         {
            _loc2_ = _listAboutme[_loc3_] as Array;
            if(_loc2_ && param1 == _loc2_[0])
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
   }
}

