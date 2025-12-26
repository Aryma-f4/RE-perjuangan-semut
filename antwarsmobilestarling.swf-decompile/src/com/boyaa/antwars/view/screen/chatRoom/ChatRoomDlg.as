package com.boyaa.antwars.view.screen.chatRoom
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.payment.PaymentDlg;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideSprite;
   import com.boyaa.tool.filter.DirtyWordFilter;
   import feathers.controls.List;
   import feathers.controls.TextInput;
   import feathers.controls.ToggleButton;
   import feathers.data.ListCollection;
   import feathers.display.Scale9Image;
   import feathers.layout.VerticalLayout;
   import feathers.textures.Scale9Textures;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import org.osflash.signals.Signal;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Shape;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class ChatRoomDlg extends GuideSprite
   {
      
      private static var _instance:ChatRoomDlg;
      
      private var btnClose:Button;
      
      private var btnTotal:ToggleButton;
      
      private var btnWorld:ToggleButton;
      
      private var btnSystem:ToggleButton;
      
      private var unionSystem:ToggleButton;
      
      private var btnSingle:ToggleButton;
      
      private var groupBtns:Sprite;
      
      private var pickerBg:Image;
      
      private var btnPicker:Button;
      
      private var pickerList:Image;
      
      private var btnSend:Button;
      
      private var btnFriendName:Button;
      
      private var textInputBg:Image;
      
      private var textFriendBg:Image;
      
      private var textInput:TextInput;
      
      private var textFriend:TextInput;
      
      private var currentState:String = "total";
      
      private const listWidth:int = 915;
      
      private const listHeight:int = 496;
      
      private var list:List;
      
      private var totalCollection:ListCollection;
      
      private var worldCollection:ListCollection;
      
      private var systemdCollection:ListCollection;
      
      private var singleCollection:ListCollection;
      
      private var unionCollection:ListCollection;
      
      private var setTime:uint = 0;
      
      private var tween:Tween;
      
      private var markBg:DlgMark;
      
      private var isFirstUseGold:Boolean = true;
      
      private var isFirstUseBoyaaCoin:Boolean = true;
      
      private var message:String = "";
      
      private var _mid:int;
      
      private var friendName:String = "";
      
      public var msgSignal:Signal;
      
      private const LIMIT_TIME:int = 30;
      
      private const LOUDER_COIN:int = 500;
      
      private var timer:Timer;
      
      private var canSend:Boolean = true;
      
      private var _btChatSignal:Signal;
      
      private var _isInit:Boolean = false;
      
      private var unionImage:Image;
      
      private const PAGE_NUM:int = 5;
      
      public function ChatRoomDlg()
      {
         super();
         if(_instance)
         {
            throw new Error("只能用getInstance()来获取实例");
         }
      }
      
      public static function getInstance() : ChatRoomDlg
      {
         if(_instance == null)
         {
            _instance = new ChatRoomDlg();
         }
         return _instance;
      }
      
      public function init() : void
      {
         if(_isInit)
         {
            return;
         }
         _isInit = true;
         addEventListener("addedToStage",onAddedToStage);
         msgSignal = new Signal(String);
         _btChatSignal = new Signal(int,String);
         markBg = new DlgMark();
         markBg.alpha = 0.1;
         var _loc1_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("scale9_chat_bg0"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         _loc1_.touchable = false;
         Assets.positionDisplay(_loc1_,"chatRoom","chatBg");
         addChild(_loc1_);
         btnClose = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         btnClose.addEventListener("triggered",onClose);
         Assets.positionDisplay(btnClose,"chatRoom","btnClose");
         addChild(btnClose);
         groupBtns = new Sprite();
         addChild(groupBtns);
         btnTotal = initButton(btnTotal,["chatRoom","tabBar0","chat_tab_0_up","chat_tab_0_down",onClickMenu]);
         btnTotal.name = "0";
         groupBtns.addChild(btnTotal);
         btnTotal.isSelected = true;
         btnTotal.isEnabled = false;
         btnWorld = initButton(btnWorld,["chatRoom","tabBar1","chat_tab_1_up","chat_tab_1_down",onClickMenu]);
         btnWorld.name = "1";
         groupBtns.addChild(btnWorld);
         btnSystem = initButton(btnSystem,["chatRoom","tabBar4","chat_tab_4_up","chat_tab_4_down",onClickMenu]);
         btnSystem.name = "4";
         groupBtns.addChild(btnSystem);
         unionSystem = initButton(unionSystem,["chatRoom","tabBar2","chat_tab_2_up","chat_tab_2_down",onClickMenu]);
         unionSystem.name = "2";
         groupBtns.addChild(unionSystem);
         btnSingle = initButton(btnSingle,["chatRoom","tabBar3","chat_tab_3_up","chat_tab_3_down",onClickMenu]);
         btnSingle.name = "3";
         groupBtns.addChild(btnSingle);
         var _loc4_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("scale9_chat_bg2"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         var _loc6_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("scale9_chat_bg1"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         Assets.sAsset.positionDisplay(_loc6_,"chatRoom","bgFrame0");
         Assets.sAsset.positionDisplay(_loc4_,"chatRoom","bgFrame");
         _loc6_.y -= 5;
         _loc4_.y -= 5;
         addChild(_loc6_);
         addChild(_loc4_);
         var _loc5_:Shape = new Shape();
         _loc5_.graphics.beginFill(5712674);
         _loc5_.graphics.drawRect(_loc4_.x + 5,_loc4_.y + 5,_loc4_.width - 10,_loc4_.height - 10);
         _loc5_.graphics.endFill();
         addChild(_loc5_);
         list = new List();
         list.width = 915;
         list.height = 496;
         totalCollection = new ListCollection(ChatList.instance.getChatListData());
         worldCollection = new ListCollection();
         systemdCollection = new ListCollection();
         singleCollection = new ListCollection();
         unionCollection = new ListCollection();
         list.dataProvider = totalCollection;
         var _loc3_:VerticalLayout = new VerticalLayout();
         _loc3_.gap = 8;
         list.layout = _loc3_;
         list.horizontalScrollPolicy = "off";
         _loc3_.useVirtualLayout = true;
         _loc3_.hasVariableItemDimensions = true;
         list.itemRendererType = ChatListItemRender;
         list.x = _loc4_.x + 30;
         list.y = _loc4_.y + 15;
         addChild(list);
         list.addEventListener("rendererAdd",onRendererAdded);
         scrollToIndex();
         btnSend = new Button(Assets.sAsset.getTexture("talk14"),"",Assets.sAsset.getTexture("talk13"));
         btnSend.addEventListener("triggered",sendMessageToServer);
         Assets.positionDisplay(btnSend,"chatRoom","btnSend");
         addChild(btnSend);
         textInputBg = new Image(Assets.sAsset.getTexture("chat_text_bg0"));
         textInputBg.touchable = false;
         Assets.positionDisplay(textInputBg,"chatRoom","textInput");
         addChild(textInputBg);
         textInput = new TextInput();
         textInput.addEventListener("focusIn",onFocusIn);
         textInput.addEventListener("change",onChange);
         textInput.addEventListener("enter",onKeydown);
         textInput.text = LangManager.t("input");
         textInput.textEditorProperties.fontFamily = "Verdana";
         textInput.textEditorProperties.color = 6710886;
         textInput.textEditorProperties.fontSize = 28;
         Assets.positionDisplay(textInput,"chatRoom","txt");
         addChild(textInput);
         var _loc2_:Rectangle = Assets.getPosition("chatRoom","btnFriend");
         btnFriendName = new Button(Assets.sAsset.getTexture("btn_choose_friend0"),LangManager.t("selectFriend"),Assets.sAsset.getTexture("btn_choose_friend1"));
         btnFriendName.addEventListener("triggered",onFriendList);
         btnFriendName.x = _loc2_.x;
         btnFriendName.y = _loc2_.y;
         btnFriendName.visible = false;
         btnFriendName.fontColor = 16777215;
         btnFriendName.fontSize = 25;
         btnFriendName.fontName = "Verdana";
         addChild(btnFriendName);
         btnFriendName.textHAlign = "left";
         textFriendBg = new Image(Assets.sAsset.getTexture("chat_text_bg1"));
         textFriendBg.touchable = false;
         Assets.positionDisplay(textFriendBg,"chatRoom","textFriend");
         addChild(textFriendBg);
         textFriend = new TextInput();
         textFriend.textEditorProperties.fontFamily = "Verdana";
         textFriend.textEditorProperties.fontSize = 28;
         textFriend.addEventListener("focusIn",onFocusIn);
         textFriend.addEventListener("change",onChange);
         textFriend.addEventListener("enter",onKeydown);
         Assets.positionDisplay(textFriend,"chatRoom","txtFriend");
         addChild(textFriend);
         textFriendBg.visible = textFriend.visible = false;
         timer = new Timer(30 * 1000,1);
         timer.addEventListener("timer",onTimer);
         GameServer.instance.onLoudSpeaker(showWorldMessage);
         GameServer.instance.onChatToFriend(showSingleMessage);
         ChatListItemRender.singleSignal.add(gotoSingle);
         GameServer.instance.onUnionSpeaker(showUnionMessage);
      }
      
      public function addEvent() : void
      {
         GameServer.instance.onLoudSpeaker(showWorldMessage);
         GameServer.instance.onChatToFriend(showSingleMessage);
         GameServer.instance.onUnionSpeaker(showUnionMessage);
      }
      
      private function showUnionMessage(param1:Object) : void
      {
         trace("显示公会聊天信息消息:" + JSON.stringify(param1));
         var _loc4_:int = int(param1.data.userId);
         var _loc3_:String = param1.data.name;
         var _loc2_:String = param1.data.str;
         cancelSelect();
         unionSystem.isSelected = true;
         unionSystem.isEnabled = false;
         var _loc5_:String = LangManager.t("unionChatTip") + "|" + _loc3_ + "|" + LangManager.t("chat0") + ":|" + _loc2_;
         ChatList.instance.addUnionData(_loc5_);
         var _loc6_:int = ChatList.instance.getUnionListData().concat().length - 1;
         unionCollection.data = ChatList.instance.getUnionListData().concat();
         list.dataProvider = unionCollection;
         scrollToIndex();
      }
      
      public function removeUnionBtn() : void
      {
         if(unionSystem)
         {
            unionSystem.removeFromParent();
            unionSystem = null;
         }
      }
      
      private function onRendererAdded(param1:Event) : void
      {
         trace("onRendererAdded:" + param1.data);
         trace("list.height:" + list.height);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         canSend = true;
         timer.stop();
      }
      
      public function showBattleChat(param1:Object) : void
      {
         trace("显示对战聊天消息" + JSON.stringify(param1));
         var _loc3_:Array = (param1.data.chat as String).split("|");
         var _loc4_:String = "";
         var _loc5_:PlayerData = PlayerDataList.instance.getDataByUID(param1.data.uid);
         var _loc2_:int = int(_loc5_.siteID);
         switch(_loc3_[0])
         {
            case LangManager.t("current"):
               if(param1.data.uid == PlayerDataList.instance.selfData.uid)
               {
                  _loc4_ = LangManager.t("current") + "|" + LangManager.t("chat0") + ":|" + _loc3_[1];
               }
               else
               {
                  _loc4_ = LangManager.t("current") + "|" + PlayerDataList.instance.selfData.babyName + ":|" + _loc3_[1];
               }
               ChatList.instance.addData(_loc4_,param1.data.uid);
               totalCollection.data = ChatList.instance.getChatListData().concat();
               list.dataProvider = totalCollection;
               btChatSignal.dispatch(_loc2_,_loc3_[1]);
               break;
            case LangManager.t("privateChat1"):
               if(param1.data.uid == PlayerDataList.instance.selfData.uid)
               {
                  _loc4_ = LangManager.t("current") + "|" + LangManager.t("chat0") + ":|" + _loc3_[1];
               }
               else
               {
                  _loc4_ = LangManager.t("current") + "|" + PlayerDataList.instance.selfData.babyName + ":|" + _loc3_[1];
               }
               ChatList.instance.addSingleData(_loc4_,param1.data.uid);
               ChatList.instance.addData(_loc4_,param1.data.uid);
               totalCollection.data = ChatList.instance.getChatListData().concat();
               list.dataProvider = totalCollection;
               msgSignal.dispatch("private");
         }
         scrollToIndex();
      }
      
      private function initButton(param1:ToggleButton, param2:Array) : ToggleButton
      {
         param1 = new ToggleButton();
         param1.isToggle = true;
         Assets.positionDisplay(param1,param2[0],param2[1]);
         param1.defaultSkin = new Image(Assets.sAsset.getTexture(param2[2]));
         param1.downSkin = new Image(Assets.sAsset.getTexture(param2[3]));
         param1.selectedDownSkin = new Image(Assets.sAsset.getTexture(param2[3]));
         param1.defaultSelectedSkin = new Image(Assets.sAsset.getTexture(param2[3]));
         param1.addEventListener("triggered",param2[4]);
         return param1;
      }
      
      public function showWorldMessage(param1:Object = null) : void
      {
         var _loc4_:String = null;
         Application.instance.log("显示当前或世界消息",JSON.stringify(param1));
         var _loc2_:String = param1.data.str;
         var _loc3_:String = param1.data.name;
         var _loc5_:int = int(param1.data.type);
         trace(_loc5_,"-----------");
         if(_loc5_ == 3)
         {
            if(param1.data.userId == PlayerDataList.instance.selfData.uid)
            {
               _loc4_ = LangManager.t("current") + "|" + LangManager.t("chat0") + ":|" + _loc2_;
            }
            else
            {
               _loc4_ = LangManager.t("current") + "|" + _loc3_ + ":|" + _loc2_;
            }
            ChatList.instance.addData(_loc4_,param1.data.userId);
            totalCollection.data = ChatList.instance.getChatListData().concat();
            list.dataProvider = totalCollection;
            cancelSelect();
            btnTotal.isSelected = true;
            btnTotal.isEnabled = false;
            scrollToIndex();
         }
         else
         {
            _loc4_ = LangManager.t("loudspeaker") + "|" + _loc3_ + ":|" + _loc2_;
            ChatList.instance.addWorldData(_loc4_,param1.data.userId);
            worldCollection.data = ChatList.instance.getWorldListData().concat();
            list.dataProvider = worldCollection;
            if(!btnWorld.isSelected)
            {
               cancelSelect();
               btnWorld.isSelected = true;
               btnWorld.isEnabled = false;
               currentState = "world";
            }
         }
         btnSend.visible = true;
      }
      
      public function showSingleMessage(param1:Object) : void
      {
         trace("显示私聊消息:" + JSON.stringify(param1));
         var _loc4_:int = int(param1.data.userId);
         var _loc3_:String = param1.data.name;
         var _loc2_:String = param1.data.str;
         var _loc5_:String = LangManager.t("privateChat1") + "|" + _loc3_ + "|" + LangManager.t("chat0") + "|" + _loc2_;
         ChatList.instance.addSingleData(_loc5_,_loc4_);
         if(!btnSingle.isSelected)
         {
            cancelSelect();
            btnSingle.isSelected = true;
            btnSingle.isEnabled = false;
            currentState = "single";
         }
         var _loc6_:int = ChatList.instance.getSingleListData().concat().length - 1;
         singleCollection.data = ChatList.instance.getSingleListData().concat();
         list.dataProvider = singleCollection;
         scrollToIndex();
         msgSignal.dispatch("private");
         btnSend.visible = true;
      }
      
      public function showSystemMessage(param1:String) : void
      {
         var _loc2_:String = LangManager.t("chat_system") + "||" + param1;
         ChatList.instance.addSystemData(_loc2_);
         if(!btnSingle.isSelected)
         {
            systemdCollection.data = ChatList.instance.getSystemListData().concat();
            list.dataProvider = systemdCollection;
            if(!btnSystem.isSelected)
            {
               cancelSelect();
               btnSystem.isSelected = true;
               btnSystem.isEnabled = false;
               currentState = "system";
            }
            btnSend.visible = false;
         }
         scrollToIndex();
      }
      
      public function talkWithFriend(param1:String, param2:int = 1) : void
      {
         btnFriendName.visible = true;
         var _loc3_:* = param1;
         friendName = param1;
         if(param1.length > 5)
         {
            _loc3_ = param1.substr(0,5);
         }
         btnFriendName.text = _loc3_;
         if(_loc3_.length > 8)
         {
            btnFriendName.textHAlign = "left";
         }
         else
         {
            btnFriendName.textHAlign = "center";
         }
         textInput.text = "";
         _mid = param2;
         cancelSelect();
         btnSingle.isSelected = true;
         currentState = "single";
         btnSend.visible = true;
      }
      
      public function setCurrentFace(param1:String) : void
      {
         var _loc2_:int = int(param1);
         if(param1 != "3")
         {
            textInput.text = LangManager.t("input");
            textInput.textEditorProperties.color = 6710886;
            textInputBg.visible = textInput.visible = true;
            textInput.isEnabled = true;
            textFriendBg.visible = textFriend.visible = btnFriendName.visible = false;
            btnSingle.isSelected = false;
         }
         else
         {
            textInputBg.visible = textInput.visible = false;
            textInput.isEnabled = false;
            textFriendBg.visible = textFriend.visible = btnFriendName.visible = true;
            textFriend.text = LangManager.t("input");
            textFriend.textEditorProperties.color = 6710886;
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         parent.addChild(markBg);
         parent.swapChildren(markBg,this);
         if(BattleServer.instance.isConnect)
         {
            BattleServer.instance.onChatMsg(showBattleChat);
         }
         this.pivotX = 508;
         this.pivotY = 400;
         this.x = 690;
         this.y = 425;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.4,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeInOut"
         });
      }
      
      private function onKeydown(param1:Event) : void
      {
         sendMessageToServer();
      }
      
      private function onFocusIn(param1:Event) : void
      {
         var _loc2_:TextInput = param1.target as TextInput;
         if(_loc2_.text == LangManager.t("input"))
         {
            _loc2_.text = "";
            _loc2_.textEditorProperties.color = 16777215;
         }
      }
      
      private function onChange(param1:Event) : void
      {
         var _loc2_:TextInput = param1.target as TextInput;
         if(_loc2_.text.length >= 40)
         {
            _loc2_.text = _loc2_.text.substr(0,40);
         }
      }
      
      private function sendPrivateMsg() : void
      {
         var _loc1_:String = null;
         if(message != "" && message != LangManager.t("input") && friendName != LangManager.t("selectFriend"))
         {
            if(BattleServer.instance.isConnect)
            {
               _loc1_ = LangManager.t("privateChat") + "|" + message;
               BattleServer.instance.sendMsg(_loc1_);
            }
            else
            {
               GameServer.instance.sendChatToFriend(_mid,message);
               trace("发送私聊消息：" + _mid,message);
            }
            ChatList.instance.addSingleData(LangManager.t("privateChat1") + "|" + LangManager.t("chat0") + "|" + friendName + "|" + message);
            singleCollection.data = ChatList.instance.getSingleListData().concat();
            list.dataProvider = singleCollection;
            if(!btnSingle.isSelected)
            {
               cancelSelect();
               btnSingle.isSelected = true;
               btnSingle.isEnabled = false;
               currentState = "single";
            }
         }
      }
      
      private function sendMessageToServer(param1:Event = null) : void
      {
         var _loc2_:String = null;
         if(textInput.visible)
         {
            _loc2_ = textInput.text;
            textInput.text = LangManager.t("input");
            textInput.textEditorProperties.color = 6710886;
         }
         else
         {
            _loc2_ = textFriend.text;
            textFriend.text = LangManager.t("input");
            textFriend.textEditorProperties.color = 6710886;
         }
         _loc2_ = DirtyWordFilter.getInstance().runFilter(_loc2_);
         message = _loc2_;
         trace("currentState:" + currentState);
         if(currentState == "single")
         {
            sendPrivateMsg();
         }
         else if(currentState == "total")
         {
            sendCurrentMsg();
         }
         else if(currentState == "world")
         {
            sendWorldMsg();
         }
         else if(currentState == "union")
         {
            sendUnionMsg();
         }
         else
         {
            TextTip.instance.show(LangManager.t("input"));
         }
         scrollToIndex();
      }
      
      private function sendUnionMsg() : void
      {
         if(message != "" && message != LangManager.t("input"))
         {
            if(PlayerDataList.instance.selfData.cid == 0)
            {
               TextTip.instance.showByLang("notJoinUnion");
               return;
            }
            GameServer.instance.sendChatToUnion(message);
         }
      }
      
      private function sendWorldMsg() : void
      {
         if(message != "" && message != LangManager.t("input"))
         {
            if(!BattleServer.instance.isConnect)
            {
               if(AccountData.instance.gameGold < 500)
               {
                  TextTip.instance.showByLang("rechargeGold");
                  return;
               }
               if(isFirstUseBoyaaCoin)
               {
                  SystemTip.instance.showSystemAlert(LangManager.replace("useGoldSendMsg",500),onGoldcoin,null);
               }
               else
               {
                  onGoldcoin();
               }
            }
            else
            {
               onGoldcoin();
            }
         }
      }
      
      private function sendCurrentMsg() : void
      {
         if(message != "" && message != LangManager.t("input"))
         {
            freeCoinChat();
         }
      }
      
      private function goRecharge() : void
      {
         var _loc1_:PaymentDlg = new PaymentDlg();
         Starling.current.stage.addChild(_loc1_);
         _loc1_.x = (1365 - _loc1_.width) / 2;
         _loc1_.y = (768 - _loc1_.height) / 2;
      }
      
      private function freeCoinChat() : void
      {
         var _loc1_:String = null;
         if(BattleServer.instance.isConnect && Application.instance.currentGame.navigator.activeScreenID != "SHOW_BT_HALL")
         {
            _loc1_ = LangManager.t("current") + "|" + message;
            BattleServer.instance.sendMsg(_loc1_);
         }
         else if(currentState == "total")
         {
            if(canSend)
            {
               GameServer.instance.sendChatToRoom(message);
               canSend = false;
               timer.start();
            }
            else
            {
               TextTip.instance.show(LangManager.replace("error15",30));
            }
         }
         else
         {
            GameServer.instance.sendChatToRoom(message);
         }
      }
      
      private function onGoldcoin() : void
      {
         AccountData.instance.gameGold -= 500;
         isFirstUseBoyaaCoin = false;
         GameServer.instance.sendLoudSpeaker(message,0);
      }
      
      private function onBooyacoin(param1:Event = null) : void
      {
         var _loc2_:String = null;
         if(BattleServer.instance.isConnect)
         {
            _loc2_ = LangManager.t("loudspeaker") + "|" + PlayerDataList.instance.selfData.name + ":|" + message;
            BattleServer.instance.sendMsg(_loc2_);
         }
         else
         {
            AccountData.instance.boyaaCoin -= 20;
            isFirstUseBoyaaCoin = false;
            GameServer.instance.sendChatToRoom(message);
         }
      }
      
      private function onFriendList(param1:Event) : void
      {
         var _loc2_:ChatFriendDlg = new ChatFriendDlg();
         _loc2_.friendSignal.add(talkWithFriend);
         _loc2_.x = 165;
         _loc2_.y = 17;
         this.addChild(_loc2_);
      }
      
      private function onClickMenu(param1:Event) : void
      {
         list.dataProvider = null;
         cancelSelect();
         var _loc2_:ToggleButton = param1.target as ToggleButton;
         _loc2_.isEnabled = false;
         trace(_loc2_.name);
         switch(_loc2_.name)
         {
            case "0":
               currentState = "total";
               totalCollection.data = ChatList.instance.getChatListData().concat();
               list.dataProvider = totalCollection;
               break;
            case "1":
               currentState = "world";
               worldCollection.data = ChatList.instance.getWorldListData().concat();
               list.dataProvider = worldCollection;
               break;
            case "4":
               currentState = "system";
               systemdCollection.data = ChatList.instance.getSystemListData().concat();
               list.dataProvider = systemdCollection;
               break;
            case "2":
               currentState = "union";
               unionCollection.data = ChatList.instance.getUnionListData().concat();
               list.dataProvider = unionCollection;
               break;
            case "3":
               currentState = "single";
               singleCollection.data = ChatList.instance.getSingleListData().concat();
               list.dataProvider = singleCollection;
         }
         scrollToIndex();
         btnSend.visible = _loc2_.name != "4";
         setCurrentFace(_loc2_.name);
      }
      
      private function onClose(param1:Event) : void
      {
         Starling.juggler.tween(this,0.2,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeIn",
            "onComplete":cleanUp
         });
      }
      
      private function cleanUp() : void
      {
         textInput.removeEventListener("enter",onKeydown);
         textFriend.removeEventListener("enter",onKeydown);
         Starling.juggler.removeTweens(this);
         this.visible = false;
         markBg.removeFromParent();
         clearTimeout(setTime);
         removeFromParent();
         Guide.instance.onBackHall();
      }
      
      public function gotoSingle(param1:String, param2:int) : void
      {
         setCurrentFace("3");
         talkWithFriend(param1,param2);
      }
      
      private function cancelSelect() : void
      {
         var _loc3_:int = 0;
         var _loc2_:ToggleButton = null;
         var _loc1_:int = groupBtns.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = groupBtns.getChildAt(_loc3_) as ToggleButton;
            if(_loc2_.isSelected == true)
            {
               _loc2_.isSelected = false;
               _loc2_.isEnabled = true;
            }
            _loc3_++;
         }
      }
      
      private function scrollToIndex() : void
      {
         try
         {
            Application.instance.log("当前共有滚动项:",list.dataProvider.length.toString());
            list.invalidate();
            if(list.maxVerticalScrollPosition > 0 || list.dataProvider.length > 5)
            {
               list.scrollToDisplayIndex(list.dataProvider.length - 1);
            }
         }
         catch(err:Error)
         {
            trace(err.getStackTrace());
         }
      }
      
      private function delay() : void
      {
         list.scrollToDisplayIndex(list.dataProvider.length - 1,0.1);
      }
      
      override public function dispose() : void
      {
         trace("[dispose ChatRoomDlg...]");
         super.dispose();
         timer.removeEventListener("timer",onTimer);
         btnClose.removeEventListener("triggered",onClose);
         btnTotal.removeEventListener("triggered",onClickMenu);
         btnSystem.removeEventListener("triggered",onClickMenu);
         btnSingle.removeEventListener("triggered",onClickMenu);
         btnSend.removeEventListener("triggered",sendMessageToServer);
         textInput.removeEventListener("focusIn",onFocusIn);
         btnFriendName.removeEventListener("triggered",onFriendList);
         textFriend.removeEventListener("focusIn",onFocusIn);
      }
      
      public function get btChatSignal() : Signal
      {
         return _btChatSignal;
      }
   }
}

