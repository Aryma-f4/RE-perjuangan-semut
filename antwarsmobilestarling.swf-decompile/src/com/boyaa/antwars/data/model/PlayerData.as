package com.boyaa.antwars.data.model
{
   import com.boyaa.antwars.data.BaseValues;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.fresh.FreshGifts;
   import com.boyaa.antwars.view.screen.fresh.LevelUp;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   
   public class PlayerData
   {
      
      public var delay:int = 0;
      
      public var siteID:uint = 0;
      
      public var name:String = "";
      
      private var _sex:int = 0;
      
      public var uid:uint = 0;
      
      public var ready:int = 0;
      
      public var houseOwner:int = 0;
      
      public var team:int = 0;
      
      public var babyName:String = "";
      
      public var img:String = "";
      
      public var babySex:int = 0;
      
      public var win:int = 0;
      
      public var fail:int = 0;
      
      public var runaway:int = 0;
      
      public var kill:int = 0;
      
      private var _energy:int = 60;
      
      public var appearence:String = "1|1|1|1";
      
      private var _exp:int = 0;
      
      private var _propArr:Array = null;
      
      private var _level:int = 0;
      
      private var _abilityArr:Array = [100,100,100,100,100,100,100,1001,100];
      
      private var _ranking:int = 0;
      
      public var age:int = 0;
      
      public var born:String = "xxxx-xx-xx";
      
      public var reside:String = "------";
      
      public var online:int = 0;
      
      public var home:String = "";
      
      public var webSid:String = "";
      
      public var hasSkill:Array = [];
      
      public var hasSuit:Array = [];
      
      public var state:int = 0;
      
      public var checkIsSafe:int = 0;
      
      public var vip:int = 0;
      
      public var yearVip:int = 0;
      
      public var cid:int = 0;
      
      public var cname:String = "";
      
      public var mdevote:int = 0;
      
      public var mhonour:int = 0;
      
      public var position:int = 0;
      
      public var isrobot:Boolean = false;
      
      private var _familiarity:int = 0;
      
      public var partnerID:int = 0;
      
      public var marryTime:int = 0;
      
      public var marryType:int = 0;
      
      private var _marryState:int = 3;
      
      private var _marryTitle:String = "";
      
      public var bulletNum:int = 0;
      
      public var hitNum:int = 0;
      
      public var hitProbability:Number = 0;
      
      public var isLoserComeback:Boolean = false;
      
      private var _firstAdd:Boolean = true;
      
      public var missCount:int = 0;
      
      public var readProp:Boolean = false;
      
      private const infoArr:Array = ["name","sex","babyName","babySex","img","runaway","kill","appearence","fail","win","ranking","age","born","reside","home","webSid"];
      
      public var ranktotalAblility:int = 0;
      
      public var isfreshpack:int = 0;
      
      public var isFreshGuide:Boolean = false;
      
      public var isAdult:Boolean = false;
      
      public var updateSignal:Signal;
      
      private var _isSigned:Boolean = false;
      
      public var signedSiganal:Signal;
      
      private var _signData:Array = [];
      
      public var invitedNum:int = 0;
      
      public var _inFight:Boolean = false;
      
      private var _endlessHighLevel:int = 0;
      
      private var _endlessFightTime:int = 0;
      
      private var _vipLevel:int = 0;
      
      private var _leaving:Boolean = false;
      
      private var tipStr:String;
      
      public function PlayerData()
      {
         super();
         updateSignal = new Signal();
         signedSiganal = new Signal();
      }
      
      public function get inFight() : Boolean
      {
         return _inFight;
      }
      
      public function set inFight(param1:Boolean) : void
      {
         _inFight = param1;
         if(_inFight == false)
         {
            GoodsList.instance.removeOvertimeRentalEquip();
         }
      }
      
      public function ability() : Array
      {
         var _loc1_:Array = [];
         if(uid == PlayerDataList.instance.selfData.uid)
         {
            _loc1_ = GoodsList.instance.getAttribute();
         }
         else
         {
            _loc1_ = GoodsList.instance.getAttribute(_propArr);
         }
         var _loc2_:int = int(_loc1_[6]);
         hasSkill = _loc1_[7];
         hasSuit = _loc1_[8];
         _loc1_[6] = BaseValues.getBloodVolume(level);
         _loc1_[6] += int(_loc1_[6] * _loc1_[9] / 100);
         _loc1_[6] += int(_loc1_[1]);
         _loc1_[7] = 240 + int(_loc1_[2] / 20);
         _loc1_[8] = _loc2_;
         _abilityArr = _loc1_.concat();
         missCount = 0;
         return _loc1_;
      }
      
      public function toString() : String
      {
         var _loc2_:int = 0;
         var _loc3_:String = "";
         var _loc1_:Object = {};
         _loc2_ = 0;
         while(_loc2_ < infoArr.length)
         {
            _loc1_[infoArr[_loc2_]] = this[infoArr[_loc2_]];
            _loc2_++;
         }
         return JSON.stringify(_loc1_) as String;
      }
      
      public function getWeapon() : GoodsData
      {
         var _loc3_:int = 0;
         var _loc2_:GoodsData = null;
         var _loc1_:Array = getPropData();
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc2_ = _loc1_[_loc3_];
            if(_loc2_.isWeapon)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getPropData() : Array
      {
         if(uid == PlayerDataList.instance.selfData.uid)
         {
            return GoodsList.instance.getEquipment(1);
         }
         return _propArr;
      }
      
      public function addInfo(param1:String) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Object = JSON.parse(param1) as Object;
         _loc3_ = 0;
         while(_loc3_ < infoArr.length)
         {
            if(_loc2_[infoArr[_loc3_]])
            {
               this[infoArr[_loc3_]] = _loc2_[infoArr[_loc3_]];
            }
            _loc3_++;
         }
      }
      
      public function addOtherInfo(param1:Object) : void
      {
         this.babySex = param1["mgender"];
         this.babyName = param1["mrolename"];
         this.runaway = param1["mflee"];
         this.kill = param1["mkill"];
         this.appearence = param1["appearance"];
         this.fail = param1["mfailure"];
         this.win = param1["mwinning"];
         this.exp = param1["mpoint"];
         this.level = param1["mlevel"];
         this.uid = param1["mid"];
      }
      
      public function addPropInfo(param1:String) : Array
      {
         var _loc5_:int = 0;
         var _loc3_:GoodsData = null;
         trace("道具信息：" + param1);
         if(param1 == "")
         {
            return null;
         }
         var _loc4_:Array = [];
         _propArr = [];
         var _loc2_:Array = JSON.parse(param1) as Array;
         _loc5_ = 0;
         while(_loc5_ < _loc2_[1].length)
         {
            _loc3_ = new GoodsData();
            _loc3_.updateGoodsInfo(_loc2_[1][_loc5_]);
            _loc3_.place = 1;
            _propArr.push(_loc3_);
            _loc4_.push(_loc3_);
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function addOtherPropInfo(param1:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc2_:GoodsData = null;
         trace("道具信息：" + param1);
         var _loc3_:Array = [];
         _propArr = [];
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_])
            {
               _loc2_ = new GoodsData();
               _loc2_.updateGoodsInfo(param1[_loc4_]);
               _loc2_.place = 1;
               _propArr.push(_loc2_);
               _loc3_.push(_loc2_);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function setAboloty(param1:Array) : void
      {
         _abilityArr = param1;
      }
      
      public function get level() : int
      {
         return BaseValues.getLevel(exp);
      }
      
      public function set level(param1:int) : void
      {
         _level = param1;
      }
      
      public function get exp() : int
      {
         return _exp;
      }
      
      public function set exp(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(_exp != 0)
         {
            _loc2_ = this.level;
            _exp = param1;
            _loc3_ = this.level;
            if(_loc3_ > _loc2_ && uid == PlayerDataList.instance.selfData.uid)
            {
               levelUp(_loc3_);
            }
         }
         else
         {
            _exp = param1;
         }
         updateSignal.dispatch();
      }
      
      private function levelUp(param1:int) : void
      {
         var _loc2_:LevelUp = new LevelUp(param1);
         Starling.current.stage.addChild(_loc2_);
         _loc2_.x = 1365 - _loc2_.width >> 1;
         _loc2_.y = 768 - _loc2_.height >> 1;
         switch(param1 - 3)
         {
            case 0:
               tipStr = LangManager.t("guide3") + "X2";
               Starling.juggler.delayCall(showGift,3);
               break;
            case 2:
               tipStr = LangManager.t("guide3") + "X3";
               Starling.juggler.delayCall(showGift,3);
               break;
            case 5:
               tipStr = LangManager.t("guide3") + "X4";
               Starling.juggler.delayCall(showGift,3);
               break;
            case 7:
               tipStr = LangManager.t("guide3") + "X5";
               Starling.juggler.delayCall(showGift,3);
         }
      }
      
      private function showGift() : void
      {
         var _loc1_:FreshGifts = new FreshGifts(level);
         Starling.current.stage.addChild(_loc1_);
         _loc1_.x = 1365 - _loc1_.width >> 1;
         _loc1_.y = 768 - _loc1_.height >> 1;
         Starling.juggler.delayCall(showTip,3);
      }
      
      private function showTip() : void
      {
         TextTip.instance.show(tipStr);
      }
      
      public function get totalAblility() : int
      {
         ability();
         var _loc2_:Number = (_abilityArr[6] - _abilityArr[1]) / 1500;
         var _loc1_:Number = ((_abilityArr[0] + _abilityArr[3] + _abilityArr[1] + _abilityArr[2]) / 2400 + 1) * (_abilityArr[4] + _abilityArr[5] * 1.5);
         return _loc2_ * _loc1_ * _loc1_ / 360;
      }
      
      public function get HP() : int
      {
         ability();
         return _abilityArr[6];
      }
      
      public function get energy() : int
      {
         return _energy;
      }
      
      public function set energy(param1:int) : void
      {
         _energy = param1;
      }
      
      public function get abilityArr() : Array
      {
         return ability();
      }
      
      public function addData(param1:Array) : void
      {
         uid = param1[0];
         name = param1[1];
         sex = param1[2];
         img = param1[3];
         babyName = param1[4];
         babySex = param1[5];
         appearence = param1[6];
         if(appearence == "")
         {
            appearence = "1|1|1|1";
         }
         exp = param1[7];
         win = param1[8];
         fail = param1[9];
         runaway = param1[10];
         online = param1[11];
         var _loc2_:Date = new Date();
         _loc2_.setTime(param1[12] * 1000);
         born = "" + _loc2_.fullYear + "-" + (_loc2_.month + 1) + "-" + _loc2_.date;
         age = PlayerDataList.instance.now.fullYear - _loc2_.fullYear;
         reside = param1[13];
         webSid = String(param1[14]);
         if(!(param1[16] is int) && Boolean(Object(param1[16]).hasOwnProperty("cid")))
         {
            cid = param1[16].cid;
            cname = param1[16].cname;
            mdevote = param1[16].mdevote;
            mhonour = param1[16].mhonour;
            position = param1[16].position;
         }
         else
         {
            cid = param1[15].cid;
            cname = param1[15].cname;
         }
         if(cname == null)
         {
            cname = "";
         }
      }
      
      public function get isSigned() : Boolean
      {
         return _isSigned;
      }
      
      public function set isSigned(param1:Boolean) : void
      {
         _isSigned = param1;
      }
      
      public function get signData() : Array
      {
         return _signData;
      }
      
      public function set signData(param1:Array) : void
      {
         var _loc2_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc3_:String = null;
         _signData = param1;
         trace("_signData:" + _signData);
         if(_signData.length > 0)
         {
            _loc2_ = Number(_signData[1]);
            _loc4_ = Number(_signData[2]);
            _loc3_ = _signData[0];
            if(_loc2_ == _loc4_)
            {
               isSigned = true;
               signedSiganal.dispatch();
            }
            else
            {
               isSigned = false;
            }
         }
      }
      
      public function get endlessHighLevel() : int
      {
         return _endlessHighLevel;
      }
      
      public function set endlessHighLevel(param1:int) : void
      {
         _endlessHighLevel = param1;
      }
      
      public function get endlessFightTime() : int
      {
         return _endlessFightTime;
      }
      
      public function set endlessFightTime(param1:int) : void
      {
         _endlessFightTime = param1;
      }
      
      public function get marryState() : int
      {
         return _marryState;
      }
      
      public function set marryState(param1:int) : void
      {
         _marryState = param1;
         if(_marryState == 1)
         {
            MissionManager.instance.updateMissionData(149);
            MissionManager.instance.updateMissionData(148);
         }
         if(_marryState == 2)
         {
            MissionManager.instance.updateMissionData(149);
         }
      }
      
      public function get sex() : int
      {
         return _sex;
      }
      
      public function set sex(param1:int) : void
      {
         _sex = param1;
      }
      
      public function get vipLevel() : int
      {
         return _vipLevel;
      }
      
      public function set vipLevel(param1:int) : void
      {
         _vipLevel = param1;
      }
      
      public function get leaving() : Boolean
      {
         return _leaving;
      }
      
      public function set leaving(param1:Boolean) : void
      {
         _leaving = param1;
      }
      
      public function get ranking() : int
      {
         return _ranking;
      }
      
      public function set ranking(param1:int) : void
      {
         _ranking = param1;
      }
      
      public function clearMarryState() : void
      {
         PlayerDataList.instance.selfData.marryState = 3;
         PlayerDataList.instance.selfData.partnerID = 0;
      }
   }
}

