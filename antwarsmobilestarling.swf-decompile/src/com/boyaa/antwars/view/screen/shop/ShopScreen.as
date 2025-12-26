package com.boyaa.antwars.view.screen.shop
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.antwars.view.vipSystem.VipButton;
   import feathers.controls.Button;
   import feathers.controls.List;
   import feathers.controls.PickerList;
   import feathers.controls.Screen;
   import feathers.controls.renderers.IListItemRenderer;
   import feathers.data.ListCollection;
   import feathers.layout.HorizontalLayout;
   import flash.filters.GlowFilter;
   import flash.text.TextFormat;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class ShopScreen extends Screen
   {
      
      public static var inGuide:Boolean = false;
      
      public static var buyType:int = 3;
      
      private var _asset:ResAssetManager;
      
      private var _layoutUitl:LayoutUitl;
      
      private var _buttonTextureArr:Array = null;
      
      private var _btnTextureArr:Array = null;
      
      private var _btns:Array = null;
      
      private var _buttons:Array = null;
      
      private var btnBoyaaCoinType:starling.display.Button;
      
      private var btnGoldCoinType:starling.display.Button;
      
      private var currentShopData:ShopData;
      
      private var list:List;
      
      private var vipListData:ListCollection;
      
      private var weaponListData:ListCollection;
      
      private var propListData:ListCollection;
      
      private var accessoryListData:ListCollection;
      
      private var equipListData:ListCollection;
      
      private var character:Character;
      
      private var container:Sprite;
      
      private var type:int = 0;
      
      private var type_weapon:Sprite;
      
      private var type_equip:Sprite;
      
      private var type_prop:Sprite;
      
      private var type_accessory:Sprite;
      
      private var txtType:TextField;
      
      private var _showListType:String = "0";
      
      private var currentList:int = 0;
      
      private var txtLevel:TextField;
      
      private var txtBoyaaCoin:TextField;
      
      private var txtGoldCoin:TextField;
      
      private var accountData:AccountData;
      
      private var btnCart:FashionStarlingButton;
      
      private var pickerlist:PickerList;
      
      private var groceryList:ListCollection;
      
      private var pickerArr:Array = [[{"text":"Senjata suci "},{"text":"senjata biasa "}],[{"text":"Baju"},{"text":"Topi"},{"text":"Kaus"},{"text":"Sepatu"}],[{"text":"Sayap"},{"text":"Kalung"},{"text":"Cincin"}],[{"text":"Batu kuat"},{"text":"Batu memadu  "},{"text":"Batu adisi"},{"text":"lain-lain"}],[]];
      
      private var sourceData:Array;
      
      private var currentWeapon:Image;
      
      protected var _optionsData:Object;
      
      private var btnExit:starling.display.Button;
      
      private var btnRecharge:starling.display.Button;
      
      private var shopDataWears:Array;
      
      public function ShopScreen()
      {
         super();
         Application.instance.currentGame.showLoading();
         _asset = Assets.sAsset;
         loadAsset();
      }
      
      public function get optionsData() : Object
      {
         return _optionsData;
      }
      
      public function set optionsData(param1:Object) : void
      {
         _optionsData = param1;
         invalidate("data");
      }
      
      private function loadAsset() : void
      {
         var _loc1_:ResManager = Application.instance.resManager;
         _asset.enqueue(_loc1_.getResFile(formatString("asset/shop.info")),_loc1_.getResFile(formatString("textures/{0}x/shop/shop.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/shop/shop.xml",Assets.sAsset.scaleFactor)));
         _asset.loadQueue(loading);
      }
      
      private function loading(param1:Number) : void
      {
         if(param1 == 1)
         {
            Application.instance.currentGame.hiddenLoading();
            _layoutUitl = new LayoutUitl(_asset.getOther("shop"),_asset);
            _layoutUitl.buildLayout("ShopScreen",this);
            this.x = 170.5;
            initScene();
         }
      }
      
      private function showGuide() : void
      {
         var _loc1_:int = 0;
         if(_optionsData.pos == "shop")
         {
            Guide.instance.guide(this.getChildByName("tab3"),LangManager.t("guide10"),true);
            inGuide = true;
            btnExit.enabled = false;
            btnRecharge.enabled = false;
            btnBoyaaCoinType.enabled = false;
            btnGoldCoinType.enabled = false;
            list.touchable = false;
            pickerlist.touchable = false;
            _loc1_ = 0;
            while(_loc1_ < 5)
            {
               if(_loc1_ != 3)
               {
                  this.getChildByName("tab" + _loc1_).touchable = false;
               }
               _loc1_++;
            }
         }
      }
      
      private function initScene() : void
      {
         initListData();
         initButton();
         initRole();
         initAccount();
         initList();
         ShopManager.instance.buySignal.add(updateAccountInfo);
         ShopManager.instance.signal.add(updateCart);
         showGuide();
      }
      
      private function initPickerList() : void
      {
         var target:DisplayObject;
         pickerlist = new PickerList();
         addChild(pickerlist);
         target = getChildByName("btnS_pickerButton");
         target.visible = false;
         pickerlist.x = target.x;
         pickerlist.y = target.y;
         groceryList = new ListCollection();
         groceryList.data = pickerArr[type];
         pickerlist.dataProvider = groceryList;
         pickerlist.addEventListener("change",onPickerListEvent);
         pickerlist.customButtonName = "my-custom-button";
         pickerlist.listProperties.@itemRendererProperties.labelField = "text";
         pickerlist.labelField = "text";
         pickerlist.prompt = "Semua";
         pickerlist.selectedIndex = -1;
         pickerlist.buttonFactory = function():feathers.controls.Button
         {
            var _loc1_:feathers.controls.Button = new feathers.controls.Button();
            _loc1_.defaultSkin = new Image(_asset.getTexture("btnS_pickerButton1"));
            _loc1_.downSkin = new Image(_asset.getTexture("btnS_pickerButton2"));
            var _loc2_:TextFormat = new TextFormat("Verdana",20,16777164);
            _loc2_.align = "left";
            _loc1_.defaultLabelProperties.textFormat = _loc2_;
            return _loc1_;
         };
         pickerlist.listProperties.itemRendererFactory = function():IListItemRenderer
         {
            return new PickerListItemRender();
         };
      }
      
      private function onPickerListEvent(param1:Event) : void
      {
         var _loc3_:PickerList = PickerList(param1.currentTarget);
         if(_loc3_.selectedIndex == -1)
         {
            return;
         }
         var _loc2_:int = _loc3_.selectedIndex;
         updateListByCoin(_showListType);
      }
      
      private function updateCart(param1:int) : void
      {
         btnCart.isGray = param1 == 0;
      }
      
      private function initAccount() : void
      {
         accountData = AccountData.instance;
         txtBoyaaCoin = this.getChildByName("txt_bycoins") as TextField;
         txtGoldCoin = this.getChildByName("txt_coins") as TextField;
         txtBoyaaCoin.text = accountData.boyaaCoin.toString();
         txtGoldCoin.text = accountData.gameGold.toString();
      }
      
      private function initRole() : void
      {
         var _loc1_:VipButton = null;
         character = CharacterFactory.instance.checkOutCharacter(PlayerDataList.instance.selfData.babySex);
         character.scaleY = 0.6;
         character.scaleX = character.scaleY;
         character.initData(PlayerDataList.instance.selfData.getPropData());
         var _loc2_:DisplayObject = this.getChildByName("role_rect");
         character.x = _loc2_.x + (_loc2_.width >> 1);
         character.y = _loc2_.y + _loc2_.height;
         addChild(character);
         txtLevel = this.getChildByName("txt_level") as TextField;
         txtLevel.text = "LV" + PlayerDataList.instance.selfData.level;
         txtLevel.nativeFilters = [new GlowFilter(4660230,1,6,6,10)];
         if(PlayerDataList.instance.selfData.vipLevel > 0)
         {
            _loc1_ = new VipButton();
            _loc1_.setLevel(PlayerDataList.instance.selfData.vipLevel);
            addChild(_loc1_);
            _loc1_.x = txtLevel.x - 150;
            _loc1_.y = txtLevel.y + 5;
            _loc1_.scaleX = _loc1_.scaleY = 0.3;
         }
      }
      
      private function initButton() : void
      {
         var _loc3_:int = 0;
         var _loc2_:String = null;
         var _loc1_:starling.display.Button = null;
         txtType = getChildByName("txt_type") as TextField;
         btnExit = this.getChildByName("btnS_close") as starling.display.Button;
         btnExit.addEventListener("triggered",onExit);
         btnRecharge = this.getChildByName("btnS_recharge") as starling.display.Button;
         btnRecharge.addEventListener("triggered",onRecharge);
         btnCart = new FashionStarlingButton(getChildByName("btnS_shopcart") as starling.display.Button);
         btnCart.triggerFunction = onCart;
         btnBoyaaCoinType = this.getChildByName("coin_type0") as starling.display.Button;
         btnGoldCoinType = this.getChildByName("coin_type1") as starling.display.Button;
         btnBoyaaCoinType.addEventListener("triggered",onRadio);
         btnGoldCoinType.addEventListener("triggered",onRadio);
         _buttonTextureArr = [];
         _btnTextureArr = [];
         _btns = [];
         _buttons = [];
         _loc3_ = 0;
         while(_loc3_ < 5)
         {
            _loc2_ = "tab" + _loc3_;
            _loc1_ = this.getChildByName(_loc2_) as starling.display.Button;
            _loc1_.addEventListener("triggered",onNavBtnClick);
            _buttonTextureArr.push([_loc1_.upState,_loc1_.downState,_loc1_]);
            _buttons.push(_loc1_);
            _loc3_++;
         }
         (_buttons[0] as starling.display.Button).upState = (_buttons[0] as starling.display.Button).downState;
         _btnTextureArr.push([btnBoyaaCoinType.upState,btnBoyaaCoinType.downState,btnBoyaaCoinType]);
         _btnTextureArr.push([btnGoldCoinType.upState,btnGoldCoinType.downState,btnGoldCoinType]);
         _btns.push(btnBoyaaCoinType);
         _btns.push(btnGoldCoinType);
         (_btns[0] as starling.display.Button).upState = (_btns[0] as starling.display.Button).downState;
         if(ShopManager.instance.shopCartArr.length == 0)
         {
            btnCart.isGray = true;
         }
      }
      
      private function onCart(param1:Event) : void
      {
         showCart();
      }
      
      private function initListData() : void
      {
         var _loc3_:int = 0;
         shopDataWears = [];
         vipListData = new ListCollection(ShopDataList.instance.getShopDataMobile(1,PlayerDataList.instance.selfData.babySex));
         weaponListData = new ListCollection(ShopDataList.instance.getShopDataMobile(2,PlayerDataList.instance.selfData.babySex));
         accessoryListData = new ListCollection(ShopDataList.instance.getShopDataMobile(4,PlayerDataList.instance.selfData.babySex));
         equipListData = new ListCollection(ShopDataList.instance.getShopDataMobile(5,PlayerDataList.instance.selfData.babySex));
         var _loc2_:Array = ShopDataList.instance.getShopDataMobile(3,PlayerDataList.instance.selfData.babySex);
         var _loc1_:int = int(_loc2_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            if((_loc2_[_loc3_] as ShopData).typeID == 15 && (_loc2_[_loc3_] as ShopData).frameID == 1013)
            {
               _loc2_.unshift(_loc2_[_loc3_]);
               _loc2_.splice(_loc3_ + 1,1);
               break;
            }
            _loc3_++;
         }
         propListData = new ListCollection(_loc2_);
      }
      
      private function initList() : void
      {
         list = new List();
         list.itemRendererType = ShopItemRenderer;
         list.addEventListener("change",listChangeHandler);
         list.verticalScrollPolicy = "off";
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.gap = 5;
         _loc1_.paddingTop = 5;
         list.layout = _loc1_;
         SmallCodeTools.instance.setDisplayObjectInSame(this.getChildByName("list_rect"),list);
         addChild(list);
         initPickerList();
         updateList(0);
      }
      
      private function resetButtonStatus() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = int(_buttonTextureArr.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            starling.display.Button(_buttonTextureArr[_loc2_][2]).upState = _buttonTextureArr[_loc2_][0];
            starling.display.Button(_buttonTextureArr[_loc2_][2]).downState = _buttonTextureArr[_loc2_][1];
            _loc2_++;
         }
      }
      
      private function resetBtnStatus() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = int(_btns.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            starling.display.Button(_btnTextureArr[_loc2_][2]).upState = _btnTextureArr[_loc2_][0];
            starling.display.Button(_btnTextureArr[_loc2_][2]).downState = _btnTextureArr[_loc2_][1];
            _loc2_++;
         }
      }
      
      private function takeOffClothes(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = int(param1.length);
         if(_loc2_ > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               character.wearById(param1[_loc3_].typeID,0);
               _loc3_++;
            }
         }
      }
      
      private function onRadio(param1:Event) : void
      {
         if(inGuide)
         {
            return;
         }
         var _loc2_:starling.display.Button = param1.target as starling.display.Button;
         if(_loc2_.upState == _loc2_.downState)
         {
            return;
         }
         resetBtnStatus();
         _loc2_.upState = _loc2_.downState;
         _showListType = _loc2_.name.charAt(9);
         buyType = _showListType == "0" ? 3 : 1;
         updateListByCoin(_showListType);
      }
      
      private function listChangeHandler(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         if(inGuide)
         {
            if(_loc2_.selectedIndex != 0)
            {
               return;
            }
         }
         onSelectedItem(_loc2_.selectedItem);
         _loc2_.selectedIndex = -1;
      }
      
      private function onNavBtnClick(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ShopData = null;
         if(starling.display.Button(param1.target).upState == starling.display.Button(param1.target).downState)
         {
            return;
         }
         resetButtonStatus();
         starling.display.Button(param1.target).upState = starling.display.Button(param1.target).downState;
         resetBtnStatus();
         (_btns[0] as starling.display.Button).upState = (_btns[0] as starling.display.Button).downState;
         type = int(starling.display.Button(param1.target).name.charAt(3));
         _showListType = "0";
         buyType = 3;
         updateList(type);
         groceryList.data = pickerArr[type];
         pickerlist.dataProvider = groceryList;
         if(shopDataWears.length > 0)
         {
            _loc2_ = shopDataWears.length == 1 ? 0 : 1;
            _loc3_ = shopDataWears[_loc2_] as ShopData;
            character.wearById(_loc3_.typeID,0);
            shopDataWears.length = 0;
            character.initData(PlayerDataList.instance.selfData.getPropData());
         }
      }
      
      private function onRecharge(param1:Event) : void
      {
         Application.instance.currentGame.mainMenu.onRechargeBtn();
      }
      
      private function updateList(param1:int) : void
      {
         var _loc3_:Array = null;
         var _loc2_:int = 0;
         switch(param1)
         {
            case 0:
               _loc3_ = ShopDataList.instance.getShopDataMobile(2,PlayerDataList.instance.selfData.babySex);
               sourceData = getDataByCoinType(_loc3_,"0");
               weaponListData.data = sourceData;
               list.dataProvider = weaponListData;
               break;
            case 1:
               _loc3_ = ShopDataList.instance.getShopDataMobile(5,PlayerDataList.instance.selfData.babySex);
               sourceData = getDataByCoinType(_loc3_,"0");
               equipListData.data = sourceData;
               list.dataProvider = equipListData;
               break;
            case 2:
               _loc3_ = ShopDataList.instance.getShopDataMobile(4,PlayerDataList.instance.selfData.babySex);
               sourceData = getDataByCoinType(_loc3_,"0");
               accessoryListData.data = sourceData;
               list.dataProvider = accessoryListData;
               break;
            case 3:
               _loc3_ = ShopDataList.instance.getShopDataMobile(3,PlayerDataList.instance.selfData.babySex);
               sourceData = getDataByCoinType(_loc3_,"0");
               propListData.data = sourceData;
               _loc2_ = 0;
               while(_loc2_ < sourceData.length)
               {
                  if((sourceData[_loc2_] as ShopData).typeID == 15 && (sourceData[_loc2_] as ShopData).frameID == 1013)
                  {
                     sourceData.unshift(sourceData[_loc2_]);
                     sourceData.splice(_loc2_ + 1,1);
                     break;
                  }
                  _loc2_++;
               }
               if(inGuide)
               {
                  Guide.instance.show(215,660,LangManager.t("guide11"),146,70);
                  list.touchable = true;
                  list.horizontalScrollPolicy = "no";
                  list.verticalScrollPolicy = "no";
               }
               list.dataProvider = propListData;
               break;
            case 4:
               _loc3_ = ShopDataList.instance.vipData;
               sourceData = getDataByCoinType(_loc3_,"0");
               vipListData.data = sourceData;
               list.dataProvider = vipListData;
         }
      }
      
      private function updateListByCoin(param1:String) : void
      {
         var _loc7_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Array = [];
         var _loc3_:int = pickerlist.selectedIndex;
         var _loc2_:int = PlayerDataList.instance.selfData.babySex;
         switch(type)
         {
            case 0:
               sourceData = getDataByCoinType(ShopDataList.instance.getShopDataMobile(2,_loc2_),param1);
               if(_loc3_ == -1)
               {
                  _loc7_ = sourceData;
                  break;
               }
               _loc7_ = ShopDataList.instance.getMagicWeapon(sourceData,_loc3_ == 0);
               break;
            case 1:
               _loc4_ = [2,3,6,4];
               if(_loc3_ == -1)
               {
                  _loc6_ = ShopDataList.instance.getShopDataMobile(5,PlayerDataList.instance.selfData.babySex);
                  _loc7_ = getDataByCoinType(_loc6_,param1);
                  break;
               }
               _loc7_ = getDataByCoinType(ShopDataList.instance.getShopData(_loc4_[_loc3_],_loc2_),param1);
               break;
            case 2:
               _loc4_ = [7,16,5];
               if(_loc3_ == -1)
               {
                  _loc6_ = ShopDataList.instance.getShopDataMobile(4,PlayerDataList.instance.selfData.babySex);
                  _loc7_ = getDataByCoinType(_loc6_,param1);
                  break;
               }
               _loc7_ = getDataByCoinType(ShopDataList.instance.getShopData(_loc4_[_loc3_],_loc2_),param1);
               break;
            case 3:
               if(_loc3_ != -1)
               {
                  if(_loc3_ == 0)
                  {
                     sourceData = ShopDataList.instance.getStoneProp(15);
                  }
                  else if(_loc3_ == 1)
                  {
                     sourceData = ShopDataList.instance.getSyntheticStone();
                  }
                  else if(_loc3_ == 2)
                  {
                     sourceData = ShopDataList.instance.getStoneProp(20);
                  }
                  else
                  {
                     sourceData = ShopDataList.instance.getOtherProps();
                  }
                  _loc7_ = getDataByCoinType(sourceData,_showListType);
                  break;
               }
               _loc6_ = ShopDataList.instance.getShopDataMobile(3,PlayerDataList.instance.selfData.babySex);
               _loc7_ = getDataByCoinType(_loc6_,param1);
               _loc5_ = 0;
               while(_loc5_ < _loc7_.length)
               {
                  if((_loc7_[_loc5_] as ShopData).typeID == 15 && (_loc7_[_loc5_] as ShopData).frameID == 1013)
                  {
                     _loc7_.unshift(_loc7_[_loc5_]);
                     _loc7_.splice(_loc5_ + 1,1);
                     break;
                  }
                  _loc5_++;
               }
               break;
            case 4:
               _loc7_ = getDataByCoinType(sourceData,_showListType);
         }
         list.dataProvider = new ListCollection(_loc7_);
         list.alpha = 0;
         Starling.juggler.tween(list,0.6,{
            "alpha":1,
            "transition":"easeOutBack"
         });
      }
      
      private function updateAccountInfo() : void
      {
         txtBoyaaCoin.text = accountData.boyaaCoin.toString();
         txtGoldCoin.text = accountData.gameGold.toString();
         if(inGuide)
         {
            Guide.instance.guide(btnExit,"",true);
            btnExit.enabled = true;
            _optionsData.pos = "mission";
         }
      }
      
      private function onExit(param1:Event) : void
      {
         if(ShopManager.instance.shopCartArr.length > 0)
         {
            SystemTip.instance.showSystemAlert(LangManager.t("shop_cart"),showCart,exit);
            return;
         }
         exit();
      }
      
      private function onSelectedItem(param1:*) : void
      {
         var _loc3_:int = 0;
         var _loc2_:ShopData = param1 as ShopData;
         currentShopData = _loc2_;
         if(_loc2_.isEquipment)
         {
            if(!_loc2_.isWeapon)
            {
               character.wearById(_loc2_.typeID,_loc2_.frameID);
               shopDataWears.push(currentShopData);
            }
            _loc3_ = int(shopDataWears.length);
            if(_loc3_ == 2)
            {
               if(currentShopData.typeID == shopDataWears[0].typeID && currentShopData.frameID == shopDataWears[0].frameID)
               {
                  character.wearById(_loc2_.typeID,0);
                  shopDataWears.length = 0;
                  wearSelfProp(currentShopData.typeID);
               }
               else
               {
                  shopDataWears.splice(0,1);
               }
            }
         }
      }
      
      private function getDataByCoinType(param1:Array, param2:String) : Array
      {
         var _loc7_:int = 0;
         var _loc4_:ShopData = null;
         var _loc5_:int = param2 == "1" ? 1 : 3;
         var _loc3_:Array = [];
         var _loc6_:int = int(param1.length);
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc4_ = param1[_loc7_] as ShopData;
            if(_loc4_.canBuyType(_loc5_))
            {
               _loc3_.push(_loc4_);
            }
            _loc7_++;
         }
         return _loc3_;
      }
      
      private function exit() : void
      {
         buyType = 3;
         if(inGuide)
         {
            inGuide = false;
            Guide.instance.stop();
            _optionsData.pos = "mission";
         }
         if(Game.fromSkycityToShop)
         {
            this.dispatchEventWith("showSkyCity");
            Game.fromSkycityToShop = false;
         }
         else
         {
            this.dispatchEvent(new Event("complete"));
         }
         ShopManager.instance.signal.remove(updateCart);
         ShopManager.instance.clearShoppingCart();
      }
      
      private function showCart() : void
      {
         var _loc1_:ShoppingCartDlg = new ShoppingCartDlg();
         Application.instance.currentGame.stage.addChild(_loc1_);
      }
      
      private function wearSelfProp(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = PlayerDataList.instance.selfData.getPropData();
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(param1 == (_loc2_[_loc3_] as GoodsData).typeID)
            {
               character.wearById((_loc2_[_loc3_] as GoodsData).typeID,(_loc2_[_loc3_] as GoodsData).frameID);
               break;
            }
            _loc3_++;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

