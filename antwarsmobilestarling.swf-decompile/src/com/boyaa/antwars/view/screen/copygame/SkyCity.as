package com.boyaa.antwars.view.screen.copygame
{
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.CopyDetailData;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.data.model.mission.SubMissionData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.IMainMenu;
   import com.boyaa.antwars.view.screen.battlefield.BtSkillDlg;
   import com.boyaa.antwars.view.screen.battlefield.element.EnergyBar;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideEventManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import feathers.controls.Screen;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.utils.formatString;
   
   public class SkyCity extends Screen implements IMainMenu, IGuideProcess
   {
      
      protected var _optionsData:Object;
      
      private var bg:Image;
      
      private var starArr:Vector.<Level1>;
      
      private var lockImgArr:Vector.<Image>;
      
      private var energyBar:EnergyBar;
      
      private var isEnterTeamList:Boolean = true;
      
      public var inGuide:Boolean = false;
      
      private var decreaseEnergy:int = 15;
      
      private var _flag:int = 1;
      
      private var levelContainer:Sprite;
      
      public function SkyCity()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         var rmger:ResManager;
         if(Assets.sAsset.getTextureAtlas("skycity"))
         {
            init();
            Application.instance.currentGame.hiddenLoading();
            return;
         }
         Application.instance.currentGame.showLoading();
         rmger = Application.instance.resManager;
         Assets.sAsset.enqueue(rmger.getResFile(formatString("textures/{0}x/COPYGAME/copygameui.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYGAME/copygameui.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYGAME/skycity.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYGAME/skycity.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/btdlg.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/btdlg.xml",Assets.sAsset.scaleFactor)));
         Assets.sAsset.loadQueue((function():*
         {
            var onProgress:Function;
            return onProgress = function(param1:Number):void
            {
               var ratio:Number = param1;
               if(ratio == 1)
               {
                  Starling.juggler.delayCall(function():void
                  {
                     init();
                     Application.instance.currentGame.hiddenLoading();
                     SoundManager.playBgSound("Music 5");
                  },0.15);
               }
            };
         })());
      }
      
      private function init() : void
      {
         var _loc2_:int = 0;
         var _loc5_:int = 0;
         Application.instance.currentGame.mainMenu.ReturnBtn.visible = true;
         bg = new Image(Assets.sAsset.getTexture("hallbg2"));
         bg.x = (1365 - bg.width) / 2;
         bg.touchable = false;
         addChild(bg);
         bg = new Image(Assets.sAsset.getTexture("fbbg2"));
         bg.x = (1365 - bg.width) / 2;
         bg.touchable = false;
         addChild(bg);
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("fb61"));
         _loc1_.touchable = false;
         Assets.positionDisplay(_loc1_,"skycity","bgTitle");
         addChild(_loc1_);
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("fb62"));
         _loc3_.touchable = false;
         Assets.positionDisplay(_loc3_,"skycity","title");
         addChild(_loc3_);
         starArr = new Vector.<Level1>();
         lockImgArr = new Vector.<Image>();
         createLevel(_optionsData.mode);
         var _loc4_:Button = new Button(Assets.sAsset.getTexture("fb65"),"",Assets.sAsset.getTexture("fb66"));
         _loc4_.addEventListener("triggered",onPropSkill);
         addChild(_loc4_);
         _loc4_.x = Assets.rightTop.x - _loc4_.width;
         _loc4_.y = Assets.rightTop.y + _loc4_.height + 50;
         energyBar = new EnergyBar();
         if(_optionsData.mode == "hero")
         {
            energyBar.allStarNum = CopyList.instance.countGradeByCpId(1,2);
         }
         else
         {
            energyBar.allStarNum = CopyList.instance.countGradeByCpId(1);
         }
         addChild(energyBar);
         energyBar.x = Assets.rightTop.x - energyBar.width;
         energyBar.y = Assets.rightTop.y;
         setStarData();
         Application.instance.currentGame.mainMenu.show(this);
         if(Application.instance.currentGame._guideOptionsData.pos == "copyGame")
         {
            Guide.instance.guide(_loc4_,LangManager.t("guide17"));
            inGuide = true;
            _loc2_ = int(starArr.length);
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               starArr[_loc5_].touchable = false;
               _loc5_++;
            }
         }
         else
         {
            Application.instance.currentGame.mainMenu.isEnable(true);
            Application.instance.currentGame.mainMenu.ReturnBtn.enabled = true;
         }
         CopyServer.instance.close();
         guideProcess();
      }
      
      public function updateEnergyBar(param1:int = 0, param2:int = 0) : void
      {
         EnergyBar.updatePlayerEnergy();
         if(param2 == 0)
         {
            energyBar.increaseEnergy(param1);
         }
         else
         {
            energyBar.updateEnergy(PlayerDataList.instance.selfData.energy);
         }
      }
      
      override protected function draw() : void
      {
      }
      
      public function createLevel(param1:String) : void
      {
         var level:Level1;
         var lockImg:Image;
         var finger:Image;
         var moveDistance:Number;
         var mode:String = param1;
         var i:int = 1;
         while(i < 10)
         {
            level = new Level1(mode);
            if(_optionsData.mode == "hero")
            {
               level.text = "2-" + i;
            }
            else
            {
               level.text = "1-" + i;
            }
            Assets.positionDisplay(level,"skycity","level1_" + i);
            starArr.push(level);
            addChild(level);
            level.touchable = false;
            lockImg = new Image(Assets.sAsset.getTexture("锁头"));
            Assets.positionDisplay(lockImg,"skycity","lock" + i);
            lockImgArr.push(lockImg);
            addChild(lockImg);
            lockImg.touchable = false;
            level.addEventListener("triggered",onEnterGameWord);
            i = i + 1;
         }
         if(Constants.debug)
         {
            unLock(9);
         }
         else
         {
            unLock(1);
         }
         if(CopyGameTips.isShowFingerFocus == 1 && _optionsData.mode == "hero")
         {
            finger = new Image(Assets.sAsset.getTexture("focusFinger"));
            finger.scaleX = finger.scaleY = 0.5;
            finger.x = starArr[0].x + (starArr[0].width - finger.width >> 1);
            finger.y = starArr[0].y - 20;
            addChild(finger);
            moveDistance = 0;
            addEventListener("enterFrame",(function():*
            {
               var moveFinger:Function;
               return moveFinger = function():void
               {
                  finger.y += Math.sin(moveDistance);
                  moveDistance += 0.1;
                  if(Application.instance.currentGame.navigator.activeScreenID != "SKYCITY")
                  {
                     CopyGameTips.isShowFingerFocus = 0;
                     removeEventListener("enterFrame",moveFinger);
                  }
               };
            })());
         }
      }
      
      private function setStarData() : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = null;
         var _loc1_:CopyDetailData = null;
         _loc3_ = 0;
         while(_loc3_ < starArr.length)
         {
            _loc2_ = starArr[_loc3_].text.split("-");
            _loc1_ = CopyList.instance.getCopyData(1,_loc2_[0],_loc2_[1]);
            if(_loc1_.owner_grade == -1)
            {
               break;
            }
            starArr[_loc3_].updateStarNum(_loc1_.owner_grade);
            _loc3_++;
         }
         unLock(_loc3_ + 1);
      }
      
      private function onEnterGameWord(param1:Event) : void
      {
         var leve:Level1;
         var ary:Array;
         var send:SkyCity;
         var e:Event = param1;
         var self:PlayerData = PlayerDataList.instance.selfData;
         var goodsData:GoodsData = self.getWeapon();
         if(!goodsData || goodsData.place != 1)
         {
            TextTip.instance.show(LangManager.t("noWeapon"));
            if(inGuide)
            {
               Guide.instance.stop();
               inGuide = false;
               Application.instance.currentGame.mainMenu.isEnable(true);
            }
            return;
         }
         leve = e.currentTarget as Level1;
         ary = leve.text.split("-");
         if(inGuide && ary[1] == 1)
         {
            Guide.instance.stop();
         }
         if(ary[1] == 10)
         {
            TextTip.instance.show(LangManager.t("unpoen"));
            return;
         }
         send = this;
         GameServer.instance.sentConsumeEnergy();
         GameServer.instance.getConsumeEnergy(function(param1:Object):void
         {
            var _loc2_:int = int(param1.data.userId);
            var _loc4_:int = int(param1.data.type);
            var _loc3_:int = int(param1.data.energy);
            if(_loc4_ == -1)
            {
               LessPowerDlg.show(Application.instance.currentGame);
               return;
            }
            energyBar.decreaseEnergy(decreaseEnergy);
            PlayerDataList.instance.selfData.energy -= decreaseEnergy;
            CopyList.instance.currentCopyData = CopyList.instance.getCopyData(1,ary[0],ary[1]);
            send.dispatchEventWith("gameStart");
         });
      }
      
      private function onPropSkill(param1:Event) : void
      {
         var _loc2_:BtSkillDlg = new BtSkillDlg();
         _loc2_.closeSignal.addOnce(showGuide);
         Starling.current.stage.addChild(_loc2_);
      }
      
      private function showGuide() : void
      {
         if(Application.instance.currentGame._guideOptionsData.pos == "copyGame")
         {
            Guide.instance.guide(starArr[0]);
            starArr[0].touchable = true;
         }
      }
      
      public function setStarNum(param1:int, param2:int) : void
      {
         (starArr[param1] as Level1).updateStarNum(param2);
      }
      
      public function unLock(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 > 9)
         {
            param1 = 9;
         }
         _loc2_ = 0;
         while(_loc2_ < param1)
         {
            lockImgArr[_loc2_].visible = false;
            starArr[_loc2_].touchable = true;
            _loc2_++;
         }
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
      
      override public function dispose() : void
      {
         if(isEnterTeamList)
         {
            CopyGameTips.isShowFingerFocus = 0;
            Assets.sAsset.removeTextureAtlas("copygameui");
            Assets.sAsset.removeTextureAtlas("skycity");
            Assets.sAsset.removeTextureAtlas("btdlg");
            super.dispose();
         }
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
            GuideEventManager.instance.dispactherEvent("newUI",[[starArr[_loc2_ - 1],40]]);
         }
      }
   }
}

