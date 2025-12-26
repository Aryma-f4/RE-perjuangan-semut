package com.boyaa.antwars.view.screen.union.warehouse
{
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.HelpDlg;
   import com.boyaa.antwars.view.BaseDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.shop.ShopItemDetailTip;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.tool.Trim;
   import feathers.controls.List;
   import feathers.controls.TextInput;
   import feathers.data.ListCollection;
   import feathers.display.Scale9Image;
   import feathers.layout.TiledRowsLayout;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class IwantRentDlg extends BaseDlg
   {
      
      private var _layout:LayoutUitl;
      
      private var list:List;
      
      private var listData:ListCollection;
      
      private var currentGoodsData:GoodsData;
      
      public const INDATE:int = 604800;
      
      private var time:int = 180;
      
      private var restGridNum:uint;
      
      private var feeArr:Array = [50,100];
      
      private var _devote:int = 50;
      
      private var gridNumArr:Array = [4,6,8,10,12,14,16,18,20,30];
      
      private var _buttonTextureArr:Array;
      
      private var _buttons:Array;
      
      private var txtStorageFee:TextField;
      
      private var textInput:TextInput;
      
      private var goods_frame:DisplayObject;
      
      private var goodsImage:Image;
      
      private var btnHour3:Button;
      
      private var btnHour7:Button;
      
      public var longTip:ShopItemDetailTip;
      
      public var signal:Signal;
      
      public function IwantRentDlg()
      {
         super();
         _layout = new LayoutUitl(Assets.sAsset.getOther("warehouse"),Assets.sAsset);
         _layout.buildLayout("IwantRentLayout",_displayObj);
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
         this.addEventListener("addedToStage",onAddedToStage);
         signal = new Signal();
         init();
      }
      
      private function init() : void
      {
         initCommandButton();
         initScale9Image();
         initList();
         initGrids();
         initTabBtn();
         initInputText();
         goods_frame = getDisplayObjByName("goods_frame_bg");
         GoodsList.instance.rentalSiganl.add(updateList);
      }
      
      private function updateList(param1:int) : void
      {
         if(param1 == 2)
         {
            initGrids();
         }
      }
      
      private function initInputText() : void
      {
         textInput = createInputTextByTextField(getTextFieldByName("txt_rentprice"));
         textInput.text = LangManager.t("rent_price");
         textInput.addEventListener("focusIn",onFocusIn);
         _displayObj.addChild(textInput);
      }
      
      private function initGrids() : void
      {
         var _loc10_:int = 0;
         var _loc6_:GoodsData = null;
         var _loc5_:GoodsData = null;
         var _loc4_:int = 0;
         var _loc12_:int = 0;
         var _loc11_:GoodsData = null;
         if(goodsImage)
         {
            goodsImage.removeFromParent();
         }
         var _loc3_:Array = GoodsList.instance.storageList.concat();
         var _loc1_:Array = [];
         _loc10_ = 0;
         while(_loc10_ < _loc3_.length)
         {
            _loc6_ = _loc3_[_loc10_] as GoodsData;
            if(_loc6_.isEquipment && !_loc6_.isRentFromOther(_loc6_.onlyID) && _loc6_.isbind != 1)
            {
               _loc1_.push(_loc6_);
            }
            _loc10_++;
         }
         var _loc9_:int = 0;
         while(_loc1_.length > _loc9_)
         {
            _loc5_ = _loc1_[_loc9_] as GoodsData;
            _loc4_ = _loc5_.lefttime - new Date().time / 1000;
            if(_loc4_ < 604800 && _loc5_.lefttime != 0)
            {
               _loc1_.splice(_loc9_,1);
            }
            else
            {
               _loc9_++;
            }
         }
         restGridNum = _loc1_.length;
         var _loc2_:int = UnionManager.getInstance().myUnionModel.storelevel;
         var _loc8_:int = int(gridNumArr[_loc2_ - 1]);
         var _loc7_:int = int(_loc8_ < 12 ? 12 : _loc8_);
         _loc12_ = 0;
         while(_loc12_ < _loc7_)
         {
            _loc11_ = new GoodsData();
            if(_loc12_ < _loc8_)
            {
               _loc11_.typeID = -1;
               _loc11_.frameID = -1;
            }
            if(_loc1_[_loc12_] == null)
            {
               _loc1_[_loc12_] = _loc11_;
            }
            _loc12_++;
         }
         listData.data = _loc1_;
         list.dataProvider = listData;
      }
      
      private function initList() : void
      {
         list = new List();
         listData = new ListCollection();
         list.itemRendererType = MyWarehouseListItemRender;
         list.addEventListener("change",onListChangeHandler);
         _displayObj.addChild(list);
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.useSquareTiles = false;
         _loc1_.gap = 10;
         _loc1_.paddingTop = 10;
         list.layout = _loc1_;
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjByName("rect"),list);
         list.height -= 10;
      }
      
      private function initScale9Image() : void
      {
         var _loc3_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("talk2"),new Rectangle(26,26,37,37)));
         var _loc6_:DisplayObject = getDisplayObjByName("frame_0");
         SmallCodeTools.instance.setDisplayObjectInSame(_loc6_,_loc3_);
         var _loc2_:Quad = new Quad(_loc3_.width - 10,_loc3_.height - 10,4269333);
         _loc2_.x = _loc3_.x + 5;
         _loc2_.y = _loc3_.y + 5;
         _displayObj.addChild(_loc2_);
         _displayObj.addChild(_loc3_);
         _displayObj.setChildIndex(_loc2_,2);
         _loc2_.touchable = false;
         _loc3_.touchable = false;
         var _loc4_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("talk2"),new Rectangle(26,26,37,37)));
         var _loc1_:DisplayObject = getDisplayObjByName("frame_1");
         SmallCodeTools.instance.setDisplayObjectInSame(_loc1_,_loc4_);
         var _loc5_:Quad = new Quad(_loc4_.width - 10,_loc4_.height - 10,4269333);
         _loc5_.x = _loc4_.x + 5;
         _loc5_.y = _loc4_.y + 5;
         _displayObj.addChild(_loc5_);
         _displayObj.addChild(_loc4_);
         _displayObj.setChildIndex(_loc5_,3);
      }
      
      private function initTabBtn() : void
      {
         txtStorageFee = getTextFieldByName("txt_storageFee");
         txtStorageFee.text = String(feeArr[0]);
         _buttonTextureArr = [];
         _buttons = [];
         btnHour3 = getButtonByName("btn_hour3");
         btnHour3.addEventListener("triggered",onTabBtn);
         btnHour7 = getButtonByName("btn_hour7");
         btnHour7.addEventListener("triggered",onTabBtn);
         _buttonTextureArr.push([btnHour3.upState,btnHour3.downState,btnHour3]);
         _buttonTextureArr.push([btnHour7.upState,btnHour7.downState,btnHour7]);
         _buttons.push(btnHour3);
         _buttons.push(btnHour7);
         Button(_buttons[0]).upState = Button(_buttons[0]).downState;
         getButtonByName("btnS_ok").addEventListener("triggered",onOKbtn);
         getButtonByName("btnS_helpbtn").addEventListener("triggered",onHelpHandle);
      }
      
      override public function deActiveDone() : void
      {
         signal.dispatch();
         super.deActiveDone();
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
      }
      
      private function onListChangeHandler(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         currentGoodsData = _loc2_.selectedItem as GoodsData;
         if(goodsImage)
         {
            goodsImage.removeFromParent();
         }
         if(currentGoodsData.typeID == -1 || currentGoodsData.typeID == 0)
         {
            return;
         }
         if(currentGoodsData.rentStatus == 1)
         {
            return;
         }
         var _loc3_:Rectangle = new Rectangle(goods_frame.x,goods_frame.y,140,140);
         goodsImage = Assets.sAsset.getGoodsImageByRect(currentGoodsData.typeID,currentGoodsData.frameID,_loc3_);
         _displayObj.addChild(goodsImage);
         checkDetail();
         _loc2_.selectedIndex = -1;
      }
      
      private function onFocusIn(param1:Event) : void
      {
         var _loc2_:TextInput = param1.target as TextInput;
         if(_loc2_.text == LangManager.t("rent_price"))
         {
            _loc2_.text = "";
            _loc2_.textEditorProperties.color = 16777215;
         }
      }
      
      private function onOKbtn(param1:Event) : void
      {
         var onlyid:int;
         var arr:Array;
         var e:Event = param1;
         if(textInput.text == LangManager.t("rent_price") || Trim.trim(textInput.text) == "")
         {
            TextTip.instance.showByLang("rent_price");
            return;
         }
         if(currentGoodsData == null || currentGoodsData.typeID == -1 || currentGoodsData.typeID == 0 || currentGoodsData.rentStatus == 1)
         {
            TextTip.instance.showByLang("select_goods");
            return;
         }
         if(UnionManager.getInstance().myUnionModel.mdevote < _devote)
         {
            TextTip.instance.showByLang("union_storage_rent_no");
            return;
         }
         onlyid = currentGoodsData.onlyID;
         arr = [onlyid,time,int(textInput.text)];
         trace("我要出租：" + currentGoodsData.onlyID,time,int(textInput.text));
         GameServer.instance.toRentalStorageResult(arr,function(param1:Object):void
         {
            var retdata:Object = param1;
            if(retdata[0] == true)
            {
               UnionManager.getInstance().myUnionModel.mdevote = UnionManager.getInstance().myUnionModel.mdevote - _devote;
               GoodsList.instance.deleteItemFromeMyStorageList(onlyid);
               GoodsList.instance.addGoodsByStr(retdata[1] as Array);
               initGrids();
               GameServer.instance.getAllRentingGoods(function(param1:Object):void
               {
                  trace("出租物品列表：" + JSON.stringify(param1));
                  GoodsList.instance.addUnionRentalGoodsByArr(param1 as Array);
               });
               TextTip.instance.showByLang("rentout_ok");
               currentGoodsData = null;
            }
         });
      }
      
      private function onTabBtn(param1:Event) : void
      {
         if(Button(param1.target).upState == Button(param1.target).downState)
         {
            return;
         }
         resetBtnStatus();
         Button(param1.target).upState = Button(param1.target).downState;
         if(Button(param1.target).name == "btn_hour3")
         {
            txtStorageFee.text = String(feeArr[0]);
            time = 180;
            _devote = 50;
         }
         else
         {
            txtStorageFee.text = String(feeArr[1]);
            time = 420;
            _devote = 100;
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
      
      private function onHelpHandle(param1:Event) : void
      {
         HelpDlg.show(LangManager.t("iwant_rent_help"));
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
      
      private function resetBtnStatus() : void
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
      
      override public function dispose() : void
      {
         super.dispose();
         signal.removeAll();
         GoodsList.instance.rentalSiganl.remove(updateList);
      }
   }
}

