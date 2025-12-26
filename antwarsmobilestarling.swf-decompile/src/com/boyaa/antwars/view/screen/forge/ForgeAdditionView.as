package com.boyaa.antwars.view.screen.forge
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.ShopData;
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
   
   public class ForgeAdditionView extends ForgeViewBase
   {
      
      private var _additionBtn:FashionStarlingButton;
      
      private const GOLD:int = 500;
      
      private const BOYAA:int = 1;
      
      public function ForgeAdditionView()
      {
         super();
         _layout = new LayoutUitl(Assets.sAsset.getOther("synthesisView"));
         _layout.buildLayout("additionLayout",_displayObj);
         _quickyBuyLayout = new ForgeQuickyBuy(1);
         _quickyBuyLayout.setForgeView(this);
         init();
      }
      
      override protected function init() : void
      {
         var _loc3_:int = 0;
         var _loc1_:FashionStarlingButton = null;
         super.init();
         _shooseBtnArr = new Vector.<FashionStarlingButton>();
         _loc3_ = 0;
         while(_loc3_ < 2)
         {
            _loc1_ = new FashionStarlingButton(getButtonByName("btnS_choose" + _loc3_));
            _loc1_.groupTag = "additionChoose";
            _loc1_.triggerFunction = onChooseButtonHandle;
            if(_loc3_ == 0)
            {
               _loc1_.isSelect = true;
            }
            _shooseBtnArr.push(_loc1_);
            _loc3_++;
         }
         _additionBtn = new FashionStarlingButton(getButtonByName("btnS_addition"));
         _additionBtn.triggerFunction = onAdditionButtonHandle;
         checkSynthesisButtonIsEnable();
         _quickyBuy = new FashionStarlingButton(getButtonByName("btnS_quickBuy"));
         _quickyBuy.triggerFunction = onQuickBuyHandle;
         stoneData = null;
         var _loc2_:GlowFilter = new GlowFilter(4660230,1,6,6,10);
         getTextFieldByName("percentName").nativeFilters = [_loc2_];
         getTextFieldByName("percentText").nativeFilters = [_loc2_];
         getTextFieldByName("text0").bold = true;
         getTextFieldByName("text1").bold = true;
         getTextFieldByName("text0").nativeFilters = [_loc2_];
         getTextFieldByName("text1").nativeFilters = [_loc2_];
      }
      
      private function getLevel(param1:GoodsData, param2:int) : int
      {
         switch(param2)
         {
            case 1021:
               return param1.nimble;
            case 1041:
               return param1.lucky;
            case 1011:
               return param1.attack;
            case 1031:
               return param1.defense;
            default:
               return 0;
         }
      }
      
      private function getHighLevel(param1:GoodsData, param2:int) : int
      {
         var _loc3_:ShopData = ShopDataList.instance.getSingleData(param1.typeID,param1.frameID);
         switch(param2)
         {
            case 1021:
               return _loc3_.nimble_high;
            case 1041:
               return _loc3_.lucky_high;
            case 1011:
               return _loc3_.attack_high;
            case 1031:
               return _loc3_.defense_high;
            default:
               return 0;
         }
      }
      
      private function onChooseButtonHandle(param1:Event) : void
      {
         var _loc3_:Button = Button(param1.target);
         var _loc2_:int = int(_loc3_.name.substr(_loc3_.name.length - 1));
         _payChoose = _loc2_ == 0 ? 1 : 3;
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
            _additionBtn.isGray = false;
            getTextFieldByName("percentText").text = "100%";
         }
         else
         {
            _additionBtn.isGray = true;
            getTextFieldByName("percentText").text = "0%";
         }
      }
      
      private function onAdditionButtonHandle(param1:Event) : void
      {
         var _loc4_:Array = [_equipData.onlyID,_stoneData.onlyID,0,0,_payChoose];
         var _loc2_:int = getLevel(_equipData,_stoneData.frameID);
         var _loc3_:int = getHighLevel(_equipData,_stoneData.frameID);
         if(_loc2_ >= _loc3_)
         {
            TextTip.instance.showByLang("highAttrTip");
            return;
         }
         GameServer.instance.onAddition(_loc4_,onAdditionByServer);
         _additionBtn.isGray = true;
      }
      
      private function onAdditionByServer(param1:Object) : void
      {
         Application.instance.log("ForgeAddition",JSON.stringify(param1));
         _additionBtn.isGray = false;
         if(param1.data.reply == 1)
         {
            _tip = new ForgeDoneTip(1);
            _tip.setBeforeForgeData(_equipData);
            _equipData.resolveAttribute(param1.data.goodArr[4]);
            _tip.setAfterForgeData(_equipData);
            SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("tipPos"),_tip.displayObj);
            _tip.show();
            if(_payChoose == 1)
            {
               AccountData.instance.gameGold -= 500;
            }
            else
            {
               AccountData.instance.boyaaCoin -= 1;
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
            switch(param1.data.reply)
            {
               case -6:
                  TextTip.instance.showByLang("highAttrTip");
                  break;
               case -9:
                  if(_payChoose == 1)
                  {
                     TextTip.instance.showByLang("noGold");
                     break;
                  }
                  TextTip.instance.showByLang("notEnoughPayGold");
                  break;
               default:
                  TextTip.instance.showByLang("jcsb");
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
         getTextFieldByName("goldText").text = (500).toString();
         getTextFieldByName("boyaaText").text = (1).toString();
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
            getTextFieldByName("text1").text = LangManager.t("putAddStoneInBox");
         }
      }
   }
}

