package com.boyaa.antwars.view.screen.copygame.team
{
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.CopyDetailData;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.display.Gauge;
   import com.boyaa.antwars.view.screen.IMainMenu;
   import com.boyaa.antwars.view.screen.PersonnalInfoDlg;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.battlefield.BtSkillDlg;
   import com.boyaa.antwars.view.screen.battlefield.element.TimerSecond;
   import com.boyaa.antwars.view.screen.copygame.LessPowerDlg;
   import com.boyaa.antwars.view.screen.copygame.boss.BossWorld;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.debug.Logging.LevelLogger;
   import feathers.controls.Screen;
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class TeamRoom extends Screen implements IMainMenu
   {
      
      public static const BgWidth:uint = 214;
      
      public static const BgHeight:uint = 176;
      
      private static var _roomFlag:uint = 0;
      
      protected var layoutUitl:LayoutUitl;
      
      private var _optionsData:Object;
      
      private var btnClose:Button;
      
      private var btnInvite:Button;
      
      private var btnStartGame:Button;
      
      private var btnStartReady:Button;
      
      private var btnStopGame:Button;
      
      private var btnStopReady:Button;
      
      private var disStartGame:Image;
      
      private var text_roomId:TextField;
      
      private var text_roomName:TextField;
      
      private var roomID:String = "1234";
      
      private var _roomName:String = "";
      
      private var text_bossName:TextField;
      
      private var text_fightValue:TextField;
      
      private var text_diffiValue:TextField;
      
      private var img_boss:Image;
      
      private var spriteChar:Sprite;
      
      private var players:Vector.<Sprite>;
      
      private var chars:Vector.<Character>;
      
      private var charNames:Vector.<TextField>;
      
      private var charLevel:Vector.<TextField>;
      
      private var charEneyValue:Vector.<TextField>;
      
      private var charReady:Vector.<Image>;
      
      private var charOwner:Vector.<Image>;
      
      private var charBg:Vector.<Image>;
      
      private var charOpen:Vector.<DisplayObject>;
      
      private var charClose:Vector.<DisplayObject>;
      
      private var charEnergy:Vector.<Sprite>;
      
      private var energyBar:Vector.<Gauge>;
      
      private const TotalEnergy:int = 60;
      
      private var mid:Array = [0,0,0,0];
      
      private var id:int = 0;
      
      private var mySite:int = 0;
      
      private var playerNum:int = 0;
      
      private var propAndSkillLayer:Sprite;
      
      private var cardContainer:Sprite;
      
      public var selectBtn:Button;
      
      private var btnSelect:Button;
      
      private var index:int = 0;
      
      private var propIndex:int = 4;
      
      private var menu:Sprite;
      
      private var btnCheck:Button;
      
      private var btnOutRoom:Button;
      
      private var paddingTop:uint = 25;
      
      private var gap:uint = 15;
      
      private var aboutme:PersonnalInfoDlg;
      
      private var timerSecond:TimerSecond;
      
      private var btSkillDlg:BtSkillDlg;
      
      public function TeamRoom()
      {
         super();
      }
      
      public static function fromCopyGame() : void
      {
         _roomFlag = 1;
         Application.instance.currentGame.navigator.showScreen("TEAMROOM");
      }
      
      override protected function initialize() : void
      {
         var rmger:ResManager;
         Application.instance.currentGame.showLoading();
         rmger = Application.instance.resManager;
         Assets.sAsset.enqueue(rmger.getResFile(formatString("textures/{0}x/COPYGAME/copygameui.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYGAME/copygameui.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYGAME/skycity.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYGAME/skycity.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/btdlg.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/btdlg.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("asset/teamRoom.info")));
         Assets.sAsset.loadQueue((function():*
         {
            var onProgress:Function;
            return onProgress = function(param1:Number):void
            {
               var ratio:Number = param1;
               if(ratio == 1)
               {
                  Starling.juggler.delayCall(function():void
                  {
                     init();
                     Application.instance.currentGame.hiddenLoading();
                  },0.15);
               }
            };
         })());
      }
      
      private function init() : void
      {
         layoutUitl = new LayoutUitl(Assets.sAsset.getOther("teamRoom"),Assets.sAsset);
         layoutUitl.buildLayout("TeamRoom",this);
         initRoomInfo();
         initBossInfo();
         initPlayerInfo();
         initButton();
         initSkillProp();
         initMenu();
         Application.instance.currentGame.mainMenu.show(this);
         Application.instance.currentGame.mainMenu.ReturnBtn.visible = false;
         stage.addEventListener("touch",onTouch);
         bindNet();
         if(Application.instance.currentGame._copyModeOptionsData.createBtn && !_roomFlag)
         {
            CopyServer.instance.sendCreateRoomDone();
            addPlayer(Application.instance.currentGame._copyModeOptionsData.retData);
            Application.instance.currentGame._copyModeOptionsData.roomId = 0;
            Application.instance.currentGame._copyModeOptionsData.createBtn = 0;
         }
         if(_roomFlag)
         {
            backRoomFromCopy();
         }
         else
         {
            CopyServer.instance.joinInRoom(Application.instance.currentGame._copyModeOptionsData.roomId,getPlayerInfoFromServer);
         }
         CopyServer.instance.serverType = 0;
      }
      
      private function backRoomFromCopy() : void
      {
         CopyServer.instance.backToRoomFromCopyGame((function():*
         {
            var call:Function;
            return call = function(param1:Object):void
            {
               PlayerDataList.instance.removePlayers();
               Application.instance.currentGame._copyModeOptionsData.retData = param1;
               PlayerDataList.instance.copyGameAddRoomPlayers(param1);
               addPlayer(Application.instance.currentGame._copyModeOptionsData.retData);
            };
         })());
         _roomFlag = 0;
      }
      
      private function getPlayerInfoFromServer(param1:Object) : void
      {
         trace(JSON.stringify(param1));
         if(!param1.data.flag)
         {
            if(!PlayerDataList.instance.selfData.houseOwner)
            {
               Application.instance.currentGame.navigator.showScreen("TEAMLIST");
            }
            return;
         }
         var _loc4_:String = param1.data.roomId;
         var _loc3_:String = param1.data.roomName;
         var _loc2_:int = int(param1.data.diff);
         Application.instance.currentGame._copyModeOptionsData.teamRoomId = _loc4_;
         Application.instance.currentGame._copyModeOptionsData.teamRoomName = _loc3_;
         Application.instance.currentGame._copyModeOptionsData.diff = _loc2_;
         Application.instance.currentGame._copyModeOptionsData.retData = param1;
         PlayerDataList.instance.copyGameAddRoomPlayers(param1);
         addPlayer(Application.instance.currentGame._copyModeOptionsData.retData);
         text_roomId.text = _loc4_;
         text_roomName.text = _loc3_;
      }
      
      private function initRoomInfo() : void
      {
         var _loc5_:Image = null;
         var _loc1_:int = 0;
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("zdpp_bottom"));
         Assets.positionDisplay(_loc3_,"btRoom","bottomBar");
         addChild(_loc3_);
         roomID = optionsData.teamRoomId;
         _roomName = optionsData.teamRoomName;
         var _loc2_:String = getRoomNameByScreenID(Application.instance.currentGame.navigator.activeScreenID);
         text_roomId = this.getChildByName("text_roomId") as TextField;
         text_roomName = this.getChildByName("text_roomName") as TextField;
         setTextFieldInVnFormat([text_roomName]);
         text_roomId.text = Application.instance.currentGame._copyModeOptionsData.teamRoomId;
         text_roomName.text = Application.instance.currentGame._copyModeOptionsData.teamRoomName;
         var _loc4_:DisplayObject = getChildByName("bossImage");
         var _loc6_:int;
         switch((_loc6_ = CopyList.instance.currentCopyData.cpid) - 3)
         {
            case 0:
               _loc5_ = new Image(Assets.sAsset.getTexture("spritefb"));
               _loc1_ = this.getChildIndex(_loc4_);
               _loc5_.x = _loc4_.x;
               _loc5_.y = _loc4_.y;
               _loc4_.removeFromParent(true);
               this.addChildAt(_loc5_,_loc1_);
         }
      }
      
      private function setTextFieldInVnFormat(param1:Array, param2:int = 24) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            param1[_loc3_].fontName = "Arial";
            param1[_loc3_].fontSize = param2;
            _loc3_++;
         }
      }
      
      private function initBossInfo() : void
      {
         text_bossName = this.getChildByName("text_bossName") as TextField;
         text_fightValue = this.getChildByName("text_fightValue") as TextField;
         text_diffiValue = this.getChildByName("text_diffiValue") as TextField;
         var _loc2_:TextField = this.getChildByName("text_fight") as TextField;
         var _loc1_:TextField = this.getChildByName("text_diffi") as TextField;
         setTextFieldInVnFormat([text_bossName,text_fightValue,text_diffiValue,_loc2_,_loc1_]);
         _loc1_.text = LangManager.t("diffi") + ":";
         _loc2_.text = LangManager.t("fight") + ":";
         text_fightValue.text = LangManager.t("unknow");
         if(Application.instance.currentGame._copyModeOptionsData.diff == 2)
         {
            text_diffiValue.text = LangManager.t("copyGameHero");
         }
         else
         {
            text_diffiValue.text = LangManager.t("copyGameNormal");
         }
         switch(CopyList.instance.currentCopyData.cpid - 2)
         {
            case 0:
               text_bossName.text = LangManager.t("zhunhuang");
               break;
            case 1:
               text_bossName.text = LangManager.t("leien");
         }
      }
      
      private function initMenu() : void
      {
         menu = new Sprite();
         var _loc1_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("tips_scale9"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         _loc1_.width = 214;
         _loc1_.height = 176;
         btnCheck = new Button(Assets.sAsset.getTexture("fb70"),"",Assets.sAsset.getTexture("fb71"));
         btnCheck.addEventListener("triggered",onCheck);
         btnOutRoom = new Button(Assets.sAsset.getTexture("btnS_outRoom1"),"",Assets.sAsset.getTexture("btnS_outRoom2"));
         btnOutRoom.addEventListener("triggered",onKickOut);
         var _loc2_:uint = _loc1_.y + paddingTop;
         btnCheck.x = btnOutRoom.x = 214 - btnCheck.width >> 1;
         btnCheck.y = _loc2_;
         btnOutRoom.y = _loc2_ + btnCheck.height + gap;
         menu.addChild(_loc1_);
         menu.addChild(btnCheck);
         menu.addChild(btnOutRoom);
         menu.visible = false;
         addChild(menu);
      }
      
      private function initSkillProp() : void
      {
         propAndSkillLayer = this.getChildByName("sprite_select") as Sprite;
         btnSelect = propAndSkillLayer.getChildByName("btnS_select") as Button;
         selectBtn = propAndSkillLayer.getChildByName("btnS_select1") as Button;
         btnSelect.addEventListener("triggered",onSelect);
         selectBtn.addEventListener("triggered",onSelect);
         cardContainer = new Sprite();
         addChild(cardContainer);
         cardContainer.touchable = false;
         updatePropAndSkill();
      }
      
      private function initButton() : void
      {
         btnClose = this.getChildByName("btnS_close") as Button;
         btnClose.addEventListener("triggered",onClose);
         btnClose.x = Assets.rightTop.x - btnClose.width;
         btnClose.y = Assets.rightTop.y + btnClose.height / 3;
         btnInvite = this.getChildByName("btnS_invite") as Button;
         btnInvite.addEventListener("triggered",onInvite);
         btnInvite.visible = false;
         btnStartGame = this.getChildByName("btnS_fight") as Button;
         btnStartGame.addEventListener("triggered",onStartGame);
         btnStartGame.visible = false;
         btnStopGame = this.getChildByName("btnS_stopFight") as Button;
         btnStopGame.addEventListener("triggered",onStopGame);
         btnStopGame.width = btnStartGame.width;
         btnStopGame.height = btnStartGame.height;
         btnStartGame.x = btnStopGame.x;
         btnStartGame.y = btnStopGame.y;
         disStartGame = this.getChildByName("image_disFight") as Image;
         disStartGame.x = btnStopGame.x;
         disStartGame.y = btnStopGame.y;
         disStartGame.visible = false;
         btnStartReady = new Button(Assets.sAsset.getTexture("zdpp30"),"",Assets.sAsset.getTexture("zdpp31"));
         btnStopReady = new Button(Assets.sAsset.getTexture("zdpp32"),"",Assets.sAsset.getTexture("zdpp33"));
         btnStartReady.addEventListener("triggered",onStartGame);
         btnStopReady.addEventListener("triggered",onStopGame);
         btnStartReady.x = btnStartGame.x;
         btnStartReady.y = btnStartGame.y;
         btnStopReady.x = btnStopGame.x;
         btnStopReady.y = btnStopGame.y;
         btnStartReady.visible = btnStopReady.visible = false;
         addChild(btnStartReady);
         addChild(btnStopReady);
      }
      
      private function initPlayerInfo() : void
      {
         var _loc10_:int = 0;
         var _loc3_:Sprite = null;
         var _loc2_:Image = null;
         var _loc9_:DisplayObject = null;
         var _loc15_:DisplayObject = null;
         var _loc13_:Image = null;
         var _loc5_:Image = null;
         var _loc12_:TextField = null;
         var _loc1_:TextField = null;
         var _loc6_:Sprite = null;
         var _loc4_:Image = null;
         var _loc8_:Rectangle = null;
         var _loc14_:Gauge = null;
         var _loc11_:TextField = null;
         var _loc7_:Image = null;
         spriteChar = new Sprite();
         players = new Vector.<Sprite>();
         chars = new Vector.<Character>(4);
         charNames = new Vector.<TextField>();
         charLevel = new Vector.<TextField>();
         charEneyValue = new Vector.<TextField>();
         charReady = new Vector.<Image>();
         charOwner = new Vector.<Image>();
         charOpen = new Vector.<DisplayObject>();
         charClose = new Vector.<DisplayObject>();
         charBg = new Vector.<Image>();
         charEnergy = new Vector.<Sprite>();
         energyBar = new Vector.<Gauge>();
         _loc10_ = 0;
         while(_loc10_ < 4)
         {
            _loc3_ = this.getChildByName("sprite_player" + _loc10_) as Sprite;
            players.push(_loc3_);
            _loc2_ = _loc3_.getChildByName("playerBg") as Image;
            charBg.push(_loc2_);
            _loc9_ = _loc3_.getChildByName("btn_close") as DisplayObject;
            _loc9_.addEventListener("triggered",onRemove);
            charClose.push(_loc9_);
            _loc15_ = _loc3_.getChildByName("btnOpen") as DisplayObject;
            _loc15_.addEventListener("triggered",onOpen);
            charOpen.push(_loc15_);
            _loc15_.visible = false;
            _loc13_ = _loc3_.getChildByName("img_owner") as Image;
            charOwner.push(_loc13_);
            _loc13_.visible = false;
            _loc5_ = _loc3_.getChildByName("img_ready") as Image;
            charReady.push(_loc5_);
            _loc5_.visible = false;
            _loc12_ = _loc3_.getChildByName("text_level") as TextField;
            charLevel.push(_loc12_);
            _loc1_ = _loc3_.getChildByName("text_name") as TextField;
            charNames.push(_loc1_);
            _loc6_ = new Sprite();
            _loc4_ = new Image(Assets.sAsset.getTexture("fb92"));
            Assets.positionDisplay(_loc4_,"btRoom","barBg" + _loc10_);
            _loc6_.addChild(_loc4_);
            _loc8_ = Assets.getPosition("btRoom","energyBar" + _loc10_);
            _loc14_ = new Gauge(Assets.sAsset.getTexture("fb91"));
            _loc14_.x = _loc8_.x + 20;
            _loc14_.y = _loc8_.y + 13;
            _loc14_.width = _loc8_.width;
            _loc14_.height = _loc8_.height;
            _loc14_.ratio = 0.5;
            energyBar.push(_loc14_);
            _loc6_.addChild(_loc14_);
            _loc11_ = new TextField(104,28,"30/60","Verdana",24,16777215,true);
            Assets.positionDisplay(_loc11_,"btRoom","energy" + _loc10_);
            charEneyValue.push(_loc11_);
            _loc6_.addChild(_loc11_);
            _loc7_ = new Image(Assets.sAsset.getTexture("image_bottle"));
            Assets.positionDisplay(_loc7_,"btRoom","bottle" + _loc10_);
            _loc6_.addChild(_loc7_);
            charEnergy.push(_loc6_);
            addChild(_loc6_);
            _loc6_.visible = false;
            _loc10_++;
         }
         addChild(spriteChar);
      }
      
      private function getRoomNameByScreenID(param1:String) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case "SKYCITY":
               _loc2_ = "天空之城";
               break;
            case "SPIDERCITY":
               _loc2_ = "乱石蛛城";
               break;
            default:
               _loc2_ = "乱石蛛城";
         }
         return _loc2_;
      }
      
      private function updatePropAndSkill() : void
      {
         var _loc4_:int = 0;
         var _loc1_:Image = null;
         propAndSkillLayer.visible = true;
         var _loc2_:Array = GoodsList.instance.getBTPropAndSkill();
         var _loc3_:int = int(_loc2_.length);
         if(_loc3_ == 0)
         {
            selectBtn.visible = true;
            return;
         }
         selectBtn.visible = false;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc1_ = new Image(Assets.sAsset.getTexture("fightgoods" + _loc2_[_loc4_]));
            _loc1_.touchable = false;
            Assets.positionDisplay(_loc1_,"btRoom","prop" + index);
            index = index + 1;
            cardContainer.addChild(_loc1_);
            _loc4_++;
         }
      }
      
      private function removePlayer(param1:int) : void
      {
         if(chars[param1])
         {
            chars[param1].removeFromParent();
            chars[param1] = null;
         }
         mid[param1] = 0;
         charClose[param1].visible = true;
         charOpen[param1].visible = false;
         charEnergy[param1].visible = false;
         charOwner[param1].visible = false;
         charLevel[param1].visible = false;
         charNames[param1].visible = false;
         charReady[param1].visible = false;
      }
      
      private function bindNet() : void
      {
         CopyServer.instance.otherLeaveRoom(onOtherLeaveRoom);
         CopyServer.instance.onKickOut(onKickOutCallback);
         CopyServer.instance.otherJoinInRoom(onOtherJoinRoom);
         CopyServer.instance.onPlayerReady(onPlayerReadyCallback);
         CopyServer.instance.onOpenCloseSite(onOpenCloseSite);
         CopyServer.instance.onGameStart(gameStart);
         CopyServer.instance.onPlayerUseEnergy(playerUseEnergy);
         CopyServer.instance.onChangeClothes(onSomeoneChangeClothes);
      }
      
      private function unBindNet() : void
      {
         CopyServer.instance.disposeRecvFun(onOtherLeaveRoom);
         CopyServer.instance.disposeRecvFun(onKickOutCallback);
         CopyServer.instance.disposeRecvFun(onOtherJoinRoom);
         CopyServer.instance.disposeRecvFun(onPlayerReadyCallback);
         CopyServer.instance.disposeRecvFun(onOpenCloseSite);
         CopyServer.instance.disposeRecvFun(gameStart);
         CopyServer.instance.disposeRecvFun(playerUseEnergy);
         CopyServer.instance.disposeRecvFun(onSomeoneChangeClothes);
      }
      
      private function onSomeoneChangeClothes(param1:Object) : void
      {
         var _loc3_:Array = param1.data.playerInfo;
         var _loc2_:uint = uint(_loc3_[1]);
         var _loc4_:String = _loc3_[2];
         var _loc5_:Character = chars[_loc2_];
         _loc5_.initData(GoodsList.instance.getBodyGoods(_loc4_));
      }
      
      private function onOtherJoinRoom(param1:Object) : void
      {
         LevelLogger.getLogger("TeamRoom addPlayer[有玩家加入队伍]").info(JSON.stringify(param1));
         playerNum = playerNum + 1;
         var _loc3_:Array = param1.data.playerInfo;
         var _loc4_:Character = CharacterFactory.instance.checkOutCharacter(_loc3_[2]);
         _loc4_.initData(GoodsList.instance.getBodyGoods(_loc3_[7]));
         var _loc2_:int = int(_loc3_[6]);
         addSite(_loc2_,_loc4_);
         mid[_loc2_] = _loc3_[0];
         charNames[_loc2_].text = _loc3_[1];
         charLevel[_loc2_].text = String(_loc3_[3]);
         charOwner[_loc2_].visible = _loc3_[4] == 0 ? false : true;
         charEneyValue[_loc2_].text = _loc3_[8] + "/" + 60;
         energyBar[_loc2_].ratio = _loc3_[8] / 60;
         PlayerDataList.instance.copyGameAddSinglePlayer(param1);
         if(PlayerDataList.instance.selfData.houseOwner == 1)
         {
            disableStartGameBtn();
         }
         if(timerSecond)
         {
            timerSecond.stop();
            selectBtn.touchable = true;
            btnSelect.touchable = true;
         }
      }
      
      private function onOtherLeaveRoom(param1:Object) : void
      {
         trace("玩家离开:" + JSON.stringify(param1));
         var _loc3_:int = int(param1.data.uid);
         var _loc2_:int = int(param1.data.siteId);
         var _loc4_:int = int(param1.data.ownerSite);
         charOwner[_loc4_].visible = true;
         playerNum = playerNum - 1;
         if(mySite == _loc4_)
         {
            PlayerDataList.instance.selfData.houseOwner = 1;
            disableStartGameBtn();
            charReady[mySite].visible = false;
         }
         else
         {
            charReady[_loc4_].visible = false;
         }
         if(_loc2_ == mySite)
         {
            PlayerDataList.instance.selfData.houseOwner = 0;
         }
         removePlayer(_loc2_);
         PlayerDataList.instance.removePlayerByUID(_loc3_);
         if(PlayerDataList.instance.selfData.houseOwner == 1 && playerNum == 1 || isAllReady())
         {
            showStartGameBtn();
         }
      }
      
      private function onKickOutCallback(param1:Object) : void
      {
         trace("通知玩家被踢出房间:" + JSON.stringify(param1));
         playerNum = playerNum - 1;
         if(param1.data.site == mySite)
         {
            TextTip.instance.showByLang("teamList3");
            dispatchEventWith("complete");
            cleanUp();
         }
         else
         {
            removePlayer(param1.data.site);
         }
      }
      
      private function addPlayer(param1:Object) : void
      {
         var _loc5_:int = 0;
         var _loc4_:Array = null;
         var _loc9_:int = 0;
         var _loc3_:int = 0;
         var _loc8_:Character = null;
         var _loc7_:Array = null;
         var _loc2_:int = 0;
         var _loc6_:int = 0;
         trace("addPlayer:",JSON.stringify(param1));
         if(param1.data.flag == 1)
         {
            _loc5_ = int(param1.data.size);
            playerNum = param1.data.size;
            _loc4_ = param1.data.playerInfo;
            _loc9_ = 0;
            while(_loc9_ < _loc5_)
            {
               _loc3_ = int(_loc4_[_loc9_][6]);
               _loc8_ = CharacterFactory.instance.checkOutCharacter(_loc4_[_loc9_][2]);
               _loc8_.initData(GoodsList.instance.getBodyGoods(_loc4_[_loc9_][7]));
               mid[_loc3_] = _loc4_[_loc9_][0];
               if(_loc4_[_loc9_][0] == PlayerDataList.instance.selfData.uid)
               {
                  mySite = _loc4_[_loc9_][6];
                  PlayerDataList.instance.setSelfSite(mySite,0);
                  PlayerDataList.instance.selfData.houseOwner = _loc4_[_loc9_][4];
               }
               addSite(_loc3_,_loc8_);
               charNames[_loc3_].text = _loc4_[_loc9_][1];
               charLevel[_loc3_].text = String(_loc4_[_loc9_][3]);
               charOwner[_loc3_].visible = _loc4_[_loc9_][4] == 0 ? false : true;
               charEneyValue[_loc3_].text = _loc4_[_loc9_][8] + "/" + 60;
               energyBar[_loc3_].ratio = _loc4_[_loc9_][8] / 60;
               charReady[_loc3_].visible = _loc4_[_loc9_][9] == 0 ? false : true;
               _loc9_++;
            }
            _loc7_ = param1.data.siteArr;
            _loc2_ = int(_loc7_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc2_)
            {
               if(_loc7_[_loc6_] == 1)
               {
                  charClose[_loc6_].visible = true;
                  charOpen[_loc6_].visible = false;
               }
               else if(_loc7_[_loc6_] == 0)
               {
                  charClose[_loc6_].visible = false;
                  charOpen[_loc6_].visible = true;
               }
               _loc6_++;
            }
            if(PlayerDataList.instance.selfData.houseOwner == 1)
            {
               if(playerNum == 1 || isAllReady())
               {
                  showStartGameBtn();
               }
               else
               {
                  disableStartGameBtn();
               }
               btnInvite.visible = true;
            }
            else
            {
               showStartReadyBtn();
               btnInvite.visible = false;
            }
         }
      }
      
      private function addSite(param1:int, param2:Character) : void
      {
         var _loc3_:Rectangle = Assets.getPosition("btRoom","pos" + param1);
         param2.x = _loc3_.x - 15;
         param2.y = _loc3_.y + 80;
         param2.scaleX = param2.scaleY = 0.4;
         chars[param1] = param2;
         spriteChar.addChild(param2);
         charClose[param1].visible = false;
         charOpen[param1].visible = false;
         charBg[param1].visible = true;
         charEnergy[param1].visible = true;
         charLevel[param1].visible = true;
         charNames[param1].visible = true;
         charReady[param1].visible = false;
      }
      
      private function gameStart(param1:Object) : void
      {
         var _loc3_:int = 0;
         LevelLogger.getLogger("TeamRoom gameStart[玩家都准备好，进入战斗...]").info(JSON.stringify(param1));
         Application.instance.currentGame._copyModeOptionsData.playerInfoArr = [];
         var _loc2_:Array = param1.data.playerInfoArr;
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            Application.instance.currentGame._copyModeOptionsData.playerInfoArr[_loc2_[_loc3_][1]] = _loc2_[_loc3_][2];
            _loc3_++;
         }
         BossWorld.goBossFight();
      }
      
      private function playerUseEnergy(param1:Object) : void
      {
         var _loc2_:int = int(param1.data.siteId);
         var _loc3_:int = int(param1.data.energy);
         charEneyValue[_loc2_].text = _loc3_.toString() + "/60";
         energyBar[_loc2_].ratio = _loc3_ / 60;
      }
      
      private function onOpenCloseSite(param1:Object) : void
      {
         trace("关闭、打开座位：" + JSON.stringify(param1));
         var _loc2_:int = int(param1.data.site);
         if(param1.data.flag == 1)
         {
            charClose[_loc2_].visible = true;
            charOpen[_loc2_].visible = false;
         }
         else
         {
            charOpen[_loc2_].visible = true;
            charClose[_loc2_].visible = false;
         }
      }
      
      private function onPlayerReadyCallback(param1:Object) : void
      {
         trace("是否准备好：" + JSON.stringify(param1));
         var _loc2_:int = int(param1.data.site);
         if(param1.data.flag == 0)
         {
            charReady[_loc2_].visible = false;
            if(timerSecond && timerSecond.parent)
            {
               timerSecond.stop();
            }
         }
         else
         {
            charReady[_loc2_].visible = true;
         }
         if(PlayerDataList.instance.selfData.houseOwner == 1)
         {
            if(isAllReady())
            {
               showStartGameBtn();
               timerSecond = new TimerSecond();
               Assets.positionDisplay(timerSecond,"bfUILayer","second");
               addChild(timerSecond);
               timerSecond.timeoverSignal.add(timeToPlayGame);
               timerSecond.start(10);
               showStopGameBtn();
               if(btSkillDlg && btSkillDlg.parent)
               {
                  btSkillDlg.onClose();
                  btSkillDlg = null;
               }
               selectBtn.touchable = false;
               btnSelect.touchable = false;
               Application.instance.currentGame.mainMenu.isEnable(false);
            }
            else
            {
               disableStartGameBtn();
               selectBtn.touchable = true;
               btnSelect.touchable = true;
               Application.instance.currentGame.mainMenu.isEnable(true);
            }
         }
      }
      
      private function isAllReady() : Boolean
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            if(mid[_loc1_] != 0 && mid[_loc1_] != PlayerDataList.instance.selfData.uid)
            {
               if(!charReady[_loc1_].visible)
               {
                  return false;
               }
            }
            _loc1_++;
         }
         return true;
      }
      
      private function timeToPlayGame() : void
      {
         var _loc1_:CopyDetailData = CopyList.instance.currentCopyData;
         if(PlayerDataList.instance.selfData.energy < 3)
         {
            LessPowerDlg.show(this);
            return;
         }
         CopyServer.instance.startGameInRoom(_loc1_.cpdtlid);
      }
      
      private function showStartGameBtn() : void
      {
         disStartGame.visible = false;
         btnStartGame.visible = true;
         btnStartReady.visible = false;
         btnStopReady.visible = false;
         btnStopGame.visible = false;
      }
      
      private function showStopGameBtn() : void
      {
         btnStartReady.visible = false;
         btnStopReady.visible = false;
         btnStartGame.visible = false;
         disStartGame.visible = false;
         btnStopGame.visible = true;
      }
      
      private function disableStartGameBtn() : void
      {
         disStartGame.visible = true;
         btnStartGame.visible = false;
         btnStartReady.visible = false;
         btnStopReady.visible = false;
         btnStopGame.visible = false;
      }
      
      private function showStartReadyBtn() : void
      {
         disStartGame.visible = false;
         btnStartGame.visible = false;
         btnStartReady.visible = true;
         btnStopReady.visible = false;
         btnStopGame.visible = false;
      }
      
      private function showStopReadyBtn() : void
      {
         disStartGame.visible = false;
         btnStartGame.visible = false;
         btnStartReady.visible = false;
         btnStopReady.visible = true;
         btnStopGame.visible = false;
      }
      
      private function hasWeapon() : Boolean
      {
         var _loc2_:PlayerData = PlayerDataList.instance.selfData;
         var _loc1_:GoodsData = _loc2_.getWeapon();
         if(!_loc1_ || _loc1_.place != 1)
         {
            TextTip.instance.show(LangManager.t("noWeapon"));
            return false;
         }
         return true;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.pivotX = 524;
         this.pivotY = 383;
         this.x = 524;
         this.y = 383;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.6,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeInOut"
         });
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:Vector.<Touch> = param1.getTouches(this.stage);
         if(_loc2_.length > 0 && _loc2_[0].phase == "began")
         {
            _loc3_ = param1.getTouches(spriteChar);
            if(_loc3_.length > 0 && _loc3_[0].phase == "began")
            {
               menu.x = _loc3_[0].globalX;
               menu.y = _loc3_[0].globalY;
               trace(_loc3_[0].globalX,_loc3_[0].globalY);
               if(_loc3_[0].globalX > 260 && _loc3_[0].globalX < 390 && _loc3_[0].globalY < 310 && _loc3_[0].globalY > 150)
               {
                  menu.visible = true;
                  id = 0;
               }
               else if(_loc3_[0].globalX > 480 && _loc3_[0].globalX < 605 && _loc3_[0].globalY < 310 && _loc3_[0].globalY > 150)
               {
                  menu.visible = true;
                  id = 1;
               }
               else if(_loc3_[0].globalX > 260 && _loc3_[0].globalX < 390 && _loc3_[0].globalY < 585 && _loc3_[0].globalY > 420)
               {
                  menu.visible = true;
                  id = 2;
               }
               else if(_loc3_[0].globalX > 480 && _loc3_[0].globalX < 605 && _loc3_[0].globalY < 585 && _loc3_[0].globalY > 420)
               {
                  menu.visible = true;
                  id = 3;
               }
               if(PlayerDataList.instance.selfData.houseOwner == 0)
               {
                  btnOutRoom.enabled = false;
               }
               else if(id == mySite)
               {
                  btnOutRoom.enabled = false;
               }
               else
               {
                  btnOutRoom.enabled = true;
               }
            }
            else if(menu.visible)
            {
               _loc4_ = param1.getTouches(menu);
               if(_loc4_.length == 0)
               {
                  menu.visible = false;
               }
            }
         }
      }
      
      private function onKickOut(param1:Event) : void
      {
         menu.visible = false;
         CopyServer.instance.kickPlayer(mid[id]);
         removePlayer(id);
      }
      
      private function onAboutMe() : void
      {
         if(aboutme == null)
         {
            aboutme = new PersonnalInfoDlg();
         }
         updateAboutme();
         parent.addChild(aboutme);
      }
      
      private function getPlayerInfo(param1:Object) : void
      {
         Application.instance.log("AboutMe显示人个信息:",JSON.stringify(param1));
         aboutme.showPlayerInfo(param1);
      }
      
      private function onCheck(param1:Event) : void
      {
         menu.visible = false;
         onAboutMe();
      }
      
      private function onInvite(param1:Event) : void
      {
         var _loc2_:InviteFriendsDlg = null;
         if(PlayerDataList.instance.selfData.houseOwner == 1)
         {
            if(playerNum == 4)
            {
               TextTip.instance.showByLang("teamList1");
            }
            else
            {
               _loc2_ = new InviteFriendsDlg();
               addChild(_loc2_);
               _loc2_.x = 1365 - _loc2_.width >> 1;
               _loc2_.y = 768 - _loc2_.height >> 1;
            }
         }
         else
         {
            TextTip.instance.showByLang("invite8");
         }
      }
      
      private function onStartGame(param1:Event) : void
      {
         var e:Event = param1;
         if(!hasWeapon())
         {
            return;
         }
         GameServer.instance.sentMsgToGetEnergy();
         GameServer.instance.getPlayerEnergy((function():*
         {
            var call:Function;
            return call = function(param1:Object):void
            {
               var _loc4_:LessPowerDlg = null;
               var _loc2_:int = int(param1.data.userId);
               var _loc5_:int = int(param1.data.type);
               var _loc3_:int = int(param1.data.energy);
               PlayerDataList.instance.selfData.energy = _loc3_;
               if(PlayerDataList.instance.selfData.energy < 3)
               {
                  _loc4_ = new LessPowerDlg();
                  Application.instance.currentGame.stage.addChild(_loc4_);
                  _loc4_.x = 1365 - _loc4_.width >> 1;
                  _loc4_.y = 768 - _loc4_.height >> 1;
               }
               else
               {
                  if(PlayerDataList.instance.selfData.houseOwner == 1)
                  {
                     CopyServer.instance.startGameInRoom(CopyList.instance.currentCopyData.cpdtlid);
                  }
                  CopyServer.instance.playerReady(1);
                  if(e.currentTarget as Button == btnStartGame)
                  {
                     showStopGameBtn();
                  }
                  else
                  {
                     showStopReadyBtn();
                  }
                  charReady[mySite].visible = true;
                  selectBtn.touchable = false;
                  btnSelect.touchable = false;
                  Application.instance.currentGame.mainMenu.isEnable(false);
                  Application.instance.currentGame.mainMenu.MessageBtn.touchable = true;
               }
            };
         })());
      }
      
      private function onStopGame(param1:Event) : void
      {
         CopyServer.instance.playerReady(0);
         if(param1.currentTarget as Button == btnStopGame)
         {
            if(timerSecond)
            {
               timerSecond.stop();
            }
            showStartGameBtn();
         }
         else
         {
            showStartReadyBtn();
         }
         charReady[mySite].visible = false;
         selectBtn.touchable = true;
         btnSelect.touchable = true;
         Application.instance.currentGame.mainMenu.isEnable(true);
      }
      
      private function onSelect(param1:Event) : void
      {
         cardContainer.removeChildren();
         index = 0;
         propIndex = 4;
         btSkillDlg = new BtSkillDlg();
         addChild(btSkillDlg);
         btSkillDlg.closeSignal.add(updatePropAndSkill);
      }
      
      private function onOpen(param1:Event) : void
      {
         if(PlayerDataList.instance.selfData.houseOwner == 0)
         {
            return;
         }
         var _loc3_:DisplayObject = param1.currentTarget as DisplayObject;
         var _loc2_:int = int(_loc3_.parent.name.substr(-1,1));
         _loc3_.visible = false;
         _loc3_.parent.getChildByName("btn_close").visible = true;
         _loc3_.parent.getChildByName("playerBg").visible = true;
         CopyServer.instance.openSite(_loc2_);
      }
      
      private function onRemove(param1:Event) : void
      {
         if(PlayerDataList.instance.selfData.houseOwner == 0)
         {
            return;
         }
         var _loc3_:DisplayObject = param1.currentTarget as DisplayObject;
         var _loc2_:int = int(_loc3_.parent.name.substr(-1,1));
         _loc3_.visible = false;
         trace(_loc3_.parent.name,"关闭座位号:" + _loc2_);
         _loc3_.parent.getChildByName("btnOpen").visible = true;
         _loc3_.parent.getChildByName("playerBg").visible = false;
         CopyServer.instance.closeSite(_loc2_);
      }
      
      private function onClose(param1:Event) : void
      {
         var e:Event = param1;
         SystemTip.instance.showSystemAlert(LangManager.t("leave"),function():void
         {
            if(PlayerDataList.instance.selfData.houseOwner == 1)
            {
               PlayerDataList.instance.selfData.houseOwner = 0;
            }
            if(charReady[mySite].visible)
            {
               CopyServer.instance.playerReady(0);
               charReady[mySite].visible = false;
            }
            Starling.juggler.tween(SystemTip.instance,0.3,{
               "scaleX":0,
               "scaleY":0,
               "transition":"easeIn",
               "onComplete":cleanUp
            });
            exit();
            dispatchEventWith("complete");
         },function():void
         {
         });
      }
      
      private function cleanUp() : void
      {
         Application.instance.currentGame._copyModeOptionsData.retData = null;
         mid = [];
         Starling.juggler.removeTweens(this);
         if(this.stage)
         {
            this.stage.removeEventListener("touch",onTouch);
         }
         removeFromParent();
      }
      
      private function updateAboutme() : void
      {
         if(id == mySite)
         {
            Remoting.instance.getMemStatus(mid[id],getPlayerInfo);
            aboutme.isFriend = true;
         }
         else
         {
            Remoting.instance.getMemStatus(mid[id],getPlayerInfo);
         }
      }
      
      public function exit() : void
      {
         CopyServer.instance.leaveRoom();
      }
      
      override public function dispose() : void
      {
         Application.instance.currentGame.mainMenu.isEnable(true);
         unBindNet();
         btnClose.removeEventListener("triggered",onClose);
         btnInvite.removeEventListener("triggered",onInvite);
         btnStopGame.removeEventListener("triggered",onStopGame);
         btnStartGame.removeEventListener("triggered",onStartGame);
         btnStartReady.removeEventListener("triggered",onStartGame);
         btnStopReady.removeEventListener("triggered",onStopGame);
         for each(var _loc1_ in chars)
         {
            CharacterFactory.instance.checkInCharacter(_loc1_);
         }
         chars = null;
         super.dispose();
         Assets.sAsset.removeTextureAtlas("copygameui");
         Assets.sAsset.removeTextureAtlas("skycity");
         Assets.sAsset.removeTextureAtlas("btdlg");
      }
      
      public function get optionsData() : Object
      {
         return _optionsData;
      }
      
      public function set optionsData(param1:Object) : void
      {
         _optionsData = param1;
      }
   }
}

