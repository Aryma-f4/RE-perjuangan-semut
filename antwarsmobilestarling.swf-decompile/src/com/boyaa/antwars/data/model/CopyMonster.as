package com.boyaa.antwars.data.model
{
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.helper.StringUtil;
   import flash.geom.Point;
   
   public class CopyMonster
   {
      
      private var _roleid:int;
      
      private var _qty:int;
      
      private var _produce_cd:int;
      
      private var _produce_num:int;
      
      private var _bornpoints:Vector.<Point> = new Vector.<Point>();
      
      private const DATA_TYPE:Array = ["roleid","qty","produce_cd","produce_num"];
      
      private const DATA_XML:Array = ["roleid","qty","produce_cd","produce_num"];
      
      public function CopyMonster()
      {
         super();
      }
      
      public function updateForData(param1:XML) : void
      {
         var _loc6_:int = 0;
         var _loc5_:Array = null;
         var _loc4_:int = 0;
         var _loc3_:Array = null;
         _loc6_ = 0;
         while(_loc6_ < DATA_TYPE.length)
         {
            if(this["_" + DATA_TYPE[_loc6_]] is int)
            {
               this["_" + DATA_TYPE[_loc6_]] = int(param1[DATA_XML[_loc6_]]);
            }
            else
            {
               this["_" + DATA_TYPE[_loc6_]] = param1[DATA_XML[_loc6_]];
            }
            _loc6_++;
         }
         var _loc2_:String = StringUtil.trim(param1.@bornpoints);
         if(_loc2_)
         {
            _loc5_ = _loc2_.split("|");
            _loc4_ = 0;
            while(_loc4_ < _loc5_.length)
            {
               _loc3_ = _loc5_[_loc4_].split(",");
               _bornpoints.push(new Point(_loc3_[0],_loc3_[1]));
               _loc4_++;
            }
         }
      }
      
      public function getRandomBronpoint() : Point
      {
         var _loc1_:int = 0;
         if(_bornpoints.length > 0)
         {
            _loc1_ = MathHelper.randomWithinRange(1,_bornpoints.length);
            return _bornpoints[_loc1_ - 1];
         }
         return null;
      }
      
      public function get roleid() : int
      {
         return _roleid;
      }
      
      public function get qty() : int
      {
         return _qty;
      }
      
      public function get produce_cd() : int
      {
         return _produce_cd;
      }
      
      public function get produce_num() : int
      {
         return _produce_num;
      }
   }
}

