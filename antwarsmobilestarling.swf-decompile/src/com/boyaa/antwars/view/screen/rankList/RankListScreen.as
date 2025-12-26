package com.boyaa.antwars.view.screen.rankList
{
   import com.boyaa.antwars.data.AllRoomData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.data.model.ServerData;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.screen.friends.FriendPickerGroup;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.antwars.view.vipSystem.VipLevelText;
   import com.boyaa.debug.Logging.LevelLogger;
   import feathers.controls.List;
   import feathers.controls.Screen;
   import feathers.data.ListCollection;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.textures.Texture;
   import starling.utils.formatString;
   
   public class RankListScreen extends Screen
   {
      
      private static var _isRankFight:Boolean = false;
      
      private var _asset:ResAssetManager;
      
      private var _layoutUitl:LayoutUitl;
      
      private var _spPos:DisplayObject;
      
      private var _rankList:List;
      
      private var _sprite0:Sprite;
      
      private var _sprite1:Sprite;
      
      private var _sprite2:Sprite;
      
      private var _fightBtn:Button;
      
      private var _allRankBtn:Button;
      
      private var _selfRankBtn:Button;
      
      private var _rewardBtn:Button;
      
      private var _character:Character;
      
      private var _backBtn:Button;
      
      private var _weaponImg:Image;
      
      private var _buttonTextureArr:Array = [];
      
      public const ALLRANK:int = 0;
      
      public const SELFRANK:int = 1;
      
      public const REWARDRANK:int = 2;
      
      private var _playerReData:Object;
      
      private var _currentPlayerData:PlayerData;
      
      private var _myRank:TextField;
      
      private var _myFightNum:TextField;
      
      private var _myName:TextField;
      
      private var _myVipLevel:VipLevelText;
      
      private var _playerAllInfoArr:Array = [];
      
      private var _playerArrowMeArr:Array = [];
      
      private var _playerRewardsArr:Array = [];
      
      private var _showInfoArr:Array = [];
      
      private var _loadingText:TextField;
      
      private var _tabIndex:int = 2;
      
      private var _FriendPicker:FriendPickerGroup;
      
      private var _myFaceBookHead:FacebookHeadPicture;
      
      private var _currentIndex:int = 0;
      
      private var _rewardList:Array = [];
      
      private var _listProviderData:ListCollection;
      
      public function RankListScreen()
      {
         super();
         Application.instance.currentGame.showLoading();
         _asset = Assets.sAsset;
         initGameServer();
         _isRankFight = false;
      }
      
      public static function get isRankFight() : Boolean
      {
         return _isRankFight;
      }
      
      private function loadRankAssets() : void
      {
         var _loc1_:ResManager = Application.instance.resManager;
         _asset.enqueue(_loc1_.getResFile(formatString("asset/rankList.info")),_loc1_.getResFile(formatString("textures/{0}x/BT/btdlg.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/btdlg.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/rankList.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/rankList.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/battlefieldSpritesheet.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/battlefieldSpritesheet.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/BattlefieldUI.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/BattlefieldUI.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/smallmap.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/smallmap.xml",Assets.sAsset.scaleFactor))
         ,_loc1_.getResFile(formatString("textures/{0}x/BT/emoticon.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/emoticon.xml",Assets.sAsset.scaleFactor)));
         _asset.loadQueue(loading);
      }
      
      private function bindNet() : void
      {
         BattleServer.instance.onRankTo50(onTop50);
         BattleServer.instance.onRankTo50ArrowMe(onTop50ArrowMe);
         BattleServer.instance.onRankIsCanFight(onIsCanFight);
         BattleServer.instance.onRankFightResut(onFightResult);
         BattleServer.instance.onRankFightHistory(onFightHistory);
         BattleServer.instance.onRankFightRewards(onFightRewards);
         BattleServer.instance.onRankSomeoneEquip(onSomeoneEquip);
      }
      
      private function unBindNet() : void
      {
         BattleServer.instance.disposeRecvFun(onTop50);
         BattleServer.instance.disposeRecvFun(onTop50ArrowMe);
         BattleServer.instance.disposeRecvFun(onIsCanFight);
         BattleServer.instance.disposeRecvFun(onFightResult);
         BattleServer.instance.disposeRecvFun(onFightHistory);
         BattleServer.instance.disposeRecvFun(onFightRewards);
         BattleServer.instance.disposeRecvFun(onSomeoneEquip);
      }
      
      private function removeEvent() : void
      {
         unBindNet();
         if(_rankList)
         {
            _rankList.removeEventListener("change",onListChangeHandle);
         }
      }
      
      private function loadFaceBookImg(param1:Array, param2:Function = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_.push(param1[_loc3_][0]);
            _loc3_++;
         }
         RankListPlayerPictures.instance.loadPic(_loc4_,param2);
      }
      
      private function onTop50(param1:Object) : void
      {
         LevelLogger.getLogger("Rank - onTop50").info(JSON.stringify(param1));
         _myRank.text = param1.data.selfData.rank;
         _myFightNum.text = param1.data.selfData.fightNum;
         _myName.text = PlayerDataList.instance.selfData.babyName;
         _myVipLevel.level = PlayerDataList.instance.selfData.vipLevel;
         _playerAllInfoArr = param1.data.playerArr;
         _loadingText.visible = false;
         loadFaceBookImg(_playerAllInfoArr,showAllRankSprite);
      }
      
      private function onTop50ArrowMe(param1:Object) : void
      {
         LevelLogger.getLogger("Rank - onTop50ArrowMe").info(JSON.stringify(param1));
         _playerArrowMeArr = param1.data.playerArr;
         showSelfRankSprite();
         _loadingText.visible = false;
         BattleServer.instance.getRankSomeOneEquip(_playerArrowMeArr[0][0]);
      }
      
      private function onIsCanFight(param1:Object) : void
      {
         LevelLogger.getLogger("Rank - onIsCanFight").info(JSON.stringify(param1));
         if(param1.data.canFightCount != -1)
         {
            _currentPlayerData.isrobot = true;
            loadFightAssests();
            _isRankFight = true;
         }
         else
         {
            TextTip.instance.showByLang("rankFightEnd");
         }
      }
      
      private function onFightResult(param1:Object) : void
      {
         LevelLogger.getLogger("Rank - onFightResult").info(JSON.stringify(param1));
      }
      
      private function onFightHistory(param1:Object) : void
      {
         LevelLogger.getLogger("Rank - onFightHistory").info(JSON.stringify(param1));
         _playerRewardsArr = param1.data.playerArr;
         showRewardSprite();
         _loadingText.visible = false;
      }
      
      private function onFightRewards(param1:Object) : void
      {
         var _loc3_:ShopData = null;
         var _loc2_:String = null;
         LevelLogger.getLogger("Rank - onFightRewards").info(JSON.stringify(param1));
         if(param1.data.done)
         {
            _loc3_ = ShopDataList.instance.getSingleData(param1.data.pcate,param1.data.pframe);
            _loc2_ = LangManager.getLang.getreplaceLang("rewardDone",_loc3_.name);
            TextTip.instance.show(_loc2_);
         }
         else
         {
            TextTip.instance.showByLang("rewardFaile");
         }
      }
      
      private function onSomeoneEquip(param1:Object) : void
      {
         LevelLogger.getLogger("Rank - onSomeoneEquip").info(JSON.stringify(param1));
         PlayerDataList.instance.removePlayers();
         param1.data.charInfo = "{\n   \"age\" : 24,\n   \"appearence\" : \"9|1|1|1\",\n   \"babyName\" : \"10051757322\",\n   \"babySex\" : 1,\n   \"born\" : \"2011-01-01\",\n   \"cid\" : 0,\n   \"cname\" : \"\",\n   \"fail\" : 17,\n   \"home\" : \"\",\n   \"img\" : \"http://uchome.manyou.com/avatar/5196718257?thumb\",\n   \"kill\" : 3,\n   \"name\" : \"10051757322\",\n   \"ranking\" : 0,\n   \"reside\" : \"安徽 蚌埠\",\n   \"runaway\" : 0,\n   \"sex\" : 0,\n   \"webSid\" : \"5196718257\",\n   \"win\" : 7\n}\n";
         _playerReData = param1.data;
         if(PlayerDataList.instance.selfData.uid != _playerReData.mid)
         {
            PlayerDataList.instance.addPlayer(_playerReData);
         }
         _currentPlayerData = PlayerDataList.instance.getDataByUID(_playerReData.mid);
         if(_playerArrowMeArr.length != 0)
         {
            _currentPlayerData.babyName = _playerArrowMeArr[_currentIndex][2];
         }
         _currentPlayerData.babySex = param1.data.babySex;
         showCharacter();
      }
      
      private function loading(param1:Number) : void
      {
         if(param1 == 1)
         {
            Application.instance.currentGame.hiddenLoading();
            _layoutUitl = new LayoutUitl(_asset.getOther("rankList"),_asset);
            _layoutUitl.buildLayout("rankLayout",this);
            _spPos = this.getChildByName("spritePos");
            init();
         }
      }
      
      private function init() : void
      {
         BattleServer.instance.getRankFightHistory(PlayerDataList.instance.selfData.uid);
         _loadingText = new TextField(200,40,"loading...","Verdana",20,16777215);
         _loadingText.x = 500;
         _loadingText.y = 400;
         _loadingText.visible = false;
         _rankList = new List();
         _rankList.addEventListener("change",onListChangeHandle);
         initButton();
         initTextInfo();
         onSelectRankFunc(null);
         showCharacter();
         _FriendPicker = new FriendPickerGroup();
      }
      
      private function onListChangeHandle(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         _listProviderData.updateItemAt(_loc2_.selectedIndex);
         _currentIndex = _loc2_.selectedIndex;
         _FriendPicker.show(_showInfoArr[_currentIndex][0]);
         if(_tabIndex == 2)
         {
            return;
         }
         BattleServer.instance.getRankSomeOneEquip(_showInfoArr[_currentIndex][0]);
      }
      
      private function initButton() : void
      {
         _backBtn = this.getChildByName("btnS_back") as Button;
         _backBtn.addEventListener("triggered",onBackFunc);
         _allRankBtn = this.getChildByName("rankAllBtn") as Button;
         _selfRankBtn = this.getChildByName("rankOtherBtn") as Button;
         _rewardBtn = this.getChildByName("rankRewardBtn") as Button;
         _fightBtn = this.getChildByName("fightBtn") as Button;
         _fightBtn.visible = false;
         _fightBtn.addEventListener("triggered",onFightOtherFunc);
         _allRankBtn.addEventListener("triggered",onSelectRankFunc);
         _selfRankBtn.addEventListener("triggered",onSelectRankFunc);
         _rewardBtn.addEventListener("triggered",onSelectRankFunc);
         _buttonTextureArr.push([_allRankBtn.upState,_allRankBtn.downState,_allRankBtn]);
         _buttonTextureArr.push([_selfRankBtn.upState,_selfRankBtn.downState,_selfRankBtn]);
         _buttonTextureArr.push([_rewardBtn.upState,_rewardBtn.downState,_rewardBtn]);
         _allRankBtn.upState = _allRankBtn.downState;
      }
      
      private function onFightOtherFunc(param1:Event) : void
      {
         if(!SmallCodeTools.instance.checkEquipWeapon())
         {
            return;
         }
         if(!_currentPlayerData)
         {
            TextTip.instance.showByLang("rankFightSelectTip");
            return;
         }
         PlayerDataList.instance.bornPoint = new Vector.<Point>();
         PlayerDataList.instance.bornPoint.push(new Point(300,300));
         PlayerDataList.instance.bornPoint.push(new Point(350,300));
         PlayerDataList.instance.bornPoint.push(new Point(825,300));
         PlayerDataList.instance.bornPoint.push(new Point(825,300));
         if(_currentPlayerData.uid == PlayerDataList.instance.selfData.uid)
         {
            TextTip.instance.showByLang("rankFightSelectTip");
            return;
         }
         BattleServer.instance.getRankIsCanFight(PlayerDataList.instance.selfData.uid);
      }
      
      private function loadFightAssests() : void
      {
         var mapId:int = 1001;
         var mapURL:String = "map_" + mapId;
         PlayerDataList.instance.mapId = mapId;
         Assets.btAsset = Assets.sAsset;
         Assets.btAsset.enqueueMap(mapId,mapURL);
         BattleServer.instance.selfReady(1);
         Application.instance.currentGame.showLoading();
         Assets.btAsset.loadQueue((function():*
         {
            var onProgress:Function;
            return onProgress = function(param1:Number):void
            {
               var ratio:Number = param1;
               if(ratio == 1)
               {
                  Starling.juggler.delayCall(function():void
                  {
                     Application.instance.currentGame.hiddenLoading();
                     dispatchEventWith("showRankFight");
                  },1);
               }
            };
         })());
      }
      
      private function onSelectRankFunc(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(_loadingText.visible)
         {
            return;
         }
         if(param1 == null)
         {
            if(_playerAllInfoArr.length == 0)
            {
               _loadingText.visible = true;
               BattleServer.instance.rankTop50(PlayerDataList.instance.selfData.uid);
            }
            showAllRankSprite();
            addChild(_loadingText);
            _tabIndex = 0;
            return;
         }
         if(Button(param1.target).upState == Button(param1.target).downState)
         {
            trace("已经是按下状态，不能操作");
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < _buttonTextureArr.length)
         {
            Button(_buttonTextureArr[_loc2_][2]).upState = _buttonTextureArr[_loc2_][0];
            Button(_buttonTextureArr[_loc2_][2]).downState = _buttonTextureArr[_loc2_][1];
            _loc2_++;
         }
         Button(param1.target).upState = Button(param1.target).downState;
         if(param1.currentTarget == _allRankBtn)
         {
            if(_playerAllInfoArr.length == 0)
            {
               _loadingText.visible = true;
               BattleServer.instance.rankTop50(PlayerDataList.instance.selfData.uid);
            }
            _tabIndex = 0;
            showAllRankSprite();
            removeSomeLayoutExpect(_sprite0);
         }
         else if(param1.currentTarget == _selfRankBtn)
         {
            if(_playerArrowMeArr.length == 0)
            {
               _loadingText.visible = true;
               BattleServer.instance.rankTop50ArrowMe(PlayerDataList.instance.selfData.uid);
            }
            else
            {
               BattleServer.instance.getRankSomeOneEquip(_playerArrowMeArr[0][0]);
            }
            _tabIndex = 1;
            showSelfRankSprite();
            removeSomeLayoutExpect(_sprite1);
            if(_playerArrowMeArr.length != 0)
            {
               _fightBtn.visible = true;
            }
         }
         else
         {
            _tabIndex = 2;
            showRewardSprite();
            BattleServer.instance.getRankFightHistory(PlayerDataList.instance.selfData.uid);
            removeSomeLayoutExpect(_sprite2);
         }
         addChild(_loadingText);
      }
      
      private function onBackFunc(param1:Event) : void
      {
         BattleServer.instance.close();
         this.dispatchEventWith("complete");
      }
      
      private function showCharacter() : void
      {
         if(!_currentPlayerData)
         {
            _currentPlayerData = PlayerDataList.instance.selfData;
         }
         if(_character)
         {
            _character.removeFromParent(true);
         }
         _character = CharacterFactory.instance.checkOutCharacter(_currentPlayerData.babySex);
         _character.scaleY = 0.6;
         _character.scaleX = _character.scaleY;
         _character.initData(_currentPlayerData.getPropData());
         var _loc1_:DisplayObject = this.getChildByName("character");
         setPosition(_character,_loc1_);
         _character.x += _loc1_.width >> 1;
         _character.y += _loc1_.height;
         this.addChild(_character);
         updateCharacter();
         showAttrText(_currentPlayerData.ability());
         TextField(this.getChildByName("level")).text = "LV" + _currentPlayerData.level;
         TextField(this.getChildByName("level")).nativeFilters = StarlingUITools.instance.getDropShadowFilter(3735581);
      }
      
      private function showAttrText(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:TextField = null;
         _loc3_ = 0;
         while(_loc3_ < 6)
         {
            _loc2_ = this.getChildByName("txt" + _loc3_) as TextField;
            _loc2_.color = 16777215;
            _loc2_.text = param1[_loc3_];
            _loc2_.nativeFilters = StarlingUITools.instance.getDropShadowFilter(3735581);
            _loc3_++;
         }
      }
      
      private function initTextInfo() : void
      {
         var _loc3_:int = 0;
         var _loc2_:TextField = null;
         var _loc1_:Array = LangManager.getLang.getLangArray("detailsNameArr");
         _loc3_ = 0;
         while(_loc3_ < 6)
         {
            _loc2_ = this.getChildByName("textInfo" + _loc3_) as TextField;
            _loc2_.text = _loc1_[_loc3_] + ": ";
            _loc2_.nativeFilters = StarlingUITools.instance.getDropShadowFilter(3735581);
            _loc3_++;
         }
      }
      
      private function updateCharacter() : void
      {
         var _loc1_:ShopData = _currentPlayerData.getWeapon();
         updateWeapon(_loc1_);
      }
      
      private function updateWeapon(param1:ShopData) : void
      {
         var _loc3_:String = ShopDataList.instance.getWeaponImageString(param1);
         if(!_loc3_)
         {
            trace("武器图片不存在, shopData",param1);
            return;
         }
         _weaponImg && _weaponImg.parent && _weaponImg.removeFromParent(true);
         var _loc2_:Texture = Assets.sAsset.getTextureAtlas("wqSpritesheet").getTexture(_loc3_);
         _weaponImg = new Image(_loc2_);
         var _loc4_:DisplayObject = this.getChildByName("weapon");
         setPosition(_weaponImg,_loc4_);
         _weaponImg.height = _loc4_.height;
         _weaponImg.scaleX = _weaponImg.scaleY;
         this.addChild(_weaponImg);
      }
      
      private function showAllRankSprite() : void
      {
         var _loc1_:String = null;
         if(!_sprite0)
         {
            _sprite0 = _layoutUitl.createSprite("rankSprite0");
            setPosition(_sprite0,_spPos);
            _myFaceBookHead = new FacebookHeadPicture(_sprite0.getChildByName("faceBookPic") as Sprite,Sprite(_sprite0.getChildByName("faceBookPic")).getChildByName("posHead").bounds);
            _loc1_ = RankListPlayerPictures.instance.getPlayerFaceBookImageUrlByUID(PlayerDataList.instance.selfData.uid);
            if(_loc1_ != "" && _loc1_ != null)
            {
               _myFaceBookHead.update(_loc1_);
            }
         }
         _sprite0.visible = true;
         addChild(_sprite0);
         _sprite0.addChild(_rankList);
         SmallCodeTools.instance.setDisplayObjectInSame(_sprite0.getChildByName("pos_list"),_rankList);
         _myRank = _sprite0.getChildByName("rankNum") as TextField;
         _myFightNum = _sprite0.getChildByName("fightNum") as TextField;
         _myName = _sprite0.getChildByName("playerName") as TextField;
         _myVipLevel = new VipLevelText();
         _myVipLevel.level = 0;
         SmallCodeTools.instance.setDisplayObjectInSameScale(_sprite0.getChildByName("pos_vip"),_myVipLevel,1);
         _sprite0.addChild(_myVipLevel);
         showPlayerInfos(_sprite0,_playerAllInfoArr);
      }
      
      private function showSelfRankSprite() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Array = null;
         var _loc3_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _playerRewardsArr.length)
         {
            _loc1_ = _playerRewardsArr[_loc2_];
            _loc3_ = 0;
            while(_loc3_ < _playerArrowMeArr.length)
            {
               if(_playerArrowMeArr[_loc3_][0] == _loc1_[1])
               {
                  _playerArrowMeArr.splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
            _loc2_++;
         }
         if(!_sprite1)
         {
            _sprite1 = _layoutUitl.createSprite("rankSprite1");
            setPosition(_sprite1,_spPos);
         }
         addChild(_sprite1);
         _sprite1.addChild(_rankList);
         SmallCodeTools.instance.setDisplayObjectInSame(_sprite1.getChildByName("pos_list"),_rankList);
         showPlayerInfos(_sprite1,_playerArrowMeArr);
         if(_playerArrowMeArr.length != 0)
         {
            _fightBtn.visible = true;
         }
      }
      
      private function showRewardSprite() : void
      {
         var _loc1_:SingleRankData = null;
         var _loc4_:int = 0;
         if(!_sprite2)
         {
            _sprite2 = _layoutUitl.createSprite("rankSprite2");
            setPosition(_sprite2,_spPos);
         }
         addChild(_sprite2);
         _sprite2.addChild(_rankList);
         SmallCodeTools.instance.setDisplayObjectInSame(_sprite2.getChildByName("pos_list"),_rankList);
         var _loc2_:Array = [];
         var _loc3_:Array = _playerRewardsArr;
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc1_ = new SingleRankData(_loc3_[_loc4_][1],_loc3_[_loc4_][0],_loc3_[_loc4_][2],0,_loc3_[_loc4_][3],_loc3_[_loc4_][4],_loc3_[_loc4_][5]);
            _loc2_.push(_loc1_);
            _loc4_++;
         }
         _rankList.dataProvider = new ListCollection(_loc2_);
         _rankList.itemRendererType = SingleRankRewardRender;
      }
      
      private function showPlayerInfos(param1:Sprite, param2:Array, param3:int = 50) : void
      {
         var _loc4_:SingleRankData = null;
         var _loc6_:int = 0;
         var _loc5_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < param2.length)
         {
            _loc4_ = new SingleRankData(param2[_loc6_][0],param2[_loc6_][1],param2[_loc6_][2],param2[_loc6_][3],false,false,param2[_loc6_][4]);
            _loc5_.push(_loc4_);
            _loc6_++;
         }
         _listProviderData = new ListCollection(_loc5_);
         _rankList.dataProvider = _listProviderData;
         _rankList.itemRendererType = SingleRankRender;
         _showInfoArr = param2;
      }
      
      private function removeSomeLayoutExpect(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            if(this["_sprite" + _loc2_])
            {
               this["_sprite" + _loc2_].visible = false;
            }
            _loc2_++;
         }
         param1.visible = true;
         _fightBtn.visible = false;
      }
      
      private function showSprite(param1:String) : void
      {
      }
      
      private function setPosition(param1:DisplayObject, param2:DisplayObject) : void
      {
         param1.x = param2.x;
         param1.y = param2.y;
      }
      
      private function initGameServer() : void
      {
         if(BattleServer.instance.isConnect)
         {
            bindNet();
            loadRankAssets();
            return;
         }
         GameServer.instance.getServerIDByType(1,function(param1:Object):void
         {
            var serData:ServerData;
            var data:Object = param1;
            LevelLogger.getLogger("RankListScreen").info(JSON.stringify(data));
            if(data.ret == 0)
            {
               serData = AllRoomData.instance.getDataByID(data.svid);
               BattleServer.instance.init(serData.ip,serData.port);
               BattleServer.instance.connect();
               BattleServer.instance.login(function(param1:Object):void
               {
                  LevelLogger.getLogger("BtRoom").info(JSON.stringify(param1));
                  if(param1.ret == 1)
                  {
                     BattleServer.instance.close();
                     Application.instance.currentGame.hiddenLoading();
                     dispatchEventWith("complete");
                     return;
                  }
                  bindNet();
                  loadRankAssets();
               });
            }
         });
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEvent();
      }
   }
}

