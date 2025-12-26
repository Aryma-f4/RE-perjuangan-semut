package com.boyaa.antwars.data.model
{
   public class FightGoodsData
   {
      
      private static const DATA_TYPE:Array = ["name","info","price","expendForce","frame","type"];
      
      private var _name:String = "";
      
      private var _info:String = "";
      
      private var _price:int = 0;
      
      private var _expendForce:int = 0;
      
      private var _frame:int = 0;
      
      private var _type:int = 0;
      
      public function FightGoodsData()
      {
         super();
      }
      
      public function readData(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:String = null;
         _loc3_ = 0;
         while(_loc3_ < DATA_TYPE.length)
         {
            _loc2_ = DATA_TYPE[_loc3_];
            this["_" + _loc2_] = param1[_loc3_];
            _loc3_++;
         }
      }
      
      public function copy() : FightGoodsData
      {
         var _loc3_:int = 0;
         var _loc2_:String = null;
         var _loc1_:FightGoodsData = new FightGoodsData();
         _loc3_ = 0;
         while(_loc3_ < DATA_TYPE.length)
         {
            _loc2_ = DATA_TYPE[_loc3_];
            _loc1_[_loc2_] = this["_" + _loc2_];
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function get price() : int
      {
         return _price;
      }
      
      public function set price(param1:int) : void
      {
         _price = param1;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function set name(param1:String) : void
      {
         _name = param1;
      }
      
      public function get info() : String
      {
         return _info;
      }
      
      public function set info(param1:String) : void
      {
         _info = param1;
      }
      
      public function get expendForce() : int
      {
         return _expendForce;
      }
      
      public function set expendForce(param1:int) : void
      {
         _expendForce = param1;
      }
      
      public function get frame() : int
      {
         return _frame;
      }
      
      public function set frame(param1:int) : void
      {
         _frame = param1;
      }
      
      public function get type() : int
      {
         return _type;
      }
      
      public function set type(param1:int) : void
      {
         _type = param1;
      }
   }
}

