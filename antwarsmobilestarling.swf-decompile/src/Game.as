package
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.LoudSpeaker;
   import com.boyaa.antwars.view.display.ChangeScreenLoading;
   import com.boyaa.antwars.view.display.StartGameProgress;
   import com.boyaa.antwars.view.game.IGameWorld;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.Hall;
   import com.boyaa.antwars.view.screen.MainMenu;
   import com.boyaa.antwars.view.screen.battlefield.Battlefield;
   import com.boyaa.antwars.view.screen.battlefield.BtHallScreen;
   import com.boyaa.antwars.view.screen.battlefield.BtRoom;
   import com.boyaa.antwars.view.screen.battlefield.Robot2vs2Battlefield;
   import com.boyaa.antwars.view.screen.battlefield.RobotBattlefield;
   import com.boyaa.antwars.view.screen.chatRoom.ChatRoomDlg;
   import com.boyaa.antwars.view.screen.copygame.CopyGame;
   import com.boyaa.antwars.view.screen.copygame.SkyCity;
   import com.boyaa.antwars.view.screen.copygame.boss.LeienWorld;
   import com.boyaa.antwars.view.screen.copygame.boss.ZhunhuangWorld;
   import com.boyaa.antwars.view.screen.copygame.game.CopyGameWorld;
   import com.boyaa.antwars.view.screen.copygame.spiderCity.SpiderCity;
   import com.boyaa.antwars.view.screen.copygame.spriteCity.SpriteCity;
   import com.boyaa.antwars.view.screen.copygame.team.InviteFriendFeedManager;
   import com.boyaa.antwars.view.screen.copygame.team.TeamList;
   import com.boyaa.antwars.view.screen.copygame.team.TeamRoom;
   import com.boyaa.antwars.view.screen.endlessTower.EndlessTowerScreen;
   import com.boyaa.antwars.view.screen.endlessTower.EndlessTowerWorld;
   import com.boyaa.antwars.view.screen.forge.Forge;
   import com.boyaa.antwars.view.screen.fresh.FreshGameWorld;
   import com.boyaa.antwars.view.screen.rankList.RankListScreen;
   import com.boyaa.antwars.view.screen.shop.ShopScreen;
   import com.boyaa.antwars.view.screen.union.UnionScreen;
   import com.boyaa.antwars.view.screen.unionBossFight.UnionBossFightWorld;
   import dragonBones.animation.WorldClock;
   import feathers.controls.ScreenNavigator;
   import feathers.controls.ScreenNavigatorItem;
   import feathers.motion.transitions.ScreenFadeTransitionManager;
   import feathers.themes.AntwarsTheme;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.textures.Texture;
   
   public class Game extends Sprite
   {
      
      public static const IN_BATTLEFIELD:int = 0;
      
      public static const IN_ROBOTBATTLEFIELD:int = 0;
      
      public static const IN_SHOP:int = 1;
      
      public static const IN_HALL:int = 1;
      
      public static const IN_FRESHGAMEWORLD:int = 1;
      
      public static const IN_FORGE:int = 1;
      
      public static const IN_SHOW_UINON:int = 1;
      
      public static const IN_BTROOM:int = 2;
      
      public static const IN_MATCH:int = 3;
      
      public static const IN_HOME:int = 4;
      
      public static const IN_TEAMLIST:int = 17;
      
      public static const IN_TEAMROOM:int = 18;
      
      public static const IN_COPYGAME:int = 5;
      
      public static const IN_SKYCITY:int = 5;
      
      public static const IN_COPYGAMEWORLD:int = 5;
      
      public static const IN_DUPROOM:int = 6;
      
      public static const IN_PROMOTION_RACE_ROOM:int = 7;
      
      public static const IN_UNION:int = 9;
      
      public static const IN_UNION_READY:int = 10;
      
      public static const IN_UNION_LIST:int = 12;
      
      public static const IN_MARRY:int = 13;
      
      public static const IN_AUCTION:int = 15;
      
      public static const IN_RANKLIST:int = 16;
      
      public static var fromSkycityToShop:Boolean = false;
      
      public static const HALL:String = "HALL";
      
      public static const SHOP:String = "SHOP";
      
      public static const BATTLEFIELD:String = "BATTLEFIELD";
      
      public static const ROBOTBATTLEFIELD:String = "ROBOTBATTLEFIELD";
      
      public static const ROBOT_2VS2_BATTLEFIELD:String = "ROBOT_2VS2_BATTLEFIELD";
      
      public static const BTROOM:String = "BTROOM";
      
      public static const COPYGAME:String = "COPYGAME";
      
      public static const SKYCITY:String = "SKYCITY";
      
      public static const SPIDERCITY:String = "SPIDERCITY";
      
      public static const SPRITECITY:String = "SPRITECITY";
      
      public static const COPYGAMEWORLD:String = "COPYGAMEWORLD";
      
      public static const FRESHGAMEWORLD:String = "FRESHGAMEWORLD";
      
      public static const FORGE:String = "FORGE";
      
      public static const TEAMLIST:String = "TEAMLIST";
      
      public static const TEAMROOM:String = "TEAMROOM";
      
      public static const RANK:String = "RANK";
      
      public static const ENDLESSTOWER:String = "ENDLESSTOWER";
      
      public static const ENDLESSTOWERWORLD:String = "ENDLESSTOWERWORLD";
      
      public static const ZHUNHUANGWORLD:String = "ZHUNHUANGWORLD";
      
      public static const LEIENWORLD:String = "LEIENTWORLD";
      
      public static const SHOW_UINON:String = "SHOW_UINON";
      
      public static const UNIONBOSSWORLD:String = "UNIONBOSSWORLD";
      
      public static const SHOW_BT_HALL:String = "SHOW_BT_HALL";
      
      private var _theme:AntwarsTheme;
      
      private var _navigator:ScreenNavigator;
      
      private var _transitionManager:ScreenFadeTransitionManager;
      
      public var mainMenu:MainMenu;
      
      public var frontLayer:Sprite;
      
      public var tipLayer:Sprite;
      
      public var _btRoomOptionsData:Object = {};
      
      public var _copyModeOptionsData:Object = {};
      
      public var _guideOptionsData:Object = {};
      
      public var hasAct:Boolean = false;
      
      private var _currentWorld:IGameWorld;
      
      private var alertShow:Boolean = false;
      
      private var noupdate:Boolean = false;
      
      private var _loadingInScreen:ChangeScreenLoading;
      
      public function Game()
      {
         super();
         Application.instance.setCurrentGame(this);
      }
      
      public function start(param1:Texture, param2:ResAssetManager) : void
      {
         var bgImage:Image;
         var progress:StartGameProgress;
         var background:Texture = param1;
         var assets:ResAssetManager = param2;
         Assets.sAsset = assets;
         bgImage = new Image(background);
         addChild(bgImage);
         progress = new StartGameProgress();
         progress.x = (1365 - progress.width) / 2;
         progress.y = 768 * 0.9;
         addChild(progress);
         assets.loadQueue((function():*
         {
            var onProgress:Function;
            return onProgress = function(param1:Number):void
            {
               var ratio:Number = param1;
               progress.progressBar.ratio = ratio;
               if(ratio == 1)
               {
                  Starling.juggler.delayCall(function():void
                  {
                     progress.removeFromParent(true);
                     bgImage.texture.dispose();
                     bgImage.removeFromParent(true);
                     initGame();
                     enterGame();
                  },0.15);
               }
            };
         })());
      }
      
      private function initGame() : void
      {
         initMainMenu();
         initScreenLayer();
         tipLayer = new Sprite();
         addChild(tipLayer);
         frontLayer = new Sprite();
         addChild(frontLayer);
         LoudSpeaker.instance;
         GameServer.instance.beInvite((function():*
         {
            var beInvite:Function;
            return beInvite = function(param1:Object):void
            {
               InviteFriendFeedManager.instance.inviteSignal.dispatch(param1);
            };
         })());
         Starling.juggler.delayCall(getActivityState,1);
         Timepiece.instance.addTimerFun(getActivityState,15000);
         addEventListener("enterFrame",onAnimationHandle);
      }
      
      public function addEventAfterReLogin() : void
      {
         addEventListener("enterFrame",onAnimationHandle);
         GameServer.instance.beInvite((function():*
         {
            var beInvite:Function;
            return beInvite = function(param1:Object):void
            {
               InviteFriendFeedManager.instance.inviteSignal.dispatch(param1);
            };
         })());
         ChatRoomDlg.getInstance().addEvent();
      }
      
      private function onAnimationHandle(param1:EnterFrameEvent) : void
      {
         WorldClock.clock.advanceTime(-1);
      }
      
      private function initMainMenu() : void
      {
         mainMenu = new MainMenu();
      }
      
      private function initScreenLayer() : void
      {
         this._theme = new AntwarsTheme(this.stage,false);
         this._navigator = new ScreenNavigator();
         this._navigator.addEventListener("change",onScreenChange);
         this._navigator.addEventListener("myClear",onScreenClear);
         this.addChild(this._navigator);
         this._navigator.addScreen("HALL",new ScreenNavigatorItem(Hall,{
            "showShop":"SHOP",
            "showBtRoom":"BTROOM",
            "showCopyGame":"COPYGAME",
            "showForge":"FORGE",
            "showRank":"RANK",
            "showEndlessTower":"ENDLESSTOWER",
            "showUnion":"SHOW_UINON"
         },{"optionsData":_guideOptionsData}));
         this._navigator.addScreen("RANK",new ScreenNavigatorItem(RankListScreen,{
            "complete":"HALL",
            "showRankFight":"ROBOTBATTLEFIELD"
         }));
         this._navigator.addScreen("SHOW_UINON",new ScreenNavigatorItem(UnionScreen,{"complete":"HALL"}));
         this._navigator.addScreen("ENDLESSTOWER",new ScreenNavigatorItem(EndlessTowerScreen,{
            "complete":"HALL",
            "showFight":"ENDLESSTOWERWORLD"
         }));
         this._navigator.addScreen("ENDLESSTOWERWORLD",new ScreenNavigatorItem(EndlessTowerWorld,{
            "hall":"HALL",
            "complete":"ENDLESSTOWER"
         }));
         this._navigator.addScreen("UNIONBOSSWORLD",new ScreenNavigatorItem(UnionBossFightWorld,{"complete":"SHOW_UINON"}));
         this._navigator.addScreen("SHOP",new ScreenNavigatorItem(ShopScreen,{
            "complete":"HALL",
            "showSkyCity":"SKYCITY"
         },{"optionsData":_guideOptionsData}));
         this._navigator.addScreen("BTROOM",new ScreenNavigatorItem(BtRoom,{
            "complete":"HALL",
            "showBattlefield":"BATTLEFIELD",
            "showRobotBt":"ROBOTBATTLEFIELD",
            "show2vs2RobotBt":"ROBOT_2VS2_BATTLEFIELD"
         },{"optionsData":_btRoomOptionsData}));
         this._navigator.addScreen("SHOW_BT_HALL",new ScreenNavigatorItem(BtHallScreen,{"complete":"HALL"}));
         this._navigator.addScreen("BATTLEFIELD",new ScreenNavigatorItem(Battlefield,{
            "complete":"BTROOM",
            "exit":"HALL"
         }));
         this._navigator.addScreen("ROBOTBATTLEFIELD",new ScreenNavigatorItem(RobotBattlefield,{
            "complete":"BTROOM",
            "exit":"HALL",
            "showRank":"RANK"
         }));
         this._navigator.addScreen("ROBOT_2VS2_BATTLEFIELD",new ScreenNavigatorItem(Robot2vs2Battlefield,{
            "complete":"BTROOM",
            "exit":"HALL"
         }));
         this._navigator.addScreen("COPYGAME",new ScreenNavigatorItem(CopyGame,{
            "complete":"HALL",
            "showSkyCity":"SKYCITY",
            "showSpiderCity":"SPIDERCITY",
            "showSpriteCity":"SPRITECITY"
         }));
         this._navigator.addScreen("SKYCITY",new ScreenNavigatorItem(SkyCity,{
            "complete":"COPYGAME",
            "gameStart":"COPYGAMEWORLD",
            "goShop":"SHOP",
            "goTeamList":"TEAMLIST"
         },{"optionsData":_copyModeOptionsData}));
         this._navigator.addScreen("SPIDERCITY",new ScreenNavigatorItem(SpiderCity,{
            "complete":"COPYGAME",
            "gameStart":"COPYGAMEWORLD",
            "zhunhuang":"ZHUNHUANGWORLD",
            "goTeamList":"TEAMLIST"
         },{"optionsData":_copyModeOptionsData}));
         this._navigator.addScreen("SPRITECITY",new ScreenNavigatorItem(SpriteCity,{
            "complete":"COPYGAME",
            "gameStart":"COPYGAMEWORLD",
            "zhunhuang":"LEIENTWORLD",
            "goTeamList":"TEAMLIST"
         },{"optionsData":_copyModeOptionsData}));
         this._navigator.addScreen("ZHUNHUANGWORLD",new ScreenNavigatorItem(ZhunhuangWorld,{
            "complete":"COPYGAME",
            "showSpiderCity":"SPIDERCITY"
         }));
         this._navigator.addScreen("LEIENTWORLD",new ScreenNavigatorItem(LeienWorld,{
            "complete":"COPYGAME",
            "showSpriteCity":"SPRITECITY"
         }));
         this._navigator.addScreen("COPYGAMEWORLD",new ScreenNavigatorItem(CopyGameWorld,{
            "complete":"SKYCITY",
            "showSpiderCity":"SPIDERCITY",
            "showSpriteCity":"SPRITECITY"
         }));
         this._navigator.addScreen("FRESHGAMEWORLD",new ScreenNavigatorItem(FreshGameWorld,{"complete":"HALL"}));
         this._navigator.addScreen("FORGE",new ScreenNavigatorItem(Forge,{"complete":"HALL"},{"optionsData":_guideOptionsData}));
         this._navigator.addScreen("TEAMLIST",new ScreenNavigatorItem(TeamList,{
            "complete":"SKYCITY",
            "showSpiderCity":"SPIDERCITY",
            "showSpriteCity":"SPRITECITY",
            "enterTeamRoom":"TEAMROOM"
         }));
         this._navigator.addScreen("TEAMROOM",new ScreenNavigatorItem(TeamRoom,{
            "complete":"TEAMLIST",
            "zhunhuang":"ZHUNHUANGWORLD"
         },{"optionsData":_copyModeOptionsData}));
      }
      
      public function enterGame() : void
      {
         if(this._navigator.activeScreenID)
         {
            this._navigator.clearScreen();
         }
         if(PlayerDataList.instance.selfData.isfreshpack == 0)
         {
            SoundManager.stopBgSound();
            this._navigator.showScreen("FRESHGAMEWORLD");
            PlayerDataList.instance.selfData.isFreshGuide = true;
         }
         else
         {
            this._navigator.showScreen("HALL");
         }
         Remoting.instance.getNSignInfo(onGetSignInfo);
         if(Constants.lanVersion == 1)
         {
            Remoting.instance.getIndulgeInfo(indulgeCheck);
         }
         else
         {
            PlayerDataList.instance.selfData.isAdult = true;
         }
      }
      
      private function onGetSignInfo(param1:Object) : void
      {
         trace("---------------------\n" + JSON.stringify(param1));
         if(param1.ret == 0)
         {
            PlayerDataList.instance.selfData.signData = param1.data as Array;
         }
         else
         {
            trace("error:" + param1.ret);
         }
      }
      
      public function indulgeCheck(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Date = null;
         if(param1.ret != 0)
         {
            return;
         }
         trace("获取验证信息:" + param1);
         var _loc4_:int = int(param1.info.status);
         if(_loc4_ == 0)
         {
            PlayerDataList.instance.selfData.isAdult = false;
         }
         else
         {
            _loc2_ = param1.info.birthday;
            _loc3_ = _loc2_.split("-");
            _loc5_ = int(_loc3_[0]);
            _loc6_ = new Date();
            PlayerDataList.instance.selfData.isAdult = _loc6_.getFullYear() - _loc5_ >= 18;
         }
      }
      
      public function getActivityState() : void
      {
         if(alertShow)
         {
            return;
         }
         Remoting.instance.mobileUpdate(Application.instance.version,function(param1:Object):void
         {
            var n:int;
            var data:Object = param1;
            if(data.ret == 0)
            {
               n = data.boyaaCoin - AccountData.instance.boyaaCoin;
               if(n > 0)
               {
                  MissionManager.instance.updateMissionData(112,n);
               }
               AccountData.instance.updateBoyaaCoin(data.boyaaCoin);
               hasAct = false;
               if(data.activity == 1)
               {
                  hasAct = true;
               }
               if(data.update == 1 && !noupdate)
               {
                  alertShow = true;
                  Application.instance.systemAlert(LangManager.t("updateTips"),data.updateMsg,[LangManager.t("yes"),LangManager.t("no")],[function():void
                  {
                     if(data.updateUrl.length > 0)
                     {
                        navigateToURL(new URLRequest(data.updateUrl));
                     }
                     noupdate = true;
                     alertShow = false;
                  },function():void
                  {
                     noupdate = true;
                     alertShow = false;
                  }]);
               }
            }
         });
      }
      
      private function onScreenChange(param1:Event) : void
      {
         var _loc2_:int = int(Game["IN_" + this._navigator.activeScreenID]);
         Application.instance.log("Game","IN_" + this._navigator.activeScreenID + ":" + _loc2_.toString());
         GameServer.instance.sendScreenPlace(_loc2_);
      }
      
      private function onScreenClear(param1:Event) : void
      {
         Application.instance.log("Game"," onScreenClear " + this._navigator.activeScreenID);
         if(this._navigator.activeScreenID == "HALL")
         {
            Assets.sAsset.removeTextureAtlas("smallmap");
            Assets.sAsset.removeTextureAtlas("btdlg");
            Assets.sAsset.removeTextureAtlas("btRoom");
            Assets.sAsset.removeTextureAtlas("BattlefieldUI");
            Assets.sAsset.removeTextureAtlas("emoticon");
            Assets.sAsset.removeTextureAtlas("rankList");
            Assets.sAsset.removeTextureAtlas("battlefieldSpritesheet");
            Assets.sAsset.removeTextureAtlas("emoticon");
            Assets.sAsset.removeTextureAtlas("copygame");
            Assets.sAsset.removeTextureAtlas("copygameui");
            Assets.sAsset.removeTextureAtlas("skycity");
            Assets.sAsset.removeTextureAtlas("spide");
            Assets.sAsset.removeTextureAtlas("spritebg");
            Assets.sAsset.removeTextureAtlas("endlessTower");
            if(Constants.debug)
            {
            }
         }
      }
      
      public function showLoading() : void
      {
         hiddenLoading();
         addChild(frontLayer);
         _loadingInScreen = new ChangeScreenLoading();
         frontLayer.addChild(_loadingInScreen);
         _loadingInScreen.x = Assets.leftTop.x;
         _loadingInScreen.y = Assets.leftTop.y;
         ChangeScreenLoading.isShow = true;
      }
      
      private function timeToHideLoading() : void
      {
         Timepiece.instance.removeFun(timeToHideLoading,2);
         hiddenLoading();
         Application.instance.currentGame.navigator.showScreen("HALL");
      }
      
      public function hiddenLoading() : void
      {
         Timepiece.instance.removeFun(timeToHideLoading,2);
         if(_loadingInScreen)
         {
            _loadingInScreen.remove();
         }
      }
      
      public function showLoadingRatio(param1:Number) : void
      {
         if(_loadingInScreen)
         {
            _loadingInScreen.setRatio(param1);
         }
      }
      
      public function get navigator() : ScreenNavigator
      {
         return _navigator;
      }
      
      public function get currentWorld() : IGameWorld
      {
         return _currentWorld;
      }
      
      public function set currentWorld(param1:IGameWorld) : void
      {
         _currentWorld = param1;
      }
      
      public function logout() : void
      {
         removeEventListener("enterFrame",onAnimationHandle);
         Application.instance.currentMain.logout();
      }
   }
}

