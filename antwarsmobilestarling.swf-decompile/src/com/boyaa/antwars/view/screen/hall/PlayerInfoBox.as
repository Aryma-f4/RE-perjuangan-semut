package com.boyaa.antwars.view.screen.hall
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.screen.PersonnalInfoDlg;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class PlayerInfoBox extends UIExportSprite
   {
      
      private var _character:Character;
      
      private var _level:int;
      
      private var _goldCoin:int;
      
      private var _boyaaCoin:int;
      
      private var _aboutMe:PersonnalInfoDlg;
      
      public function PlayerInfoBox()
      {
         super();
      }
      
      override protected function initialization() : void
      {
         super.initialization();
         buildLayout("publicComponent","playerInfo");
         addHeadImg();
         initText();
         AccountData.instance.updateSignal.add(update);
         this.addEventListener("triggered",onAboutMe);
      }
      
      private function onAboutMe(param1:Event) : void
      {
         Guide.instance.stop();
         var _loc2_:PlayerData = PlayerDataList.instance.selfData;
         if(_aboutMe == null)
         {
            _aboutMe = new PersonnalInfoDlg(_loc2_,true);
         }
         else
         {
            _aboutMe.showPlayerInfoByPlayerData(_loc2_);
         }
         Application.instance.currentGame.stage.addChild(_aboutMe);
      }
      
      private function update() : void
      {
         level = PlayerDataList.instance.selfData.level;
         goldCoin = AccountData.instance.gameGold;
         boyaaCoin = AccountData.instance.boyaaCoin;
      }
      
      private function addHeadImg() : void
      {
         _character = CharacterFactory.instance.checkOutCharacter(PlayerDataList.instance.selfData.babySex);
         _character = _character.avatar();
         _character.pivotX = _character.width / 2;
         _character.pivotY = _character.height / 2;
         _character.scaleY = _character.scaleX = 0.4;
         var _loc1_:DisplayObject = getDisplayObjectByName("headPos");
         _character.x = _loc1_.x + _character.width / 2 + 15;
         _character.y = _loc1_.y + _character.height + 12;
         _displayObj.addChildAt(_character,_displayObj.getChildIndex(_loc1_));
      }
      
      private function initText() : void
      {
         getButtonByName("goldCoin").upState = getButtonByName("goldCoin").downState;
         getButtonByName("boyaaCoin").downState = getButtonByName("boyaaCoin").upState;
         getTextFieldByName("playerName").text = PlayerDataList.instance.selfData.babyName;
         level = PlayerDataList.instance.selfData.level;
         goldCoin = AccountData.instance.gameGold;
         boyaaCoin = AccountData.instance.boyaaCoin;
      }
      
      public function get level() : int
      {
         return _level;
      }
      
      public function set level(param1:int) : void
      {
         _level = param1;
         getTextFieldByName("level").text = _level.toString();
      }
      
      public function get goldCoin() : int
      {
         return _goldCoin;
      }
      
      public function set goldCoin(param1:int) : void
      {
         _goldCoin = param1;
         getTextFieldByName("goldText").text = _goldCoin.toString();
      }
      
      public function get boyaaCoin() : int
      {
         return _boyaaCoin;
      }
      
      public function set boyaaCoin(param1:int) : void
      {
         _boyaaCoin = param1;
         getTextFieldByName("boyaaText").text = _boyaaCoin.toString();
      }
   }
}

