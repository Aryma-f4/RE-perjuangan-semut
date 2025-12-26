package com.coltware.airxzip.crypt
{
   import com.coltware.airxzip.ZipCRC32;
   import com.coltware.airxzip.ZipEntry;
   import com.coltware.airxzip.ZipError;
   import com.coltware.airxzip.ZipHeader;
   import com.coltware.airxzip.zip_internal;
   import flash.utils.*;
   import mx.logging.*;
   
   use namespace zip_internal;
   
   public class ZipCrypto implements ICrypto
   {
      
      private static var log:ILogger = Log.getLogger("com.coltware.airxzip.crypt.ZipCrypto");
      
      private static var CRYPTHEADLEN:int = 12;
      
      private static var S_KEY1:int = 305419896;
      
      private static var S_KEY2:int = 591751049;
      
      private static var S_KEY3:int = 878082192;
      
      private var _outBytes:ByteArray;
      
      private var _key:Array;
      
      private var _header:ZipHeader;
      
      private var _password:ByteArray;
      
      public function ZipCrypto()
      {
         super();
      }
      
      protected function decryptByte() : int
      {
         var _loc1_:uint = uint(this._key[2] & 0xFFFF | 2);
         return _loc1_ * (_loc1_ ^ 1) >> 8 & 0xFF;
      }
      
      public function decrypt(param1:ByteArray) : ByteArray
      {
         var _loc2_:uint = uint(this._header.zip_internal::_crc32 >>> 24);
         var _loc3_:ByteArray = new ByteArray();
         param1.readBytes(_loc3_,0,CRYPTHEADLEN);
         var _loc4_:uint = this._initDecrypt(this._password,_loc3_);
         _loc4_ = uint(_loc4_ & 0xFFFF);
         if(_loc2_ == _loc4_)
         {
            return this._decrypt(param1);
         }
         throw new ZipError("password is not match");
      }
      
      private function _decrypt(param1:ByteArray) : ByteArray
      {
         var _loc3_:uint = 0;
         var _loc2_:ByteArray = new ByteArray();
         while(param1.bytesAvailable > 0)
         {
            _loc3_ = param1.readUnsignedByte();
            _loc3_ = this.zdecode(_loc3_);
            _loc2_.writeByte(_loc3_);
         }
         _loc2_.position = 0;
         return _loc2_;
      }
      
      protected function zencode(param1:uint) : uint
      {
         var _loc2_:uint = uint(this.decryptByte());
         this.updateKeys(param1);
         return _loc2_ ^ param1;
      }
      
      private function _initDecrypt(param1:ByteArray, param2:ByteArray) : uint
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc3_:ByteArray = new ByteArray();
         this._key = new Array(3);
         this._key[0] = S_KEY1;
         this._key[1] = S_KEY2;
         this._key[2] = S_KEY3;
         param1.position = 0;
         while(param1.bytesAvailable > 0)
         {
            _loc5_ = param1.readUnsignedByte();
            this.updateKeys(_loc5_);
         }
         param2.position = 0;
         var _loc4_:int = 0;
         while(_loc4_ < CRYPTHEADLEN)
         {
            _loc6_ = param2.readUnsignedByte();
            _loc6_ = this.zdecode(_loc6_);
            _loc4_++;
         }
         return _loc6_;
      }
      
      public function initDecrypt(param1:ByteArray, param2:ZipHeader) : void
      {
         this._password = param1;
         this._header = param2;
      }
      
      public function encrypt(param1:ByteArray) : ByteArray
      {
         var _loc2_:uint = 0;
         param1.position = 0;
         while(param1.bytesAvailable)
         {
            _loc2_ = param1.readUnsignedByte();
            this._outBytes.writeByte(this.zencode(_loc2_));
         }
         this._outBytes.position = 0;
         return this._outBytes;
      }
      
      protected function zdecode(param1:uint) : uint
      {
         var _loc2_:uint = param1;
         var _loc3_:uint = uint(this.decryptByte());
         param1 ^= _loc3_;
         this.updateKeys(param1);
         return param1;
      }
      
      public function checkDecrypt(param1:ZipEntry) : Boolean
      {
         return true;
      }
      
      private function _initEncrypt(param1:ByteArray, param2:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc6_:uint = 0;
         param2 >>= 24;
         var _loc3_:ByteArray = this._outBytes;
         this._key = new Array(3);
         this._key[0] = S_KEY1;
         this._key[1] = S_KEY2;
         this._key[2] = S_KEY3;
         param1.position = 0;
         while(param1.bytesAvailable > 0)
         {
            _loc6_ = param1.readUnsignedByte();
            this.updateKeys(_loc6_);
         }
         var _loc5_:int = 0;
         while(_loc5_ < CRYPTHEADLEN)
         {
            if(_loc5_ == CRYPTHEADLEN - 1)
            {
               _loc4_ = uint(param2 & 0xFF);
            }
            else
            {
               _loc4_ = uint(param2 >> 32 & 0xFF);
            }
            _loc4_ = this.zencode(_loc4_);
            _loc3_.writeByte(_loc4_);
            _loc5_++;
         }
      }
      
      public function initEncrypt(param1:ByteArray, param2:ZipHeader) : void
      {
         var _loc3_:uint = param2.zip_internal::_crc32;
         this._outBytes = new ByteArray();
         this._initEncrypt(param1,_loc3_);
         param2.zip_internal::_compressSize += CRYPTHEADLEN;
      }
      
      protected function updateKeys(param1:uint) : void
      {
         this._key[0] = ZipCRC32.getCRC32(this._key[0],param1);
         this._key[1] += this._key[0] & 0xFF;
         var _loc2_:int = int(this._key[1]);
         var _loc3_:int = 134775000;
         var _loc4_:int = 813;
         var _loc5_:int = uint(_loc2_ * _loc3_) + uint(_loc2_ * _loc4_) + 1;
         this._key[1] = _loc5_;
         var _loc6_:int = int(this._key[1]);
         var _loc7_:* = this._key[1] >> 24;
         this._key[2] = int(ZipCRC32.getCRC32(this._key[2],_loc7_));
      }
   }
}

