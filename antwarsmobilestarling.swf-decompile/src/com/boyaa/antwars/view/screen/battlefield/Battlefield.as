package com.boyaa.antwars.view.screen.battlefield
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.DisableAll;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterCtrl;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.game.IGameWorld;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.PersonnalInfoDlg;
   import com.boyaa.antwars.view.screen.battlefield.element.CharBox;
   import com.boyaa.antwars.view.screen.battlefield.element.LostMovieClip;
   import com.boyaa.antwars.view.screen.battlefield.element.OtherCharacterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.element.PokerView;
   import com.boyaa.antwars.view.screen.battlefield.element.ResultView;
   import com.boyaa.antwars.view.screen.battlefield.element.SelfCharacterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.element.SkillBox;
   import com.boyaa.antwars.view.screen.battlefield.element.WinMovieClip;
   import com.boyaa.antwars.view.screen.battlefield.element.dropHpView;
   import com.boyaa.antwars.view.screen.chatRoom.FriendData;
   import com.boyaa.antwars.view.screen.chatRoom.FriendsList;
   import com.boyaa.antwars.view.screen.wedding.WeddingManager;
   import com.boyaa.debug.Logging.LevelLogger;
   import com.boyaa.tool.RandomNum;
   import com.joeonmars.camerafocus.StarlingCameraFocus;
   import com.joeonmars.camerafocus.events.CameraFocusEvent;
   import feathers.controls.Screen;
   import flash.geom.Point;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   
   public class Battlefield extends Screen implements IGameWorld
   {
      
      public const TIME:int = 30;
      
      protected var _camera:StarlingCameraFocus;
      
      private var myZoom:Number = 1;
      
      private var minZoom:Number = 1;
      
      private var maxZoom:Number = 2;
      
      private var map_bg:Image;
      
      private var map:BtMap;
      
      private var gameLayer:Sprite;
      
      protected var _charatersBGLayer:Sprite;
      
      protected var _charatersLayer:Sprite;
      
      protected var _ctrlInfoLayer:Sprite;
      
      public var _UILayer:BtUILayer;
      
      private var textureAtlas:ResAssetManager;
      
      public var selfCharacterCtrl:SelfCharacterCtrl;
      
      public var otherCtrls:Vector.<OtherCharacterCtrl>;
      
      private var _currentSeatId:int = 0;
      
      private var myGo:Tween;
      
      private var distance:Number = 0;
      
      private var focusTarget:Point = new Point();
      
      private var bronPoint:Vector.<Point> = new Vector.<Point>();
      
      protected var _mapCtrlByTouch:Boolean;
      
      public var wind:Number;
      
      public var bulletHitArr:Array = [];
      
      private var canOverturnPoker:Boolean = false;
      
      private var _gameOver:Boolean = false;
      
      private var _totalCDCount:int = 0;
      
      private var _deadSite:int = -1;
      
      private var _ovarFlopCount:int;
      
      private var poker:PokerView;
      
      private var isSendLand:Boolean = false;
      
      private var skill_2_count:int = 0;
      
      private var aboutme:PersonnalInfoDlg;
      
      private var aboutmeData:PlayerData;
      
      public function Battlefield()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         Application.instance.currentGame.currentWorld = this;
         Application.instance.log("BATTLEFIELD","initialize");
         textureAtlas = Assets.sAsset;
         this._ctrlInfoLayer = new Sprite();
         this._charatersLayer = new Sprite();
         this.charatersLayer.touchable = false;
         this._charatersBGLayer = new Sprite();
         this.charatersBGLayer.touchable = false;
         this.gameLayer = new Sprite();
         this.map = new BtMap(PlayerDataList.instance.mapId);
         map_bg = new Image(Assets.btAsset.getMapTexture(PlayerDataList.instance.mapId,"bg"));
         map_bg.touchable = false;
         map_bg.blendMode = "none";
         this.gameLayer.addChild(map_bg);
         this.gameLayer.addChild(map);
         this.gameLayer.addEventListener("touch",onTouchGameLayer);
         minZoom = Math.max(Starling.current.stage.width / this.map_bg.width,Starling.current.stage.height / this.map_bg.height);
         myZoom = minZoom;
         this.gameLayer.addChild(charatersBGLayer);
         this.gameLayer.addChild(charatersLayer);
         this.gameLayer.addChild(ctrlInfoLayer);
         this.addChild(gameLayer);
         this._UILayer = new BtUILayer();
         this._UILayer.setGameWorld(this);
         this.addChild(_UILayer);
         _UILayer.bomb.bombValue = 0;
         _UILayer.disable = true;
         _UILayer.timer.timeoverSignal.add(timeOverHandle);
         _UILayer.onPassBtnSignal.add(onPassBtnHandle);
         _UILayer.skillSignal.add(onUseSkillHandle);
         _UILayer.bombSignal.add(onBombHandle);
         _UILayer.usePlaneSignal.add(usePlaneSignalHandle);
         CharBox.aboutMeSignal.add(aboutMe);
         var _loc1_:Image = new Image(textureAtlas.getTexture("go"));
         _loc1_.y = Starling.current.stage.height - _loc1_.height - 100 >> 1;
         this.myGo = new Tween(_loc1_,2,"easeOutIn");
         gameStart();
         netInit();
         Starling.juggler.delayCall(Remoting.instance.apkPromo,5,4);
         PlayerDataList.instance.selfData.inFight = true;
         EventCenter.GameEvent.addEventListener("useSKill",onUseSkillFunction);
      }
      
      private function netInit() : void
      {
         bindNet();
      }
      
      private function bindNet() : void
      {
         BattleServer.instance.otherMove(otherMoveFromNet);
         BattleServer.instance.onSetSender(onSetSender);
         BattleServer.instance.syncAnger(syncAnger);
         BattleServer.instance.onBombPoint(onBombPoint);
         BattleServer.instance.onPlayerLeave(onPlayerLeave);
         BattleServer.instance.onLuckyDraw(onLuckyDraw);
         BattleServer.instance.onVipLuckyDraw(onLuckyDraw);
         BattleServer.instance.onUseProp(onUseProp);
         BattleServer.instance.onFace(receiveFace);
         BattleServer.instance.onGameOver(onGameOver);
         BattleServer.instance.onAntDropDead(onAntDropDead);
         BattleServer.instance.onChangeRoomOwner(onChangeRoomOwner);
         BattleServer.instance.onChangeWeaponDone(onPlayerChangeWeapon);
      }
      
      private function unBindNet() : void
      {
         BattleServer.instance.disposeRecvFun(otherMoveFromNet);
         BattleServer.instance.disposeRecvFun(onSetSender);
         BattleServer.instance.disposeRecvFun(syncAnger);
         BattleServer.instance.disposeRecvFun(onBombPoint);
         BattleServer.instance.disposeRecvFun(onPlayerLeave);
         BattleServer.instance.disposeRecvFun(onLuckyDraw);
         BattleServer.instance.disposeRecvFun(onUseProp);
         BattleServer.instance.disposeRecvFun(receiveFace);
         BattleServer.instance.disposeRecvFun(onGameOver);
         BattleServer.instance.disposeRecvFun(onAntDropDead);
         BattleServer.instance.disposeRecvFun(onChangeRoomOwner);
         BattleServer.instance.disposeRecvFun(onPlayerChangeWeapon);
      }
      
      private function onPlayerChangeWeapon(param1:Object) : void
      {
         Application.instance.log("onPlayerChangeWeapon-Battle",JSON.stringify(param1));
         if(param1.data.uid == PlayerDataList.instance.selfData.uid)
         {
            return;
         }
         var _loc3_:PlayerData = PlayerDataList.instance.getDataByUID(param1.data.uid);
         var _loc2_:GoodsData = new GoodsData();
         _loc2_.updateGoodsInfo(param1.data.weaponArr);
         getCtrlBySiteID(_loc3_.siteID).changeWeapon(_loc2_);
      }
      
      private function onChangeRoomOwner(param1:Object) : void
      {
         Application.instance.log("new room owner",JSON.stringify(param1));
         var _loc2_:PlayerData = PlayerDataList.instance.getDataByUID(param1.data.uid);
         _loc2_.houseOwner = 1;
      }
      
      private function charsInit() : void
      {
         buildSelfCharacter();
         buildOtherCharacter();
      }
      
      public function onChatMsg(param1:Object) : void
      {
         Application.instance.log("对战聊天",JSON.stringify(param1));
      }
      
      private function onSetSender(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc2_:CharacterCtrl = null;
         LevelLogger.getLogger("Battlefield5-onSetSender").info(JSON.stringify(param1));
         this.wind = param1.data.wind;
         this.currentSeatId = param1.data.siteID;
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            _loc2_ = getCtrlBySiteID(_loc3_);
            if(_loc2_)
            {
               _loc2_.ctrlStart(false);
            }
            _loc3_++;
         }
      }
      
      private function syncAnger(param1:Object) : void
      {
         LevelLogger.getLogger("Battlefield6-syncAnger").info(JSON.stringify(param1));
         UILayer.bomb.bombValue = param1.data;
      }
      
      private function gameStart() : void
      {
         _gameOver = false;
         bronPoint[0] = PlayerDataList.instance.bornPoint[RandomNum.myrand(0,PlayerDataList.instance.bornPoint.length / 2 - 1)];
         bronPoint[1] = PlayerDataList.instance.bornPoint[RandomNum.myrand(0,PlayerDataList.instance.bornPoint.length / 2 - 1)];
         bronPoint[2] = PlayerDataList.instance.bornPoint[RandomNum.myrand(PlayerDataList.instance.bornPoint.length / 2,PlayerDataList.instance.bornPoint.length - 1)];
         bronPoint[3] = PlayerDataList.instance.bornPoint[RandomNum.myrand(PlayerDataList.instance.bornPoint.length / 2,PlayerDataList.instance.bornPoint.length - 1)];
         charsInit();
         cameraInit();
      }
      
      private function onChangeWeapon(param1:Object) : void
      {
         var _loc3_:OtherCharacterCtrl = getOtherCtrlBySiteID(param1.data.siteID);
         var _loc2_:GoodsData = new GoodsData();
         _loc2_.updateGoodsInfo([]);
         _loc3_.changeWeapon(_loc2_);
      }
      
      private function otherMoveFromNet(param1:Object) : void
      {
         LevelLogger.getLogger("Battlefield7-otherMoveFromNet").info(JSON.stringify(param1));
         var _loc2_:OtherCharacterCtrl = getOtherCtrlBySiteID(param1.data.siteID);
         _loc2_.addSetpData(param1.data.data);
      }
      
      private function onBombPoint(param1:Object) : void
      {
         LevelLogger.getLogger("Battlefield8-onBombPoint").info(JSON.stringify(param1));
         if(param1.data.senderSiteID == selfCharacterCtrl.siteID)
         {
            for each(var _loc2_ in param1.data.hitArr)
            {
               if(!canOverturnPoker && _loc2_[0] != selfCharacterCtrl.siteID)
               {
                  canOverturnPoker = true;
               }
               dropHp(_loc2_,param1.data.senderSiteID);
            }
         }
         else
         {
            bulletHitArr.push(param1.data);
         }
      }
      
      private function onAntDropDead(param1:Object) : void
      {
         Application.instance.log("Battlefield-onAntDropDead",JSON.stringify(param1));
         var _loc2_:int = int(PlayerDataList.instance.getDataByUID(param1.data.uid).siteID);
      }
      
      private function onPlayerLeave(param1:Object) : void
      {
         var _loc3_:PlayerData = null;
         var _loc2_:int = 0;
         LevelLogger.getLogger("Battlefield9-onPlayerLeave").info(JSON.stringify(param1));
         if(param1.data.uid == PlayerDataList.instance.selfData.uid)
         {
            BattleServer.instance.close();
            Application.instance.currentGame.navigator.showScreen("HALL");
            TextTip.instance.show("你被请离游戏!");
         }
         else
         {
            _loc3_ = PlayerDataList.instance.getDataByUID(param1.data.uid);
            _loc2_ = int(_loc3_.siteID);
            UILayer.clearCharBySiteID(_loc2_);
            removeOtherPlayerBySiteID(_loc2_);
            _loc3_.leaving = true;
         }
      }
      
      private function removeOtherPlayerBySiteID(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:OtherCharacterCtrl = null;
         _loc3_ = 0;
         while(_loc3_ < otherCtrls.length)
         {
            _loc2_ = otherCtrls[_loc3_] as OtherCharacterCtrl;
            if(_loc2_ && _loc2_.siteID == param1)
            {
               _loc2_.ctrlStart(false);
               if(_loc2_.character)
               {
                  _loc2_.character.removeFromParent(true);
               }
               _loc2_.dispose();
               otherCtrls.splice(_loc3_,1);
            }
            _loc3_++;
         }
      }
      
      private function onGameOver(param1:Object) : void
      {
         trace("-----------告知游戏胜利和失败");
         _gameOver = true;
         LevelLogger.getLogger("Battlefield10").info(JSON.stringify(param1));
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
      
      private function playWinOrLostMC(param1:Object) : void
      {
         var winMovie:WinMovieClip;
         var lostMovie:LostMovieClip;
         var retData:Object = param1;
         var winner:Boolean = retData.data.winner == PlayerDataList.instance.selfData.team;
         MissionManager.instance.updateMissionData(103);
         MissionManager.instance.updateMissionData(134);
         if(WeddingManager.instance.isCoupleFight)
         {
            MissionManager.instance.updateMissionData(158);
         }
         if(winner)
         {
            if(PlayerDataList.instance.fightMode == 0 && PlayerDataList.instance.pk_type == 0)
            {
               MissionManager.instance.updateMissionData(135);
            }
            if(PlayerDataList.instance.fightMode == 0 && PlayerDataList.instance.pk_type == 1)
            {
               MissionManager.instance.updateMissionData(137);
            }
            if(WeddingManager.instance.isCoupleFight)
            {
               MissionManager.instance.updateMissionData(159);
            }
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
      
      private function onLuckyDraw(param1:Object) : void
      {
         var retData:Object = param1;
         LevelLogger.getLogger("Battlefield1").info(JSON.stringify(retData));
         if(poker)
         {
            poker.overturnPoker(retData.data.cardNum,retData.data,function():void
            {
            });
         }
      }
      
      private function onUseProp(param1:Object) : void
      {
         LevelLogger.getLogger("Battlefield2").info(JSON.stringify(param1));
         var _loc2_:PlayerData = PlayerDataList.instance.getDataByUID(param1.data.uid);
         if(_loc2_.siteID != selfCharacterCtrl.siteID)
         {
            trace("playData.siteID:",_loc2_.siteID);
            getCtrlBySiteID(_loc2_.siteID).useProp(param1.data.type);
         }
      }
      
      private function showResultView(param1:Boolean, param2:Object) : void
      {
         var myteam:Array;
         var otherteam:Array;
         var playData:PlayerData;
         var exp:int;
         var myResultArr:Array;
         var i:int;
         var data:Array;
         var winner:Boolean = param1;
         var retData:Object = param2;
         var resultView:ResultView = new ResultView(winner);
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
            if(playData.team == PlayerDataList.instance.selfData.team)
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
      
      private function rewardPoker() : void
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
            trace("[battlefield] 发送翻牌命令");
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
         PlayerDataList.instance.removeLeavingPlayers();
         if(PlayerDataList.instance.fightMode != 1)
         {
            if(PlayerDataList.instance.pk_type != 1)
            {
               PlayerDataList.instance.removePlayers();
            }
            else
            {
               PlayerDataList.instance.removeOtherTeamPlayers(PlayerDataList.instance.selfData.team);
            }
         }
      }
      
      private function backToRoom() : void
      {
         BattleServer.instance.overFlop();
         Application.instance.currentGame.navigator.showScreen("BTROOM");
      }
      
      private function cameraInit() : void
      {
         var _loc1_:Array = [{
            "name":"map_bg",
            "instance":this.map_bg,
            "ratio":0
         },{
            "name":"map",
            "instance":this.map,
            "ratio":0
         },{
            "name":"charatersBGLayer",
            "instance":this.charatersBGLayer,
            "ratio":0
         },{
            "name":"charatersLayer",
            "instance":this.charatersLayer,
            "ratio":0
         },{
            "name":"ctrlInfoLayer",
            "instance":this.ctrlInfoLayer,
            "ratio":0
         }];
         _camera = new StarlingCameraFocus(Starling.current.stage,gameLayer,selfCharacterCtrl.character,this.map,_loc1_,true);
         camera.swapStep = 5;
         camera.setBoundary(this.map);
         camera.zoomFocus(minZoom,0);
         addEventListener("enterFrame",onEnterFrameHandler);
         Starling.current.stage.addEventListener("hitBoundary",onHitBoundary);
      }
      
      private function onEnterFrameHandler(param1:EnterFrameEvent) : void
      {
         camera.update();
      }
      
      private function onHitBoundary(param1:CameraFocusEvent) : void
      {
      }
      
      public function cameraFocusCtrlByTouch(param1:Boolean) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         if(param1)
         {
            focusTarget.setTo(camera.focusTarget.x,camera.focusTarget.y);
            camera.focusTarget = focusTarget;
            this.mapCtrlByTouch = true;
         }
         else
         {
            this.mapCtrlByTouch = false;
            _loc2_ = stagePointToGamePoint(camera.focusPosition);
            camera.setDefaultFocusPosition();
            _loc3_ = stagePointToGamePoint(camera.focusPosition);
            focusTarget.setTo(camera.focusTarget.x + (_loc3_.x - _loc2_.x),camera.focusTarget.y + (_loc3_.x - _loc2_.y));
            trace("focusTarget:",focusTarget);
            camera.focusTarget = focusTarget;
            camera.jumpToFocus(focusTarget);
         }
      }
      
      private function onTouchGameLayer(param1:TouchEvent) : void
      {
         var _loc5_:Point = null;
         var _loc12_:Touch = null;
         var _loc11_:Touch = null;
         var _loc6_:Point = null;
         var _loc9_:Point = null;
         var _loc3_:Point = null;
         var _loc10_:Point = null;
         var _loc8_:Point = null;
         var _loc7_:Point = null;
         var _loc13_:Number = NaN;
         var _loc2_:Number = NaN;
         if(!this.mapCtrlByTouch)
         {
            return;
         }
         var _loc4_:Vector.<Touch> = param1.getTouches(this,"moved");
         if(_loc4_.length == 1)
         {
            _loc5_ = _loc4_[0].getMovement(parent);
            camera.setFocusPosition(camera.focusPosition.x + _loc5_.x * 2,camera.focusPosition.y + _loc5_.y * 2);
         }
         else if(_loc4_.length == 2)
         {
            _loc12_ = _loc4_[0];
            _loc11_ = _loc4_[1];
            _loc6_ = _loc12_.getLocation(parent);
            _loc9_ = _loc12_.getPreviousLocation(parent);
            _loc3_ = _loc11_.getLocation(parent);
            _loc10_ = _loc11_.getPreviousLocation(parent);
            _loc8_ = _loc6_.subtract(_loc3_);
            _loc7_ = _loc9_.subtract(_loc10_);
            _loc13_ = _loc8_.length / _loc7_.length;
            _loc2_ = camera.zoomFactor * _loc13_;
            if(_loc2_ >= minZoom && _loc2_ <= maxZoom)
            {
               camera.zoomFocus(_loc2_,3);
               myZoom = _loc2_;
            }
         }
      }
      
      private function buildSelfCharacter() : void
      {
         var character:Character = CharacterFactory.instance.checkOutCharacter(PlayerDataList.instance.selfData.babySex);
         character.initData(PlayerDataList.instance.selfData.getPropData());
         selfCharacterCtrl = new SelfCharacterCtrl(this,character,PlayerDataList.instance.selfData.siteID,PlayerDataList.instance.selfData.HP,PlayerDataList.instance.selfData.babyName);
         selfCharacterCtrl.ctrlInfoLayer = ctrlInfoLayer;
         selfCharacterCtrl.setServer(BattleServer.instance);
         selfCharacterCtrl.actionCompeleteSignal.add(actionCompeleteSignalHandle);
         selfCharacterCtrl.slottingCompleteSignal.add(slottingCompleteHandle);
         selfCharacterCtrl.ctrlStartSignal.add(myCtrlStartInit);
         selfCharacterCtrl.ctrlCompeleteSignal.add(ctrlEndSignalHandle);
         selfCharacterCtrl.dieSignal.addOnce(dieSignalHandle);
         selfCharacterCtrl.downStart();
         selfCharacterCtrl.downOkSignal.add(downOkSignalHandle);
         this.charatersLayer.addChild(character);
         character.x = bronPoint[PlayerDataList.instance.selfData.siteID].x;
         character.y = bronPoint[PlayerDataList.instance.selfData.siteID].y;
         Starling.juggler.delayCall(function():void
         {
            selfCharacterCtrl && selfCharacterCtrl.roleAttr;
         },1);
         this.UILayer.addChar(PlayerDataList.instance.selfData.siteID,PlayerDataList.instance.selfData.team,character,PlayerDataList.instance.selfData.HP);
      }
      
      private function buildOtherCharacter() : void
      {
         var _loc2_:Character = null;
         this.otherCtrls = new Vector.<OtherCharacterCtrl>();
         var _loc3_:int = 0;
         for each(var _loc1_ in PlayerDataList.instance.list)
         {
            if(_loc1_.uid != PlayerDataList.instance.selfData.uid)
            {
               _loc2_ = CharacterFactory.instance.checkOutCharacter(_loc1_.babySex);
               _loc2_.initData(_loc1_.getPropData());
               LevelLogger.getLogger("Battlefield3").info("buildOtherCharacter playerData.siteID:" + _loc1_.siteID + " mid:" + _loc1_.uid);
               this.otherCtrls[_loc3_] = new OtherCharacterCtrl(this,_loc2_,_loc1_.siteID,_loc1_.HP,_loc1_.babyName);
               otherCtrls[_loc3_].actionCompeleteSignal.add(actionCompeleteSignalHandle);
               otherCtrls[_loc3_].slottingCompleteSignal.add(slottingCompleteHandle);
               otherCtrls[_loc3_].ctrlCompeleteSignal.add(ctrlEndSignalHandle);
               otherCtrls[_loc3_].dieSignal.addOnce(dieSignalHandle);
               otherCtrls[_loc3_].downStart();
               this.charatersLayer.addChild(_loc2_);
               _loc2_.x = bronPoint[_loc1_.siteID].x;
               _loc2_.y = bronPoint[_loc1_.siteID].y;
               _loc3_++;
               this.UILayer.addChar(_loc1_.siteID,_loc1_.team,_loc2_,_loc1_.HP);
            }
         }
      }
      
      public function slottingCompleteHandle(param1:int, param2:Array) : void
      {
         var _loc5_:Object = null;
         var _loc7_:int = 0;
         var _loc6_:int = int(param2.shift());
         var _loc4_:* = param2;
         if(param1 == selfCharacterCtrl.siteID)
         {
            BattleServer.instance.sendCannonball(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3]);
         }
         else
         {
            while(bulletHitArr.length > 0)
            {
               _loc5_ = bulletHitArr.shift();
               for each(var _loc3_ in _loc5_.hitArr)
               {
                  dropHp(_loc3_,_loc5_.senderSiteID);
               }
            }
         }
         if(_loc6_ == 2 || _loc6_ == 3)
         {
            return;
         }
         selfCharacterCtrl.downStart();
         _loc7_ = 0;
         while(_loc7_ < otherCtrls.length)
         {
            otherCtrls[_loc7_].downStart();
            _loc7_++;
         }
         camera.shake(0.05,10);
      }
      
      public function actionCompeleteSignalHandle(param1:int) : void
      {
         BattleServer.instance.sendComplete();
         LevelLogger.getLogger("Battlefield4").info("actionCompeleteSignalHandle");
         var _loc2_:OtherCharacterCtrl = getOtherCtrlBySiteID(param1);
         if(_loc2_)
         {
            _loc2_.changeStatus("DOWN");
         }
         cameraFocusCtrlByTouch(true);
      }
      
      public function ctrlEndSignalHandle(param1:int) : void
      {
         UILayer.timer.stop();
      }
      
      public function dieSignalHandle(param1:int, param2:String) : void
      {
         var _loc3_:CharacterCtrl = null;
         if(param2 == "drop")
         {
            if(param1 == selfCharacterCtrl.siteID)
            {
               BattleServer.instance.sendDeductionHP();
            }
            else
            {
               _loc3_ = getCtrlBySiteID(param1);
               if(!_loc3_)
               {
                  return;
               }
               _loc3_.hp = 0;
               UILayer.updateCharHP(param1,_loc3_.hp);
            }
            BattleServer.instance.sendComplete();
         }
      }
      
      public function timeOverHandle() : void
      {
         if(isMyCtrl())
         {
            currentCharCtl.ctrlStart(false);
            selfCharacterCtrl.sendData();
            BattleServer.instance.sendOvertime();
         }
      }
      
      public function downOkSignalHandle() : void
      {
         if(!isSendLand)
         {
            selfCharacterCtrl.sendMoveToServer();
            BattleServer.instance.sendLand();
            isSendLand = true;
         }
         else
         {
            selfCharacterCtrl.sendMoveToServer();
         }
      }
      
      public function onPassBtnHandle() : void
      {
         if(isMyCtrl())
         {
            BattleServer.instance.giveUp();
            UILayer.timer.stop();
            UILayer.timer.timeoverSignal.dispatch();
         }
      }
      
      private function onUseSkillFunction(param1:GameEvent) : void
      {
         var _loc2_:Object = param1.param as Object;
         if(_loc2_.skillId == 2)
         {
            skill_2_count = skill_2_count + 1;
            if(skill_2_count > 1)
            {
               return;
            }
         }
         selfCharacterCtrl.useSkillById(_loc2_.skillId);
      }
      
      public function onUseSkillHandle(param1:SkillBox) : void
      {
         if(param1.skillId == 2)
         {
            skill_2_count = skill_2_count + 1;
            if(skill_2_count > 1)
            {
               return;
            }
         }
         selfCharacterCtrl.usePropBySkillBox(param1);
      }
      
      public function onBombHandle() : void
      {
         selfCharacterCtrl.useAnger();
      }
      
      public function usePlaneSignalHandle() : void
      {
         selfCharacterCtrl.usePlane();
      }
      
      private function _selectSeatId(param1:EnterFrameEvent) : void
      {
         if(Starling.juggler.contains(selfCharacterCtrl) || Starling.juggler.contains(otherCtrls[0]))
         {
            return;
         }
         if(this.currentSeatId == 2 || this.currentSeatId == 0)
         {
            this.currentSeatId = 1;
         }
         else
         {
            this.currentSeatId++;
         }
      }
      
      private function myCtrlStartInit(param1:Boolean) : void
      {
         if(param1)
         {
            selfCharacterCtrl.actionPoint = selfCharacterCtrl.roleAttr[7];
            UILayer.timer.start(30);
            skill_2_count = 0;
            _totalCDCount = _totalCDCount + 1;
         }
      }
      
      private function set currentSeatId(param1:int) : void
      {
         var otherCtr:OtherCharacterCtrl;
         var id:int = param1;
         this._currentSeatId = id;
         UILayer.updateRound(id,this.wind);
         if(this._currentSeatId == PlayerDataList.instance.selfData.siteID)
         {
            playMyGo(function():void
            {
               if(_gameOver)
               {
                  return;
               }
               selfCharacterCtrl.ctrlStart(true);
               if(camera.focusTarget.x != selfCharacterCtrl.character.x || camera.focusTarget.y != selfCharacterCtrl.character.y)
               {
                  camera.swapFocus(selfCharacterCtrl.character);
               }
            });
            cameraFocusCtrlByTouch(false);
            camera.enableCallBack = true;
            camera.swapFocus(selfCharacterCtrl.character,10,true,myZoom);
            Starling.current.stage.addEventListener("swapFinished",function(param1:CameraFocusEvent):void
            {
               Starling.current.stage.removeEventListeners("swapFinished");
               camera.enableCallBack = false;
               if(!_gameOver)
               {
                  camera.enableCallBack = false;
                  cameraFocusCtrlByTouch(true);
               }
            });
            for each(otherCtr in otherCtrls)
            {
               otherCtr.ctrlStart(false);
            }
         }
         else
         {
            Starling.juggler.delayCall(function():void
            {
               if(!_gameOver)
               {
                  UILayer.timer.start(30);
                  otherCtr = getOtherCtrlBySiteID(id);
                  otherCtr.ctrlStart(true);
                  cameraFocusCtrlByTouch(true);
               }
            },1.5);
         }
      }
      
      private function receiveFace(param1:Object) : void
      {
         var _loc7_:Point = null;
         var _loc6_:Point = null;
         var _loc4_:int = 0;
         var _loc5_:OtherCharacterCtrl = null;
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
            _loc5_ = getOtherCtrlBySiteID(_loc4_);
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
      
      private function getCtrlBySiteID(param1:int) : CharacterCtrl
      {
         if(selfCharacterCtrl.siteID == param1)
         {
            return selfCharacterCtrl;
         }
         return getOtherCtrlBySiteID(param1);
      }
      
      private function getOtherCtrlBySiteID(param1:int) : OtherCharacterCtrl
      {
         for each(var _loc2_ in otherCtrls)
         {
            if(_loc2_.siteID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function playMyGo(param1:Function) : void
      {
         var onComplete:Function = param1;
         var myGoImage:Image = this.myGo.target as Image;
         myGoImage.touchable = false;
         this.addChild(myGoImage);
         myGoImage.x = Assets.rightCenter.x;
         this.myGo.reset(myGoImage,1.5,"easeOutIn");
         this.myGo.onComplete = function():void
         {
            onComplete();
            myGoImage.removeFromParent();
            Starling.juggler.remove(myGo);
         };
         this.myGo.animate("x",Assets.leftTop.x - myGoImage.width);
         Starling.juggler.add(this.myGo);
      }
      
      private function get currentSeatId() : int
      {
         return _currentSeatId;
      }
      
      private function get currentCharCtl() : CharacterCtrl
      {
         if(isMyCtrl())
         {
            return selfCharacterCtrl;
         }
         return getOtherCtrlBySiteID(this.currentSeatId);
      }
      
      private function isMyCtrl() : Boolean
      {
         return this.currentSeatId == PlayerDataList.instance.selfData.siteID;
      }
      
      private function dropHp(param1:Array, param2:int) : void
      {
         var _loc5_:CharacterCtrl = getCtrlBySiteID(param1[0]);
         var _loc3_:Character = _loc5_.character;
         if(param1[0] == param2 && _loc5_.hp <= param1[1])
         {
            _loc5_.hp = 1;
         }
         else
         {
            _loc5_.hp -= param1[1];
         }
         UILayer.updateCharHP(param1[0],_loc5_.hp);
         var _loc4_:dropHpView = new dropHpView(new Point(_loc3_.x + 30,_loc3_.y - _loc3_.height),param1[1]);
         _loc4_.scaleX = _loc4_.scaleY = 0.8;
         this.gameLayer.addChild(_loc4_);
      }
      
      public function addHp(param1:Array) : void
      {
         var _loc3_:CharacterCtrl = getCtrlBySiteID(param1[0]);
         var _loc2_:Character = _loc3_.character;
         _loc3_.hp += param1[1];
         UILayer.updateCharHP(param1[0],_loc3_.hp);
      }
      
      public function aboutMe(param1:int) : void
      {
         var _loc2_:PlayerData = PlayerDataList.instance.getDataBySiteID(param1);
         aboutmeData = _loc2_;
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
         FriendsList.instance.addDataAboutme(param1);
         aboutme.showPlayerInfo(param1);
         var _loc4_:Object = (param1 as Array)[1];
         var _loc2_:FriendData = new FriendData();
         var _loc3_:Array = [];
         _loc3_.push(_loc4_.mid,_loc4_.mrolename,_loc4_.mlevel);
         _loc2_.readData(_loc3_);
         aboutme.setData(_loc2_);
      }
      
      private function updateAboutme(param1:PlayerData) : void
      {
         var _loc2_:FriendData = null;
         var _loc3_:Array = null;
         if(FriendsList.instance.isLoadedAboutMe(param1.uid))
         {
            aboutme.showPlayerInfo(FriendsList.instance.getDataAboutme(param1.uid));
            _loc2_ = new FriendData();
            _loc3_ = [];
            _loc3_.push(param1.uid,param1.name,param1.level);
            _loc2_.readData(_loc3_);
            aboutme.setData(_loc2_);
         }
         else
         {
            Remoting.instance.getMemStatus(param1.uid,getPlayerInfo);
         }
      }
      
      public function stagePointToGamePoint(param1:Point) : Point
      {
         return this.getGameLayer().globalToLocal(param1);
      }
      
      public function gamePointToStagePoint(param1:Point) : Point
      {
         return this.getGameLayer().localToGlobal(param1);
      }
      
      override protected function draw() : void
      {
      }
      
      public function getMap() : BtMap
      {
         return this.map;
      }
      
      public function getGameLayer() : Sprite
      {
         return this.gameLayer;
      }
      
      public function getMoveButton() : Sprite
      {
         return UILayer.arrowSprite;
      }
      
      override public function dispose() : void
      {
         Application.instance.log("BATTLEFIELD","dispose");
         _gameOver = true;
         PlayerDataList.instance.selfData.inFight = false;
         EventCenter.GameEvent.removeEventListener("useSKill",onUseSkillFunction);
         this.gameLayer.removeEventListener("touch",onTouchGameLayer);
         CharacterFactory.instance.checkInCharacter(selfCharacterCtrl.character);
         selfCharacterCtrl.dispose();
         for each(var _loc1_ in otherCtrls)
         {
            CharacterFactory.instance.checkInCharacter(_loc1_.character);
            _loc1_.dispose();
         }
         unBindNet();
         removeEventListener("enterFrame",onEnterFrameHandler);
         Starling.current.stage.removeEventListener("hitBoundary",onHitBoundary);
         aboutme && aboutme.dispose();
         super.dispose();
         Assets.btAsset.removeMapTexture(PlayerDataList.instance.mapId);
         Assets.btAsset.removeMapTexture(PlayerDataList.instance.mapId,"bg");
      }
      
      public function get totalCDCount() : int
      {
         return _totalCDCount;
      }
      
      public function get mapBackCharatersLayer() : Sprite
      {
         return null;
      }
      
      public function get UILayer() : BtUILayer
      {
         return _UILayer;
      }
      
      public function get mapCtrlByTouch() : Boolean
      {
         return _mapCtrlByTouch;
      }
      
      public function set mapCtrlByTouch(param1:Boolean) : void
      {
         _mapCtrlByTouch = param1;
      }
      
      public function get ctrlInfoLayer() : Sprite
      {
         return _ctrlInfoLayer;
      }
      
      public function get charatersBGLayer() : Sprite
      {
         return _charatersBGLayer;
      }
      
      public function get camera() : StarlingCameraFocus
      {
         return _camera;
      }
      
      public function get charatersLayer() : Sprite
      {
         return _charatersLayer;
      }
   }
}

