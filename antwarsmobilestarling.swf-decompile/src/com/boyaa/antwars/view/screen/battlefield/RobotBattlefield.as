package com.boyaa.antwars.view.screen.battlefield
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.DisableAll;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterCtrl;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.game.GameWorld;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.battlefield.element.LostMovieClip;
   import com.boyaa.antwars.view.screen.battlefield.element.PokerView;
   import com.boyaa.antwars.view.screen.battlefield.element.ResultView;
   import com.boyaa.antwars.view.screen.battlefield.element.RobotCharacterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.element.WinMovieClip;
   import com.boyaa.antwars.view.screen.rankList.RankListScreen;
   import com.boyaa.debug.Logging.LevelLogger;
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   
   public class RobotBattlefield extends GameWorld
   {
      
      protected var currentCtrl:int = 0;
      
      protected var _gameOver:Boolean = false;
      
      private var robotCharacterCtrl:RobotCharacterCtrl;
      
      protected const ROBOT_ROUND_TIME:int = 30;
      
      protected var _ovarFlopCount:int;
      
      protected var canOverturnPoker:Boolean = false;
      
      protected var poker:PokerView;
      
      private var __send:Boolean = false;
      
      private var _robotName:String;
      
      private var _robotUID:int;
      
      protected var in_switchCtrl:Boolean = false;
      
      private var myhurt:int = 0;
      
      private var robothurt:int = 0;
      
      public function RobotBattlefield()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         init();
         buildWorld(PlayerDataList.instance.mapId);
         startGame();
      }
      
      override protected function init() : void
      {
         super.init();
         _UILayer.copyTimeLimit = false;
      }
      
      protected function startGame() : void
      {
         var textSprite:Sprite;
         var textBg:Scale9Image;
         var _text:TextField;
         Application.instance.currentGame.mainMenu.isEnable(true);
         this.visible = false;
         getMap().mapSolid = false;
         infoSprite.visible = false;
         addSelfToWorld(PlayerDataList.instance.bornPoint[MathHelper.randomWithinRange(0,1)]);
         selfCharacterCtrl.downStart();
         selfCharacterCtrl.slottingCompleteSignal.add(slottingCompleteSignalHandle);
         selfCharacterCtrl.actionCompeleteSignal.add(actionCompleteHandle);
         selfCharacterCtrl.dieSignal.addOnce(dieSignalHandle);
         selfCharacterCtrl.setServer(BattleServer.instance);
         selfCharacterCtrl.ctrlCompeleteSignal.add(ctrlCompeleteSignalHandle);
         addRobotToWorld(PlayerDataList.instance.bornPoint[MathHelper.randomWithinRange(2,3)]);
         robotCharacterCtrl.downStart();
         robotCharacterCtrl.attackTarget = selfCharacterCtrl.icharacter;
         robotCharacterCtrl.slottingCompleteSignal.add(slottingCompleteSignalHandle);
         robotCharacterCtrl.actionCompeleteSignal.add(actionCompleteHandle);
         robotCharacterCtrl.dieSignal.addOnce(dieSignalHandle);
         switchCtrl();
         UILayer.timer.timeoverSignal.add(onTimeOver);
         BattleServer.instance.onGameOver(onGameOver);
         BattleServer.instance.onLuckyDraw(onLuckyDraw);
         BattleServer.instance.onVipLuckyDraw(onLuckyDraw);
         BattleServer.instance.onFace(receiveFace);
         this.visible = true;
         Starling.juggler.delayCall(function():void
         {
            robotCharacterCtrl && robotCharacterCtrl.roleAttr;
         },2);
         if(Application.instance.currentGame._guideOptionsData.pos == "btRoom")
         {
            textSprite = new Sprite();
            textBg = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("tips_scale9"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
            textBg.width = 500;
            textBg.height = 90;
            _text = new TextField(500,90,LangManager.t("guide16"),"Verdana",32,16777215);
            _text.x = textBg.x;
            _text.y = textBg.y;
            _text.autoScale = true;
            textSprite.addChild(textBg);
            textSprite.addChild(_text);
            Starling.current.stage.addChild(textSprite);
            textSprite.x = 432;
            textSprite.y = 339;
            Starling.juggler.delayCall(function():void
            {
               textSprite.removeFromParent();
            },3);
            Application.instance.currentGame._guideOptionsData.pos = "mission";
         }
      }
      
      protected function ctrlCompeleteSignalHandle(param1:int) : void
      {
         UILayer.timer.stop();
      }
      
      protected function onTimeOver() : void
      {
         selfCharacterCtrl.ctrlStart(false);
         switchCtrl();
      }
      
      override public function onPassBtnHandle() : void
      {
         super.onPassBtnHandle();
         if(isMyCtrl())
         {
            switchCtrl();
         }
      }
      
      override protected function isMyCtrl() : Boolean
      {
         return currentCtrl == 1;
      }
      
      protected function onGameOver(param1:Object) : void
      {
         _gameOver = true;
         LevelLogger.getLogger("Battlefield-onGameOver").info(JSON.stringify(param1));
         var _loc2_:Image = this.myGo.target as Image;
         if(_loc2_.parent)
         {
            _loc2_.removeFromParent(true);
         }
         else
         {
            _loc2_.dispose();
         }
         Starling.juggler.remove(myGo);
         DisableAll.instance.enabled = true;
         this.UILayer.removeFromParent(true);
         Starling.juggler.delayCall(playWinOrLostMC,1,param1);
      }
      
      protected function playWinOrLostMC(param1:Object) : void
      {
         var winMovie:WinMovieClip;
         var lostMovie:LostMovieClip;
         var retData:Object = param1;
         var winner:Boolean = retData.data.winner == PlayerDataList.instance.selfData.team;
         MissionManager.instance.updateMissionData(103);
         MissionManager.instance.updateMissionData(134);
         if(winner)
         {
            MissionManager.instance.updateMissionData(135);
            winMovie = new WinMovieClip();
            addChild(winMovie);
            winMovie.x = 1365 >> 1;
            winMovie.y = 768 >> 1;
            winMovie.completeSignal.addOnce(function():void
            {
               winMovie.removeFromParent(true);
               showResultView(winner,retData);
            });
            winMovie.play(2);
            SoundManager.playSound("sound 27");
         }
         else
         {
            lostMovie = new LostMovieClip();
            addChild(lostMovie);
            lostMovie.x = 1365 >> 1;
            lostMovie.y = 768 >> 1;
            lostMovie.completeSignal.addOnce(function():void
            {
               lostMovie.removeFromParent(true);
               showResultView(winner,retData);
            });
            lostMovie.play(2);
            SoundManager.playSound("sound 28");
         }
      }
      
      protected function onLuckyDraw(param1:Object) : void
      {
         var retData:Object = param1;
         LevelLogger.getLogger("Battlefield-onLuckyDraw").info(JSON.stringify(retData));
         if(poker && poker.parent)
         {
            poker.overturnPoker(retData.data.cardNum,retData.data,function():void
            {
            });
         }
         else
         {
            Starling.juggler.delayCall(onLuckyDraw,2.5,retData);
         }
      }
      
      protected function showResultView(param1:Boolean, param2:Object) : void
      {
         var resultView:ResultView;
         var myteam:Array;
         var otherteam:Array;
         var playData:PlayerData;
         var exp:int;
         var myResultArr:Array;
         var i:int;
         var data:Array;
         var winner:Boolean = param1;
         var retData:Object = param2;
         if(RankListScreen.isRankFight)
         {
            DisableAll.instance.enabled = false;
            dispatchEventWith("showRank");
            return;
         }
         resultView = new ResultView(winner);
         addChild(resultView);
         DisableAll.instance.enabled = false;
         myteam = [];
         otherteam = [];
         _ovarFlopCount = retData.data.list.length;
         trace("_ovarFlopCount:",_ovarFlopCount);
         exp = 0;
         myResultArr = [0,0,0,0,0];
         i = 0;
         while(i < _ovarFlopCount)
         {
            playData = PlayerDataList.instance.getDataBySiteID(retData.data.list[i][0]);
            data = [playData.babyName,playData.level,retData.data.list[i][1]];
            if(retData.data.list[i][0] <= 1)
            {
               playData.exp += retData.data.list[i][1];
               exp = int(retData.data.list[i][1]);
               myteam.push(data);
               if(playData.siteID == PlayerDataList.instance.selfData.siteID)
               {
                  myResultArr = [exp,exp - retData.data.list[i][8],0,retData.data.list[i][8],0];
               }
            }
            else
            {
               otherteam.push(data);
            }
            i = i + 1;
         }
         resultView.setData(myResultArr,myteam,otherteam);
         resultView.completeSignal.addOnce(function():void
         {
            resultView.removeFromParent(true);
            rewardPoker();
         });
         resultView.play(5);
      }
      
      protected function rewardPoker() : void
      {
         var index:int = canOverturnPoker ? 1 : 0;
         poker = new PokerView(index);
         if(!canOverturnPoker)
         {
            poker.disableMsg = LangManager.t("unPoker");
         }
         addChild(poker);
         poker.play(8);
         poker.clickPokerSignal.add(function(param1:int):void
         {
            LevelLogger.getLogger("rewardPoker").info("玩家：" + PlayerDataList.instance.selfData.siteID + ", 发送翻牌命令--------牌的ID为：" + param1);
            BattleServer.instance.luckyDraw(param1);
         });
         poker.timeView.timeoverSignal.addOnce(function():void
         {
            if(poker.pokerNumSelf > 0)
            {
               poker.autoTurnCard();
            }
            Starling.juggler.delayCall(backToRoom,2);
         });
         PlayerDataList.instance.removePlayers();
      }
      
      protected function backToRoom() : void
      {
         BattleServer.instance.overFlop();
      }
      
      protected function dieSignalHandle(param1:int, param2:String) : void
      {
         var _loc5_:Object = null;
         var _loc3_:int = 0;
         _gameOver = true;
         trace("dieSignalHandle:",param1);
         var _loc4_:int = 0;
         if(param1 == PlayerDataList.instance.selfData.siteID)
         {
            _loc4_ = 1;
         }
         if(!__send)
         {
            BattleServer.instance.robotOver([_loc4_,myhurt,robothurt]);
            __send = true;
         }
         if(RankListScreen.isRankFight)
         {
            _loc5_ = {};
            _loc5_.data = {};
            _loc5_.data.list = [];
            _loc5_.data.winner = _loc4_;
            _loc5_.data.list.push([param1,0,_loc4_,myhurt,0,robothurt,0,0]);
            onGameOver(_loc5_);
            _loc3_ = _loc4_ == 0 ? 1 : 0;
            BattleServer.instance.sendRankFightWin(PlayerDataList.instance.selfData.uid,_robotUID,_loc3_,_robotName);
         }
      }
      
      protected function addRobotToWorld(param1:Point) : void
      {
         var _loc2_:PlayerData = PlayerDataList.instance.getRobotData();
         _robotName = _loc2_.babyName;
         _robotUID = _loc2_.uid;
         var _loc3_:Character = CharacterFactory.instance.checkOutCharacter(_loc2_.babySex);
         _loc3_.initData(_loc2_.getPropData());
         if(_loc2_.getWeapon() == null)
         {
            _loc3_.wearById(11,1091);
         }
         robotCharacterCtrl = new RobotCharacterCtrl(this,_loc3_,_loc2_.siteID,_loc2_.HP,_loc2_.babyName);
         this._charatersLayer.addChild(_loc3_);
         _loc3_.x = param1.x;
         _loc3_.y = param1.y;
         this.UILayer.addChar(_loc2_.siteID,_loc2_.team,_loc3_,_loc2_.HP);
      }
      
      protected function switchCtrl() : void
      {
         if(in_switchCtrl)
         {
            return;
         }
         in_switchCtrl = true;
         if(_gameOver)
         {
            return;
         }
         UILayer.timer.start(30);
         Starling.juggler.delayCall(function():void
         {
            if(_gameOver)
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
                  in_switchCtrl = false;
                  currentCtrl = 1;
               });
            }
            else
            {
               currentCtrl = 0;
               robotCharacterCtrl.ctrlStart(true);
               camera.swapFocus(robotCharacterCtrl.icharacter);
               in_switchCtrl = false;
            }
         },1);
         UILayer.updateRound(currentCtrl == 0 ? PlayerDataList.instance.selfData.siteID : 2,(MathHelper.randomWithinRange(0,1) == 0 ? -1 : 1) * MathHelper.randomWithinRange(1,5));
      }
      
      protected function slottingCompleteSignalHandle(param1:int, param2:Array) : void
      {
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         selfCharacterCtrl.downStart();
         robotCharacterCtrl.downStart();
         var _loc5_:int = int(param2[0]);
         if(_loc5_ == 2 || _loc5_ == 3)
         {
            return;
         }
         var _loc3_:Array = param2[4];
         trace(_loc3_);
         _loc6_ = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc4_ = dropHp(getCtrlBySiteID(_loc3_[_loc6_][7]),getCtrlBySiteID(_loc3_[_loc6_][0]),_loc3_[_loc6_][1]);
            if(_loc3_[_loc6_][0] == 2 && _loc3_[_loc6_][7] == 0)
            {
               canOverturnPoker = true;
               myhurt += _loc4_;
            }
            if(_loc3_[_loc6_][0] == 0 && _loc3_[_loc6_][7] == 2)
            {
               robothurt += _loc4_;
            }
            if(_loc3_[_loc6_][0] == 2)
            {
               UILayer.updateCharHP(2,robotCharacterCtrl.hp);
            }
            _loc6_++;
         }
      }
      
      protected function getCtrlBySiteID(param1:int) : CharacterCtrl
      {
         if(param1 == PlayerDataList.instance.selfData.siteID)
         {
            return selfCharacterCtrl;
         }
         return robotCharacterCtrl;
      }
      
      override public function addHp(param1:Array) : void
      {
         var _loc3_:CharacterCtrl = getCtrlBySiteID(param1[0]);
         var _loc2_:Character = _loc3_.character;
         _loc3_.hp += param1[1];
         UILayer.updateCharHP(param1[0],_loc3_.hp);
      }
      
      protected function actionCompleteHandle(param1:int = 0) : void
      {
         cameraFocusCtrlByTouch(true);
         switchCtrl();
      }
      
      protected function receiveFace(param1:Object) : void
      {
         var _loc7_:Point = null;
         var _loc6_:Point = null;
         var _loc4_:int = 0;
         var _loc5_:CharacterCtrl = null;
         var _loc3_:Point = null;
         Application.instance.log("接收对手表情:",JSON.stringify(param1));
         var _loc2_:int = int(param1.data.type);
         var _loc8_:int = int(param1.data.uid);
         if(_loc8_ == PlayerDataList.instance.selfData.uid)
         {
            trace(selfCharacterCtrl.self.x,selfCharacterCtrl.self.y,selfCharacterCtrl.self.centerY);
            _loc6_ = new Point(selfCharacterCtrl.self.x - selfCharacterCtrl.self.charWidth,selfCharacterCtrl.self.y - selfCharacterCtrl.self.charHeight);
            _loc7_ = gamePointToStagePoint(_loc6_);
         }
         else
         {
            _loc4_ = int(PlayerDataList.instance.getDataByUID(_loc8_).siteID);
            _loc5_ = getCtrlBySiteID(_loc4_);
            _loc3_ = new Point(_loc5_.character.x,_loc5_.character.y - _loc5_.character.charHeight);
            _loc7_ = gamePointToStagePoint(_loc3_);
            if(_loc7_.x < 0)
            {
               _loc7_.x = 0;
            }
            if(_loc7_.x > 1365)
            {
               _loc7_.x = 1365 - 124;
            }
            if(_loc7_.y < 0)
            {
               _loc7_.y = 0;
            }
            if(_loc7_.y > 768)
            {
               _loc7_.y = 768 - 124;
            }
         }
         playFaceById(_loc2_,_loc7_);
      }
      
      public function playFaceById(param1:int, param2:Point) : void
      {
         var _loc5_:TextureAtlas = Assets.sAsset.getTextureAtlas("emoticon");
         var _loc4_:Vector.<Texture> = _loc5_.getTextures(param1 + "A00");
         var _loc3_:MovieClip = new MovieClip(_loc4_,6);
         _loc3_.width = _loc3_.height = 124;
         _loc3_.x = param2.x;
         _loc3_.y = param2.y - _loc3_.height;
         trace("point" + param2);
         _loc3_.loop = false;
         _loc3_.touchable = false;
         stage.addChild(_loc3_);
         Starling.juggler.add(_loc3_);
         _loc3_.play();
         _loc3_.addEventListener("complete",onPlayComplete);
      }
      
      private function onPlayComplete(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.isComplete)
         {
            Starling.juggler.remove(_loc2_);
            _loc2_.removeFromParent(true);
         }
      }
      
      override public function dispose() : void
      {
         BattleServer.instance.disposeRecvFun(onGameOver);
         BattleServer.instance.disposeRecvFun(onLuckyDraw);
         BattleServer.instance.disposeRecvFun(receiveFace);
         if(robotCharacterCtrl)
         {
            robotCharacterCtrl.dispose();
         }
         Assets.btAsset.removeMapTexture(PlayerDataList.instance.mapId);
         Assets.btAsset.removeMapTexture(PlayerDataList.instance.mapId,"bg");
         UILayer.face.faceSingal.removeAll();
         super.dispose();
      }
   }
}

