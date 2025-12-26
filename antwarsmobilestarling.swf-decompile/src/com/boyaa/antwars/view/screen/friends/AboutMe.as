package com.boyaa.antwars.view.screen.friends
{
   import com.boyaa.antwars.data.BaseValues;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.Hall;
   import com.boyaa.antwars.view.screen.chatRoom.FriendData;
   import com.boyaa.antwars.view.screen.chatRoom.FriendsList;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideSprite;
   import com.boyaa.antwars.view.vipSystem.VipLevelIcon;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class AboutMe extends GuideSprite
   {
      
      private static const DEVICELOGIN:int = 10;
      
      private static const SINALOGIN:int = 12;
      
      private static const BOYAALOGIN:int = 11;
      
      private var bg:Image;
      
      private var btnClose:Button;
      
      private var btnAddFriend:Button;
      
      private var btnSwitchAccount:Button;
      
      private var _data:FriendData;
      
      private var txtName:TextField;
      
      private var txtLevel:TextField;
      
      private var txtId:TextField;
      
      private var txtExp:TextField;
      
      private var txt2:TextField;
      
      private var txt3:TextField;
      
      private var txt4:TextField;
      
      private var txt5:TextField;
      
      private var txt6:TextField;
      
      private var txt7:TextField;
      
      private var txt8:TextField;
      
      private var txt9:TextField;
      
      private var txt10:TextField;
      
      private var txt11:TextField;
      
      private var txt12:TextField;
      
      private var markBg:DlgMark;
      
      private var txtSprite:Sprite;
      
      private var character:Character;
      
      private var rect:Rectangle;
      
      private var imgDisable:Image;
      
      private var _acountImage:Image;
      
      private var _acountType:int = 11;
      
      private var _typeArr:Array = [10,12,11];
      
      private var _vipIcon:VipLevelIcon;
      
      private var _isEnable:Boolean = true;
      
      public function AboutMe(param1:Boolean = false)
      {
         super();
         this.addEventListener("addedToStage",onAddedToStage);
         initFace();
         if(param1)
         {
            btnSwitchAccount.visible = true;
            btnAddFriend.visible = false;
            imgDisable.visible = false;
         }
         else
         {
            btnSwitchAccount.visible = false;
            btnAddFriend.visible = true;
            imgDisable.visible = false;
         }
      }
      
      public function set isFriend(param1:Boolean) : void
      {
         btnAddFriend.visible = !param1;
         imgDisable.visible = param1;
      }
      
      public function get acountType() : int
      {
         return _acountType;
      }
      
      public function setData(param1:FriendData) : void
      {
         _data = param1;
         if(FriendsList.instance.isFriend(param1.antId) || param1.antId == PlayerDataList.instance.selfData.uid)
         {
            btnAddFriend.visible = false;
            imgDisable.visible = true;
         }
         else
         {
            btnAddFriend.visible = true;
            imgDisable.visible = false;
         }
      }
      
      private function initVipIcon() : void
      {
         if(!_vipIcon)
         {
            _vipIcon = new VipLevelIcon(PlayerDataList.instance.selfData.vipLevel);
            Assets.sAsset.positionDisplay(_vipIcon,"aboutMe","vipLevelIcon");
            addChild(_vipIcon);
         }
      }
      
      private function initFace() : void
      {
         markBg = new DlgMark();
         txtSprite = new Sprite();
         bg = new Image(Assets.sAsset.getTexture("grzl"));
         bg.touchable = false;
         Assets.positionDisplay(bg,"aboutMe","bg");
         addChild(bg);
         btnClose = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         btnClose.addEventListener("triggered",onClose);
         Assets.positionDisplay(btnClose,"aboutMe","btnClose");
         addChild(btnClose);
         btnAddFriend = new Button(Assets.sAsset.getTexture("grzl1"),"",Assets.sAsset.getTexture("grzl2"));
         btnAddFriend.addEventListener("triggered",addFriend);
         Assets.positionDisplay(btnAddFriend,"aboutMe","btnAddFriend");
         addChild(btnAddFriend);
         imgDisable = new Image(Assets.sAsset.getTexture("grzl1-2"));
         Assets.positionDisplay(imgDisable,"aboutMe","btnAddFriend");
         addChild(imgDisable);
         imgDisable.visible = false;
         btnSwitchAccount = new Button(Assets.sAsset.getTexture("account0"),"",Assets.sAsset.getTexture("account1"));
         btnSwitchAccount.addEventListener("triggered",onSwitchAccount);
         Assets.positionDisplay(btnSwitchAccount,"aboutMe","btnAddFriend");
         addChild(btnSwitchAccount);
         btnSwitchAccount.visible = false;
         var _loc3_:TextField = new TextField(250,28,LangManager.t("nickName") + ":","Verdana",24,4660230);
         _loc3_.hAlign = "right";
         txtName = new TextField(250,28,"LeoLuo","Verdana",24,4660230);
         txtName.hAlign = "left";
         txtName.autoScale = true;
         Assets.sAsset.positionDisplay(_loc3_,"aboutMe","txtName0");
         _loc3_.autoScale = true;
         Assets.sAsset.positionDisplay(txtName,"aboutMe","txtName");
         txtSprite.addChild(txtName);
         txtSprite.addChild(_loc3_);
         var _loc6_:TextField = new TextField(250,28,LangManager.t("level") + ":","Verdana",24,4660230);
         _loc3_.hAlign = "right";
         txtLevel = new TextField(250,28,"LV18","Verdana",24,4660230);
         txtLevel.hAlign = "left";
         Assets.sAsset.positionDisplay(txtLevel,"aboutMe","txtLevel");
         Assets.sAsset.positionDisplay(_loc6_,"aboutMe","txtLevel0");
         txtSprite.addChild(txtLevel);
         txtSprite.addChild(_loc6_);
         var _loc2_:TextField = new TextField(250,28,LangManager.t("mid") + ":","Verdana",24,4660230);
         txtId = new TextField(250,28,"45789546","Verdana",24,4660230);
         txtId.hAlign = "left";
         Assets.sAsset.positionDisplay(txtId,"aboutMe","txtId");
         Assets.sAsset.positionDisplay(_loc2_,"aboutMe","txtId0");
         txtSprite.addChild(txtId);
         txtSprite.addChild(_loc2_);
         var _loc1_:TextField = new TextField(250,28,LangManager.t("exp"),"Verdana",24,4660230);
         txtExp = new TextField(250,28,"1111111/1234567","Verdana",24,4660230);
         txtId.hAlign = "left";
         txtExp.autoScale = true;
         Assets.sAsset.positionDisplay(_loc1_,"aboutMe","txtExp0");
         Assets.sAsset.positionDisplay(txtExp,"aboutMe","txtExp");
         txtSprite.addChild(_loc1_);
         txtSprite.addChild(txtExp);
         var _loc7_:Image = new Image(Assets.sAsset.getTexture("line"));
         Assets.sAsset.positionDisplay(_loc7_,"aboutMe","line1");
         addChild(_loc7_);
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("line"));
         Assets.sAsset.positionDisplay(_loc5_,"aboutMe","line2");
         addChild(_loc5_);
         txt2 = new TextField(250,24," ","Verdana",24,16777215);
         txt2.hAlign = "left";
         Assets.sAsset.positionDisplay(txt2,"aboutMe","txt2");
         txtSprite.addChild(txt2);
         txt3 = new TextField(250,24," ","Verdana",24,16777215);
         txt3.hAlign = "left";
         Assets.sAsset.positionDisplay(txt3,"aboutMe","txt3");
         txtSprite.addChild(txt3);
         txt4 = new TextField(250,24,"","Verdana",24,16777215);
         txt4.hAlign = "left";
         Assets.sAsset.positionDisplay(txt4,"aboutMe","txt4");
         txtSprite.addChild(txt4);
         txt5 = new TextField(250,24,"","Verdana",24,16777215);
         txt5.hAlign = "left";
         Assets.sAsset.positionDisplay(txt5,"aboutMe","txt5");
         txtSprite.addChild(txt5);
         txt6 = new TextField(250,24,"","Verdana",24,16777215);
         txt6.hAlign = "left";
         Assets.sAsset.positionDisplay(txt6,"aboutMe","txt6");
         txtSprite.addChild(txt6);
         txt7 = new TextField(250,24,"","Verdana",24,16777215);
         txt7.hAlign = "left";
         Assets.sAsset.positionDisplay(txt7,"aboutMe","txt7");
         txtSprite.addChild(txt7);
         txt8 = new TextField(250,24,"","Verdana",24,16777215);
         txt8.hAlign = "left";
         Assets.sAsset.positionDisplay(txt8,"aboutMe","txt8");
         txtSprite.addChild(txt8);
         txt9 = new TextField(250,24,"","Verdana",24,16777215);
         txt9.hAlign = "left";
         Assets.sAsset.positionDisplay(txt9,"aboutMe","txt9");
         txtSprite.addChild(txt9);
         txt10 = new TextField(250,24,"","Verdana",24,16777215);
         txt10.hAlign = "left";
         Assets.sAsset.positionDisplay(txt10,"aboutMe","txt10");
         txtSprite.addChild(txt10);
         txt11 = new TextField(250,24,"","Verdana",24,16777215);
         txt11.hAlign = "left";
         Assets.sAsset.positionDisplay(txt11,"aboutMe","txt11");
         txtSprite.addChild(txt11);
         txt12 = new TextField(250,24,"","Verdana",24,16777215);
         txt12.hAlign = "left";
         Assets.sAsset.positionDisplay(txt12,"aboutMe","txt12");
         txtSprite.addChild(txt12);
         txtSprite.touchable = false;
         addChild(txtSprite);
         rect = Assets.getPosition("aboutMe","headImg");
         var _loc4_:Rectangle = Assets.sAsset.getPosition("aboutMe","acountType");
         _acountImage = new Image(Assets.sAsset.getTexture("bd" + _acountType));
         _acountImage.x = _loc4_.x;
         _acountImage.y = _loc4_.y;
         addChild(_acountImage);
         _acountImage.addEventListener("touch",onTouchAccountType);
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
      
      private function som() : void
      {
         var _loc1_:Object = {};
         _loc1_[10] = {"info":"visitor"};
         _loc1_[12] = {"info":"Sina"};
         _loc1_[11] = {"info":"Boyaa"};
         trace("你当前登陆账号类型： " + _loc1_[_acountType].info);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         var event:Event = param1;
         parent.addChild(markBg);
         parent.swapChildren(markBg,this);
         this.pivotX = 306;
         this.pivotY = 306;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.5,{
            "scaleX":1,
            "scaleY":1,
            "transition":"linear",
            "onComplete":function():void
            {
               if(character)
               {
                  addChild(character);
               }
            }
         });
      }
      
      private function onClose(param1:Event) : void
      {
         Starling.juggler.tween(this,0.5,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeInBack",
            "onComplete":remove
         });
      }
      
      private function addFriend(param1:Event) : void
      {
         var _loc3_:FriendData = null;
         var _loc2_:Array = null;
         btnAddFriend.visible = false;
         imgDisable.visible = true;
         if(_data == null)
         {
            _loc3_ = new FriendData();
            _loc2_ = [txtId.text,txtName.text,txtLevel.text];
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
      
      private function remove() : void
      {
         var _loc1_:Hall = null;
         Starling.juggler.removeTweens(this);
         if(character)
         {
            character.removeFromParent();
         }
         markBg.removeFromParent();
         removeFromParent();
         if(Application.instance.currentGame.navigator.activeScreenID == "HALL" && btnSwitchAccount.visible)
         {
            _loc1_ = Application.instance.currentGame.navigator.activeScreen as Hall;
            _loc1_.posGuide();
         }
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
      
      public function showPlayerInfo(param1:Object) : void
      {
         var _loc2_:Array = param1 as Array;
         var _loc5_:Object = _loc2_[1];
         var _loc3_:Array = _loc2_[2];
         var _loc4_:PlayerData = new PlayerData();
         _loc4_.addOtherInfo(_loc5_);
         _loc4_.addOtherPropInfo(_loc3_);
         showPlayerInfoByPlayerData(_loc4_);
      }
      
      public function showPlayerInfoByPlayerData(param1:PlayerData) : void
      {
         var levelScore:int;
         var total:int;
         var data:FriendData;
         var target:Array;
         var playData:PlayerData = param1;
         var targetArr:Array = playData.ability();
         character = CharacterFactory.instance.checkOutCharacter(playData.babySex);
         character.initData(playData.getPropData());
         character.scaleY = 0.6;
         character.scaleX = -character.scaleY;
         character.x = rect.x + (rect.width >> 1);
         character.y = rect.y + rect.height;
         txtName.text = playData.babyName;
         txtId.text = playData.uid.toString();
         txtLevel.text = "LV" + playData.level;
         levelScore = BaseValues.getScoreByLevel(playData.level);
         txtExp.text = playData.exp + "/" + levelScore;
         txtExp.hAlign = "left";
         txt2.text = LangManager.t("strength") + targetArr[0];
         txt3.text = LangManager.t("reduceBlood") + ": " + targetArr[4];
         txt4.text = LangManager.t("constitution") + targetArr[1];
         txt5.text = LangManager.t("defense") + targetArr[5];
         txt6.text = LangManager.t("agile") + targetArr[2];
         txt7.text = LangManager.t("lucky") + targetArr[3];
         txt8.text = LangManager.t("life") + targetArr[6];
         txt9.text = LangManager.t("physical") + targetArr[7];
         total = playData.fail + playData.win;
         if(total == 0)
         {
            txt10.text = LangManager.t("winPercent") + ":" + 0;
         }
         else
         {
            txt10.text = LangManager.t("winPercent") + ":" + Math.floor(playData.win / total * 100) + "%";
         }
         txt11.text = LangManager.t("fightNum") + ":" + total;
         txt12.text = LangManager.t("fight") + ":" + targetArr[0];
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
      
      override public function dispose() : void
      {
         trace("[dispose AboutMe...]");
      }
   }
}

