package com.boyaa.antwars.view.screen.copygame
{
   import com.boyaa.antwars.data.AllRoomData;
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.CopyDetailData;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.data.model.ServerData;
   import com.boyaa.antwars.data.model.mission.SubMissionData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.IMainMenu;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.battlefield.BtSkillDlg;
   import com.boyaa.antwars.view.screen.battlefield.element.EnergyBar;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideEventManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import feathers.controls.Screen;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.events.Event;
   
   public class CityWorld extends Screen implements IMainMenu, IGuideProcess
   {
      
      protected var _propSkillBtn:Button;
      
      protected var _levelPosArr:Array;
      
      protected var _lockPosArr:Array;
      
      protected var _decreaseEnergy:int = 3;
      
      protected var _currentCopyArr:Array;
      
      protected var _optionsData:Object;
      
      protected var energyBar:EnergyBar;
      
      protected var levelArr:Array;
      
      protected var lockArr:Vector.<Image>;
      
      protected var infoArr:Vector.<String> = new Vector.<String>();
      
      protected var layoutUitl:LayoutUitl;
      
      protected var currentCpWorld:int = 1;
      
      public const SKYCITY:int = 1;
      
      public const SPIDERCITY:int = 2;
      
      public const SPRITICITY:int = 3;
      
      public const NORMAL:String = "normal";
      
      public const HERO:String = "hero";
      
      protected var _screenArr:Array = [];
      
      public function CityWorld()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         loadAssets();
      }
      
      protected function loadAssets() : void
      {
      }
      
      protected function init() : void
      {
         var _loc2_:int = 0;
         var _loc1_:DisplayObject = null;
         Application.instance.currentGame.mainMenu.ReturnBtn.visible = true;
         levelArr = [];
         lockArr = new Vector.<Image>();
         _levelPosArr = [];
         _lockPosArr = [];
         _loc2_ = 1;
         while(_loc2_ <= 10)
         {
            _loc1_ = getChildByName("btnS_level" + _loc2_);
            _loc1_.visible = false;
            _levelPosArr.push(_loc1_);
            _loc2_++;
         }
         getChildByName("btnS_PropSkill").visible = false;
         _propSkillBtn = new Button(Assets.sAsset.getTexture("fb65"),"",Assets.sAsset.getTexture("fb66"));
         _propSkillBtn.addEventListener("triggered",onPropSkill);
         _propSkillBtn.x = Assets.rightTop.x - _propSkillBtn.width;
         _propSkillBtn.y = Assets.rightTop.y + _propSkillBtn.height + 50;
         this.addChild(_propSkillBtn);
         energyBar = new EnergyBar();
         if(_optionsData.mode == "hero")
         {
            energyBar.allStarNum = CopyList.instance.countGradeByCpId(currentCpWorld,2);
         }
         else
         {
            energyBar.allStarNum = CopyList.instance.countGradeByCpId(currentCpWorld);
         }
         addChild(energyBar);
         energyBar.x = Assets.rightTop.x - energyBar.width;
         energyBar.y = Assets.rightTop.y;
         createLevel(_optionsData.mode);
         setStarData();
         Application.instance.currentGame.mainMenu.show(this);
         guideProcess();
      }
      
      protected function createLevel(param1:String = "normal") : void
      {
         var finger:Image;
         var moveDistance:Number;
         var mode:String = param1;
         if(Constants.debug)
         {
            unLock(10);
         }
         else
         {
            unLock(1);
         }
         if(CopyGameTips.isShowFingerFocus == 1 && _optionsData.mode == "hero")
         {
            finger = new Image(Assets.sAsset.getTexture("focusFinger"));
            finger.scaleX = finger.scaleY = 0.5;
            finger.x = levelArr[0].x + (levelArr[0].width - finger.width >> 1);
            finger.y = levelArr[0].y - 20;
            addChild(finger);
            moveDistance = 0;
            addEventListener("enterFrame",(function():*
            {
               var moveFinger:Function;
               return moveFinger = function():void
               {
                  finger.y += Math.sin(moveDistance);
                  moveDistance += 0.1;
                  switch(Application.instance.currentGame.navigator.activeScreenID)
                  {
                     case "SKYCITY":
                     case "SPIDERCITY":
                        break;
                     default:
                        CopyGameTips.isShowFingerFocus = 0;
                        removeEventListener("enterFrame",moveFinger);
                  }
               };
            })());
         }
      }
      
      public function updateEnergyBar(param1:int) : void
      {
         EnergyBar.updatePlayerEnergy();
         energyBar.updateEnergy(PlayerDataList.instance.selfData.energy);
      }
      
      protected function unLock(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 > 10)
         {
            param1 = 10;
         }
         _loc2_ = 0;
         while(_loc2_ < param1)
         {
            CityWorldLevel(levelArr[_loc2_]).showLock(false);
            _loc2_++;
         }
      }
      
      protected function setStarData() : void
      {
         var _loc2_:Array = null;
         var _loc1_:CopyDetailData = null;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < levelArr.length)
         {
            _loc2_ = CityWorldLevel(levelArr[_loc3_]).text.split("-");
            _loc1_ = CopyList.instance.getCopyData(currentCpWorld,_loc2_[0],_loc2_[1]);
            if(_loc1_)
            {
               if(_loc1_.owner_grade == -1)
               {
                  break;
               }
               CityWorldLevel(levelArr[_loc3_]).updateStarNum(_loc1_.owner_grade);
            }
            _loc3_++;
         }
         unLock(_loc3_ + 1);
      }
      
      protected function onEnterGameWorld(param1:Event) : void
      {
         var _loc4_:PlayerData = PlayerDataList.instance.selfData;
         var _loc3_:GoodsData = _loc4_.getWeapon();
         if(!_loc3_ || _loc3_.place != 1)
         {
            TextTip.instance.show(LangManager.t("noWeapon"));
            return;
         }
         var _loc2_:CityWorldLevel = param1.currentTarget as CityWorldLevel;
         _currentCopyArr = _loc2_.text.split("-");
         CopyList.instance.currentCopyData = CopyList.instance.getCopyData(currentCpWorld,_currentCopyArr[0],_currentCopyArr[1]);
         if(_currentCopyArr[1] == 10)
         {
            bossFight();
            return;
         }
         GameServer.instance.sentConsumeEnergy();
         GameServer.instance.getConsumeEnergy(consumEnergy);
      }
      
      protected function bossFight() : void
      {
         GameServer.instance.getServerIDByType(3,function(param1:Object):void
         {
            var _loc2_:ServerData = AllRoomData.instance.getDataByID(param1.svid);
            CopyServer.instance.init(_loc2_.ip,_loc2_.port);
            trace("当前连接的服务器：",_loc2_.ip,_loc2_.port);
            CopyServer.instance.connect();
            CopyServer.instance.serverType = 0;
         });
         SystemTip.instance.showSystemAlert(LangManager.t("copyBoss"),function():void
         {
            if(CopyServer.instance.isConnect)
            {
               dispatchEventWith("goTeamList");
            }
            else
            {
               TextTip.instance.show(LangManager.t("copyGameConnetFaile"));
            }
         },function():void
         {
            Application.instance.currentGame.navigator.showScreen(_screenArr[currentCpWorld]);
            CopyServer.instance.close();
         });
      }
      
      protected function consumEnergy(param1:Object) : void
      {
         var _loc2_:int = int(param1.data.userId);
         var _loc4_:int = int(param1.data.type);
         var _loc3_:int = int(param1.data.energy);
         if(_loc4_ == -1)
         {
            LessPowerDlg.show(Application.instance.currentGame);
            return;
         }
         energyBar.decreaseEnergy(_decreaseEnergy);
         PlayerDataList.instance.selfData.energy -= _decreaseEnergy;
         this.dispatchEventWith("gameStart");
      }
      
      protected function onPropSkill(param1:Event) : void
      {
         var _loc2_:BtSkillDlg = new BtSkillDlg();
         Starling.current.stage.addChild(_loc2_);
         _loc2_.x = 1365 - _loc2_.width >> 1;
         _loc2_.y = 768 - _loc2_.height >> 1;
      }
      
      public function exit() : void
      {
         this.dispatchEventWith("complete");
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
      
      public function get levelPosArr() : Array
      {
         return _levelPosArr;
      }
      
      public function get lockPosArr() : Array
      {
         return _lockPosArr;
      }
      
      protected function setPos(param1:DisplayObject, param2:DisplayObject) : void
      {
         param1.x = param2.x + 5;
         param1.y = param2.y + 15;
         param1.width = param2.width;
         param1.height = param2.height;
      }
      
      override public function dispose() : void
      {
         CopyGameTips.isShowFingerFocus = 0;
         super.dispose();
      }
      
      public function guideProcess(param1:Object = null) : void
      {
         var _loc4_:SubMissionData = null;
         var _loc2_:int = 0;
         GuideTipManager.instance.currentProcess = this;
         var _loc3_:String = MissionGuideValue.instance.getMissionFlag();
         var _loc5_:* = _loc3_;
         if("copyMission" === _loc5_)
         {
            _loc4_ = MissionGuideValue.instance.getUnCompleteSubMissions();
            _loc2_ = _loc4_.pframe % 10;
            if(_loc2_ == 0)
            {
               _loc2_ = 1;
            }
            GuideEventManager.instance.dispactherEvent("newUI",[[levelArr[_loc2_ - 1],40]]);
         }
      }
   }
}

