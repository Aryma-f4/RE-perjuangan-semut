package com.boyaa.antwars.view.screen.copygame.game
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.AllRoomData;
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.CopyMonsterRoleList;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.CopyDetailData;
   import com.boyaa.antwars.data.model.CopyMonsterRole;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.data.model.ServerData;
   import com.boyaa.antwars.helper.autoFight.AutoFightManager;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.character.CharacterCtrl;
   import com.boyaa.antwars.view.game.GameWorld;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.monster.EggCtrl;
   import com.boyaa.antwars.view.monster.Monster;
   import com.boyaa.antwars.view.monster.MonsterCtrl;
   import com.boyaa.antwars.view.monster.MonsterData;
   import com.boyaa.antwars.view.monster.MonsterFactory;
   import com.boyaa.antwars.view.monster.MonsterInfoDlg;
   import com.boyaa.antwars.view.screen.PersonnalInfoDlg;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.battlefield.element.CharBox;
   import com.boyaa.antwars.view.screen.battlefield.element.PokerView;
   import com.boyaa.antwars.view.screen.copygame.CopyGameTips;
   import com.boyaa.antwars.view.screen.copygame.ReliveControl;
   import com.boyaa.antwars.view.screen.copygame.element.CountDownTimer;
   import com.boyaa.antwars.view.screen.copygame.game.element.StoneGate;
   import com.boyaa.antwars.view.vipSystem.VipManager;
   import com.boyaa.debug.Logging.LevelLogger;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.events.Event;
   import starling.textures.TextureAtlas;
   import starling.utils.formatString;
   
   public class CopyGameWorld extends GameWorld
   {
      
      private var currentCtrl:int = 1;
      
      protected var monsters:Vector.<MonsterCtrl>;
      
      public var allMonsters:int = 0;
      
      protected var timePass:Number = 0;
      
      protected var _gameOver:Boolean = false;
      
      protected var timeLimit:Number = 5;
      
      protected var copyData:CopyDetailData;
      
      public var monsterAttack:Boolean = true;
      
      private var monstersCount:Object = {};
      
      private var flushMonstersCount:Object = {};
      
      private var _monsterCDCount:int = 0;
      
      private var _monsterSelfCDCount:Object = {};
      
      private var _monsterRoleIdArr:Array = [];
      
      private var monsterDlg:MonsterInfoDlg;
      
      private var eggNum:int = 0;
      
      private var aboutme:PersonnalInfoDlg;
      
      private var aboutmeData:Object;
      
      private var isInit:Boolean = true;
      
      private var _monsters_complete_count:int = 0;
      
      private var _alldie:Boolean;
      
      private var goodsDataVector:Vector.<Object>;
      
      private var winExp:int = 0;
      
      private var vipExp:int = 0;
      
      private var starNum:int = 0;
      
      private var pokerView:PokerView;
      
      private var tips:CopyGameTips = new CopyGameTips();
      
      private var _countDownTimer:CountDownTimer;
      
      private var _callgameOverShowCount:int = 0;
      
      private var turnOverCount:int = 0;
      
      private var _finishCount:CountDownTimer;
      
      private var monsterRoldIdArr:Array;
      
      private var monsterShowTime:int = 0;
      
      private var selfMirror:CopyGameSelfRobot;
      
      private var robotPosVector:Vector.<Point>;
      
      protected var stoneGate:StoneGate;
      
      public function CopyGameWorld()
      {
         super();
         Assets.btAsset = Assets.sAsset;
      }
      
      private function connectServer() : void
      {
         GameServer.instance.getServerIDByType(3,function(param1:Object):void
         {
            var data:Object = param1;
            var serData:ServerData = AllRoomData.instance.getDataByID(data.svid);
            CopyServer.instance.init(serData.ip,serData.port);
            trace("当前连接的服务器：",serData.ip,serData.port);
            CopyServer.instance.connect();
            CopyServer.instance.serverType = 1;
            CopyServer.instance.loginSuccessful((function():*
            {
               var cb:Function;
               return cb = function(param1:Object):void
               {
                  var retData:Object = param1;
                  Application.instance.log("copyserver loginSucc",JSON.stringify(retData));
                  CopyServer.instance.getFreeReliveTimes((function():*
                  {
                     var cb:Function;
                     return cb = function(param1:Object):void
                     {
                        Application.instance.log("getFreeReliveTimes",JSON.stringify(param1));
                        VipManager.instance.vipPowerData.copyReliveTime = param1.data.freeleft;
                     };
                  })());
               };
            })());
         });
      }
      
      private function disConnectServer() : void
      {
         CopyServer.instance.close();
      }
      
      private function playBgSound() : void
      {
         switch(copyData.cpid - 1)
         {
            case 0:
               SoundManager.playBgSound("Music 11");
               break;
            case 1:
               SoundManager.playBgSound("Music 14");
               break;
            default:
               SoundManager.playBgSound("Music 11");
         }
         SoundManager.bgVol = 0.1;
      }
      
      override protected function initialize() : void
      {
         var rmger:ResManager;
         initData();
         Application.instance.currentGame.showLoading();
         Assets.btAsset.enqueueMap(copyData.mapid,"map_" + copyData.mapid);
         rmger = Application.instance.resManager;
         loadAssets(rmger);
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
                     buildWorld(copyData.mapid);
                     startGame();
                     Application.instance.currentGame.hiddenLoading();
                  },0.15);
               }
            };
         })());
      }
      
      private function loadAssets(param1:ResManager) : void
      {
         Assets.btAsset.enqueue(param1.getResFile(formatString("textures/{0}x/BT/battlefieldSpritesheet.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/BT/battlefieldSpritesheet.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/BT/BattlefieldUI.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/BT/BattlefieldUI.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYGAME/monsterskill.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYGAME/monsterskill.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/BT/emoticon.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/BT/emoticon.xml",Assets.sAsset.scaleFactor)));
         switch(copyData.cpid - 1)
         {
            case 0:
               Assets.btAsset.enqueue(param1.getResFile(formatString("textures/{0}x/COPYCHAR/worm.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/worm.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_worm.xml",Assets.sAsset.scaleFactor)));
               break;
            case 1:
               Assets.btAsset.enqueue(param1.getResFile(formatString("textures/{0}x/COPYGAME/badstate.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYGAME/badstate.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYGAME/monsterskill2.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYGAME/monsterskill2.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/spider.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/spider.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_spider.xml",Assets.sAsset.scaleFactor)));
               break;
            case 2:
               Assets.btAsset.enqueue(param1.getResFile(formatString("textures/{0}x/COPYGAME/spriteMonsterSkill.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYGAME/spriteMonsterSkill.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/sprite.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/sprite.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_sprite.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/LeienSkillEffect.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/LeienSkillEffect.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_LeienSkillEffect.xml",Assets.sAsset.scaleFactor)));
         }
      }
      
      override protected function init() : void
      {
         super.init();
         _UILayer.copyTimeLimit = true;
         connectServer();
      }
      
      protected function initData() : void
      {
         copyData = CopyList.instance.currentCopyData;
         timeLimit = copyData.powerTips;
         MonsterFactory.dispose();
         playBgSound();
      }
      
      protected function startGame() : void
      {
         var _loc1_:int = 0;
         getMap().mapSolid = true;
         _UILayer.minute.timeoverSignal.addOnce(onTimerOver);
         _UILayer.minute.startMinute(timeLimit);
         monsters = new Vector.<MonsterCtrl>();
         if(copyData.mapid == 206)
         {
            this.addSelfToWorld(new Point(725,300));
         }
         else if(copyData.mapid != 202)
         {
            this.addSelfToWorld(new Point(500,300));
            addMonsterHeadImg();
         }
         else
         {
            this.camera.zoomFocus(1.333);
            this.addSelfToWorld(new Point(340,800));
         }
         selfCharacterCtrl.downStart();
         selfCharacterCtrl.slottingCompleteSignal.add(slottingCompleteSignalHandle);
         selfCharacterCtrl.actionCompeleteSignal.add(actionCompleteHandle);
         _loc1_ = 0;
         while(_loc1_ < copyData.monsterList.length)
         {
            monstersCount[copyData.monsterList[_loc1_].roleid] = 0;
            flushMonstersCount[copyData.monsterList[_loc1_].roleid] = 0;
            _loc1_++;
         }
         CharBox.aboutMeSignal.add(aboutMe);
         UILayer.hiddenBottomBar();
         switchCtrl();
         if(Application.instance.currentGame._guideOptionsData.pos == "copyGame")
         {
            TextTip.instance.showByLang("guide19");
            MissionManager.instance.updateMissionData(178,0,11);
            MissionManager.instance.updateMissionData(178,0,15);
            MissionManager.instance.updateMissionData(172,0,1);
            Application.instance.currentGame._guideOptionsData.pos = "mission";
         }
         initMonsterRoleArr();
      }
      
      override public function onPassBtnHandle() : void
      {
         super.onPassBtnHandle();
         if(isMyCtrl())
         {
            if(copyData.mapid == 202)
            {
               currentCtrl = 0;
            }
            switchCtrl();
         }
      }
      
      override protected function isMyCtrl() : Boolean
      {
         return currentCtrl == 1;
      }
      
      public function aboutMe(param1:int) : void
      {
         var _loc2_:PlayerData = PlayerDataList.instance.getDataBySiteID(param1);
         if(aboutme == null)
         {
            aboutme = new PersonnalInfoDlg();
         }
         updateAboutme(_loc2_);
         this.UILayer.addChild(aboutme);
      }
      
      private function getPlayerInfo(param1:Object) : void
      {
         Application.instance.log("AboutMe显示人个信息:",JSON.stringify(param1));
         aboutmeData = param1;
         aboutme.showPlayerInfo(param1);
         aboutme.isFriend = true;
      }
      
      private function addMonsterHeadImg(param1:String = "") : void
      {
         var _loc4_:Image = null;
         var _loc2_:Button = new Button(Assets.sAsset.getTexture("btnS_btUIHeadBtn1"),"",Assets.sAsset.getTexture("btnS_btUIHeadBtn2"));
         var _loc3_:Rectangle = Assets.getPosition("bfUILayer","charbox3");
         _loc2_.x = _loc3_.x;
         _loc2_.y = _loc3_.y;
         _loc2_.addEventListener("triggered",showMonsterInfo);
         this.UILayer.addChild(_loc2_);
         switch(copyData.cpid - 1)
         {
            case 0:
               _loc4_ = new Image(Assets.sAsset.getTexture("120x120毛虫1"));
               _loc4_.y = _loc3_.y + 5;
               _loc4_.x = _loc3_.x + 10;
               _loc4_.scaleX = _loc4_.scaleY = 0.5833333333333334;
               break;
            case 1:
               _loc4_ = new Image(Assets.sAsset.getTexture("s2"));
               _loc4_.y = _loc3_.y + 10;
               _loc4_.x = _loc3_.x + 10;
               _loc4_.scaleX = _loc4_.scaleY = 0.6666666666666666;
               break;
            case 2:
               _loc4_ = new Image(Assets.sAsset.getTexture("wizard"));
               _loc4_.y = _loc3_.y + 10;
               _loc4_.x = _loc3_.x + 10;
               _loc4_.scaleX = _loc4_.scaleY = 0.375;
         }
         _loc4_.touchable = false;
         this.UILayer.addChild(_loc4_);
      }
      
      private function flushMonsters() : void
      {
         var _loc1_:Point = null;
         var _loc4_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:Point = null;
         var _loc11_:int = 0;
         var _loc6_:int = 0;
         var _loc12_:MonsterCtrl = null;
         var _loc2_:CopyMonsterRole = null;
         var _loc13_:MonsterData = null;
         var _loc3_:Monster = null;
         var _loc5_:Rectangle = null;
         var _loc7_:Rectangle = null;
         var _loc14_:TextureAtlas = null;
         var _loc9_:MovieClip = null;
         if(isInit)
         {
            if(copyData.mapid == 204)
            {
               stoneGate = new StoneGate();
               this.map.addChild(stoneGate);
            }
            if(copyData.cpid == 2 && copyData.difficulty == 2 && copyData.stage == 5)
            {
               robotPositionInit([200,400,600,800,1000]);
               _loc1_ = robotPosVector[Math.floor(Math.random() * (robotPosVector.length - 1))];
               addSelfRobot(_loc1_);
               currentCtrl = 0;
            }
            allMonsters = int(copyData.taskContent);
            showLeftNumText();
            isInit = false;
         }
         _loc8_ = 0;
         while(_loc8_ < copyData.monsterList.length)
         {
            _loc4_ = copyData.monsterList[_loc8_].roleid;
            if(flushMonstersCount[_loc4_] < copyData.monsterList[_loc8_].qty / copyData.monsterList[_loc8_].produce_num)
            {
               _loc10_ = copyData.monsterList[_loc8_].getRandomBronpoint();
               if(!_loc10_)
               {
                  _loc10_ = new Point(int(1324 * Math.random() + 100),100);
               }
               if(monstersCount[_loc4_] <= 0 || _monsterSelfCDCount[_loc4_] > copyData.monsterList[_loc8_].produce_cd)
               {
                  _loc11_ = int(monsters.length);
                  _loc6_ = 0;
                  while(_loc6_ < copyData.monsterList[_loc8_].produce_num)
                  {
                     _loc2_ = CopyMonsterRoleList.instance.getRoleById(_loc4_);
                     _loc13_ = new MonsterData(_loc2_);
                     _loc13_.move_speed = 50 + _loc6_ * 10;
                     _loc3_ = MonsterFactory.instance.create(_loc2_.remake,_loc13_);
                     this.charatersLayer.addChild(_loc3_);
                     if(_loc10_)
                     {
                        _loc3_.x = _loc10_.x - _loc6_ * (_loc3_.width >> 1);
                        _loc3_.y = _loc10_.y;
                     }
                     _loc5_ = Assets.getPosition("map201","monster" + _loc3_.data.spiece_type);
                     if(_loc5_)
                     {
                        _loc3_.x = _loc5_.x;
                        _loc3_.y = _loc5_.y;
                        _loc3_.width = _loc5_.width;
                        _loc3_.height = _loc5_.height;
                     }
                     if(_loc2_.remake == "Dan")
                     {
                        eggNum = eggNum + 1;
                        if(eggNum > 11)
                        {
                           eggNum = 1;
                        }
                        _loc7_ = Assets.getPosition("map202","egg" + eggNum);
                        if(_loc7_)
                        {
                           _loc3_.x = _loc7_.x;
                           _loc3_.y = _loc7_.y;
                           this.mapBackCharatersLayer.addChild(_loc3_);
                        }
                        _loc12_ = new EggCtrl(this,_loc3_,eggNum);
                     }
                     else
                     {
                        _loc12_ = new MonsterCtrl(this,_loc3_,_loc6_ + _loc11_ + 1);
                     }
                     Starling.juggler.add(_loc12_);
                     _loc12_.actionCompleteSignal.add(monsterActionCompleteHandle);
                     _loc12_.attackSignal.add(monsterAttackHandle);
                     monsters.push(_loc12_);
                     _loc12_.firstShowRunAction = false;
                     _loc6_++;
                  }
                  if(_loc10_ && _loc8_ == 0 && copyData.mapid != 202)
                  {
                     _loc14_ = Assets.sAsset.getTextureAtlas("monsterskill");
                     _loc9_ = new MovieClip(_loc14_.getTextures("yun00"),5);
                     _loc9_.scaleX = 1.5;
                     _loc9_.x = _loc10_.x - _loc9_.width / 2;
                     _loc9_.y = _loc10_.y;
                     _loc9_.loop = false;
                     this.ctrlInfoLayer.addChild(_loc9_);
                     _loc9_.play();
                     Starling.juggler.add(_loc9_);
                     _loc9_.addEventListener("complete",removeAnimation);
                  }
                  var _loc15_:* = _loc4_;
                  var _loc16_:* = monstersCount[_loc15_] + copyData.monsterList[_loc8_].produce_num;
                  monstersCount[_loc15_] = _loc16_;
                  _monsterSelfCDCount[_loc4_] = 0;
                  if(_monsterRoleIdArr.indexOf(_loc4_) == -1)
                  {
                     _monsterRoleIdArr.push(_loc4_);
                  }
                  flushMonstersCount[_loc4_]++;
               }
            }
            _loc8_++;
         }
      }
      
      private function removeAnimation(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.removeEventListener("complete",removeAnimation);
         _loc2_.stop();
         Starling.juggler.remove(_loc2_);
         _loc2_.removeFromParent();
      }
      
      private function actionCompleteHandle(param1:int = 0) : void
      {
         cameraFocusCtrlByTouch(true);
         switchCtrl();
         monsterAttack = true;
      }
      
      private function monsterAttackHandle(param1:String, param2:MonsterCtrl) : void
      {
         switch(param1)
         {
            case "attack":
               dropHp(param2,selfCharacterCtrl);
               break;
            case "palsy":
               stateOfParalysis(selfCharacterCtrl,"palsy");
               break;
            case "chain":
               stateOfParalysis(selfCharacterCtrl,"chain");
         }
      }
      
      private function monsterActionCompleteHandle() : void
      {
         _monsters_complete_count = _monsters_complete_count + 1;
         if(_monsters_complete_count >= getCurrentMonstersSum())
         {
            switchCtrl();
            monsterAttack = false;
         }
      }
      
      protected function getCurrentMonstersSum() : int
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < monsters.length)
         {
            if(monsters[_loc2_].hp > 0)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getMonsters() : Vector.<MonsterCtrl>
      {
         return monsters;
      }
      
      private function slottingCompleteSignalHandle(param1:int, param2:Array) : void
      {
         var _loc5_:int = 0;
         var _loc4_:int = int(param2[0]);
         if(_loc4_ == 2 || _loc4_ == 3)
         {
            return;
         }
         var _loc3_:Array = param2[4];
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_][0] == 0)
            {
               dropHp(selfCharacterCtrl,selfCharacterCtrl,_loc3_[_loc5_][1]);
            }
            else if(selfMirror && _loc3_[_loc5_][0] == selfMirror.siteID)
            {
               dropHp(selfCharacterCtrl,selfMirror.robot,_loc3_[_loc5_][1]);
               UILayer.updateCharHP(selfMirror.siteID,selfMirror.robot.hp);
               if(selfMirror.robot.hp <= 0)
               {
                  allMonsters = allMonsters - 1;
                  if(allMonsters < 0)
                  {
                     allMonsters = 0;
                  }
               }
            }
            else
            {
               if(Monster(monsters[_loc3_[_loc5_][0] - 1].icharacter).data.influ_through == 0)
               {
                  return;
               }
               dropHp(selfCharacterCtrl,monsters[_loc3_[_loc5_][0] - 1],_loc3_[_loc5_][1]);
               if(monsters[_loc3_[_loc5_][0] - 1].hp <= 0)
               {
                  monstersCount[(monsters[_loc3_[_loc5_][0] - 1].icharacter as Monster).data.roleid]--;
                  allMonsters = allMonsters - 1;
                  if(allMonsters < 0)
                  {
                     allMonsters = 0;
                  }
               }
            }
            _loc5_++;
         }
         showLeftNumText();
      }
      
      protected function switchCtrl() : void
      {
         var monsterCtrl:MonsterCtrl;
         flushMonsters();
         Starling.juggler.delayCall(function():void
         {
            var monsterCtrl:MonsterCtrl;
            var item:int;
            if(_gameOver || _alldie)
            {
               return;
            }
            if(currentCtrl == 0)
            {
               cameraFocusCtrlByTouch(true);
               camera.swapFocus(selfCharacterCtrl.icharacter);
               playMyGo(function():void
               {
                  selfCharacterCtrl.ctrlStart(true);
                  currentCtrl = 1;
                  if(copyData.mapid == 202)
                  {
                     _UILayer.usePlaneSignal.dispatch();
                  }
               });
               if(stateObject != null)
               {
                  stateSignal.dispatch(selfCharacterCtrl);
               }
            }
            else
            {
               hitStoneGate();
               if(selfMirror)
               {
                  selfMirror.robot.ctrlStart(true);
                  camera.swapFocus(selfMirror.robot.character);
                  return;
               }
               _monsterCDCount = _monsterCDCount + 1;
               _monsters_complete_count = 0;
               for each(monsterCtrl in monsters)
               {
                  monsterCtrl.ctrlStart();
               }
               for each(item in _monsterRoleIdArr)
               {
                  _monsterSelfCDCount[item]++;
               }
               currentCtrl = 0;
            }
         },1);
         _alldie = true;
         for each(monsterCtrl in monsters)
         {
            if((monsterCtrl.icharacter as Monster).data.influ_through != 0 && monsterCtrl.hp > 0)
            {
               _alldie = false;
               break;
            }
         }
         if(selfMirror && selfMirror.robot.hp > 0)
         {
            _alldie = false;
         }
         if(_alldie)
         {
            gameOver(true);
            trace("打死所有怪物",SoundManager.actSoundVol);
            Starling.juggler.delayCall(function():void
            {
               SoundManager.playSound("sound 27");
            },0.5);
         }
      }
      
      override protected function update(param1:Number) : void
      {
         timePass += param1;
         if(!_gameOver)
         {
            if(selfCharacterCtrl.hp <= 0)
            {
               gameOver(false);
            }
            if(currentCtrl == 0)
            {
               MonsterCtrl.monsterAttrQueue.start();
            }
         }
      }
      
      private function onTimerOver() : void
      {
         gameOver(false);
      }
      
      private function getGrade() : void
      {
         if(timePass < 90)
         {
            starNum = 3;
         }
         else if(timePass < 150)
         {
            starNum = 2;
         }
         else if(timePass < 210)
         {
            starNum = 1;
         }
         else
         {
            starNum = 1;
         }
         if(starNum > copyData.owner_grade)
         {
            copyData.owner_grade = starNum;
         }
      }
      
      public function gameOver(param1:Boolean) : void
      {
         var win:Boolean = param1;
         if(!_gameOver)
         {
            tips.setTipPosition();
            tips.setGameWorld(this);
            _gameOver = true;
            selfCharacterCtrl.ctrlStart(false);
            Starling.juggler.remove(selfCharacterCtrl);
            UILayer.minute.stop();
            if(win)
            {
               getGrade();
               MissionManager.instance.updateMissionData(172,0,copyData.cpdtlid);
               MissionManager.instance.updateMissionData(174,0,copyData.cpdtlid,starNum);
               Remoting.instance.getMobileCopyPrize(copyData.cpdtlid,copyData.cpid,copyData.stage,copyData.difficulty,starNum,function(param1:Object):void
               {
                  var _loc4_:int = 0;
                  var _loc2_:GoodsData = null;
                  var _loc3_:int = 0;
                  if(param1.hasOwnProperty("account"))
                  {
                     _loc3_ = param1.account.currency - AccountData.instance.gameGold;
                  }
                  if(param1.hasOwnProperty("role"))
                  {
                     vipExp = param1.role.vipmpoint;
                     winExp = param1.role.mpoint - PlayerDataList.instance.selfData.exp;
                     PlayerDataList.instance.selfData.addOtherInfo(param1.role);
                     winExp -= vipExp;
                  }
                  goodsDataVector = new Vector.<Object>();
                  if(param1.hasOwnProperty("props"))
                  {
                     _loc4_ = 0;
                     while(_loc4_ < param1.props.length)
                     {
                        _loc2_ = GoodsList.instance.addGoodsByStr(param1.props[_loc4_]);
                        goodsDataVector.push(_loc2_);
                        _loc4_++;
                     }
                  }
                  else
                  {
                     goodsDataVector.push({"goldCount":_loc3_});
                  }
                  gameOverWinShow();
               });
               gameOverAnimation(win,gameOverWinShow);
            }
            else
            {
               SoundManager.playSound("sound 28");
               gameOverAnimation(win,gameOverLostShow);
            }
         }
      }
      
      private function onPlayerReliveHandle(param1:Array) : void
      {
         var arr:Array = param1;
         var flag:String = arr[0];
         if(flag == "pause")
         {
            _countDownTimer.setPause(true);
         }
         if(flag == "no")
         {
            _countDownTimer.setPause(false);
         }
         if(flag == "yes")
         {
            if(VipManager.instance.vipPowerData.copyReliveTime > 0)
            {
               CopyServer.instance.useFreeRelive(2,(function():*
               {
                  var cb:Function;
                  return cb = function(param1:Object):void
                  {
                     Application.instance.log("useFreeReliveInNormal",JSON.stringify(param1));
                     if(param1.data.flag == 0)
                     {
                        VipManager.instance.vipPowerData.copyReliveTime--;
                        reliveSelfPlayer();
                     }
                  };
               })());
               return;
            }
            CopyServer.instance.playerReliveInNormal((function():*
            {
               var cb:Function;
               return cb = function(param1:Object):void
               {
                  LevelLogger.getLogger("PlayerReliveInNormal").info(JSON.stringify(param1));
                  if(param1.data.flag == 0)
                  {
                     return;
                  }
                  if(param1.data.flag == 1)
                  {
                     AccountData.instance.updateBoyaaCoin(param1.data.boyaaCoin);
                     reliveSelfPlayer();
                  }
               };
            })());
            if(AccountData.instance.boyaaCoin < arr[1])
            {
               TextTip.instance.showByLang("boyyabz");
               _countDownTimer.setPause(false);
               return;
            }
            CopyServer.instance.sendReliveInNormal();
         }
      }
      
      override protected function reliveSelfPlayer() : void
      {
         super.reliveSelfPlayer();
         selfCharacterCtrl.downStart();
         selfCharacterCtrl.slottingCompleteSignal.add(slottingCompleteSignalHandle);
         selfCharacterCtrl.actionCompeleteSignal.add(actionCompleteHandle);
         _gameOver = false;
         _countDownTimer.stop();
         tips.removeFromParent(false);
         _countDownTimer.removeFromParent(true);
         switchCtrl();
      }
      
      private function gameOverLostShow() : void
      {
         var type:int;
         ReliveControl.instance.removeSignalFunc(onPlayerReliveHandle);
         _countDownTimer = CountDownTimer.show(this,10,(function():*
         {
            var call:Function;
            return call = function():void
            {
               dispatchMessage();
            };
         })());
         type = 1;
         if(selfCharacterCtrl.hp <= 0)
         {
            ReliveControl.instance.addSignalFunc(onPlayerReliveHandle,false);
            type = 5;
         }
         addChild(tips);
         tips.showTip(type);
      }
      
      private function dispatchMessage() : void
      {
         var _loc1_:Array = ["complete","complete","showSpiderCity","showSpriteCity"];
         dispatchEventWith(_loc1_[copyData.cpid]);
      }
      
      private function gameOverWinShow() : void
      {
         _callgameOverShowCount = _callgameOverShowCount + 1;
         if(_callgameOverShowCount > 1)
         {
            pokerView = new PokerView(goodsDataVector.length);
            pokerView.showTimeView = false;
            pokerView.expText.text = winExp.toString();
            pokerView.vipExp = vipExp;
            addChild(pokerView);
            pokerView.play(0);
            pokerView.star.updateStarNum(starNum);
            pokerView.clickPokerSignal.add(showPoker);
            AutoFightManager.instance.autoTurnPocket(showPoker,0);
            if(goodsDataVector.length == 0)
            {
               Starling.juggler.delayCall(function():void
               {
                  dispatchMessage();
               },6);
            }
         }
      }
      
      private function showPoker(param1:int) : void
      {
         if(turnOverCount >= goodsDataVector.length)
         {
            return;
         }
         if(goodsDataVector[0].hasOwnProperty("goldCount") && goodsDataVector[0].goldCount == 0)
         {
            goodsDataVector[0].goldCount = 100;
         }
         pokerView.overturnPoker(param1,goodsDataVector[turnOverCount],overturnPokerCallBack);
         turnOverCount = turnOverCount + 1;
      }
      
      private function overturnPokerCallBack() : void
      {
         if(turnOverCount >= goodsDataVector.length)
         {
            pokerView.disableMsg = LangManager.t("unPoker");
            _finishCount = CountDownTimer.show(this,10,(function():*
            {
               var call:Function;
               return call = function():void
               {
                  dispatchMessage();
               };
            })());
            addChild(tips);
            tips.showTip(0);
            _finishCount.y += 150;
         }
      }
      
      private function initMonsterRoleArr() : void
      {
         var _loc1_:int = 0;
         monsterRoldIdArr = [];
         var _loc2_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < copyData.monsterList.length)
         {
            _loc2_ = uint(copyData.monsterList[_loc1_].roleid);
            if(_loc2_ == 16 || _loc2_ == 17)
            {
               _loc2_ = 16;
            }
            else if(_loc2_ == 22 || _loc2_ == 23)
            {
               _loc2_ = 22;
            }
            if(monsterRoldIdArr.indexOf(_loc2_) == -1)
            {
               monsterRoldIdArr.push(_loc2_);
            }
            _loc1_++;
         }
      }
      
      private function showMonsterInfo(param1:Event) : void
      {
      }
      
      override public function dispose() : void
      {
         for each(var _loc1_ in monsters)
         {
            _loc1_.dispose();
            Starling.juggler.remove(_loc1_);
         }
         MonsterCtrl.monsterAttrQueue.clear();
         if(monsterDlg)
         {
            monsterDlg.removeFromParent(true);
         }
         if(aboutme)
         {
            aboutme.removeFromParent(true);
         }
         stoneGate && stoneGate.removeFromParent(true);
         _UILayer.minute.timeoverSignal.remove(onTimerOver);
         SoundManager.stopBgSound();
         CharBox.aboutMeSignal.removeAll();
         disConnectServer();
         SystemTip.instance.hide();
         if(_finishCount)
         {
            _finishCount.stop();
            _finishCount.removeFromParent(true);
         }
         pokerView && pokerView.clickPokerSignal.remove(showPoker);
         UILayer.onPassBtnSignal.removeAll();
         Assets.btAsset.removeTextureAtlas("monsterskill");
         Assets.btAsset.removeTextureAtlas("monsterskill2");
         Assets.btAsset.removeTextureAtlas("badstate");
         Assets.btAsset.removeMapTexture(copyData.mapid);
         Assets.btAsset.removeMapTexture(copyData.mapid,"bg");
         Assets.btAsset.removeTextureAtlas("battlefieldSpritesheet");
         Assets.btAsset.removeTextureAtlas("emoticon");
         Assets.btAsset.removeTextureAtlas("worm");
         Assets.btAsset.removeSkeletonsAndBoneAtlases("worm");
         Assets.btAsset.removeTextureAtlas("spider");
         Assets.btAsset.removeSkeletonsAndBoneAtlases("spider");
         Assets.btAsset.removeTextureAtlas("sprite");
         Assets.btAsset.removeSkeletonsAndBoneAtlases("sprite");
         Assets.btAsset.removeTextureAtlas("LeienSkillEffect");
         Assets.btAsset.removeSkeletonsAndBoneAtlases("LeienSkillEffect");
         super.dispose();
      }
      
      override public function get totalCDCount() : int
      {
         return _monsterCDCount;
      }
      
      public function showLeftNumText() : void
      {
         switch(copyData.mapid - 202)
         {
            case 0:
               txtLeftNum.text = LangManager.t("lastCount") + allMonsters;
               break;
            case 4:
               txtLeftNum.text = LangManager.t("robotSelf") + allMonsters;
               break;
            default:
               txtLeftNum.text = LangManager.t("leftMonster") + allMonsters;
         }
      }
      
      private function robotPositionInit(param1:Array) : void
      {
         var _loc2_:int = 0;
         robotPosVector = new Vector.<Point>();
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            robotPosVector.push(new Point(param1[_loc2_],100));
            _loc2_++;
         }
      }
      
      private function addSelfRobot(param1:Point) : void
      {
         var pt:Point = param1;
         var actionComplete:* = function(param1:int = 0):void
         {
            cameraFocusCtrlByTouch(true);
            currentCtrl = 0;
            switchCtrl();
         };
         var dieActionComplete:* = function(param1:int, param2:String):void
         {
            if(param1 == PlayerDataList.instance.selfData.siteID)
            {
               gameOver(false);
            }
            else
            {
               gameOver(true);
            }
         };
         selfMirror = new CopyGameSelfRobot(this,selfCharacterCtrl.character);
         selfMirror.addRobotToWorld(pt);
         selfMirror.addSignalFunc([robotSlotting,actionComplete,dieActionComplete]);
      }
      
      private function robotSlotting(param1:int, param2:Array) : void
      {
         var type:int;
         var hitAry:Array;
         var i:int;
         var hp:int;
         var sid:int = param1;
         var data:Array = param2;
         var getCtrlBySiteID:* = function(param1:int):CharacterCtrl
         {
            if(param1 == PlayerDataList.instance.selfData.siteID)
            {
               return selfCharacterCtrl;
            }
            return selfMirror.robot;
         };
         selfCharacterCtrl.downStart();
         selfMirror.robot.downStart();
         type = int(data[0]);
         if(type == 2 || type == 3)
         {
            return;
         }
         hitAry = data[4];
         trace(hitAry);
         i = 0;
         while(i < hitAry.length)
         {
            hp = dropHp(getCtrlBySiteID(hitAry[i][7]),getCtrlBySiteID(hitAry[i][0]),hitAry[i][1]);
            if(hitAry[i][0] != 0)
            {
               UILayer.updateCharHP(hitAry[i][0],selfMirror.robot.hp);
            }
            if(getCtrlBySiteID(hitAry[i][0]) == selfCharacterCtrl)
            {
               selfMirror.robot.countShoot(1);
            }
            i = i + 1;
         }
         selfMirror.robot.countShoot();
      }
      
      private function updateAboutme(param1:PlayerData) : void
      {
         if(aboutmeData == null)
         {
            if(param1 == null)
            {
               Remoting.instance.getMemStatus(PlayerDataList.instance.selfData.uid,getPlayerInfo);
            }
            else
            {
               Remoting.instance.getMemStatus(param1.uid,getPlayerInfo);
            }
         }
         else
         {
            aboutme.showPlayerInfo(aboutmeData);
            aboutme.isFriend = true;
         }
      }
      
      protected function hitStoneGate() : void
      {
         var _loc1_:int = 0;
         if(stoneGate)
         {
            if(selfCharacterCtrl.character.x + selfCharacterCtrl.character.width >= stoneGate.x)
            {
               _loc1_ = 0.1 * selfCharacterCtrl.maxHp;
               dropHpByChar(selfCharacterCtrl,_loc1_);
               selfCharacterCtrl.playCry();
            }
         }
      }
   }
}

