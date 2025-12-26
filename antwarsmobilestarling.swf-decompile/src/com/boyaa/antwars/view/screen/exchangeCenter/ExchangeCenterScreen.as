package com.boyaa.antwars.view.screen.exchangeCenter
{
   import com.boyaa.antwars.data.ExchangeList;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.ExchangeNeedItem;
   import com.boyaa.antwars.data.model.ExchangePropItem;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.tool.LoadData;
   import feathers.controls.List;
   import feathers.controls.Screen;
   import feathers.data.ListCollection;
   import feathers.layout.TiledRowsLayout;
   import starling.display.Button;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class ExchangeCenterScreen extends Screen
   {
      
      private var _asset:ResAssetManager;
      
      private var _layoutUitl:LayoutUitl;
      
      private var _closeBtn:Button;
      
      private var _exchangeBtn:Button;
      
      private var _propsList:List;
      
      private var _labels:Array;
      
      private var _selectedProp:ExchangePropItem;
      
      private var _needsProp:Array;
      
      private var _tradingProps:Array;
      
      private var _markBg:DlgMark;
      
      private var _displayObject:Sprite;
      
      public function ExchangeCenterScreen()
      {
         super();
         _asset = Assets.sAsset;
         _selectedProp = null;
         _needsProp = [];
         _tradingProps = [];
         _markBg = new DlgMark();
         addChild(_markBg);
         _displayObject = new Sprite();
         addChild(_displayObject);
         loadAssets();
      }
      
      private function loadAssets() : void
      {
         LoadData.show();
         var _loc1_:ResManager = Application.instance.resManager;
         _asset.enqueue(_loc1_.getResFile(formatString("asset/exchange.info")),_loc1_.getResFile(formatString("textures/{0}x/OTHER/exchange.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/OTHER/exchange.xml",Assets.sAsset.scaleFactor)));
         _asset.loadQueue(loading);
      }
      
      private function loading(param1:Number) : void
      {
         if(param1 == 1)
         {
            LoadData.hide();
            Application.instance.currentGame.hiddenLoading();
            _layoutUitl = new LayoutUitl(_asset.getOther("exchange"),_asset);
            _layoutUitl.buildLayout("exchangeCenterLayout",_displayObject);
            SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObject);
            initButton();
            initTextField();
            GuideTipManager.instance.windowTopOnHall = true;
         }
      }
      
      private function initButton() : void
      {
         _closeBtn = _displayObject.getChildByName("btnS_close") as Button;
         _closeBtn.addEventListener("triggered",onClose);
         _exchangeBtn = _displayObject.getChildByName("exchangeBtn") as Button;
         _exchangeBtn.addEventListener("triggered",onExchange);
         var _loc2_:Array = ExchangeList.instance.getPropItems();
         _propsList = new List();
         _propsList.itemRendererType = ExchangePropButton;
         _propsList.dataProvider = new ListCollection(_loc2_);
         SmallCodeTools.instance.setDisplayObjectInSame(_displayObject.getChildByName("props_pos"),_propsList);
         _displayObject.addChild(_propsList);
         _propsList.addEventListener("change",onListChangeHandler);
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.useSquareTiles = false;
         _loc1_.gap = 5;
         _loc1_.paddingTop = 5;
         _propsList.layout = _loc1_;
      }
      
      private function initTextField() : void
      {
         _labels = [];
         _labels.push(_displayObject.getChildByName("descTxt") as TextField);
         _labels.push(_displayObject.getChildByName("itemTxt0") as TextField);
         _labels.push(_displayObject.getChildByName("itemTxt1") as TextField);
         _labels.push(_displayObject.getChildByName("itemTxt2") as TextField);
         _labels.push(_displayObject.getChildByName("itemTxt3") as TextField);
         _labels.push(_displayObject.getChildByName("itemTxt4") as TextField);
         clearTextField();
         (_labels[0] as TextField).text = LangManager.getLang.getLangByStr("excg_label_tip");
      }
      
      private function onListChangeHandler(param1:Event) : void
      {
         var _loc6_:int = 0;
         var _loc3_:ExchangeNeedItem = null;
         var _loc2_:TextField = null;
         var _loc4_:ShopData = null;
         var _loc5_:List = List(param1.currentTarget);
         if(_loc5_.selectedIndex == -1)
         {
            return;
         }
         if(!_exchangeBtn.enabled)
         {
            return;
         }
         clearTextField();
         _selectedProp = _loc5_.selectedItem as ExchangePropItem;
         _needsProp = ExchangeList.instance.getNeedItemsByPropid(_selectedProp.propid);
         _loc6_ = 0;
         while(_loc6_ < _needsProp.length)
         {
            _loc3_ = _needsProp[_loc6_] as ExchangeNeedItem;
            _loc2_ = getNextEmptyTextField();
            if(_loc2_)
            {
               _loc4_ = ShopDataList.instance.getSingleData(_loc3_.pcate,_loc3_.pframe);
               _loc2_.text = _loc4_.name + " X" + _loc3_.quantity;
            }
            else
            {
               trace("ERROR: no empty TextField left!!!");
            }
            _loc6_++;
         }
      }
      
      private function onClose(param1:Event) : void
      {
         this.removeFromParent(true);
      }
      
      private function onExchange(param1:Event) : void
      {
         var _loc8_:int = 0;
         var _loc3_:ExchangeNeedItem = null;
         var _loc7_:Array = null;
         var _loc2_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         if(_selectedProp == null)
         {
            TextTip.instance.show(LangManager.getLang.getLangByStr("excg_please_select"));
            return;
         }
         _exchangeBtn.enabled = false;
         _tradingProps = [];
         _loc8_ = 0;
         while(_loc8_ < _needsProp.length)
         {
            _loc3_ = _needsProp[_loc8_] as ExchangeNeedItem;
            _loc7_ = GoodsList.instance.getConsumeGoods(_loc3_.pcate,_loc3_.pframe);
            _loc2_ = int(_loc7_[_loc7_.length - 1]);
            if(_loc2_ < _loc3_.quantity)
            {
               TextTip.instance.show(LangManager.getLang.getLangByStr("excg_not_enough"));
               _exchangeBtn.enabled = true;
               return;
            }
            _loc6_ = _loc3_.quantity;
            _loc5_ = 0;
            while(_loc5_ < _loc7_.length - 1)
            {
               if(_loc7_[_loc5_][1] >= _loc6_)
               {
                  _tradingProps.push([_loc7_[_loc5_][0],_loc6_]);
                  break;
               }
               _tradingProps.push(_loc7_[_loc5_]);
               _loc6_ -= _loc7_[_loc5_][1];
               _loc5_++;
            }
            _loc8_++;
         }
         var _loc4_:int = int(PlayerDataList.instance.selfData.uid);
         GameServer.instance.exchangePropMessage(_loc4_,_selectedProp.propid,_tradingProps,onExchangeServerResponse);
      }
      
      private function onExchangeServerResponse(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc2_:ExchangeNeedItem = null;
         _exchangeBtn.enabled = true;
         var _loc3_:Array = param1 as Array;
         if(_loc3_[0])
         {
            _loc4_ = 0;
            while(_loc4_ < _needsProp.length)
            {
               _loc2_ = _needsProp[_loc4_] as ExchangeNeedItem;
               GoodsList.instance.reduceConsumeGoods(_loc2_.pcate,_loc2_.pframe,_loc2_.quantity);
               _loc4_++;
            }
            TextTip.instance.show(LangManager.getLang.getLangByStr("excg_success"));
         }
         else
         {
            TextTip.instance.show("server error");
         }
         _tradingProps = [];
      }
      
      private function clearTextField() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 1;
         while(_loc1_ < _labels.length)
         {
            (_labels[_loc1_] as TextField).text = "";
            _loc1_++;
         }
         _needsProp = [];
      }
      
      private function getNextEmptyTextField() : TextField
      {
         var _loc1_:int = 0;
         _loc1_ = 1;
         while(_loc1_ < _labels.length)
         {
            if((_labels[_loc1_] as TextField).text == "")
            {
               return _labels[_loc1_] as TextField;
            }
            _loc1_++;
         }
         return null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Assets.sAsset.removeTextureAtlas("exchange");
         GuideTipManager.instance.windowTopOnHall = false;
      }
   }
}

