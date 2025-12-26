package com.boyaa.antwars.view.payment
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.helper.ModelOpenContrl;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.BaseDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.tool.payment.PaymentManager;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.layout.TiledColumnsLayout;
   import flash.utils.Dictionary;
   import starling.display.Button;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class PaymentInfoIdDlg extends BaseDlg
   {
      
      private static var _hasLoadData:Boolean = false;
      
      private static var _loadData:Object;
      
      public static var currentChance:String = "";
      
      private static var _productInfoArr:Array = [];
      
      private var _layout:LayoutUitl;
      
      private var _list:List;
      
      private var _buttons:Array = [];
      
      private var _googleBtn:Button;
      
      private var _telkBtn:Button;
      
      private var _indosatBtn:Button;
      
      private var _xlBtn:Button;
      
      private var _btnNames:Array = ["googleBtn","telkBtn","indosatBtn","esiaBtn","zingMobileBtn"];
      
      private var _btnNameDic:Dictionary = new Dictionary();
      
      private var _txtBoyaa:TextField;
      
      private var pcoinsArr:Array = [];
      
      public function PaymentInfoIdDlg(param1:Boolean = true)
      {
         super(param1);
         Guide.instance.stop();
         initDic();
         loadAsset();
         PaymentManager.instance.updateCoinSignal.add(updateCoin);
      }
      
      private function initDic() : void
      {
         _btnNameDic[_btnNames[0]] = "12";
         _btnNameDic[_btnNames[1]] = "205";
         _btnNameDic[_btnNames[2]] = "269";
         _btnNameDic[_btnNames[3]] = "269";
         _btnNameDic[_btnNames[4]] = "147";
      }
      
      private function loadAsset() : void
      {
         Assets.sAsset.enqueue(Application.instance.resManager.getResFile(formatString("textures/{0}x/OTHER/paymentDlg.png",Assets.sAsset.scaleFactor)),Application.instance.resManager.getResFile(formatString("textures/{0}x/OTHER/paymentDlg.xml",Assets.sAsset.scaleFactor)));
         Application.instance.currentGame.showLoading();
         if(!_hasLoadData)
         {
            PaymentManager.instance.getPaymentInfo("",getData);
         }
         else
         {
            Assets.sAsset.loadQueue(loading);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Assets.sAsset.removeTextureAtlas("paymentDlg");
         PaymentManager.instance.updateCoinSignal.remove(updateCoin);
      }
      
      private function loading(param1:Number) : void
      {
         if(param1 >= 1)
         {
            Application.instance.currentGame.hiddenLoading();
            _layout = new LayoutUitl(Assets.sAsset.getOther("paymentDlg"),Assets.sAsset);
            _layout.buildLayout("paymentLayout",_displayObj);
            SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
            _isLoadComplete = true;
            init();
         }
      }
      
      private function getData(param1:Object) : void
      {
         var _loc7_:int = 0;
         var _loc4_:Array = null;
         var _loc2_:Array = null;
         var _loc6_:int = 0;
         var _loc5_:ProductInfo = null;
         Application.instance.log("PaymentInfo",JSON.stringify(param1));
         _hasLoadData = true;
         _loadData = param1;
         var _loc3_:Array = ["12","205","269","147"];
         _loc7_ = 0;
         while(_loc7_ < _loc3_.length)
         {
            _loc4_ = param1.productInfo[_loc3_[_loc7_]];
            if(_loc4_ == null)
            {
               TextTip.instance.show("data error! please back again later!");
               Application.instance.currentGame.hiddenLoading();
               _markBg.removeFromParent(true);
               return;
            }
            _loc2_ = [_loc3_[_loc7_]];
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc5_ = new ProductInfo(_loc4_[_loc6_]);
               _loc2_.push(_loc5_);
               _loc6_++;
            }
            _productInfoArr.push(_loc2_);
            _loc7_++;
         }
         Assets.sAsset.loadQueue(loading);
      }
      
      private function init() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Button = null;
         getTextFieldByName("tipTxt").text = LangManager.t("paymentTip0") + "：";
         getButtonByName("btnS_close").addEventListener("triggered",deactive);
         _loc3_ = 0;
         while(_loc3_ < _btnNames.length)
         {
            _loc1_ = getButtonByName(_btnNames[_loc3_]);
            _loc1_.addEventListener("triggered",onPaymentBtnHandle);
            _buttons.push([_loc1_,_loc1_.upState,_loc1_.downState]);
            if(_loc3_ == 0)
            {
               _loc1_.upState = _loc1_.downState;
            }
            else
            {
               _loc1_.visible = ModelOpenContrl.instance.checkIsOpen("open_mopay");
            }
            _loc3_++;
         }
         _txtBoyaa = getTextFieldByName("boyaaTxt");
         _txtBoyaa.nativeFilters = StarlingUITools.instance.getDropShadowFilter(0,30);
         updateCoin();
         _list = new List();
         _list.itemRendererType = PaymentItemRender;
         _list.verticalScrollPolicy = "off";
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjByName("listPos"),_list);
         _displayObj.addChild(_list);
         _list.addEventListener("change",onListSelectHandle);
         var _loc2_:TiledColumnsLayout = new TiledColumnsLayout();
         _loc2_.useSquareTiles = false;
         _loc2_.verticalGap = 0;
         _loc2_.horizontalGap = 5;
         _loc2_.paddingTop = 5;
         _loc2_.horizontalAlign = "left";
         _loc2_.verticalAlign = "top";
         _list.layout = _loc2_;
         currentChance = "12";
         _list.dataProvider = new ListCollection(getDataBymode(currentChance));
      }
      
      private function onListSelectHandle(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
      }
      
      private function resetAllButtons() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Button = null;
         _loc2_ = 0;
         while(_loc2_ < _buttons.length)
         {
            _loc1_ = _buttons[_loc2_][0];
            _loc1_.upState = _buttons[_loc2_][1];
            _loc1_.downState = _buttons[_loc2_][2];
            _loc2_++;
         }
      }
      
      private function onTelkHandle(param1:Event) : void
      {
         resetAllButtons();
         currentChance = "205";
         _list.dataProvider = new ListCollection(getDataBymode(currentChance));
         _list.validate();
         Button(param1.currentTarget).upState = Button(param1.currentTarget).downState;
      }
      
      private function onGoogleHandle(param1:Event) : void
      {
         resetAllButtons();
         currentChance = "12";
         _list.dataProvider = new ListCollection(getDataBymode(currentChance));
         _list.validate();
         Button(param1.currentTarget).upState = Button(param1.currentTarget).downState;
      }
      
      private function onPaymentBtnHandle(param1:Event) : void
      {
         resetAllButtons();
         var _loc2_:String = Button(param1.target).name;
         currentChance = _btnNameDic[_loc2_];
         if(currentChance == "")
         {
            TextTip.instance.show("this is payment no open now!");
            return;
         }
         _list.dataProvider = new ListCollection(getDataBymode(currentChance));
         _list.validate();
         Button(param1.currentTarget).upState = Button(param1.currentTarget).downState;
      }
      
      private function updateCoin() : void
      {
         _txtBoyaa.text = AccountData.instance.boyaaCoin.toString();
      }
      
      private function getDataBymode(param1:String) : Array
      {
         var _loc4_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         _loc4_ = 0;
         while(_loc4_ < _productInfoArr.length)
         {
            _loc2_ = _productInfoArr[_loc4_];
            if(_loc2_[0] == param1)
            {
               _loc3_ = _loc2_.concat();
               _loc3_.shift();
               return sort(_loc3_);
            }
            _loc4_++;
         }
         return null;
      }
      
      private function sort(param1:Array) : Array
      {
         var _loc3_:int = 0;
         param1.sortOn("pcoins",0x10 | 2);
         var _loc2_:int = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            pcoinsArr.push(param1[_loc3_].pcoins);
            _loc3_++;
         }
         return param1;
      }
   }
}

