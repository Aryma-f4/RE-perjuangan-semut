package com.boyaa.antwars.view.screen.battlefield
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.ServerManager;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.screen.IMainMenu;
   import com.boyaa.antwars.view.screen.UIExportScreen;
   import com.boyaa.antwars.view.screen.battlefield.btRoomItem.BtRoomData;
   import com.boyaa.antwars.view.screen.battlefield.btRoomItem.BtRoomItemListRender;
   import com.boyaa.antwars.view.screen.battlefield.btRoomItem.BtRoomModeItemRender;
   import com.boyaa.antwars.view.screen.battlefield.tipdlg.CreateRoomDlg;
   import com.boyaa.antwars.view.screen.battlefield.tipdlg.SearchRoomDlg;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.antwars.view.vipSystem.VipButton;
   import com.boyaa.tool.LoadData;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.utils.formatString;
   
   public class BtHallScreen extends UIExportScreen implements IMainMenu
   {
      
      private var _roomItemList:List;
      
      private var _modeList:List;
      
      private var _character:Character;
      
      private var _vipIcon:VipButton;
      
      private var _modeChoice:int;
      
      private var _refreshBtn:FashionStarlingButton;
      
      private var _searchRoomBtn:FashionStarlingButton;
      
      private var _createRoomBtn:FashionStarlingButton;
      
      private var _backBtn:FashionStarlingButton;
      
      private var _pickerBtn:FashionStarlingButton;
      
      private var _fightBtn:FashionStarlingButton;
      
      public function BtHallScreen()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         Application.instance.log("BTHALLSCREEN","initialize");
         Application.instance.currentGame.showLoading();
         connectServer();
      }
      
      private function connectServer() : void
      {
         ServerManager.instance.connectServer(1,loginSuccessful,(function():*
         {
            var fail:Function;
            return fail = function(param1:Object):void
            {
               Application.instance.currentGame.navigator.showScreen("HALL");
            };
         })());
      }
      
      private function loginSuccessful(param1:Object) : void
      {
         Application.instance.log("bt login successful",JSON.stringify(param1));
         loadAssets();
         bindNet();
      }
      
      private function loadAssets() : void
      {
         if(Assets.sAsset.getTextureAtlas("btRoom"))
         {
            loadAssetsComplete(1);
            return;
         }
         var _loc1_:ResManager = Application.instance.resManager;
         _assets.enqueue(_loc1_.getResFile(formatString("asset/btRoom.info")),_loc1_.getResFile(formatString("textures/{0}x/BT/btRoom.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/btRoom.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/btdlg.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/btdlg.xml",Assets.sAsset.scaleFactor)));
         _assets.loadQueue(loadAssetsComplete);
      }
      
      private function loadAssetsComplete(param1:Number) : void
      {
         if(param1 == 1)
         {
            init();
         }
      }
      
      private function bindNet() : void
      {
         EventCenter.GameEvent.addEventListener("joinBattleRoom",onJoinBattleRoomHandle);
         EventCenter.GameEvent.addEventListener("searchBtRoom",onSearchRoomHandle);
      }
      
      private function unBindNet() : void
      {
         EventCenter.GameEvent.removeEventListener("joinBattleRoom",onJoinBattleRoomHandle);
         EventCenter.GameEvent.removeEventListener("searchBtRoom",onSearchRoomHandle);
      }
      
      private function init() : void
      {
         PlayerDataList.instance.removePlayers();
         _layoutUtil = new LayoutUitl(Assets.sAsset.getOther("btRoom"));
         _layoutUtil.buildLayout("btHallLayout",_displayObj);
         PlayerDataList.instance.removePlayers();
         _roomItemList = new List();
         _roomItemList.layout = SmallCodeTools.instance.getListRowsLayout();
         _roomItemList.itemRendererType = BtRoomItemListRender;
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("listPos"),_roomItemList);
         _displayObj.addChild(_roomItemList);
         initButtons();
         initModeSelectList();
         updateCharacter();
         getFightList();
         _displayObj.addChild(Application.instance.currentGame.mainMenu);
         Application.instance.currentGame.mainMenu.parentWin = this;
         posGuide();
      }
      
      private function posGuide() : void
      {
         if(PlayerDataList.instance.selfData.leaving < 5)
         {
            if(Application.instance.currentGame._guideOptionsData.pos == "btRoom")
            {
               Guide.instance.guide(_fightBtn.starlingBtn,"fight");
            }
         }
      }
      
      private function onSearchRoomHandle(param1:GameEvent) : void
      {
         var _loc2_:Object = param1.param as Object;
         BattleServer.instance.seekRoom(_loc2_.roomId,_loc2_.password);
      }
      
      private function getFightList(param1:int = 0) : void
      {
         LoadData.show();
         BattleServer.instance.getFightList(onGetFightListHandle,param1);
      }
      
      private function onJoinBattleRoomHandle(param1:GameEvent) : void
      {
         var _loc3_:SearchRoomDlg = null;
         var _loc2_:BtRoomData = param1.param as BtRoomData;
         PlayerDataList.instance.pk_type = _loc2_.type;
         if(_loc2_.isLock)
         {
            _loc3_ = new SearchRoomDlg();
            _loc3_.searchInput.text = _loc2_.roomId.toString();
            _loc3_.searchInput.isEditable = false;
            _loc3_.passwordInput.setFocus();
            addChildToDisplayObject(_loc3_);
         }
         else
         {
            BattleServer.instance.seekRoom(_loc2_.roomId,"");
         }
      }
      
      private function onGetFightListHandle(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc2_:BtRoomData = null;
         LoadData.hide();
         Application.instance.log("BTHALLSCREEN",JSON.stringify(param1));
         var _loc3_:Vector.<BtRoomData> = new Vector.<BtRoomData>();
         _loc4_ = 0;
         while(_loc4_ < param1.data.roomSize)
         {
            _loc2_ = new BtRoomData(param1.data.roomArr[_loc4_]);
            _loc3_.push(_loc2_);
            _loc4_++;
         }
         _roomItemList.dataProvider = new ListCollection(_loc3_);
         Application.instance.currentGame.hiddenLoading();
      }
      
      private function initButtons() : void
      {
         _refreshBtn = new FashionStarlingButton(getButtonByName("refreshBtn"));
         _searchRoomBtn = new FashionStarlingButton(getButtonByName("searchRoomBtn"));
         _createRoomBtn = new FashionStarlingButton(getButtonByName("createRoomBtn"));
         _backBtn = new FashionStarlingButton(getButtonByName("backBtn"));
         _pickerBtn = new FashionStarlingButton(getButtonByName("pickerButton"));
         _fightBtn = new FashionStarlingButton(getButtonByName("fightButton"));
         _refreshBtn.triggerFunction = onRefreshButtonHandle;
         _searchRoomBtn.triggerFunction = onSearchButtonHandle;
         _createRoomBtn.triggerFunction = onCreateRoomButtonHandle;
         _backBtn.triggerFunction = onBackButtonHandle;
         _pickerBtn.triggerFunction = onModeSelectHandle;
         _fightBtn.triggerFunction = onFightButtonHandle;
      }
      
      private function onFightButtonHandle(param1:Event) : void
      {
         BattleServer.instance.quickJoin(0);
      }
      
      private function initModeSelectList() : void
      {
         _modeList = new List();
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("pickerListPos"),_modeList);
         _modeList.layout = SmallCodeTools.instance.getListRowsLayout(1);
         addChildToDisplayObject(_modeList);
         _modeList.dataProvider = new ListCollection(LangManager.ta("fightModeArr"));
         _modeList.itemRendererType = BtRoomModeItemRender;
         _modeList.selectedIndex = 0;
         _modeList.visible = false;
         _modeList.addEventListener("change",onModeListHandle);
         stage.addEventListener("touch",(function():*
         {
            var remove:Function;
            return remove = function(param1:TouchEvent):void
            {
               var _loc4_:* = undefined;
               var _loc3_:* = undefined;
               var _loc2_:Vector.<Touch> = param1.getTouches(stage);
               if(_loc2_.length > 0 && _loc2_[0].phase == "began")
               {
                  _loc4_ = param1.getTouches(_modeList);
                  _loc3_ = param1.getTouches(_pickerBtn.starlingBtn);
                  if(_loc4_.length == 0 && _loc3_.length == 0)
                  {
                     _modeList.visible = false;
                  }
               }
            };
         })());
      }
      
      private function onModeListHandle(param1:Event) : void
      {
         _modeList.visible = !_modeList.visible;
         modeChoice = _modeList.selectedIndex;
         trace(modeChoice);
         getFightList(modeChoice);
      }
      
      private function onModeSelectHandle(param1:Event) : void
      {
         _modeList.visible = !_modeList.visible;
      }
      
      private function onBackButtonHandle(param1:Event) : void
      {
         dispatchEventWith("complete");
      }
      
      private function onCreateRoomButtonHandle(param1:Event) : void
      {
         var _loc2_:CreateRoomDlg = new CreateRoomDlg();
         addChildToDisplayObject(_loc2_);
      }
      
      private function onSearchButtonHandle(param1:Event) : void
      {
         var _loc2_:SearchRoomDlg = new SearchRoomDlg();
         _loc2_.searchInput.setFocus();
         addChildToDisplayObject(_loc2_);
      }
      
      private function onRefreshButtonHandle(param1:Event) : void
      {
         getFightList();
         _refreshBtn.isGray = true;
         Timepiece.instance.addDelayCall(onShowRefreshButton,15000);
      }
      
      private function onShowRefreshButton() : void
      {
         _refreshBtn.isGray = false;
      }
      
      private function updateCharacter() : void
      {
         var _loc1_:PlayerData = PlayerDataList.instance.selfData;
         if(PlayerDataList.instance.selfData.vipLevel != 0)
         {
            _vipIcon = new VipButton();
            _vipIcon.setLevel(PlayerDataList.instance.selfData.vipLevel);
            SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("vipIcon"),_vipIcon);
            addChildToDisplayObject(_vipIcon);
         }
         _character = SmallCodeTools.instance.getCharcterByData(_loc1_,getDisplayObjectByName("playerPos"));
         _character.scaleX = _character.scaleY = 0.73;
         _character.scaleX *= -1;
         _displayObj.addChild(_character);
         getTextFieldByName("infoLevelText").text = _loc1_.level.toString();
         getTextFieldByName("infoFightText").text = _loc1_.totalAblility.toString();
         getTextFieldByName("rankingText").text = _loc1_.ranking.toString();
      }
      
      override public function dispose() : void
      {
         Application.instance.log("BTHALLSCREEN","dispose");
         super.dispose();
         Guide.instance.stop();
         Timepiece.instance.removeFun(onShowRefreshButton,2);
         unBindNet();
      }
      
      public function exit() : void
      {
      }
      
      public function get modeChoice() : int
      {
         return _modeChoice;
      }
      
      public function set modeChoice(param1:int) : void
      {
         _modeChoice = param1;
      }
   }
}

