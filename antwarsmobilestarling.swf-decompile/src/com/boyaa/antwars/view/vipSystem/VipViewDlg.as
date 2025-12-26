package com.boyaa.antwars.view.vipSystem
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.activity.ActivityBase;
   import com.boyaa.antwars.view.screen.shop.GoodsDetailView;
   import feathers.controls.List;
   import feathers.controls.ScrollContainer;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class VipViewDlg extends ActivityBase
   {
      
      private const MAX_VIP_LEVEL:int = 10;
      
      private var _infoScroller:ScrollContainer = new ScrollContainer();
      
      private var _buttonsScroller:ScrollContainer = new ScrollContainer();
      
      private var _powerList:List;
      
      private var _infoSprite:Sprite;
      
      private var _rewardSprite:Sprite;
      
      private var _loadingSprite:Sprite;
      
      private var _infoTxt:TextField;
      
      private var _vipMoneyTxt:TextField;
      
      private var _vipLevelTxt:TextField;
      
      private var _loadingTxt:TextField;
      
      private var _conditionTxt:TextField;
      
      private var _txt_vip:TextField;
      
      private var _buttonsLayout:Sprite;
      
      private var _btnPre:Button;
      
      private var _btnNext:Button;
      
      private var _rewardButton:FashionStarlingButton;
      
      private var _currentLevel:int = -1;
      
      private var _giftImgArr:Array = [];
      
      private var txt_loading:TextField;
      
      public function VipViewDlg(param1:Boolean = true)
      {
         super();
      }
      
      override protected function initLoadAsset() : void
      {
         super.initLoadAsset();
         _assetArr = ["asset/vipView.info","textures/{0}x/OTHER/vipView.png","textures/{0}x/OTHER/vipView.xml"];
         _layoutInfoName = "vipView";
         _layoutName = "vipMainViewLayout";
      }
      
      override protected function init() : void
      {
         super.init();
         _infoSprite = getSpriteByName("infoSprite");
         _rewardSprite = getSpriteByName("rewardSprite");
         _loadingSprite = getSpriteByName("loadingBar",_infoSprite);
         _vipLevelTxt = getTextFieldByName("vipLevelTxt",_infoSprite);
         _vipMoneyTxt = getTextFieldByName("vipMoneyTxt",_infoSprite);
         _conditionTxt = getTextFieldByName("condition",_infoSprite);
         _txt_vip = getTextFieldByName("txt_vip_num",_infoSprite);
         _txt_vip.nativeFilters = StarlingUITools.instance.getDropShadowFilter();
         txt_loading = getTextFieldByName("loadingTxt",_loadingSprite);
         txt_loading.nativeFilters = StarlingUITools.instance.getDropShadowFilter();
         getTextFieldByName("powerTitle",_infoSprite).vAlign = "top";
         _vipLevelTxt.bold = true;
         _vipLevelTxt.nativeFilters = StarlingUITools.instance.getDropShadowFilter(0,40);
         _infoScroller.layout = SmallCodeTools.instance.getListRowsLayout();
         _buttonsScroller.layout = SmallCodeTools.instance.getListRowsLayout();
         initPowerTipText();
         initVipButtons();
         initGoodsNumText();
         getButtonByName("rechargeBtn",_infoSprite).addEventListener("triggered",onRechargeTriggerHandle);
         _rewardButton = new FashionStarlingButton(getButtonByName("rewardBtn",_rewardSprite));
         _rewardButton.triggerFunction = onRewardTriggerHandle;
         VipManager.instance.getVipViewInfo(1,onVipViewInfo);
      }
      
      private function onVipViewInfo(param1:Object) : void
      {
         Application.instance.log("onVipViewInfo",JSON.stringify(param1));
         if(_currentLevel == -1)
         {
            _currentLevel = param1.data.vipLevel == 0 ? 1 : param1.data.vipLevel;
         }
         _vipLevelTxt.text = "VIP " + param1.data.vipLevel;
         setMoneyLoading(param1.data.boyaaCoin,param1.data.nextLevelCoin);
         var _loc2_:int = int(param1.data.nextLevelCoin) - int(param1.data.boyaaCoin);
         if(PlayerDataList.instance.selfData.vipLevel >= VipManager.instance.MAX_VIP_LEVEL)
         {
            _vipMoneyTxt.text = LangManager.t("vipTopLevelTip");
         }
         else
         {
            _vipMoneyTxt.text = LangManager.getLang.getreplaceLang("vipNextLevelText",_loc2_,param1.data.nextLevel);
         }
         if(param1.data.isReward)
         {
            _rewardButton.isGray = false;
         }
         else
         {
            _rewardButton.isGray = true;
         }
         showRewardShopData(param1.data.giftArr);
      }
      
      private function initGoodsNumText() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            getTextFieldByName("boxTxt" + _loc1_,_rewardSprite).color = 16777215;
            getTextFieldByName("boxTxt" + _loc1_,_rewardSprite).bold = true;
            getTextFieldByName("boxTxt" + _loc1_,_rewardSprite).y = getTextFieldByName("boxTxt" + _loc1_,_rewardSprite).y - 60;
            getTextFieldByName("boxTxt" + _loc1_,_rewardSprite).nativeFilters = StarlingUITools.instance.getDropShadowFilter();
            _loc1_++;
         }
      }
      
      private function showRewardShopData(param1:Array) : void
      {
         var _loc3_:Array = null;
         var _loc2_:Array = null;
         var _loc5_:ShopData = null;
         var _loc4_:GoodsDetailView = null;
         var _loc6_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < _giftImgArr.length)
         {
            _loc3_ = _giftImgArr[_loc6_];
            DisplayObject(_loc3_[0]).removeFromParent(true);
            TextField(_loc3_[1]).text = "";
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < param1.length)
         {
            _loc2_ = param1[_loc6_];
            _loc5_ = ShopDataList.instance.getSingleData(_loc2_[0],_loc2_[1]);
            _loc4_ = new GoodsDetailView(getDisplayObjByName("box" + _loc6_,_rewardSprite).bounds,_loc5_);
            _loc4_.addEvent();
            _rewardSprite.addChild(_loc4_);
            getTextFieldByName("boxTxt" + _loc6_,_rewardSprite).text = "x" + _loc2_[2];
            _rewardSprite.addChild(getTextFieldByName("boxTxt" + _loc6_,_rewardSprite));
            _giftImgArr.push([_loc4_,getTextFieldByName("boxTxt" + _loc6_,_rewardSprite)]);
            _loc6_++;
         }
      }
      
      private function setMoneyLoading(param1:int, param2:int) : void
      {
         var _loc3_:DisplayObject = getDisplayObjByName("loadingBar",_loadingSprite);
         _loc3_.scaleX = param1 / param2;
         if(param1 > param2)
         {
            _loc3_.scaleX = 1;
         }
         txt_loading.text = param1 + "/" + param2;
      }
      
      private function initVipButtons() : void
      {
         _btnPre = _infoSprite.getChildByName("btn_pre") as Button;
         _btnNext = _infoSprite.getChildByName("btn_next") as Button;
         _btnPre.addEventListener("triggered",onPreVip);
         _btnNext.addEventListener("triggered",onNextVip);
      }
      
      private function onPreVip(param1:Event) : void
      {
         _currentLevel = _currentLevel - 1;
         _currentLevel = _currentLevel <= 0 ? 10 : _currentLevel;
         setInfoText(_currentLevel + "");
         VipManager.instance.getVipViewInfo(_currentLevel,onVipViewInfo);
      }
      
      private function onNextVip(param1:Event) : void
      {
         _currentLevel = _currentLevel + 1;
         _currentLevel = _currentLevel > 10 ? 1 : _currentLevel;
         setInfoText(_currentLevel + "");
         VipManager.instance.getVipViewInfo(_currentLevel,onVipViewInfo);
      }
      
      private function vipButtonTriggerHandle(param1:Event) : void
      {
         trace("vipButton trigger");
         var _loc2_:String = Button(param1.currentTarget).name.substr(3);
         setInfoText(_loc2_);
         VipManager.instance.getVipViewInfo(int(_loc2_),onVipViewInfo);
         _currentLevel = int(_loc2_);
      }
      
      private function initPowerTipText() : void
      {
         _infoTxt = SmallCodeTools.instance.getTitleTextField(24,VipManager.instance.getLevelTipInfo(1)[1],16777215);
         _infoScroller.addChild(_infoTxt);
         SmallCodeTools.instance.setDisplayObjectInSame(_infoSprite.getChildByName("powerInfoListPos"),_infoScroller);
         _infoSprite.addChild(_infoScroller);
         _infoTxt.width = _infoScroller.width;
         _infoTxt.height = _infoTxt.textBounds.height;
         _infoTxt.autoScale = true;
         _infoTxt.vAlign = "top";
         setInfoText("1");
      }
      
      private function onRechargeTriggerHandle(param1:Event) : void
      {
         Application.instance.currentGame.mainMenu.onRechargeBtn();
      }
      
      private function onRewardTriggerHandle(param1:Event) : void
      {
         var e:Event = param1;
         trace("reward gifts");
         GameServer.instance.getVipLevelGift(_currentLevel,(function():*
         {
            var callBack:Function;
            return callBack = function(param1:Object):void
            {
               Application.instance.log("getVipLevelGift",JSON.stringify(param1));
               if(param1.data.flag)
               {
                  TextTip.instance.showByLang("ljcg");
                  showRewardShopData([]);
               }
            };
         })());
      }
      
      private function setInfoText(param1:String) : void
      {
         _txt_vip.text = LangManager.replace("vipLevelTip",param1);
         var _loc2_:Array = VipManager.instance.getLevelTipInfo(int(param1));
         _infoTxt.height = 1000;
         _infoTxt.text = _loc2_[1];
         _infoTxt.height = _infoTxt.textBounds.height + _infoTxt.fontSize;
         _infoTxt.removeFromParent();
         _infoScroller.addChild(_infoTxt);
         setConditionText(param1,_loc2_[0]);
      }
      
      private function setConditionText(param1:String, param2:String) : void
      {
         _conditionTxt.text = LangManager.getLang.getreplaceLang("vipCondition",param1,param2);
      }
   }
}

