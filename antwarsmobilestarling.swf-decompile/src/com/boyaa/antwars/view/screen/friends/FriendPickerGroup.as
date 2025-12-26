package com.boyaa.antwars.view.screen.friends
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.helper.tools.PickerButtonsInUIExport;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.PersonnalInfoDlg;
   import com.boyaa.antwars.view.screen.chatRoom.ChatRoomDlg;
   import com.boyaa.antwars.view.screen.chatRoom.FriendsList;
   import com.boyaa.tool.LoadData;
   import flash.geom.Point;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class FriendPickerGroup
   {
      
      public static const CHAT:int = 0;
      
      public static const PLAYERDATA:int = 1;
      
      public static const ADD_FRIEND:int = 2;
      
      public static const DELETE_FRIEND:int = 3;
      
      private static var _showPoint:Point = new Point(0,0);
      
      private var _popWindow:PickerButtonsInUIExport;
      
      private var _playerUID:int;
      
      private var _aboutMe:PersonnalInfoDlg;
      
      private var _currentIndex:int = 0;
      
      public function FriendPickerGroup()
      {
         super();
         initUI();
      }
      
      public function show(param1:int) : void
      {
         _playerUID = param1;
         if(_playerUID == PlayerDataList.instance.selfData.uid)
         {
            _popWindow.showButtonById([1]);
         }
         else if(FriendsList.instance.getFriendByUID(_playerUID) != null)
         {
            _popWindow.showButtonById([0,1]);
         }
         else
         {
            _popWindow.showButtonById([0,1,2]);
         }
         _popWindow.x = _showPoint.x;
         _popWindow.y = _showPoint.y;
         Application.instance.currentGame.stage.addChild(_popWindow);
      }
      
      public function hide() : void
      {
         LoadData.hide();
         _popWindow.removeFromParent();
      }
      
      public function dispose() : void
      {
         removeEvent();
         _popWindow.removeFromParent(true);
      }
      
      private function addEvent() : void
      {
         Application.instance.currentGame.stage.addEventListener("touch",onTouchHandle);
      }
      
      private function removeEvent() : void
      {
         Application.instance.currentGame.stage.removeEventListener("touch",onTouchHandle);
      }
      
      private function onTouchHandle(param1:TouchEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc5_:* = undefined;
         var _loc4_:Vector.<Touch> = param1.getTouches(Application.instance.currentGame.stage);
         if(_loc4_.length > 0 && _loc4_[0].phase == "began")
         {
            _loc2_ = _loc4_[0].globalY;
            _loc3_ = _loc4_[0].globalX;
            if(_loc2_ >= 768 - _popWindow.height)
            {
               _loc2_ = 768 - _popWindow.height;
            }
            _showPoint.setTo(_loc3_,_loc2_);
            if(_popWindow.parent)
            {
               _loc5_ = param1.getTouches(_popWindow);
               if(_loc5_.length == 0)
               {
                  hide();
               }
            }
         }
      }
      
      private function initUI() : void
      {
         var _loc2_:int = 0;
         _popWindow = new PickerButtonsInUIExport("FriendDlg","FriendButtonsLayout",4);
         var _loc1_:Array = [onSingle,onAboutMe,onAdd];
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _popWindow.getButtonById(_loc2_).triggerFunction = _loc1_[_loc2_];
            _loc2_++;
         }
         addEvent();
      }
      
      private function onAdd(param1:Event) : void
      {
         var e:Event = param1;
         _currentIndex = 2;
         LoadData.show();
         Remoting.instance.addFriend(_playerUID,(function():*
         {
            var callBack:Function;
            return callBack = function(param1:Object):void
            {
               Application.instance.log("FriendPickerGroup","add friend done!");
               if(param1 == 0)
               {
                  TextTip.instance.showByLang("teamList6");
                  FriendsList.instance.resetMyFriendsList(null);
               }
               hide();
            };
         })());
      }
      
      private function getPlayerInfo(param1:Object) : void
      {
         var _loc2_:ChatRoomDlg = null;
         Application.instance.log("AboutMe显示人个信息:",JSON.stringify(param1));
         switch(_currentIndex)
         {
            case 0:
               _loc2_ = ChatRoomDlg.getInstance();
               Application.instance.currentGame.stage.addChild(_loc2_);
               _loc2_.visible = true;
               _loc2_.setCurrentFace("3");
               _loc2_.talkWithFriend(param1[1]["mrolename"],_playerUID);
               break;
            case 1:
               _aboutMe.showPlayerInfo(param1);
               Application.instance.currentGame.stage.addChild(_aboutMe);
         }
         hide();
      }
      
      private function onAboutMe(param1:Event) : void
      {
         LoadData.show();
         _currentIndex = 1;
         if(_aboutMe == null)
         {
            _aboutMe = new PersonnalInfoDlg();
         }
         Remoting.instance.getMemStatus(_playerUID,getPlayerInfo);
      }
      
      private function onSingle(param1:Event) : void
      {
         LoadData.show();
         _currentIndex = 0;
         Remoting.instance.getMemStatus(_playerUID,getPlayerInfo);
      }
   }
}

