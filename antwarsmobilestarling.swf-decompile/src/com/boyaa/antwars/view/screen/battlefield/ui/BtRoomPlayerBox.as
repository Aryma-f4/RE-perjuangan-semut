package com.boyaa.antwars.view.screen.battlefield.ui
{
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.display.Gauge;
   import com.boyaa.antwars.view.screen.battlefield.ani.MatchingAni;
   import com.boyaa.antwars.view.screen.battlefield.element.NumberView;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.antwars.view.vipSystem.VipButton;
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.filters.FragmentFilter;
   
   public class BtRoomPlayerBox extends UIExportSprite
   {
      
      private var _vipIcon:VipButton;
      
      private var _progressNumView:NumberView;
      
      private var _percentView:Image;
      
      private var _progress:Gauge;
      
      private var _progressBg:Image;
      
      private var _isRoomOwner:Boolean = false;
      
      private var _isReady:Boolean = false;
      
      private var _level:int;
      
      private var _playerName:String;
      
      private var _character:Character;
      
      private var _playerData:PlayerData;
      
      private var _loadingRatio:Number = 0;
      
      private var _vipLevel:int = 0;
      
      private var _bgBox:Image;
      
      private var _matchAni:MatchingAni;
      
      private var _waitingImg:Image;
      
      private var _readyImg:Image;
      
      private var _team:int;
      
      public function BtRoomPlayerBox(param1:int = 0)
      {
         super();
         init();
         this.team = param1;
      }
      
      private function init() : void
      {
         _layout = new LayoutUitl(Assets.sAsset.getOther("btRoom"));
         _layout.buildLayout("btRoomPlayerLayout",_displayObj);
         initRatio();
         initPercent();
         _vipIcon = new VipButton();
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("vipIconPos"),_vipIcon);
         addChildToDisplayObject(_vipIcon);
         vipLevel = 0;
         _bgBox = getImageByName("bg");
         _waitingImg = new Image(Assets.sAsset.getTexture("zdpp_anti_unmatch"));
         SmallCodeTools.instance.setDisplayObjectInSamePos(getDisplayObjectByName("playerPos"),_waitingImg);
         _waitingImg.x += getDisplayObjectByName("playerPos").width - _waitingImg.width >> 1;
         addChildToDisplayObject(_waitingImg);
         getTextFieldByName("levelText").nativeFilters = StarlingUITools.instance.getDropShadowFilter();
         _readyImg = getImageByName("ready");
         clear();
      }
      
      private function changeColor() : void
      {
         _bgBox.filter = new FragmentFilter();
      }
      
      private function initPercent() : void
      {
         var _loc1_:DisplayObject = getDisplayObjectByName("numberViewPos");
         _progressNumView = new NumberView("num",_loc1_.width + 30,_loc1_.height + 30);
         _progressNumView.x = _loc1_.x;
         _progressNumView.y = _loc1_.y;
         _progressNumView.scaleX = _progressNumView.scaleY = 0.5;
         _percentView = new Image(Assets.sAsset.getTexture("num%"));
         _percentView.x = _progressNumView.x + _progressNumView.width;
         _percentView.y = _progressNumView.y;
         _percentView.scaleX = _percentView.scaleY = 0.5;
         addChildToDisplayObject(_progressNumView);
         addChildToDisplayObject(_percentView);
         _progressNumView.visible = _percentView.visible = false;
      }
      
      private function initRatio() : void
      {
         _progress = new Gauge(Assets.sAsset.getTexture("zdpp26"));
         _progressBg = new Image(Assets.sAsset.getTexture("zdpp27"));
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("loadingPos"),_progress);
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("loadingPos"),_progressBg);
         addChildToDisplayObject(_progressBg);
         addChildToDisplayObject(_progress);
         _progressBg.visible = _progress.visible = false;
      }
      
      private function initCharcter() : void
      {
         if(_character)
         {
            _character.removeFromParent(true);
         }
         _character = SmallCodeTools.instance.getCharcterByData(_playerData,getDisplayObjectByName("playerPos"));
         _displayObj.addChild(_character);
         _character.scaleX = _character.scaleY = 0.55;
         if(team != 0)
         {
            _character.scaleX *= -1;
         }
      }
      
      public function updateByData(param1:PlayerData) : void
      {
         _playerData = param1;
         playerName = param1.babyName;
         level = param1.level;
         isRoomOwner = Boolean(param1.houseOwner);
         isReady = param1.ready;
         initCharcter();
         _vipIcon.showLevelByPlayerData(param1);
         vipLevel = _vipIcon.level;
         _waitingImg.visible = false;
      }
      
      public function setBoxByDisplayObject(param1:DisplayObject) : void
      {
         var _loc2_:Number = _bgBox.width;
         var _loc3_:Number = _bgBox.width - param1.width >> 1;
         _bgBox.width = param1.width;
         if(_loc3_ == 0)
         {
            return;
         }
         getDisplayObjectByName("roomOwnerTextBg").x = _bgBox.width - getDisplayObjectByName("roomOwnerTextBg").width - getDisplayObjectByName("roomOwnerTextBg").width / 4;
         getDisplayObjectByName("roomOwnerText").x = getDisplayObjectByName("roomOwnerTextBg").x;
         getDisplayObjectByName("nameText").x = getDisplayObjectByName("nameText").x - _loc3_;
         _readyImg.x = _bgBox.width - _readyImg.width;
         _progress.x -= _loc3_;
         _progressBg.x -= _loc3_;
         _progressNumView.x -= _loc3_;
         _percentView.x -= _loc3_;
         getDisplayObjectByName("playerPos").x = getDisplayObjectByName("playerPos").x - _loc3_;
         SmallCodeTools.instance.setDisplayObjectInSamePos(getDisplayObjectByName("playerPos"),_waitingImg);
         _waitingImg.x += getDisplayObjectByName("playerPos").width - _waitingImg.width >> 1;
      }
      
      public function startMatchingAni() : void
      {
         var _loc1_:Rectangle = null;
         if(!_matchAni)
         {
            _loc1_ = getDisplayObjectByName("playerPos").bounds;
            _matchAni = new MatchingAni(_loc1_);
            addChildToDisplayObject(_matchAni);
         }
         _matchAni.start();
         _waitingImg.visible = false;
         playerName = "matching";
      }
      
      public function stopMatchingAni() : void
      {
         _matchAni && _matchAni.stop();
      }
      
      public function clear() : void
      {
         _character && _character.removeFromParent(true);
         showLoading(false);
         level = -1;
         playerName = "waiting";
         isRoomOwner = false;
         _playerData = null;
         _waitingImg.visible = true;
         isReady = false;
         stopMatchingAni();
      }
      
      public function showLoading(param1:Boolean = true) : void
      {
         SmallCodeTools.instance.setDisplayObjectVisible([_progress,_progressBg,_percentView,_progressNumView],param1);
      }
      
      public function get isRoomOwner() : Boolean
      {
         return _isRoomOwner;
      }
      
      public function set isRoomOwner(param1:Boolean) : void
      {
         _isRoomOwner = param1;
         getDisplayObjectByName("roomOwnerTextBg").visible = _isRoomOwner;
         getDisplayObjectByName("roomOwnerText").visible = _isRoomOwner;
      }
      
      public function set playerName(param1:String) : void
      {
         _playerName = param1;
         getTextFieldByName("nameText").text = _playerName;
      }
      
      public function set level(param1:int) : void
      {
         _level = param1;
         getTextFieldByName("levelText").visible = true;
         if(_level < 0)
         {
            getTextFieldByName("levelText").visible = false;
         }
         getTextFieldByName("levelText").text = "LV" + _level;
      }
      
      public function get loadingRatio() : Number
      {
         return _loadingRatio;
      }
      
      public function set loadingRatio(param1:Number) : void
      {
         showLoading();
         _loadingRatio = param1;
         _progress.ratio = _loadingRatio;
         _progressNumView.number = _loadingRatio * 100;
      }
      
      public function set vipLevel(param1:int) : void
      {
         _vipLevel = param1;
         _vipIcon.visible = false;
         if(_vipLevel != 0)
         {
            _vipIcon.visible = true;
            _vipIcon.setLevel(_vipLevel);
         }
      }
      
      public function get playerData() : PlayerData
      {
         return _playerData;
      }
      
      public function get isReady() : Boolean
      {
         return _isReady;
      }
      
      public function set isReady(param1:Boolean) : void
      {
         _isReady = param1;
         _readyImg.visible = _isReady;
      }
      
      public function get team() : int
      {
         return _team;
      }
      
      public function set team(param1:int) : void
      {
         _team = param1;
         if(team == 1)
         {
            _bgBox.texture = Assets.sAsset.getTexture("img_btRoomPlayerBoxBg2");
         }
         else
         {
            _bgBox.texture = Assets.sAsset.getTexture("img_btRoomPlayerBoxBg1");
         }
      }
   }
}

