package com.coltware.airxzip
{
   import flash.utils.*;
   
   public class ZipCRC32
   {
      
      public static var CRYPTHEADLEN:int = 12;
      
      private static var S_KEY1:uint = 305419896;
      
      private static var S_KEY2:uint = 591751049;
      
      private static var S_KEY3:uint = 878082192;
      
      private static var _crc32table:Array = createTable();
      
      private var _key:Array;
      
      public function ZipCRC32()
      {
         super();
      }
      
      public static function getStringValue(param1:String) : uint
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         return getByteArrayValue(_loc2_);
      }
      
      private static function createTable() : Array
      {
         var _loc3_:uint = 0;
         var _loc5_:uint = 0;
         var _loc1_:Array = new Array(256);
         var _loc2_:uint = 3988292384;
         var _loc4_:uint = 0;
         while(_loc4_ < 256)
         {
            _loc3_ = _loc4_;
            _loc5_ = 0;
            while(_loc5_ < 8)
            {
               if(_loc3_ & 1)
               {
                  _loc3_ = uint(_loc2_ ^ uint(_loc3_ >>> 1));
               }
               else
               {
                  _loc3_ = uint(_loc3_ >>> 1);
               }
               _loc1_[_loc4_] = _loc3_;
               _loc5_++;
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public static function getByteArrayValue(param1:ByteArray) : uint
      {
         var _loc2_:uint = 4294967295;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_ = uint((_loc2_ ^ param1[_loc4_]) & 0xFF);
            _loc2_ = uint(uint(_crc32table[_loc3_]) ^ _loc2_ >>> 8);
            _loc4_++;
         }
         return _loc2_ ^ 0xFFFFFFFF;
      }
      
      public static function getCRC32(param1:uint, param2:uint) : uint
      {
         var _loc3_:uint = uint((param1 ^ param2) & 0xFF);
         return uint(_crc32table[_loc3_] ^ param1 >>> 8);
      }
   }
}

