package com.boyaa.antwars.view.screen.copygame
{
   import com.boyaa.antwars.data.AllRoomData;
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.CopyDetailData;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.data.model.ServerData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.game.GameWorld;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.battlefield.element.EnergyBar;
   import com.boyaa.antwars.view.screen.copygame.team.TeamRoom;
   import feathers.controls.ScreenNavigator;
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class CopyGameTips extends Sprite
   {
      
      public static const WIN:int = 0;
      
      public static const LOST:int = 1;
      
      public static const NORMALDONE:int = 2;
      
      public static const HERODONE:int = 3;
      
      public static const LESSPOWER:int = 4;
      
      public static const RELIVEMODE:int = 5;
      
      public static var missionObject:Object;
      
      public static var isShowFingerFocus:int = 0;
      
      private static var missionArr:Array = [1,1];
      
      private var _atlas:ResAssetManager;
      
      private var bg:Scale9Image;
      
      private var txt:TextField;
      
      private var cancelButton:Button;
      
      private var enterButton:Button;
      
      private var forceButton:Button;
      
      private var buyButton:Button;
      
      private var againButton:Button;
      
      private var tryHeroButton:Button;
      
      private var state:int = 0;
      
      private var navitor:ScreenNavigator = Application.instance.currentGame.navigator;
      
      private var _buttonPos:Vector.<Rectangle> = new Vector.<Rectangle>();
      
      private var _gameWorld:GameWorld;
      
      private var _buttonArr:Array = [];
      
      private var currentState:int;
      
      public function CopyGameTips()
      {
         super();
         this.addEventListener("addedToStage",onAdded);
      }
      
      public static function nextMission() : void
      {
         var detail:CopyDetailData;
         GameServer.instance.sentConsumeEnergy();
         detail = CopyList.instance.currentCopyData;
         CopyList.instance.currentCopyData = CopyList.instance.getCopyData(detail.cpid,missionArr[0],missionArr[1]);
         Application.instance.currentGame.navigator.clearScreen();
         if(missionArr[1] == 10 && detail.cpid != 1)
         {
            GameServer.instance.getServerIDByType(3,function(param1:Object):void
            {
               var _loc2_:ServerData = AllRoomData.instance.getDataByID(param1.svid);
               CopyServer.instance.init(_loc2_.ip,_loc2_.port);
               CopyServer.instance.connect();
            });
            SystemTip.instance.showSystemAlert(LangManager.t("copyBoss"),function():void
            {
               Application.instance.currentGame.navigator.showScreen("TEAMLIST");
            },function():void
            {
               var _loc1_:String = null;
               CopyServer.instance.close();
               switch(detail.cpid - 1)
               {
                  case 0:
                     _loc1_ = "SKYCITY";
                     break;
                  case 1:
                     _loc1_ = "SPIDERCITY";
                     break;
                  case 2:
                     _loc1_ = "SPRITECITY";
                     break;
                  default:
                     _loc1_ = "HALL";
               }
               Application.instance.currentGame.navigator.showScreen(_loc1_);
            });
         }
         else
         {
            Application.instance.currentGame.navigator.showScreen("COPYGAMEWORLD");
         }
      }
      
      public function setGameWorld(param1:GameWorld) : void
      {
         _gameWorld = param1;
      }
      
      private function setButtonPos() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:int = 0;
         _loc2_ = 1;
         while(_loc2_ <= 4)
         {
            _loc1_ = Assets.sAsset.getPosition("copyGameTip","button" + _loc2_);
            _buttonPos.push(_loc1_);
            _loc2_++;
         }
      }
      
      private function onAdded(param1:Event) : void
      {
         removeEventListener("addedToStage",onAdded);
         _atlas = Assets.sAsset;
         bg = new Scale9Image(new Scale9Textures(_atlas.getTexture("zd9"),new Rectangle(26,26,37,37)));
         var _loc2_:Rectangle = Assets.sAsset.getPosition("copyGameTip","tipBg");
         bg.width = 944;
         bg.height = _loc2_.height;
         setButtonPos();
      }
      
      public function showTip(param1:int = 0) : void
      {
         addChild(bg);
         state = param1;
         initButton();
         initButtonAndText();
         trace("下一关卡：" + missionArr[0] + "-" + missionArr[1]);
      }
      
      private function onEnterButton(param1:Event) : void
      {
         EnergyBar.updatePlayerEnergy();
         Starling.juggler.delayCall(isEnoughPowerEnterWorld,0.1);
      }
      
      private function isEnoughPowerEnterWorld() : void
      {
         var _loc1_:PlayerData = PlayerDataList.instance.selfData;
         if(_loc1_.energy < 3)
         {
            LessPowerDlg.show(Application.instance.currentGame);
         }
         else
         {
            nextMission();
         }
      }
      
      private function onCancelButton(param1:Event) : void
      {
         if(Application.instance.getAppVersionNamber() == "1.14.0")
         {
            leaveCopyGameWorld();
         }
         else
         {
            ReliveControl.instance.showReliveDlg();
         }
      }
      
      private function initButton() : void
      {
         var _loc1_:int = 0;
         cancelButton = new Button(_atlas.getTexture("zd1"),"",_atlas.getTexture("zd2"));
         enterButton = new Button(_atlas.getTexture("zd3"),"",_atlas.getTexture("zd4"));
         buyButton = new Button(_atlas.getTexture("copyGameTip_buyBtn1"),"",_atlas.getTexture("copyGameTip_buyBtn2"));
         forceButton = new Button(_atlas.getTexture("zd5"),"",_atlas.getTexture("zd6"));
         againButton = new Button(_atlas.getTexture("zd10"),"",_atlas.getTexture("zd11"));
         tryHeroButton = new Button(_atlas.getTexture("zd7"),"",_atlas.getTexture("zd8"));
         _buttonArr = [tryHeroButton,enterButton,againButton,buyButton,forceButton,cancelButton];
         _loc1_ = 0;
         while(_loc1_ < _buttonArr.length)
         {
            Button(_buttonArr[_loc1_]).visible = false;
            _loc1_++;
         }
      }
      
      private function initButtonAndText() : void
      {
         var _loc3_:String = null;
         var _loc6_:int = 0;
         var _loc2_:Rectangle = Assets.sAsset.getPosition("copyGameTip","txt");
         missionArr[0] = CopyList.instance.currentCopyData.difficulty;
         missionArr[1] = CopyList.instance.currentCopyData.stage;
         if(parseInt(missionArr[0]) == 1)
         {
            _loc3_ = LangManager.t("copyGameNormal") + " " + missionArr[0] + "-" + missionArr[1];
         }
         else
         {
            _loc3_ = LangManager.t("copyGameHero") + " " + missionArr[0] + "-" + missionArr[1];
         }
         currentState = parseInt(missionArr[1]);
         missionArr[1] = parseInt(missionArr[1]) + 1;
         var _loc1_:String = missionArr[0] + "-" + missionArr[1];
         var _loc4_:String = getCurrentCopyName();
         if(parseInt(missionArr[1]) > 9 && parseInt(missionArr[0]) == 1 && state == 0 && CopyList.instance.currentCopyData.cpid == 1)
         {
            state = 2;
         }
         if(parseInt(missionArr[1]) > 10 && state == 0)
         {
            state = 3;
         }
         switch(state)
         {
            case 0:
               enterButton.visible = true;
               txt = new TextField(925,40,LangManager.getLang.getreplaceLang("copyGameTip1",_loc3_,_loc1_,_loc4_));
               if(_loc1_ == "2-11")
               {
                  txt = new TextField(925,40,LangManager.getLang.getreplaceLang("copyGameTip4",_loc4_));
                  enterButton.visible = false;
               }
               break;
            case 1:
               if(parseInt(missionArr[1]) > 10)
               {
                  againButton.visible = false;
               }
               else
               {
                  againButton.visible = true;
               }
               forceButton.visible = buyButton.visible = true;
               txt = new TextField(925,40,LangManager.getLang.getreplaceLang("copyGameTip2",_loc3_,_loc4_));
               break;
            case 2:
               tryHeroButton.visible = true;
               txt = new TextField(925,50,LangManager.getLang.getreplaceLang("copyGameTip3"));
               break;
            case 3:
               txt = new TextField(925,40,LangManager.getLang.getreplaceLang("copyGameTip4",_loc4_));
               break;
            case 5:
               if(parseInt(missionArr[1]) > 10)
               {
                  againButton.visible = false;
               }
               else
               {
                  againButton.visible = true;
               }
               if(Application.instance.getAppVersionNamber() != "1.14.0")
               {
                  cancelButton.visible = true;
               }
               forceButton.visible = buyButton.visible = true;
               txt = new TextField(925,40,LangManager.getLang.getreplaceLang("copyGameTip2",_loc3_,_loc4_));
         }
         txt.fontSize = 25;
         txt.autoScale = true;
         txt.bold = true;
         txt.x = _loc2_.x;
         txt.y = _loc2_.y;
         addChild(txt);
         var _loc5_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < _buttonArr.length)
         {
            if(Button(_buttonArr[_loc6_]).visible)
            {
               _buttonArr[_loc6_].x = _buttonPos[_loc5_].x;
               _buttonArr[_loc6_].y = _buttonPos[_loc5_].y;
               _buttonArr[_loc6_].width = _buttonPos[_loc5_].width;
               _buttonArr[_loc6_].height = _buttonPos[_loc5_].height;
               addChild(_buttonArr[_loc6_]);
               _loc5_++;
            }
            _loc6_++;
         }
         cancelButton.addEventListener("triggered",onCancelButton);
         enterButton.addEventListener("triggered",onEnterButton);
         tryHeroButton.addEventListener("triggered",onTryHeroButton);
         forceButton.addEventListener("triggered",onForceButton);
         againButton.addEventListener("triggered",onAgainButton);
         buyButton.addEventListener("triggered",onBuyButton);
      }
      
      private function onTryHeroButton(param1:Event) : void
      {
         isShowFingerFocus = 1;
         Application.instance.currentGame._copyModeOptionsData.mode = "hero";
         navitor.clearScreen();
         switch(CopyList.instance.currentCopyData.cpid - 1)
         {
            case 0:
               navitor.showScreen("SKYCITY");
               break;
            case 1:
               navitor.showScreen("SPIDERCITY");
               break;
            case 2:
               navitor.showScreen("SPRITECITY");
         }
      }
      
      private function onForceButton(param1:Event) : void
      {
         navitor.showScreen("FORGE");
         if(CopyServer.instance.isConnect)
         {
            CopyServer.instance.close();
         }
      }
      
      private function onAgainButton(param1:Event) : void
      {
         missionArr[1] = currentState;
         EnergyBar.updatePlayerEnergy();
         Starling.juggler.delayCall(isEnoughPowerEnterWorld,0.1);
      }
      
      private function onBuyButton(param1:Event) : void
      {
         if(CopyServer.instance.isConnect)
         {
            CopyServer.instance.close();
         }
         navitor.showScreen("SHOP");
      }
      
      public function setTipPosition(param1:String = "bottom") : void
      {
         var _loc2_:Object = {
            "top":[Assets.leftTop.x + 40,Assets.leftTop.y + 50],
            "middle":[Assets.leftTop.x + 40,Assets.leftTop.y + 330],
            "bottom":[210.5,Assets.leftTop.y + 610]
         };
         this.x = _loc2_[param1][0];
         this.y = _loc2_[param1][1];
      }
      
      override public function dispose() : void
      {
         trace("CopyGameTips dispose!");
         cancelButton.removeEventListener("triggered",onCancelButton);
         enterButton.removeEventListener("triggered",onEnterButton);
         if(buyButton)
         {
            buyButton.removeEventListener("triggered",onBuyButton);
         }
         super.dispose();
      }
      
      private function getCurrentCopyName() : String
      {
         var _loc2_:int = CopyList.instance.currentCopyData.cpid;
         var _loc1_:Array = ["skycity","spidercity","spritecity"];
         return LangManager.t(_loc1_[_loc2_ - 1]);
      }
      
      private function leaveCopyGameWorld() : void
      {
         var _loc1_:CopyDetailData = CopyList.instance.currentCopyData;
         var _loc2_:Array = ["COPYGAME","SKYCITY","SPIDERCITY","SPRITECITY"];
         if(CopyServer.instance.isConnect)
         {
            TeamRoom.fromCopyGame();
            return;
         }
         navitor.showScreen(_loc2_[_loc1_.cpid]);
      }
   }
}

