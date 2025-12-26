package com.boyaa.antwars.view.screen.friends
{
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.helper.tools.PickerButtonsInUIExport;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.PersonnalInfoDlg;
   import com.boyaa.antwars.view.screen.chatRoom.ChatRoomDlg;
   import com.boyaa.antwars.view.screen.chatRoom.FriendData;
   import com.boyaa.antwars.view.screen.chatRoom.FriendListItemRender;
   import com.boyaa.antwars.view.screen.chatRoom.FriendsList;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideEventManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import com.boyaa.tool.LoadData;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.layout.VerticalLayout;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class FriendsDlg extends UIExportSprite implements IGuideProcess
   {
      
      private var myFriendsData:ListCollection;
      
      private var onLineUserData:ListCollection;
      
      private var list:List;
      
      private var friendData:FriendData;
      
      private var nickName:String = "test";
      
      private var mid:int = 1;
      
      private var markBg:DlgMark;
      
      private var aboutme:PersonnalInfoDlg;
      
      private var selectState:int = 0;
      
      private var pos:Number = 0;
      
      private var _onlinePlayerBtn:FashionStarlingButton;
      
      private var _friendBtn:FashionStarlingButton;
      
      private var _loadText:TextField;
      
      private var _popWindow:PickerButtonsInUIExport;
      
      public function FriendsDlg()
      {
         super();
         init();
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function init() : void
      {
         markBg = new DlgMark();
         initAll();
      }
      
      private function initAll() : void
      {
         buildLayout("FriendDlg","FriendDlg");
         initNewUI();
         addList();
         addPopWindow();
      }
      
      private function loading(param1:Number) : void
      {
         if(param1 == 1)
         {
            initAll();
            Application.instance.currentGame.hiddenLoading();
         }
      }
      
      private function initNewUI() : void
      {
         _onlinePlayerBtn = new FashionStarlingButton(getButtonByName("onlineBtn"));
         _friendBtn = new FashionStarlingButton(getButtonByName("friendBtn"));
         _onlinePlayerBtn.groupTag = _friendBtn.groupTag = "FriendDlgSelect";
         _friendBtn.isSelect = true;
         _onlinePlayerBtn.triggerFunction = showOnlinePlayer;
         _friendBtn.triggerFunction = showAllFriends;
         addCloseButtonEvent();
         _loadText = getTextFieldByName("loadText");
         _loadText.text = LangManager.t("upLoad");
         _loadText.visible = false;
      }
      
      private function addList() : void
      {
         list = new List();
         onLineUserData = new ListCollection();
         myFriendsData = new ListCollection();
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 8;
         list.layout = _loc1_;
         list.horizontalScrollPolicy = "off";
         list.itemRendererType = FriendListItemRender;
         list.addEventListener("change",listChangeHandler);
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("pos_list"),list);
         _displayObj.addChild(list);
      }
      
      private function addPopWindow() : void
      {
         var _loc2_:int = 0;
         _popWindow = new PickerButtonsInUIExport("FriendDlg","FriendButtonsLayout",4);
         var _loc1_:Array = [onSingle,onAboutMe,onAdd,onDelete];
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _popWindow.getButtonById(_loc2_).triggerFunction = _loc1_[_loc2_];
            _loc2_++;
         }
         _popWindow.visible = false;
         _popWindow.x = _displayObj.width / 2 + 40;
         _displayObj.addChild(_popWindow);
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         var event:Event = param1;
         parent.addChild(markBg);
         parent.swapChildren(markBg,this);
         this.stage.addEventListener("touch",onTouch);
         list.visible = false;
         this.pivotX = _displayObj.width / 2;
         this.pivotY = _displayObj.height / 2;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.4,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeInOut",
            "onComplete":function():void
            {
               list.visible = true;
               guideProcess();
            }
         });
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:Vector.<Touch> = param1.getTouches(this.stage);
         if(_loc2_.length > 0 && _loc2_[0].phase == "began")
         {
            _loc3_ = param1.getTouches(list);
            if(_loc3_.length > 0 && _loc3_[0].phase == "began")
            {
               pos = getItemY(_loc3_[0].globalY);
            }
            if(_popWindow)
            {
               _loc4_ = param1.getTouches(_popWindow);
               if(_loc4_.length == 0)
               {
                  showPopWindow(false);
                  list.selectedIndex = -1;
               }
            }
         }
      }
      
      private function showPopWindow(param1:Boolean) : void
      {
         _popWindow.visible = param1;
         if(!param1)
         {
            _popWindow.y = 0;
         }
         else
         {
            _popWindow.y = pos;
         }
      }
      
      private function listChangeHandler(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         onSelectedItem(_loc2_.selectedItem);
      }
      
      private function onSelectedItem(param1:*) : void
      {
         friendData = param1 as FriendData;
         nickName = friendData.nickName;
         mid = friendData.antId;
         if(selectState == 1)
         {
            if(FriendsList.instance.isFriend(mid))
            {
               _popWindow.showButtonById([2,3],false);
            }
            else
            {
               _popWindow.showButtonById([3],false);
            }
         }
         else
         {
            _popWindow.showButtonById([2],false);
         }
         showPopWindow(true);
         _popWindow.alpha = 0;
         Starling.juggler.tween(_popWindow,0.6,{
            "alpha":1,
            "transition":"easeOutBack"
         });
      }
      
      override protected function onCloseHandle(param1:Event) : void
      {
         Guide.instance.onBackHall();
         list.visible = false;
         Starling.juggler.tween(this,0.2,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeIn",
            "onComplete":remove
         });
      }
      
      private function remove() : void
      {
         Starling.juggler.removeTweens(this);
         this.stage.removeEventListener("touch",onTouch);
         markBg.removeFromParent();
         removeFromParent();
      }
      
      private function showAllFriends(param1:Event) : void
      {
         FriendsList.instance.resetMyFriendsList(null);
         selectState = 0;
         list.dataProvider = myFriendsData;
         _loadText.visible = false;
      }
      
      private function showOnlinePlayer(param1:Event) : void
      {
         var evt:Event = param1;
         selectState = 1;
         _loadText.visible = true;
         GameServer.instance.getOnlineUser(function(param1:Object):void
         {
            Application.instance.log("FriendsDlg",JSON.stringify(param1));
            if(param1["ret"] == 0)
            {
               _loadText.visible = false;
               onLineUserData.data = FriendsList.instance.aryToList(param1.friendsArr);
               list.dataProvider = onLineUserData;
            }
         });
      }
      
      private function onSingle(param1:Event) : void
      {
         openChatRoom();
      }
      
      private function onDelete(param1:Event) : void
      {
         var data:FriendData;
         var evt:Event = param1;
         showPopWindow(false);
         data = list.selectedItem as FriendData;
         Remoting.instance.deleteFriend(data.antId,function(param1:Object):void
         {
            Application.instance.log("FriendsDlg",JSON.stringify(param1));
            if(param1 == true)
            {
               TextTip.instance.showByLang("teamList7");
               FriendsList.instance.removeFriends(data);
               myFriendsData.data = FriendsList.instance.getFriendListData().concat();
            }
            else
            {
               TextTip.instance.show("error code:" + param1.error);
            }
         });
      }
      
      private function onAdd(param1:Event) : void
      {
         showPopWindow(false);
         Remoting.instance.addFriend(mid,addFriendCallback);
      }
      
      private function onAboutMe(param1:Event) : void
      {
         showPopWindow(false);
         if(aboutme == null)
         {
            aboutme = new PersonnalInfoDlg();
         }
         updateAboutMe();
         parent.addChild(aboutme);
      }
      
      private function getPlayerInfo(param1:Object) : void
      {
         Application.instance.log("AboutMe显示人个信息:",JSON.stringify(param1));
         FriendsList.instance.addDataAboutme(param1);
         aboutme.showPlayerInfo(param1);
      }
      
      private function addFriendCallback(param1:Object) : void
      {
         FriendsList.instance.addFriends(friendData);
         myFriendsData.data = FriendsList.instance.getFriendListData().concat();
         TextTip.instance.showByLang("teamList6");
      }
      
      private function getItemY(param1:Number) : Number
      {
         var _loc2_:Number = NaN;
         if(param1 > 204 && param1 < 325)
         {
            _loc2_ = 220;
         }
         else if(param1 > 325 && param1 < 410)
         {
            _loc2_ = 300;
         }
         else if(param1 > 410 && param1 < 495)
         {
            _loc2_ = 385;
         }
         else if(param1 > 495 && param1 < 580)
         {
            _loc2_ = 465;
         }
         else if(param1 > 580 && param1 < 665)
         {
            _loc2_ = 400;
         }
         return _loc2_;
      }
      
      private function openChatRoom() : void
      {
         showPopWindow(false);
         var _loc1_:ChatRoomDlg = ChatRoomDlg.getInstance();
         parent.addChild(_loc1_);
         _loc1_.visible = true;
         _loc1_.setCurrentFace("3");
         _loc1_.talkWithFriend(nickName,mid);
         remove();
      }
      
      private function updateAboutMe() : void
      {
         var _loc1_:FriendData = list.selectedItem as FriendData;
         if(FriendsList.instance.isLoadedAboutMe(_loc1_.antId))
         {
            aboutme.showPlayerInfo(FriendsList.instance.getDataAboutme(_loc1_.antId));
         }
         else
         {
            Remoting.instance.getMemStatus(_loc1_.antId,getPlayerInfo);
         }
         trace("list.selectedItem" + list.selectedItem);
         if(list.selectedItem)
         {
            aboutme.setData(list.selectedItem as FriendData);
         }
      }
      
      public function resetFriendData() : void
      {
         LoadData.show();
         list.dataProvider = null;
         FriendsList.instance.resetMyFriendsList((function():*
         {
            var callBack:Function;
            return callBack = function():void
            {
               myFriendsData.data = FriendsList.instance.getFriendListData();
               list.dataProvider = myFriendsData;
               list.validate();
               LoadData.hide();
            };
         })());
      }
      
      override public function dispose() : void
      {
         trace("[dispose FriendsDlg...]");
         if(aboutme)
         {
            aboutme.dispose();
         }
         if(_popWindow)
         {
            _popWindow.removeFromParent();
         }
      }
      
      public function guideProcess(param1:Object = null) : void
      {
         var _loc2_:String = MissionGuideValue.instance.getMissionFlag();
         var _loc3_:* = _loc2_;
         if("friendMission" === _loc3_)
         {
            GuideEventManager.instance.dispactherEvent("newUI",[[_onlinePlayerBtn.starlingBtn,20],[list,30],[_friendBtn.starlingBtn,40]]);
         }
      }
   }
}

