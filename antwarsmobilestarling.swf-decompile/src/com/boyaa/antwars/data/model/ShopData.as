package com.boyaa.antwars.data.model
{
   import com.boyaa.antwars.lang.LangManager;
   
   public class ShopData
   {
      
      public static var GOOGS_TITLES:Array;
      
      protected var _amount:int = 0;
      
      public var time:int = 0;
      
      public var buyNumber:int = 1;
      
      public var incar:Boolean = false;
      
      public var inbody:Boolean = false;
      
      public var buyTypeInCar:int = 0;
      
      public var isSuit:Boolean = false;
      
      protected var _typeID:int = 0;
      
      protected var _frameID:int = 0;
      
      protected var _name:String = "";
      
      protected var _quality:int = 0;
      
      protected var _qualityStr:String = "";
      
      protected var _nameColor:Number = 0;
      
      protected var _dec:String = "";
      
      public var enhance:Boolean = false;
      
      protected var _synthesis:int = 0;
      
      protected var _strengthen:int = 0;
      
      protected var _canRL:int = 0;
      
      protected var _canCZ:int = 0;
      
      protected var _canTransfer:int = 0;
      
      protected var _gender:int = 0;
      
      private var _canBuy:Boolean = true;
      
      protected var _buyType:String = "";
      
      private var _gameGold:int = 0;
      
      private var _payGold:int = 0;
      
      private var _freeGold:int = 0;
      
      protected var _proptype:int = 0;
      
      protected var _isconsum:uint = 0;
      
      private var _xinping:int = 0;
      
      private var _dazhe:int = 0;
      
      private var _mianfei:int = 0;
      
      private var _recommend:int = 0;
      
      private var _xianshi:int = 0;
      
      private var _vipGood:int = 0;
      
      protected var _color:Number = 0;
      
      protected var _priceList:Array = null;
      
      protected var _damage:int = 0;
      
      protected var _armor:int = 0;
      
      protected var _attack:int = 0;
      
      protected var _defense:int = 0;
      
      protected var _nimble:int = 0;
      
      protected var _lucky:int = 0;
      
      protected var _best:int = 0;
      
      private var _attack_high:int = 0;
      
      private var _defense_high:int = 0;
      
      private var _nimble_high:int = 0;
      
      private var _lucky_high:int = 0;
      
      private var _damage_high:int = 0;
      
      private var _armor_high:int = 0;
      
      protected var _isEquipment:Boolean = false;
      
      protected var _isWear:Boolean = false;
      
      private var _isWeapon:Boolean = false;
      
      private var _isSynthetic:Boolean = false;
      
      private var _upgradetype:String = "";
      
      public var lowerlevel:int = 0;
      
      private var _sellPlace:int = 0;
      
      private var _validperiod:int;
      
      private const DATA_TYPE:Array = ["typeID","frameID","name","buyType","upgradetype","dec","gender","quality","sellPlace"];
      
      private const DATA_XML:Array = ["pcate","pframe","pname","pstatus","upgradetype","pdec","pgender","plevel","sellplace"];
      
      public function ShopData()
      {
         super();
         _priceList = [];
         GOOGS_TITLES = [LangManager.getLang.getLangArray("goodsTitle")[0],LangManager.getLang.getLangArray("goodsTitle")[1],LangManager.getLang.getLangArray("goodsTitle")[2],LangManager.getLang.getLangArray("goodsTitle")[3],LangManager.getLang.getLangArray("goodsTitle")[4],LangManager.getLang.getLangArray("goodsTitle")[5],LangManager.getLang.getLangArray("goodsTitle")[6],LangManager.getLang.getLangArray("goodsTitle")[7],LangManager.getLang.getLangArray("goodsTitle")[8],LangManager.getLang.getLangArray("goodsTitle")[9],LangManager.getLang.getLangArray("goodsTitle")[10],LangManager.getLang.getLangArray("goodsTitle")[11],LangManager.getLang.getLangArray("goodsTitle")[12],LangManager.getLang.getLangArray("goodsTitle")[13]];
      }
      
      public function updateForData(param1:XML) : int
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < DATA_TYPE.length)
         {
            if(this["_" + DATA_TYPE[_loc2_]] is int)
            {
               this["_" + DATA_TYPE[_loc2_]] = int(param1[DATA_XML[_loc2_]]);
            }
            else
            {
               this["_" + DATA_TYPE[_loc2_]] = param1[DATA_XML[_loc2_]];
            }
            _loc2_++;
         }
         lowerlevel = int(param1["lowerlevel"]);
         if(param1.hasOwnProperty("atlist"))
         {
            updateAttributes(param1.atlist[0]);
         }
         if(param1.hasOwnProperty("pricelist"))
         {
            updatePrice(param1.pricelist[0]);
         }
         switch(int(param1["saleobj"]) - 1)
         {
            case 0:
               _recommend = 1;
               break;
            case 1:
               _xinping = 1;
               break;
            case 2:
               _dazhe = 1;
               break;
            case 3:
               _mianfei = 1;
               break;
            case 4:
               _xianshi = 1;
               break;
            case 5:
               _vipGood = 1;
               _recommend = 1;
         }
         _isconsum = int(param1["isconsum"]);
         _proptype = int(param1["proptype"]);
         if(_typeID < 15 || _typeID == 105 && (_frameID >= 6 && _frameID <= 17))
         {
            _isEquipment = true;
            if(_typeID == 11 || _typeID == 12 || _typeID == 13 || _typeID == 14)
            {
               _isWeapon = true;
            }
            else
            {
               _isWear = true;
            }
         }
         else if(_typeID == 16 || _typeID == 17 || _typeID == 18 || _typeID == 19)
         {
            _isSynthetic = true;
         }
         _strengthen = int(_upgradetype.charAt(0));
         _synthesis = int(_upgradetype.charAt(1));
         _canRL = int(_upgradetype.charAt(2));
         _canTransfer = int(_upgradetype.charAt(3));
         _canCZ = int(_upgradetype.charAt(4));
         if(_strengthen == 0 && _synthesis == 0 && _canRL == 0 && _canCZ == 0)
         {
            enhance = false;
         }
         else
         {
            enhance = true;
         }
         if(_buyType == "0100")
         {
            _buyType = "01000";
         }
         return _typeID;
      }
      
      public function getBuyType() : Boolean
      {
         var _loc1_:int = int(_buyType.charAt(1));
         return Boolean(_loc1_);
      }
      
      public function canBuyType(param1:int) : Boolean
      {
         var _loc2_:int = int(_buyType.charAt(param1 - 1));
         return Boolean(_loc2_);
      }
      
      public function canBuyInShop() : Boolean
      {
         var _loc2_:int = 0;
         var _loc1_:Boolean = false;
         _loc2_ = 0;
         while(_loc2_ < _buyType.length)
         {
            if(_buyType.charAt(_loc2_) == "1")
            {
               _loc1_ = true;
               break;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function updatePrice(param1:XML) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.attribute.length())
         {
            addPrice(param1.attribute[_loc2_]);
            _loc2_++;
         }
      }
      
      private function addPrice(param1:XML) : void
      {
         _priceList.push([int(param1["validperiod"]),int(param1["curprice"]),int(param1["exprice"]),int(param1["boyaaprice"]),int(param1["auctecoin"]),int(param1["cdevote"])]);
      }
      
      public function get validperiod() : int
      {
         if(_priceList.length != 0 && _priceList[0].length > 0)
         {
            _validperiod = _priceList[0][0];
         }
         return _validperiod;
      }
      
      public function set validperiod(param1:int) : void
      {
         _validperiod = param1;
      }
      
      public function getSellPrice(param1:int) : int
      {
         var _loc2_:int = 50;
         switch(param1 - 1)
         {
            case 0:
               _loc2_ = 50;
               break;
            case 1:
               _loc2_ = 100;
               break;
            case 2:
               _loc2_ = 200;
               break;
            case 3:
               _loc2_ = 500;
               break;
            case 4:
               _loc2_ = 1000;
         }
         return _loc2_;
      }
      
      public function getPrice(param1:int) : Array
      {
         var _loc4_:Array = null;
         var _loc2_:Array = [];
         var _loc3_:int = int(_priceList.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _priceList[_loc5_];
            if(_loc4_[param1] != 0)
            {
               _loc2_.push([_loc4_[0],_loc4_[param1]]);
            }
            _loc5_++;
         }
         if(_loc2_.length == 0)
         {
            return null;
         }
         return _loc2_;
      }
      
      public function getUnionPrice() : Array
      {
         var _loc1_:Array = [];
         var _loc3_:int = 0;
         var _loc2_:Array = _buyType.split("");
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] != "0")
            {
               return getPrice(_loc3_ + 1);
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getPriceType() : int
      {
         var _loc1_:Array = [];
         var _loc3_:int = 0;
         var _loc2_:Array = _buyType.split("");
         trace("_buyType",_buyType);
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] != "0")
            {
               return _loc3_ + 1;
            }
            _loc3_++;
         }
         return -1;
      }
      
      private function updateAttributes(param1:XML) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.attribute.length())
         {
            addAttributes(param1.attribute[_loc2_]);
            _loc2_++;
         }
      }
      
      private function addAttributes(param1:XML) : void
      {
         var _loc4_:int = int(param1["atid"]);
         var _loc3_:int = int(param1["lower_value"]);
         var _loc2_:int = int(param1["high_value"]);
         switch(_loc4_ - 101)
         {
            case 0:
               _defense = _loc3_;
               _defense_high = _loc2_;
               break;
            case 1:
               _attack = _loc3_;
               _attack_high = _loc2_;
               break;
            case 2:
               _nimble = _loc3_;
               _nimble_high = _loc2_;
               break;
            case 3:
               _lucky = _loc3_;
               _lucky_high = _loc2_;
               break;
            case 4:
               _armor = _loc3_;
               _armor_high = _loc2_;
               break;
            case 5:
               _damage = _loc3_;
               _damage_high = _loc2_;
               break;
            case 6:
               _best = _loc3_;
         }
      }
      
      public function getExtAttrText() : String
      {
         var _loc1_:String = "";
         if(this.strengthen == 1)
         {
            _loc1_ += LangManager.getLang.getLangByStr("strengthen") + "/";
         }
         if(this.canTransfer == 1)
         {
            _loc1_ += LangManager.getLang.getLangByStr("zhuanYi") + "/";
         }
         if(_loc1_.length > 1)
         {
            _loc1_ = LangManager.getLang.getLangByStr("kqhhc") + _loc1_.substr(0,_loc1_.length - 1);
         }
         return _loc1_;
      }
      
      public function getType(param1:int) : String
      {
         var _loc2_:String = LangManager.t("prop");
         switch(param1 - 1)
         {
            case 0:
            case 1:
            case 5:
            case 6:
               _loc2_ = LangManager.t("fjs1");
               break;
            case 7:
               _loc2_ = LangManager.t("pss1");
               break;
            case 10:
            case 11:
               _loc2_ = LangManager.t("wqs1");
         }
         return _loc2_;
      }
      
      public function copyShopData(param1:ShopData) : void
      {
         _typeID = param1.typeID;
         _frameID = param1.frameID;
         _name = param1.name;
         _quality = param1.quality;
         _dec = param1.dec;
         _strengthen = param1.strengthen;
         _synthesis = param1.synthesis;
         _canRL = param1.canRL;
         _canCZ = param1.canCZ;
         _canTransfer = param1.canTransfer;
         _gender = param1.gender;
         _isEquipment = param1.isEquipment;
         _priceList = param1.priceList;
         lowerlevel = param1.lowerlevel;
         enhance = param1.enhance;
         isWeapon = param1.isWeapon;
         isWear = param1.isWear;
         isSynthetic = param1.isSynthetic;
         _isconsum = param1.isconsum;
         _proptype = param1.proptype;
         _buyType = param1.buyType;
         if(_typeID == 25 && _frameID == 1)
         {
         }
         _damage = param1.damage;
         _damage_high = param1.damage_high;
         _armor = param1.armor;
         _armor_high = param1.armor_high;
         _attack = param1.attack;
         _attack_high = param1.attack_high;
         _defense = param1.defense;
         _defense_high = param1.defense_high;
         _nimble = param1.nimble;
         _nimble_high = param1.nimble_high;
         _lucky = param1.lucky;
         _lucky_high = param1.lucky_high;
      }
      
      public function get gender() : int
      {
         return _gender;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function set name(param1:String) : void
      {
         _name = param1;
      }
      
      public function get typeID() : int
      {
         return _typeID;
      }
      
      public function get frameID() : int
      {
         return _frameID;
      }
      
      public function get quality() : int
      {
         return _quality;
      }
      
      public function get damage() : int
      {
         return _damage;
      }
      
      public function get armor() : int
      {
         return _armor;
      }
      
      public function get attack() : int
      {
         return _attack;
      }
      
      public function get defense() : int
      {
         return _defense;
      }
      
      public function get nimble() : int
      {
         return _nimble;
      }
      
      public function get lucky() : int
      {
         return _lucky;
      }
      
      public function get synthesis() : int
      {
         return _synthesis;
      }
      
      public function get strengthen() : int
      {
         return _strengthen;
      }
      
      public function get canRL() : int
      {
         return _canRL;
      }
      
      public function get dec() : String
      {
         return _dec;
      }
      
      public function get attack_high() : int
      {
         return _attack_high;
      }
      
      public function get defense_high() : int
      {
         return _defense_high;
      }
      
      public function get nimble_high() : int
      {
         return _nimble_high;
      }
      
      public function get lucky_high() : int
      {
         return _lucky_high;
      }
      
      public function get canBuy() : Boolean
      {
         return _canBuy;
      }
      
      public function get priceList() : Array
      {
         return _priceList;
      }
      
      public function set priceList(param1:Array) : void
      {
         _priceList = param1;
      }
      
      public function get best() : int
      {
         return _best;
      }
      
      public function set typeID(param1:int) : void
      {
         this._typeID = param1;
      }
      
      public function set frameID(param1:int) : void
      {
         this._frameID = param1;
      }
      
      public function set dec(param1:String) : void
      {
         this._dec = param1;
      }
      
      public function set best(param1:int) : void
      {
         this._best = param1;
      }
      
      public function get isEquipment() : Boolean
      {
         return _isEquipment;
      }
      
      public function get damage_high() : int
      {
         return _damage_high;
      }
      
      public function get armor_high() : int
      {
         return _armor_high;
      }
      
      public function get amount() : int
      {
         return _amount;
      }
      
      public function get buyType() : String
      {
         return _buyType;
      }
      
      public function set buyType(param1:String) : void
      {
         _buyType = param1;
      }
      
      public function set amount(param1:int) : void
      {
         _amount = param1;
      }
      
      public function get canCZ() : int
      {
         return _canCZ;
      }
      
      public function get isconsum() : uint
      {
         return _isconsum;
      }
      
      public function set isconsum(param1:uint) : void
      {
         _isconsum = param1;
      }
      
      public function get sellPlace() : int
      {
         return _sellPlace;
      }
      
      public function get canTransfer() : int
      {
         return _canTransfer;
      }
      
      public function get recommend() : int
      {
         return _recommend;
      }
      
      public function set recommend(param1:int) : void
      {
         _recommend = param1;
      }
      
      public function get mianfei() : int
      {
         return _mianfei;
      }
      
      public function set mianfei(param1:int) : void
      {
         _mianfei = param1;
      }
      
      public function get dazhe() : int
      {
         return _dazhe;
      }
      
      public function set dazhe(param1:int) : void
      {
         _dazhe = param1;
      }
      
      public function get xinping() : int
      {
         return _xinping;
      }
      
      public function set xinping(param1:int) : void
      {
         _xinping = param1;
      }
      
      public function get isWeapon() : Boolean
      {
         return _isWeapon;
      }
      
      public function set isWeapon(param1:Boolean) : void
      {
         _isWeapon = param1;
      }
      
      public function get isSynthetic() : Boolean
      {
         return _isSynthetic;
      }
      
      public function get color() : Number
      {
         return _color;
      }
      
      public function set color(param1:Number) : void
      {
         _color = param1;
      }
      
      public function get xianshi() : int
      {
         return _xianshi;
      }
      
      public function set xianshi(param1:int) : void
      {
         _xianshi = param1;
      }
      
      public function set isSynthetic(param1:Boolean) : void
      {
         _isSynthetic = param1;
      }
      
      public function get proptype() : int
      {
         return _proptype;
      }
      
      public function get isWear() : Boolean
      {
         return _isWear;
      }
      
      public function set isWear(param1:Boolean) : void
      {
         _isWear = param1;
      }
      
      public function get qualityStr() : String
      {
         if(_qualityStr == "")
         {
            switch(quality - 1)
            {
               case 0:
                  _qualityStr = "普通";
                  break;
               case 1:
                  _qualityStr = "精良";
                  break;
               case 2:
                  _qualityStr = "卓越";
                  break;
               case 3:
                  _qualityStr = "史诗";
                  break;
               case 4:
                  _qualityStr = "传说";
                  break;
               default:
                  _qualityStr = "普通";
            }
         }
         return _qualityStr;
      }
      
      public function get nameColor() : Number
      {
         if(_nameColor == 0)
         {
            switch(quality - 1)
            {
               case 0:
                  _nameColor = 948992;
                  break;
               case 1:
                  _nameColor = 26788;
                  break;
               case 2:
                  _nameColor = 12000001;
                  break;
               case 3:
                  _nameColor = 11018621;
                  break;
               case 4:
                  _nameColor = 11018621;
                  break;
               default:
                  _nameColor = 948992;
            }
         }
         return _nameColor;
      }
      
      public function get vipGood() : int
      {
         return _vipGood;
      }
   }
}

