package com.boyaa.antwars.view.screen.union.store
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.UnionListItemModel;
   import com.boyaa.antwars.data.UnionShopData;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.shop.ShopBuyDlg;
   import com.boyaa.antwars.view.screen.shop.ShopItemDetailTip;
   import com.boyaa.antwars.view.screen.union.UnionCoreDlg;
   import com.boyaa.antwars.view.screen.union.UnionEvent;
   import com.boyaa.antwars.view.screen.union.commonBtn.LabelButton;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.tool.LoadData;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import org.osflash.signals.Signal;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class UnionStoreDlg extends UnionCoreDlg
   {
      
      public static var wearSignal:Signal = new Signal(ShopData);
      
      private var _character:Character;
      
      private var _closeBtn:Button;
      
      private var _buttonTextureArr:Array;
      
      private var _buttons:Array;
      
      private var _itemList:List;
      
      private var _currentShopData:ShopData;
      
      private var _storeLevelBtn:Button;
      
      private var _needLevel:Array;
      
      private var _frameBtns:Sprite;
      
      private var _curLevel:int = 0;
      
      public const UP_LEVEL_PRICE:Array = [0,80000,144000,224000,360000];
      
      private var buyDlg:ShopBuyDlg = null;
      
      public function UnionStoreDlg()
      {
         super();
      }
      
      override protected function getRawAssets() : Array
      {
         _rawAssets = [rmger.getResFile(formatString("asset/UnionStore.info")),rmger.getResFile(formatString("textures/{0}x/Union/UnionStore.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/Union/UnionStore.xml",Assets.sAsset.scaleFactor))];
         return _rawAssets;
      }
      
      override protected function loadAssetDone(param1:int) : void
      {
         var _loc8_:int = 0;
         var _loc3_:LayoutUitl = null;
         var _loc7_:Array = null;
         var _loc2_:String = null;
         var _loc4_:Button = null;
         var _loc6_:PlayerData = null;
         var _loc5_:DisplayObject = null;
         if(param1 == 1)
         {
            ShopDataList.instance.shopType = 1;
            _loc3_ = new LayoutUitl(_asset.getOther("UnionStore"),_asset);
            _loc3_.buildLayout("UnionStoreLayout",_displayObj);
            _closeBtn = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
            _closeBtn.x = 930;
            _closeBtn.y = 20;
            _closeBtn.addEventListener("triggered",onclose);
            _displayObj.addChild(_closeBtn);
            _buttonTextureArr = [];
            _buttons = [];
            _loc7_ = ["a","b","c","d","e"];
            _loc8_ = 0;
            while(_loc8_ < 5)
            {
               _loc2_ = "btnS_UnionStoreItemBtn" + _loc7_[_loc8_];
               _loc4_ = getButtonByName(_loc2_);
               _loc4_.addEventListener("triggered",onNavBtnClick);
               _buttonTextureArr.push([_loc4_.upState,_loc4_.downState,_loc4_]);
               _buttons.push(_loc4_);
               _loc8_++;
            }
            (_buttons[0] as Button).upState = (_buttons[0] as Button).downState;
            _itemList = new List();
            _itemList.itemRendererType = UnionStoreItemRender;
            _displayObj.addChild(_itemList);
            _itemList.x = 305;
            _itemList.y = 200;
            _itemList.width = 700;
            _itemList.height = 467;
            _itemList.dataProvider = new ListCollection(ShopDataList.instance.getUnionGoodsByLevel(1));
            _itemList.addEventListener("change",onItemSelect);
            _loc6_ = PlayerDataList.instance.selfData;
            _character = CharacterFactory.instance.checkOutCharacter(_loc6_.babySex);
            _character.initData(_loc6_.getPropData());
            _character.scaleY = 0.5;
            _character.scaleX = _character.scaleY;
            _loc5_ = getDisplayObjByName("character");
            SmallCodeTools.instance.setDisplayObjectInSamePos(_loc5_,_character);
            getTextFieldByName("LevelTF").text = UnionManager.getInstance().myUnionModel.shoplevel + "";
            UnionManager.getInstance().addEventListener("unionBuyDone",buyItemHandel);
            updateAccountInfo();
            UnionManager.getInstance().addEventListener(UnionEvent.UNION_DATA_REFRESH,unionDataRefreshDone);
            _storeLevelBtn = _displayObj.getChildByName("btnS_unionLevelBtn") as Button;
            _storeLevelBtn.addEventListener("triggered",storeLevelUpHandel);
            initTextInfo();
            showAttrText(PlayerDataList.instance.selfData.ability());
            setDisplayObjectInMiddle();
            _displayObj.addChild(_character);
            wearSignal.add(wearCloths);
            _frameBtns = new Sprite();
            addChild(_frameBtns);
            _frameBtns.visible = false;
            initFrameBtns();
            ShopItemDetailTip.getInstance().buySignal.add(onDetailBuy);
            this.stage.addChild(ShopItemDetailTip.getInstance());
            ShopItemDetailTip.getInstance().visible = false;
            this.stage.addEventListener("touch",onTouch);
         }
         super.loadAssetDone(param1);
      }
      
      private function unionDataRefreshDone(param1:UnionEvent) : void
      {
         updateAccountInfo();
      }
      
      private function onDetailBuy() : void
      {
         buyItem(_currentShopData);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:Vector.<Touch> = param1.getTouches(this.stage);
         if(_loc2_.length > 0 && _loc2_[0].phase == "began")
         {
            _loc3_ = param1.getTouches(_itemList);
            if(_loc3_.length > 0 && _loc3_[0].phase == "began")
            {
               _frameBtns.x = _loc3_[0].globalX;
               _frameBtns.y = _loc3_[0].globalY;
               if(_frameBtns.x > 700)
               {
                  _frameBtns.x = 700;
               }
            }
            if(_frameBtns.visible)
            {
               _loc4_ = param1.getTouches(_frameBtns);
               if(_loc4_.length == 0)
               {
                  _frameBtns.visible = false;
                  _itemList.selectedIndex = -1;
               }
            }
         }
      }
      
      private function onItemSelect(param1:Event) : void
      {
         var _loc3_:List = param1.currentTarget as List;
         if(_loc3_.selectedIndex == -1)
         {
            return;
         }
         var _loc2_:UnionShopData = _loc3_.selectedItem as UnionShopData;
         _currentShopData = ShopDataList.instance.getSingleData(_loc2_.typeID,_loc2_.frameID);
         if(_curLevel + 1 <= UnionManager.getInstance().myUnionModel.shoplevel)
         {
            _frameBtns.visible = true;
         }
         if(buyDlg && buyDlg.parent)
         {
            _frameBtns.visible = false;
         }
      }
      
      private function initFrameBtns() : void
      {
         var _loc2_:LabelButton = null;
         var _loc5_:int = 0;
         while(_frameBtns.numChildren)
         {
            _frameBtns.removeChildAt(0);
         }
         var _loc3_:Array = [{
            "title":"unionStoreTip0",
            "callBack":checkShopData
         }];
         var _loc1_:int = 20;
         var _loc6_:int = 30;
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc2_ = new LabelButton(LangManager.t(_loc3_[_loc5_]["title"]),131,55);
            _frameBtns.addChild(_loc2_);
            _loc2_.x = _loc1_;
            _loc2_.y = 20;
            _loc1_ = _loc1_ + _loc6_ + _loc2_.width;
            _loc2_.addEventListener("triggered",_loc3_[_loc5_]["callBack"]);
            _loc5_++;
         }
         var _loc4_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("tips_scale9"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         _loc4_.width = _loc1_ + 10;
         _loc4_.height = 96;
         _frameBtns.addChildAt(_loc4_,0);
      }
      
      private function checkShopData() : void
      {
         if(_currentShopData)
         {
            ShopItemDetailTip.getInstance().setData(_currentShopData);
            ShopItemDetailTip.getInstance().showButtonById(5);
            ShopItemDetailTip.getInstance().x = 807;
            ShopItemDetailTip.getInstance().y = 100;
            ShopItemDetailTip.getInstance().visible = true;
            _frameBtns.visible = false;
         }
      }
      
      private function wearCloths(param1:ShopData) : void
      {
         _character.wear(Constants.getGoodsNameById(param1.typeID),param1.typeID,param1.frameID);
      }
      
      private function storeLevelUpHandel(param1:Event) : void
      {
         if(UnionManager.getInstance().myUnionModel.position == 8 || UnionManager.getInstance().myUnionModel.position == 9)
         {
            TextTip.instance.showByLang("canUplevelUnion");
            return;
         }
         var _loc2_:int = UnionManager.getInstance().myUnionModel.shoplevel;
         _needLevel = [4,5,6,8,10];
         if(_loc2_ == UP_LEVEL_PRICE.length)
         {
            TextTip.instance.showByLang("unionshopLevelHighest");
            return;
         }
         if(UnionManager.getInstance().myUnionModel.clevel < _needLevel[_loc2_])
         {
            TextTip.instance.show(LangManager.getLang.getreplaceLang("unionNeedLevel",_needLevel[_loc2_]));
            return;
         }
         SystemTip.instance.showSystemAlert(LangManager.getLang.getreplaceLang("payUpLevelUnionShop",UP_LEVEL_PRICE[_loc2_]),okHandler,null);
      }
      
      private function okHandler() : void
      {
         var _loc2_:UnionListItemModel = UnionManager.getInstance().myUnionModel;
         var _loc1_:int = _loc2_.shoplevel;
         if(_loc2_.cdevote < UP_LEVEL_PRICE[_loc1_])
         {
            TextTip.instance.show(LangManager.getLang.getLangByStr("noContributor"));
            return;
         }
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("upUnionLevel",upUnionLevelHandler);
         Remoting.instance.gameTable.upUnionLevel(2);
      }
      
      private function upUnionLevelHandler(param1:PHPEvent) : void
      {
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         var _loc4_:int = UnionManager.getInstance().myUnionModel.shoplevel;
         if(_loc3_.ret == 0)
         {
            TextTip.instance.show(LangManager.getLang.getLangByStr("uplevelOK"));
            UnionManager.getInstance().myUnionModel.shoplevel = _loc3_.clevel;
            UnionManager.getInstance().myUnionModel.cdevote = UnionManager.getInstance().myUnionModel.cdevote - UP_LEVEL_PRICE[_loc4_];
            (this._displayObj.getChildByName("LevelTF") as TextField).text = UnionManager.getInstance().myUnionModel.shoplevel + "";
            MissionManager.instance.updateMissionData(126);
            return;
         }
         throw new Error(_loc3_.msg);
      }
      
      private function updateAccountInfo() : void
      {
         getTextFieldByName("byCoinTF").text = AccountData.instance.boyaaCoin + "";
         getTextFieldByName("coinTF").text = AccountData.instance.gameGold + "";
         getTextFieldByName("unionCoinTF").text = UnionManager.getInstance().myUnionModel.mdevote + "";
      }
      
      private function buyItemHandel(param1:UnionEvent) : void
      {
         _currentShopData = param1.eventData as ShopData;
         buyItem(_currentShopData);
      }
      
      private function buyItem(param1:ShopData) : void
      {
         buyDlg = new ShopBuyDlg(false,param1);
         buyDlg.buySignal.add(updateAccountInfo);
         Application.instance.currentGame.addChild(buyDlg);
         _frameBtns.visible = false;
      }
      
      private function onNavBtnClick(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(Button(param1.target).upState == Button(param1.target).downState)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < _buttonTextureArr.length)
         {
            Button(_buttonTextureArr[_loc2_][2]).upState = _buttonTextureArr[_loc2_][0];
            Button(_buttonTextureArr[_loc2_][2]).downState = _buttonTextureArr[_loc2_][1];
            _loc2_++;
         }
         Button(param1.target).upState = Button(param1.target).downState;
         showType(_buttons.indexOf(Button(param1.target)));
      }
      
      private function showType(param1:int) : void
      {
         _curLevel = param1;
         _itemList.selectedIndex = -1;
         _itemList.dataProvider = new ListCollection(ShopDataList.instance.getUnionGoodsByLevel(param1 + 1));
      }
      
      private function onclose(param1:Event) : void
      {
         UnionManager.getInstance().removeEventListener("unionBuyDone",buyItemHandel);
         UnionManager.getInstance().removeEventListener(UnionEvent.UNION_DATA_REFRESH,unionDataRefreshDone);
         this.stage.removeEventListener("touch",onTouch);
         this.deactive();
      }
      
      private function showAttrText(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:TextField = null;
         _loc3_ = 0;
         while(_loc3_ < 6)
         {
            _loc2_ = getTextFieldByName("txt" + _loc3_);
            _loc2_.color = 65280;
            _loc2_.text = param1[_loc3_];
            _loc3_++;
         }
      }
      
      private function initTextInfo() : void
      {
         var _loc3_:int = 0;
         var _loc2_:TextField = null;
         var _loc1_:Array = LangManager.getLang.getLangArray("detailsNameArr");
         _loc3_ = 0;
         while(_loc3_ < 6)
         {
            _loc2_ = getTextFieldByName("textInfo" + _loc3_);
            _loc2_.text = _loc1_[_loc3_] + ": ";
            _loc2_.nativeFilters = StarlingUITools.instance.getGlowFilter(3735581);
            _loc3_++;
         }
      }
   }
}