import com.boyaa.antwars.helper.StarlingUITools;
import com.boyaa.antwars.lang.LangManager;
import com.boyaa.antwars.view.screen.SystemTip;
import com.boyaa.antwars.view.ui.ListItemRenderer;
import com.boyaa.antwars.view.ui.layout.LayoutUitl;
import com.boyaa.tool.payment.PaymentManager;
import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

class ProductInfo
{
   
   private var _id:String;
   
   private var _pmode:String;
   
   private var _pamount:String;
   
   private var _discount:String;
   
   private var _appid:String;
   
   private var _pcoins:String;
   
   private var _coinName:String;
   
   public function ProductInfo(param1:Object)
   {
      super();
      _id = param1.id;
      _pmode = param1.pmode;
      _pamount = param1.pamount;
      _discount = param1.discount;
      _appid = param1.appid;
      _pcoins = param1.pcoins;
      _coinName = param1.getName;
   }
   
   public function get id() : String
   {
      return _id;
   }
   
   public function get pmode() : String
   {
      return _pmode;
   }
   
   public function get pamount() : String
   {
      return _pamount;
   }
   
   public function get discount() : String
   {
      return _discount;
   }
   
   public function get appid() : String
   {
      return _appid;
   }
   
   public function get pcoins() : String
   {
      return _pcoins;
   }
   
