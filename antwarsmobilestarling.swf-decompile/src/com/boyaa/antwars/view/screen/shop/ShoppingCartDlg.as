package com.boyaa.antwars.view.screen.shop
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.BaseDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.layout.TiledRowsLayout;
   import starling.events.Event;
   
   public class ShoppingCartDlg extends BaseDlg
   {
      
      private var list:List;
      
      private var _layout:LayoutUitl;
      
      private var listData:ListCollection;
      
      public var longTip:ShopItemDetailTip;
      
      private var _totalPrice:Number;
      
      private var _totalBoyaaPrice:Number;
      
      public function ShoppingCartDlg()
      {
         super();
         _layout = new LayoutUitl(Assets.sAsset.getOther("shop"),Assets.sAsset);
         _layout.buildLayout("ShoppingCart",_displayObj);
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
         this.addEventListener("addedToStage",onAddedToStage);
         init();
      }
      
      private function init() : void
      {
         addEvent();
         initList();
         ShopManager.instance.signal.add(updateList);
      }
      
      private function updateList(param1:int) : void
      {
         listData.data = ShopManager.instance.shopCartArr;
         if(ShopManager.instance.shopCartArr.length == 0)
         {
            list.dataProvider = null;
         }
         else
         {
            list.dataProvider = new ListCollection(ShopManager.instance.shopCartArr);
         }
         getTextFieldByName("txt_num").text = param1.toString();
         _totalPrice = ShopManager.instance.calculateTotalPrice(1);
         _totalBoyaaPrice = ShopManager.instance.calculateTotalPrice(3);
         getTextFieldByName("txt_price0").text = _totalBoyaaPrice.toString();
         getTextFieldByName("txt_price1").text = _totalPrice.toString();
      }
      
      private function initList() : void
      {
         list = new List();
         listData = new ListCollection();
         list.itemRendererType = ShopCartItemRender;
         list.addEventListener("change",onListChangeHandler);
         _displayObj.addChild(list);
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.useSquareTiles = false;
         _loc1_.gap = 10;
         list.layout = _loc1_;
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjByName("list_rect"),list);
         updateList(ShopManager.instance.shopCartArr.length);
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
      }
      
      private function onBuy(param1:Event) : void
      {
         var e:Event = param1;
         if(ShopManager.instance.shopCartArr.length > 0)
         {
            if(AccountData.instance.gameGold < _totalPrice || AccountData.instance.boyaaCoin < _totalBoyaaPrice)
            {
               SystemTip.instance.showSystemAlert(LangManager.t("rechargeBoyaaGold"),function():void
               {
                  Application.instance.currentGame.mainMenu.onRechargeBtn();
               },function():void
               {
               });
            }
            else
            {
               buyAll();
            }
         }
      }
      
      private function onClear(param1:Event) : void
      {
         ShopManager.instance.clearShoppingCart();
      }
      
      private function buyAll() : void
      {
         var item:ShopData;
         var price:Array;
         var buyNum:int;
         var ary:Array = [];
         var arr:Array = ShopManager.instance.shopCartArr;
         var i:int = 0;
         while(i < arr.length)
         {
            item = arr[i] as ShopData;
            price = item.getPrice(item.buyTypeInCar);
            buyNum = item.amount + 1;
            ary.push([item.buyTypeInCar,item.typeID,item.frameID,price[0][0],buyNum,""]);
            i = i + 1;
         }
         GameServer.instance.buy(1,ary,function(param1:Object):void
         {
            buyCallBack(param1);
         });
      }
      
      public function buyCallBack(param1:Object) : void
      {
         trace("[buyCallBack]",JSON.stringify(param1));
         if(param1.ret == 0)
         {
            GoodsList.instance.addGoodsByAry(param1.data.goodsAry);
            if(param1.data.money.gameGold != 0)
            {
               AccountData.instance.gameGold -= param1.data.money.gameGold;
            }
            if(param1.data.money.boyaaCoin != 0)
            {
               AccountData.instance.boyaaCoin -= param1.data.money.boyaaCoin;
            }
            TextTip.instance.show(LangManager.t("shop_success"));
            ShopManager.instance.buySignal.dispatch();
            ShopManager.instance.clearShoppingCart();
            deactive();
         }
         else
         {
            TextTip.instance.show(LangManager.t("shop_fail"));
         }
      }
      
      private function addEvent() : void
      {
         getButtonByName("btnS_exit").addEventListener("triggered",deactive);
         getButtonByName("btnS_clear_cart").addEventListener("triggered",onClear);
         getButtonByName("btnS_cart_buy").addEventListener("triggered",onBuy);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ShopManager.instance.signal.remove(updateList);
      }
   }
}

