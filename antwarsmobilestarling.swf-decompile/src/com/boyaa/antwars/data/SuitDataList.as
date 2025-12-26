package com.boyaa.antwars.data
{
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.SuitData;
   
   public class SuitDataList
   {
      
      private static var _instance:SuitDataList = null;
      
      public var wishList:Array = null;
      
      public var isChange:Boolean = false;
      
      public var currSuitData:SuitData = null;
      
      private var _list:Array;
      
      public function SuitDataList(param1:Single)
      {
         super();
      }
      
      public static function get instance() : SuitDataList
      {
         if(_instance == null)
         {
            _instance = new SuitDataList(new Single());
         }
         return _instance;
      }
      
      public function addSuitData(param1:XML) : void
      {
         var _loc4_:int = 0;
         var _loc2_:SuitData = null;
         var _loc3_:int = int(param1.suit.length());
         _list = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new SuitData();
            _loc2_.updateForData(param1.suit[_loc4_]);
            _list.push(_loc2_);
            _loc4_++;
         }
      }
      
      public function isSuit(param1:int, param2:int) : Array
      {
         var _loc5_:int = 0;
         var _loc4_:SuitData = null;
         var _loc3_:Array = null;
         _loc5_ = 0;
         while(_loc5_ < _list.length)
         {
            _loc4_ = _list[_loc5_] as SuitData;
            _loc3_ = _loc4_.isSuit(param1,param2);
            if(_loc3_ != null)
            {
               return _loc3_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public function getSuitData(param1:int) : SuitData
      {
         var _loc3_:int = 0;
         var _loc2_:SuitData = null;
         _loc3_ = 0;
         while(_loc3_ < _list.length)
         {
            _loc2_ = _list[_loc3_] as SuitData;
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getSuitAttribute(param1:Array) : Array
      {
         var _loc10_:int = 0;
         var _loc5_:GoodsData = null;
         var _loc8_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc9_:int = 0;
         var _loc6_:Array = [];
         _loc10_ = 0;
         while(_loc10_ < param1.length)
         {
            _loc5_ = param1[_loc10_];
            _loc8_ = isSuit(_loc5_.typeID,_loc5_.frameID);
            if(_loc8_ != null)
            {
               judgeRepeat(_loc6_,_loc8_);
            }
            _loc10_++;
         }
         var _loc7_:Array = [0,0,0,0,0,0,[],[]];
         _loc10_ = 0;
         while(_loc10_ < _loc6_.length)
         {
            _loc2_ = int(_loc6_[_loc10_][0]);
            _loc3_ = (_loc6_[_loc10_] as Array).length - 1;
            _loc4_ = getAttribute(_loc2_,_loc3_);
            _loc9_ = 0;
            while(_loc9_ < 6)
            {
               var _loc11_:* = _loc9_;
               var _loc12_:* = _loc7_[_loc11_] + _loc4_[_loc9_];
               _loc7_[_loc11_] = _loc12_;
               _loc9_++;
            }
            if(_loc4_[6] != 0)
            {
               (_loc7_[6] as Array).push(_loc4_[6]);
            }
            (_loc7_[7] as Array).push([_loc2_,_loc3_]);
            _loc10_++;
         }
         return _loc7_;
      }
      
      public function getAttribute(param1:int, param2:int) : Array
      {
         var _loc4_:int = 0;
         var _loc3_:SuitData = null;
         _loc4_ = 0;
         while(_loc4_ < _list.length)
         {
            _loc3_ = _list[_loc4_] as SuitData;
            if(_loc3_.id == param1)
            {
               return _loc3_.getAttribute(param2);
            }
            _loc4_++;
         }
         return [0,0,0,0,0,0,0];
      }
      
      private function judgeRepeat(param1:Array, param2:Array) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_][0] == param2[0])
            {
               _loc3_ = 1;
               while(_loc3_ < param2.length)
               {
                  if((param1[_loc4_] as Array).lastIndexOf(param2[_loc3_]) < 1)
                  {
                     (param1[_loc4_] as Array).push(param2[_loc3_]);
                     return;
                  }
                  _loc3_++;
               }
               return;
            }
            _loc4_++;
         }
         param1.push(param2.concat());
      }
      
      public function getDemandList(param1:SuitData) : void
      {
      }
      
      public function getSuitByType(param1:int) : Array
      {
         var _loc4_:int = 0;
         var _loc3_:SuitData = null;
         var _loc2_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < _list.length)
         {
            _loc3_ = _list[_loc4_] as SuitData;
            if(_loc3_.type == param1)
            {
               _loc2_.push(_loc3_);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function get list() : Array
      {
         return _list;
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
