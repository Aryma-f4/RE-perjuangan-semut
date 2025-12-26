package com.boyaa.antwars.data
{
   import com.boyaa.antwars.data.model.ShopData;
   
   public class ShopDataList
   {
      
      private static var _instance:ShopDataList = null;
      
      private var _shopType:int = 0;
      
      private var _allData:Array = null;
      
      private var _clothesData:Array = null;
      
      private var _shoesData:Array = null;
      
      private var _spectaclesData:Array = null;
      
      private var _ornamentData:Array = null;
      
      private var _hatData:Array = null;
      
      private var _gloveData:Array = null;
      
      private var _wingData:Array = null;
      
      private var _porpData:Array = null;
      
      private var _weaponData:Array = null;
      
      private var _recommendData:Array = null;
      
      private var _xinpingData:Array = null;
      
      private var _dazheData:Array = null;
      
      private var _mianfeiData:Array = null;
      
      private var _xianshiData:Array = null;
      
      private var _vipData:Array = null;
      
      private var _meltingFormulaData:Array = null;
      
      private var _speechBubbleData:Array = null;
      
      private var _cardData:Array = null;
      
      private var _necklace:Array = null;
      
      private var _unionList:Array;
      
      public function ShopDataList(param1:Single)
      {
         super();
      }
      
      public static function get instance() : ShopDataList
      {
         if(_instance == null)
         {
            _instance = new ShopDataList(new Single());
         }
         return _instance;
      }
      
      public function init() : void
      {
         _allData = [];
         _clothesData = [];
         _shoesData = [];
         _spectaclesData = [];
         _ornamentData = [];
         _hatData = [];
         _wingData = [];
         _recommendData = [];
         _xinpingData = [];
         _dazheData = [];
         _mianfeiData = [];
         _xianshiData = [];
         _vipData = [];
         _gloveData = [];
         _weaponData = [];
         _porpData = [];
         _meltingFormulaData = [];
         _speechBubbleData = [];
         _cardData = [];
         _necklace = [];
         _allData.push(_clothesData);
         _allData.push(_shoesData);
         _allData.push(_spectaclesData);
         _allData.push(_ornamentData);
         _allData.push(_hatData);
         _allData.push(_gloveData);
         _allData.push(_wingData);
         _allData.push(_weaponData);
         _allData.push(_porpData);
         _allData.push(_cardData);
         _allData.push(_recommendData);
         _allData.push(_xinpingData);
         _allData.push(_dazheData);
         _allData.push(_mianfeiData);
         _allData.push(_xianshiData);
         _allData.push(_vipData);
      }
      
      public function addUnionDataFromXML(param1:XML) : void
      {
         var _loc3_:int = 0;
         var _loc2_:UnionShopData = null;
         _unionList = [];
         _loc3_ = 0;
         while(_loc3_ < param1.props.length())
         {
            _loc2_ = new UnionShopData();
            _loc2_.updateForData(param1.props[_loc3_]);
            _unionList.push(_loc2_);
            _loc3_++;
         }
      }
      
      public function getUnionGoodsByLevel(param1:int) : Array
      {
         var _loc4_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < _unionList.length)
         {
            if(_unionList[_loc4_].placelevel == param1)
            {
               _loc3_.push(_unionList[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function addDataFromXML(param1:XML) : void
      {
         var _loc5_:int = 0;
         var _loc4_:ShopData = null;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         _loc5_ = 0;
         while(_loc5_ < param1.props.length())
         {
            _loc4_ = new ShopData();
            _loc2_ = _loc4_.updateForData(param1.props[_loc5_]);
            _loc3_ = [];
            if(_loc4_.recommend == 1)
            {
               _recommendData.push(_loc4_);
            }
            if(_loc4_.mianfei == 1)
            {
               _mianfeiData.push(_loc4_);
            }
            if(_loc4_.xinping == 1)
            {
               _xinpingData.push(_loc4_);
            }
            if(_loc4_.dazhe == 1)
            {
               _dazheData.push(_loc4_);
            }
            if(_loc4_.xianshi)
            {
               _xianshiData.push(_loc4_);
            }
            if(_loc4_.vipGood == 1)
            {
               _vipData.push(_loc4_);
            }
            _loc3_ = getType(_loc2_);
            _loc3_.push(_loc4_);
            _loc5_++;
         }
      }
      
      private function filterBuyType(param1:Array) : Array
      {
         var _loc3_:int = 0;
         var _loc2_:ShopData = null;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = param1[_loc3_];
            if(_loc2_.buyType == "01000")
            {
               param1.splice(_loc3_,1);
               _loc3_--;
            }
            _loc3_++;
         }
         return param1;
      }
      
      public function getWeapon() : Array
      {
         return _weaponData;
      }
      
      public function getMagicWeapon(param1:Array, param2:Boolean) : Array
      {
         var _loc8_:int = 0;
         var _loc5_:ShopData = null;
         var _loc3_:int = 0;
         var _loc4_:Array = [];
         var _loc7_:Array = [];
         var _loc6_:int = int(param1.length);
         _loc8_ = 0;
         while(_loc8_ < _loc6_)
         {
            _loc5_ = param1[_loc8_] as ShopData;
            _loc3_ = _loc5_.frameID / 10;
            if(_loc3_ == 101 || _loc3_ == 102 || _loc3_ == 103 || _loc3_ == 104 || _loc3_ == 111)
            {
               _loc4_.push(_loc5_);
            }
            else
            {
               _loc7_.push(_loc5_);
            }
            _loc8_++;
         }
         if(param2)
         {
            return _loc4_;
         }
         return _loc7_;
      }
      
      public function getWeaponImageString(param1:ShopData) : String
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(param1)
         {
            _loc2_ = param1.frameID / 10;
            _loc3_ = "mallet";
            switch(_loc2_ - 101)
            {
               case 0:
                  _loc3_ = "xg1";
                  break;
               case 1:
                  _loc3_ = "bl1";
                  break;
               case 2:
                  _loc3_ = "grenade1";
                  break;
               case 3:
                  _loc3_ = "missile1";
                  break;
               case 4:
                  _loc3_ = "xg0";
                  break;
               case 5:
                  _loc3_ = "bl0";
                  break;
               case 6:
                  _loc3_ = "grenade0";
                  break;
               case 7:
                  _loc3_ = "missile0";
                  break;
               case 8:
                  _loc3_ = "mallet";
                  break;
               case 9:
                  _loc3_ = "xq";
                  break;
               case 10:
                  _loc3_ = "bow0";
            }
            return _loc3_;
         }
         return null;
      }
      
      private function getType(param1:int) : Array
      {
         var _loc2_:* = param1;
         switch(_loc2_)
         {
            case 1:
            case 2:
            case 3:
               return _allData[_loc2_ - 1];
            case 4:
               return _allData[3];
            case 5:
               return _necklace;
            case 6:
            case 7:
            case 8:
               return _allData[_loc2_ - 2];
            case 11:
            case 12:
            case 13:
            case 14:
               return _weaponData;
            case 20:
            case 21:
            case 25:
            case 26:
            case 27:
            case 29:
            case 32:
            case 39:
            case 34:
            case 38:
            case 55:
            case 41:
            case 42:
            case 43:
               break;
            case 34:
            case 37:
               return _meltingFormulaData;
            case 9:
               return _speechBubbleData;
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 105:
            case 40:
               return _porpData;
            case 37:
               return _meltingFormulaData;
            case 9:
               return _speechBubbleData;
            case 36:
            case 33:
            case 10:
            case 30:
            case 31:
            case 35:
               return _cardData;
            default:
               return [];
         }
         return _porpData;
      }
      
      public function getSingleData(param1:int, param2:int) : ShopData
      {
         var _loc5_:int = 0;
         var _loc4_:ShopData = null;
         var _loc3_:Array = getType(param1);
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc4_ = _loc3_[_loc5_] as ShopData;
            if(_loc4_.typeID == param1 && _loc4_.frameID == param2)
            {
               return _loc3_[_loc5_];
            }
            _loc5_++;
         }
         return new ShopData();
      }
      
      public function getShopData(param1:int, param2:int) : Array
      {
         var _loc3_:Array = null;
         switch(param1)
         {
            case 1:
               _loc3_ = filterOther(_weaponData,2);
               break;
            case 2:
               _loc3_ = _clothesData;
               break;
            case 3:
               _loc3_ = _hatData;
               break;
            case 4:
               _loc3_ = _shoesData;
               break;
            case 5:
               _loc3_ = _speechBubbleData.concat(_ornamentData).concat(_necklace);
               break;
            case 6:
               _loc3_ = _gloveData;
               break;
            case 7:
               _loc3_ = _wingData;
               break;
            case 8:
               _loc3_ = _spectaclesData;
               break;
            case 10:
               _loc3_ = filterOtherFree(_porpData);
               break;
            case 13:
               _loc3_ = _meltingFormulaData;
               break;
            case 15:
               _loc3_ = _cardData;
               break;
            case 16:
               _loc3_ = _necklace;
               break;
            case 10000:
               _loc3_ = _recommendData;
               break;
            case 10001:
               _loc3_ = _xinpingData;
               break;
            case 10002:
               _loc3_ = _dazheData;
               break;
            case 10003:
               _loc3_ = _mianfeiData;
               break;
            case 10004:
               _loc3_ = filterFree(_weaponData,2);
               break;
            case 10005:
               _loc3_ = filterFree(_porpData,2);
               break;
            case 10006:
               _loc3_ = filterFree(_clothesData.concat(_shoesData).concat(_spectaclesData).concat(_hatData).concat(_ornamentData).concat(_necklace).concat(_gloveData).concat(_wingData),2);
         }
         if(shopType == 0)
         {
            _loc3_ = filterUnion(_loc3_);
         }
         return filterBySex(_loc3_,param2);
      }
      
      public function getStoneProp(param1:int) : Array
      {
         var _loc6_:int = 0;
         var _loc4_:ShopData = null;
         var _loc2_:Array = [];
         var _loc3_:Array = getShopDataMobile(3,PlayerDataList.instance.selfData.babySex);
         var _loc5_:int = int(_loc3_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = _loc3_[_loc6_] as ShopData;
            if(_loc4_.typeID == param1)
            {
               _loc2_.push(_loc4_);
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      public function getSyntheticStone() : Array
      {
         var _loc5_:int = 0;
         var _loc3_:ShopData = null;
         var _loc1_:Array = [];
         var _loc2_:Array = getShopDataMobile(3,PlayerDataList.instance.selfData.babySex);
         var _loc4_:int = int(_loc2_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _loc2_[_loc5_] as ShopData;
            if(_loc3_.typeID == 16 || _loc3_.typeID == 17 || _loc3_.typeID == 18 || _loc3_.typeID == 19)
            {
               _loc1_.push(_loc3_);
            }
            _loc5_++;
         }
         return _loc1_;
      }
      
      public function getOtherProps() : Array
      {
         var _loc5_:int = 0;
         var _loc3_:ShopData = null;
         var _loc1_:Array = [];
         var _loc2_:Array = getShopDataMobile(3,PlayerDataList.instance.selfData.babySex);
         var _loc4_:int = int(_loc2_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _loc2_[_loc5_] as ShopData;
            if(_loc3_.typeID < 15 || _loc3_.typeID > 20)
            {
               _loc1_.push(_loc3_);
            }
            _loc5_++;
         }
         return _loc1_;
      }
      
      public function getShopDataMobile(param1:int, param2:int) : Array
      {
         var _loc3_:Array = null;
         switch(param1 - 1)
         {
            case 0:
               _loc3_ = _recommendData;
               break;
            case 1:
               _loc3_ = _weaponData;
               break;
            case 2:
               _loc3_ = _porpData;
               break;
            case 3:
               _loc3_ = _wingData;
               break;
            case 4:
               _loc3_ = _clothesData.concat(_hatData).concat(_shoesData).concat(_necklace).concat(_ornamentData).concat(_gloveData);
         }
         trace(param1,"=====",_loc3_);
         if(shopType == 0)
         {
            _loc3_ = filterUnion(_loc3_);
         }
         _loc3_.sortOn(["quality","typeID"],[0x10 | 2,16]);
         return filterBySex(_loc3_,param2);
      }
      
      private function filterOtherFree(param1:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc2_:ShopData = null;
         var _loc3_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = param1[_loc4_] as ShopData;
            if(_loc2_.canBuyType(1))
            {
               _loc3_.push(param1[_loc4_]);
            }
            else if(_loc2_.canBuyType(3))
            {
               _loc3_.push(param1[_loc4_]);
            }
            else if(_loc2_.canBuyType(4))
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function filterOther(param1:Array, param2:int) : Array
      {
         var _loc5_:int = 0;
         var _loc3_:ShopData = null;
         var _loc4_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc3_ = param1[_loc5_] as ShopData;
            if(!_loc3_.canBuyType(param2))
            {
               _loc4_.push(param1[_loc5_]);
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function filterFree(param1:Array, param2:int) : Array
      {
         var _loc5_:int = 0;
         var _loc3_:ShopData = null;
         var _loc4_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc3_ = param1[_loc5_] as ShopData;
            if(_loc3_.canBuyType(param2))
            {
               _loc4_.push(param1[_loc5_]);
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function filterUnion(param1:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc2_:ShopData = null;
         if(param1 == null)
         {
            return [];
         }
         var _loc3_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = param1[_loc4_] as ShopData;
            if(_loc2_.sellPlace == 0)
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function filterBySex(param1:Array, param2:int) : Array
      {
         var _loc5_:int = 0;
         var _loc3_:ShopData = null;
         var _loc4_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc3_ = param1[_loc5_] as ShopData;
            if(_loc3_.canBuyInShop())
            {
               if(_loc3_.gender == 0)
               {
                  _loc4_.push(param1[_loc5_]);
               }
               else if(_loc3_.gender == param2 + 1)
               {
                  _loc4_.push(param1[_loc5_]);
               }
            }
            _loc5_++;
         }
         _loc4_.reverse();
         return _loc4_;
      }
      
      public function getSeaData(param1:String) : Array
      {
         var _loc6_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc3_:ShopData = null;
         var _loc2_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < _allData.length)
         {
            _loc4_ = _allData[_loc6_];
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc3_ = _loc4_[_loc5_];
               if(_loc3_.canBuyInShop() && _loc3_.name.indexOf(param1) != -1)
               {
                  _loc2_.push(_loc3_);
               }
               _loc5_++;
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      public function getAllTypeData(param1:int) : Array
      {
         var _loc6_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc3_:ShopData = null;
         var _loc2_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < _allData.length)
         {
            _loc4_ = _allData[_loc6_];
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc3_ = _loc4_[_loc5_];
               if(_loc3_.canBuyInShop())
               {
                  if(_loc3_.typeID == param1)
                  {
                     _loc2_.push(_loc3_);
                  }
               }
               _loc5_++;
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      public function get allData() : Array
      {
         return _allData;
      }
      
      public function get unionList() : Array
      {
         return _unionList;
      }
      
      public function get shopType() : int
      {
         return _shopType;
      }
      
      public function set shopType(param1:int) : void
      {
         _shopType = param1;
      }
      
      public function get vipData() : Array
      {
         return _vipData;
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
