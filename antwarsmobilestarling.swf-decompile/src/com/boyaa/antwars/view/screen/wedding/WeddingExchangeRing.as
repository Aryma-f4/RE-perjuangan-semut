package com.boyaa.antwars.view.screen.wedding
{
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.ShopData;
   import starling.display.Sprite;
   
   public class WeddingExchangeRing
   {
      
      private var _view:Sprite;
      
      private var _exchangeArr:Vector.<ExchangeLayout>;
      
      private var _exchangeNumArr:Array = [299,499,899];
      
      public function WeddingExchangeRing(param1:Sprite)
      {
         super();
         _view = param1;
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:ExchangeLayout = null;
         var _loc3_:ShopData = null;
         var _loc4_:int = 0;
         _exchangeArr = new Vector.<ExchangeLayout>();
         _loc4_ = 0;
         while(_loc4_ < 3)
         {
            _loc1_ = _view.getChildByName("exchange" + _loc4_) as Sprite;
            _loc2_ = new ExchangeLayout(_loc1_);
            _loc3_ = ShopDataList.instance.getSingleData(4,1022 + _loc4_ * 10);
            _loc2_.setData(_loc3_,_exchangeNumArr[_loc4_]);
            _exchangeArr.push(_loc2_);
            _loc4_++;
         }
      }
   }
}

import com.boyaa.antwars.data.GoodsList;
import com.boyaa.antwars.data.ShopDataList;
import com.boyaa.antwars.data.model.GoodsData;
import com.boyaa.antwars.data.model.ShopData;
import com.boyaa.antwars.lang.LangManager;
import com.boyaa.antwars.net.server.GameServer;
import com.boyaa.antwars.view.TextTip;
import com.boyaa.antwars.view.screen.shop.GoodsDetailView;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

class ExchangeLayout
{
   
   private var _posHelper:Rectangle;
   
   private var _view:Sprite;
   
   private var _ringImage:GoodsDetailView;
   
   private var _roseImage:GoodsDetailView;
   
   private var _smallRingImage:GoodsDetailView;
   
   private var _exchangeBtn:Button;
   
   private var _ringName:String;
   
   private var _roseNum:int;
   
   private var _showData:ShopData;
   
   private var _exchangeGoodData:GoodsData;
   
   private const shopDataArr:Array = [[4,1012],[4,1022],[4,1032],[4,1042],[34,1081]];
   
   public function ExchangeLayout(param1:Sprite)
   {
      super();
      _view = param1;
      init();
   }
   
   private function init() : void
   {
      _exchangeBtn = _view.getChildByName("rewardBtn") as Button;
      _exchangeBtn.addEventListener("triggered",onExchangeHandle);
      var _loc2_:DisplayObject = _view.getChildByName("rose");
      var _loc1_:ShopData = ShopDataList.instance.getSingleData(shopDataArr[4][0],shopDataArr[4][1]);
      _roseImage = new GoodsDetailView(_view.getChildByName("rose").bounds,_loc1_);
      _roseImage.addEvent();
      _view.addChild(_roseImage);
      TextField(_view.getChildByName("addFlag")).nativeFilters = [new GlowFilter(3677194,1,5,5,15)];
      TextField(_view.getChildByName("roseNum")).nativeFilters = [new GlowFilter(3677194,1,5,5,15)];
   }
   
   private function onExchangeHandle(param1:Event) : void
   {
      var _loc4_:GoodsData = GoodsList.instance.getGoodsById(_showData.typeID,_showData.frameID - 10);
      if(!_loc4_)
      {
         TextTip.instance.show(LangManager.getLang.getreplaceLang("exchangeRingTip2",ShopDataList.instance.getSingleData(_showData.typeID,_showData.frameID - 10).name));
         return;
      }
      _exchangeGoodData = _loc4_;
      var _loc3_:Array = GoodsList.instance.getConsumeGoods(shopDataArr[4][0],shopDataArr[4][1]);
      var _loc2_:int = int(_loc3_[_loc3_.length - 1]);
      if(_loc2_ < _roseNum)
      {
         TextTip.instance.show(LangManager.getLang.getreplaceLang("exchangeRingTip2",ShopDataList.instance.getSingleData(shopDataArr[4][0],shopDataArr[4][1]).name));
         return;
      }
      _loc3_.pop();
      GameServer.instance.weddingExchangeRing(_loc4_.onlyID,_loc3_,onExchangeResult);
   }
   
   private function onExchangeResult(param1:Object) : void
   {
      Application.instance.log("onExchangeResult",JSON.stringify(param1));
      if(param1.data.isSuccess == 1)
      {
         TextTip.instance.showByLang("exchangeRingTip0");
         GoodsList.instance.removeGoodsByOnlyID(_exchangeGoodData.onlyID);
         GoodsList.instance.reduceConsumeGoods(shopDataArr[4][0],shopDataArr[4][1],_roseNum);
         Application.instance.currentGame.mainMenu.backpack.updateData();
      }
      else
      {
         TextTip.instance.showByLang("exchangeRingTip1");
      }
   }
   
   public function setData(param1:ShopData, param2:int) : void
   {
      this.roseNum = param2;
      _showData = param1;
      _ringImage = new GoodsDetailView(_view.getChildByName("goodsBox").bounds,_showData);
      _ringImage.addEvent();
      _smallRingImage = new GoodsDetailView(_view.getChildByName("smallRing").bounds,ShopDataList.instance.getSingleData(param1.typeID,param1.frameID - 10));
      _smallRingImage.addEvent();
      _view.addChild(_ringImage);
      _view.addChild(_smallRingImage);
   }
   
   public function set ringName(param1:String) : void
   {
      _ringName = param1;
      TextField(_view.getChildByName("goodsName")).text = _ringName;
   }
   
   public function set roseNum(param1:int) : void
   {
      _roseNum = param1;
      TextField(_view.getChildByName("roseNum")).text = "x" + _roseNum;
   }
}
