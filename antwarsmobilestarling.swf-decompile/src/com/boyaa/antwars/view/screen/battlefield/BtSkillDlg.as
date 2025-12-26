package com.boyaa.antwars.view.screen.battlefield
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.model.FightGoodsData;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.mission.SubMissionData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.battlefield.element.SkillBox;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.BtSelectItem;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.BtSkillDlgItemRender;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.UseWeaponData;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.WeaponChangeManager;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideEventManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.antwars.view.vipSystem.VipManager;
   import com.boyaa.tool.LoadData;
   import feathers.controls.List;
   import feathers.controls.renderers.IListItemRenderer;
   import feathers.data.ListCollection;
   import flash.geom.Rectangle;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.textures.Texture;
   
   public class BtSkillDlg extends UIExportSprite implements IGuideProcess
   {
      
      private static const MAX_NUM:int = 8;
      
      private var bg:Image;
      
      private var closeBtn:Button;
      
      private var sTabBtn:Button;
      
      private var pTabBtn:Button;
      
      private var skillBoxsLenght:int = 0;
      
      private var skillBoxs:Vector.<SkillBox>;
      
      private var propBoxsLenght:int = 0;
      
      private var propBoxs:Vector.<SkillBox>;
      
      private var list:List;
      
      private var skillList:ListCollection;
      
      private var propList:ListCollection;
      
      private var aucteCoin:TextField;
      
      private var boyaaCoin:TextField;
      
      private var gameGold:TextField;
      
      private var accountData:AccountData;
      
      private var skillBoxsOpen:int = 4;
      
      private var _propBoxsOpen:int = 3;
      
      private var markbg:DlgMark;
      
      public var closeSignal:Signal;
      
      private var inGuide:Boolean = false;
      
      private var _isSkillBtnSelect:Boolean = true;
      
      private var _type:int = 0;
      
      private const MAX_NUM:int = 8;
      
      private var _propButton:FashionStarlingButton;
      
      private var _weaponButton:FashionStarlingButton;
      
      private var _propList:List;
      
      private var _rightItems:Vector.<BtSelectItem>;
      
      private var _payPropArr:Array = [];
      
      private var _normalSkillArr:Array = [];
      
      private var _skillItemRenderArr:Vector.<IListItemRenderer> = new Vector.<IListItemRenderer>();
      
      private var _propItemRenderArr:Vector.<IListItemRenderer> = new Vector.<IListItemRenderer>();
      
      private var hasSelectedX1:Boolean;
      
      private var hasSelectedX2:Boolean;
      
      private var hasSelectedX3:Boolean;
      
      private var hasSelectedX4:Boolean;
      
      private var _closeCallBack:Function = null;
      
      public function BtSkillDlg(param1:int = 0)
      {
         super();
         _type = param1;
         initNewUI();
      }
      
      private function loading(param1:Number) : void
      {
         if(param1 == 1)
         {
            initNewUI();
            Application.instance.currentGame.hiddenLoading();
         }
      }
      
      private function initNewUI() : void
      {
         _layout = new LayoutUitl(Assets.sAsset.getOther("btSkillDlg"));
         _layout.buildLayout("propBox",_displayObj);
         addCloseButtonEvent();
         accountData = AccountData.instance;
         _payPropArr = GoodsList.instance.payPorpIdArr;
         _normalSkillArr = GoodsList.instance.normalSkillArr;
         showMark();
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
         initOther();
         initNetData();
         initButtons();
         initLists();
         initRightItems();
         WeaponChangeManager.instance.initWeapon(initByType);
      }
      
      private function initByType() : void
      {
         _propButton.isSelect = _weaponButton.isSelect = false;
         if(_type == 0)
         {
            _propButton.isSelect = true;
            updateSkillShow();
         }
         else
         {
            _weaponButton.isSelect = true;
            updateWeaponShow();
         }
      }
      
      private function initOther() : void
      {
         closeSignal = new Signal();
      }
      
      private function initNetData() : void
      {
         if(BattleServer.instance.isConnect)
         {
            BattleServer.instance.onRecv_buy(onRecv_buy);
         }
      }
      
      private function initRightItems() : void
      {
         var _loc2_:int = 0;
         var _loc1_:BtSelectItem = null;
         _rightItems = new Vector.<BtSelectItem>();
         _loc2_ = 0;
         while(_loc2_ < 8)
         {
            _loc1_ = new BtSelectItem();
            SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("item" + _loc2_),_loc1_);
            addChildToDisplayObject(_loc1_);
            _rightItems.push(_loc1_);
            _loc1_.addEventListener("triggered",onItemTriggerHandle);
            _loc2_++;
         }
         updateSkillShow();
      }
      
      private function initButtons() : void
      {
         _propButton = new FashionStarlingButton(getButtonByName("propButton"));
         _weaponButton = new FashionStarlingButton(getButtonByName("weaponButton"));
         _propButton.groupTag = _weaponButton.groupTag = "BTSKILLDLG_TAB";
         _propButton.isSelect = true;
         _propButton.triggerFunction = onTabSelectHandle;
         _weaponButton.triggerFunction = onTabSelectHandle;
      }
      
      private function initLists() : void
      {
         _propList = new List();
         _propList.horizontalScrollPolicy = "off";
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("propListPos"),_propList);
         addChildToDisplayObject(_propList);
         _propList.layout = SmallCodeTools.instance.getListRowsLayout(5,30);
         _propList.itemRendererType = BtSkillDlgItemRender;
         _propList.dataProvider = new ListCollection(createSkillData());
         _propList.addEventListener("change",onListItemSelectHandle);
         _propList.selectedIndex = -1;
      }
      
      private function vipLock() : void
      {
         var _loc2_:int = 0;
         for each(var _loc1_ in _rightItems)
         {
            _loc1_.lock(false);
         }
         if(_propButton.isSelect)
         {
            if(propBoxsOpen == 3)
            {
               _rightItems[7].lock(true);
            }
            else
            {
               _rightItems[7].lock(false);
            }
         }
         if(_weaponButton.isSelect)
         {
            _loc2_ = 2;
            while(_loc2_ < 8)
            {
               _rightItems[_loc2_].lock(true);
               _loc2_++;
            }
         }
      }
      
      private function onListItemSelectHandle(param1:Event) : void
      {
         var fightGoods:FightGoodsData;
         var good:GoodsData;
         var e:Event = param1;
         var list:List = List(e.currentTarget);
         if(list.selectedIndex == -1)
         {
            return;
         }
         if(_propButton.isSelect)
         {
            fightGoods = list.selectedItem as FightGoodsData;
            buyProp(fightGoods);
         }
         else
         {
            good = list.selectedItem as GoodsData;
            LoadData.show();
            Remoting.instance.changeWeaponInBox(0,good.onlyID,(function():*
            {
               var callBack:Function;
               return callBack = function(param1:Object):void
               {
                  Application.instance.log("PHP-playerChangeWeaponInBox",JSON.stringify(param1));
                  LoadData.hide();
                  if(param1.ret == 0)
                  {
                     addWeapon(good);
                     updateWeaponShow();
                  }
                  else
                  {
                     TextTip.instance.show("add weapon error:" + param1.ret + "|" + param1.msg);
                  }
               };
            })());
         }
         list.selectedIndex = -1;
      }
      
      private function createSkillData() : Vector.<FightGoodsData>
      {
         return GoodsList.instance.getFightGoodsListByType(1).concat(GoodsList.instance.getFightGoodsListByType(2));
      }
      
      private function createWeaponData() : Array
      {
         var _loc6_:int = 0;
         var _loc1_:UseWeaponData = null;
         var _loc4_:int = 0;
         var _loc3_:GoodsData = null;
         var _loc5_:int = 0;
         var _loc2_:Array = GoodsList.instance.getWQ(2);
         if(WeaponChangeManager.instance.weaponVec)
         {
            _loc6_ = 0;
            while(_loc6_ < WeaponChangeManager.instance.weaponVec.length)
            {
               _loc1_ = WeaponChangeManager.instance.weaponVec[_loc6_];
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  _loc3_ = _loc2_[_loc4_];
                  if(_loc3_.onlyID == _loc1_.weaponData.onlyID)
                  {
                     _loc2_.splice(_loc4_,1);
                     break;
                  }
                  _loc4_++;
               }
               _loc6_++;
            }
         }
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc5_];
            if(_loc3_.stutas == 0)
            {
               _loc2_.splice(_loc5_,1);
               _loc5_--;
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      private function onTabSelectHandle(param1:Event) : void
      {
         saveData();
         var _loc2_:Button = param1.target as Button;
         if(_loc2_ == _propButton.starlingBtn)
         {
            _propList.dataProvider = new ListCollection(createSkillData());
            updateSkillShow();
         }
         else
         {
            _propList.dataProvider = new ListCollection(createWeaponData());
            updateWeaponShow();
         }
      }
      
      private function onItemTriggerHandle(param1:Event) : void
      {
         var good:GoodsData;
         var e:Event = param1;
         var item:BtSelectItem = e.target as BtSelectItem;
         if(item.showData == null)
         {
            return;
         }
         if(item.showData is FightGoodsData)
         {
            cancelPropBuy(FightGoodsData(item.showData));
         }
         else
         {
            good = GoodsData(item.showData);
            LoadData.show();
            Remoting.instance.changeWeaponInBox(1,good.onlyID,(function():*
            {
               var callBack:Function;
               return callBack = function(param1:Object):void
               {
                  Application.instance.log("PHP-playerChangeWeaponInBox-delete",JSON.stringify(param1));
                  LoadData.hide();
                  if(param1.ret == 0)
                  {
                     WeaponChangeManager.instance.removeWeaponData(good);
                     _propList.dataProvider = new ListCollection(createWeaponData());
                     updateWeaponShow();
                  }
                  else
                  {
                     TextTip.instance.show("remove weapon error:" + param1.ret + "|" + param1.msg);
                  }
               };
            })());
         }
         item.clearDataShow();
      }
      
      private function addSkill(param1:FightGoodsData) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _rightItems.length)
         {
            if(!_rightItems[_loc2_].showData)
            {
               if(param1.type == 1)
               {
                  if(_normalSkillArr.indexOf(param1.frame.toString()) != -1)
                  {
                     return;
                  }
                  _normalSkillArr.push(param1.frame.toString());
               }
               else
               {
                  _payPropArr.push(param1.frame.toString());
               }
               _rightItems[_loc2_].updateSkill(param1);
               break;
            }
            _loc2_++;
         }
      }
      
      private function removeSkill(param1:FightGoodsData) : void
      {
         if(param1.type == 1)
         {
            _normalSkillArr.splice(_normalSkillArr.indexOf(param1.frame.toString()),1);
         }
         else
         {
            _payPropArr.splice(_payPropArr.indexOf(param1.frame.toString()),1);
         }
      }
      
      private function addWeapon(param1:GoodsData) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _rightItems.length)
         {
            if(!_rightItems[_loc2_].showData)
            {
               _rightItems[_loc2_].updateWeapon(param1);
               WeaponChangeManager.instance.addWeaponData(param1);
               break;
            }
            _loc2_++;
         }
      }
      
      private function clearRightItemsData() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _rightItems.length)
         {
            _rightItems[_loc1_].clearDataShow();
            _loc1_++;
         }
      }
      
      private function updateSkillShow() : void
      {
         var _loc3_:int = 0;
         var _loc2_:FightGoodsData = null;
         clearRightItemsData();
         var _loc1_:Array = GoodsList.instance.getBTPropAndSkill();
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(_loc3_ >= 8)
            {
               break;
            }
            _loc2_ = GoodsList.instance.getFightDataByID(_loc1_[_loc3_]);
            _rightItems[_loc3_].updateSkill(_loc2_);
            _loc3_++;
         }
         vipLock();
      }
      
      private function updateWeaponShow() : void
      {
         var _loc1_:int = 0;
         clearRightItemsData();
         _loc1_ = 0;
         while(_loc1_ < WeaponChangeManager.instance.weaponVec.length)
         {
            _rightItems[_loc1_].updateWeapon(WeaponChangeManager.instance.weaponVec[_loc1_].weaponData);
            _loc1_++;
         }
         _propList.dataProvider = new ListCollection(createWeaponData());
         vipLock();
      }
      
      private function initOldUI() : void
      {
         var _loc9_:int = 0;
         var _loc4_:int = 0;
         var _loc8_:FightGoodsData = null;
         closeSignal = new Signal();
         bg = new Image(Assets.sAsset.getTexture("bb_bg"));
         Assets.positionDisplay(bg,"missionDlg","bg1");
         addChild(bg);
         var _loc10_:Image = new Image(Assets.sAsset.getTexture("55"));
         Assets.positionDisplay(_loc10_,"missionDlg","topbar");
         addChild(_loc10_);
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("bb46"));
         Assets.positionDisplay(_loc5_,"missionDlg","bottomBar");
         addChild(_loc5_);
         sTabBtn = new Button(Assets.sAsset.getTexture("jndj04"),"",Assets.sAsset.getTexture("jndj05"));
         Assets.positionDisplay(sTabBtn,"skillDlg","stab");
         addChild(sTabBtn);
         sTabBtn.addEventListener("triggered",onSTabBtnTriggeredHandle);
         sTabBtn.upState = Assets.sAsset.getTexture("jndj05");
         pTabBtn = new Button(Assets.sAsset.getTexture("jndj06"),"",Assets.sAsset.getTexture("jndj07"));
         Assets.positionDisplay(pTabBtn,"skillDlg","ptab");
         addChild(pTabBtn);
         pTabBtn.addEventListener("triggered",onPTabBtnTriggeredHandle);
         var _loc6_:Image = new Image(Assets.sAsset.getTexture("skill_bg"));
         Assets.positionDisplay(_loc6_,"skillDlg","skill_bg");
         addChild(_loc6_);
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("skill"));
         Assets.positionDisplay(_loc3_,"skillDlg","skill");
         addChild(_loc3_);
         closeBtn = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         Assets.positionDisplay(closeBtn,"skillDlg","closeBtn");
         addChild(closeBtn);
         closeBtn.addEventListener("triggered",onCloseTriggeredHandle);
         skillBoxs = new Vector.<SkillBox>();
         propBoxs = new Vector.<SkillBox>();
         var _loc2_:Vector.<Texture> = new Vector.<Texture>();
         _loc2_.push(Assets.sAsset.getTexture("jndj09"),Assets.sAsset.getTexture("jndj08"),Assets.sAsset.getTexture("jndj10"));
         _loc9_ = 0;
         while(_loc9_ < 4)
         {
            if(_loc9_ >= skillBoxsOpen)
            {
               skillBoxs[_loc9_] = new SkillBox(true,_loc2_);
            }
            else
            {
               skillBoxs[_loc9_] = new SkillBox(false,_loc2_);
               skillBoxs[_loc9_].addEventListener("triggered",onBoxClick);
            }
            Assets.positionDisplay(skillBoxs[_loc9_],"skillDlg","sbox" + (_loc9_ + 1));
            addChild(skillBoxs[_loc9_]);
            if(_loc9_ >= propBoxsOpen)
            {
               propBoxs[_loc9_] = new SkillBox(true,_loc2_);
            }
            else
            {
               propBoxs[_loc9_] = new SkillBox(false,_loc2_);
               propBoxs[_loc9_].addEventListener("triggered",onBoxClick);
            }
            Assets.positionDisplay(propBoxs[_loc9_],"skillDlg","pbox" + (_loc9_ + 1));
            addChild(propBoxs[_loc9_]);
            _loc9_++;
         }
         var _loc1_:Array = GoodsList.instance.getBTPropAndSkill();
         for each(_loc4_ in _loc1_)
         {
            _loc8_ = GoodsList.instance.getFightDataByID(_loc4_);
            if(_loc8_)
            {
               if(_loc8_.type == 1)
               {
                  addSkillBoxs(_loc4_);
               }
               else if(_loc8_.type == 2)
               {
                  addPropBoxs(_loc4_);
               }
            }
         }
         skillList = new ListCollection(GoodsList.instance.getFightGoodsListByType(1));
         propList = new ListCollection(GoodsList.instance.getFightGoodsListByType(2));
         trace("skillList.length:",skillList.length);
         list = new List();
         list.dataProvider = skillList;
         list.itemRendererType = SkillItemRenderer;
         Assets.positionDisplay(list,"skillDlg","item");
         this.addChild(list);
         list.addEventListener("change",listChangeHandler);
         list.addEventListener("rendererAdd",onItemAddToListHandle);
         list.addEventListener("rendererRemove",onItemRemoveListHandle);
         if(BattleServer.instance.isConnect)
         {
            BattleServer.instance.onRecv_buy(onRecv_buy);
         }
         accountData = AccountData.instance;
         var _loc7_:Rectangle = Assets.getPosition("skillDlg","gameGold");
         gameGold = new TextField(_loc7_.width,_loc7_.height,accountData.gameGold.toString(),"Verdana",24,16777215,true);
         gameGold.hAlign = "left";
         gameGold.vAlign = "top";
         gameGold.x = _loc7_.x;
         gameGold.y = _loc7_.y;
         addChild(gameGold);
         _loc7_ = Assets.getPosition("skillDlg","aucteCoin");
         aucteCoin = new TextField(_loc7_.width,_loc7_.height,accountData.aucteCoin.toString(),"Verdana",24,16777215,true);
         aucteCoin.hAlign = "left";
         aucteCoin.vAlign = "top";
         aucteCoin.x = _loc7_.x;
         aucteCoin.y = _loc7_.y;
         addChild(aucteCoin);
         _loc7_ = Assets.getPosition("skillDlg","boyaaCoin");
         boyaaCoin = new TextField(_loc7_.width,_loc7_.height,accountData.boyaaCoin.toString(),"Verdana",24,16777215,true);
         boyaaCoin.hAlign = "left";
         boyaaCoin.vAlign = "top";
         boyaaCoin.x = _loc7_.x;
         boyaaCoin.y = _loc7_.y;
         addChild(boyaaCoin);
         addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onItemRemoveListHandle(param1:Event, param2:IListItemRenderer) : void
      {
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = [_skillItemRenderArr,_propItemRenderArr];
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc3_ = int(_loc4_[_loc5_].indexOf(param2));
            if(_loc3_ != -1)
            {
               _loc4_[_loc5_].splice(_loc3_,1);
               break;
            }
            _loc5_++;
         }
      }
      
      private function onItemAddToListHandle(param1:Event, param2:IListItemRenderer) : void
      {
         if(_isSkillBtnSelect)
         {
            _skillItemRenderArr.push(param2);
         }
         else
         {
            _propItemRenderArr.push(param2);
         }
      }
      
      private function jumpToItem(param1:Vector.<FightGoodsData>, param2:Vector.<IListItemRenderer>, param3:List) : void
      {
         var fightGoodsData:FightGoodsData;
         var i:int;
         var propArr:Vector.<FightGoodsData> = param1;
         var itemRenderArr:Vector.<IListItemRenderer> = param2;
         var list:List = param3;
         var subMissionData:SubMissionData = MissionGuideValue.instance.getUnCompleteSubMissions();
         if(!subMissionData)
         {
            return;
         }
         fightGoodsData = null;
         i = 0;
         while(i < propArr.length)
         {
            fightGoodsData = propArr[i];
            if(fightGoodsData.frame == subMissionData.pframe)
            {
               break;
            }
            fightGoodsData = null;
            i = i + 1;
         }
         if(fightGoodsData)
         {
            list.scrollToDisplayIndex(i);
            Timepiece.instance.addDelayCall((function():*
            {
               var delay:Function;
               return delay = function():void
               {
                  var _loc1_:int = 0;
                  var _loc2_:ListItemRenderer = null;
                  _loc1_ = 0;
                  while(_loc1_ < itemRenderArr.length)
                  {
                     _loc2_ = itemRenderArr[_loc1_] as ListItemRenderer;
                     if(_loc2_.data == fightGoodsData)
                     {
                        GuideEventManager.instance.dispactherEvent("newUI",[[_loc2_,50]]);
                        break;
                     }
                     _loc1_++;
                  }
               };
            })(),300);
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener("addedToStage",onAddedToStage);
         markbg = new DlgMark();
         parent.addChild(markbg);
         parent.swapChildren(markbg,this);
         list.visible = false;
         this.pivotX = 497;
         this.pivotY = 384;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.3,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeInOut",
            "onComplete":onCompleteHandler
         });
      }
      
      private function onCompleteHandler() : void
      {
         list.visible = true;
         if(Application.instance.currentGame._guideOptionsData.pos == "btRoom")
         {
            inGuide = true;
            Guide.instance.guide(list,LangManager.t("guide15"),true);
            pTabBtn.enabled = false;
         }
         else if(Application.instance.currentGame._guideOptionsData.pos == "copyGame")
         {
            inGuide = true;
            sTabBtn.upState = Assets.sAsset.getTexture("jndj04");
            pTabBtn.upState = Assets.sAsset.getTexture("jndj07");
            list.dataProvider = propList;
            Guide.instance.guide(list,LangManager.t("guide18"),true);
            sTabBtn.enabled = false;
         }
         guideProcess();
      }
      
      public function saveData() : void
      {
         GoodsList.instance.setBTPropAndSkill(_payPropArr,_normalSkillArr);
      }
      
      private function listChangeHandler(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         onSelectedItem(_loc2_.selectedItem);
         _loc2_.selectedIndex = -1;
      }
      
      private function addSkillBoxs(param1:int) : Boolean
      {
         var _loc2_:* = null;
         var _loc3_:Boolean = false;
         if(skillBoxsLenght < skillBoxsOpen)
         {
            _loc3_ = false;
            for each(_loc2_ in skillBoxs)
            {
               if(_loc2_.skillId == param1 && !_loc2_.lock)
               {
                  _loc3_ = true;
                  if(param1 == 0)
                  {
                     hasSelectedX1 = true;
                  }
                  if(param1 == 1)
                  {
                     hasSelectedX2 = true;
                  }
                  break;
               }
            }
            if(!_loc3_)
            {
               for each(_loc2_ in skillBoxs)
               {
                  if(_loc2_.skillId == -1)
                  {
                     _loc2_.setSkill(param1);
                     if(param1 == 0)
                     {
                        hasSelectedX1 = true;
                     }
                     if(param1 == 1)
                     {
                        hasSelectedX2 = true;
                     }
                     break;
                  }
               }
               skillBoxsLenght = skillBoxsLenght + 1;
               return true;
            }
         }
         return false;
      }
      
      private function addPropBoxs(param1:int) : Boolean
      {
         var _loc2_:* = null;
         if(propBoxsLenght < propBoxsOpen)
         {
            for each(_loc2_ in propBoxs)
            {
               if(_loc2_.skillId == -1 && !_loc2_.lock)
               {
                  if(_loc2_.skillId == 11)
                  {
                     hasSelectedX3 = true;
                  }
                  if(_loc2_.skillId == 15)
                  {
                     hasSelectedX4 = true;
                  }
                  _loc2_.setSkill(param1);
                  break;
               }
            }
            propBoxsLenght = propBoxsLenght + 1;
            return true;
         }
         return false;
      }
      
      private function onSelectedItem(param1:Object) : void
      {
         var item:Object = param1;
         if(item.type == 1)
         {
            if(item.frame == 0)
            {
               hasSelectedX1 = true;
            }
            if(item.frame == 1)
            {
               hasSelectedX2 = true;
            }
            if(inGuide)
            {
               Guide.instance.guide(closeBtn,"",true);
            }
            if(addSkillBoxs(item.frame))
            {
            }
         }
         else if(item.type == 2)
         {
            if(inGuide)
            {
               Guide.instance.guide(closeBtn,"",true);
            }
            if(propBoxsLenght < propBoxsOpen)
            {
               if(BattleServer.instance.isConnect)
               {
                  BattleServer.instance.buyPayProp(item.frame);
               }
               else
               {
                  Remoting.instance.buyBTProp([item.frame],function(param1:Object):void
                  {
                     if(param1.ret == 0)
                     {
                        AccountData.instance.updateAccount(param1.account);
                        gameGold.text = accountData.gameGold.toString();
                        addPropBoxs(item.frame);
                     }
                  });
               }
            }
         }
      }
      
      private function checkIsEmptyBox() : Boolean
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _rightItems.length)
         {
            if(!_rightItems[_loc1_].showData && !_rightItems[_loc1_].isLock)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function buyProp(param1:FightGoodsData) : void
      {
         var fightGood:FightGoodsData = param1;
         if(!checkIsEmptyBox())
         {
            TextTip.instance.showByLang("propItemBoxFull");
            return;
         }
         if(fightGood.type == 1)
         {
            addSkill(fightGood);
            return;
         }
         LoadData.show();
         if(BattleServer.instance.isConnect)
         {
            BattleServer.instance.buyPayProp(fightGood.frame);
         }
         else
         {
            Remoting.instance.buyBTProp([fightGood.frame],function(param1:Object):void
            {
               if(param1.ret == 0)
               {
                  AccountData.instance.updateAccount(param1.account);
                  addSkill(fightGood);
               }
               else if(param1.ret == 101)
               {
                  TextTip.instance.show(LangManager.replace("payPropIsFull",propBoxsOpen));
               }
               LoadData.hide();
            });
         }
      }
      
      private function cancelPropBuy(param1:FightGoodsData) : void
      {
         var fightGood:FightGoodsData = param1;
         if(fightGood.type == 1)
         {
            removeSkill(fightGood);
            return;
         }
         if(BattleServer.instance.isConnect)
         {
            Application.instance.log("cancelBuy","");
            BattleServer.instance.cancelPayProp(fightGood.frame);
            removeSkill(fightGood);
            accountData.gameGold += fightGood.price;
         }
         else
         {
            LoadData.show();
            Remoting.instance.backBTProp([fightGood.frame],function(param1:Object):void
            {
               if(param1.ret == 0)
               {
                  AccountData.instance.updateAccount(param1.account);
                  removeSkill(fightGood);
               }
               LoadData.hide();
            });
         }
      }
      
      public function setCloseCallBack(param1:Function) : void
      {
         _closeCallBack = param1;
      }
      
      public function onClose() : void
      {
         saveData();
         closeSignal.dispatch();
         Starling.juggler.tween(this,0.3,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeIn",
            "onComplete":cleanUp
         });
         if(inGuide)
         {
            Guide.instance.stop();
         }
         if(_closeCallBack != null)
         {
            _closeCallBack();
         }
         if(this.parent is IGuideProcess)
         {
            IGuideProcess(this.parent).guideProcess("gameStart");
         }
      }
      
      override protected function onCloseHandle(param1:Event) : void
      {
         super.onCloseHandle(param1);
         onClose();
      }
      
      private function onCloseTriggeredHandle(param1:Event) : void
      {
         onClose();
      }
      
      private function onSTabBtnTriggeredHandle(param1:Event) : void
      {
         pTabBtn.upState = Assets.sAsset.getTexture("jndj06");
         sTabBtn.upState = Assets.sAsset.getTexture("jndj05");
         list.dataProvider = skillList;
         _isSkillBtnSelect = true;
         guideProcess("skillBtn");
      }
      
      private function onPTabBtnTriggeredHandle(param1:Event) : void
      {
         sTabBtn.upState = Assets.sAsset.getTexture("jndj04");
         pTabBtn.upState = Assets.sAsset.getTexture("jndj07");
         list.dataProvider = propList;
         _isSkillBtnSelect = false;
         guideProcess("propBtn");
      }
      
      private function onBoxClick(param1:Event) : void
      {
         var fightData:FightGoodsData;
         var e:Event = param1;
         var skillBox:SkillBox = e.currentTarget as SkillBox;
         if(skillBox.skillId != -1)
         {
            fightData = GoodsList.instance.getFightDataByID(skillBox.skillId);
            if(fightData.type == 1)
            {
               skillBoxsLenght = skillBoxsLenght - 1;
            }
            else if(fightData.type == 2)
            {
               propBoxsLenght = propBoxsLenght - 1;
               if(BattleServer.instance.isConnect)
               {
                  BattleServer.instance.cancelPayProp(fightData.frame);
                  accountData.gameGold += fightData.price;
                  gameGold.text = accountData.gameGold.toString();
               }
               else
               {
                  Remoting.instance.backBTProp([fightData.frame],function(param1:Object):void
                  {
                     if(param1.ret == 0)
                     {
                        AccountData.instance.updateAccount(param1.account);
                        gameGold.text = accountData.gameGold.toString();
                     }
                  });
               }
            }
            skillBox.setSkill(-1);
         }
      }
      
      private function onRecv_buy(param1:Object) : void
      {
         var _loc2_:FightGoodsData = null;
         Application.instance.log("propBuy",JSON.stringify(param1));
         LoadData.hide();
         if(param1.data.type == 1)
         {
            TextTip.instance.show(LangManager.t("buySkillCardFail"));
         }
         else
         {
            _loc2_ = GoodsList.instance.getFightDataByID(param1.data.propID);
            if(_loc2_)
            {
               accountData.gameGold -= _loc2_.price;
               addSkill(_loc2_);
            }
         }
      }
      
      private function cleanUp() : void
      {
         Starling.juggler.removeTweens(this);
         removeFromParent(true);
      }
      
      override public function dispose() : void
      {
         if(BattleServer.instance.isConnect)
         {
            BattleServer.instance.disposeRecvFun(onRecv_buy);
         }
         super.dispose();
         Assets.sAsset.removeTextureAtlas("btSkillDlg");
      }
      
      public function guideProcess(param1:Object = null) : void
      {
         var _loc2_:String = MissionGuideValue.instance.getMissionFlag();
         var _loc3_:SubMissionData = MissionGuideValue.instance.getUnCompleteSubMissions();
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:* = _loc2_;
         if("useFightSkill" === _loc4_)
         {
            if(param1 == "propBtn")
            {
               jumpToItem(GoodsList.instance.getFightGoodsListByType(2),_propItemRenderArr,list);
            }
            else if(param1 == "skillBtn")
            {
               jumpToItem(GoodsList.instance.getFightGoodsListByType(1),_skillItemRenderArr,list);
            }
            if(_loc3_.pframe <= 8)
            {
               jumpToItem(GoodsList.instance.getFightGoodsListByType(1),_skillItemRenderArr,list);
            }
            else
            {
               GuideEventManager.instance.dispactherEvent("newUI",[[pTabBtn,40]]);
            }
         }
      }
      
      public function get propBoxsOpen() : int
      {
         if(VipManager.instance.getVipPowerTimes(4) > 0)
         {
            return 4;
         }
         return 3;
      }
   }
}

