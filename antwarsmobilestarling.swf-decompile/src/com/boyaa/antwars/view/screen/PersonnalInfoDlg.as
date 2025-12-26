package com.boyaa.antwars.view.screen
{
   import com.boyaa.antwars.data.BaseValues;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.BaseDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.screen.chatRoom.FriendData;
   import com.boyaa.antwars.view.screen.chatRoom.FriendsList;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.antwars.view.vipSystem.VipLevelIcon;
   import flash.filters.GlowFilter;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class PersonnalInfoDlg extends BaseDlg
   {
      
      private static const DEVICELOGIN:int = 10;
      
      private static const SINALOGIN:int = 12;
      
      private static const BOYAALOGIN:int = 11;
      
      private var _layout:LayoutUitl;
      
      private var btnShop:Button;
      
      private var btnClose:Button;
      
      private var btnAddFriend:Button;
      
      private var btnSwitchAccount:Button;
      
      private var txtName:TextField;
      
      private var txtLevel:TextField;
      
      private var txtId:TextField;
      
      private var txtExp:TextField;
      
      private var _switchAccount:Boolean;
      
      private var _data:FriendData;
      
      private var character:Character;
      
      private var _playerData:PlayerData;
      
      private var _acountImage:Image;
      
      private var _acountType:int = 11;
      
      private var _typeArr:Array = [10,12,11];
      
      private var _vipIcon:VipLevelIcon;
      
      private var _isEnable:Boolean = true;
      
      public function PersonnalInfoDlg(param1:PlayerData = null, param2:Boolean = false)
      {
         super();
         _playerData = param1;
         _switchAccount = param2;
         loadAssetDone(1);
      }
      
      public function get acountType() : int
      {
         return _acountType;
      }
      
      public function set isFriend(param1:Boolean) : void
      {
         btnAddFriend.visible = !param1;
      }
      
      protected function loadAssetDone(param1:int) : void
      {
         if(param1 == 1)
         {
            _layout = new LayoutUitl(Assets.sAsset.getOther("aboutMe"),Assets.sAsset);
            _layout.buildLayout("AboutMe",_displayObj);
            SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
            init();
            if(_switchAccount)
            {
               btnSwitchAccount.visible = true;
               btnAddFriend.visible = false;
               btnShop.visible = true;
            }
            else
            {
               btnShop.visible = false;
               btnSwitchAccount.visible = false;
               btnAddFriend.visible = true;
            }
            if(_playerData)
            {
               showPlayerInfoByPlayerData(_playerData);
            }
         }
      }
      
      public function setData(param1:FriendData) : void
      {
         _data = param1;
         if(FriendsList.instance.isFriend(param1.antId) || param1.antId == PlayerDataList.instance.selfData.uid)
         {
            btnAddFriend.visible = false;
         }
         else
         {
            btnAddFriend.visible = true;
         }
      }
      
      public function showPlayerInfo(param1:Object) : void
      {
         var _loc2_:Array = param1 as Array;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc5_:Object = _loc2_[1];
         var _loc3_:Array = _loc2_[2];
         var _loc4_:PlayerData = new PlayerData();
         _loc4_.addOtherInfo(_loc5_);
         _loc4_.addOtherPropInfo(_loc3_);
         showPlayerInfoByPlayerData(_loc4_);
      }
      
      private function init() : void
      {
         var _loc2_:int = 0;
         var _loc1_:TextField = null;
         addEvent();
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            _loc1_ = getTextFieldByName("name" + _loc2_);
            _loc1_.bold = true;
            _loc1_.hAlign = "left";
            _loc2_++;
         }
         txtName = getTextFieldByName("txtName");
         txtId = getTextFieldByName("txtId");
         txtLevel = getTextFieldByName("txtLevel");
         txtName.bold = true;
         txtId.bold = true;
         txtName.hAlign = "left";
         txtId.hAlign = "left";
         txtLevel.nativeFilters = [new GlowFilter(3677194,1,5,5,15)];
      }
      
      private function initVipIcon() : void
      {
         var _loc1_:DisplayObject = null;
         if(!_vipIcon)
         {
            _vipIcon = new VipLevelIcon(PlayerDataList.instance.selfData.vipLevel);
            _displayObj.addChild(_vipIcon);
            _loc1_ = getDisplayObjByName("pos");
            _vipIcon.x = _loc1_.x;
            _vipIcon.y = _loc1_.y - _vipIcon.height;
         }
      }
      
      public function showPlayerInfoByPlayerData(param1:PlayerData) : void
      {
         var levelScore:int;
         var scale:Number;
         var total:int;
         var i:int;
         var data:FriendData;
         var target:Array;
         var playData:PlayerData = param1;
         var targetArr:Array = playData.ability();
         var pos:DisplayObject = getDisplayObjByName("pos");
         character = CharacterFactory.instance.checkOutCharacter(playData.babySex);
         character.initData(playData.getPropData());
         character.scaleY = 0.7;
         character.scaleX = -character.scaleY;
         character.x = pos.x + pos.width * 1.8;
         character.y = pos.y + pos.height * 1.4;
         addChild(character);
         txtName.text = playData.babyName;
         txtId.text = playData.uid.toString();
         txtLevel.text = "LV" + playData.level;
         levelScore = BaseValues.getScoreByLevel(playData.level);
         getTextFieldByName("txtExp").text = playData.exp + " / " + levelScore;
         getTextFieldByName("txtExp").nativeFilters = [new GlowFilter(3677194,1,5,5,15)];
         scale = playData.exp / levelScore;
         scale = scale > 1 ? 1 : scale;
         getDisplayObjByName("bar").scaleX = scale;
         getTextFieldByName("txt2").text = LangManager.t("strength") + targetArr[0];
         getTextFieldByName("txt3").text = LangManager.t("reduceBlood") + ": " + targetArr[4];
         getTextFieldByName("txt4").text = LangManager.t("constitution") + targetArr[1];
         getTextFieldByName("txt5").text = LangManager.t("defense") + targetArr[5];
         getTextFieldByName("txt6").text = LangManager.t("agile") + targetArr[2];
         getTextFieldByName("txt7").text = LangManager.t("lucky") + targetArr[3];
         total = playData.fail + playData.win;
         if(total == 0)
         {
            getTextFieldByName("txt10").text = "0";
         }
         else
         {
            getTextFieldByName("txt10").text = Math.floor(playData.win / total * 100) + "%";
         }
         getTextFieldByName("txt11").text = total.toString();
         getTextFieldByName("txt12").text = playData.totalAblility.toString();
         i = 10;
         while(i < 13)
         {
            getTextFieldByName("txt" + i).bold = true;
            getTextFieldByName("txt" + i).hAlign = "left";
            getTextFieldByName("txt" + i).fontSize = 24;
            i = i + 1;
         }
         if(!btnSwitchAccount.visible)
         {
            data = new FriendData();
            target = [txtId.text,txtName.text,txtLevel.text];
            data.readData(target);
            setData(data);
         }
         initVipIcon();
         GameServer.instance.onSomeOneVipLevel((function():*
         {
            var cb:Function;
            return cb = function(param1:Object):void
            {
               _vipIcon.level = param1.level;
            };
         })());
         GameServer.instance.getSomeOneVipLevel(playData.uid);
      }
      
      public function receiveData(param1:Object) : void
      {
         Application.instance.log("AboutMe",JSON.stringify(param1));
         if(param1 == 0)
         {
            FriendsList.instance.addFriends(_data);
            TextTip.instance.showByLang("teamList6");
         }
      }
      
      private function gotoShop(param1:Event) : void
      {
         dispose();
         Application.instance.currentGame.navigator.showScreen("SHOP");
      }
      
      private function onTouchAccountType(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(!_isEnable || _loc2_ == null)
         {
            return;
         }
         if(_loc2_.phase == "began")
         {
            _loc2_.target.scaleX = _loc2_.target.scaleY = 0.9;
         }
         else if(_loc2_.phase == "ended")
         {
            _loc2_.target.scaleX = _loc2_.target.scaleY = 1;
            som();
         }
      }
      
      private function addFriend(param1:Event) : void
      {
         var _loc3_:FriendData = null;
         var _loc2_:Array = null;
         btnAddFriend.visible = false;
         if(_data == null)
         {
            _loc3_ = new FriendData();
            _loc2_ = [txtId.text,txtName.text,txtLevel.text,0,3];
            _loc3_.readData(_loc2_);
            _data = _loc3_;
         }
         Remoting.instance.addFriend(_data.antId,receiveData);
         remove();
      }
      
      private function onSwitchAccount(param1:Event) : void
      {
         remove();
         Application.instance.currentGame.mainMenu.onReturnBtn();
      }
      
      private function onClose(param1:Event) : void
      {
         remove();
      }
      
      private function remove() : void
      {
         var _loc1_:Hall = null;
         if(character)
         {
            character.removeFromParent();
         }
         removeFromParent();
         if(Application.instance.currentGame.navigator.activeScreenID == "HALL" && btnSwitchAccount.visible)
         {
            _loc1_ = Application.instance.currentGame.navigator.activeScreen as Hall;
            _loc1_.posGuide();
         }
      }
      
      private function addEvent() : void
      {
         btnClose = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         btnClose.addEventListener("triggered",onClose);
         _displayObj.addChild(btnClose);
         var _loc1_:DisplayObject = getDisplayObjByName("btnClose");
         SmallCodeTools.instance.setDisplayObjectInSame(_loc1_,btnClose);
         btnSwitchAccount = getButtonByName("btn_account");
         btnSwitchAccount.addEventListener("triggered",onSwitchAccount);
         btnAddFriend = getButtonByName("btn_addFriend");
         btnAddFriend.addEventListener("triggered",addFriend);
         btnShop = getButtonByName("btn_shop");
         btnShop.addEventListener("triggered",gotoShop);
      }
      
      private function som() : void
      {
         var _loc1_:Object = {};
         _loc1_[10] = {"info":"visitor"};
         _loc1_[12] = {"info":"Sina"};
         _loc1_[11] = {"info":"Boyaa"};
         trace("你当前登陆账号类型： " + _loc1_[_acountType].info);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

