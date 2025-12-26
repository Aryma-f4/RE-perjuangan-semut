package com.boyaa.tool
{
   public class TimeUtil
   {
      
      public function TimeUtil()
      {
         super();
      }
      
      public static function timestampToDateString(param1:int) : String
      {
         var _loc6_:Date = new Date();
         _loc6_.setTime(param1 * 1000);
         var _loc5_:String = String(_loc6_.getFullYear());
         var _loc4_:String = (_loc6_.getMonth() + 1 < 10 ? "0" : "") + (_loc6_.getMonth() + 1);
         var _loc3_:String = (_loc6_.getDate() < 10 ? "0" : "") + _loc6_.getDate();
         var _loc2_:String = "";
         _loc2_ += _loc5_ + "/" + _loc4_ + "/" + _loc3_ + " ";
         _loc2_ += (_loc6_.getHours() < 10 ? "0" : "") + _loc6_.getHours();
         return _loc2_ + ((_loc6_.getMinutes() < 10 ? ":0" : ":") + _loc6_.getMinutes());
      }
   }
}

