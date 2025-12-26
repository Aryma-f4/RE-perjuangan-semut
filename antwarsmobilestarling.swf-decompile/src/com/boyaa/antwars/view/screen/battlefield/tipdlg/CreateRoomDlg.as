package com.boyaa.antwars.view.screen.battlefield.tipdlg
{
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import feathers.controls.TextInput;
   import starling.events.Event;
   
   public class CreateRoomDlg extends UIExportSprite
   {
      
      private var _modeButtons:Vector.<FashionStarlingButton>;
      
      private var _playerNumButtons:Vector.<FashionStarlingButton>;
      
      private var _inputPW:TextInput;
      
      private var _okButton:FashionStarlingButton;
      
      private var _mode:int;
      
      private var _type:int;
      
      public function CreateRoomDlg()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         _layout = new LayoutUitl(Assets.sAsset.getOther("btRoom"));
         _layout.buildLayout("btHallCreateRoomDlg",_displayObj);
         showMark();
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
         addCloseButtonEvent();
         initButtons();
         _inputPW = StarlingUITools.instance.createInputByTextField(getTextFieldByName("inputPW"),6);
         _inputPW.restrict = "0-9";
      }
      
      private function initButtons() : void
      {
         var _loc1_:FashionStarlingButton = null;
         _modeButtons = new Vector.<FashionStarlingButton>();
         _playerNumButtons = new Vector.<FashionStarlingButton>();
         var _loc2_:int = 0;
         _loc2_ = 1;
         while(_loc2_ >= 0)
         {
            _loc1_ = new FashionStarlingButton(getButtonByName("choice" + _loc2_));
            _loc1_.groupTag = "BTROOM_MODE";
            if(0 == _loc2_)
            {
               _loc1_.isSelect = true;
            }
            _modeButtons.push(_loc1_);
            _loc2_--;
         }
         _loc2_ = 2;
         while(_loc2_ < 4)
         {
            _loc1_ = new FashionStarlingButton(getButtonByName("choice" + _loc2_));
            _loc1_.groupTag = "BTROOM_PLAYERNUM";
            if(2 == _loc2_)
            {
               _loc1_.isSelect = true;
            }
            _playerNumButtons.push(_loc1_);
            _loc2_++;
         }
         _okButton = new FashionStarlingButton(getButtonByName("btnS_btHallCreateButton"));
         _okButton.triggerFunction = onOkButtonHandle;
      }
      
      private function onOkButtonHandle(param1:Event) : void
      {
         BattleServer.instance.createRoom(mode,type,_inputPW.text);
      }
      
      public function get mode() : int
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _modeButtons.length)
         {
            if(_modeButtons[_loc1_].isSelect)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return 0;
      }
      
      public function get type() : int
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _playerNumButtons.length)
         {
            if(_playerNumButtons[_loc1_].isSelect)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return 0;
      }
   }
}