import com.boyaa.antwars.control.UnionManager;
import com.boyaa.antwars.data.ShopDataList;
import com.boyaa.antwars.data.UnionShopData;
import com.boyaa.antwars.data.model.ShopData;
import com.boyaa.antwars.view.screen.union.UnionEvent;
import com.boyaa.antwars.view.ui.ListItemRenderer;
import com.boyaa.antwars.view.ui.layout.LayoutUitl;
import flash.geom.Rectangle;
import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.filters.ColorMatrixFilter;
import starling.text.TextField;

class UnionStoreItemRender extends ListItemRenderer
{
   
   private var _layout:LayoutUitl;
   
   private var _asset:ResAssetManager;
   
   private var _priceType:Image;
   
   private var _goodsBox:Image;
   
   private var _shopData:ShopData;
   
   public function UnionStoreItemRender()
   {
      super();
   }
   
   override protected function initialize() : void
   {
      super.initialize();
      _asset = Assets.sAsset;
      this.bgFocusTexture = _asset.getTexture("UnionStoreItemBgNull");
      this.bgNormalTexture = _asset.getTexture("UnionStoreItemBgNull");
      this.bg = new Image(this.bgNormalTexture);
      this.addChild(this.bg);
      _layout = new LayoutUitl(_asset.getOther("UnionStore"),_asset);
      _layout.buildLayout("UnionStoreItemLayout",this);
      _priceType = this.getChildByName("buyTypeIcon") as Image;
      _priceType.touchable = false;
      (this.getChildByName("btnS_UnionStoreBuyBtn") as Button).addEventListener("triggered",buyBtn);
      (getChildByName("btnS_storeItemBg") as Button).addEventListener("triggered",onWearCloths);
   }
   
