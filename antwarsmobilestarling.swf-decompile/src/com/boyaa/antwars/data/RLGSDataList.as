package com.boyaa.antwars.data
{
   import com.boyaa.antwars.data.model.RLGSData;
   
   public class RLGSDataList
   {
      
      private static var _instance:RLGSDataList = null;
      
      private var _rlgsDataArr:Array = [];
      
      public function RLGSDataList(param1:Single)
      {
         super();
      }
      
      public static function get instance() : RLGSDataList
      {
         if(_instance == null)
         {
            _instance = new RLGSDataList(new Single());
         }
         return _instance;
      }
      
      public function getCanRLGoodByXml(param1:XML) : void
      {
         var _loc6_:int = 0;
         var _loc3_:XML = null;
         var _loc2_:Array = null;
         var _loc5_:int = 0;
         var _loc4_:XML = null;
         _rlgsDataArr = [];
         _loc6_ = 0;
         while(_loc6_ < param1.smelt.length())
         {
            _loc3_ = param1.smelt[_loc6_];
            _loc2_ = [];
            _loc5_ = 0;
            while(_loc5_ < _loc3_.s.length())
            {
               _loc4_ = _loc3_.s[_loc5_];
               _loc2_[_loc5_] = new RLGSData(_loc4_["str"],_loc4_["spcate"],_loc4_["spframe"]);
               _loc5_++;
            }
            _rlgsDataArr[_loc3_["formulapframe"]] = _loc2_;
            _loc6_++;
         }
      }
      
      public function matchRL(param1:int, param2:int, param3:int) : Array
      {
         var _loc8_:int = 0;
         var _loc6_:RLGSData = null;
         var _loc5_:Array = null;
         var _loc7_:Array = _rlgsDataArr[param3];
         if(_loc7_ == null)
         {
            return null;
         }
         var _loc4_:String = param1 + "," + param2;
         _loc8_ = 0;
         while(_loc8_ < _loc7_.length)
         {
            _loc6_ = _loc7_[_loc8_];
            _loc5_ = _loc6_._str.split("|");
            if(_loc5_[0] == _loc4_)
            {
               return [_loc6_._spcate,_loc6_._spframe];
            }
            _loc8_++;
         }
         return null;
      }
      
      public function matchsuit(param1:int, param2:int) : Array
      {
         return seek([param1,param2]);
      }
      
      private function seek(param1:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc3_:RLGSData = null;
         var _loc2_:Array = _rlgsDataArr[5];
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc4_];
            if(_loc3_._spcate == param1[0] && _loc3_._spframe == param1[1])
            {
               return seek(_loc3_.subGoods());
            }
            _loc4_++;
         }
         return param1;
      }
      
      public function seekAllSuit(param1:int, param2:int) : Array
      {
         var _loc7_:int = 0;
         var _loc6_:RLGSData = null;
         var _loc5_:Array = null;
         var _loc3_:Array = [];
         var _loc4_:Array = _rlgsDataArr[5];
         _loc7_ = 0;
         while(_loc7_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc7_];
            _loc5_ = matchsuit(_loc6_._spcate,_loc6_._spframe);
            if(_loc5_[0] == param1 && _loc5_[1] == param2)
            {
               _loc3_.push([_loc6_._spcate,_loc6_._spframe]);
            }
            _loc7_++;
         }
         return _loc3_;
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