   public function get coinName() : String
   {
      return _coinName;
   }
}

class PaymentItemRender extends ListItemRenderer
{
   
   private var _layout:LayoutUitl;
   
   private var _boyaa:TextField;
   
   private var _amout:TextField;
   
   private var _coinImg:Image;
   
   private var _hotIcon:DisplayObject;
   
   private var _btnBuy:Button;
   
   private var _infoData:ProductInfo;
   
   private var ishot:Boolean;
   
   public function PaymentItemRender()
   {
      super();
   }
   
   override protected function initialize() : void
   {
      super.initialize();
      this.bgFocusTexture = Assets.sAsset.getTexture("img_itemBg");
      this.bgNormalTexture = Assets.sAsset.getTexture("img_itemBg");
      this.bg = new Image(Assets.sAsset.getTexture("img_itemBg"));
      this.addChild(this.bg);
      _layout = new LayoutUitl(Assets.sAsset.getOther("paymentDlg"),Assets.sAsset);
      _layout.buildLayout("paymentItem",this);
      _boyaa = this.getChildByName("boyaa") as TextField;
      _amout = this.getChildByName("money") as TextField;
      _boyaa.nativeFilters = StarlingUITools.instance.getDropShadowFilter();
      _hotIcon = getChildByName("hot_icon");
      _hotIcon.visible = false;
      _btnBuy = this.getChildByName("btn_buy") as Button;
      _btnBuy.addEventListener("triggered",onBuy);
   }
   
   private function onBuy(param1:Event) : void
   {
      var e:Event = param1;
      var getMoneyName:* = function(param1:uint):String
      {
         return param1 / 1000 + "K " + LangManager.t("moneyName");
      };
      var productInfo:ProductInfo = _infoData;
      if(PaymentInfoIdDlg.currentChance != "147")
      {
         PaymentManager.instance.makePayment(productInfo.id);
      }
      else
      {
         SystemTip.instance.showSystemAlert(productInfo.pcoins + LangManager.t("coinName") + "\n" + getMoneyName(uint(productInfo.pamount)) + "\n----------------------------\n" + LangManager.t("zingMobileconfirm"),(function():*
         {
            var yes:Function;
            return yes = function():void
            {
               PaymentManager.instance.makePayment(productInfo.id);
            };
         })(),(function():*
         {
            var no:Function;
            return no = function():void
            {
            };
         })());
      }
   }
   
   private function showIcon() : void
   {
      var _loc2_:int = 0;
      var _loc1_:int = int(_infoData.pcoins);
      if(_loc1_ >= 29 && _loc1_ <= 137)
      {
         _loc2_ = 0;
         ishot = false;
      }
      else if(_loc1_ >= 138 && _loc1_ <= 933)
      {
         _loc2_ = 1;
         ishot = false;
      }
      else if(_loc1_ > 933 && _loc1_ <= 1920)
      {
         _loc2_ = 2;
         ishot = true;
      }
      else if(_loc1_ > 1920 && _loc1_ <= 3013)
      {
         _loc2_ = 3;
         ishot = true;
      }
      else if(_loc1_ > 3013 && _loc1_ < 5260)
      {
         _loc2_ = 4;
         ishot = true;
      }
      else
      {
         _loc2_ = 5;
         ishot = false;
      }
      if(_coinImg)
      {
         _coinImg.removeFromParent();
      }
      _coinImg = new Image(Assets.sAsset.getTexture("rechargeIcon_" + _loc2_));
      addChild(_coinImg);
      var _loc3_:DisplayObject = this.getChildByName("icon_pos") as DisplayObject;
      _coinImg.x = _loc3_.x;
      _coinImg.y = _loc3_.y;
      _coinImg.height = _loc3_.height;
      _coinImg.width = _loc3_.width;
      if(ishot)
      {
         _hotIcon.visible = true;
         this.setChildIndex(_hotIcon,this.numChildren - 1);
      }
      else
      {
         _hotIcon.visible = false;
      }
   }
   
   override protected function commitData() : void
   {
      super.commitData();
      _infoData = this._data as ProductInfo;
      _boyaa.text = _infoData.pcoins;
      if(PaymentInfoIdDlg.currentChance == "12")
      {
         _amout.text = "$" + _infoData.pamount;
      }
      else
      {
         _amout.text = int(_infoData.pamount) / 1000 + "K IDR";
      }
      showIcon();
   }
}