   private function onWearCloths(param1:Event) : void
   {
      UnionStoreDlg.wearSignal.dispatch(_shopData);
   }
   
   private function buyBtn(param1:Event) : void
   {
      UnionManager.getInstance().dispatchEvent(new UnionEvent("unionBuyDone",_shopData));
   }
   
   override protected function commitData() : void
   {
      super.commitData();
      if(!this._data)
      {
         return;
      }
      var _loc2_:UnionShopData = this._data as UnionShopData;
      _shopData = ShopDataList.instance.getSingleData(_loc2_.typeID,_loc2_.frameID);
      (this.getChildByName("titleTF") as TextField).text = _shopData.name;
      if(this._goodsBox)
      {
         this._goodsBox.removeFromParent(true);
      }
      var _loc1_:Array = null;
      if(_shopData.canBuyType(1))
      {
         _loc1_ = _shopData.getPrice(1);
         _priceType.texture = Assets.sAsset.getTexture("gameGoldIcon");
      }
      else if(_shopData.canBuyType(3))
      {
         _priceType.texture = Assets.sAsset.getTexture("boyaaCoinIcon");
         _loc1_ = _shopData.getPrice(3);
      }
      else if(_shopData.canBuyType(5))
      {
         _priceType.texture = Assets.sAsset.getTexture("unionDevoteIcon");
         _loc1_ = _shopData.getPrice(5);
      }
      if(_loc1_)
      {
         (this.getChildByName("priceTF") as TextField).text = _loc1_[0][1];
      }
      else
      {
         (this.getChildByName("priceTF") as TextField).text = "";
      }
      var _loc4_:Rectangle = new Rectangle(8,2,140,140);
      _goodsBox = Assets.sAsset.getGoodsImageByRect(_shopData.typeID,_shopData.frameID,_loc4_);
      if(this._goodsBox)
      {
         addChild(this._goodsBox);
         this._goodsBox.touchable = false;
      }
      (this.getChildByName("btnS_UnionStoreBuyBtn") as Button).touchable = false;
      (this.getChildByName("btnS_storeItemBg") as Button).touchable = false;
      var _loc3_:ColorMatrixFilter = new ColorMatrixFilter();
      if(_loc2_.placelevel > UnionManager.getInstance().myUnionModel.shoplevel)
      {
         _loc3_.adjustSaturation(-1);
      }
      else
      {
         _loc3_.adjustSaturation(0);
         (this.getChildByName("btnS_UnionStoreBuyBtn") as Button).touchable = true;
         (this.getChildByName("btnS_storeItemBg") as Button).touchable = true;
      }
      this.filter = _loc3_;
   }
   
   override public function dispose() : void
   {
   }
}
