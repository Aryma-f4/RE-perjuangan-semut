package com.boyaa.antwars.view.screen.battlefield
{
   import com.boyaa.antwars.data.AllRoomData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.DisableAll;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.display.Gauge;
   import com.boyaa.antwars.view.screen.IMainMenu;
   import com.boyaa.antwars.view.screen.UIExportScreen;
   import com.boyaa.antwars.view.screen.battlefield.element.NumberView;
   import com.boyaa.antwars.view.screen.battlefield.element.bullet.BulletSlottingManager;
   import com.boyaa.antwars.view.screen.battlefield.ui.BtRoomPlayerBox;
   import com.boyaa.antwars.view.screen.battlefield.ui.MultiStateButton;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.BtRoomPropItemListRender;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.UseSkillManager;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.WeaponChangeManager;
   import com.boyaa.antwars.view.screen.chatRoom.EmotionPlay;
   import com.boyaa.antwars.view.screen.copygame.team.InviteFriendsDlg;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideEventManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import com.boyaa.antwars.view.screen.wedding.WeddingManager;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.antwars.view.vipSystem.VipLevelIcon;
   import com.boyaa.antwars.view.vipSystem.VipManager;
   import com.boyaa.debug.Logging.LevelLogger;
   import com.boyaa.tool.RandomNum;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import starling.utils.formatString;
   
   public class BtRoom extends UIExportScreen implements IMainMenu, IGuideProcess
   {
      
      public static const SHOW_BATTLEFIELD:String = "showBattlefield";
      
      private var topLayer:Sprite;
      
      private var roomTextField:TextField;
      
      private var btnClose:Button;
      
      private var zymsBtn:Button;
      
      private var jjmsBtn:Button;
      
      private var characterLayer:Sprite;
      
      private var charNames:Vector.<TextField>;
      
      private var siteImage:Vector.<Image>;
      
      private var unMatchImage:Vector.<Image>;
      
      private var ratioBgImage:Vector.<Image>;
      
      private var percentImage:Vector.<Image>;
      
      private var ratioImage:Vector.<Gauge>;
      
      private var numView:Vector.<NumberView>;
      
      private var vsMovie:MovieClip;
      
      private var clip:Sprite;
      
      private var matchingImage:Image;
      
      private var matchingImage2:Image;
      
      private var tween:Tween;
      
      private var randomMapLayer:Sprite;
      
      private var smallMap:Image;
      
      private var matchLayer:Sprite;
      
      private var border:Image;
      
      private var imgDisable0:Image;
      
      private var imgDisable1:Image;
      
      private var kshfBtn:Button;
      
      private var yqbyBtn:Button;
      
      private var startBtn:Button;
      
      private var stopBtn:Button;
      
      private var propAndSkillLayer:Sprite;
      
      private var cardContainer:Sprite;
      
      public var selectBtn:Button;
      
      private var boxbg:Button;
      
      private var index:int = 0;
      
      private var propIndex:int = 4;
      
      private var _pk_type:int = 0;
      
      private var siteStatus:Array = [1,1,1,1];
      
      private var characters:Array = [null,null,null,null];
      
      private var _readyImageVec:Vector.<Image> = new Vector.<Image>();
      
      private var _vipIconArr:Vector.<VipLevelIcon> = new Vector.<VipLevelIcon>();
      
      protected var _optionsData:Object;
      
      public var inGuide:Boolean = false;
      
      private var _propButton:FashionStarlingButton;
      
      private var _weaponButton:FashionStarlingButton;
      
      private var _inviteButton:FashionStarlingButton;
      
      private var _changeRoomButton:FashionStarlingButton;
      
      private var _readyButton:FashionStarlingButton;
      
      private var _startButton:MultiStateButton;
      
      private var _backButton:FashionStarlingButton;
      
      private var _roomId:int;
      
      private var _propAndWeaponList:List;
      
      private var _charBoxVec:Vector.<BtRoomPlayerBox>;
      
      private var _roomMode:int;
      
      private var _siteStateArr:Array = [];
      
      private var _inviteDlg:InviteFriendsDlg = null;
      
      public function BtRoom()
      {
         super();
         if(!Assets.btAsset)
         {
            Assets.btAsset = new ResAssetManager(Assets.sAsset.scaleFactor);
            Assets.btAsset.verbose = Constants.debug;
         }
         DisableAll.instance.enabled = false;
         BulletSlottingManager.instance.clear();
      }
      
      public function get optionsData() : Object
      {
         return _optionsData;
      }
      
      public function set optionsData(param1:Object) : void
      {
         _optionsData = param1;
         invalidate("data");
      }
      
      public function set roomId(param1:int) : void
      {
         _roomId = param1;
         getTextFieldByName("roomIdText").text = "" + _roomId;
      }
      
      public function get roomMode() : int
      {
         return _roomMode;
      }
      
      public function set roomMode(param1:int) : void
      {
         _roomMode = param1;
      }
      
      public function get pk_type() : int
      {
         return _pk_type;
      }
      
      override protected function initialize() : void
      {
         var rmger:ResManager;
         Application.instance.log("BTROOM","initialize");
         super.initialize();
         if(Assets.sAsset.getTextureAtlas("btdlg") && Assets.sAsset.getTextureAtlas("emoticon") && Assets.sAsset.getTextureAtlas("BattlefieldUI"))
         {
            initNewUI();
            Application.instance.currentGame.hiddenLoading();
            return;
         }
         Application.instance.currentGame.showLoading();
         rmger = Application.instance.resManager;
         Assets.sAsset.enqueue(rmger.getResFile(formatString("textures/{0}x/BT/btdlg.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/btdlg.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/BattlefieldUI.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/BattlefieldUI.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/btRoom.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/btRoom.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/battlefieldSpritesheet.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/battlefieldSpritesheet.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/emoticon.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/emoticon.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYGAME/copygameui.png"
         ,Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYGAME/copygameui.xml",Assets.sAsset.scaleFactor)));
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
                     initNewUI();
                     Application.instance.currentGame.hiddenLoading();
                     SoundManager.playBgSound("Music 5");
                  },0.15);
               }
            };
         })());
      }
      
      private function initNewUI() : void
      {
         _layoutUtil = new LayoutUitl(Assets.sAsset.getOther("btRoom"));
         _layoutUtil.buildLayout("btRoomLayout",_displayObj);
         _pk_type = optionsData.pk_type;
         _roomMode = optionsData.pk_mode;
         _siteStateArr = optionsData.siteStatusArr;
         AllRoomData.instance.roomID = _optionsData.roomid;
         PlayerDataList.instance.pk_type = _pk_type;
         PlayerDataList.instance.fightMode = _roomMode;
         initFightData();
         initButtons();
         initList();
         initCharBox();
         initUIData();
         bindNet();
         addOtherPlayers();
         _displayObj.addChild(Application.instance.currentGame.mainMenu);
         Application.instance.currentGame.mainMenu.parentWin = this;
         posGuide();
      }
      
      private function initFightData() : void
      {
         WeaponChangeManager.instance.initWeapon();
      }
      
      private function addOtherPlayers() : void
      {
         var _loc2_:int = 0;
         var _loc1_:PlayerData = null;
         _loc2_ = 0;
         while(_loc2_ < PlayerDataList.instance.list.length)
         {
            _loc1_ = PlayerDataList.instance.list[_loc2_];
            if(_loc1_.siteID != PlayerDataList.instance.selfData.siteID)
            {
               if(!_loc1_.leaving)
               {
                  addSite(_loc1_);
               }
            }
            _loc2_++;
         }
      }
      
      private function initUIData() : void
      {
         roomId = optionsData.roomid;
      }
      
      private function initButtons() : void
      {
         _propButton = new FashionStarlingButton(getButtonByName("propButton"));
         _weaponButton = new FashionStarlingButton(getButtonByName("weaponButton"));
         _propButton.groupTag = _weaponButton.groupTag = "CHANGE_PROP";
         _propButton.triggerFunction = onChangePropOrWeapon;
         _weaponButton.triggerFunction = onChangePropOrWeapon;
         _propButton.isSelect = true;
         _inviteButton = new FashionStarlingButton(getButtonByName("inviteButton"));
         _changeRoomButton = new FashionStarlingButton(getButtonByName("changeRoomButton"));
         _inviteButton.triggerFunction = onInviteFriends;
         _changeRoomButton.triggerFunction = onChangeRoomHandle;
         _backButton = new FashionStarlingButton(getButtonByName("backButton"));
         _backButton.triggerFunction = onBackToGameHall;
         _startButton = new MultiStateButton([getButtonByName("startButton"),getButtonByName("readyButton"),getButtonByName("cancelButton")]);
         _startButton.addEventListener("buttonTouch",onStartButtonTouch);
         if(roomMode == 0 && pk_type == 0)
         {
            _inviteButton.isGray = true;
         }
         showStartButtonState();
      }
      
      private function onStartButtonTouch(param1:Event) : void
      {
         var _loc2_:Object = param1.data;
         switch(_loc2_.idx)
         {
            case 0:
               onGameStart();
               break;
            case 1:
               BattleServer.instance.selfReady(1);
               itemsTouchable(false);
               break;
            case 2:
               BattleServer.instance.selfReady(0);
               itemsTouchable(true);
         }
      }
      
      private function showStartButtonState(param1:int = 0) : void
      {
         if(param1 == 0)
         {
            if(PlayerDataList.instance.selfData.houseOwner)
            {
               _startButton.showButtonById(0);
            }
            else
            {
               _startButton.showButtonById(1);
            }
         }
         else
         {
            _startButton.showButtonById(2);
         }
         isStartButtonGray();
      }
      
      private function isStartButtonGray() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 1;
         var _loc2_:int = 0;
         _loc2_ = 3;
         _startButton.isGray = false;
         if(PlayerDataList.instance.selfData.houseOwner)
         {
            switch(roomMode)
            {
               case 0:
                  if(pk_type && getReadyCount() < 1)
                  {
                     _startButton.isGray = true;
                  }
                  break;
               case 1:
                  if(pk_type == 0 && getReadyCount() < 1)
                  {
                     _startButton.isGray = true;
                  }
                  if(pk_type && getReadyCount() < 3)
                  {
                     _startButton.isGray = true;
                  }
            }
         }
      }
      
      private function initList() : void
      {
         _propAndWeaponList = new List();
         _propAndWeaponList.layout = SmallCodeTools.instance.getListRowsLayout(1,30);
         _propAndWeaponList.itemRendererType = BtRoomPropItemListRender;
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("propListPos"),_propAndWeaponList);
         addChildToDisplayObject(_propAndWeaponList);
         _propAndWeaponList.dataProvider = new ListCollection(getSkillData());
         _propAndWeaponList.addEventListener("change",onListChangeHandle);
      }
      
      private function initCharBox() : void
      {
         var _loc4_:int = 0;
         var _loc3_:BtRoomPlayerBox = null;
         var _loc1_:DisplayObject = null;
         _charBoxVec = new Vector.<BtRoomPlayerBox>();
         _pk_type = optionsData.pk_type;
         var _loc2_:Array = [];
         _loc2_[0] = ["singlePlayer",2,[0,1]];
         _loc2_[1] = ["multiPlayer",4,[0,0,1,1]];
         _loc4_ = 0;
         while(_loc4_ < _loc2_[_pk_type][1])
         {
            _loc3_ = new BtRoomPlayerBox(_loc2_[_pk_type][2][_loc4_]);
            _loc1_ = getDisplayObjectByName(_loc2_[_pk_type][0] + _loc4_);
            _charBoxVec.push(_loc3_);
            SmallCodeTools.instance.setDisplayObjectInSamePos(_loc1_,_loc3_);
            _loc3_.setBoxByDisplayObject(_loc1_);
            addChildToDisplayObject(_loc3_);
            _loc4_++;
         }
         addSite(PlayerDataList.instance.selfData);
      }
      
      private function onListChangeHandle(param1:Event) : void
      {
         var _loc3_:BtSkillDlg = null;
         var _loc2_:List = param1.currentTarget as List;
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         if(_propButton.isSelect)
         {
            _loc3_ = new BtSkillDlg();
         }
         else
         {
            _loc3_ = new BtSkillDlg(1);
         }
         _displayObj.addChild(_loc3_);
         _loc3_.setCloseCallBack(updatePropAndSkill);
         _loc2_.selectedIndex = -1;
      }
      
      private function onBackToGameHall(param1:Event) : void
      {
         exit();
      }
      
      private function onChangePropOrWeapon(param1:Event) : void
      {
         var _loc2_:Button = param1.target as Button;
         if(_loc2_ == _propButton.starlingBtn)
         {
            _propAndWeaponList.dataProvider = new ListCollection(getSkillData());
         }
         else
         {
            _propAndWeaponList.dataProvider = new ListCollection(getWeaponData());
         }
      }
      
      private function getSkillData() : Array
      {
         var _loc3_:int = 0;
         UseSkillManager.instance.initSkillState();
         var _loc2_:int = int(UseSkillManager.instance.skillDataVector.length);
         var _loc1_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < 8)
         {
            if(_loc3_ < _loc2_)
            {
               _loc1_.push(UseSkillManager.instance.skillDataVector[_loc3_]);
            }
            else if(VipManager.instance.getVipPowerTimes(4) == 0 && _loc3_ == 7)
            {
               _loc1_.push({"string":"lock"});
            }
            else
            {
               _loc1_.push({"string":"add"});
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      private function getWeaponData() : Array
      {
         var _loc3_:int = 0;
         var _loc2_:int = int(WeaponChangeManager.instance.weaponVec.length);
         var _loc1_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < 8)
         {
            if(_loc3_ < _loc2_)
            {
               _loc1_.push(WeaponChangeManager.instance.weaponVec[_loc3_]);
            }
            else if(_loc3_ > 1)
            {
               _loc1_.push({"string":"lock"});
            }
            else
            {
               _loc1_.push({"string":"add"});
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      private function getCharBoxBySiteID(param1:int) : BtRoomPlayerBox
      {
         for each(var _loc2_ in _charBoxVec)
         {
            if(_loc2_.playerData && param1 == _loc2_.playerData.siteID)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function getEmptyCharBoxByTeam(param1:int) : Array
      {
         var _loc2_:Array = [];
         for each(var _loc3_ in _charBoxVec)
         {
            if(_loc3_.team == param1 && !_loc3_.playerData)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function init() : void
      {
         var _loc7_:int = 0;
         var _loc3_:Image = null;
         this.visible = false;
         PlayerDataList.instance.removePlayers();
         var _loc11_:Image = new Image(Assets.sAsset.getTexture("zdpp"));
         _loc11_.y = 50;
         addChild(_loc11_);
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("zdpp_bottom"));
         Assets.positionDisplay(_loc2_,"btRoom","bottomBar");
         addChild(_loc2_);
         topLayer = new Sprite();
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("vs"));
         Assets.positionDisplay(_loc5_,"btRoom","vs");
         topLayer.addChild(_loc5_);
         var _loc4_:Image = new Image(Assets.sAsset.getTexture("top_bar"));
         Assets.positionDisplay(_loc4_,"btRoom","top_bar");
         topLayer.addChild(_loc4_);
         var _loc12_:Image = new Image(Assets.sAsset.getTexture("room"));
         Assets.positionDisplay(_loc12_,"btRoom","img_room");
         topLayer.addChild(_loc12_);
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("bg_text"));
         Assets.positionDisplay(_loc1_,"btRoom","img_room_bg");
         topLayer.addChild(_loc1_);
         btnClose = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         btnClose.addEventListener("triggered",onBackToHall);
         btnClose.x = Assets.rightTop.x - btnClose.width;
         btnClose.y = Assets.rightTop.y;
         topLayer.addChild(btnClose);
         var _loc13_:Rectangle = Assets.getPosition("btRoom","roomname");
         roomTextField = new TextField(_loc13_.width,_loc13_.height,"000 房号","Verdana",18,16777215);
         roomTextField.x = _loc13_.x;
         roomTextField.y = _loc13_.y;
         roomTextField.text = LangManager.t("roomID") + "：" + _optionsData.roomid;
         roomTextField.autoScale = true;
         topLayer.addChild(roomTextField);
         zymsBtn = new Button(Assets.sAsset.getTexture("zdpp9"),"",Assets.sAsset.getTexture("zdpp10"));
         Assets.positionDisplay(zymsBtn,"btRoom","zdpp9");
         topLayer.addChild(zymsBtn);
         jjmsBtn = new Button(Assets.sAsset.getTexture("zdpp11"),"",Assets.sAsset.getTexture("zdpp12"));
         Assets.positionDisplay(jjmsBtn,"btRoom","zdpp11");
         topLayer.addChild(jjmsBtn);
         zymsBtn.enabled = false;
         jjmsBtn.touchable = false;
         if(_optionsData.pk_mode == 0)
         {
            jjmsBtn.upState = Assets.sAsset.getTexture("zdpp12");
         }
         else if(_optionsData.pk_mode == 1)
         {
            zymsBtn.upState = Assets.sAsset.getTexture("zdpp10");
         }
         addChild(topLayer);
         characterLayer = new Sprite();
         initPlayerInfo();
         addVSFireAnimation();
         addChild(characterLayer);
         randomMapLayer = new Sprite();
         Assets.positionDisplay(randomMapLayer,"btRoom","zdpp15");
         addChild(randomMapLayer);
         var _loc6_:Image = new Image(Assets.sAsset.getTexture("zdpp15"));
         randomMapLayer.addChild(_loc6_);
         smallMap = new Image(Assets.sAsset.getTexture("smallmap_0"));
         var _loc8_:Rectangle = Assets.getPosition("btRoom","mapthumb");
         var _loc9_:Point = randomMapLayer.globalToLocal(new Point(_loc8_.x,_loc8_.y));
         smallMap.width = _loc8_.width;
         smallMap.height = _loc8_.height;
         smallMap.x = _loc9_.x;
         smallMap.y = _loc9_.y;
         randomMapLayer.addChild(smallMap);
         var _loc10_:Image = new Image(Assets.sAsset.getTexture("zdpp_map_random"));
         _loc10_.name = "randomMap";
         randomMapLayer.addChild(_loc10_);
         _loc10_.x = _loc9_.x + (smallMap.width - _loc10_.width >> 1);
         _loc10_.y = _loc9_.y + (smallMap.height - _loc10_.height >> 1);
         randomMapLayer.touchable = false;
         propAndSkillLayer = new Sprite();
         cardContainer = new Sprite();
         boxbg = new Button(Assets.sAsset.getTexture("zdppp0"),"",Assets.sAsset.getTexture("zdppp1"));
         boxbg.addEventListener("triggered",onSelectSkillBtn);
         Assets.positionDisplay(boxbg,"btRoom","zdpp13");
         selectBtn = new Button(Assets.sAsset.getTexture("select0"),"",Assets.sAsset.getTexture("select1"));
         selectBtn.addEventListener("triggered",onSelectSkillBtn);
         Assets.positionDisplay(selectBtn,"btRoom","zdpp14");
         propAndSkillLayer.addChild(boxbg);
         propAndSkillLayer.addChild(selectBtn);
         propAndSkillLayer.addChild(cardContainer);
         addChild(propAndSkillLayer);
         cardContainer.touchable = false;
         updatePropAndSkill();
         matchLayer = new Sprite();
         border = new Image(Assets.sAsset.getTexture("zdpp23"));
         Assets.positionDisplay(border,"btRoom","zdpp23");
         matchLayer.addChild(border);
         startBtn = new Button(Assets.sAsset.getTexture("zdpp8"));
         startBtn.addEventListener("triggered",onGameStart);
         Assets.positionDisplay(startBtn,"btRoom","zdpp8");
         matchLayer.addChild(startBtn);
         stopBtn = new Button(Assets.sAsset.getTexture("zdpp_qx"));
         stopBtn.addEventListener("triggered",onStopGame);
         Assets.positionDisplay(stopBtn,"btRoom","zdpp8");
         matchLayer.addChild(stopBtn);
         stopBtn.visible = false;
         kshfBtn = new Button(Assets.sAsset.getTexture("zdpp5"),"",Assets.sAsset.getTexture("zdpp7"));
         Assets.positionDisplay(kshfBtn,"btRoom","zdpp5");
         kshfBtn.addEventListener("triggered",onChangeRoomHandle);
         matchLayer.addChild(kshfBtn);
         yqbyBtn = new Button(Assets.sAsset.getTexture("zdpp4"),"",Assets.sAsset.getTexture("zdpp6"));
         Assets.positionDisplay(yqbyBtn,"btRoom","zdpp4");
         yqbyBtn.addEventListener("triggered",onInviteFriends);
         matchLayer.addChild(yqbyBtn);
         imgDisable0 = new Image(Assets.sAsset.getTexture("zdpp16-2"));
         Assets.positionDisplay(imgDisable0,"btRoom","zdpp4");
         matchLayer.addChild(imgDisable0);
         imgDisable1 = new Image(Assets.sAsset.getTexture("zdpp15-2"));
         Assets.positionDisplay(imgDisable1,"btRoom","zdpp5");
         matchLayer.addChild(imgDisable1);
         imgDisable0.visible = imgDisable1.visible = false;
         addChild(matchLayer);
         if(optionsData.pk_type == 0)
         {
            showDisplayObjects([kshfBtn,yqbyBtn,kshfBtn,yqbyBtn],false);
            showDisplayObjects([imgDisable0,imgDisable1]);
         }
         this.visible = true;
         bindNet();
         BattleServer.instance.netDelayTest();
         Application.instance.currentGame.mainMenu.show(this);
         if(Application.instance.currentGame._guideOptionsData.pos == "btRoom")
         {
            Guide.instance.guide(boxbg,LangManager.t("guide14"));
            startBtn.enabled = false;
            Application.instance.currentGame.mainMenu.isEnable(false);
            inGuide = true;
         }
         if(optionsData.otherPlayerData)
         {
            otherComeOn(optionsData.otherPlayerData);
            optionsData.otherPlayerData = null;
         }
         AllRoomData.instance.roomID = _optionsData.roomid;
         _loc7_ = 0;
         while(_loc7_ < 2)
         {
            _loc3_ = new Image(Assets.sAsset.getTexture("img_ready"));
            Assets.positionDisplay(_loc3_,"btRoom","ready" + _loc7_);
            addChild(_loc3_);
            _loc3_.visible = false;
            _readyImageVec.push(_loc3_);
            _loc7_++;
         }
         guideProcess();
      }
      
      private function posGuide() : void
      {
         if(Application.instance.currentGame._guideOptionsData.pos == "btRoom")
         {
            Guide.instance.guide(_startButton.getButtonById(0).starlingBtn,LangManager.t("guide14"));
         }
      }
      
      private function onInviteFriends(param1:Event) : void
      {
         _inviteDlg = new InviteFriendsDlg();
         addChild(_inviteDlg);
         _inviteDlg.x = 1365 - _inviteDlg.width >> 1;
         _inviteDlg.y = 768 - _inviteDlg.height >> 1;
      }
      
      private function showDisplayObjects(param1:Array, param2:Boolean = true) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            param1[_loc3_].visible = param2;
            _loc3_++;
         }
      }
      
      private function onChangeRoomHandle(param1:Event) : void
      {
         BattleServer.instance.sendChangeRoom();
      }
      
      private function bindNet() : void
      {
         BattleServer.instance.otherComeOn(otherComeOn);
         BattleServer.instance.syncBody(syncBody);
         BattleServer.instance.mapPROGRESS(mapPROGRESS);
         BattleServer.instance.gameStart(gameStart);
         BattleServer.instance.onRobotCome(onRobotCome);
         BattleServer.instance.onStartRobot(onStartRobot);
         BattleServer.instance.allReadyGo(allReadyGo);
         BattleServer.instance.onPlayerLeave(onPlayerLeave);
         BattleServer.instance.playerReady(onPlayerReady);
         BattleServer.instance.onChangeRoomError(onChangeRoomError);
         BattleServer.instance.onChangeRoomFast(onChangeRoomFast);
         BattleServer.instance.on2v2RobotGameStart(on2v2RobotGameStart);
         BattleServer.instance.on2v2GameTimeOut(on2v2GameTimeOut);
         BattleServer.instance.onGameOver(onGameOver);
         BattleServer.instance.onLoadMapOverTime(onLoadMapOverTimeCallBack);
         BattleServer.instance.onChangeRoomOwner(onChangeRoomOwner);
         BattleServer.instance.onFace(receiveEmotionFace);
      }
      
      private function unBindNet() : void
      {
         BattleServer.instance.disposeRecvFun(otherComeOn);
         BattleServer.instance.disposeRecvFun(syncBody);
         BattleServer.instance.disposeRecvFun(onRobotCome);
         BattleServer.instance.disposeRecvFun(mapPROGRESS);
         BattleServer.instance.disposeRecvFun(onGameOver);
         BattleServer.instance.disposeRecvFun(onLoadMapOverTimeCallBack);
         BattleServer.instance.disposeRecvFun(allReadyGo);
         BattleServer.instance.disposeRecvFun(onPlayerLeave);
         BattleServer.instance.disposeRecvFun(onChangeRoomError);
         BattleServer.instance.disposeRecvFun(onChangeRoomFast);
         BattleServer.instance.disposeRecvFun(on2v2RobotGameStart);
         BattleServer.instance.disposeRecvFun(on2v2GameTimeOut);
         BattleServer.instance.disposeRecvFun(onPlayerReady);
         BattleServer.instance.disposeRecvFun(onChangeRoomOwner);
         BattleServer.instance.disposeRecvFun(receiveEmotionFace);
      }
      
      private function receiveEmotionFace(param1:Object) : void
      {
         Application.instance.log("BTROOM-接收表情:",JSON.stringify(param1));
         var _loc3_:int = int(param1.data.type);
         var _loc6_:int = int(param1.data.uid);
         var _loc2_:int = int(PlayerDataList.instance.getDataByUID(_loc6_).siteID);
         var _loc4_:BtRoomPlayerBox = getCharBoxBySiteID(_loc2_);
         var _loc5_:Point = _loc4_.parent.localToGlobal(new Point(_loc4_.x,_loc4_.y));
         _loc5_.y = _loc5_.y + 100;
         EmotionPlay.playFaceById(_loc3_,_loc5_);
      }
      
      public function enterRoom() : void
      {
         var _loc3_:* = 0;
         roomTextField.text = LangManager.t("roomID") + "：" + _optionsData.roomid;
         showSite(optionsData.pk_type);
         for each(var _loc2_ in characters)
         {
            removeChild(_loc2_);
         }
         var _loc4_:Character = CharacterFactory.instance.checkOutCharacter(PlayerDataList.instance.selfData.babySex);
         _loc4_.initData(PlayerDataList.instance.selfData.getPropData());
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            ratioBgImage[_loc3_].visible = false;
            ratioImage[_loc3_].visible = false;
            numView[_loc3_].visible = false;
            percentImage[_loc3_].visible = false;
            _loc3_++;
         }
         matchLayer.visible = true;
         startBtn.visible = true;
         stopBtn.visible = false;
         propAndSkillLayer.visible = true;
         propAndSkillLayer.touchable = true;
         var _loc1_:Array = GoodsList.instance.getBTPropAndSkill();
         selectBtn.visible = _loc1_.length == 0;
         smallMap.texture = Assets.sAsset.getTexture("smallmap_0");
         randomMapLayer.getChildByName("randomMap").visible = true;
      }
      
      private function initPlayerInfo() : void
      {
         var _loc4_:* = 0;
         var _loc2_:Rectangle = null;
         var _loc1_:Rectangle = null;
         charNames = new Vector.<TextField>();
         siteImage = new Vector.<Image>();
         unMatchImage = new Vector.<Image>();
         ratioBgImage = new Vector.<Image>();
         ratioImage = new Vector.<Gauge>();
         percentImage = new Vector.<Image>();
         numView = new Vector.<NumberView>();
         _loc4_ = 0;
         while(_loc4_ < 4)
         {
            if(_loc4_ < 2)
            {
               siteImage[_loc4_] = new Image(Assets.sAsset.getTexture("zdpp2-red"));
            }
            else
            {
               siteImage[_loc4_] = new Image(Assets.sAsset.getTexture("zdpp2"));
            }
            Assets.positionDisplay(siteImage[_loc4_],"btRoom","box" + (_loc4_ + 1));
            characterLayer.addChild(siteImage[_loc4_]);
            unMatchImage[_loc4_] = new Image(Assets.sAsset.getTexture("zdpp_anti_unmatch"));
            _loc2_ = Assets.getPosition("btRoom","box" + (_loc4_ + 1));
            unMatchImage[_loc4_].x = _loc2_.x + 40;
            unMatchImage[_loc4_].y = _loc2_.y + 45;
            characterLayer.addChild(unMatchImage[_loc4_]);
            _loc1_ = Assets.getPosition("btRoom","name" + (_loc4_ + 1));
            charNames[_loc4_] = new TextField(_loc1_.width,_loc1_.height,LangManager.t("unMatch"),"Verdana",22,16777215);
            charNames[_loc4_].x = _loc1_.x;
            charNames[_loc4_].y = _loc1_.y;
            charNames[_loc4_].autoScale = true;
            characterLayer.addChild(charNames[_loc4_]);
            ratioBgImage[_loc4_] = new Image(Assets.sAsset.getTexture("zdpp27"));
            ratioBgImage[_loc4_].x = _loc1_.x;
            ratioBgImage[_loc4_].y = _loc1_.y + 50;
            characterLayer.addChild(ratioBgImage[_loc4_]);
            ratioBgImage[_loc4_].visible = false;
            ratioImage[_loc4_] = new Gauge(Assets.sAsset.getTexture("zdpp26"));
            ratioImage[_loc4_].x = _loc1_.x;
            ratioImage[_loc4_].y = _loc1_.y + 50;
            characterLayer.addChild(ratioImage[_loc4_]);
            ratioImage[_loc4_].visible = false;
            numView[_loc4_] = new NumberView("num",100,57);
            numView[_loc4_].x = _loc1_.x + 30;
            numView[_loc4_].y = _loc1_.y + 65;
            characterLayer.addChild(numView[_loc4_]);
            numView[_loc4_].visible = false;
            numView[_loc4_].scaleX = numView[_loc4_].scaleY = 0.5;
            percentImage[_loc4_] = new Image(Assets.sAsset.getTexture("num%"));
            percentImage[_loc4_].x = _loc1_.x + 80;
            percentImage[_loc4_].y = _loc1_.y + 63;
            characterLayer.addChild(percentImage[_loc4_]);
            percentImage[_loc4_].scaleX = percentImage[_loc4_].scaleY = 0.5;
            percentImage[_loc4_].visible = false;
            _loc4_++;
         }
         showSite(optionsData.pk_type);
         var _loc3_:Character = CharacterFactory.instance.checkOutCharacter(PlayerDataList.instance.selfData.babySex);
         _loc3_.initData(PlayerDataList.instance.selfData.getPropData());
      }
      
      private function addVSFireAnimation() : void
      {
         var _loc2_:TextureAtlas = Assets.sAsset.getTextureAtlas("btdlg");
         var _loc1_:Vector.<Texture> = _loc2_.getTextures("vs00");
         vsMovie = new MovieClip(_loc1_,15);
         vsMovie.blendMode = "screen";
         vsMovie.touchable = false;
         vsMovie.loop = true;
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("vsFlag"),vsMovie);
         vsMovie.y -= getDisplayObjectByName("vsFlag").height / 2;
         addChildToDisplayObject(vsMovie);
         Starling.juggler.add(vsMovie);
         vsMovie.play();
      }
      
      private function removeVsFire() : void
      {
         if(Starling.juggler.contains(vsMovie))
         {
            vsMovie.stop();
            Starling.juggler.remove(vsMovie);
            vsMovie.removeFromParent(true);
         }
      }
      
      private function showRandomMap() : void
      {
      }
      
      private function showSite(param1:int) : void
      {
         if(param1 == 0)
         {
            siteStatus = [1,0,1,0];
         }
         else if(param1 == 1)
         {
            siteStatus = [1,1,1,1];
         }
         _drawSiteByStatus();
      }
      
      private function _drawSiteByStatus() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < siteStatus.length)
         {
            if(siteStatus[_loc1_] == 0)
            {
               siteImage[_loc1_].texture = Assets.sAsset.getTexture("zdpp3");
               unMatchImage[_loc1_].visible = false;
               charNames[_loc1_].text = "";
            }
            else if(siteStatus[_loc1_] == 1 && _loc1_ == PlayerDataList.instance.selfData.siteID)
            {
               unMatchImage[_loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      private function addSite(param1:PlayerData) : void
      {
         var _loc2_:int = int(param1.siteID);
         var _loc3_:BtRoomPlayerBox = getEmptyCharBoxByTeam(param1.team)[0];
         _loc3_.updateByData(param1);
         _loc3_.stopMatchingAni();
      }
      
      private function setLoadingRatio(param1:int, param2:int) : void
      {
         getCharBoxBySiteID(param1).loadingRatio = param2 / 100;
      }
      
      private function onSelectSkillBtn(param1:Event) : void
      {
         cardContainer.removeChildren();
         index = 0;
         propIndex = 4;
         var _loc2_:BtSkillDlg = new BtSkillDlg();
         _loc2_.closeSignal.add(updatePropAndSkill);
         addChild(_loc2_);
         _loc2_.x = 1365 - _loc2_.width >> 1;
         _loc2_.y = 768 - _loc2_.height >> 1;
      }
      
      private function onGameStart() : void
      {
         var _loc2_:PlayerData = PlayerDataList.instance.selfData;
         var _loc1_:GoodsData = _loc2_.getWeapon();
         if(!_loc1_ || _loc1_.place != 1)
         {
            TextTip.instance.show(LangManager.t("noWeapon"));
            Application.instance.currentGame.mainMenu.isEnable(true);
            return;
         }
         BattleServer.instance.selfReady(1);
         if(inGuide)
         {
            stopBtn.enabled = false;
         }
         itemsTouchable(false);
      }
      
      private function itemsTouchable(param1:Boolean = true) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = [_propButton.starlingBtn,_weaponButton.starlingBtn,_propAndWeaponList,_backButton.starlingBtn,_inviteButton.starlingBtn,_changeRoomButton.starlingBtn,Application.instance.currentGame.mainMenu];
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            DisplayObject(_loc2_[_loc3_]).touchable = param1;
            _loc3_++;
         }
      }
      
      private function startMatchAni() : void
      {
         for each(var _loc1_ in _charBoxVec)
         {
            if(!_loc1_.playerData)
            {
               _loc1_.startMatchingAni();
            }
         }
      }
      
      private function stopMatchAni() : void
      {
         for each(var _loc1_ in _charBoxVec)
         {
            if(!_loc1_.playerData)
            {
               _loc1_.stopMatchingAni();
               _loc1_.clear();
            }
         }
      }
      
      private function getPlayerCounts() : int
      {
         var _loc1_:int = 0;
         for each(var _loc2_ in _charBoxVec)
         {
            if(_loc2_.playerData)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      private function cancelReady() : void
      {
         isStartButtonGray();
         showStartButtonState(0);
         BattleServer.instance.selfReady(0);
         itemsTouchable();
      }
      
      private function onStopGame(param1:Event) : void
      {
         cancelReady();
      }
      
      private function onJJMSTriggeredHandle(param1:Event) : void
      {
         zymsBtn.upState = Assets.sAsset.getTexture("zdpp9");
         jjmsBtn.upState = Assets.sAsset.getTexture("zdpp12");
      }
      
      private function onZYMSTriggeredHandle(param1:Event) : void
      {
         jjmsBtn.upState = Assets.sAsset.getTexture("zdpp11");
         zymsBtn.upState = Assets.sAsset.getTexture("zdpp10");
      }
      
      private function onBackToHall(param1:Event) : void
      {
         if(inGuide)
         {
            inGuide = false;
         }
         Guide.instance.stop();
         Application.instance.currentGame._guideOptionsData.pos = "mission";
         exit();
      }
      
      private function clearSite(param1:int) : void
      {
         getCharBoxBySiteID(param1).clear();
      }
      
      private function setPlayerReadyStatus(param1:int, param2:int) : void
      {
         getCharBoxBySiteID(param1).isReady = Boolean(param2);
      }
      
      private function getReadyCount() : int
      {
         var _loc1_:int = 0;
         for each(var _loc2_ in _charBoxVec)
         {
            if(_loc2_.isReady)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      private function on2v2GameTimeOut(param1:Object) : void
      {
         var retData:Object = param1;
         TextTip.instance.showByLang("loadMapOvertime1");
         Starling.juggler.delayCall((function():*
         {
            var call:Function;
            return call = function():void
            {
               dispatchEventWith("complete");
            };
         })(),1);
      }
      
      private function on2v2RobotGameStart(param1:Object) : void
      {
         var retData:Object = param1;
         Application.instance.log("on2v2RobotGameStart",JSON.stringify(retData));
         Starling.juggler.delayCall((function():*
         {
            var delay:Function;
            return delay = function():void
            {
               dispatchEventWith("show2vs2RobotBt");
            };
         })(),1);
      }
      
      private function onPlayerLeave(param1:Object) : void
      {
         var _loc2_:int = int(param1.data.uid);
         var _loc3_:PlayerData = PlayerDataList.instance.getDataByUID(_loc2_);
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_.leaving)
         {
            return;
         }
         if(_loc3_.uid == PlayerDataList.instance.selfData.uid)
         {
            return;
         }
         _loc3_.leaving = true;
         Application.instance.log("BT room Player level:",JSON.stringify(param1));
         cancelReady();
         setPlayerReadyStatus(_loc3_.siteID,0);
         clearSite(_loc3_.siteID);
         PlayerDataList.instance.removePlayerByUID(_loc2_);
      }
      
      private function onChangeRoomOwner(param1:Object) : void
      {
         Application.instance.log("new room owner",JSON.stringify(param1));
         var _loc3_:PlayerData = PlayerDataList.instance.getDataByUID(param1.data.uid);
         _loc3_.houseOwner = 1;
         var _loc2_:BtRoomPlayerBox = getCharBoxBySiteID(_loc3_.siteID);
         _loc2_.isRoomOwner = Boolean(_loc3_.houseOwner);
      }
      
      private function onPlayerReady(param1:Object) : void
      {
         LevelLogger.getLogger("BtRoom onPlayerReady").info(JSON.stringify(param1));
         var _loc2_:int = int(param1.data.siteID);
         var _loc3_:int = int(param1.data.ready);
         setPlayerReadyStatus(_loc2_,_loc3_);
         if(roomMode == 0 && _loc3_)
         {
            if(getReadyCount() >= PlayerDataList.instance.pk_type + 1)
            {
               startMatchAni();
            }
         }
         else
         {
            stopMatchAni();
         }
         if(_loc2_ == PlayerDataList.instance.selfData.siteID)
         {
            showStartButtonState(_loc3_);
         }
         isStartButtonGray();
      }
      
      private function onChangeRoomError(param1:Object) : void
      {
         TextTip.instance.show(LangManager.t("noRoomNow"));
      }
      
      private function onChangeRoomFast(param1:Object) : void
      {
         TextTip.instance.showByLang("changeRoomFast");
      }
      
      private function otherComeOn(param1:Object) : void
      {
         Guide.instance.stop();
         LevelLogger.getLogger("BtRoom otherComeOn").info(JSON.stringify(param1));
         PlayerDataList.instance.addPlayer(param1.data);
         var _loc2_:PlayerData = PlayerDataList.instance.getDataBySiteID(param1.data.siteID);
         addSite(_loc2_);
      }
      
      private function syncBody(param1:Object) : void
      {
         LevelLogger.getLogger("BtRoom syncBody").info(JSON.stringify(param1));
         var _loc2_:PlayerData = PlayerDataList.instance.getDataBySiteID(param1.data.siteID);
         if(param1.data.siteID == PlayerDataList.instance.selfData.siteID)
         {
            GoodsList.instance.resetBodyGoods(param1.data.propInfo);
         }
         else
         {
            _loc2_ && _loc2_.addPropInfo(param1.data.propInfo);
         }
         getCharBoxBySiteID(param1.data.siteID).updateByData(_loc2_);
      }
      
      private function allReadyGo(param1:Object) : void
      {
         var mapId:int;
         var mapUrl:String;
         var pt:Array;
         var retData:Object = param1;
         LevelLogger.getLogger("BtRoom allReadyGo").info(JSON.stringify(retData));
         mapId = int(retData.data.mapID);
         mapUrl = retData.data.mapURL;
         PlayerDataList.instance.bornPoint = new Vector.<Point>();
         for each(pt in retData.data.born)
         {
            PlayerDataList.instance.bornPoint.push(new Point(pt[0],pt[1]));
         }
         PlayerDataList.instance.mapId = mapId;
         Assets.btAsset.enqueueMap(mapId,"map_" + mapId);
         Assets.btAsset.loadQueue((function():*
         {
            var onProgress:Function;
            return onProgress = function(param1:Number):void
            {
               var _loc2_:int = param1 * 100;
               setLoadingRatio(PlayerDataList.instance.selfData.siteID,_loc2_);
               BattleServer.instance.sendMapPROGRESS(_loc2_);
               if(param1 == 1)
               {
                  Starling.juggler.delayCall(BattleServer.instance.sendLoadMapComplete,3);
               }
            };
         })());
         _startButton.isGray = true;
         showRandomMap();
      }
      
      private function mapPROGRESS(param1:Object) : void
      {
         setLoadingRatio(param1.data.siteID,param1.data.PROGRESS);
      }
      
      private function onGameOver(param1:Object) : void
      {
         var _loc4_:int = 0;
         trace("btRoom onGameOver");
         LevelLogger.getLogger("Battlefield10").info(JSON.stringify(param1));
         var _loc3_:PlayerData = PlayerDataList.instance.selfData;
         _loc4_ = 0;
         while(_loc4_ < param1.data.list.length)
         {
            if(param1.data.list[_loc4_][0] == _loc3_.siteID)
            {
               _loc3_.exp += param1.data.list[_loc4_][1];
            }
            _loc4_++;
         }
         Assets.btAsset.removeMapTexture(PlayerDataList.instance.mapId,"bg");
         Assets.btAsset.removeMapTexture(PlayerDataList.instance.mapId);
         PlayerDataList.instance.removeLeavingPlayers();
         BattleServer.instance.overFlop();
         for each(var _loc2_ in _charBoxVec)
         {
            _loc2_.showLoading(false);
         }
      }
      
      private function onLoadMapOverTimeCallBack(param1:Object) : void
      {
         LevelLogger.getLogger("BattleServer").info(JSON.stringify(param1));
         var _loc2_:PlayerData = PlayerDataList.instance.getDataByUID(param1.data.uid);
         if(_loc2_.siteID == PlayerDataList.instance.selfData.siteID)
         {
            TextTip.instance.show(LangManager.t("loadMapOvertime"));
         }
         else
         {
            TextTip.instance.show(LangManager.t("loadMapOvertime1"));
         }
         Assets.btAsset.removeMapTexture(PlayerDataList.instance.mapId,"bg");
         Assets.btAsset.removeMapTexture(PlayerDataList.instance.mapId);
         PlayerDataList.instance.removePlayers();
         BattleServer.instance.overFlop();
      }
      
      public function updatePropAndSkill() : void
      {
         if(_propButton.isSelect)
         {
            _propAndWeaponList.dataProvider = new ListCollection(getSkillData());
         }
         else
         {
            _propAndWeaponList.dataProvider = new ListCollection(getWeaponData());
         }
         if(inGuide)
         {
            Guide.instance.guide(startBtn,"",true);
            startBtn.enabled = true;
            boxbg.enabled = false;
         }
      }
      
      private function gameStart(param1:Object) : void
      {
         var retData:Object = param1;
         LevelLogger.getLogger("Battlefield").info(JSON.stringify(retData));
         RandomNum.setNext(retData.data.seed);
         WeddingManager.instance.checkCoupleFight();
         Starling.juggler.delayCall(function():void
         {
            dispatchEventWith("showBattlefield");
         },1);
         _startButton.isGray = true;
      }
      
      private function onStartRobot(param1:Object) : void
      {
         var mapId:int;
         var mapUrl:String;
         var pt:Array;
         var retData:Object = param1;
         LevelLogger.getLogger("Battlefield").info(JSON.stringify(retData));
         mapId = int(retData.data.mapID);
         mapUrl = retData.data.mapURL;
         PlayerDataList.instance.bornPoint = new Vector.<Point>();
         for each(pt in retData.data.born)
         {
            PlayerDataList.instance.bornPoint.push(new Point(pt[0],pt[1]));
         }
         PlayerDataList.instance.mapId = mapId;
         WeddingManager.instance.checkCoupleFight();
         Assets.btAsset.enqueueMap(mapId,"map_" + mapId);
         Assets.btAsset.loadQueue((function():*
         {
            var onProgress:Function;
            return onProgress = function(param1:Number):void
            {
               var ratio:Number = param1;
               var loadingRatio:int = ratio * 100;
               setLoadingRatio(PlayerDataList.instance.selfData.siteID,loadingRatio);
               BattleServer.instance.sendMapPROGRESS(loadingRatio);
               if(ratio == 1)
               {
                  Starling.juggler.delayCall(function():void
                  {
                     if(optionsData.pk_type == 0)
                     {
                        dispatchEventWith("showRobotBt");
                        return;
                     }
                     Starling.juggler.delayCall(BattleServer.instance.sendLoadMapComplete,3);
                  },1);
               }
            };
         })());
         _startButton.isGray = true;
         showRandomMap();
      }
      
      private function onRobotCome(param1:Object) : void
      {
         param1.data.mid = param1.data.siteID + 1000;
         otherComeOn(param1);
         var _loc2_:PlayerData = PlayerDataList.instance.getDataBySiteID(param1.data.siteID);
         _loc2_.isrobot = true;
         Application.instance.log("Battlefield------onRobotCome",JSON.stringify(param1));
      }
      
      public function exit() : void
      {
         BattleServer.instance.close();
         this.removeFromParent(true);
         Application.instance.currentGame.navigator.showScreen("SHOW_BT_HALL");
      }
      
      override public function dispose() : void
      {
         Application.instance.log("BTROOM","dispose");
         Application.instance.currentGame.mainMenu.backpack.updateSignal.removeAll();
         itemsTouchable();
         unBindNet();
         if(roomMode == 0)
         {
            optionsData.otherPlayerData = null;
         }
         for each(var _loc1_ in characters)
         {
            CharacterFactory.instance.checkInCharacter(_loc1_);
         }
         super.dispose();
         trace("btRoom dispose");
      }
      
      public function guideProcess(param1:Object = null) : void
      {
         GuideTipManager.instance.currentProcess = this;
         var _loc2_:String = MissionGuideValue.instance.getMissionFlag();
         switch(_loc2_)
         {
            case "fight1v1Mission":
            case "fight2v2Mission":
               GuideEventManager.instance.dispactherEvent("newUI",[[_startButton.getButtonById(0),30]]);
               break;
            case "useFightSkill":
               if(String(param1) == "gameStart")
               {
                  GuideEventManager.instance.dispactherEvent("newUI",[[_startButton.getButtonById(0),60]]);
                  break;
               }
               GuideEventManager.instance.dispactherEvent("newUI",[[_propAndWeaponList,30]]);
         }
      }
   }
}

