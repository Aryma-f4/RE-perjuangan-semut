package com.boyaa.antwars.view.screen.copygame.team
{
   import com.boyaa.antwars.helper.tools.PickerButtonsInUIExport;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.chatRoom.ChatRoomDlg;
   import com.boyaa.antwars.view.screen.chatRoom.FriendData;
   import com.boyaa.antwars.view.screen.chatRoom.FriendsList;
   import com.boyaa.antwars.view.screen.friends.AboutMe;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import flash.events.TimerEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class InviteFriendsDlg extends Sprite
   {
      
      private var closeBtn:Button;
      
      private var list:List;
      
      private var listData:ListCollection;
      
      private var btnRefresh:Button;
      
      private var noPlayerTxt:TextField;
      
      private var selectedItem:FriendData;
      
      private var friendData:Vector.<FriendData>;
      
      private var timeSprite:Sprite;
      
      private var secondTxt:TextField;
      
      private var timer:Timer;
      
      private var timeArr:Array = ["[","]","CD:",LangManager.t("second")];
      
      private var second:int = 60;
      
      private var invitedSprite:Sprite;
      
      private var invitedTxt:TextField;
      
      private var optionVisible:Boolean = true;
      
      private var markBg:DlgMark;
      
      private var tipSprite:Sprite;
      
      private var _popWindow:PickerButtonsInUIExport;
      
      private var aboutme:AboutMe;
      
      public function InviteFriendsDlg()
      {
         super();
         init();
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function init() : void
      {
         var _loc7_:int = 0;
         var _loc1_:TextField = null;
         var _loc11_:int = 0;
         var _loc4_:TextField = null;
         var _loc3_:DropShadowFilter = new DropShadowFilter(0,45,0,1,1.2,1.2,20);
         var _loc9_:Array = [];
         _loc9_.push(_loc3_);
         markBg = new DlgMark();
         var _loc6_:Image = new Image(Assets.sAsset.getTexture("fb101"));
         Assets.positionDisplay(_loc6_,"inviteFriends","bg");
         addChild(_loc6_);
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("fb102"));
         Assets.positionDisplay(_loc2_,"inviteFriends","title");
         addChild(_loc2_);
         closeBtn = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         Assets.sAsset.positionDisplay(closeBtn,"inviteFriends","btn_close");
         closeBtn.addEventListener("triggered",onCloseBtn);
         addChild(closeBtn);
         var _loc12_:Image = new Image(Assets.sAsset.getTexture("fb103"));
         Assets.positionDisplay(_loc12_,"inviteFriends","title_bar");
         addChild(_loc12_);
         list = new List();
         listData = new ListCollection();
         list.dataProvider = listData;
         list.itemRendererType = InviteFriendItemRender;
         Assets.positionDisplay(list,"inviteFriends","item");
         list.addEventListener("change",onListChangeHandler);
         addChild(list);
         list.visible = false;
         var _loc8_:Rectangle = Assets.getPosition("inviteFriends","noPlayer");
         noPlayerTxt = new TextField(_loc8_.width,_loc8_.height,LangManager.t("noPlayer"),"Verdana",24,16777215);
         Assets.positionDisplay(noPlayerTxt,"inviteFriends","noPlayer");
         noPlayerTxt.nativeFilters = _loc9_;
         addChild(noPlayerTxt);
         noPlayerTxt.autoScale = true;
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("talk23"));
         _loc5_.touchable = false;
         Assets.positionDisplay(_loc5_,"inviteFriends","text_bg");
         addChild(_loc5_);
         timeSprite = new Sprite();
         _loc8_ = Assets.getPosition("inviteFriends","txtSecond");
         secondTxt = new TextField(_loc8_.width,_loc8_.height,"60","Verdana",24,16711680);
         secondTxt.x = _loc8_.x;
         secondTxt.y = _loc8_.y;
         secondTxt.nativeFilters = _loc9_;
         timeSprite.addChild(secondTxt);
         _loc7_ = 0;
         while(_loc7_ < 4)
         {
            _loc1_ = new TextField(34,28,timeArr[_loc7_],"Verdana",24,16777215);
            Assets.positionDisplay(_loc1_,"inviteFriends","time" + _loc7_);
            if(_loc7_ > 1)
            {
               _loc1_.color = 16711680;
            }
            else
            {
               _loc1_.color = 16777215;
            }
            _loc1_.nativeFilters = _loc9_;
            timeSprite.addChild(_loc1_);
            _loc7_++;
         }
         addChild(timeSprite);
         timer = new Timer(1000);
         timer.addEventListener("timer",onTimer);
         invitedSprite = new Sprite();
         _loc8_ = Assets.getPosition("inviteFriends","txtNum");
         invitedTxt = new TextField(_loc8_.width,_loc8_.height,"0/10","Verdana",24,16777215);
         invitedTxt.x = _loc8_.x;
         invitedTxt.y = _loc8_.y;
         invitedTxt.nativeFilters = _loc9_;
         invitedSprite.addChild(invitedTxt);
         _loc11_ = 0;
         while(_loc11_ < 2)
         {
            _loc4_ = new TextField(140,28,LangManager.t("invite" + _loc11_),"Verdana",24,16777215);
            Assets.positionDisplay(_loc4_,"inviteFriends","txt" + _loc11_);
            _loc4_.nativeFilters = _loc9_;
            invitedSprite.addChild(_loc4_);
            _loc11_++;
         }
         addChild(invitedSprite);
         tipSprite = new Sprite();
         _loc8_ = Assets.getPosition("teamList","text");
         var _loc10_:TextField = new TextField(_loc8_.width,_loc8_.height,LangManager.t("upLoad"),"Verdana",24,16777215);
         _loc10_.x = this.width - _loc10_.width >> 1;
         _loc10_.y = _loc8_.y;
         tipSprite.addChild(_loc10_);
         _loc10_.autoScale = true;
         addChild(tipSprite);
         btnRefresh = new Button(Assets.sAsset.getTexture("refresh0"),"",Assets.sAsset.getTexture("refresh1"));
         Assets.positionDisplay(btnRefresh,"inviteFriends","btnRefresh");
         btnRefresh.addEventListener("triggered",onRefresh);
         addChild(btnRefresh);
         btnRefresh.enabled = false;
         onInvitedCallback(0);
      }
      
      private function onInvitedCallback(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:int = param1 as int;
         if(_loc2_ > 0)
         {
            invitedTxt.text = _loc2_ + "/10";
            _loc3_ = int(friendData.length);
            if(_loc2_ == 10)
            {
               invitedTxt.color = 16711680;
               TextTip.instance.showByLang("invite3");
               _loc5_ = 0;
               while(_loc5_ < _loc3_)
               {
                  friendData[_loc5_].enbale = false;
                  _loc5_++;
               }
            }
            else
            {
               invitedTxt.color = 16777215;
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  friendData[_loc4_].enbale = false;
                  _loc4_++;
               }
            }
         }
      }
      
      private function onPrivateChat() : void
      {
         var _loc1_:ChatRoomDlg = ChatRoomDlg.getInstance();
         parent.addChild(_loc1_);
         _loc1_.visible = true;
         _loc1_.setCurrentFace("2");
         _loc1_.talkWithFriend(selectedItem.nickName,selectedItem.antId);
      }
      
      private function onAboutMe() : void
      {
         if(aboutme == null)
         {
            aboutme = new AboutMe();
         }
         parent.addChild(aboutme);
         aboutme.x = 1365 - aboutme.width >> 1;
         aboutme.y = 768 - aboutme.height >> 1;
         if(FriendsList.instance.isLoadedAboutMe(selectedItem.antId))
         {
            aboutme.showPlayerInfo(FriendsList.instance.getDataAboutme(selectedItem.antId));
         }
         else
         {
            Remoting.instance.getMemStatus(selectedItem.antId,getPlayerInfo);
         }
         if(selectedItem)
         {
            aboutme.setData(selectedItem);
         }
      }
      
      private function getPlayerInfo(param1:Object) : void
      {
         Application.instance.log("AboutMe显示人个信息:",JSON.stringify(param1));
         FriendsList.instance.addDataAboutme(param1);
         aboutme.showPlayerInfo(param1);
      }
      
      private function onAddFriend() : void
      {
         Remoting.instance.addFriend(selectedItem.antId,function(param1:Object):void
         {
            Application.instance.log("添加好友",JSON.stringify(param1));
            if(param1 == 0)
            {
               FriendsList.instance.addFriends(selectedItem);
               TextTip.instance.showByLang("teamList6");
            }
         });
      }
      
      private function onDelFriend() : void
      {
         Remoting.instance.deleteFriend(selectedItem.antId,function(param1:Object):void
         {
            Application.instance.log("删除好友",JSON.stringify(param1));
            if(param1 == true)
            {
               FriendsList.instance.removeFriends(selectedItem);
               TextTip.instance.showByLang("teamList7");
            }
         });
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         var arr:Array;
         var i:int;
         var e:Event = param1;
         this.removeEventListener("addedToStage",onAddedToStage);
         this.stage.addEventListener("touch",onTouch);
         GameServer.instance.getOnlineUser(function(param1:Object):void
         {
            Application.instance.log("TeamRoom:[邀请好友]",JSON.stringify(param1));
            if(param1["ret"] == 0)
            {
               friendData = FriendsList.instance.aryToList(param1.friendsArr);
               tipSprite.visible = false;
               listData.data = friendData;
               list.dataProvider = listData;
               noPlayerTxt.visible = friendData.length == 0 ? true : false;
               timer.start();
               timeSprite.visible = true;
            }
         });
         if(_popWindow == null)
         {
            _popWindow = new PickerButtonsInUIExport("FriendDlg","FriendButtonsLayout",4);
            stage.addChild(_popWindow);
            _popWindow.visible = false;
            arr = [onPrivateChat,onAboutMe,onAddFriend,onDelFriend];
            i = 0;
            while(i < arr.length)
            {
               _popWindow.getButtonById(i).triggerFunction = arr[i];
               i = i + 1;
            }
         }
         this.pivotX = this.width / 2;
         this.pivotY = this.height / 2;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.7,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeOutBack",
            "onComplete":function():void
            {
               list.visible = true;
            }
         });
         parent.addChild(markBg);
         parent.swapChildren(markBg,this);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc3_:Point = null;
         var _loc5_:* = undefined;
         var _loc2_:Vector.<Touch> = param1.getTouches(this.stage);
         if(_loc2_.length > 0 && _loc2_[0].phase == "began")
         {
            _loc4_ = param1.getTouches(list);
            if(_loc4_.length > 0 && _loc4_[0].phase == "began")
            {
               _loc3_ = list.globalToLocal(new Point(_loc4_[0].globalX,_loc4_[0].globalY));
               trace(_loc3_.y,_loc3_.x);
               if(_loc3_.x > 560)
               {
                  optionVisible = false;
                  _popWindow.visible = false;
                  return;
               }
               optionVisible = true;
               if(_loc3_.y > 320)
               {
                  _loc3_.y = 320;
               }
               _popWindow.x = _loc3_.x + _popWindow.width;
               _popWindow.y = _loc3_.y + 120;
            }
            if(_popWindow.visible)
            {
               _loc5_ = param1.getTouches(_popWindow);
               if(_loc5_.length == 0)
               {
                  _popWindow.visible = false;
                  list.selectedIndex = -1;
               }
            }
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         second = second - 1;
         if(second == 0)
         {
            secondTxt.text = "00";
            timer.stop();
            second = 60;
            timeSprite.visible = false;
            secondTxt.text = "60";
            btnRefresh.enabled = true;
         }
         else
         {
            secondTxt.text = second.toString();
         }
      }
      
      private function onListChangeHandler(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         if(optionVisible)
         {
            selectedItem = _loc2_.selectedItem as FriendData;
            trace(FriendsList.instance.isFriend(selectedItem.antId),"---是否好友");
            if(FriendsList.instance.isFriend(selectedItem.antId))
            {
               _popWindow.showButtonById([2,3],false);
            }
            else
            {
               _popWindow.showButtonById([3],false);
            }
            _popWindow.visible = true;
            _popWindow.alpha = 0;
            Starling.juggler.tween(_popWindow,0.6,{
               "alpha":1,
               "transition":"easeOutBack"
            });
         }
         _loc2_.selectedIndex = -1;
      }
      
      private function onRefresh(param1:Event) : void
      {
         var event:Event = param1;
         btnRefresh.enabled = false;
         tipSprite.visible = true;
         GameServer.instance.getOnlineUser(function(param1:Object):void
         {
            var _loc2_:* = undefined;
            Application.instance.log("TeamRoom:[刷新在线列表]",JSON.stringify(param1));
            if(param1["ret"] == 0)
            {
               _loc2_ = FriendsList.instance.aryToList(param1.friendsArr);
               friendData = _loc2_;
               listData.data = friendData;
               list.dataProvider = listData;
               noPlayerTxt.visible = friendData.length == 0 ? true : false;
               timer.start();
               timeSprite.visible = true;
               tipSprite.visible = false;
            }
         });
      }
      
      private function onCloseBtn(param1:Event) : void
      {
         list.visible = false;
         Starling.juggler.tween(this,0.5,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeInBack",
            "onComplete":cleanUp
         });
      }
      
      private function cleanUp() : void
      {
         timer.removeEventListener("timer",onTimer);
         closeBtn.removeEventListener("triggered",onCloseBtn);
         btnRefresh.removeEventListener("triggered",onRefresh);
         list.removeEventListener("change",onListChangeHandler);
         Starling.juggler.removeTweens(this);
         this.stage.removeEventListener("touch",onTouch);
         _popWindow.removeFromParent();
         markBg.removeFromParent();
         removeFromParent();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         cleanUp();
      }
   }
}

