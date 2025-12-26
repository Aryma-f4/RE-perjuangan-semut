package com.boyaa.antwars.view.game
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.helper.autoFight.AutoFightManager;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterCtrl;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.monster.MonsterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.BtMap;
   import com.boyaa.antwars.view.screen.battlefield.BtUILayer;
   import com.boyaa.antwars.view.screen.battlefield.element.LostMovieClip;
   import com.boyaa.antwars.view.screen.battlefield.element.SelfCharacterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.element.SkillBox;
   import com.boyaa.antwars.view.screen.battlefield.element.WinMovieClip;
   import com.boyaa.antwars.view.screen.battlefield.element.dropHpView;
   import com.boyaa.antwars.view.screen.copygame.ReliveControl;
   import com.boyaa.antwars.view.vipSystem.VipManager;
   import com.joeonmars.camerafocus.StarlingCameraFocus;
   import feathers.controls.Screen;
   import feathers.controls.ScreenNavigator;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import org.osflash.signals.Signal;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class GameWorld extends Screen implements IGameWorld
   {
      
      public static var energyLight:BitmapData = null;
      
      private static var cdCount:int = 0;
      
      protected static var sHelperPoint:Point = new Point();
      
      public const TIME:int = 17;
      
      protected var _camera:StarlingCameraFocus;
      
      protected var myZoom:Number = 1;
      
      protected var minZoom:Number = 1;
      
      protected var maxZoom:Number = 2;
      
      private var map_bg:Image;
      
      protected var map:BtMap;
      
      private var gameLayer:Sprite;
      
      protected var _charatersBGLayer:Sprite;
      
      protected var _charatersLayer:Sprite;
      
      protected var _ctrlInfoLayer:Sprite;
      
      protected var _mapBackCharatersLayer:Sprite;
      
      private var textureAtlas:ResAssetManager;
      
      protected var _UILayer:BtUILayer;
      
      protected var myGo:Tween;
      
      protected var _mapCtrlByTouch:Boolean = true;
      
      public var selfCharacterCtrl:SelfCharacterCtrl;
      
      private var focusTarget:Point = new Point();
      
      protected var downStart:Boolean = true;
      
      public var txtLeftNum:TextField;
      
      public var txtBg:Quad;
      
      public var infoSprite:Sprite;
      
      protected var stateSignal:Signal;
      
      protected var navigator:ScreenNavigator;
      
      protected var _totalCDCount:int = 0;
      
      private var _energyLightImg:Image = null;
      
      private var _playerReliveCount:int = 0;
      
      private var skill_2_count:int = 0;
      
      protected var stateObject:Object = {};
      
      public function GameWorld()
      {
         super();
      }
      
      protected function init() : void
      {
         Application.instance.currentGame.currentWorld = this;
         textureAtlas = Assets.sAsset;
         _UILayer = new BtUILayer();
         _UILayer.setGameWorld(this);
         ReliveControl.instance.setGameWorld(this);
         var _loc1_:Image = new Image(textureAtlas.getTexture("go"));
         _loc1_.y = Starling.current.stage.height - _loc1_.height - 100 >> 1;
         this.myGo = new Tween(_loc1_,2,"easeOutIn");
         stateSignal = new Signal(ICharacterCtrl);
         stateSignal.add(clearBadState);
         navigator = Application.instance.currentGame.navigator;
         Starling.juggler.delayCall(Remoting.instance.apkPromo,5,4);
         PlayerDataList.instance.selfData.inFight = true;
         Application.instance.log("玩家最大血量：",PlayerDataList.instance.selfData.HP.toString());
      }
      
      protected function buildWorld(param1:int) : void
      {
         _ctrlInfoLayer = new Sprite();
         _charatersLayer = new Sprite();
         _charatersLayer.touchable = false;
         _charatersBGLayer = new Sprite();
         _charatersBGLayer.touchable = false;
         _mapBackCharatersLayer = new Sprite();
         infoSprite = new Sprite();
         infoSprite.touchable = false;
         txtBg = new Quad(170,50,5592405,true);
         txtBg.alpha = 0.4;
         txtBg.x = 0;
         txtBg.y = 0;
         infoSprite.addChild(txtBg);
         txtLeftNum = new TextField(200,25,"","Verdana",16,16777215);
         txtLeftNum.x = txtBg.x + (txtBg.width - txtLeftNum.width) / 2;
         txtLeftNum.y = txtBg.y + (txtBg.height - txtLeftNum.height) / 2;
         infoSprite.addChild(txtLeftNum);
         _UILayer.addChild(infoSprite);
         infoSprite.x = Assets.rightTop.x - infoSprite.width;
         infoSprite.y = Assets.rightTop.y + infoSprite.height * 2;
         this.gameLayer = new Sprite();
         this.map = new BtMap(param1);
         map_bg = new Image(Assets.btAsset.getMapTexture(param1,"bg"));
         map_bg.touchable = false;
         map_bg.blendMode = "none";
         this.gameLayer.addChild(map_bg);
         this.gameLayer.addChild(_mapBackCharatersLayer);
         this.gameLayer.addChild(map);
         energyLight = null;
         if(param1 == 208)
         {
            energyLight = Assets.btAsset.getBitmapData("energyLight");
            _energyLightImg = new Image(Assets.btAsset.getTexture("energyLight"));
            this.gameLayer.addChild(_energyLightImg);
         }
         this.gameLayer.addEventListener("touch",onTouchGameLayer);
         minZoom = Math.max(Starling.current.stage.width / this.map_bg.width,Starling.current.stage.height / this.map_bg.height);
         this.gameLayer.addChild(_charatersBGLayer);
         this.gameLayer.addChild(_charatersLayer);
         this.gameLayer.addChild(_ctrlInfoLayer);
         this.addChild(gameLayer);
         addChild(_UILayer);
         _UILayer.disable = true;
         var _loc2_:Array = [{
            "name":"map_bg",
            "instance":this.map_bg,
            "ratio":0
         },{
            "name":"mapBackCharatersLayer",
            "instance":_mapBackCharatersLayer,
            "ratio":0
         },{
            "name":"map",
            "instance":this.map,
            "ratio":0
         },{
            "name":"charatersBGLayer",
            "instance":_charatersBGLayer,
            "ratio":0
         },{
            "name":"charatersLayer",
            "instance":_charatersLayer,
            "ratio":0
         },{
            "name":"ctrlInfoLayer",
            "instance":_ctrlInfoLayer,
            "ratio":0
         }];
         _camera = new StarlingCameraFocus(Starling.current.stage,gameLayer,focusTarget,this.map,_loc2_,true);
         _camera.swapStep = 5;
         _camera.setBoundary(this.map);
         camera.zoomFocus(minZoom,0);
         addEventListener("enterFrame",onEnterFrameHandler);
         GameServer.instance.getAutoFightTimes(onAutoFightTimeHandle);
      }
      
      private function onAutoFightTimeHandle(param1:Object) : void
      {
         Application.instance.log("onAutoFightTimeHandle",JSON.stringify(param1));
         VipManager.instance.vipPowerData.autoFightTime = param1.data.todayCount;
      }
      
      public function addCharacter(param1:ICharacter) : void
      {
         if(param1 is Sprite)
         {
            this._charatersLayer.addChild(param1 as Sprite);
         }
      }
      
      public function removeCharacter(param1:ICharacter) : void
      {
         if(param1 is Sprite)
         {
            this._charatersLayer.removeChild(param1 as Sprite);
         }
      }
      
      public function getGameLayer() : Sprite
      {
         return gameLayer;
      }
      
      public function getMap() : BtMap
      {
         return map;
      }
      
      public function getMoveButton() : Sprite
      {
         return UILayer.arrowSprite;
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
      
      public function get charatersLayer() : Sprite
      {
         return _charatersLayer;
      }
      
      public function get camera() : StarlingCameraFocus
      {
         return _camera;
      }
      
      public function get mapBackCharatersLayer() : Sprite
      {
         return _mapBackCharatersLayer;
      }
      
      public function get totalCDCount() : int
      {
         return _totalCDCount;
      }
      
      public function get playerReliveCount() : int
      {
         return _playerReliveCount;
      }
      
      public function set playerReliveCount(param1:int) : void
      {
         _playerReliveCount = param1;
      }
      
      public function cameraFocusCtrlByTouch(param1:Boolean) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         if(param1 && camera.focusTarget)
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
            trace("focusTarget>:",focusTarget);
            if(!isNaN(focusTarget.x) && !isNaN(focusTarget.y))
            {
               camera.jumpToFocus(focusTarget);
            }
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
      
      public function addHp(param1:Array) : void
      {
         if(PlayerDataList.instance.selfData.siteID == param1[0])
         {
            selfCharacterCtrl.hp += param1[1];
            UILayer.updateCharHP(param1[0],selfCharacterCtrl.hp);
         }
      }
      
      protected function addSelfToWorld(param1:Point) : void
      {
         var pt:Point = param1;
         var character:Character = CharacterFactory.instance.checkOutCharacter(PlayerDataList.instance.selfData.babySex);
         character.initData(PlayerDataList.instance.selfData.getPropData());
         selfCharacterCtrl = new SelfCharacterCtrl(this,character,PlayerDataList.instance.selfData.siteID,PlayerDataList.instance.selfData.HP,PlayerDataList.instance.selfData.babyName);
         selfCharacterCtrl.ctrlInfoLayer = ctrlInfoLayer;
         this._charatersLayer.addChild(character);
         character.x = pt.x;
         character.y = pt.y;
         selfCharacterCtrl.slottingCompleteSignal.add(slottingSignalHandle);
         selfCharacterCtrl.ctrlStartSignal.add(myCtrlStartInit);
         selfCharacterCtrl.ctrlCompeleteSignal.add(myCtrlEndSignal);
         _camera.focusTarget = selfCharacterCtrl.icharacter;
         this.UILayer.addChar(PlayerDataList.instance.selfData.siteID,PlayerDataList.instance.selfData.team,character,PlayerDataList.instance.selfData.HP);
         _UILayer.onPassBtnSignal.add(onPassBtnHandle);
         _UILayer.skillSignal.add(onUseSkillHandle);
         _UILayer.bombSignal.add(onBombHandle);
         _UILayer.usePlaneSignal.add(usePlaneSignalHandle);
         Starling.juggler.delayCall(function():void
         {
            selfCharacterCtrl && selfCharacterCtrl.roleAttr;
         },1);
         EventCenter.GameEvent.addEventListener("useSKill",onUseSkillFunction);
      }
      
      private function onUseSkillFunction(param1:GameEvent) : void
      {
         var _loc2_:Object = param1.param as Object;
         if(!selfCharacterCtrl.canUseProp)
         {
            TextTip.instance.show(LangManager.t(selfCharacterCtrl.character.badState + "Info"));
            return;
         }
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
      
      private function myCtrlEndSignal(param1:int) : void
      {
      }
      
      protected function slottingSignalHandle(param1:int, param2:Array) : void
      {
         var _loc5_:int = 0;
         var _loc3_:ICharacter = null;
         var _loc4_:int = int(param2[0]);
         if(_loc4_ == 2 || _loc4_ == 3)
         {
            return;
         }
         _loc5_ = _charatersLayer.numChildren - 1;
         while(_loc5_ >= 0)
         {
            _loc3_ = _charatersLayer.getChildAt(_loc5_) as ICharacter;
            _loc3_.icharacterCtrl.downStatus = true;
            _loc5_--;
         }
         camera.shake(0.05,10);
      }
      
      protected function myCtrlStartInit(param1:Boolean) : void
      {
         if(param1)
         {
            if(!selfCharacterCtrl.isInFresh)
            {
               selfCharacterCtrl.actionPoint = selfCharacterCtrl.roleAttr[7];
               skill_2_count = 0;
               UILayer.bomb.bombValue += 10;
            }
            _totalCDCount = _totalCDCount + 1;
         }
      }
      
      public function onUseSkillHandle(param1:SkillBox) : void
      {
         if(!selfCharacterCtrl.canUseProp)
         {
            TextTip.instance.show(LangManager.t(selfCharacterCtrl.character.badState + "Info"));
            return;
         }
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
      
      public function onPassBtnHandle() : void
      {
         if(isMyCtrl())
         {
            UILayer.bomb.bombValue += 10;
            selfCharacterCtrl.ctrlStart(false);
         }
      }
      
      protected function isMyCtrl() : Boolean
      {
         return false;
      }
      
      public function onBombHandle() : void
      {
         selfCharacterCtrl.useAnger();
      }
      
      public function usePlaneSignalHandle() : void
      {
         selfCharacterCtrl.usePlane();
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
         if(!_mapCtrlByTouch)
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
      
      private function onEnterFrameHandler(param1:EnterFrameEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:ICharacter = null;
         camera.update();
         update(param1.passedTime);
         if(downStart)
         {
            _loc3_ = _charatersLayer.numChildren - 1;
            while(_loc3_ >= 0)
            {
               _loc2_ = _charatersLayer.getChildAt(_loc3_) as ICharacter;
               down(_loc2_);
               _loc3_--;
            }
         }
      }
      
      protected function update(param1:Number) : void
      {
      }
      
      override protected function draw() : void
      {
      }
      
      protected function down(param1:ICharacter, param2:Number = 0) : void
      {
         if(param1.icharacterCtrl.downStatus)
         {
            sHelperPoint.setTo(param1.x,param1.y);
            while(!param1.hitMap(sHelperPoint.x,sHelperPoint.y,this.getMap()))
            {
               sHelperPoint.y++;
               if(sHelperPoint.y > this.getMap().mapHeight + 20)
               {
                  break;
               }
            }
            (param1 as DisplayObject).y = sHelperPoint.y;
            param1.icharacterCtrl.downStatus = false;
            if(param1.icharacterCtrl is SelfCharacterCtrl)
            {
               (param1.icharacterCtrl as SelfCharacterCtrl).sendMoveToServer();
            }
         }
      }
      
      protected function playMyGo(param1:Function) : void
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
            AutoFightManager.instance.startShoot(selfCharacterCtrl);
         };
         this.myGo.animate("x",Assets.leftTop.x - myGoImage.width);
         Starling.juggler.add(this.myGo);
         SoundManager.playSound("sound 26");
      }
      
      protected function stateOfParalysis(param1:ICharacterCtrl, param2:String = "", param3:ICharacterCtrl = null) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(stateObject[param1] == null)
         {
            stateObject[param1] = {};
         }
         switch(param2)
         {
            case "palsy":
               _loc4_ = [];
               if(stateObject[param1]["palsy"])
               {
                  _loc5_ = 0;
                  while(_loc5_ < 4)
                  {
                     param1.roleAttr[_loc5_] = stateObject[param1]["palsy"][_loc5_];
                     _loc5_++;
                  }
                  stateObject[param1].palsy = null;
               }
               _loc5_ = 0;
               while(_loc5_ < 4)
               {
                  _loc4_.push(param1.roleAttr[_loc5_]);
                  param1.roleAttr[_loc5_] *= 0.8;
                  _loc5_++;
               }
               stateObject[param1].palsy = _loc4_;
               CharacterCtrl(param1).setBadState("palsy");
               break;
            case "chain":
               stateObject[param1].chain = "true";
               CharacterCtrl(param1).setBadState("chain");
               CharacterCtrl(param1).setWhatCanIDo(0,0,0);
         }
         if(param1.siteID == PlayerDataList.instance.selfData.siteID)
         {
            TextTip.instance.showByLang(param2 + "Name");
         }
         cdCount = param1.gameworld.totalCDCount;
         trace(cdCount);
      }
      
      protected function clearBadState(param1:ICharacterCtrl) : void
      {
         var _loc3_:int = 0;
         if(stateObject[param1] == null)
         {
            return;
         }
         var _loc2_:int = 0;
         if(!param1.gameworld)
         {
            return;
         }
         _loc2_ = param1.gameworld.totalCDCount - cdCount;
         if(stateObject[param1].palsy)
         {
            switch(_loc2_ - 1)
            {
               case 0:
                  CharacterCtrl(param1).setWhatCanIDo(0);
                  break;
               case 1:
                  _loc3_ = 0;
                  while(_loc3_ < 4)
                  {
                     param1.roleAttr[_loc3_] = stateObject[param1]["palsy"][_loc3_];
                     _loc3_++;
                  }
                  stateObject[param1].palsy = null;
                  if(param1 is SelfCharacterCtrl)
                  {
                     TextTip.instance.show(LangManager.t("clearBadState"));
                  }
                  CharacterCtrl(param1).setWhatCanIDo(1);
                  CharacterCtrl(param1).setBadState();
            }
         }
         else if(stateObject[param1].chain)
         {
            switch(_loc2_ - 1)
            {
               case 0:
                  if(param1 is SelfCharacterCtrl)
                  {
                     TextTip.instance.show(LangManager.t("clearBadState"));
                  }
                  stateObject[param1].chain = null;
                  CharacterCtrl(param1).setWhatCanIDo();
                  CharacterCtrl(param1).setBadState();
            }
         }
      }
      
      protected function getLossHp(param1:ICharacterCtrl, param2:ICharacterCtrl, param3:Boolean = false) : Array
      {
         var _loc5_:int = (param1.roleAttr[4] * 350 / (param2.roleAttr[5] + 400) + 0.175 * param1.roleAttr[0] * 800 / (param2.roleAttr[1] + 800)) * MathHelper.randomNumberWithinRange(0.9,1);
         _loc5_ = _loc5_ * param1.hurtfactor / 1000;
         _loc5_ = _loc5_ * param1.hurtplus / 1000;
         var _loc7_:int = param1.roleAttr[3] * 1000 / (param1.roleAttr[3] + 2000);
         var _loc4_:int = MathHelper.randomWithinRange(0,1000);
         var _loc6_:* = _loc4_ - _loc7_ < 0;
         if(_loc6_)
         {
            _loc5_ = _loc5_ * 15 * (2400 + param1.roleAttr[3]) / 24000;
         }
         if(param3)
         {
            _loc5_ *= 0.75;
         }
         trace("getLossHp:",_loc5_,"isPower:",_loc6_);
         return [_loc5_,_loc6_];
      }
      
      protected function dropHp(param1:ICharacterCtrl, param2:ICharacterCtrl, param3:Boolean = false) : int
      {
         var _loc5_:int = (param1.roleAttr[4] * 350 / (param2.roleAttr[5] + 400) + 0.175 * param1.roleAttr[0] * 800 / (param2.roleAttr[1] + 800)) * MathHelper.randomNumberWithinRange(0.9,1);
         trace("dropHp:",_loc5_);
         _loc5_ = _loc5_ * param1.hurtfactor / 1000;
         _loc5_ = _loc5_ * param1.hurtplus / 1000;
         var _loc7_:int = param1.roleAttr[3] * 1000 / (param1.roleAttr[3] + 2000);
         var _loc4_:int = MathHelper.randomWithinRange(0,1000);
         var _loc6_:* = _loc4_ - _loc7_ < 0;
         if(_loc6_)
         {
            _loc5_ = _loc5_ * 15 * (2400 + param1.roleAttr[3]) / 24000;
         }
         if(param3)
         {
            _loc5_ *= 0.75;
         }
         if(param2 == param1 && param2.hp <= _loc5_)
         {
            param2.hp = 1;
         }
         else
         {
            param2.hp -= _loc5_;
         }
         if(param2 is SelfCharacterCtrl)
         {
            UILayer.bomb.bombValue += _loc5_ * 100 / PlayerDataList.instance.selfData.HP;
            UILayer.updateCharHP(PlayerDataList.instance.selfData.siteID,param2.hp);
         }
         var _loc8_:dropHpView = new dropHpView(new Point(param2.icharacter.x + 30,param2.icharacter.y - (param2.icharacter as Sprite).height),_loc5_,_loc6_ || param1.isUseAnger);
         _loc8_.scaleX = _loc8_.scaleY = 0.5;
         this.gameLayer.addChild(_loc8_);
         if(CopyServer.instance.isConnect && CopyServer.instance.serverType == 0 && param1 is MonsterCtrl)
         {
            CopyServer.instance.sendMonsterAttack(param1.siteID,param2.siteID,_loc5_,int(_loc6_));
            trace("GameWorld dropHp 座位号 " + param2.siteID);
         }
         return _loc5_;
      }
      
      protected function dropHpByValue(param1:ICharacterCtrl, param2:ICharacterCtrl, param3:int) : int
      {
         return dropHpByChar(param2,param3,param1.isUseAnger);
      }
      
      protected function dropHpByChar(param1:ICharacterCtrl, param2:int, param3:Boolean = false, param4:Number = 0.5) : int
      {
         param1.hp -= param2;
         var _loc5_:dropHpView = new dropHpView(new Point(param1.icharacter.x + 30,param1.icharacter.y - (param1.icharacter as Sprite).height),param2,param3);
         _loc5_.scaleX = _loc5_.scaleY = param4;
         this.gameLayer.addChild(_loc5_);
         if(param1 is SelfCharacterCtrl)
         {
            UILayer.bomb.bombValue += param2 * 100 / PlayerDataList.instance.selfData.HP;
            UILayer.updateCharHP(PlayerDataList.instance.selfData.siteID,param1.hp);
         }
         return param2;
      }
      
      protected function dropHpByCharAndSetHPView(param1:ICharacterCtrl, param2:int, param3:Boolean = false, param4:Number = 0.5, param5:Point = null) : int
      {
         var _loc6_:dropHpView = null;
         param1.hp -= param2;
         if(param5 == null)
         {
            _loc6_ = new dropHpView(new Point(param1.icharacter.x + 30,param1.icharacter.y - (param1.icharacter as Sprite).height),param2,param3);
         }
         else
         {
            _loc6_ = new dropHpView(new Point(param5.x,param5.y),param2,param3);
         }
         _loc6_.scaleX = _loc6_.scaleY = param4;
         this.gameLayer.addChild(_loc6_);
         if(param1 is SelfCharacterCtrl)
         {
            UILayer.bomb.bombValue += param2 * 100 / PlayerDataList.instance.selfData.HP;
            UILayer.updateCharHP(PlayerDataList.instance.selfData.siteID,param1.hp);
         }
         return param2;
      }
      
      protected function dropHPByServerAndSetHPView(param1:ICharacterCtrl, param2:ICharacterCtrl, param3:int, param4:Boolean = false, param5:Point = null) : int
      {
         var _loc6_:dropHpView = null;
         if(!param1 || !param2)
         {
            return 0;
         }
         trace("座位号：" + param2.siteID + " 当前血量：",param2.hp);
         if(param1 == param2 && param2.hp <= param3)
         {
            param2.hp = 1;
         }
         else
         {
            param2.hp -= param3;
         }
         if(param5 == null)
         {
            _loc6_ = new dropHpView(new Point(param2.icharacter.x + 30,param2.icharacter.y - (param2.icharacter as Sprite).height),param3,param4);
         }
         else
         {
            _loc6_ = new dropHpView(new Point(param5.x,param5.y),param3,param4);
         }
         _loc6_.scaleX = _loc6_.scaleY = 0.5;
         this.gameLayer.addChild(_loc6_);
         if(param2 is SelfCharacterCtrl)
         {
            UILayer.bomb.bombValue += param3 * 100 / PlayerDataList.instance.selfData.HP;
            UILayer.updateCharHP(PlayerDataList.instance.selfData.siteID,param2.hp);
         }
         return param3;
      }
      
      protected function dropHpByServer(param1:ICharacterCtrl, param2:ICharacterCtrl, param3:int, param4:Boolean = false) : int
      {
         if(!param1 || !param2)
         {
            return 0;
         }
         trace("座位号：" + param2.siteID + " 当前血量：",param2.hp);
         if(param1 == param2 && param2.hp <= param3)
         {
            param2.hp = 1;
         }
         else
         {
            param2.hp -= param3;
         }
         var _loc5_:dropHpView = new dropHpView(new Point(param2.icharacter.x + int(30 * Math.random()),param2.icharacter.y - (param2.icharacter as Sprite).height),param3,param4);
         _loc5_.scaleX = _loc5_.scaleY = 0.5;
         this.gameLayer.addChild(_loc5_);
         if(param2 is SelfCharacterCtrl)
         {
            UILayer.bomb.bombValue += param3 * 100 / PlayerDataList.instance.selfData.HP;
            UILayer.updateCharHP(PlayerDataList.instance.selfData.siteID,param2.hp);
         }
         return param3;
      }
      
      protected function gameOverAnimation(param1:Boolean, param2:Function = null) : void
      {
         var winMovie:WinMovieClip;
         var lostMovie:LostMovieClip;
         var win:Boolean = param1;
         var callBack:Function = param2;
         if(win)
         {
            winMovie = new WinMovieClip();
            addChild(winMovie);
            winMovie.x = 1365 >> 1;
            winMovie.y = 768 >> 1;
            winMovie.completeSignal.addOnce(function():void
            {
               winMovie.removeFromParent(true);
               callBack && callBack();
            });
            winMovie.play(2);
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
               callBack && callBack();
            });
            lostMovie.play(2);
         }
      }
      
      protected function reliveSelfPlayer() : void
      {
         if(UILayer.minute)
         {
            UILayer.minute.play();
         }
         UILayer.clearCharBySiteID(PlayerDataList.instance.selfData.siteID);
         sHelperPoint.setTo(selfCharacterCtrl.character.x,selfCharacterCtrl.character.y);
         if(selfCharacterCtrl)
         {
            selfCharacterCtrl.character.removeFromParent(true);
            CharacterFactory.instance.checkInCharacter(selfCharacterCtrl.character as Character);
            selfCharacterCtrl.dispose();
         }
         addSelfToWorld(sHelperPoint);
         playerReliveCount = playerReliveCount + 1;
      }
      
      protected function reliveOtherPlayer(param1:int) : void
      {
      }
      
      override public function dispose() : void
      {
         PlayerDataList.instance.selfData.inFight = false;
         Starling.juggler.remove(myGo);
         this.gameLayer.removeEventListener("touch",onTouchGameLayer);
         if(selfCharacterCtrl)
         {
            CharacterFactory.instance.checkInCharacter(selfCharacterCtrl.character as Character);
            selfCharacterCtrl.dispose();
         }
         _UILayer.removeFromParent(true);
         removeEventListener("enterFrame",onEnterFrameHandler);
         EventCenter.GameEvent.removeEventListener("useSKill",onUseSkillFunction);
         super.dispose();
      }
   }
}

