package com.boyaa.antwars.view.screen.endlessTower
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.AllRoomData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.ServerData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.HelpDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.monster.Monster;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.battlefield.BtSkillDlg;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideEventManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.antwars.view.vipSystem.VipManager;
   import feathers.controls.Screen;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class EndlessTowerScreen extends Screen implements IGuideProcess
   {
      
      public static var isFightToWorld:Boolean = false;
      
      public static var FlyCost:int = 10;
      
      public static var ReliveCost:int = 10;
      
      public static var ChallengeCost:int = 20;
      
      private var _asset:ResAssetManager;
      
      private var _layoutUitl:LayoutUitl;
      
      private var _rank:Sprite;
      
      private var _levelTipArr:Array = [];
      
      private var _monsterArr:Array = [];
      
      private var _closeBtn:Button;
      
      private var _rankBtn:Button;
      
      private var _fightBtn:Button;
      
      private var _flyBtn:Button;
      
      private var _addBtn:Button;
      
      private var _introBtn:Button;
      
      private const MAX_TIP_NUM:int = 5;
      
      private const CENTER_NUM:int = 2;
      
      private var _limitFightTime:int = 1;
      
      private var _vipTime:int = 0;
      
      private var _monsterShowArr:Array = [1,3,4,9,10,11,12,16,17,20];
      
      private var _currentLevel:int = 0;
      
      private var _giftLevel:int = 0;
      
      public function EndlessTowerScreen()
      {
         super();
         Application.instance.currentGame.showLoading();
         _asset = Assets.sAsset;
         if(!isFightToWorld)
         {
            loadAssets();
         }
         else
         {
            CopyServer.instance.getEndlessData(getEndlessData);
         }
      }
      
      private function connectServer() : void
      {
         GameServer.instance.getServerIDByType(21,function(param1:Object):void
         {
            var data:Object = param1;
            var serData:ServerData = AllRoomData.instance.getDataByID(data.svid);
            CopyServer.instance.init(serData.ip,serData.port);
            trace("当前连接的服务器：",serData.ip,serData.port);
            CopyServer.instance.connect();
            CopyServer.instance.serverType = 1;
            CopyServer.instance.loginSuccessful((function():*
            {
               var send:Function;
               return send = function():void
               {
                  bindNet();
                  CopyServer.instance.getEndlessData(getEndlessData);
               };
            })());
         });
      }
      
      private function bindNet() : void
      {
         CopyServer.instance.onFlyToTop(onFlyToTop);
      }
      
      private function unBindNet() : void
      {
         CopyServer.instance.disposeRecvFun(onFlyToTop);
      }
      
      private function getEndlessData(param1:Object) : void
      {
         Application.instance.log("EndlessData",JSON.stringify(param1));
         _currentLevel = param1.data.currentLevel;
         _giftLevel = param1.data.nextGiftLevel;
         _limitFightTime = param1.data.challengeTime - param1.data.vipTime;
         _vipTime = param1.data.vipTime;
         PlayerDataList.instance.selfData.endlessHighLevel = param1.data.peakLevel;
         FlyCost = param1.data.flyLevelCost;
         ReliveCost = param1.data.reliveCost;
         ChallengeCost = param1.data.challengeCost;
         VipManager.instance.vipPowerData.endlessReliveTime = param1.data.freeRelive;
         VipManager.instance.vipPowerData.freeEnterEndlessTime = _limitFightTime;
         initUI();
         guideProcess();
      }
      
      private function loadAssets() : void
      {
         var _loc1_:ResManager = Application.instance.resManager;
         _asset.enqueue(_loc1_.getResFile(formatString("asset/endlessTower.info")),_loc1_.getResFile(formatString("textures/{0}x/BT/endlessTower.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/endlessTower.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/btdlg.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/BT/btdlg.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/spider.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/spider.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_spider.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/sprite.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/sprite.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_sprite.xml",Assets
         .sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/worm.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/worm.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_worm.xml",Assets.sAsset.scaleFactor)));
         _asset.loadQueue(loading);
      }
      
      private function loading(param1:Number) : void
      {
         if(param1 == 1)
         {
            connectServer();
         }
      }
      
      private function initUI() : void
      {
         isFightToWorld = false;
         Application.instance.currentGame.hiddenLoading();
         _layoutUitl = new LayoutUitl(_asset.getOther("endlessTower"),_asset);
         _layoutUitl.buildLayout("endlessTowerUI",this);
         this.x = 170.5;
         _closeBtn = StarlingUITools.instance.initStarlingButton(this,"btnS_close",onCloseHandle);
         _rankBtn = StarlingUITools.instance.initStarlingButton(this,"rankBtn",onRankHandle);
         _fightBtn = StarlingUITools.instance.initStarlingButton(this,"fightBtn",onFightBtnHandle);
         _flyBtn = StarlingUITools.instance.initStarlingButton(this,"flyBtn",onFlyBtnHandle);
         _addBtn = StarlingUITools.instance.initStarlingButton(this,"addBtn",onAddBtnHandle);
         _introBtn = StarlingUITools.instance.initStarlingButton(this,"introBtn",onIntroBtnHandle);
         getTextFieldByName("highTxt").text = LangManager.getLang.getreplaceLang("endless_txt3",PlayerDataList.instance.selfData.endlessHighLevel);
         limitFightTime = _limitFightTime;
         addLevelTipInfos();
         if(PlayerDataList.instance.selfData.endlessHighLevel - _currentLevel <= 0)
         {
            _flyBtn.visible = false;
         }
         Remoting.instance.backBTProp([],function(param1:Object):void
         {
            if(param1.ret == 0)
            {
               GoodsList.instance.payPorpIdArr = param1.props.split("|");
            }
         });
         getTextFieldByName("vipTimeTxt").nativeFilters = StarlingUITools.instance.getDropShadowFilter(0,30);
      }
      
      private function removeEvent() : void
      {
         unBindNet();
         StarlingUITools.instance.removeStarlingButtonsListener([_closeBtn,_rankBtn,_fightBtn,_flyBtn,_addBtn]);
      }
      
      private function addLevelTipInfos() : void
      {
         var _loc5_:int = 0;
         var _loc2_:DisplayObject = null;
         var _loc3_:TextField = null;
         var _loc4_:Image = null;
         var _loc1_:Image = null;
         _loc5_ = 0;
         while(_loc5_ < 5)
         {
            _loc2_ = this.getChildByName("box" + _loc5_) as DisplayObject;
            _loc3_ = this.getChildByName("boxTxt" + _loc5_) as TextField;
            _loc4_ = new Image(_asset.getTexture("img_complete"));
            _loc1_ = new Image(_asset.getTexture("img_lock"));
            if(_loc5_ < 2)
            {
               SmallCodeTools.instance.setDisplayObjectToCenter(_loc2_,_loc4_);
               addChild(_loc4_);
            }
            if(_loc5_ > 2)
            {
               SmallCodeTools.instance.setDisplayObjectToCenter(_loc2_,_loc1_);
               addChild(_loc1_);
            }
            _levelTipArr.push({
               "box":_loc2_,
               "txt":_loc3_,
               "passFlag":_loc4_,
               "lockFlag":_loc1_
            });
            _loc5_++;
         }
         setLevelData(_currentLevel);
      }
      
      private function getMonsterType() : int
      {
         return _monsterShowArr[Math.floor(Math.random() * _monsterShowArr.length)];
      }
      
      private function setLevelData(param1:int) : void
      {
         var obj:Object;
         var num:int;
         var level:int = param1;
         var addMonster:* = function(param1:int, param2:Object):void
         {
            var _loc3_:Monster = SmallCodeTools.instance.getMonsterSpieceType(param1);
            SmallCodeTools.instance.setDisplayObjectToCenter(param2.box,_loc3_);
            _loc3_.x += param2.box.width / 2.5;
            _loc3_.y += param2.box.height / 2;
            _loc3_.width = param2.box.width - param2.box.width / 10;
            _loc3_.scaleY = _loc3_.scaleX;
            addChild(_loc3_);
            _monsterArr.push(_loc3_);
         };
         var i:int = 0;
         while(i < 2)
         {
            obj = _levelTipArr[i];
            SmallCodeTools.instance.setDisplayObjectVisible([obj.box,obj.txt,obj.passFlag,obj.lockFlag],false);
            i = i + 1;
         }
         if(level == 1)
         {
            obj = _levelTipArr[1];
            SmallCodeTools.instance.setDisplayObjectVisible([obj.box,obj.txt,obj.passFlag,obj.lockFlag],true);
            obj.txt.text = LangManager.getLang.getreplaceLang("endless_txt4",level);
            addMonster(getMonsterType(),obj);
            addChild(obj.passFlag);
         }
         if(level >= 2)
         {
            i = 0;
            while(i < 2)
            {
               num = level - 2 + i + 1;
               obj = _levelTipArr[i];
               SmallCodeTools.instance.setDisplayObjectVisible([obj.box,obj.txt,obj.passFlag,obj.lockFlag],true);
               obj.txt.text = LangManager.getLang.getreplaceLang("endless_txt4",num);
               addMonster(getMonsterType(),obj);
               addChild(obj.passFlag);
               i = i + 1;
            }
         }
         i = 2;
         while(i < _levelTipArr.length)
         {
            obj = _levelTipArr[i];
            obj.txt.text = LangManager.getLang.getreplaceLang("endless_txt4",level + 1 + i - 2);
            if(i == 2)
            {
               addMonster(getMonsterType(),obj);
            }
            i = i + 1;
         }
         getTextFieldByName("currentTxt").text = LangManager.getLang.getreplaceLang("endless_txt0",_currentLevel);
         getTextFieldByName("currentTip").text = LangManager.getLang.getreplaceLang("endless_txt1",_giftLevel - _currentLevel);
         if(PlayerDataList.instance.selfData.vipLevel != 0)
         {
            getTextFieldByName("vipTimeTxt").text = "VIP" + PlayerDataList.instance.selfData.vipLevel + "+" + _vipTime;
         }
         else
         {
            getTextFieldByName("vipTimeTxt").text = "";
         }
      }
      
      private function onFlyToTop(param1:Object) : void
      {
         Application.instance.log("onFlyToTop",JSON.stringify(param1));
         if(param1.data.flag == 0)
         {
            _currentLevel = param1.data.currentLevel;
            _giftLevel = param1.data.giftLevel;
            getTextFieldByName("currentTxt").text = LangManager.getLang.getreplaceLang("endless_txt0",_currentLevel);
            getTextFieldByName("currentTip").text = LangManager.getLang.getreplaceLang("endless_txt1",_giftLevel - _currentLevel);
            setLevelData(_currentLevel);
            TextTip.instance.showByLang("endless_fly_tip2");
         }
      }
      
      private function onAddBtnHandle(param1:Event) : void
      {
         var e:Event = param1;
         SystemTip.instance.showSystemAlert(LangManager.getLang.getreplaceLang("endless_txt5",ChallengeCost),(function():*
         {
            var yes:Function;
            return yes = function():void
            {
               if(AccountData.instance.boyaaCoin < ChallengeCost)
               {
                  TextTip.instance.showByLang("boyyabz");
                  return;
               }
               CopyServer.instance.sendEndlessBuyTime((function():*
               {
                  var buy:Function;
                  return buy = function(param1:Object):void
                  {
                     if(param1.data.flag == 0)
                     {
                        limitFightTime = limitFightTime + 1;
                     }
                  };
               })());
            };
         })(),(function():*
         {
            var no:Function;
            return no = function():void
            {
            };
         })());
      }
      
      private function onIntroBtnHandle(param1:Event) : void
      {
         HelpDlg.show(LangManager.t("endless_help"));
      }
      
      private function onFlyBtnHandle(param1:Event) : void
      {
         var distanceLevel:int;
         var e:Event = param1;
         if(PlayerDataList.instance.selfData.endlessHighLevel <= 0)
         {
            TextTip.instance.showByLang("endless_fly_tip");
            return;
         }
         distanceLevel = PlayerDataList.instance.selfData.endlessHighLevel - _currentLevel;
         SystemTip.instance.showSystemAlert(LangManager.getLang.getreplaceLang("endless_txt6",distanceLevel * FlyCost,distanceLevel),(function():*
         {
            var yes:Function;
            return yes = function():void
            {
               if(_currentLevel <= 0)
               {
                  TextTip.instance.showByLang("endless_fly_tip1");
               }
               if(AccountData.instance.boyaaCoin < distanceLevel * FlyCost)
               {
                  TextTip.instance.showByLang("boyyabz");
                  return;
               }
               CopyServer.instance.sendFlyToTop(PlayerDataList.instance.selfData.endlessHighLevel);
            };
         })(),(function():*
         {
            var no:Function;
            return no = function():void
            {
            };
         })());
      }
      
      private function onFightBtnHandle(param1:Event) : void
      {
         var propSkill:BtSkillDlg;
         var e:Event = param1;
         if(!SmallCodeTools.instance.checkEquipWeapon())
         {
            return;
         }
         if(limitFightTime <= 0)
         {
            onAddBtnHandle(null);
            return;
         }
         propSkill = new BtSkillDlg();
         Starling.current.stage.addChild(propSkill);
         propSkill.setCloseCallBack((function():*
         {
            var call:Function;
            return call = function():void
            {
               isFightToWorld = true;
               Starling.juggler.delayCall((function():*
               {
                  var delay:Function;
                  return delay = function():void
                  {
                     Application.instance.currentGame.navigator.showScreen("ENDLESSTOWERWORLD");
                  };
               })(),0.5);
            };
         })());
      }
      
      private function onRankHandle(param1:Event) : void
      {
         if(_rank)
         {
            _rank.removeFromParent(true);
         }
         _rank = new Sprite();
         _layoutUitl.buildLayout("rankLayout",_rank);
         new EndlessRank(_rank);
         this.parent.addChild(_rank);
      }
      
      private function onCloseHandle(param1:Event) : void
      {
         this.dispatchEventWith("complete");
      }
      
      private function getTextFieldByName(param1:String) : TextField
      {
         return this.getChildByName(param1) as TextField;
      }
      
      override public function dispose() : void
      {
         var _loc4_:int = 0;
         var _loc1_:Monster = null;
         var _loc3_:int = 0;
         var _loc2_:Object = null;
         if(!isFightToWorld)
         {
            Assets.sAsset.removeTextureAtlas("endlessTower");
            Assets.sAsset.removeObject("endlessTower");
            Assets.sAsset.removeTextureAtlas("spider");
            Assets.sAsset.removeSkeletonsAndBoneAtlases("spider");
            Assets.sAsset.removeTextureAtlas("worm");
            Assets.sAsset.removeSkeletonsAndBoneAtlases("worm");
            Assets.sAsset.removeTextureAtlas("sprite");
            Assets.sAsset.removeSkeletonsAndBoneAtlases("sprite");
            CopyServer.instance.close();
         }
         _loc4_ = 0;
         while(_loc4_ < _monsterArr.length)
         {
            _loc1_ = _monsterArr[_loc4_];
            _loc1_.removeFromParent(true);
            _loc1_.dispose();
            _loc1_ = null;
            _loc4_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _levelTipArr.length)
         {
            _loc2_ = _levelTipArr[_loc3_];
            _loc2_.box.dispose();
            _loc2_.txt.dispose();
            _loc2_.passFlag.dispose();
            _loc2_.lockFlag.dispose();
            _loc3_++;
         }
         removeEvent();
         super.dispose();
      }
      
      public function guideProcess(param1:Object = null) : void
      {
         var _loc2_:String = MissionGuideValue.instance.getMissionFlag();
         var _loc3_:* = _loc2_;
         if("endlessMission" === _loc3_)
         {
            GuideEventManager.instance.dispactherEvent("newUI",[[_fightBtn,20]]);
         }
      }
      
      public function set limitFightTime(param1:int) : void
      {
         _limitFightTime = param1;
         getTextFieldByName("limitTxt").text = LangManager.getLang.getreplaceLang("endless_txt2",param1);
      }
      
      public function get limitFightTime() : int
      {
         return _limitFightTime;
      }
   }
}

