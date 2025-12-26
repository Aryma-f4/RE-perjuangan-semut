package com.boyaa.antwars.view.screen.shop
{
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.ShopData;
   import org.osflash.signals.Signal;
   
   public class ShopManager
   {
      
      private static var _instance:ShopManager = null;
      
      public var signal:Signal = new Signal();
      
      public var buySignal:Signal = new Signal();
      
      private var _shopCartArr:Array;
      
      public function ShopManager(param1:Single)
      {
         super();
         _shopCartArr = [];
      }
      
      public static function get instance() : ShopManager
      {
         if(!_instance)
         {
            _instance = new ShopManager(new Single());
         }
         return _instance;
      }
      
      public function intoShoppingCart(param1:ShopData) : void
      {
         if(param1.isconsum == 1)
         {
            if(!hasSameGoods(param1))
            {
               shopCartArr.push(param1);
            }
         }
         else
         {
            shopCartArr.push(param1);
         }
         signal.dispatch(shopCartArr.length);
      }
      
      private function hasSameGoods(param1:ShopData) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:ShopData = null;
         _loc3_ = 0;
         while(_loc3_ < _shopCartArr.length)
         {
            _loc2_ = _shopCartArr[_loc3_] as ShopData;
            if(_loc2_.typeID == param1.typeID && _loc2_.frameID == param1.frameID)
            {
               _loc2_.amount++;
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function calculateTotalPrice(param1:int) : Number
      {
         var _loc5_:int = 0;
         var _loc3_:ShopData = null;
         var _loc2_:Number = 0;
         var _loc4_:int = int(_shopCartArr.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _shopCartArr[_loc5_] as ShopData;
            if(_loc3_.canBuyType(param1) && _loc3_.buyTypeInCar == param1)
            {
               _loc2_ += _loc3_.getPrice(param1)[0][1] * (_loc3_.amount + 1);
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function deleteItem(param1:ShopData) : void
      {
         var _loc4_:int = 0;
         var _loc2_:ShopData = null;
         var _loc3_:int = int(_shopCartArr.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _shopCartArr[_loc4_] as ShopData;
            if(_loc2_.typeID == param1.typeID && _loc2_.frameID == param1.frameID)
            {
               _shopCartArr.splice(_loc4_,1);
               _loc3_--;
               signal.dispatch(_loc3_);
               return;
            }
            _loc4_++;
         }
      }
      
      public function clearShoppingCart() : void
      {
         _shopCartArr.length = 0;
         signal.dispatch(0);
      }
      
      public function showBuyDlgByData(param1:ShopData) : void
      {
         var _loc2_:ShopBuyDlg = new ShopBuyDlg(true,param1);
         Application.instance.currentGame.addChild(_loc2_);
      }
      
      public function showBuyDlgByTypeID(param1:int, param2:int) : void
      {
         var _loc3_:ShopData = ShopDataList.instance.getSingleData(param1,param2);
         showBuyDlgByData(_loc3_);
      }
      
      public function get shopCartArr() : Array
      {
         return _shopCartArr;
      }
   }
}

class Single
{
   
   public function Single()
   {
      super();
   }
}
