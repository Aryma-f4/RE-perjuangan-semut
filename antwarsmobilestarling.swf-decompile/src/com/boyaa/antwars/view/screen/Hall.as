package com.boyaa.antwars.view.screen
{
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.activity.RankLevelActivity;
   import com.boyaa.antwars.view.screen.Animation.WinterSnow;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.WeaponChangeManager;
   import com.boyaa.antwars.view.screen.bindAccount.BindAccountDlg;
   import com.boyaa.antwars.view.screen.chatRoom.FriendsList;
   import com.boyaa.antwars.view.screen.fresh.FreshGifts;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import com.boyaa.antwars.view.screen.fresh.LevelUp;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideEventManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import com.boyaa.antwars.view.screen.hall.PlayerInfoBox;
   import com.boyaa.antwars.view.screen.mail.MailTipsControl;
   import com.boyaa.antwars.view.screen.wedding.WeddingDlg;
   import com.boyaa.antwars.view.screen.wedding.WeddingManager;
   import feathers.controls.Screen;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class Hall extends Screen implements IMainMenu, IGuideProcess
   {
      
      public static const SHOW_SHOP:String = "showShop";
      
      public static const SHOW_BTDLG:String = "showBtDlg";
      
      public static const SHOW_BTROOM:String = "showBtRoom";
      
      public static const SHOW_COPY_GAME:String = "showCopyGame";
      
      public static const SHOW_FORGE:String = "showForge";
      
      public static const SHOW_RANK:String = "showRank";
      
      public static const SHOW_ENDLESSTOWER:String = "showEndlessTower";
      
      public static const SHOW_WEDDING:String = "showWedding";
      
      public static const SHOW_WAIT:String = "SHOW_WAIT";
      
      public static var inGuide:Boolean = false;
      
      public static var SHOW_UINON:String = "showUnion";
      
      public static var isFirstRun:Boolean = true;
      
      private static const WINTER:String = "hallWinter";
      
      private static const SUMMER:String = "hall";
      
      public static const buttonEvent:Array = [{
         "name":"sc",
         "event":"showShop"
      },{
         "name":"yxdt",
         "event":"showBtDlg"
      },{
         "name":"mwsl",
         "event":"showCopyGame"
      },{
         "name":"wdj",
         "event":"SHOW_WAIT"
      },{
         "name":"wqgf",
         "event":"showForge"
      },{
         "name":"pmc",
         "event":"SHOW_WAIT"
      },{
         "name":"mrt",
         "event":"showRank"
      },{
         "name":"wjt",
         "event":"showEndlessTower"
      },{
         "name":"gh",
         "event":SHOW_UINON
      },{
         "name":"jh",
         "event":"showWedding"
      }];
      
      protected var _optionsData:Object;
      
      private var bg:Image;
      
      private var yun:Image;
      
      private var bg1:Image;
      
      private var _leftSprite:Sprite;
      
      private var _playerInfo:PlayerInfoBox;
      
      private var _scrollMenu:ScrollMenu;
      
      private var screenItemsPos:Dictionary;
      
      private var itemsDictionary:Dictionary = new Dictionary();
      
      private var btnRank:Button;
      
      private var _snow:WinterSnow = null;
      
      private var HALL_STATE:String = "hall";
      
      private var _hallAni:HallAni;
      
      private var bindDlg:BindAccountDlg;
      
      public function Hall()
      {
         super();
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
      
      override protected function initialize() : void
      {
         var itemArr:Array;
         var openBuildingArr:Array;
         var itemName:String;
         var i:int;
         var level:LevelUp;
         var gameNotice:GameNotice;
         SoundManager.playBgSound("bgGame");
         Application.instance.currentGame.mainMenu.isEnable(true);
         Application.instance.currentGame.mainMenu.ReturnBtn.visible = false;
         bg = new Image(Assets.sAsset.getTexture("hallbg2"));
         bg.x = (1365 - bg.width) / 2;
         bg.blendMode = "none";
         this.addChild(bg);
         yun = new Image(Assets.sAsset.getTexture("yun1"));
         addChild(yun);
         yun.x = -yun.width;
         yun.y = 768 + 50;
         Starling.juggler.tween(yun,50,{
            "x":1365,
            "y":-100,
            "repeatCount":0
         });
         bg1 = new Image(Assets.sAsset.getTexture("hallbg1"));
         bg1.x = (1365 - bg1.width) / 2;
         this.addChild(bg1);
         itemArr = ["btnRecharge","headImg","hdzx","hdzxani","boyaaCoinIcon","gameGoldIcon","boyaaCoin","gameGold","level_txt","exp_bg","exp_bar","exp_value","btn_sign","btn_rank","signani","btn_bind","levelBg","headBg","fightAniPos","shopLightPos","copySmokePos","copyEyePos","forgeSmokePos","vipButton"];
         openBuildingArr = ["sc","yxdt","mwsl","wqgf","mrt","wjt","gh","jh"];
         screenItemsPos = Assets.getScreenPos(HALL_STATE);
         for(itemName in screenItemsPos)
         {
            if(openBuildingArr.indexOf(itemName) != -1)
            {
               itemsDictionary[itemName] = new Button(Assets.sAsset.getTexture(itemName),"",Assets.sAsset.getTexture(itemName + "1"));
            }
            else
            {
               if(itemArr.indexOf(itemName) != -1)
               {
                  continue;
               }
               itemsDictionary[itemName] = new Button(Assets.sAsset.getTexture(itemName));
            }
            itemsDictionary[itemName].x = screenItemsPos[itemName].x;
            itemsDictionary[itemName].y = screenItemsPos[itemName].y;
            itemsDictionary[itemName].width = screenItemsPos[itemName].width;
            itemsDictionary[itemName].height = screenItemsPos[itemName].height;
            this.addChild(itemsDictionary[itemName]);
            itemsDictionary[itemName].addEventListener("triggered",buildingButton_triggeredHandler);
         }
         i = 0;
         while(i < openBuildingArr.length)
         {
            this.addChild(itemsDictionary[openBuildingArr[i]]);
            i = i + 1;
         }
         this.addEventListener("showBtDlg",onShowBTDlg);
         this.addEventListener("showWedding",onShowWedding);
         Application.instance.currentGame.mainMenu.show(this);
         initLeftSprite();
         if(PlayerDataList.instance.selfData.isFreshGuide)
         {
            level = new LevelUp(1);
            Starling.current.stage.addChild(level);
            level.x = 1365 - level.width >> 1;
            level.y = 768 - level.height >> 1;
            Starling.juggler.delayCall(showGift,3);
            PlayerDataList.instance.selfData.isFreshGuide = false;
         }
         else
         {
            if(isFirstRun)
            {
               gameNotice = new GameNotice();
               gameNotice.show(true);
               isFirstRun = false;
               if(FriendsList.instance.needLoad)
               {
                  Remoting.instance.getFirends(1,receiveData);
               }
            }
            _optionsData.pos = "mission";
            posGuide();
         }
         _hallAni = new HallAni(this);
         Remoting.instance.backBTProp([],function(param1:Object):void
         {
            if(param1.ret == 0)
            {
               GoodsList.instance.payPorpIdArr = param1.props.split("|");
            }
         });
         if(HALL_STATE == "hallWinter")
         {
            if(_snow != null)
            {
               _snow.remove();
            }
            _snow = new WinterSnow();
            _snow.show(Application.instance.currentGame.stage);
         }
         MailTipsControl.instance.showTip();
         GuideTipManager.instance.showGuideInPlace(Application.instance.currentGame.mainMenu.MissionBtn,itemsDictionary["yxdt"]);
         GuideTipManager.instance.currentProcess = this;
         WeaponChangeManager.instance.initWeapon();
         BattleServer.instance.close();
      }
      
      public function receiveData(param1:Object) : void
      {
         Application.instance.log("好友列表",JSON.stringify(param1));
         FriendsList.instance.addData(param1 as Array);
         FriendsList.instance.needLoad = false;
         WeddingManager.instance.showDeleyMarryAsk();
      }
      
      public function posGuide() : void
      {
         if(PlayerDataList.instance.selfData.level >= 5)
         {
            if(Hall.inGuide == false)
            {
               Guide.instance.stop();
               return;
            }
            Hall.inGuide = false;
         }
         switch(_optionsData.pos)
         {
            case "mission":
               Guide.instance.guide(Application.instance.currentGame.mainMenu.MissionBtn,LangManager.t("guide4"),true);
               break;
            case "shop":
               Guide.instance.guide(itemsDictionary["sc"],LangManager.t("guide5"));
               break;
            case "forge":
               Guide.instance.guide(itemsDictionary["wqgf"],LangManager.t("guide6"));
               break;
            case "backpack":
               Guide.instance.guide(Application.instance.currentGame.mainMenu.PackageBtn,LangManager.t("guide7"),true);
               break;
            case "btRoom":
               Guide.instance.guide(itemsDictionary["yxdt"],LangManager.t("guide8"));
               break;
            case "copyGame":
               Guide.instance.guide(itemsDictionary["mwsl"],LangManager.t("guide9"));
               break;
            default:
               Guide.instance.guide(Application.instance.currentGame.mainMenu.MissionBtn,LangManager.t("guide4"),true);
         }
         if(Guide.instance.x != 0)
         {
            Guide.instance.x = 0;
         }
         if(Application.instance.currentGame.mainMenu.MissionBtn.x == 395.85)
         {
            Guide.instance.x = 10;
            Guide.instance.textSprite.x += 150;
         }
      }
      
      private function showGift() : void
      {
         var _loc1_:FreshGifts = new FreshGifts(1);
         Starling.current.stage.addChild(_loc1_);
         _loc1_.x = 1365 - _loc1_.width >> 1;
         _loc1_.y = 768 - _loc1_.height >> 1;
         Starling.juggler.delayCall(showTip,3);
      }
      
      private function showTip() : void
      {
         TextTip.instance.show(LangManager.t("guide3") + "X1");
         Guide.instance.visible = true;
         Guide.instance.guide(Application.instance.currentGame.mainMenu.MissionBtn,LangManager.t("guide0"),true);
      }
      
      private function onBindAccountBtn(param1:Event) : void
      {
         Guide.instance.stop();
         if(bindDlg && bindDlg.parent)
         {
            return;
         }
         bindDlg = new BindAccountDlg();
         Starling.current.stage.addChild(bindDlg);
         bindDlg.x = 1365 - bindDlg.width >> 1;
         bindDlg.y = 768 - bindDlg.height >> 1;
      }
      
      private function onBtnRank(param1:Event) : void
      {
         new RankLevelActivity();
      }
      
      override protected function draw() : void
      {
      }
      
      private function onShowHome(param1:Event) : void
      {
      }
      
      private function onShowBTDlg(param1:Event) : void
      {
         Application.instance.currentGame.navigator.showScreen("SHOW_BT_HALL");
      }
      
      private function onShowWedding(param1:Event) : void
      {
         var _loc2_:WeddingDlg = new WeddingDlg();
         addChild(_loc2_);
      }
      
      private function buildingButton_triggeredHandler(param1:Event) : void
      {
         for(var _loc2_ in itemsDictionary)
         {
            if(itemsDictionary[_loc2_] == param1.currentTarget)
            {
               for each(var _loc3_ in buttonEvent)
               {
                  if(_loc3_.name == _loc2_)
                  {
                     if(_loc3_.event == "SHOW_WAIT")
                     {
                        TextTip.instance.show(LangManager.t("unpoen"));
                     }
                     else
                     {
                        this.dispatchEventWith(_loc3_.event);
                        Guide.instance.stop();
                     }
                  }
               }
            }
         }
      }
      
      private function initLeftSprite() : void
      {
         _leftSprite = new Sprite();
         _playerInfo = new PlayerInfoBox();
         _scrollMenu = new ScrollMenu();
         _leftSprite.addChild(_playerInfo);
         _leftSprite.addChild(_scrollMenu);
         _playerInfo.x = Assets.leftTop.x;
         _playerInfo.y = Assets.leftTop.y;
         _scrollMenu.x = _playerInfo.x;
         _scrollMenu.y = _playerInfo.y + _playerInfo.height + 10;
         addChild(_leftSprite);
      }
      
      public function exit() : void
      {
         Application.instance.currentGame.logout();
      }
      
      override public function dispose() : void
      {
         _snow && _snow.remove();
         _hallAni && _hallAni.dispose();
         Starling.juggler.removeTweens(yun);
         super.dispose();
      }
      
      public function guideProcess(param1:Object = null) : void
      {
         var _loc2_:String = MissionGuideValue.instance.getMissionFlag();
         switch(_loc2_)
         {
            case "copyMission":
               GuideEventManager.instance.dispactherEvent("newUI",[[itemsDictionary["mwsl"],10]]);
               break;
            case "endlessMission":
               GuideEventManager.instance.dispactherEvent("newUI",[[itemsDictionary["wjt"],10]]);
               break;
            case "fight1v1Mission":
            case "fight2v2Mission":
               GuideEventManager.instance.dispactherEvent("newUI",[[itemsDictionary["yxdt"],10]]);
               break;
            case "forgeMission":
               GuideEventManager.instance.dispactherEvent("newUI",[[itemsDictionary["wqgf"],10]]);
               break;
            case "marryMission":
               GuideEventManager.instance.dispactherEvent("newUI",[[itemsDictionary["jh"],10]]);
               break;
            case "payMission":
               GuideEventManager.instance.dispactherEvent("newUI",[[itemsDictionary["gh"],10]]);
               break;
            case "unionMission":
               GuideEventManager.instance.dispactherEvent("newUI",[[itemsDictionary["gh"],10]]);
               break;
            case "useFightSkill":
               GuideEventManager.instance.dispactherEvent("newUI",[[itemsDictionary["yxdt"],10]]);
         }
      }
   }
}

