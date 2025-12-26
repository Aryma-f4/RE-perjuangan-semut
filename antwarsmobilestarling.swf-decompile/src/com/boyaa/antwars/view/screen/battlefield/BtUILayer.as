package com.boyaa.antwars.view.screen.battlefield
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.FightGoodsData;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.autoFight.AutoFightManager;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.GameConfigDlg;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.game.GameWorld;
   import com.boyaa.antwars.view.game.IGameWorld;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.battlefield.element.Bomb;
   import com.boyaa.antwars.view.screen.battlefield.element.SkillBox;
   import com.boyaa.antwars.view.screen.battlefield.element.TimerMinute;
   import com.boyaa.antwars.view.screen.battlefield.element.TimerView;
   import com.boyaa.antwars.view.screen.battlefield.ui.BtControlBar;
   import com.boyaa.antwars.view.screen.battlefield.ui.BtSkillAndWeaponDlg;
   import com.boyaa.antwars.view.screen.battlefield.ui.NewCharBox;
   import com.boyaa.antwars.view.screen.battlefield.ui.NewDirectionControl;
   import com.boyaa.antwars.view.screen.chatRoom.BtChatBox;
   import com.boyaa.antwars.view.screen.chatRoom.ChatRoomDlg;
   import com.boyaa.antwars.view.screen.chatRoom.Emoticon;
   import com.boyaa.antwars.view.screen.copygame.ReliveControl;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.screen.fresh.FreshGameWorld;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.shop.ShopManager;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.antwars.view.vipSystem.VipManager;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import org.osflash.signals.Signal;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.textures.Texture;
   
   public class BtUILayer extends UIExportSprite implements IGuideProcess
   {
      
      private var bottomBar:Sprite;
      
      public var planeBtn:Button;
      
      private var btnMessage:Button;
      
      private var messageCome:Image;
      
      private var _reliveBtn:FashionStarlingButton;
      
      private var _autoFightBtn:Button;
      
      public var bomb:Bomb;
      
      public var bombSignal:Signal;
      
      public var onPassBtnSignal:Signal;
      
      public var skillSignal:Signal;
      
      public var usePlaneSignal:Signal;
      
      public var copyTimeLimit:Boolean = false;
      
      public var isInFresh:Boolean = false;
      
      public var timer:TimerView;
      
      public var minute:TimerMinute;
      
      private var textureAtlas:ResAssetManager;
      
      private var _disable:Boolean = false;
      
      private var skillboxs:Vector.<SkillBox> = new Vector.<SkillBox>();
      
      public var face:Emoticon;
      
      private var chatroom:ChatRoomDlg;
      
      public var arrowSprite:Sprite;
      
      public var btnLeft:Button;
      
      public var btnRight:Button;
      
      private var leftArrow0:Image;
      
      private var leftArrow1:Image;
      
      private var rightArrow0:Image;
      
      private var rightArrow1:Image;
      
      private var _chatBoxArr:Array = [];
      
      private var _gameWorld:IGameWorld;
      
      private var _myTeamCharBoxNum:int = 1;
      
      private var _otherTeamCharBoxNum:int = 3;
      
      private var _weaponAndSkillButton:FashionStarlingButton;
      
      private var _angerButton:FashionStarlingButton;
      
      private var _emotionButton:FashionStarlingButton;
      
      private var _passButton:FashionStarlingButton;
      
      private var _setButton:FashionStarlingButton;
      
      private var _autoFightButton:FashionStarlingButton;
      
      private var _controlBar:BtControlBar;
      
      private var _directionControl:NewDirectionControl;
      
      private var _charBoxVec:Vector.<NewCharBox>;
      
      private var isShowBottomBar:Boolean = true;
      
      private var planeLimit:int = 0;
      
      private var gameConfigDlg:GameConfigDlg;
      
      public function BtUILayer()
      {
         super();
         textureAtlas = Assets.sAsset;
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      public function setGameWorld(param1:IGameWorld) : void
      {
         _gameWorld = param1;
      }
      
      public function getGameWorld() : IGameWorld
      {
         return _gameWorld;
      }
      
      public function lock() : void
      {
         timer.visible = false;
         btnMessage.visible = false;
         bottomBar.visible = false;
      }
      
      public function unLock() : void
      {
      }
      
      public function showTopInfo(param1:Boolean) : void
      {
         timer.visible = param1;
         _charBoxVec[0].displayObj.visible = param1;
         getDisplayObjectByName("vsFlag").visible = param1;
      }
      
      public function disableSkillbox(param1:int, param2:Boolean) : void
      {
         skillboxs[param1].canClick = param2;
      }
      
      public function set disable(param1:Boolean) : void
      {
         if(this._disable == param1)
         {
            return;
         }
         this._disable = param1;
         showControlUI(!param1);
      }
      
      private function showControlUI(param1:Boolean) : void
      {
         _controlBar.visible = param1;
         showAutoFightBtn(param1);
         _directionControl.displayObj.visible = param1;
         _weaponAndSkillButton.starlingBtn.visible = param1;
         bomb.visible = param1;
         _passButton.starlingBtn.visible = param1;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         skillSignal = new Signal(SkillBox);
         usePlaneSignal = new Signal();
         onPassBtnSignal = new Signal();
         init();
         topCenterView();
         createBottomBar();
         initMoveBtn();
         showAutoFightBtn();
         AutoFightManager.instance.setBTUILLayer(this);
         hideOldBtUILayerItems();
         hiddenBottomBar();
         disable = false;
      }
      
      private function hideOldBtUILayerItems() : void
      {
      }
      
      private function init() : void
      {
         var _loc2_:int = 0;
         var _loc1_:NewCharBox = null;
         _layout = new LayoutUitl(Assets.sAsset.getOther("BattlefieldUI"));
         _layout.buildLayout("BattlefieldUI",_displayObj);
         _controlBar = new BtControlBar(getSpriteByName("control"));
         _controlBar.uiLayer = this;
         _directionControl = new NewDirectionControl(getSpriteByName("directionLayout"));
         _directionControl.uiLayer = this;
         _charBoxVec = new Vector.<NewCharBox>();
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc1_ = new NewCharBox(getSpriteByName("char" + _loc2_));
            _charBoxVec.push(_loc1_);
            _loc1_.displayObj.visible = false;
            _loc2_++;
         }
         _reliveBtn = new FashionStarlingButton(getButtonByName("reliveBtn"));
         _reliveBtn.triggerFunction = onReliveBtnTriggeredHandle;
         _reliveBtn.starlingBtn.visible = false;
         SmallCodeTools.instance.setDisplayObjectInWidthScreen("right",_reliveBtn.starlingBtn);
         _passButton = new FashionStarlingButton(getButtonByName("passBtn"));
         _passButton.triggerFunction = passBtnTriggeredHandle;
         SmallCodeTools.instance.setDisplayObjectInWidthScreen("left",_passButton.starlingBtn);
         _setButton = new FashionStarlingButton(getButtonByName("setButton"));
         _setButton.triggerFunction = setBtnTriggeredHandle;
         SmallCodeTools.instance.setDisplayObjectInWidthScreen("right",_setButton.starlingBtn);
         _emotionButton = new FashionStarlingButton(getButtonByName("emotionIcon"));
         _emotionButton.triggerFunction = onEmoticonBtn;
         _emotionButton.starlingBtn.visible = false;
         SmallCodeTools.instance.setDisplayObjectInWidthScreen("left",_emotionButton.starlingBtn);
         _weaponAndSkillButton = new FashionStarlingButton(getButtonByName("skillBtn"));
         _weaponAndSkillButton.triggerFunction = onWeaponAndSkillBtnHandle;
         SmallCodeTools.instance.setDisplayObjectInWidthScreen("right",_weaponAndSkillButton.starlingBtn);
         _autoFightButton = new FashionStarlingButton(getButtonByName("autoFightBtn"));
         _autoFightButton.triggerFunction = onAutoFightTriggeredHandle;
         SmallCodeTools.instance.setDisplayObjectInWidthScreen("right",_autoFightButton.starlingBtn);
         EventCenter.GameEvent.addEventListener("useSKill",onUseSkillHandle);
         if(Constants.isFresh)
         {
            EventCenter.GameEvent.addEventListener("freshGame",onFreshGameHandle);
         }
         showAutoFightBtn();
      }
      
      private function onFreshGameHandle(param1:GameEvent) : void
      {
         var _loc2_:Array = param1.param as Array;
         if(_loc2_[0] == "openSkillBox")
         {
            GuideTipManager.instance.showByDisplayObject(_weaponAndSkillButton.starlingBtn);
         }
         if(_loc2_[0] == "usePower")
         {
            GuideTipManager.instance.showByDisplayObject(bomb);
         }
      }
      
      private function onUseSkillHandle(param1:GameEvent) : void
      {
         var _loc2_:Object = param1.param as Object;
         if(_loc2_.skillId == 15)
         {
            bomb.bombValue += 50;
         }
      }
      
      private function onWeaponAndSkillBtnHandle(param1:Event) : void
      {
         var _loc3_:int = 0;
         if(_gameWorld is Battlefield)
         {
            _loc3_ = int(Battlefield(_gameWorld).selfCharacterCtrl.actionPoint);
         }
         else
         {
            _loc3_ = int(GameWorld(_gameWorld).selfCharacterCtrl.actionPoint);
            if(_gameWorld is FreshGameWorld)
            {
               _loc3_ = 1000;
            }
         }
         var _loc2_:BtSkillAndWeaponDlg = new BtSkillAndWeaponDlg(_loc3_);
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_loc2_);
         addChild(_loc2_);
      }
      
      private function initMoveBtn() : void
      {
         arrowSprite = new Sprite();
         btnLeft = new Button(Assets.sAsset.getTexture("dz74"),"",Assets.sAsset.getTexture("dz75"));
         btnRight = new Button(Assets.sAsset.getTexture("dz74"),"",Assets.sAsset.getTexture("dz75"));
         btnLeft.x = Assets.leftCenter.x;
         btnLeft.y = Assets.leftCenter.y - btnLeft.height;
         btnRight.x = Assets.rightCenter.x - btnRight.width;
         btnRight.y = Assets.rightCenter.y - btnRight.height;
         leftArrow0 = new Image(Assets.sAsset.getTexture("dz76"));
         leftArrow1 = new Image(Assets.sAsset.getTexture("dz77"));
         leftArrow0.x = leftArrow1.x = btnLeft.x + (btnLeft.width - leftArrow0.width) / 2;
         leftArrow0.y = leftArrow1.y = btnLeft.y + (btnLeft.height - leftArrow0.height) / 2;
         rightArrow0 = new Image(Assets.sAsset.getTexture("dz76"));
         rightArrow1 = new Image(Assets.sAsset.getTexture("dz77"));
         rightArrow0.scaleX = rightArrow1.scaleX = -1;
         rightArrow0.x = rightArrow1.x = btnRight.x + btnRight.width / 2 + rightArrow1.width / 2;
         rightArrow0.y = rightArrow1.y = leftArrow1.y;
         leftArrow0.touchable = leftArrow1.touchable = rightArrow0.touchable = rightArrow1.touchable = false;
         arrowSprite.addChild(btnLeft);
         arrowSprite.addChild(btnRight);
         arrowSprite.addChild(leftArrow1);
         arrowSprite.addChild(leftArrow0);
         arrowSprite.addChild(rightArrow1);
         arrowSprite.addChild(rightArrow0);
         addChild(arrowSprite);
         arrowSprite.visible = false;
      }
      
      public function addChar(param1:int, param2:int, param3:Character, param4:int) : void
      {
         var _loc5_:NewCharBox = null;
         if(param2 == PlayerDataList.instance.selfData.team)
         {
            if(param1 == PlayerDataList.instance.selfData.siteID)
            {
               _loc5_ = getCharById(0);
            }
            else
            {
               _loc5_ = getCharById(1);
            }
         }
         else if(!getCharById(2).isHaveData)
         {
            _loc5_ = getCharById(2);
         }
         else
         {
            _loc5_ = getCharById(3);
         }
         _loc5_.displayObj.visible = true;
         _loc5_.setData(param1,param2,param3,param4);
      }
      
      public function addMonsterHead(param1:int, param2:int, param3:int = 2, param4:int = 0) : void
      {
         var _loc5_:NewCharBox = null;
         if(param3 == PlayerDataList.instance.selfData.team)
         {
            if(param1 == PlayerDataList.instance.selfData.siteID)
            {
               _loc5_ = getCharById(0);
            }
            else
            {
               _loc5_ = getCharById(1);
            }
         }
         else if(!getCharById(2).isHaveData)
         {
            _loc5_ = getCharById(2);
         }
         else
         {
            _loc5_ = getCharById(3);
         }
         _loc5_.displayObj.visible = true;
         _loc5_.setMonsterData(param1,param2,param3,param4);
      }
      
      private function getCharById(param1:int) : NewCharBox
      {
         return _charBoxVec[param1];
      }
      
      public function clearCharBySiteID(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:NewCharBox = null;
         _loc3_ = 0;
         while(_loc3_ < _charBoxVec.length)
         {
            _loc2_ = _charBoxVec[_loc3_];
            if(_loc2_.siteID == param1)
            {
               _loc2_.showBox(false);
            }
            _loc3_++;
         }
      }
      
      private function getChatBoxBySiteID(param1:int) : BtChatBox
      {
         var _loc3_:int = 0;
         var _loc2_:BtChatBox = null;
         _loc3_ = 0;
         while(_loc3_ < _chatBoxArr.length)
         {
            _loc2_ = _chatBoxArr[_loc3_];
            if(_loc2_.playerSite == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function updateCharHP(param1:int, param2:int) : void
      {
         for each(var _loc3_ in _charBoxVec)
         {
            if(_loc3_.siteID == param1)
            {
               _loc3_.updateHp(param2);
            }
         }
      }
      
      public function updateRound(param1:int, param2:Number) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < _charBoxVec.length)
         {
            if(_charBoxVec[_loc3_].siteID == param1)
            {
               _charBoxVec[_loc3_].isSelect = true;
            }
            else
            {
               _charBoxVec[_loc3_].isSelect = false;
            }
            _loc3_++;
         }
      }
      
      private function topCenterView() : void
      {
         if(copyTimeLimit)
         {
            minute = new TimerMinute();
            addChildToDisplayObject(minute);
            SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("copyTimerPos"),minute);
         }
         else
         {
            timer = new TimerView();
            SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("btTimerPos"),timer);
            addChildToDisplayObject(timer);
         }
      }
      
      private function createBottomBar() : void
      {
         var _loc3_:SkillBox = null;
         var _loc5_:* = 0;
         bottomBar = new Sprite();
         var _loc7_:Image = new Image(textureAtlas.getTexture("bottombar"));
         bottomBar.addChild(_loc7_);
         Assets.positionDisplay(bottomBar,"bfUILayer","bottombar");
         bottomBar.scaleX = bottomBar.scaleY = 1;
         bottomBar.x = 0;
         this.addChild(bottomBar);
         var _loc4_:Dictionary = Assets.getScreenPos("bfUILayer");
         var _loc2_:Point = null;
         var _loc6_:Array = GoodsList.instance.getBTPropAndSkill();
         _loc6_.sort(16);
         var _loc1_:Vector.<Texture> = new Vector.<Texture>();
         _loc1_.push(textureAtlas.getTexture("skillbox0"),textureAtlas.getTexture("skillbox1"),textureAtlas.getTexture("skillbox2"));
         _loc5_ = 1;
         while(_loc5_ < 9)
         {
            if(_loc6_.length >= _loc5_)
            {
               _loc3_ = new SkillBox(false,_loc1_);
               _loc3_.setSkill(_loc6_[_loc5_ - 1]);
               _loc3_.addEventListener("triggered",onClickSkillBox);
            }
            else
            {
               _loc3_ = new SkillBox(true,_loc1_);
            }
            _loc2_ = bottomBar.globalToLocal(new Point(_loc4_["s" + _loc5_].x,_loc4_["s" + _loc5_].y));
            _loc3_.x = _loc2_.x;
            _loc3_.y = _loc2_.y;
            bottomBar.addChild(_loc3_);
            skillboxs.push(_loc3_);
            _loc5_++;
         }
         planeBtn = new Button(textureAtlas.getTexture("plane0"),"",textureAtlas.getTexture("plane1"));
         _loc2_ = bottomBar.globalToLocal(new Point(_loc4_["plane"].x,_loc4_["plane"].y));
         planeBtn.x = _loc2_.x;
         planeBtn.y = _loc2_.y;
         planeBtn.width = _loc4_["plane"].width;
         planeBtn.height = _loc4_["plane"].height;
         bottomBar.addChild(planeBtn);
         planeBtn.addEventListener("triggered",planeBtnTriggeredHandle);
         bomb = new Bomb();
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("angerPos"),bomb);
         addChildToDisplayObject(bomb);
         SmallCodeTools.instance.setDisplayObjectInWidthScreen("right",bomb);
         bombSignal = new Signal();
         bomb.addEventListener("touch",bombTriggeredHandle);
         btnMessage = new Button(Assets.sAsset.getTexture("msg"));
         _loc2_ = bottomBar.globalToLocal(new Point(_loc4_["msg"].x,_loc4_["msg"].y));
         btnMessage.x = _loc2_.x;
         btnMessage.y = _loc2_.y;
         btnMessage.width = _loc4_["msg"].width;
         btnMessage.height = _loc4_["msg"].height;
         btnMessage.addEventListener("triggered",onMessageBtn);
         bottomBar.addChild(btnMessage);
         messageCome = new Image(Assets.sAsset.getTexture("h2"));
         messageCome.x = btnMessage.x - 5;
         messageCome.y = btnMessage.y - 4;
         messageCome.touchable = false;
         messageCome.visible = false;
         bottomBar.addChild(messageCome);
         if(Application.instance.currentGame.navigator.activeScreenID == "BATTLEFIELD" || Application.instance.currentGame.navigator.activeScreenID == "ROBOTBATTLEFIELD" || Application.instance.currentGame.navigator.activeScreenID == "ROBOT_2VS2_BATTLEFIELD")
         {
            _emotionButton.starlingBtn.visible = true;
            face = new Emoticon();
            face.x = _emotionButton.starlingBtn.x + _emotionButton.starlingBtn.width;
            face.y = _emotionButton.starlingBtn.y;
            stage.addChild(face);
            stage.addEventListener("touch",onTouch);
         }
         else
         {
            _emotionButton.starlingBtn.visible = false;
         }
         chatroom = ChatRoomDlg.getInstance();
         chatroom.msgSignal.add(onMessageCome);
         chatroom.btChatSignal.add(onBtMessageCome);
         chatroom.visible = false;
      }
      
      public function onMessageCome(param1:String) : void
      {
         if(isInFresh)
         {
            return;
         }
      }
      
      private function onBtMessageCome(param1:int, param2:String) : void
      {
         trace(param1,param2);
         getChatBoxBySiteID(param1).setText(param2);
      }
      
      public function updateSkillBoxsByActionPoint(param1:int) : void
      {
         var _loc3_:* = null;
         var _loc2_:FightGoodsData = null;
         for each(_loc3_ in skillboxs)
         {
            if(_loc3_.skillId !== -1)
            {
               _loc2_ = GoodsList.instance.getFightDataByID(_loc3_.skillId);
               _loc3_.disabled = param1 < _loc2_.expendForce;
            }
         }
         _loc2_ = GoodsList.instance.getFightDataByID(4);
         planeBtn.enabled = planeLimit <= 0 && param1 >= _loc2_.expendForce;
      }
      
      public function showBottomBar() : void
      {
         var tween:Tween;
         var screenPos:Dictionary;
         if(isShowBottomBar)
         {
            return;
         }
         tween = new Tween(bottomBar,0.1);
         tween.onComplete = function():void
         {
            Starling.juggler.remove(tween);
         };
         screenPos = Assets.getScreenPos("bfUILayer");
         tween.moveTo(0,screenPos["bottombar"].y);
         Starling.juggler.add(tween);
         isShowBottomBar = true;
      }
      
      public function hiddenBottomBar() : void
      {
         var tween:Tween;
         if(!isShowBottomBar)
         {
            return;
         }
         tween = new Tween(bottomBar,0.1);
         tween.onComplete = function():void
         {
            Starling.juggler.remove(tween);
         };
         tween.moveTo(0,768 + bottomBar.height);
         Starling.juggler.add(tween);
         isShowBottomBar = true;
      }
      
      private function planeBtnTriggeredHandle(param1:Event = null) : void
      {
         if(isInFresh)
         {
            SoundManager.playSound("sound 17");
            usePlaneSignal.dispatch();
            planeLimit = 2;
            return;
         }
         if(this._disable)
         {
            return;
         }
         SoundManager.playSound("sound 17");
         usePlaneSignal.dispatch();
         planeLimit = 2;
      }
      
      private function onReliveBtnTriggeredHandle(param1:Event) : void
      {
         ReliveControl.instance.showReliveDlg();
      }
      
      private function showAutoFightBtn(param1:Boolean = true) : void
      {
         var _loc5_:int = 0;
         var _loc2_:Array = null;
         if(!param1)
         {
            _autoFightButton.starlingBtn.visible = param1;
            return;
         }
         var _loc3_:Array = ["BATTLEFIELD","ROBOTBATTLEFIELD","ROBOT_2VS2_BATTLEFIELD","FRESHGAMEWORLD"];
         var _loc6_:Boolean = true;
         _autoFightButton.starlingBtn.visible = true;
         if(_loc3_.indexOf(Application.instance.currentGame.navigator.activeScreenID) != -1)
         {
            _autoFightButton.starlingBtn.visible = false;
         }
         var _loc4_:Array = [[1,6]];
         if(Application.instance.currentGame.navigator.activeScreenID == "COPYGAMEWORLD")
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc2_ = _loc4_[_loc5_];
               if(CopyList.instance.currentCopyData.cpid == _loc2_[0] && CopyList.instance.currentCopyData.cpdtlid == _loc2_[1])
               {
                  _autoFightButton.starlingBtn.visible = false;
               }
               _loc5_++;
            }
         }
      }
      
      public function onAutoFightTriggeredHandle(param1:Event) : void
      {
         var e:Event = param1;
         var fightFight:* = function():void
         {
            AutoFightManager.instance.isRunning = true;
            isAutoFight();
         };
         var lang:String = "";
         if(!AutoFightManager.instance.isRunning)
         {
            if(VipManager.instance.vipPowerData.autoFightTime > 0)
            {
               lang = LangManager.getLang.getreplaceLang("vipAutoFightTip",VipManager.instance.vipPowerData.autoFightTime);
            }
            else
            {
               lang = LangManager.t("buyAutoFightTip");
            }
            lang += LangManager.t("isOpenAutoFight");
         }
         else
         {
            lang = LangManager.t("isCloseAutoFight");
         }
         SystemTip.instance.showSystemAlert(lang,(function():*
         {
            var yes:Function;
            return yes = function():void
            {
               var goodType:int;
               var goodFrame:int;
               var good:GoodsData;
               if(AutoFightManager.instance.isRunning)
               {
                  AutoFightManager.instance.stop();
                  return;
               }
               if(VipManager.instance.vipPowerData.autoFightTime > 0)
               {
                  GameServer.instance.useAutoFight((function():*
                  {
                     var cb:Function;
                     return cb = function(param1:Object):void
                     {
                        Application.instance.log("useAutoFight",JSON.stringify(param1));
                        if(param1.data.todayCount != -1)
                        {
                           fightFight();
                           VipManager.instance.vipPowerData.autoFightTime = param1.data.todayCount;
                        }
                     };
                  })());
               }
               else
               {
                  goodType = 34;
                  goodFrame = 1091;
                  good = GoodsList.instance.getGoodsById(goodType,goodFrame);
                  if(!good)
                  {
                     ShopManager.instance.showBuyDlgByTypeID(goodType,goodFrame);
                     return;
                  }
                  Application.instance.currentGame.mainMenu.backpack.useMissionGoods(goodType,goodFrame,fightFight);
               }
            };
         })(),(function():*
         {
            var no:Function;
            return no = function():void
            {
            };
         })());
      }
      
      private function isAutoFight() : void
      {
         if(!AutoFightManager.instance.isRunning)
         {
            AutoFightManager.instance.stop();
            return;
         }
         if(_gameWorld is Battlefield)
         {
            AutoFightManager.instance.startShoot(Battlefield(_gameWorld).selfCharacterCtrl);
         }
         else
         {
            AutoFightManager.instance.startShoot(GameWorld(_gameWorld).selfCharacterCtrl);
         }
      }
      
      private function bombTriggeredHandle(param1:TouchEvent) : void
      {
         if(this._disable)
         {
            return;
         }
         if(param1.getTouch(param1.target as DisplayObject,"ended"))
         {
            if(bomb.bombValue >= 100)
            {
               SoundManager.playSound("sound 17");
               bomb.bombValue = 0;
               bombSignal.dispatch();
            }
         }
      }
      
      private function onClickSkillBox(param1:Event) : void
      {
         if(this._disable)
         {
            return;
         }
         var _loc2_:SkillBox = param1.currentTarget as SkillBox;
         if(_loc2_.skillId == 15)
         {
            bomb.bombValue += 50;
         }
         skillSignal.dispatch(_loc2_);
         SoundManager.playSound("sound 17");
      }
      
      override public function dispose() : void
      {
         AutoFightManager.instance.stop();
         bomb.removeEventListener("touch",bombTriggeredHandle);
         planeBtn.removeEventListener("triggered",planeBtnTriggeredHandle);
         onPassBtnSignal.removeAll();
         bombSignal.removeAll();
         skillSignal.removeAll();
         chatroom.msgSignal.remove(onMessageCome);
         chatroom.btChatSignal.remove(onBtMessageCome);
         usePlaneSignal.removeAll();
         if(chatroom)
         {
            chatroom.removeFromParent();
         }
         if(face)
         {
            face.removeFromParent();
            if(stage)
            {
               stage.removeEventListener("touch",onTouch);
            }
         }
         _controlBar.dispose();
         _directionControl.dispose();
         EventCenter.GameEvent.removeEventListener("useSKill",onUseSkillHandle);
         EventCenter.GameEvent.removeEventListener("freshGame",onFreshGameHandle);
         super.dispose();
      }
      
      private function passBtnTriggeredHandle(param1:Event) : void
      {
         onPassBtnSignal.dispatch();
      }
      
      private function setBtnTriggeredHandle(param1:Event) : void
      {
         if(gameConfigDlg && Starling.current.stage.contains(gameConfigDlg))
         {
            return;
         }
         gameConfigDlg = new GameConfigDlg(true);
         Starling.current.stage.addChild(gameConfigDlg);
         gameConfigDlg.x = 1365 - gameConfigDlg.width >> 1;
         gameConfigDlg.y = 768 - gameConfigDlg.height >> 1;
      }
      
      private function onEmoticonBtn(param1:Event) : void
      {
         face.faceBorad.visible = !face.faceBorad.visible;
      }
      
      private function onMessageBtn(param1:Event) : void
      {
         trace("...对战聊天");
         messageCome.visible = false;
         chatroom.visible = true;
         Starling.current.stage.addChild(chatroom);
         chatroom.x = 1365 - chatroom.width >> 1;
         chatroom.y = (768 - chatroom.height >> 1) - 20;
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc3_:* = undefined;
         var _loc2_:Vector.<Touch> = param1.getTouches(this.stage);
         if(_loc2_.length > 0 && _loc2_[0].phase == "began")
         {
            _loc4_ = param1.getTouches(face);
            _loc3_ = param1.getTouches(_emotionButton.starlingBtn);
            if(_loc4_.length == 0 && _loc3_.length == 0)
            {
               face.faceBorad.visible = false;
            }
         }
      }
      
      public function getSKillBoxs() : Vector.<SkillBox>
      {
         return skillboxs;
      }
      
      public function showReliveBtn(param1:Boolean = false) : void
      {
         _reliveBtn.starlingBtn.visible = param1;
      }
      
      public function guideProcess(param1:Object = null) : void
      {
      }
   }
}

