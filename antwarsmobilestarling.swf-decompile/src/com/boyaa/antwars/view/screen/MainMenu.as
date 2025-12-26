package com.boyaa.antwars.view.screen
{
   import com.boyaa.ane.SystemProperties;
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.MissionDataList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.sound.GameConfigDlg;
   import com.boyaa.antwars.view.mission.MissionDlg;
   import com.boyaa.antwars.view.payment.PaymentDlg;
   import com.boyaa.antwars.view.payment.PaymentInfoIdDlg;
   import com.boyaa.antwars.view.screen.backpack.Backpack;
   import com.boyaa.antwars.view.screen.battlefield.BtHallScreen;
   import com.boyaa.antwars.view.screen.battlefield.BtRoom;
   import com.boyaa.antwars.view.screen.chatRoom.ChatRoomDlg;
   import com.boyaa.antwars.view.screen.chatRoom.Emoticon;
   import com.boyaa.antwars.view.screen.copygame.CityWorld;
   import com.boyaa.antwars.view.screen.copygame.CopyGame;
   import com.boyaa.antwars.view.screen.copygame.SkyCity;
   import com.boyaa.antwars.view.screen.copygame.team.TeamRoom;
   import com.boyaa.antwars.view.screen.exchangeCenter.ExchangeCenterScreen;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideEventManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import com.boyaa.antwars.view.screen.friends.FriendsDlg;
   import com.boyaa.antwars.view.screen.mail.MailBoxDlg;
   import com.boyaa.antwars.view.screen.menu.LeftMenu;
   import com.boyaa.antwars.view.screen.menu.MenuButton;
   import com.boyaa.antwars.view.screen.menu.RightMenu;
   import com.boyaa.antwars.view.screen.union.UnionScreen;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import flash.geom.Point;
   import flash.media.StageWebView;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObjectContainer;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class MainMenu extends UIExportSprite implements IGuideProcess
   {
      
      private var _ReturnBtn:Button;
      
      private var _parentWin:IMainMenu;
      
      public var backpack:Backpack;
      
      private var chatroom:ChatRoomDlg;
      
      private var friendScreen:FriendsDlg;
      
      private var webView:StageWebView;
      
      public var menuHeight:int = 105;
      
      private var _leftMenu:LeftMenu;
      
      private var _rightMenu:RightMenu;
      
      private var _emotion:Emoticon;
      
      private var gameConfigDlg:GameConfigDlg;
      
      private var _oldPosition:Array = [];
      
      public function MainMenu()
      {
         super();
         initBackpack();
         initChatRoom();
         _ReturnBtn = new Button(Assets.sAsset.getTexture("back0"),"",Assets.sAsset.getTexture("back1"));
         ReturnBtn.addEventListener("triggered",onReturnBtn);
         ReturnBtn.x = Assets.leftTop.x + 10;
         ReturnBtn.y = Assets.leftTop.y + 10;
         ReturnBtn.visible = false;
         _displayObj.addChild(ReturnBtn);
         initNewMenu();
      }
      
      public function get PackageBtn() : Button
      {
         return _rightMenu.backPackBtn.starlingBtn;
      }
      
      public function get FriendsBtn() : Button
      {
         return _rightMenu.friendBtn.starlingBtn;
      }
      
      public function get MissionBtn() : Button
      {
         return _rightMenu.missionBtn.starlingBtn;
      }
      
      public function get MessageBtn() : Button
      {
         return _leftMenu.chatBtn.starlingBtn;
      }
      
      public function get ReturnBtn() : Button
      {
         return _ReturnBtn;
      }
      
      public function get MailBoxBtn() : Button
      {
         return _rightMenu.emailBtn.starlingBtn;
      }
      
      public function get ExchangeCenterBtn() : Button
      {
         return _rightMenu.exchangeBtn.starlingBtn;
      }
      
      public function get parentWin() : IMainMenu
      {
         return _parentWin;
      }
      
      public function set parentWin(param1:IMainMenu) : void
      {
         _parentWin = param1;
         _leftMenu.displayObj.x = _oldPosition[2];
         _leftMenu.displayObj.y = _oldPosition[3];
         _rightMenu.displayObj.x = _oldPosition[0];
         _rightMenu.displayObj.y = _oldPosition[1];
         if(_rightMenu.displayObj.scaleX <= 0.9)
         {
            _rightMenu.showScale();
         }
         if(_parentWin is CopyGame || _parentWin is SkyCity || _parentWin is CityWorld || _parentWin is Hall || _parentWin is UnionScreen || _parentWin is TeamRoom)
         {
            showMenuItems(["chatBtn"]);
         }
         else if(_parentWin is BtHallScreen)
         {
            _leftMenu.displayObj.x = 170;
            showMenuItems(["chatBtn"],[]);
         }
         else if(_parentWin is BtRoom)
         {
            _leftMenu.displayObj.x = 170;
            _rightMenu.showScale(0.9);
            _rightMenu.displayObj.y += _rightMenu.displayObj.height * 0.1;
            _rightMenu.displayObj.x = 1365 - 170.5 - _rightMenu.displayObj.width;
            showMenuItems();
         }
         else
         {
            showMenuItems();
         }
      }
      
      public function get rightMenu() : RightMenu
      {
         return _rightMenu;
      }
      
      public function get leftMenu() : LeftMenu
      {
         return _leftMenu;
      }
      
      private function showMenuItems(param1:Array = null, param2:Array = null, param3:Boolean = true) : void
      {
         _leftMenu.showMenuItems(param1,param3);
         _rightMenu.showMenuItems(param2,param3);
      }
      
      private function initNewMenu() : void
      {
         _layout = new LayoutUitl(Assets.sAsset.getOther("publicComponent"));
         _layout.buildLayout("mainMenu",_displayObj);
         _leftMenu = new LeftMenu(getSpriteByName("leftPart"));
         _leftMenu.displayObj.x = _oldPosition[2] = Assets.leftBottom.x;
         _leftMenu.displayObj.y = _oldPosition[3] = Assets.leftBottom.y - _leftMenu.displayObj.height;
         _rightMenu = new RightMenu(getSpriteByName("rightPart"));
         _rightMenu.displayObj.x = _oldPosition[0] = Assets.rightBottom.x - _rightMenu.displayObj.width;
         _rightMenu.displayObj.y = _oldPosition[1] = Assets.rightBottom.y - _rightMenu.displayObj.height;
         EventCenter.GameEvent.addEventListener("menuButtonTouch",onMenuButtonTouch);
         showMissionFinishNum(MissionDataList.getInstance().doneMissionArr.length);
      }
      
      private function onStageTouch(param1:TouchEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc3_:* = undefined;
         var _loc2_:Vector.<Touch> = param1.getTouches(this.stage);
         if(_loc2_.length > 0 && _loc2_[0].phase == "began")
         {
            _loc4_ = param1.getTouches(_emotion);
            _loc3_ = param1.getTouches(_rightMenu.emailBtn.starlingBtn);
            if(_loc4_.length == 0 && _loc3_.length == 0)
            {
               _emotion.faceBorad.visible = false;
            }
         }
      }
      
      private function onMenuButtonTouch(param1:GameEvent) : void
      {
         var _loc3_:Object = param1.param as Object;
         var _loc2_:MenuButton = _loc3_.menuButton;
         switch(_loc2_.starlingBtn.name)
         {
            case "exchangeBtn":
               onExchangeCenterBtn(null);
               break;
            case "backPackBtn":
               onPackageBtn(null);
               break;
            case "missionBtn":
               onMissionBtn(null);
               break;
            case "emailBtn":
               onMailBoxBtn(null);
               break;
            case "friendBtn":
               onFriendsBtn(null);
               break;
            case "setBtn":
               onSetBtn(null);
               break;
            case "menuBtn":
               onMenuButton();
               break;
            case "emotionBtn":
               onEmotionButton();
               break;
            case "chatBtn":
               onMessageBtn(null);
         }
      }
      
      private function onEmotionButton() : void
      {
         var _loc1_:Point = null;
         if(_emotion == null)
         {
            _emotion = new Emoticon();
            _loc1_ = _leftMenu.emotionBtn.starlingBtn.parent.localToGlobal(new Point(_leftMenu.emotionBtn.starlingBtn.x,_leftMenu.emotionBtn.starlingBtn.y));
            _emotion.x = _loc1_.x;
            _emotion.y = _loc1_.y - _emotion.faceBorad.height - 10;
            _displayObj.addChild(_emotion);
            stage.addEventListener("touch",onStageTouch);
         }
         _emotion.faceBorad.visible = !_emotion.faceBorad.visible;
      }
      
      private function onMenuButton() : void
      {
         var _loc1_:Boolean = _rightMenu.menuBtn.starlingBtn.scaleX > 0 ? false : true;
         if(_loc1_)
         {
            _rightMenu.showButtons(_loc1_,showGuide);
         }
         else
         {
            _rightMenu.showButtons(_loc1_);
         }
         onOldMenuBtnHandle();
      }
      
      private function showRightPart(param1:Boolean) : void
      {
      }
      
      private function showLeftPart(param1:Boolean) : void
      {
      }
      
      private function onExchangeCenterBtn(param1:Event) : void
      {
         Guide.instance.stop();
         var _loc2_:ExchangeCenterScreen = new ExchangeCenterScreen();
         (parentWin as DisplayObjectContainer).addChild(_loc2_);
      }
      
      private function onMailBoxBtn(param1:Event) : void
      {
         Guide.instance.stop();
         var _loc2_:MailBoxDlg = new MailBoxDlg();
         (parentWin as DisplayObjectContainer).addChild(_loc2_);
      }
      
      public function isEnable(param1:Boolean) : void
      {
         _leftMenu.displayObj.touchable = param1;
         _rightMenu.displayObj.touchable = param1;
      }
      
      public function onMessageCome(param1:String = "") : void
      {
         if(!chatroom.visible && param1 == "private")
         {
            _leftMenu.chatBtn.tipNum += 1;
         }
      }
      
      public function initBackpack() : void
      {
         backpack = new Backpack();
      }
      
      public function initChatRoom() : void
      {
         chatroom = ChatRoomDlg.getInstance();
         chatroom.init();
         chatroom.name = "chatRoom";
         chatroom.visible = false;
         chatroom.msgSignal.add(onMessageCome);
      }
      
      public function initFriends() : void
      {
         if(!friendScreen)
         {
            friendScreen = new FriendsDlg();
         }
         friendScreen.resetFriendData();
      }
      
      public function onRechargeBtn() : void
      {
         var _loc2_:PaymentDlg = null;
         var _loc1_:PaymentInfoIdDlg = null;
         if(Constants.lanVersion == 2)
         {
            SystemProperties.appotaPayment(PlayerDataList.instance.selfData.uid);
         }
         else if(Constants.lanVersion == 1)
         {
            _loc2_ = new PaymentDlg();
            Starling.current.stage.addChild(_loc2_);
            _loc2_.x = (1365 - _loc2_.width) / 2;
            _loc2_.y = (768 - _loc2_.height) / 2;
         }
         else if(Constants.lanVersion == 3)
         {
            _loc1_ = new PaymentInfoIdDlg();
            Starling.current.stage.addChild(_loc1_);
         }
      }
      
      public function show(param1:IMainMenu) : void
      {
         parentWin = param1;
         var _loc2_:DisplayObjectContainer = parentWin as DisplayObjectContainer;
         _loc2_.addChild(this);
      }
      
      public function missionBtnHightLight(param1:Boolean) : void
      {
         _rightMenu.missionBtn.showTipAni(param1);
      }
      
      public function showMissionFinishNum(param1:int) : void
      {
         _rightMenu.missionBtn.tipNum = param1;
      }
      
      public function mailBtnHighLight(param1:Boolean) : void
      {
         _rightMenu.emailBtn.showTipAni(param1);
      }
      
      private function onOldMenuBtnHandle() : void
      {
         if(PlayerDataList.instance.selfData.level < 5)
         {
            if(Application.instance.currentGame._guideOptionsData.pos == "backpack" && Application.instance.currentGame.navigator.activeScreenID == "HALL")
            {
               return;
            }
         }
         if(_rightMenu.menuBtn.starlingBtn.scaleX < 0)
         {
            if(PlayerDataList.instance.selfData.level < 5)
            {
               if(Application.instance.currentGame._guideOptionsData.pos == "mission" && Application.instance.currentGame.navigator.activeScreenID == "HALL")
               {
                  Guide.instance.stop();
               }
            }
         }
      }
      
      private function showGuide() : void
      {
         var _loc1_:Hall = null;
         if(Application.instance.currentGame._guideOptionsData.pos == "mission" && Application.instance.currentGame.navigator.activeScreenID == "HALL")
         {
            _loc1_ = Application.instance.currentGame.navigator.activeScreen as Hall;
            _loc1_.posGuide();
         }
      }
      
      public function onMessageBtn(param1:Event = null) : void
      {
         Guide.instance.stop();
         chatroom.visible = true;
         (parentWin as DisplayObjectContainer).addChild(chatroom);
         _leftMenu.chatBtn.tipNum = 0;
      }
      
      public function onPackageBtn(param1:Event = null) : void
      {
         Guide.instance.stop();
         (parentWin as DisplayObjectContainer).addChild(backpack);
         backpack.x = (1365 - backpack.width) / 2 + 30;
         backpack.y = (768 - backpack.height) / 2;
      }
      
      public function onMissionBtn(param1:Event = null) : void
      {
         Guide.instance.stop();
         var _loc2_:MissionDlg = new MissionDlg();
         (parentWin as DisplayObjectContainer).addChild(_loc2_);
         _loc2_.x = 1365 - _loc2_.width >> 1;
         _loc2_.y = 768 - _loc2_.height >> 1;
      }
      
      public function onFriendsBtn(param1:Event = null) : void
      {
         Guide.instance.stop();
         initFriends();
         (parentWin as DisplayObjectContainer).addChild(friendScreen);
         friendScreen.x = 1365 - friendScreen.width >> 1;
         friendScreen.y = 768 - friendScreen.height >> 1;
      }
      
      private function onSetBtn(param1:Event) : void
      {
         if(gameConfigDlg && Starling.current.stage.contains(gameConfigDlg))
         {
            return;
         }
         gameConfigDlg = new GameConfigDlg();
         Starling.current.stage.addChild(gameConfigDlg);
         gameConfigDlg.x = 1365 - gameConfigDlg.width >> 1;
         gameConfigDlg.y = 768 - gameConfigDlg.height >> 1;
      }
      
      public function onReturnBtn(param1:Event = null) : void
      {
         Guide.instance.stop();
         Application.instance.currentGame._guideOptionsData.pos = "mission";
         parentWin.exit();
      }
      
      override public function dispose() : void
      {
         trace("[dispose Hall...]");
      }
      
      public function guideProcess(param1:Object = null) : void
      {
         var _loc2_:String = MissionGuideValue.instance.getMissionFlag();
         switch(_loc2_)
         {
            case "friendMission":
               GuideEventManager.instance.dispactherEvent("newUI",[[FriendsBtn,10]]);
               break;
            case "usePropMission":
               GuideEventManager.instance.dispactherEvent("newUI",[[PackageBtn,10]]);
         }
      }
   }
}

