package com.boyaa.antwars.data.model
{
   public class RLGSData
   {
      
      public var _str:String = "";
      
      public var _spcate:int = 0;
      
      public var _spframe:int = 0;
      
      public function RLGSData(param1:String, param2:int, param3:int)
      {
         super();
         this._spcate = param2;
         this._spframe = param3;
         this._str = param1;
      }
      
      public function subGoods() : Array
      {
         var _loc1_:Array = _str.split("|");
         return (_loc1_[0] as String).split(",");
      }
   }
}

