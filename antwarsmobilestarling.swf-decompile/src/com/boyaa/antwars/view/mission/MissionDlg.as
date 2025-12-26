package com.boyaa.antwars.view.mission
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.LocalData;
   import com.boyaa.antwars.data.MissionDataList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.data.model.mission.MissionData;
   import com.boyaa.antwars.data.model.mission.RewardData;
   import com.boyaa.antwars.data.model.mission.SubMissionData;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.Hall;
   import com.boyaa.antwars.view.screen.chatRoom.FriendsList;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideSprite;
   import com.boyaa.antwars.view.screen.fresh.guideControl.JumpSceneInGuide;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import com.boyaa.antwars.view.screen.shop.GoodsDetailView;
   import feathers.controls.List;
   import feathers.controls.ToggleButton;
   import feathers.data.ListCollection;
   import flash.filters.DropShadowFilter;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.utils.RectangleUtil;
   
   public class MissionDlg extends GuideSprite
   {
      
      private static var hasGained:Boolean = false;
      
      private var _bg1:Image;
      
      private var _bg2:Image;
      
      private var _markBg:Quad;
      
      private var btnGo:Button;
      
      private var _dailyBtn:ToggleButton;
      
      private var _activeBtn:ToggleButton;
      
      private var _submitBtn:Button;
      
      private var _gotoBtn:Button;
      
      private var _closeBtn:Button;
      
      private var _scrollText1:TextField;
      
      private var _scrollText2:TextField;
      
      private var _goodsList:Array;
      
      private var _goodsTextList:Array;
      
      private var _missionList:List;
      
      private var _atlas:ResAssetManager;
      
      private var _dailyArr:Array = [];
      
      private var _activeArr:Array = [];
      
      private var _dailyData:ListCollection;
      
      private var _activeData:ListCollection;
      
      private var _rewardArr:Array = [];
      
      private var _isFinish:Boolean = false;
      
      private var _isReward:Boolean = false;
      
      private var _currentMissionData:MissionData;
      
      private var _currentIndex:int = 0;
      
      private var _flag:int = 0;
      
      private var markBg:DlgMark;
      
      private var missionID:Array = [1011,1013,1014,1015,1023,1024,1034,1044,1045,1012,1055,1056,1065,1066];
      
      private var posArr:Array = ["mission","shop","forge","btRoom","copyGame"];
      
      private var gotoPage:String;
      
      public var inGuide:Boolean = false;
      
      private var isFirst:Boolean = true;
      
      private var _guideJump:JumpSceneInGuide = new JumpSceneInGuide();
      
      private var emptyMissionDataFlag:uint;
      
      public function MissionDlg()
      {
         super();
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onUpdateStatus(param1:PHPEvent) : void
      {
         init();
      }
      
      private function init() : void
      {
         _markBg = new Quad(1024,768,0);
         _markBg.alpha = 0.5;
         _atlas = Assets.sAsset;
         _bg1 = new Image(_atlas.getTexture("bb_bg"));
         _bg2 = new Image(_atlas.getTexture("rw2"));
         var _loc1_:Image = new Image(_atlas.getTexture("mission"));
         Assets.positionDisplay(_loc1_,"missionDlg","mission");
         Assets.positionDisplay(_bg1,"missionDlg","bg1");
         Assets.positionDisplay(_bg2,"missionDlg","bg2");
         var _loc4_:Image = new Image(Assets.sAsset.getTexture("55"));
         Assets.positionDisplay(_loc4_,"missionDlg","topbar");
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("bb46"));
         Assets.positionDisplay(_loc3_,"missionDlg","bottomBar");
         _closeBtn = new Button(_atlas.getTexture("close"),"",_atlas.getTexture("close1"));
         Assets.positionDisplay(_closeBtn,"missionDlg","closeBtn");
         _closeBtn.addEventListener("triggered",onCloseBtn);
         _submitBtn = new Button(_atlas.getTexture("rw12-2"),"",_atlas.getTexture("rw13"));
         Assets.positionDisplay(_submitBtn,"missionDlg","submitBtn");
         _submitBtn.addEventListener("triggered",onSubmitBtn);
         _gotoBtn = new Button(_atlas.getTexture("rw20"),"",_atlas.getTexture("rw21"));
         Assets.positionDisplay(_gotoBtn,"missionDlg","submitBtn");
         _gotoBtn.addEventListener("triggered",onGotoHandle);
         btnGo = new Button(_atlas.getTexture("rw20"),"",_atlas.getTexture("rw21"));
         Assets.positionDisplay(btnGo,"missionDlg","submitBtn");
         btnGo.addEventListener("triggered",onGo);
         btnGo.visible = false;
         _activeBtn = initButton(_activeBtn,["missionDlg","dailyMissionBtn","rw24","rw25",onActiveBtn]);
         _activeBtn.isSelected = true;
         _dailyBtn = initButton(_dailyBtn,["missionDlg","activeMissionBtn","rw8","rw9",onDailyBtn]);
         _scrollText1 = new TextField(100,100,"","Verdana",28,4530951,true);
         _scrollText2 = new TextField(100,100,"","Verdana",28,4530951,true);
         var _loc2_:TextFormat = new TextFormat("Verdana",28,4530951,true);
         _scrollText1.hAlign = _scrollText2.hAlign = "left";
         _scrollText1.autoScale = _scrollText2.autoScale = true;
         Assets.positionDisplay(_scrollText1,"missionDlg","text1");
         Assets.positionDisplay(_scrollText2,"missionDlg","text2");
         initMissionList();
         addChild(_bg1);
         addChild(_dailyBtn);
         addChild(_activeBtn);
         addChild(_bg2);
         addChild(_scrollText1);
         addChild(_scrollText2);
         addChild(_submitBtn);
         addChild(_gotoBtn);
         addChild(_missionList);
         addChild(btnGo);
         addChild(_loc3_);
         addChild(_loc4_);
         addChild(_loc1_);
         addChild(_closeBtn);
         _goodsList = [];
         _goodsTextList = [];
         onActiveBtn();
         EventCenter.PHPEvent.addEventListener("getMissionStatus",updateCurrentBtnMsg);
         this.x = 1365 - this.width >> 1;
         this.y = 768 - this.height >> 1;
         markBg = new DlgMark();
         MissionManager.instance.updateMissionData(170,0,0,FriendsList.instance.getFriendListData().length);
      }
      
      private function checkGotoBtnIsValue() : void
      {
         _gotoBtn.visible = false;
         if(!btnGo.visible && !_currentMissionData.isFinished)
         {
            _gotoBtn.visible = true;
         }
      }
      
      private function onGotoHandle(param1:Event) : void
      {
         onCloseBtn(null);
         GuideTipManager.instance.currentMissionData = _currentMissionData;
         _guideJump.jump();
         var _loc2_:String = MissionGuideValue.instance.getMissionFlag();
         switch(_loc2_)
         {
            case "payMission":
               Application.instance.currentGame.mainMenu.onRechargeBtn();
               break;
            case "friendMission":
            case "usePropMission":
               Application.instance.currentGame.mainMenu.guideProcess();
               break;
            default:
               GuideTipManager.instance.start();
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         init();
         parent.addChild(markBg);
         parent.swapChildren(markBg,this);
         this.pivotX = 497;
         this.pivotY = 384;
         this.scaleX = this.scaleY = 0;
         _scrollText1.visible = _scrollText2.visible = false;
         _missionList.alpha = 0;
         _scrollText1.alpha = 0;
         _scrollText2.alpha = 0;
         Starling.juggler.tween(_scrollText1,0.1,{
            "alpha":1,
            "transition":"linear"
         });
         Starling.juggler.tween(_scrollText2,0.1,{
            "alpha":1,
            "transition":"linear"
         });
         Starling.juggler.tween(this,0.5,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeInOut",
            "onComplete":onCompleteHandler
         });
      }
      
      private function onCompleteHandler() : void
      {
         Starling.juggler.tween(_missionList,0.5,{
            "alpha":1,
            "transition":"easeOut"
         });
         _scrollText1.visible = _scrollText2.visible = true;
         onSelectedItem(_currentMissionData);
      }
      
      private function guideCheckBtn() : void
      {
         if(PlayerDataList.instance.selfData.level >= 5)
         {
            return;
         }
         Guide.instance.guide(_missionList,LangManager.t("guide1"),true);
         Guide.instance.x = -5;
      }
      
      private function guideGoBtn() : void
      {
         btnGo.visible = true;
         _submitBtn.visible = false;
         Guide.instance.guide(btnGo,"",true);
      }
      
      private function guideGetBtn() : void
      {
         _submitBtn.visible = true;
         btnGo.visible = false;
         Guide.instance.guide(_submitBtn,"",true);
      }
      
      private function guideCloseBtn() : void
      {
         Guide.instance.guide(_closeBtn,"",true);
         Guide.instance.x = 0;
      }
      
      private function onListChangeHandle(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         Guide.instance.stop();
         saveGoodExp(MissionData(_loc2_.selectedItem));
         _dailyData.updateItemAt(_loc2_.selectedIndex);
         _activeData.updateItemAt(_loc2_.selectedIndex);
         this._currentIndex = _loc2_.selectedIndex;
         if(MissionData(_loc2_.selectedItem))
         {
            onSelectedItem(MissionData(_loc2_.selectedItem));
         }
         checkGotoBtnIsValue();
      }
      
      private function onSelectedItem(param1:MissionData) : void
      {
         var _loc2_:int = param1.msid;
         Application.instance.log("当前选择任务：",JSON.stringify(param1));
         switch(_loc2_)
         {
            case 1011:
               guideGetBtn();
               inGuide = true;
               break;
            case 1013:
            case 1014:
            case 1015:
               if(!param1.isFinished)
               {
                  Guide.instance.stop();
                  btnGo.visible = false;
                  _submitBtn.touchable = false;
                  _submitBtn.upState = _atlas.getTexture("rw12-2");
                  inGuide = false;
                  break;
               }
               if(PlayerDataList.instance.selfData.level < 6)
               {
                  inGuide = true;
                  guideGetBtn();
               }
               break;
            case 1023:
               inGuide = true;
               if(!param1.isFinished)
               {
                  gotoPage = "shop";
                  guideGoBtn();
                  break;
               }
               gotoPage = "mission";
               guideGetBtn();
               break;
            case 1024:
               if(!param1.isFinished)
               {
                  gotoPage = "forge";
                  guideGoBtn();
               }
               else
               {
                  gotoPage = "mission";
                  guideGetBtn();
               }
               inGuide = true;
               break;
            case 1034:
               inGuide = true;
               if(!param1.isFinished)
               {
                  gotoPage = "backpack";
                  guideGoBtn();
                  break;
               }
               gotoPage = "mission";
               guideGetBtn();
               break;
            case 1041:
            case 1044:
            case 1045:
               inGuide = true;
               if(!param1.isFinished)
               {
                  gotoPage = "btRoom";
                  guideGoBtn();
                  break;
               }
               gotoPage = "mission";
               guideGetBtn();
               break;
            case 1054:
            case 1055:
            case 1056:
            case 1012:
               inGuide = true;
               if(!param1.isFinished)
               {
                  gotoPage = "copyGame";
                  guideGoBtn();
                  break;
               }
               gotoPage = "mission";
               guideGetBtn();
               break;
            default:
               inGuide = false;
               if(!param1.isFinished)
               {
                  Guide.instance.stop();
                  btnGo.visible = false;
                  _submitBtn.touchable = false;
                  _submitBtn.upState = _atlas.getTexture("rw12-2");
                  break;
               }
               Guide.instance.stop();
               btnGo.visible = false;
               _submitBtn.touchable = true;
               _submitBtn.upState = _atlas.getTexture("rw12");
         }
      }
      
      private function onActiveBtn() : void
      {
         if(_flag == 2)
         {
            return;
         }
         if(_dailyBtn.isSelected)
         {
            _dailyBtn.isSelected = false;
            _dailyBtn.touchable = true;
         }
         _activeBtn.touchable = false;
         _missionList.dataProvider = _activeData;
         _missionList.selectedIndex = -1;
         saveGoodExp(null);
         _flag = 2;
      }
      
      private function onDailyBtn() : void
      {
         if(_flag == 1)
         {
            return;
         }
         inGuide = false;
         if(_activeBtn.isSelected)
         {
            _activeBtn.isSelected = false;
            _activeBtn.touchable = true;
            Guide.instance.stop();
            btnGo.visible = false;
         }
         _dailyBtn.touchable = false;
         _missionList.dataProvider = _dailyData;
         _missionList.selectedIndex = -1;
         saveGoodExp(null);
         _flag = 1;
      }
      
      private function initButton(param1:ToggleButton, param2:Array) : ToggleButton
      {
         param1 = new ToggleButton();
         param1.isToggle = true;
         param1.name = "0";
         Assets.positionDisplay(param1,param2[0],param2[1]);
         param1.defaultSkin = new Image(Assets.sAsset.getTexture(param2[2]));
         param1.downSkin = new Image(Assets.sAsset.getTexture(param2[3]));
         param1.selectedDownSkin = new Image(Assets.sAsset.getTexture(param2[3]));
         param1.defaultSelectedSkin = new Image(Assets.sAsset.getTexture(param2[3]));
         param1.addEventListener("triggered",param2[4]);
         return param1;
      }
      
      private function onGo(param1:Event) : void
      {
         Hall.inGuide = true;
         Guide.instance.stop();
         Starling.juggler.tween(_missionList,0.1,{
            "alpha":0,
            "transition":"linear"
         });
         Starling.juggler.tween(_scrollText1,0.1,{
            "alpha":0,
            "transition":"linear"
         });
         Starling.juggler.tween(_scrollText2,0.1,{
            "alpha":0,
            "transition":"linear",
            "onComplete":tween
         });
      }
      
      private function onSubmitBtn(param1:Event) : void
      {
         if(_currentMissionData)
         {
            if(_isFinish && !_isReward)
            {
               _currentMissionData.isRewarded = true;
               MissionManager.instance.beRewarded(_currentMissionData);
               MissionManager.instance.getMissionState();
               _submitBtn.visible = false;
            }
         }
         _dailyData.updateItemAt(_currentIndex);
         _activeData.updateItemAt(_currentIndex);
         var _loc2_:int = 0;
      }
      
      private function updateCurrentBtnMsg(param1:PHPEvent) : void
      {
         updateList();
         if(_flag == 2)
         {
            saveGoodExp(_activeArr[_currentIndex] as MissionData);
         }
         else
         {
            saveGoodExp(_dailyArr[_currentIndex] as MissionData);
         }
      }
      
      private function onCloseBtn(param1:Event) : void
      {
         Starling.juggler.tween(_missionList,0.1,{
            "alpha":0,
            "transition":"linear"
         });
         Starling.juggler.tween(_scrollText1,0.1,{
            "alpha":0,
            "transition":"linear"
         });
         Starling.juggler.tween(_scrollText2,0.1,{
            "alpha":0,
            "transition":"linear",
            "onComplete":tween
         });
         Hall.inGuide = false;
         Guide.instance.stop();
         Guide.instance.textSprite.visible = true;
         gotoPage = "mission";
         GuideTipManager.instance.currentMissionData = null;
      }
      
      private function tween() : void
      {
         Starling.juggler.tween(this,0.3,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeIn",
            "onComplete":cleanUp
         });
      }
      
      private function cleanUp() : void
      {
         onGoto();
         Starling.juggler.removeTweens(this);
         EventCenter.PHPEvent.removeEventListener("getMissionStatus",updateCurrentBtnMsg);
         _closeBtn.removeEventListener("triggered",onCloseBtn);
         _submitBtn.removeEventListener("triggered",onSubmitBtn);
         markBg.removeFromParent();
         this.removeFromParent(true);
      }
      
      private function sortMissionDataArr(param1:Array) : void
      {
         param1.sortOn(["isFinished","isNew","level","msid"],[2,2,16,16]);
      }
      
      private function initMissionList() : void
      {
         var _loc1_:MissionData = null;
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         _missionList = new List();
         _loc3_ = 0;
         while(_loc3_ < MissionDataList.getInstance().mainMissionArr.length)
         {
            _loc1_ = MissionDataList.getInstance().mainMissionArr[_loc3_];
            if(_loc1_.msid == 2070)
            {
               trace("");
            }
            _activeArr.push(_loc1_);
            _loc3_++;
         }
         sortMissionDataArr(_activeArr);
         specialMissionInEnd();
         _activeData = new ListCollection(_activeArr);
         _loc2_ = 0;
         while(_loc2_ < MissionDataList.getInstance().dailyMissionArr.length)
         {
            _loc1_ = MissionDataList.getInstance().dailyMissionArr[_loc2_];
            if(!_loc1_.isRewarded)
            {
               _dailyArr.push(_loc1_);
            }
            _loc2_++;
         }
         sortMissionDataArr(_dailyArr);
         _dailyData = new ListCollection(_dailyArr);
         _missionList.dataProvider = _activeData;
         _missionList.itemRendererType = SingleMissionRender;
         Assets.positionDisplay(_missionList,"missionDlg","list");
         _missionList.addEventListener("change",onListChangeHandle);
      }
      
      private function specialMissionInEnd() : void
      {
         var _loc4_:int = 0;
         var _loc3_:MissionData = null;
         var _loc1_:int = 0;
         var _loc2_:Array = [2070,2071];
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = MissionDataList.getInstance().getMissionByID(_loc2_[_loc4_]);
            if(!_loc3_ || !_loc3_.isCurMission)
            {
               return;
            }
            _loc1_ = int(_activeArr.indexOf(_loc3_));
            if(_loc1_ != -1)
            {
               _activeArr.splice(_loc1_,1);
            }
            _activeArr.push(_loc3_);
            _loc4_++;
         }
      }
      
      private function saveGoodExp(param1:MissionData) : void
      {
         var _loc20_:SubMissionData = null;
         var _loc10_:int = 0;
         var _loc9_:int = 0;
         var _loc5_:RewardData = null;
         var _loc14_:Rectangle = null;
         var _loc8_:ShopData = null;
         var _loc6_:GoodsDetailView = null;
         var _loc11_:Image = null;
         var _loc2_:int = 0;
         var _loc13_:int = 0;
         var _loc7_:DisplayObject = null;
         var _loc4_:Sprite = null;
         var _loc19_:String = null;
         var _loc12_:TextField = null;
         var _loc17_:String = null;
         var _loc15_:TextField = null;
         emptyMissionDataFlag = 1;
         if(!param1)
         {
            param1 = new MissionData();
            emptyMissionDataFlag = 0;
         }
         var _loc16_:String = "";
         _loc10_ = 0;
         while(_loc10_ < param1.submissions.length)
         {
            _loc20_ = param1.submissions[_loc13_];
            _loc16_ += _loc20_.target + "(" + _loc20_.completed + "/" + _loc20_.times + ")" + "\n";
            _loc10_++;
         }
         _scrollText1.text = _loc16_.substr(0,_loc16_.length - 1);
         _scrollText2.text = param1.mdesc;
         this._isFinish = param1.isFinished;
         this._isReward = param1.isRewarded;
         this._currentMissionData = param1;
         param1.isNew = false;
         if(this._isFinish && emptyMissionDataFlag)
         {
            _submitBtn.touchable = true;
            _submitBtn.upState = _atlas.getTexture("rw12");
            _submitBtn.visible = true;
         }
         else
         {
            _submitBtn.touchable = false;
            _submitBtn.upState = _atlas.getTexture("rw12-2");
            _submitBtn.visible = false;
         }
         LocalData.instance.setData(String(PlayerDataList.instance.selfData.uid + param1.msid),"false");
         _rewardArr = [];
         _rewardArr.push([new Image(Assets.sAsset.getTexture("rwCoin")),param1.coin]);
         _rewardArr.push([new Image(Assets.sAsset.getTexture("rwExp")),param1.experience]);
         _loc9_ = 0;
         while(_loc9_ < param1.rewards.length)
         {
            _loc5_ = param1.rewards[_loc9_];
            if(_loc5_.mgender == 0 || _loc5_.mgender - 1 == PlayerDataList.instance.selfData.babySex)
            {
               _loc14_ = Assets.getPosition("shopitem","goodsBox");
               _loc14_.x = 0;
               _loc14_.y = 0;
               _loc8_ = ShopDataList.instance.getSingleData(_loc5_.pcate,_loc5_.pframe);
               _loc6_ = new GoodsDetailView(_loc14_,_loc8_);
               _loc6_.addEvent();
               _loc11_ = Assets.sAsset.getGoodsImage(_loc5_.pcate,_loc5_.pframe);
               _rewardArr.push([_loc6_,_loc5_.quantity]);
            }
            _loc9_++;
         }
         if(_goodsList)
         {
            for each(var _loc18_ in _goodsList)
            {
               _loc18_.removeFromParent(true);
            }
            for each(var _loc3_ in _goodsTextList)
            {
               _loc3_.removeFromParent(true);
            }
            _loc2_ = 0;
            _loc13_ = 0;
            while(_loc13_ < _rewardArr.length)
            {
               if(!(_loc13_ == 0 && _rewardArr[_loc13_] == 0))
               {
                  if(!(_loc13_ == 1 && _rewardArr[_loc13_] == 0))
                  {
                     _loc7_ = _rewardArr[_loc13_][0];
                     _loc4_ = new Sprite();
                     _loc4_.addChild(_loc7_);
                     Assets.positionDisplay(_loc4_,"missionDlg","item" + _loc2_);
                     addChild(_loc4_);
                     if(_loc13_ == 0 || _loc13_ == 1)
                     {
                        _loc19_ = _rewardArr[_loc13_][1] ? String(_rewardArr[_loc13_][1]) : "0";
                        _loc12_ = new TextField(120,40,"X" + _loc19_,"Verdana",30,16777215,true);
                        _loc12_.autoScale = true;
                        _loc12_.nativeFilters = [new DropShadowFilter(0,45,0,1,3.2,3.2,30)];
                        _loc12_.hAlign = "center";
                        _loc12_.y = _loc4_.y + _loc4_.height - 30;
                        _loc12_.x = _loc4_.x - 10;
                        addChild(_loc12_);
                        _goodsTextList.push(_loc12_);
                     }
                     else
                     {
                        _loc17_ = _rewardArr[_loc13_][1] ? String(_rewardArr[_loc13_][1]) : "0";
                        _loc15_ = new TextField(_loc4_.width,60,"+" + _loc17_,"Verdana",30,16777215,true);
                        _loc15_.autoScale = true;
                        _loc15_.nativeFilters = [new DropShadowFilter(0,45,0,1,3.2,3.2,30)];
                        _loc15_.hAlign = "center";
                        _loc15_.y = _loc4_.y + _loc4_.height - 30;
                        _loc15_.x = _loc4_.x + _loc4_.width / 2 - 10;
                        addChild(_loc15_);
                        _goodsTextList.push(_loc15_);
                     }
                     _goodsList.push(_loc4_);
                     _loc2_++;
                  }
               }
               _loc13_++;
            }
         }
         if(param1.isRewarded)
         {
            _submitBtn.visible = false;
         }
         else
         {
            _submitBtn.visible = true;
         }
      }
      
      private function updateList() : void
      {
         var _loc1_:MissionData = null;
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         _missionList.selectedIndex = -1;
         if(_activeBtn.isSelected)
         {
            _activeArr = [];
            _loc3_ = 0;
            while(_loc3_ < MissionDataList.getInstance().mainMissionArr.length)
            {
               _loc1_ = MissionDataList.getInstance().mainMissionArr[_loc3_];
               _activeArr.push(_loc1_);
               _loc3_++;
            }
            sortMissionDataArr(_activeArr);
            specialMissionInEnd();
            _activeData = new ListCollection(_activeArr);
            _missionList.dataProvider = _activeData;
            _missionList.selectedIndex = 0;
         }
         if(_dailyBtn.isSelected)
         {
            _dailyArr = [];
            _loc2_ = 0;
            while(_loc2_ < MissionDataList.getInstance().dailyMissionArr.length)
            {
               _loc1_ = MissionDataList.getInstance().dailyMissionArr[_loc2_];
               if(!_loc1_.isRewarded)
               {
                  _dailyArr.push(_loc1_);
               }
               _loc2_++;
            }
            sortMissionDataArr(_dailyArr);
            _dailyData = new ListCollection(_dailyArr);
            _missionList.dataProvider = _dailyData;
            _missionList.selectedIndex = 0;
         }
         _submitBtn.visible = false;
      }
      
      private function initGoods(param1:Image) : Image
      {
         var _loc3_:Rectangle = null;
         var _loc2_:Rectangle = null;
         _loc3_ = Assets.getPosition("shopitem","goodsBox");
         _loc3_.x = 0;
         _loc3_.y = 0;
         if(param1)
         {
            param1.pivotX = 0;
            param1.pivotY = 0;
            if(param1.width < _loc3_.width && param1.height < _loc3_.height)
            {
               _loc2_ = RectangleUtil.fit(new Rectangle(0,0,param1.width,param1.height),_loc3_,"none");
            }
            else
            {
               _loc2_ = RectangleUtil.fit(new Rectangle(0,0,param1.width,param1.height),_loc3_,"showAll");
            }
            param1.width = _loc2_.width;
            param1.height = _loc2_.height;
            return param1;
         }
         return null;
      }
      
      private function onGoto() : void
      {
         var _loc2_:Hall = null;
         var _loc1_:Hall = null;
         inGuide = false;
         Application.instance.currentGame._guideOptionsData.pos = gotoPage;
         if(Application.instance.currentGame.navigator.activeScreenID != "HALL")
         {
            if(gotoPage != "mission")
            {
               Application.instance.currentGame.navigator.showScreen("HALL");
               _loc2_ = Application.instance.currentGame.navigator.activeScreen as Hall;
               _loc2_.posGuide();
            }
         }
         else
         {
            _loc1_ = Application.instance.currentGame.navigator.activeScreen as Hall;
            _loc1_.posGuide();
         }
      }
   }
}

