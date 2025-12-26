package com.boyaa.antwars.helper
{
   import com.boyaa.antwars.lang.LangManager;
   
   public class AnalysisPHPTimeData
   {
      
      public function AnalysisPHPTimeData()
      {
         super();
      }
      
      public static function getDataFromString(param1:String) : Number
      {
         var _loc2_:Number = NaN;
         var _loc4_:Array = param1.split("-");
         var _loc5_:String = _loc4_.join("/");
         var _loc3_:Date = new Date(_loc5_);
         switch(Constants.lanVersion - 3)
         {
            case 0:
               _loc2_ = _loc3_.getTime() - 3600000;
               break;
            default:
               _loc2_ = Number(_loc3_.getTime());
         }
         return _loc2_;
      }
      
      public static function getDataString(param1:String, param2:Number) : String
      {
         var _loc4_:Date = new Date();
         _loc4_.setTime(param2 * 1000);
         var _loc3_:String = "";
         return _loc4_.getFullYear() + param1 + (String(_loc4_.getMonth() + 1 + 100)).substr(1) + param1 + (String(_loc4_.getDate() + 100)).substr(1) + " " + (String(_loc4_.getHours() + 100)).substr(1) + ":" + (String(_loc4_.getMinutes() + 100)).substr(1);
      }
      
      public static function getDaySecString(param1:Number, param2:Number) : Array
      {
         var _loc3_:int = param2 - param1;
         var _loc5_:int = _loc3_ / 86400;
         var _loc7_:int = (_loc3_ - _loc5_ * 24 * 3600) / 3600;
         var _loc6_:int = (_loc3_ - _loc5_ * 24 * 3600 - _loc7_ * 3600) / 60;
         var _loc4_:int = _loc3_ - _loc5_ * 24 * 3600 - _loc7_ * 3600 - _loc6_ * 60;
         return [_loc5_ + "",_loc7_ + "",_loc6_ + "",_loc4_ + ""];
      }
      
      public static function getAllDataString(param1:String, param2:Number) : String
      {
         var _loc4_:Date = new Date();
         _loc4_.setTime(param2 * 1000);
         var _loc3_:String = "";
         if(_loc4_.minutes < 10)
         {
            _loc3_ = _loc4_.hours + ":0" + _loc4_.minutes;
         }
         else
         {
            _loc3_ = _loc4_.hours + ":" + _loc4_.minutes;
         }
         return _loc3_;
      }
      
      public static function getYear(param1:Number) : String
      {
         var _loc2_:Date = new Date();
         _loc2_.setTime(param1 * 1000);
         return _loc2_.fullYear + "";
      }
      
      public static function getMonth(param1:Number) : String
      {
         var _loc2_:Date = new Date();
         _loc2_.setTime(param1 * 1000);
         return _loc2_.month + 1 + "";
      }
      
      public static function getDate(param1:Number) : String
      {
         var _loc2_:Date = new Date();
         _loc2_.setTime(param1 * 1000);
         return _loc2_.date + "";
      }
      
      public static function getHour(param1:Number) : String
      {
         var _loc2_:Date = new Date();
         _loc2_.setTime(param1 * 1000);
         return _loc2_.hours + "";
      }
      
      public static function getMinute(param1:Number) : String
      {
         var _loc2_:Date = new Date();
         _loc2_.setTime(param1 * 1000);
         return _loc2_.minutes + "";
      }
      
      public static function getSecond(param1:Number) : String
      {
         var _loc2_:Date = new Date();
         _loc2_.setTime(param1 * 1000);
         return _loc2_.seconds + "";
      }
      
      public static function dayDefference(param1:Number, param2:Number) : Number
      {
         return int((param2 - param1) / 86400);
      }
      
      public static function hourDefference(param1:Number, param2:Number) : Number
      {
         return int((param2 - param1) / 3600);
      }
      
      public static function minuteDefference(param1:Number, param2:Number) : Number
      {
         return int((param2 - param1) / 60);
      }
      
      public static function secondsDefference(param1:Number, param2:Number) : Number
      {
         return int(param2 - param1);
      }
      
      public static function timedifference(param1:Number, param2:Number) : Number
      {
         var _loc10_:Number = 0;
         var _loc8_:Date = new Date();
         _loc8_.setTime(param1 * 1000);
         var _loc3_:Date = new Date();
         _loc3_.setTime(param2 * 1000);
         var _loc6_:Number = _loc8_.month + 1;
         var _loc5_:Number = _loc8_.date;
         var _loc7_:Number = _loc3_.month + 1;
         var _loc13_:Number = _loc3_.fullYear;
         var _loc4_:Number = _loc3_.date;
         var _loc11_:Number = 0;
         if(_loc13_ % 4 == 0 && _loc13_ % 100 != 0 || _loc13_ % 400 == 0)
         {
            if(_loc7_ > 2 && _loc6_ <= 2)
            {
               _loc11_ -= 1;
            }
         }
         else if(_loc7_ > 2 && _loc6_ <= 2)
         {
            _loc11_ -= 2;
         }
         if(_loc6_ < _loc7_)
         {
            switch(_loc6_)
            {
               case 1:
               case 3:
               case 5:
               case 7:
               case 8:
               case 10:
               case 12:
                  _loc11_ += 1;
            }
         }
         if(_loc6_ > _loc7_)
         {
            _loc7_ += 12;
         }
         var _loc9_:Number = _loc7_ - _loc6_;
         var _loc12_:Number = _loc4_ - _loc5_;
         return _loc9_ * 30 + _loc12_ + _loc11_;
      }
      
      public static function bettwenThisTime(param1:Number, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:Boolean = true;
         if(hourDefference(param1,param3) < 0)
         {
            _loc4_ = false;
         }
         else if(hourDefference(param3,param2) < 0)
         {
            _loc4_ = false;
         }
         return _loc4_;
      }
      
      public static function getOfflineTime(param1:Number, param2:Number) : String
      {
         var _loc5_:int = Math.ceil(param1 / 3600);
         var _loc4_:int = Math.ceil(param2 / 1000 / 3600);
         var _loc3_:int = Math.abs(_loc4_ - _loc5_);
         if(_loc3_ < 24)
         {
            return _loc3_ + LangManager.getLang.getLangByStr("hour");
         }
         if(_loc3_ > 24 && _loc3_ < 168)
         {
            return Math.ceil(_loc3_ / 24) + LangManager.getLang.getLangByStr("day");
         }
         if(_loc3_ > 168 && _loc3_ < 720)
         {
            return Math.ceil(_loc3_ / 168) + LangManager.getLang.getLangByStr("week");
         }
         if(_loc3_ > 720 && _loc3_ < 4320)
         {
            return Math.ceil(_loc3_ / 720) + LangManager.getLang.getLangByStr("month");
         }
         if(_loc3_ > 4320)
         {
            return LangManager.getLang.getLangByStr("forlong");
         }
         return "";
      }
   }
}

