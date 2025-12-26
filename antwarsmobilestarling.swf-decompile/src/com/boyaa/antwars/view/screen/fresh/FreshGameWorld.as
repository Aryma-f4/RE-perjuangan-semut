package com.boyaa.antwars.view.screen.fresh
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.LocalData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.CopyMonsterRole;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.game.GameWorld;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.monster.Monster;
   import com.boyaa.antwars.view.monster.MonsterCtrl;
   import com.boyaa.antwars.view.monster.MonsterData;
   import com.boyaa.antwars.view.monster.MonsterFactory;
   import com.boyaa.antwars.view.screen.battlefield.element.PokerView;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.WeaponChangeManager;
   import com.boyaa.antwars.view.screen.forge.tip.InfoTipBase;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.textures.TextureAtlas;
   import starling.utils.formatString;
   
   public class FreshGameWorld extends GameWorld
   {
      
      private var dataXml:XML;
      
      private var currentCtrl:int = 0;
      
      private var monster:Monster;
      
      protected var monsterCtrl:MonsterCtrl;
      
      private var pokerView:PokerView;
      
      private var isDead:Boolean = false;
      
      private var round:int = 0;
      
      private var hitPoint:Point;
      
      private var hpArr:Array = [71,110,114,200];
      
      private var dragon:MonsterFactory;
      
      private const MAP_ID:int = 2;
      
      private var _stepTextDictionary:Dictionary = new Dictionary();
      
      private var _stepArr:Array = [["getWeapon1"],["turnLeft"],["openSkillBox"],["usePlane",10,true],["changeAngle",135],["shoot",26],["turnRight"],["changeAngle",25],["shoot",35],["openSkillBox"],["useSkill",1,false],["useSkill",3,true],["shoot",35],["openSkillBox"],["changeTab"],["changeWeapon",[11,1082],true],["changeAngle",30],["shoot",30],["usePower"],["shoot",30],["turnPoker"]];
      
      private var _infoTip:InfoTipBase = new InfoTipBase();
      
      private var _weaponBox:CreateWeaponBox;
      
      private var turnOverCount:int = 0;
      
      public function FreshGameWorld()
      {
         super();
         Assets.btAsset = Assets.sAsset;
      }
      
      override protected function initialize() : void
      {
         var rmger:ResManager;
         initData();
         GuideTipManager.instance.windowTopOnHall = true;
         Application.instance.currentGame.showLoading();
         Assets.btAsset.enqueueMap(2,"map_2");
         rmger = Application.instance.resManager;
         Assets.btAsset.enqueue(rmger.getResFile(formatString("textures/{0}x/BT/battlefieldSpritesheet.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/battlefieldSpritesheet.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/BattlefieldUI.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/BT/BattlefieldUI.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYGAME/monsterskill.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYGAME/monsterskill.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYCHAR/dragon.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYCHAR/dragon.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_dragon.xml",Assets.sAsset.scaleFactor)));
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
                     init();
                     buildWorld(2);
                     startGame();
                     Application.instance.currentGame.hiddenLoading();
                     SoundManager.playBgSound("Music 9");
                  },0.15);
               }
            };
         })());
      }
      
      protected function initData() : void
      {
         dataXml = <roleinfo roleid="0" rolename="Dragon" roledesc="dragon" blood="600" power="500" isBoss="0" spiece_type="100" name="dragon " attack_type="0" attack_dist="0" max_move="20" width="0" height="0" remake="dragon" influ_through="1">
			<ats>			
			<at atid="101" value="150"/>
						<at atid="102" value="10"/>
						<at atid="103" value="10"/>
						<at atid="104" value="10"/>
						<at atid="105" value="10"/>
						<at atid="106" value="10"/>
			</ats>
				</roleinfo>;
         LocalData.instance.setData("skill","1|3|10");
         Constants.isFresh = true;
         initStepTextDic();
         EventCenter.GameEvent.addEventListener("freshGuideComplete",onShowNextStep);
      }
      
      private function initStepTextDic() : void
      {
         var _loc2_:Number = 500;
         var _loc1_:Number = 200;
         _stepTextDictionary["getWeapon1"] = [LangManager.t("freshWorld_guide0"),[_loc2_,_loc1_]];
         _stepTextDictionary["usePlane"] = [LangManager.t("freshWorld_guide3"),[_loc2_,_loc1_ - 50]];
         _stepTextDictionary["changeAngle"] = [LangManager.t("freshWorld_guide4"),[_loc2_,_loc1_]];
         _stepTextDictionary["changeWeapon"] = [LangManager.t("freshWorld_guide7"),[_loc2_,_loc1_ - 50]];
         _stepTextDictionary["shoot"] = [LangManager.t("freshWorld_guide5"),[_loc2_,_loc1_]];
         _stepTextDictionary["turnLeft"] = [LangManager.t("freshWorld_guide1"),[_loc2_,_loc1_]];
         _stepTextDictionary["turnRight"] = [LangManager.t("freshWorld_guide12"),[_loc2_,_loc1_]];
         _stepTextDictionary["usePower"] = [LangManager.t("freshWorld_guide10"),[_loc2_,_loc1_]];
         _stepTextDictionary["useSkill"] = [LangManager.t("freshWorld_guide11"),[_loc2_,_loc1_ - 50]];
         _stepTextDictionary["openSkillBox"] = [LangManager.t("freshWorld_guide2"),[_loc2_,_loc1_ - 60]];
         _stepTextDictionary["turnPoker"] = [LangManager.t("freshWorld_guide9"),[_loc2_,_loc1_]];
         _stepTextDictionary["changeTab"] = [LangManager.t("freshWorld_guide8"),[_loc2_,_loc1_ - 50]];
      }
      
      protected function startGame() : void
      {
         Guide.instance.stop();
         getMap().mapSolid = true;
         FreshGuideVlaue.inFreshGame = true;
         this.addSelfToWorld(new Point(550,400));
         selfCharacterCtrl.downStart();
         selfCharacterCtrl.star.touchable = false;
         selfCharacterCtrl.actionPoint = PlayerDataList.instance.selfData.ability()[7];
         selfCharacterCtrl.slottingCompleteSignal.add(slottingCompleteSignalHandle);
         selfCharacterCtrl.actionCompeleteSignal.add(actionCompleteHandle);
         selfCharacterCtrl.isInFresh = true;
         MonsterCtrl.isInFresh = true;
         UILayer.isInFresh = true;
         infoSprite.visible = false;
         this.UILayer.lock();
         Remoting.instance.getNewWeapon(function(param1:Object):void
         {
            var good:GoodsData;
            var i:int;
            var XGOnlyID:Array;
            var data:Object = param1;
            if(data.ret == 0)
            {
               PlayerDataList.instance.selfData.addOtherInfo(data.role);
               i = 0;
               while(i < data.prop.length)
               {
                  good = GoodsList.instance.addGoodsByStr(data.prop[i]);
                  i = i + 1;
               }
            }
            Application.instance.log("FreshGameWorld",JSON.stringify(data));
            GoodsList.instance.wearGoodsById("weapon",11,1091);
            selfCharacterCtrl.character.initData(GoodsList.instance.getEquipment(1));
            XGOnlyID = GoodsList.instance.getOnlyIDArr(11,1091);
            GameServer.instance.setMemBody(["weapon",1,XGOnlyID[0]],function():void
            {
            });
            selfCharacterCtrl.setAttr();
            selfCharacterCtrl.ctrlStart(true);
         });
         UILayer.bombSignal.addOnce(onUseBombHandle);
         MonsterFactory.dispose();
         dragon = MonsterFactory.instance;
         MissionManager.instance.updateMissionData(175);
         cameraFocusCtrlByTouch(false);
         createWeaponBox(760,500,11,1091);
         showStepGuide();
      }
      
      private function onUseBombHandle() : void
      {
         showStepGuide();
      }
      
      private function createWeaponBox(param1:Number, param2:Number, param3:int, param4:int) : void
      {
         if(_weaponBox && _weaponBox.parent)
         {
            _weaponBox.removeFromParent(true);
         }
         _weaponBox = new CreateWeaponBox(param3,param4);
         _weaponBox.x = param1;
         _weaponBox.y = param2;
         hitPoint = _weaponBox.hitPoint;
         this.ctrlInfoLayer.addChild(_weaponBox);
         selfCharacterCtrl.self.addEventListener("enterFrame",onHitTest);
      }
      
      protected function switchCtrl() : void
      {
         Starling.juggler.delayCall(function():void
         {
            if(isDead)
            {
               return;
            }
            if(currentCtrl == 0)
            {
               cameraFocusCtrlByTouch(true);
               this.mapCtrlByTouch = false;
               camera.swapFocus(selfCharacterCtrl.icharacter);
               playMyGo(function():void
               {
                  selfCharacterCtrl.ctrlStart(true);
                  currentCtrl = 1;
                  if(round != 0)
                  {
                     showStepGuide();
                  }
               });
               round = round + 1;
               UILayer.bomb.bombValue += 40;
               if(round > 1)
               {
                  selfCharacterCtrl.actionPoint = PlayerDataList.instance.selfData.ability()[7];
               }
            }
            else
            {
               UILayer.disable = true;
               if(round == 2)
               {
                  UILayer.planeBtn.enabled = false;
               }
               monsterCtrl.ctrlStart();
               monsterCtrl.attackAction();
               currentCtrl = 0;
            }
         },1);
      }
      
      private function onUseSkill(param1:GameEvent) : void
      {
         var _loc2_:Object = param1.param as Object;
         selfCharacterCtrl.star.touchable = true;
         UILayer.hiddenBottomBar();
         Guide.instance.stop();
         if(_loc2_.skillId == 10)
         {
         }
      }
      
      private function onShowNextStep(param1:GameEvent) : void
      {
         showStepGuide();
      }
      
      private function flushMonsters() : void
      {
         var _loc4_:TextureAtlas = Assets.sAsset.getTextureAtlas("monsterskill");
         var _loc1_:MovieClip = new MovieClip(_loc4_.getTextures("yun00"),5);
         _loc1_.scaleX = 1.5;
         _loc1_.x = 1100;
         _loc1_.y = 200;
         _loc1_.loop = false;
         _loc1_.addEventListener("complete",removeCloud);
         _loc1_.play();
         Starling.juggler.add(_loc1_);
         this.ctrlInfoLayer.addChild(_loc1_);
         var _loc2_:CopyMonsterRole = new CopyMonsterRole();
         _loc2_.updateForData(dataXml);
         var _loc3_:MonsterData = new MonsterData(_loc2_);
         monster = dragon.create("Dragon",_loc3_);
         monster.width = 300;
         monster.height = 180;
         monster.x = 1080;
         monster.y = 400;
         this._charatersLayer.addChild(monster);
         monsterCtrl = new MonsterCtrl(this,monster,1);
         monster.setStatus("move");
         SoundManager.playSound("dragon_shock");
         Starling.juggler.add(monsterCtrl);
         monsterCtrl.actionCompleteSignal.add(monsterActionCompleteHandle);
         this.UILayer.addMonsterHead(monsterCtrl.siteID,monsterCtrl.hp,2,1);
         dataXml = null;
      }
      
      private function removeCloud(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.removeEventListener("complete",removeCloud);
         _loc2_.stop();
         Starling.juggler.remove(_loc2_);
         _loc2_.removeFromParent(true);
      }
      
      private function showTipText(param1:String) : void
      {
         var _loc2_:Array = _stepTextDictionary[param1];
         _infoTip.update(_loc2_[0]);
         _infoTip.x = _loc2_[1][0];
         _infoTip.y = _loc2_[1][1];
         stage.addChild(_infoTip);
      }
      
      private function showStepGuide() : void
      {
         var _loc1_:Array = _stepArr.shift();
         FreshGuideVlaue.currentStepData = _loc1_;
         showTipText(_loc1_[0]);
         EventCenter.GameEvent.dispatchEvent(new GameEvent("freshGame",_loc1_));
      }
      
      private function onHitTest(param1:EnterFrameEvent) : void
      {
         var good:GoodsData;
         var e:EnterFrameEvent = param1;
         var isHit:Boolean = MathHelper.check_circleAndRectangle(hitPoint,40,selfCharacterCtrl.self.bitmapRectangle);
         if(isHit)
         {
            Guide.instance.stop();
            this.getMoveButton().visible = false;
            selfCharacterCtrl.self.removeEventListener("enterFrame",onHitTest);
            _weaponBox.removeFromParent();
            UILayer.unLock();
            EventCenter.GameEvent.addEventListener("useSKill",onUseSkill);
            MissionManager.instance.updateMissionData(101,0,10);
            selfCharacterCtrl.actionPoint = 0;
            if(FreshGuideVlaue.currentStepData[0] == "getWeapon1")
            {
               selfCharacterCtrl.changeWeapon(GoodsList.instance.getGoodsById(11,1091));
               createWeaponBox(350,300,11,1082);
               showStepGuide();
            }
            else
            {
               good = GoodsList.instance.getGoodsById(11,1082);
               Remoting.instance.changeWeaponInBox(0,good.onlyID,(function():*
               {
                  var callBack:Function;
                  return callBack = function(param1:Object):void
                  {
                     Application.instance.log("PHP-playerChangeWeaponInBox",JSON.stringify(param1));
                     WeaponChangeManager.instance.initWeapon();
                  };
               })());
            }
         }
      }
      
      private function actionCompleteHandle(param1:int = 0) : void
      {
         cameraFocusCtrlByTouch(true);
         if(!isDead)
         {
            switchCtrl();
         }
      }
      
      private function slottingCompleteSignalHandle(param1:int, param2:Array) : void
      {
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         trace(JSON.stringify(param2));
         var _loc5_:int = int(param2[0]);
         trace("type" + _loc5_);
         if(_loc5_ == 2 || _loc5_ == 3)
         {
            if(!monster)
            {
               flushMonsters();
            }
            return;
         }
         var _loc3_:Array = param2[4];
         _loc6_ = 0;
         while(_loc6_ < _loc3_.length)
         {
            trace(_loc3_[_loc6_][0]);
            if(_loc3_[_loc6_][0] != 0)
            {
               _loc4_ = dropHpByValue(selfCharacterCtrl,monster.monsterCtrl,hpArr[round - 1]);
               UILayer.updateCharHP(monsterCtrl.siteID,monsterCtrl.hp - _loc4_);
            }
            _loc6_++;
         }
         if(monster.monsterCtrl.hp <= 0)
         {
            SoundManager.playSound("sound 27");
            isDead = true;
            gameOver(true);
            trace("game over...");
         }
      }
      
      private function monsterActionCompleteHandle() : void
      {
         dropHpByValue(monsterCtrl,selfCharacterCtrl,9);
         if(!isDead)
         {
            switchCtrl();
         }
      }
      
      private function gameOver(param1:Boolean) : void
      {
         selfCharacterCtrl.ctrlStart(false);
         GuideTipManager.instance.stopGuide();
         gameOverAnimation(param1,gameOverWinShow);
      }
      
      private function showPoker(param1:int) : void
      {
         pokerView.overturnPoker(param1,GoodsList.instance.getGoodsById(25,1011),overturnPokerCallBack);
         pokerView.clickPokerSignal.removeAll();
      }
      
      private function overturnPokerCallBack() : void
      {
         turnOverCount = turnOverCount + 1;
         if(turnOverCount >= 1)
         {
            Starling.juggler.delayCall(function():void
            {
               dispatchEventWith("complete");
            },2);
         }
      }
      
      private function gameOverWinShow() : void
      {
         showTipText("turnPoker");
         pokerView = new PokerView();
         pokerView.showTimeView = false;
         addChild(pokerView);
         pokerView.play(0);
         pokerView.clickPokerSignal.add(showPoker);
         Remoting.instance.openFreshPack(4,function(param1:Object):void
         {
            AccountData.instance.gameGold = param1.currency;
            PlayerDataList.instance.selfData.exp = param1.mpoint;
         });
      }
      
      override public function dispose() : void
      {
         trace("[dispose FreshGameWorld...]");
         FreshGuideVlaue.currentStepData = [];
         FreshGuideVlaue.inFreshGame = false;
         selfCharacterCtrl.isInFresh = false;
         MonsterCtrl.isInFresh = false;
         UILayer.isInFresh = false;
         EventCenter.GameEvent.removeEventListener("freshGuideComplete",onShowNextStep);
         EventCenter.GameEvent.removeEventListener("useSKill",onUseSkill);
         selfCharacterCtrl.slottingCompleteSignal.remove(slottingCompleteSignalHandle);
         selfCharacterCtrl.actionCompeleteSignal.remove(actionCompleteHandle);
         if(monsterCtrl)
         {
            monsterCtrl.actionCompleteSignal.remove(monsterActionCompleteHandle);
         }
         GuideTipManager.instance.stopGuide();
         _infoTip.removeFromParent(true);
         Starling.juggler.remove(selfCharacterCtrl);
         Starling.juggler.remove(monsterCtrl);
         if(pokerView)
         {
            pokerView.removeFromParent();
         }
         if(monster)
         {
            monster.monsterCtrl.dispose();
         }
         Assets.btAsset.removeTextureAtlas("monsterskill");
         Assets.btAsset.removeMapTexture(2);
         Assets.btAsset.removeTextureAtlas("dragon");
         Assets.btAsset.removeSkeletonsAndBoneAtlases("dragon");
         super.dispose();
         LocalData.instance.setData("skill","");
         GuideTipManager.instance.windowTopOnHall = false;
      }
   }
}

