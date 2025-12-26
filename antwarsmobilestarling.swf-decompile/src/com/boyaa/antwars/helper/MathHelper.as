package com.boyaa.antwars.helper
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MathHelper
   {
      
      public function MathHelper()
      {
         super();
         throw new Error("AbstractClassError");
      }
      
      public static function check_circleAndRectangle(param1:Point, param2:Number, param3:Rectangle) : Boolean
      {
         var _loc4_:Number = Math.abs(param1.x - param3.x);
         var _loc5_:Number = Math.abs(param1.y - param3.y);
         var _loc7_:* = param2;
         var _loc6_:Number = param3.width >> 1;
         var _loc8_:Number = param3.height >> 1;
         if(_loc4_ > _loc7_ + _loc6_ || _loc5_ > _loc7_ + _loc8_)
         {
            return false;
         }
         if(_loc5_ <= _loc8_)
         {
            return true;
         }
         if(_loc4_ <= _loc6_)
         {
            return true;
         }
         if(param1.x > param3.x)
         {
            if(param1.y > param3.y)
            {
               if(getSquareOfDistAlongTwoPoint(param3.x + _loc6_,param3.y + _loc8_,param1.x,param1.y) <= _loc7_ * _loc7_)
               {
                  return true;
               }
            }
            else if(getSquareOfDistAlongTwoPoint(param3.x + _loc6_,param3.y - _loc8_,param1.x,param1.y) <= _loc7_ * _loc7_)
            {
               return true;
            }
         }
         else if(param1.y > param3.y)
         {
            if(getSquareOfDistAlongTwoPoint(param3.x - _loc6_,param3.y + _loc8_,param1.x,param1.y) <= _loc7_ * _loc7_)
            {
               return true;
            }
         }
         else if(getSquareOfDistAlongTwoPoint(param3.x - _loc6_,param3.y - _loc8_,param1.x,param1.y) <= _loc7_ * _loc7_)
         {
            return true;
         }
         return false;
      }
      
      public static function check_circleAndPoint(param1:Point, param2:Number, param3:Point) : Boolean
      {
         return getSquareOfDistAlongTwoPoint(param1.x,param1.y,param3.x,param3.y) <= Math.pow(param2,2);
      }
      
      public static function getSquareOfDistAlongTwoPoint(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return (param3 - param1) * (param3 - param1) + (param4 - param2) * (param4 - param2);
      }
      
      public static function randomWithinRange(param1:int, param2:int) : int
      {
         var _loc3_:Number = NaN;
         if(param1 > param2)
         {
            _loc3_ = param2;
            param2 = param1;
            param1 = _loc3_;
         }
         return param1 + Math.round(Math.random() * (param2 - param1));
      }
      
      public static function randomNumberWithinRange(param1:Number, param2:Number) : Number
      {
         var _loc3_:* = NaN;
         if(param1 > param2)
         {
            _loc3_ = param2;
            param2 = param1;
            param1 = _loc3_;
         }
         return param1 + Math.round(Math.random() * (param2 - param1));
      }
      
      public static function getVelocity(param1:Number, param2:Number, param3:Number) : Number
      {
         trace("dx:",param1," dy:",param2);
         return Math.sqrt(1.2 / (2 * (param1 * Math.tan(param3 * 3.141592653589793 / 180) - param2))) * (param1 / Math.cos(param3 * 3.141592653589793 / 180));
      }
   }
}

