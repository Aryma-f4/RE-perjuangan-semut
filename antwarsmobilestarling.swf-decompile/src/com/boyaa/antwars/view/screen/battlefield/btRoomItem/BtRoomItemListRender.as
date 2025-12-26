package com.boyaa.antwars.view.screen.battlefield.btRoomItem
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.ui.LayoutListItemRender;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import starling.display.Image;
   import starling.events.Event;
   
   public class BtRoomItemListRender extends LayoutListItemRender
   {
      
      private var _btRoomData:BtRoomData;
      
      private var _roomId:int;
      
      private var _lockImg:Image;
      
      private var _roomName:String;
      
      private var _mode:int;
      
      private var _playerNum:String;
      
      private var _joinButton:FashionStarlingButton;
      
      private var _bgButton:FashionStarlingButton;
      
      private var _langArr:Array;
      
      public function BtRoomItemListRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         _layoutUtil = new LayoutUitl(Assets.sAsset.getOther("btRoom"));
         _layoutUtil.buildLayout("btHallItemLayout",_displayObject);
         _joinButton = new FashionStarlingButton(getButtonByName("joinButton"));
         _joinButton.triggerFunction = onJoinInFightHandle;
         _bgButton = new FashionStarlingButton(getButtonByName("button"));
         _lockImg = getImageByName("lock");
         initOriginRenderItems();
         _langArr = LangManager.ta("fightModeArr");
      }
      
      override protected function selectDraw() : void
      {
         super.selectDraw();
         if(_joinButton.isGray)
         {
            return;
         }
         if(isSelected)
         {
            _bgButton.isSelect = true;
         }
         else
         {
            _bgButton.isSelect = false;
         }
      }
      
      private function onJoinInFightHandle(param1:Event) : void
      {
         EventCenter.GameEvent.dispatchEvent(new GameEvent("joinBattleRoom",this._data));
      }
      
      override protected function commitData() : void
      {
         super.commitData();
         _btRoomData = this._data as BtRoomData;
         roomId = _btRoomData.roomId;
         roomName = _btRoomData.roomName;
         mode = _btRoomData.mode;
         if(_btRoomData.isLock)
         {
            _lockImg.visible = true;
         }
         else
         {
            _lockImg.visible = false;
         }
         if(_btRoomData.isJoin)
         {
            _joinButton.isGray = false;
         }
         else
         {
            _joinButton.isGray = true;
         }
         if(_btRoomData.isFight)
         {
            _bgButton.isGray = true;
         }
         else
         {
            _bgButton.isGray = false;
         }
         playerNum = _btRoomData.currentPlayer + "/" + _btRoomData.maxPlayer;
      }
      
      public function set roomId(param1:int) : void
      {
         _roomId = param1;
         getTextFieldByName("roomId").text = _roomId.toString();
      }
      
      public function set roomName(param1:String) : void
      {
         _roomName = param1;
         getTextFieldByName("roomOwner").text = _roomName;
      }
      
      public function set mode(param1:int) : void
      {
         _mode = param1;
         if(_mode == 1)
         {
            getTextFieldByName("mode").text = _langArr[2];
         }
         else
         {
            getTextFieldByName("mode").text = _langArr[1];
         }
      }
      
      public function set playerNum(param1:String) : void
      {
         _playerNum = param1;
         getTextFieldByName("playerNum").text = _playerNum;
      }
   }
}

