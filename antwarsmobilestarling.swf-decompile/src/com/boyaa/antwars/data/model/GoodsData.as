package com.boyaa.antwars.data.model
{
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.lang.LangManager;
   
   public class GoodsData extends ShopData
   {
      
      public static const strengthenTable:Array = [10,50,200,600,1200,2500,4000,6000,9000,12500,18000,24000];
      
      public static const shiftBoyaaCurrencyTable:Array = [20,50,80,120,600,1200,2400,4000,10000,18000,27000,38000];
      
      public static const shiftPTable:Array = [100,100,100,100,50,40,30,20,10,5,5,5];
      
      private var _onlyID:int = 0;
      
      private var _stutas:int = 0;
      
      public var position:int = 0;
      
      private var _attribute:String = "";
      
      private var _synthesisLevel:String = "";
      
      private var _strengthenNum:int = 0;
      
      private var _expiration:uint = 0;
      
      private var _place:int = 0;
      
      private var _attackLevel:int = 0;
      
      private var _defenseLevel:int = 0;
      
      private var _nimbleLevel:int = 0;
      
      private var _damageLevel:int = 0;
      
      private var _luckyLevel:int = 0;
      
      private var _armorLevel:int = 0;
      
      private var _bestLevel:int = 0;
      
      public var placeDec:String = "";
      
      private var _isbind:int = 0;
      
      public var inAtt:Boolean = false;
      
      private var _termofvalidity:uint = 0;
      
      private var _strengthenExp:uint = 0;
      
      private const DATA_TYPE:Array = ["onlyID","typeID","frameID","stutas","attribute","synthesisLevel","expiration","strengthenExp","place","termofvalidity","amount","isbind","color"];
      
      private const ATTRIBUTE_TYPE:Array = ["attack","defense","nimble","damage","lucky","armor","best"];
      
      private const SYNTHESIS_TYPE:Array = ["attackLevel","defenseLevel","nimbleLevel","damageLevel","luckyLevel","armorLevel","bestLevel"];
      
      private var _owner:int;
      
      private var _rentStatus:int;
      
      private var _rental_period:int;
      
      private var _rental_price:int;
      
      private var _unionid:int;
      
      private var _expire_time:int;
      
      private var _rental_mppid:int;
      
      public function GoodsData()
      {
         super();
      }
      
      public function isRentFromOther(param1:int) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:Array = GoodsList.instance.rentArr;
         var _loc3_:int = int(_loc2_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_[_loc4_] == param1)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function get rental_mppid() : int
      {
         return _rental_mppid;
      }
      
      public function set rental_mppid(param1:int) : void
      {
         _rental_mppid = param1;
      }
      
      public function get unionid() : int
      {
         return _unionid;
      }
      
      public function set unionid(param1:int) : void
      {
         _unionid = param1;
      }
      
      public function get rental_period() : int
      {
         return _rental_period;
      }
      
      public function set rental_period(param1:int) : void
      {
         _rental_period = param1;
      }
      
      public function get expire_time() : int
      {
         return _expire_time;
      }
      
      public function set expire_time(param1:int) : void
      {
         _expire_time = param1;
      }
      
      public function get rentStatus() : int
      {
         return _rentStatus;
      }
      
      public function set rentStatus(param1:int) : void
      {
         _rentStatus = param1;
      }
      
      public function get rental_price() : int
      {
         return _rental_price;
      }
      
      public function set rental_price(param1:int) : void
      {
         _rental_price = param1;
      }
      
      public function get lefttime() : int
      {
         return _expiration;
      }
      
      public function iconID() : int
      {
         if(strengthenNum < 9)
         {
            return 1;
         }
         if(strengthenNum == 9)
         {
            return 2;
         }
         return 3;
      }
      
      public function addOtherProperty(param1:Object) : void
      {
         _owner = param1.from_mid;
         _rentStatus = param1.flag;
         _rental_period = param1.rental_period;
         _expire_time = param1.expire_time;
         _rental_mppid = param1.rental_mppid;
         _rental_price = param1.rental_price;
         _unionid = param1.unionid;
      }
      
      public function updateGoodsInfo(param1:Array) : void
      {
         _onlyID = param1[0];
         _typeID = param1[1];
         _frameID = param1[2];
         _stutas = param1[3];
         resolveAttribute(param1[4]);
         resolveSynthesis(param1[5]);
         _expiration = param1[6];
         _strengthenExp = param1[7];
         position = param1[8];
         _termofvalidity = param1[9];
         _amount = param1[10];
         _isbind = param1[11];
         if(param1.length > 12)
         {
            color = Number(param1[12]);
         }
         else
         {
            color = 0;
         }
         getShopData();
      }
      
      public function updateGoodsInfoC(param1:Object) : void
      {
         _onlyID = param1.mppid;
         _typeID = param1.pcate;
         _frameID = param1.pframe;
         _stutas = param1.mppstatus;
         resolveAttribute(param1.mpaddvalue);
         resolveSynthesis(param1.mpbasevalue);
         _expiration = param1.mpplaytime;
         if(param1.color == null)
         {
            _color = 0;
         }
         else
         {
            _color = Number(param1.color);
         }
         position = param1.position;
         _termofvalidity = param1.validperiod;
         _amount = param1.quantity;
         _isbind = param1.isbind;
         getShopData();
      }
      
      public function copyData(param1:GoodsData) : void
      {
         _onlyID = param1.onlyID;
         _typeID = param1.typeID;
         _frameID = param1.frameID;
         _stutas = param1.stutas;
         _rental_period = param1.rental_period;
         _rental_price = param1.rental_price;
         _owner = param1.owner;
         _unionid = param1.unionid;
         _rental_mppid = param1.rental_mppid;
         enhance = param1.enhance;
         color = param1.color;
         _place = param1.place;
         _termofvalidity = param1.termofvalidity;
         _amount = param1.amount;
         _isbind = param1.isbind;
         isSuit = param1.isSuit;
         getShopData();
         resolveAttribute(param1._attribute);
         resolveSynthesis(param1._synthesisLevel);
      }
      
      public function getShopData() : void
      {
         var _loc1_:ShopData = ShopDataList.instance.getSingleData(_typeID,_frameID);
         _name = _loc1_.name;
         _quality = _loc1_.quality;
         _dec = _loc1_.dec;
         _strengthen = _loc1_.strengthen;
         _synthesis = _loc1_.synthesis;
         _canRL = _loc1_.canRL;
         _canCZ = _loc1_.canCZ;
         _canTransfer = _loc1_.canTransfer;
         _gender = _loc1_.gender;
         _isEquipment = _loc1_.isEquipment;
         _priceList = _loc1_.priceList;
         lowerlevel = _loc1_.lowerlevel;
         enhance = _loc1_.enhance;
         isWeapon = _loc1_.isWeapon;
         isWear = _loc1_.isWear;
         isSynthetic = _loc1_.isSynthetic;
         _isconsum = _loc1_.isconsum;
         _proptype = _loc1_.proptype;
         _buyType = _loc1_.buyType;
         if(_typeID == 25 && _frameID == 1)
         {
         }
      }
      
      public function resolveSynthesis(param1:String) : void
      {
         var _loc3_:int = 0;
         _synthesisLevel = param1;
         var _loc2_:Array = param1.split("|") as Array;
         _loc3_ = 0;
         while(_loc3_ < SYNTHESIS_TYPE.length)
         {
            this["_" + SYNTHESIS_TYPE[_loc3_]] = _loc2_[_loc3_];
            _loc3_++;
         }
         if(_damageLevel > 0)
         {
            _strengthenNum = _damageLevel;
         }
         else if(_armorLevel > 0)
         {
            _strengthenNum = _armorLevel;
         }
         else
         {
            _strengthenNum = 0;
         }
      }
      
      public function resolveAttribute(param1:String) : void
      {
         var _loc3_:int = 0;
         _attribute = param1;
         var _loc2_:Array = param1.split("|") as Array;
         _loc3_ = 0;
         while(_loc3_ < ATTRIBUTE_TYPE.length)
         {
            this["_" + ATTRIBUTE_TYPE[_loc3_]] = _loc2_[_loc3_];
            _loc3_++;
         }
      }
      
      public function max_synthesis() : int
      {
         var _loc1_:Array = [_nimbleLevel,_attackLevel,_defenseLevel,_luckyLevel];
         _loc1_.sort(0x10 | 2);
         return _loc1_[0];
      }
      
      public function get annexDamage() : int
      {
         if(_strengthenNum == 0)
         {
            return 0;
         }
         var _loc1_:Number = Math.pow(1.1,_strengthenNum);
         return _loc1_ * _damage - _damage;
      }
      
      public function get annexArmor() : int
      {
         if(_strengthenNum == 0)
         {
            return 0;
         }
         var _loc1_:Number = Math.pow(1.1,_strengthenNum);
         return _loc1_ * _armor - _armor;
      }
      
      public function get strengthenNum() : int
      {
         return _strengthenNum;
      }
      
      public function get attackLevel() : int
      {
         return _attackLevel;
      }
      
      public function get defenseLevel() : int
      {
         return _defenseLevel;
      }
      
      public function get nimbleLevel() : int
      {
         return _nimbleLevel;
      }
      
      public function get luckyLevel() : int
      {
         return _luckyLevel;
      }
      
      public function get onlyID() : int
      {
         return _onlyID;
      }
      
      public function get place() : int
      {
         return _place;
      }
      
      public function set place(param1:int) : void
      {
         _place = param1;
      }
      
      public function get stutas() : int
      {
         return _stutas;
      }
      
      public function set stutas(param1:int) : void
      {
         _stutas = param1;
      }
      
      public function set isbind(param1:int) : void
      {
         _isbind = param1;
      }
      
      public function get isbind() : int
      {
         return _isbind;
      }
      
      public function get expiration() : String
      {
         var _loc1_:int = 0;
         if(_stutas == 0)
         {
            return LangManager.getLang.getLangByStr("ygq");
         }
         if(_stutas == 1 || _stutas == 3 || _stutas == 4)
         {
            if(_termofvalidity == 0)
            {
               return LangManager.getLang.getLangByStr("yjyx");
            }
            return LangManager.getLang.getLangByStr("hsy") + _termofvalidity + LangManager.getLang.getLangByStr("day");
         }
         if(_termofvalidity == 0)
         {
            return LangManager.getLang.getLangByStr("yjyx");
         }
         _loc1_ = _expiration - PlayerDataList.instance.now.getTime() / 1000;
         if(_loc1_ < 0)
         {
            _stutas = 0;
            return LangManager.getLang.getLangByStr("ygq");
         }
         return LangManager.getLang.getLangByStr("hsy") + int(_loc1_ / 86400) + LangManager.getLang.getLangByStr("day");
      }
      
      public function get owner() : int
      {
         return _owner;
      }
      
      public function set owner(param1:int) : void
      {
         _owner = param1;
      }
      
      public function get termofvalidity() : uint
      {
         return _termofvalidity;
      }
      
      public function set onlyID(param1:int) : void
      {
         _onlyID = param1;
      }
      
      public function get strengthenExp() : uint
      {
         return _strengthenExp;
      }
      
      public function set strengthenExp(param1:uint) : void
      {
         _strengthenExp = param1;
      }
      
      public function nextStrengthenExp() : uint
      {
         if(_strengthenNum < 12)
         {
            return strengthenTable[_strengthenNum];
         }
         return 0;
      }
      
      public function getShiftBoyaaCoin() : int
      {
         if(_strengthenNum == 0)
         {
            return 0;
         }
         return shiftBoyaaCurrencyTable[_strengthenNum - 1];
      }
      
      public function getShiftProbability() : int
      {
         if(_strengthenNum == 0)
         {
            return 100;
         }
         return shiftPTable[_strengthenNum - 1];
      }
      
      public function toString() : String
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < DATA_TYPE.length)
         {
            if(_loc2_ == DATA_TYPE.length - 1)
            {
               _loc1_ += 1;
            }
            else
            {
               _loc1_ += this["_" + DATA_TYPE[_loc2_]];
            }
            if(_loc2_ != DATA_TYPE.length - 1)
            {
               _loc1_ += ",";
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getPosName() : String
      {
         var _loc1_:String = "";
         switch(this.typeID - 1)
         {
            case 0:
               _loc1_ = "coat";
               break;
            case 1:
               _loc1_ = "shoes";
               break;
            case 3:
               _loc1_ = "weddingRing";
               break;
            case 4:
               _loc1_ = "necklace";
               break;
            case 5:
               _loc1_ = "hat";
               break;
            case 6:
               _loc1_ = "glove";
               break;
            case 7:
               _loc1_ = "wing";
               break;
            case 10:
               _loc1_ = "weapon";
         }
         return _loc1_;
      }
   }
}

