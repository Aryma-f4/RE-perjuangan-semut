package com.boyaa.antwars.data
{
   import com.boyaa.antwars.data.model.FightGoodsData;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.mission.MissionManager;
   import org.osflash.signals.Signal;
   
   public class GoodsList
   {
      
      private static var _instance:GoodsList = null;
      
      private var _fightGoods:StaticFightGoods = null;
      
      private var _list:Array = null;
      
      public var serveraddEXP:Boolean = false;
      
      public var payPorpIdArr:Array = null;
      
      private var _normalSkillArr:Array = [];
      
      private var _ordinaryEquipment:Array = null;
      
      private var _suit:Array = null;
      
      private var _props:Array = null;
      
      public var inBodyExpiration:Array = [];
      
      private var _copy_placer:Object = null;
      
      private var _otherList:Array = null;
      
      private var _storageList:Array = null;
      
      private var _unionStorageList:Array = [];
      
      private var _myRentalList:Array = [];
      
      public var _rentalGoodsOvertime:Array = [];
      
      private var _bagList:Array = [];
      
      private var _rentArr:Array = [];
      
      public var rentalSiganl:Signal = new Signal();
      
      public function GoodsList(param1:Single)
      {
         super();
         _fightGoods = new StaticFightGoods();
         init();
      }
      
      public static function get instance() : GoodsList
      {
         if(_instance == null)
         {
            _instance = new GoodsList(new Single());
         }
         return _instance;
      }
      
      public function init() : void
      {
         _list = [];
         _otherList = [];
         _storageList = [];
         _props = [];
         _suit = [];
         _ordinaryEquipment = [];
         payPorpIdArr = [];
         _copy_placer = {};
         _unionStorageList = [];
      }
      
      public function get list() : Array
      {
         return _list;
      }
      
      public function get rentArr() : Array
      {
         return _rentArr;
      }
      
      public function set rentArr(param1:Array) : void
      {
         _rentArr = param1;
      }
      
      public function modifyRentArr(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = int(_rentArr.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(_rentArr[_loc3_] == param1)
            {
               _rentArr.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function get bagList() : Array
      {
         var _loc3_:int = 0;
         var _loc1_:GoodsData = null;
         var _loc2_:int = int(_list.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = _list[_loc3_] as GoodsData;
            if(_loc1_.place == 0)
            {
               _bagList.push(_loc1_);
            }
            _loc3_++;
         }
         return _bagList;
      }
      
      public function getBagData() : Array
      {
         var _loc2_:Array = [];
         var _loc3_:Array = GoodsList.instance.getWQ(2);
         var _loc1_:Array = GoodsList.instance.getFZ(2);
         _loc2_ = _loc3_.concat(_loc1_);
         return _loc2_.concat(getOther());
      }
      
      public function getFightDataByID(param1:int) : FightGoodsData
      {
         return _fightGoods.getDataByID(param1);
      }
      
      public function getPriceByFrame(param1:int) : int
      {
         return _fightGoods.getPriceByFrame(param1);
      }
      
      public function getFightGoodsListByType(param1:int) : Vector.<FightGoodsData>
      {
         return _fightGoods.getListByType(param1);
      }
      
      public function getMyFightGoodsMinActionPoint() : int
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc1_:* = 100000;
         var _loc3_:Array = getBTPropAndSkill();
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = getFightDataByID(_loc3_[_loc4_]).expendForce;
            if(_loc1_ > _loc2_)
            {
               _loc1_ = _loc2_;
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getAttribute(param1:Array = null) : Array
      {
         var _loc7_:int = 0;
         var _loc4_:GoodsData = null;
         var _loc6_:int = 0;
         var _loc2_:Array = [0,0,0,0,0,0,0,[],[]];
         var _loc5_:* = [];
         if(param1 == null)
         {
            _loc5_ = getEquipment(1);
         }
         else
         {
            _loc5_ = param1;
         }
         _loc7_ = 0;
         while(_loc7_ < _loc5_.length)
         {
            _loc4_ = _loc5_[_loc7_];
            if(_loc4_)
            {
               if(_loc4_.isEquipment)
               {
                  if(_loc4_.place == 1)
                  {
                     var _loc8_:* = 0;
                     var _loc9_:* = _loc2_[_loc8_] + _loc4_.attack;
                     _loc2_[_loc8_] = _loc9_;
                     _loc2_[0] += _loc4_.attackLevel * 10;
                     _loc2_[1] += _loc4_.defense;
                     _loc2_[1] += _loc4_.defenseLevel * 10;
                     _loc2_[2] += _loc4_.nimble;
                     _loc2_[2] += _loc4_.nimbleLevel * 10;
                     _loc2_[3] += _loc4_.lucky;
                     _loc2_[3] += _loc4_.luckyLevel * 10;
                     _loc2_[4] += _loc4_.damage + _loc4_.annexDamage;
                     _loc2_[5] += _loc4_.armor + _loc4_.annexArmor;
                     _loc2_[6] += _loc4_.strengthenNum;
                     if(_loc4_.typeID == 5)
                     {
                        _loc2_[9] = _loc4_.best;
                     }
                  }
               }
            }
            _loc7_++;
         }
         var _loc3_:Array = SuitDataList.instance.getSuitAttribute(_loc5_);
         _loc6_ = 0;
         while(_loc6_ < 6)
         {
            _loc9_ = _loc6_;
            _loc8_ = _loc2_[_loc9_] + _loc3_[_loc6_];
            _loc2_[_loc9_] = _loc8_;
            _loc6_++;
         }
         _loc2_[7] = _loc3_[6];
         _loc2_[8] = _loc3_[7];
         return _loc2_;
      }
      
      public function getEquipment(param1:int) : Array
      {
         var _loc5_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < _list.length)
         {
            if((_list[_loc5_] as GoodsData).isEquipment)
            {
               _loc4_.push(_list[_loc5_]);
               if((_list[_loc5_] as GoodsData).place == 1)
               {
                  _loc2_.push(_list[_loc5_]);
               }
               else
               {
                  _loc3_.push(_list[_loc5_]);
               }
            }
            _loc5_++;
         }
         if(param1 == 1)
         {
            return _loc2_;
         }
         if(param1 == 0)
         {
            return _loc3_;
         }
         return _loc4_;
      }
      
      public function addUnionRentalGoodsByArr(param1:Array) : void
      {
         var _loc3_:* = 0;
         _unionStorageList = [];
         _myRentalList = [];
         if(param1.length == 0)
         {
            _unionStorageList = [];
            return;
         }
         var _loc2_:int = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            addUnionRenalGoodsByStr(param1[_loc3_][0],param1[_loc3_][1]);
            _loc3_++;
         }
      }
      
      public function addUnionRenalGoodsByStr(param1:Object, param2:Array) : GoodsData
      {
         var _loc3_:GoodsData = new GoodsData();
         _loc3_.updateGoodsInfo(param2);
         _loc3_.addOtherProperty(param1);
         addUnionRentalGoods(_loc3_);
         return _loc3_;
      }
      
      private function addUnionRentalGoods(param1:GoodsData) : void
      {
         var _loc2_:GoodsData = null;
         trace(PlayerDataList.instance.selfData.uid + "----" + param1.owner);
         if(param1.owner == PlayerDataList.instance.selfData.uid)
         {
            _loc2_ = new GoodsData();
            _loc2_.copyData(param1);
            _myRentalList.push(_loc2_);
         }
         if(param1.stutas != 20 && param1.isbind != 1)
         {
            _unionStorageList.push(param1);
         }
      }
      
      public function addGoodsByAry(param1:Array) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            addGoodsByStr(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function addGoodsByStr(param1:Array) : GoodsData
      {
         var _loc2_:GoodsData = new GoodsData();
         _loc2_.updateGoodsInfo(param1);
         addGoods(_loc2_);
         return _loc2_;
      }
      
      private function addGoods(param1:GoodsData) : void
      {
         var _loc2_:int = removeGoodsByOnlyID(param1.onlyID,0);
         if(_loc2_ != 0 && param1.place == 0)
         {
            param1.place = _loc2_;
         }
         if(param1.position == 3)
         {
            _storageList.push(param1);
         }
         else if(param1.position == 5)
         {
            param1.rentStatus = 1;
            _storageList.push(param1);
         }
         else if(param1.position == 0 || param1.position == 1)
         {
            trace("添加到背包" + param1.position,"  " + param1.name);
            _list.push(param1);
         }
         MissionManager.instance.updateMissionData(115,param1.typeID,param1.frameID);
      }
      
      public function getSuitData() : Array
      {
         var _loc1_:int = 0;
         _suit = [];
         _loc1_ = 0;
         while(_loc1_ < _list.length)
         {
            if(_list[_loc1_].proptype == 10)
            {
               _suit.push(_list[_loc1_]);
            }
            _loc1_++;
         }
         return _suit;
      }
      
      public function getOrdinaryEquipmentData() : Array
      {
         var _loc1_:int = 0;
         _ordinaryEquipment = [];
         _loc1_ = 0;
         while(_loc1_ < _list.length)
         {
            if(_list[_loc1_].proptype == 1)
            {
               _ordinaryEquipment.push(_list[_loc1_]);
            }
            _loc1_++;
         }
         return _ordinaryEquipment;
      }
      
      public function getWQ(param1:int = 0) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         switch(param1)
         {
            case 0:
               _loc3_ = 0;
               while(_loc3_ < _list.length)
               {
                  if(_list[_loc3_].isWeapon)
                  {
                     _loc2_.push(_list[_loc3_]);
                  }
                  _loc3_++;
               }
               break;
            case 1:
               _loc3_ = 0;
               while(_loc3_ < _list.length)
               {
                  if(_list[_loc3_].isWeapon && _list[_loc3_].place == 1)
                  {
                     _loc2_.push(_list[_loc3_]);
                  }
                  _loc3_++;
               }
               break;
            case 2:
               _loc3_ = 0;
               while(_loc3_ < _list.length)
               {
                  if(_list[_loc3_].isWeapon && _list[_loc3_].place != 1)
                  {
                     _loc2_.push(_list[_loc3_]);
                  }
                  _loc3_++;
               }
         }
         return _loc2_;
      }
      
      public function getFZ(param1:int = 0) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         switch(param1)
         {
            case 0:
               _loc3_ = 0;
               while(_loc3_ < _list.length)
               {
                  if(_list[_loc3_].isWear)
                  {
                     _loc2_.push(_list[_loc3_]);
                  }
                  _loc3_++;
               }
               break;
            case 1:
               _loc3_ = 0;
               while(_loc3_ < _list.length)
               {
                  if(_list[_loc3_].isWear && _list[_loc3_].place == 1)
                  {
                     _loc2_.push(_list[_loc3_]);
                  }
                  _loc3_++;
               }
               break;
            case 2:
               _loc3_ = 0;
               while(_loc3_ < _list.length)
               {
                  if(_list[_loc3_].isWear && _list[_loc3_].place != 1)
                  {
                     _loc2_.push(_list[_loc3_]);
                  }
                  _loc3_++;
               }
         }
         return _loc2_;
      }
      
      public function getOther() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < _list.length)
         {
            if(!_list[_loc2_].isWear && !_list[_loc2_].isWeapon)
            {
               _loc1_.push(_list[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getPropsData() : Array
      {
         var _loc1_:int = 0;
         _props = [];
         _loc1_ = 0;
         while(_loc1_ < _list.length)
         {
            if(_list[_loc1_].proptype == 2)
            {
               _props.push(_list[_loc1_]);
            }
            _loc1_++;
         }
         return _props;
      }
      
      public function removeGoodsByOnlyID(param1:int, param2:int = 1) : int
      {
         var _loc4_:int = 0;
         var _loc3_:GoodsData = null;
         _loc4_ = 0;
         while(_loc4_ < _list.length)
         {
            _loc3_ = _list[_loc4_] as GoodsData;
            if(_loc3_.onlyID == param1)
            {
               if(_loc3_.isconsum && _loc3_.amount > param2 && param2 != 0)
               {
                  _loc3_.amount -= param2;
               }
               else
               {
                  _loc3_.amount = 0;
                  _list.splice(_loc4_,1);
               }
               return _loc3_.place;
            }
            _loc4_++;
         }
         return 0;
      }
      
      public function reduceConsumeGoods(param1:int, param2:int, param3:int) : void
      {
         var _loc5_:GoodsData = null;
         var _loc4_:Array = getOnlyIDArr(param1,param2);
         if(_loc4_.length == 1)
         {
            removeGoodsByOnlyID(_loc4_[0],param3);
         }
         else if(_loc4_.length == 2)
         {
            _loc5_ = getGoodsByOnlyID(_loc4_[0]);
            if(_loc5_.amount < param3)
            {
               removeGoodsByOnlyID(_loc4_[1],param3 - _loc5_.amount);
               removeGoodsByOnlyID(_loc4_[0],_loc5_.amount);
            }
            else
            {
               removeGoodsByOnlyID(_loc4_[0],param3);
            }
         }
      }
      
      public function holdPositions(param1:int, param2:int) : void
      {
         _copy_placer[param1] = param2;
      }
      
      public function getGoodsByOnlyID(param1:int) : GoodsData
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _list.length)
         {
            if((_list[_loc2_] as GoodsData).onlyID == param1)
            {
               return _list[_loc2_];
            }
            _loc2_++;
         }
         return new GoodsData();
      }
      
      public function getStrengGood() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:GoodsData = null;
         var _loc3_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < _list.length)
         {
            _loc1_ = _list[_loc2_];
            if(_loc1_.isEquipment)
            {
               if(_loc1_.place == 1)
               {
                  if(_loc1_.strengthenNum >= 6)
                  {
                     _loc3_.push(_loc1_);
                  }
               }
            }
            _loc2_++;
         }
         return _loc3_;
      }
      
      public function getActiveGoods() : Array
      {
         var _loc3_:int = 0;
         var _loc2_:GoodsData = null;
         var _loc1_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < _list.length)
         {
            _loc2_ = _list[_loc3_];
            if(_loc2_.isEquipment)
            {
               if(_loc2_.place == 1)
               {
                  if(_loc2_.typeID == 6 || _loc2_.typeID == 2 || _loc2_.typeID == 3 || _loc2_.typeID == 1 || _loc2_.typeID == 7 || _loc2_.typeID == 8)
                  {
                     _loc1_.push([_loc2_.typeID,_loc2_.frameID,_loc2_.color]);
                  }
               }
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function getBodyGoods(param1:String) : Array
      {
         var _loc5_:* = null;
         var _loc7_:int = 0;
         var _loc3_:GoodsData = null;
         var _loc2_:Array = [];
         var _loc4_:Array = [];
         if(param1 != "")
         {
            _loc4_ = JSON.parse(param1) as Array;
         }
         _loc7_ = 0;
         while(_loc7_ < _loc4_[1].length)
         {
            _loc3_ = new GoodsData();
            _loc3_.updateGoodsInfo(_loc4_[1][_loc7_]);
            _loc5_ = _loc3_;
            _loc5_.place = 1;
            _loc2_.push(_loc5_);
            _loc7_++;
         }
         for(var _loc6_ in _loc4_[0])
         {
            _loc5_ = GoodsList.instance.getGoodsByOnlyID(_loc4_[0][_loc6_]);
            _loc5_.placeDec = _loc6_;
         }
         return _loc2_;
      }
      
      public function resetBodyGoods(param1:String) : void
      {
         var _loc2_:GoodsData = null;
         var _loc5_:int = 0;
         GoodsList.instance.resetPlace();
         if(param1 == "")
         {
            return;
         }
         var _loc3_:Array = JSON.parse(param1) as Array;
         _loc5_ = 0;
         while(_loc5_ < _loc3_[1].length)
         {
            _loc2_ = GoodsList.instance.addGoodsByStr(_loc3_[1][_loc5_]);
            _loc2_.place = 1;
            _loc5_++;
         }
         for(var _loc4_ in _loc3_[0])
         {
            _loc2_ = GoodsList.instance.getGoodsByOnlyID(_loc3_[0][_loc4_]);
            _loc2_.placeDec = _loc4_;
         }
      }
      
      public function takeOffGoodsById(param1:String) : void
      {
         var _loc2_:GoodsData = null;
         _loc2_ = getGoodsByPosName(param1);
         if(_loc2_)
         {
            _loc2_.place = 0;
         }
      }
      
      public function resetPlace() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _list.length)
         {
            if((_list[_loc1_] as GoodsData).place == 1)
            {
               (_list[_loc1_] as GoodsData).place = 0;
            }
            _loc1_++;
         }
      }
      
      public function getOnlyIDArr(param1:int, param2:int, param3:Boolean = false) : Array
      {
         var _loc7_:int = 0;
         var _loc6_:GoodsData = null;
         if(param3)
         {
            return getOtherOnlyIDArr(param1,param2);
         }
         var _loc5_:Array = [];
         _loc7_ = 0;
         while(_loc7_ < _list.length)
         {
            _loc6_ = _list[_loc7_];
            if(_loc6_.typeID == param1 && _loc6_.frameID == param2)
            {
               _loc5_.push(_list[_loc7_].onlyID);
            }
            _loc7_++;
         }
         var _loc4_:int = 0;
         if(_loc5_.length == 2)
         {
            if(getGoodsByOnlyID(_loc5_[1]).isbind == 1)
            {
               _loc4_ = int(_loc5_[0]);
               _loc5_[0] = _loc5_[1];
               _loc5_[1] = _loc4_;
            }
         }
         return _loc5_;
      }
      
      public function getConsumeGoods(param1:int, param2:int) : Array
      {
         var _loc5_:GoodsData = null;
         var _loc7_:* = 0;
         var _loc6_:Array = [];
         var _loc3_:Array = getOnlyIDArr(param1,param2);
         var _loc4_:uint = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc3_.length)
         {
            _loc5_ = getGoodsByOnlyID(_loc3_[_loc7_]);
            _loc4_ += _loc5_.amount;
            _loc6_.push([_loc3_[_loc7_],_loc5_.amount]);
            _loc7_++;
         }
         _loc6_.push(_loc4_);
         return _loc6_;
      }
      
      public function getOtherOnlyIDArr(param1:int, param2:int) : Array
      {
         var _loc5_:int = 0;
         var _loc4_:GoodsData = null;
         var _loc3_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < _otherList.length)
         {
            _loc4_ = _otherList[_loc5_];
            if(_loc4_.typeID == param1 && _loc4_.frameID == param2)
            {
               _loc3_.push(_otherList[_loc5_].onlyID);
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function getGoodsListUnbind() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < _list.length)
         {
            if((_list[_loc2_] as GoodsData).isbind == 0)
            {
               _loc1_.push(_list[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getGoodsByPosName(param1:String) : GoodsData
      {
         var _loc4_:int = 0;
         var _loc3_:GoodsData = null;
         var _loc2_:Array = getEquipment(1);
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc4_];
            if(_loc3_.getPosName() == param1)
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function wearGoods(param1:String, param2:Array) : void
      {
         var _loc3_:GoodsData = null;
         _loc3_ = getGoodsByPosName(param1);
         if(_loc3_)
         {
            _loc3_.place = 0;
         }
         _loc3_ = GoodsList.instance.addGoodsByStr(param2);
         _loc3_.placeDec = param1;
         _loc3_.place = 1;
      }
      
      public function wearGoodsById(param1:String, param2:int, param3:int) : void
      {
         var _loc4_:GoodsData = null;
         _loc4_ = getGoodsByPosName(param1);
         if(_loc4_)
         {
            _loc4_.place = 0;
         }
         _loc4_ = GoodsList.instance.getGoodsById(param2,param3);
         trace(_loc4_);
         if(_loc4_)
         {
            _loc4_.placeDec = param1;
            _loc4_.place = 1;
         }
      }
      
      public function getGoodsById(param1:int, param2:int) : GoodsData
      {
         var _loc4_:int = 0;
         var _loc3_:GoodsData = null;
         _loc4_ = 0;
         while(_loc4_ < _list.length)
         {
            _loc3_ = _list[_loc4_];
            if(_loc3_.typeID == param1 && _loc3_.frameID == param2)
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getGoodsNumInMission(param1:int, param2:int) : int
      {
         var _loc5_:int = 0;
         var _loc4_:GoodsData = null;
         var _loc3_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < _list.length)
         {
            _loc4_ = _list[_loc5_];
            if(_loc4_.typeID == param1 && _loc4_.frameID == param2)
            {
               _loc3_ += _loc4_.amount;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function getHighestStrengthenNumByTypeFrame(param1:int, param2:int) : int
      {
         var _loc5_:int = 0;
         var _loc4_:GoodsData = null;
         var _loc3_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < _list.length)
         {
            _loc4_ = _list[_loc5_] as GoodsData;
            if(_loc4_.typeID == param1 && _loc4_.frameID == param2)
            {
               if(_loc4_.strengthenNum > _loc3_)
               {
                  _loc3_ = _loc4_.strengthenNum;
               }
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function get otherList() : Array
      {
         return _otherList;
      }
      
      public function set otherList(param1:Array) : void
      {
         _otherList = param1;
      }
      
      public function get storageList() : Array
      {
         return _storageList;
      }
      
      public function get unionStorageList() : Array
      {
         return _unionStorageList;
      }
      
      public function get myRentalList() : Array
      {
         return _myRentalList;
      }
      
      public function get normalSkillArr() : Array
      {
         if(LocalData.instance.getData("skill"))
         {
            _normalSkillArr = LocalData.instance.getData("skill").split("|");
         }
         return _normalSkillArr;
      }
      
      public function deleteItemFromeStorageList(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc2_:GoodsData = null;
         var _loc3_:int = int(_unionStorageList.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _unionStorageList[_loc4_] as GoodsData;
            if(_loc2_.onlyID == param1)
            {
               _unionStorageList.splice(_loc4_,1);
               rentalSiganl.dispatch(1);
               return;
            }
            _loc4_++;
         }
      }
      
      public function deleteItemFromeMyStorageList(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc2_:GoodsData = null;
         var _loc3_:int = int(_storageList.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _storageList[_loc4_] as GoodsData;
            if(_loc2_.onlyID == param1)
            {
               _storageList.splice(_loc4_,1);
               return;
            }
            _loc4_++;
         }
      }
      
      public function deleteItemFromMyRentalList(param1:int, param2:Boolean = true) : void
      {
         var _loc5_:int = 0;
         var _loc3_:GoodsData = null;
         if(param2)
         {
            deleteItemFromeMyStorageList(param1);
         }
         var _loc4_:int = int(_myRentalList.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _myRentalList[_loc5_] as GoodsData;
            if(_loc3_.onlyID == param1)
            {
               _myRentalList.splice(_loc5_,1);
               rentalSiganl.dispatch(0);
               return;
            }
            _loc5_++;
         }
      }
      
      public function getGoodsByTypeIDFromUnionStorage(param1:int) : Array
      {
         var _loc4_:int = 0;
         var _loc3_:GoodsData = null;
         var _loc2_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < _unionStorageList.length)
         {
            _loc3_ = _unionStorageList[_loc4_] as GoodsData;
            if(param1 == _loc3_.typeID)
            {
               _loc2_.push(_loc3_);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function search(param1:String) : Array
      {
         var _loc5_:int = 0;
         var _loc3_:GoodsData = null;
         var _loc2_:Array = [];
         var _loc4_:int = int(_unionStorageList.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _unionStorageList[_loc5_] as GoodsData;
            if(_loc3_.name.indexOf(param1) != -1)
            {
               _loc2_.push(_loc3_);
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function isBodyExpiration(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < inBodyExpiration.length)
         {
            if((inBodyExpiration[_loc2_] as GoodsData).onlyID == param1)
            {
               inBodyExpiration.splice(_loc2_,1);
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function getTypeID(param1:String) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case "coat":
               _loc2_ = 1;
               break;
            case "shoes":
               _loc2_ = 2;
               break;
            case "hat":
               _loc2_ = 6;
               break;
            case "glove":
               _loc2_ = 7;
               break;
            case "wing":
               _loc2_ = 8;
               break;
            case "weapon":
               _loc2_ = 11;
               break;
            case "weddingRing":
               _loc2_ = 4;
               break;
            case "necklace":
               _loc2_ = 5;
               break;
            case "glass":
            case "normalRing":
         }
         return _loc2_;
      }
      
      public function getOvertimeEquip() : Array
      {
         var _loc4_:int = 0;
         var _loc2_:GoodsData = null;
         var _loc3_:int = int(list.length);
         var _loc1_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = list[_loc4_] as GoodsData;
            if(_loc2_.stutas == 0)
            {
               _loc1_.push(_loc2_);
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function removeOvertimeRentalEquip() : void
      {
         var _loc5_:int = 0;
         var _loc2_:GoodsData = null;
         var _loc4_:int = 0;
         if(_rentalGoodsOvertime.length == 0)
         {
            return;
         }
         var _loc3_:int = int(list.length);
         var _loc1_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc2_ = list[_loc5_] as GoodsData;
            _loc4_ = 0;
            while(_loc4_ < _rentalGoodsOvertime.length)
            {
               if(_rentalGoodsOvertime[_loc4_] == _loc2_.onlyID)
               {
                  _rentalGoodsOvertime.splice(_loc4_,1);
                  _loc4_--;
                  list.splice(_loc5_,1);
                  TextTip.instance.show(LangManager.replace("rentout_over",_loc2_.name));
               }
               _loc4_++;
            }
            _loc5_++;
         }
      }
      
      public function nobodyRentBacktoMystore(param1:Array) : void
      {
         var _loc2_:int = int(param1[1]);
         if(param1[0] == PlayerDataList.instance.selfData.uid)
         {
            deleteItemFromMyRentalList(_loc2_,false);
            deleteItemFromeStorageList(_loc2_);
            modifyStorageList(_loc2_);
         }
      }
      
      public function modifyStorageList(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc2_:GoodsData = null;
         var _loc3_:int = int(_storageList.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _storageList[_loc4_] as GoodsData;
            if(_loc2_.onlyID == param1)
            {
               _loc2_.rentStatus = 0;
               rentalSiganl.dispatch(2);
               break;
            }
            _loc4_++;
         }
      }
      
      public function getBTPropAndSkill() : Array
      {
         var data:Array;
         var skilldata:Array = [];
         if(LocalData.instance.getData("skill"))
         {
            skilldata = LocalData.instance.getData("skill").split("|");
         }
         Application.instance.log("getBTpropAndSkill",JSON.stringify(skilldata));
         data = skilldata.concat(GoodsList.instance.payPorpIdArr);
         return data.filter(function(param1:String, param2:int, param3:Array):Boolean
         {
            return param1 != "" && param1 != " ";
         });
      }
      
      public function setBTPropAndSkill(param1:Array, param2:Array = null) : void
      {
         payPorpIdArr = param1;
         if(param2)
         {
            LocalData.instance.setData("skill",param2.join("|"));
         }
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
