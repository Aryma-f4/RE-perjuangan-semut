package com.boyaa.antwars.view.screen.union.warehouse
{
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.HelpDlg;
   import com.boyaa.antwars.view.BaseDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.shop.ShopItemDetailTip;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.tool.Trim;
   import feathers.controls.List;
   import feathers.controls.ScrollContainer;
   import feathers.controls.TextInput;
   import feathers.data.ListCollection;
   import feathers.display.Scale9Image;
   import feathers.layout.TiledRowsLayout;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class UnionWarehouseDlg extends BaseDlg
   {
      
      private var _layout:LayoutUitl;
      
      private var textInput:TextInput;
      
      private var list:List;
      
      private var list_btns0:Sprite;
      
      private var list_btns1:Sprite;
      
      private var btnRentGoods:Button;
      
      private var btnMyGoods:Button;
      
      private var btnRent:Button;
      
      private var btnCancellRent:Button;
      
      private var typeIDArr:Array = [11,1,2,6,7,4,5,8];
      
      private var _buttonTextureArr:Array;
      
      private var _buttonTextureArr1:Array;
      
      private var _buttonTextureArr2:Array;
      
      private var _buttons:Array;
      
      private var _buttons1:Array;
      
      private var _buttons2:Array;
      
      private var _inRentGoodsPage:Boolean = true;
      
      private var _rental_price:int;
      
      private var _onlyID:int;
      
      private var _owner:int;
      
      private var listData:ListCollection;
      
      private var myRentalListData:ListCollection;
      
      private var currentGoodsData:GoodsData;
      
      public var longTip:ShopItemDetailTip;
      
      private var _buttonsScroller:ScrollContainer = new ScrollContainer();
      
      private var iwantRentDlg:IwantRentDlg;
      
      private var nameID:int = 1;
      
      public function UnionWarehouseDlg()
      {
         super();
         GameServer.instance.getAllRentingGoods(function(param1:Object):void
         {
            trace("出租物品列表：" + JSON.stringify(param1));
            GoodsList.instance.addUnionRentalGoodsByArr(param1 as Array);
            updateList(1);
         });
         _layout = new LayoutUitl(Assets.sAsset.getOther("warehouse"),Assets.sAsset);
         _layout.buildLayout("RentGoodsLayout",_displayObj);
         list_btns0 = getSpriteByName("list_btn0");
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
         this.addEventListener("addedToStage",onAddedToStage);
         GoodsList.instance.rentalSiganl.add(updateMyRentList);
         init();
      }
      
      private function init() : void
      {
         initScale9Image();
         initButtons();
         initInputText();
         getTextFieldByName("txt_contribution").text = UnionManager.getInstance().myUnionModel.mdevote.toString();
         initList();
         getTextFieldByName("txt_nothing").visible = false;
         _displayObj.setChildIndex(getTextFieldByName("txt_nothing"),_displayObj.numChildren);
         _displayObj.setChildIndex(list_btns0,_displayObj.numChildren);
      }
      
      private function initList() : void
      {
         myRentalListData = new ListCollection();
         list = new List();
         listData = new ListCollection();
         listData.data = GoodsList.instance.unionStorageList;
         list.dataProvider = listData;
         list.itemRendererType = RentGoodsListItemRender;
         list.addEventListener("change",onListChangeHandler);
         _displayObj.addChild(list);
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.useSquareTiles = false;
         _loc1_.gap = 20;
         _loc1_.paddingTop = 20;
         list.layout = _loc1_;
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjByName("frame0"),list);
         list.height -= 30;
         list.y += 10;
      }
      
      private function initScale9Image() : void
      {
         var _loc3_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("talk2"),new Rectangle(26,26,37,37)));
         var _loc6_:DisplayObject = getDisplayObjByName("frame0");
         SmallCodeTools.instance.setDisplayObjectInSame(_loc6_,_loc3_);
         var _loc2_:Quad = new Quad(_loc3_.width - 10,_loc3_.height - 10,4269333);
         _loc2_.x = _loc3_.x + 5;
         _loc2_.y = _loc3_.y + 5;
         _displayObj.addChild(_loc3_);
         var _loc4_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("talk2"),new Rectangle(26,26,37,37)));
         var _loc1_:DisplayObject = getDisplayObjByName("frame1");
         SmallCodeTools.instance.setDisplayObjectInSame(_loc1_,_loc4_);
         var _loc5_:Quad = new Quad(_loc4_.width - 10,_loc4_.height - 10,4269333);
         _loc5_.x = _loc4_.x + 5;
         _loc5_.y = _loc4_.y + 5;
         _displayObj.addChild(_loc5_);
         _displayObj.addChild(_loc4_);
         list_btns0.visible = false;
      }
      
      private function initInputText() : void
      {
         textInput = createInputTextByTextField(getTextFieldByName("txt_search"));
         textInput.text = LangManager.t("search");
         textInput.addEventListener("focusIn",onFocusIn);
         _displayObj.addChild(textInput);
      }
      
      private function initButtons() : void
      {
         list_btns1 = new Sprite();
         _layout.buildLayout("list_btns_layout1",list_btns1);
         _buttonsScroller.addChild(list_btns1);
         _displayObj.addChild(_buttonsScroller);
         SmallCodeTools.instance.setDisplayObjectInSame(_displayObj.getChildByName("area"),_buttonsScroller);
         _buttonsScroller.x -= 10;
         _buttonsScroller.width += 10;
         _buttonsScroller.horizontalScrollPolicy = "off";
         btnRentGoods = getButtonByName("item0");
         btnMyGoods = getButtonByName("item1");
         _buttons = [];
         _buttons1 = [];
         _buttons2 = [];
         _buttonTextureArr = [];
         _buttonTextureArr1 = [];
         _buttonTextureArr2 = [];
         _buttonTextureArr.push([btnRentGoods.upState,btnRentGoods.downState,btnRentGoods]);
         _buttonTextureArr.push([btnMyGoods.upState,btnMyGoods.downState,btnMyGoods]);
         _buttons.push(btnRentGoods);
         _buttons.push(btnMyGoods);
         addEvent();
         (_buttons1[0] as Button).upState = (_buttons1[0] as Button).downState;
         (_buttons[0] as Button).upState = (_buttons[0] as Button).downState;
      }
      
      private function addEvent() : void
      {
         var _loc5_:int = 0;
         var _loc1_:String = null;
         var _loc2_:Button = null;
         var _loc4_:int = 0;
         var _loc3_:Button = null;
         getButtonByName("btnS_search").addEventListener("triggered",onSearch);
         getButtonByName("btnS_back").addEventListener("triggered",deactive);
         btnRentGoods.addEventListener("triggered",onTabBtnClick);
         btnMyGoods.addEventListener("triggered",onTabBtnClick);
         getButtonByName("btnS_helpbtn").addEventListener("triggered",onHelpHandle);
         _loc5_ = 1;
         while(_loc5_ < 9)
         {
            _loc1_ = "btn" + _loc5_;
            _loc2_ = getButtonByName(_loc1_,list_btns1);
            _loc2_.addEventListener("triggered",onNavBtnClick);
            _buttonTextureArr1.push([_loc2_.upState,_loc2_.downState,_loc2_]);
            _buttons1.push(_loc2_);
            _loc5_++;
         }
         _loc4_ = 1;
         while(_loc4_ < 3)
         {
            _loc3_ = getButtonByName("btn" + _loc4_,list_btns0);
            _loc3_.addEventListener("triggered",onNavBtn);
            _buttonTextureArr2.push([_loc3_.upState,_loc3_.downState,_loc3_]);
            _buttons2.push(_loc3_);
            _loc4_++;
         }
      }
      
      private function checkDetail() : void
      {
         longTip.setData(currentGoodsData);
         longTip.showButtonById(5);
         longTip.y = 460;
         longTip.x = 1365 >> 1;
         longTip.pivotX = 151;
         longTip.pivotY = 305;
         longTip.scaleX = longTip.scaleY = 0;
         longTip.visible = true;
         Starling.juggler.tween(longTip,0.5,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeOut"
         });
      }
      
      private function switchPage(param1:Boolean) : void
      {
         list_btns0.visible = param1;
         list_btns1.visible = !param1;
         textInput.visible = !param1;
         getDisplayObjByName("textBg1").visible = !param1;
         getButtonByName("btnS_search").visible = !param1;
      }
      
      private function createInputTextByTextField(param1:TextField) : TextInput
      {
         var _loc2_:TextInput = new TextInput();
         _loc2_.textEditorProperties.fontFamily = param1.fontName;
         _loc2_.textEditorProperties.color = param1.color;
         _loc2_.textEditorProperties.fontSize = param1.fontSize;
         _loc2_.width = param1.width + 20;
         _loc2_.height = param1.height + 20;
         _loc2_.x = param1.x - 10;
         _loc2_.y = param1.y - 10;
         param1.visible = false;
         return _loc2_;
      }
      
      private function updateList(param1:int) : void
      {
         if(GoodsList.instance.getGoodsByTypeIDFromUnionStorage(typeIDArr[param1 - 1]).length == 0)
         {
            list.dataProvider = null;
         }
         else
         {
            list.dataProvider = new ListCollection(GoodsList.instance.getGoodsByTypeIDFromUnionStorage(typeIDArr[param1 - 1]));
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         if(longTip == null)
         {
            longTip = ShopItemDetailTip.getInstance();
            longTip.visible = false;
         }
         stage.addChild(longTip);
         btnRent = getButtonByName("btn_rent");
         btnCancellRent = getButtonByName("btn_cancell_rent");
         btnRent.addEventListener("triggered",onRent);
         btnCancellRent.addEventListener("triggered",onCancellRent);
         btnRent.visible = false;
         btnCancellRent.visible = false;
      }
      
      private function onHelpHandle(param1:Event) : void
      {
         HelpDlg.show(LangManager.t("rent_goods_help"));
      }
      
      private function vipButtonTriggerHandle(param1:Event) : void
      {
         trace("vipButton trigger");
         var _loc2_:String = Button(param1.currentTarget).name.substr(3);
      }
      
      private function onListChangeHandler(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         currentGoodsData = _loc2_.selectedItem as GoodsData;
         if(currentGoodsData == null)
         {
            return;
         }
         _onlyID = currentGoodsData.onlyID;
         if(_inRentGoodsPage)
         {
            _rental_price = currentGoodsData.rental_price;
            _owner = currentGoodsData.owner;
            if(_owner != PlayerDataList.instance.selfData.uid)
            {
               longTip.addChild(btnRent);
               btnRent.visible = true;
               btnCancellRent.visible = false;
               Assets.positionDisplay(btnRent,"checkDetail","bntBuy");
            }
            else
            {
               btnRent.visible = false;
               btnCancellRent.visible = false;
            }
         }
         else
         {
            if(currentGoodsData.stutas != 20)
            {
               longTip.addChild(btnCancellRent);
               Assets.positionDisplay(btnCancellRent,"checkDetail","bntBuy");
               btnCancellRent.visible = true;
            }
            btnRent.visible = false;
         }
         checkDetail();
         _loc2_.selectedIndex = -1;
      }
      
      private function onFocusIn(param1:Event) : void
      {
         var _loc2_:TextInput = param1.target as TextInput;
         if(_loc2_.text == LangManager.t("search"))
         {
            _loc2_.text = "";
            _loc2_.textEditorProperties.color = 16777215;
         }
      }
      
      private function onNavBtn(param1:Event) : void
      {
         if(Button(param1.target).upState == Button(param1.target).downState)
         {
            return;
         }
         if(Button(param1.target).name == "btn2")
         {
            iwantRentDlg = new IwantRentDlg();
            iwantRentDlg.signal.add(updateMyRentList);
            this.addChild(iwantRentDlg);
         }
      }
      
      private function onNavBtnClick(param1:Event) : void
      {
         if(Button(param1.target).upState == Button(param1.target).downState)
         {
            return;
         }
         resetButtonStatus();
         Button(param1.target).upState = Button(param1.target).downState;
         nameID = int(Button(param1.target).name.charAt(3));
         updateList(nameID);
      }
      
      private function onTabBtnClick(param1:Event) : void
      {
         if(Button(param1.target).upState == Button(param1.target).downState)
         {
            return;
         }
         resetTabBtn();
         Button(param1.target).upState = Button(param1.target).downState;
         if(Button(param1.target).name == "item1")
         {
            _inRentGoodsPage = false;
            switchPage(true);
            resetNavBtn();
            (_buttons2[0] as Button).upState = (_buttons2[0] as Button).downState;
            getTextFieldByName("txt_nothing").visible = GoodsList.instance.myRentalList.length == 0;
            updateMyRentList();
         }
         else
         {
            _inRentGoodsPage = true;
            resetButtonStatus();
            switchPage(false);
            (_buttons1[0] as Button).upState = (_buttons1[0] as Button).downState;
            getTextFieldByName("txt_nothing").visible = false;
            updateList(1);
         }
      }
      
      private function onSearch(param1:Event) : void
      {
         var _loc2_:String = Trim.trim(textInput.text);
         if(_loc2_ == "")
         {
            TextTip.instance.showByLang("search");
            return;
         }
         listData.data = GoodsList.instance.search(_loc2_);
         list.dataProvider = listData;
      }
      
      private function onRent(param1:Event) : void
      {
         btnRent.removeFromParent();
         SystemTip.instance.showSystemAlert(LangManager.getLang.getreplaceLang("union_storage_rent_tip",_rental_price),rent,null);
      }
      
      private function onCancellRent(param1:Event) : void
      {
         var e:Event = param1;
         GameServer.instance.toMyStorFromeUnionStorResult([_onlyID],function(param1:Object):void
         {
            var _loc2_:Array = param1 as Array;
            if(_loc2_[0] == true)
            {
               GoodsList.instance.modifyRentArr(_onlyID);
               GoodsList.instance.deleteItemFromMyRentalList(_onlyID);
               GoodsList.instance.deleteItemFromeStorageList(_onlyID);
               GoodsList.instance.addGoodsByStr(_loc2_[1]);
               btnCancellRent.removeFromParent();
               listData.data = GoodsList.instance.myRentalList;
               list.dataProvider = listData;
            }
         });
      }
      
      private function rent() : void
      {
         if(UnionManager.getInstance().myUnionModel.mdevote < currentGoodsData.rental_price)
         {
            TextTip.instance.showByLang("union_storage_rent_no");
            return;
         }
         GameServer.instance.getRentGoodsResult([_onlyID,_owner],function(param1:Object):void
         {
            if((param1 as Array).length > 0)
            {
               GoodsList.instance.deleteItemFromeStorageList(_onlyID);
               updateList(nameID);
               UnionManager.getInstance().myUnionModel.mdevote = UnionManager.getInstance().myUnionModel.mdevote - _rental_price;
               getTextFieldByName("txt_contribution").text = UnionManager.getInstance().myUnionModel.mdevote.toString();
               TextTip.instance.showByLang("union_storage_rent_ok");
               GoodsList.instance.rentArr.push(param1[2]);
            }
            else
            {
               TextTip.instance.showByLang("union_storage_rent_fail");
            }
         });
      }
      
      private function resetButtonStatus() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = int(_buttonTextureArr1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            Button(_buttonTextureArr1[_loc2_][2]).upState = _buttonTextureArr1[_loc2_][0];
            Button(_buttonTextureArr1[_loc2_][2]).downState = _buttonTextureArr1[_loc2_][1];
            _loc2_++;
         }
      }
      
      private function resetTabBtn() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = int(_buttonTextureArr.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            Button(_buttonTextureArr[_loc2_][2]).upState = _buttonTextureArr[_loc2_][0];
            Button(_buttonTextureArr[_loc2_][2]).downState = _buttonTextureArr[_loc2_][1];
            _loc2_++;
         }
      }
      
      private function resetNavBtn() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = int(_buttonTextureArr2.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            Button(_buttonTextureArr2[_loc2_][2]).upState = _buttonTextureArr2[_loc2_][0];
            Button(_buttonTextureArr2[_loc2_][2]).downState = _buttonTextureArr2[_loc2_][1];
            _loc2_++;
         }
      }
      
      public function updateMyRentList(param1:int = 0) : void
      {
         if(param1 == 0)
         {
            myRentalListData.data = GoodsList.instance.myRentalList;
            if(GoodsList.instance.myRentalList.length == 0)
            {
               list.dataProvider = null;
            }
            else
            {
               list.dataProvider = myRentalListData;
            }
            list.validate();
            getTextFieldByName("txt_nothing").visible = GoodsList.instance.myRentalList.length <= 0;
            trace("刷新列表:" + GoodsList.instance.myRentalList.length);
            getTextFieldByName("txt_contribution").text = UnionManager.getInstance().myUnionModel.mdevote.toString();
         }
         else if(_inRentGoodsPage)
         {
            updateList(1);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         textInput.removeEventListener("focusIn",onFocusIn);
         btnRent.removeFromParent();
         btnCancellRent.removeFromParent();
         GoodsList.instance.rentalSiganl.remove(updateMyRentList);
      }
   }
}

