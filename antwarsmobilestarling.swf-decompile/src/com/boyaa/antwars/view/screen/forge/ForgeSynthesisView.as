package com.boyaa.antwars.view.screen.forge
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.forge.tip.ForgeDoneTip;
   import com.boyaa.antwars.view.screen.forge.tip.ForgeQuickyBuy;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import flash.filters.GlowFilter;
   import starling.display.Button;
   import starling.events.Event;
   
   public class ForgeSynthesisView extends ForgeViewBase
   {
      
      private static const MAX_SYN_LEVEL:int = 5;
      
      private static const GOLD_PAY:Array = [1000,2000,3000,4000,5000];
      
      private static const BOYAA_PAY:Array = [2,4,6,8,10];
      
      private var _synthesisBtn:FashionStarlingButton;
      
      private var glowFilter:GlowFilter = new GlowFilter(4660230,1,6,6,10);
      
      private var _stoneLevel:int = 1;
      
      public function ForgeSynthesisView()
      {
         super();
         _layout = new LayoutUitl(Assets.sAsset.getOther("synthesisView"));
         _layout.buildLayout("synthesisLayout",_displayObj);
         _quickyBuyLayout = new ForgeQuickyBuy(0);
         _quickyBuyLayout.setForgeView(this);
         init();
      }
      
      override protected function init() : void
      {
         var _loc2_:int = 0;
         var _loc1_:FashionStarlingButton = null;
         super.init();
         _shooseBtnArr = new Vector.<FashionStarlingButton>();
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            _loc1_ = new FashionStarlingButton(getButtonByName("btnS_choose" + _loc2_));
            _loc1_.groupTag = "synthesisChoose";
            _loc1_.triggerFunction = onChooseButtonHandle;
            if(_loc2_ == 0)
            {
               _loc1_.isSelect = true;
            }
            _shooseBtnArr.push(_loc1_);
            _loc2_++;
         }
         _synthesisBtn = new FashionStarlingButton(getButtonByName("btnS_synthesis"));
         _synthesisBtn.triggerFunction = onSynthesisButtonHandle;
         checkSynthesisButtonIsEnable();
         _quickyBuy = new FashionStarlingButton(getButtonByName("btnS_quickBuy"));
         _quickyBuy.triggerFunction = onQuickBuyHandle;
         stoneData = null;
         getTextFieldByName("percentName").nativeFilters = [glowFilter];
         getTextFieldByName("percentText").nativeFilters = [glowFilter];
         getTextFieldByName("text0").bold = true;
         getTextFieldByName("text1").bold = true;
         getTextFieldByName("text0").nativeFilters = [glowFilter];
         getTextFieldByName("text1").nativeFilters = [glowFilter];
      }
      
      private function onQuickBuyHandle(param1:Event) : void
      {
         _quickyBuyLayout.x = _quickyBuy.starlingBtn.x - _quickyBuyLayout.width;
         _quickyBuyLayout.y = 100;
         _quickyBuyLayout.show();
      }
      
      private function checkSynthesisButtonIsEnable() : void
      {
         if(_equipData && _stoneData)
         {
            _synthesisBtn.isGray = false;
            getTextFieldByName("percentText").text = "100%";
         }
         else
         {
            _synthesisBtn.isGray = true;
            getTextFieldByName("percentText").text = "0%";
         }
      }
      
      private function onChooseButtonHandle(param1:Event) : void
      {
         var _loc3_:Button = Button(param1.target);
         var _loc2_:int = int(_loc3_.name.substr(_loc3_.name.length - 1));
         _payChoose = _loc2_ == 0 ? 1 : 3;
      }
      
      private function getLevel(param1:GoodsData, param2:int) : int
      {
         switch(param2 - 16)
         {
            case 0:
               return param1.attackLevel;
            case 1:
               return param1.nimbleLevel;
            case 2:
               return param1.defenseLevel;
            case 3:
               return param1.luckyLevel;
            default:
               return 0;
         }
      }
      
      private function onSynthesisButtonHandle(param1:Event) : void
      {
         var _loc3_:Array = [_equipData.onlyID,_stoneData.onlyID,0,0,_payChoose];
         var _loc2_:int = getLevel(_equipData,_stoneData.typeID);
         if(_loc2_ >= 5)
         {
            TextTip.instance.showByLang("highAttrSynTip");
            return;
         }
         if(_loc2_ >= _stoneLevel)
         {
            TextTip.instance.showByLang("stoneLevelEnough");
            return;
         }
         GameServer.instance.onSynthesis(_loc3_,onSynthesisByServer);
         _synthesisBtn.isGray = true;
      }
      
      private function onSynthesisByServer(param1:Object) : void
      {
         Application.instance.log("ForgeSynthesis",JSON.stringify(param1));
         _synthesisBtn.isGray = false;
         if(param1.data.reply == 1)
         {
            _tip = new ForgeDoneTip(0);
            _tip.setBeforeForgeData(_equipData);
            _equipData.resolveSynthesis(param1.data.goodArr[5]);
            _tip.setAfterForgeData(_equipData);
            SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("tipPos"),_tip.displayObj);
            _tip.show();
            if(_payChoose == 1)
            {
               AccountData.instance.gameGold -= GOLD_PAY[_stoneLevel - 1];
            }
            else
            {
               AccountData.instance.boyaaCoin -= BOYAA_PAY[_stoneLevel - 1];
            }
            GoodsList.instance.reduceConsumeGoods(_stoneData.typeID,_stoneData.frameID,1);
            if(_stoneData.amount == 0)
            {
               _stoneImgInForge.removeFromParent(true);
               stoneData = null;
            }
            doneSignal.dispatch();
            ForgeGoodsBox.updateSignal.dispatch();
         }
         else
         {
            var _loc2_:* = param1.data.reply;
            if(-6 !== _loc2_)
            {
               TextTip.instance.showByLang("hcsb");
            }
            else if(_payChoose == 1)
            {
               TextTip.instance.showByLang("noGold");
            }
            else
            {
               TextTip.instance.showByLang("notEnoughPayGold");
            }
         }
      }
      
      private function updatePay() : void
      {
         if(!_stoneData)
         {
            getTextFieldByName("goldText").text = "0";
            getTextFieldByName("boyaaText").text = "0";
            return;
         }
         _stoneLevel = (_stoneData.frameID - 1000) / 10;
         getTextFieldByName("goldText").text = GOLD_PAY[_stoneLevel - 1];
         getTextFieldByName("boyaaText").text = BOYAA_PAY[_stoneLevel - 1];
      }
      
      override public function set equipData(param1:GoodsData) : void
      {
         _equipData = param1;
         checkSynthesisButtonIsEnable();
         if(_equipData)
         {
            getTextFieldByName("text0").text = "";
         }
         else
         {
            getTextFieldByName("text0").text = LangManager.t("putEquiptInBox");
         }
      }
      
      override public function set stoneData(param1:GoodsData) : void
      {
         _stoneData = param1;
         checkSynthesisButtonIsEnable();
         updatePay();
         if(_stoneData)
         {
            getTextFieldByName("text1").text = "";
         }
         else
         {
            getTextFieldByName("text1").text = LangManager.t("putSynStoneInBox");
         }
      }
   }
}

