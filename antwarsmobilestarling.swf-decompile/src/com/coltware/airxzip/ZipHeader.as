package com.coltware.airxzip
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   use namespace zip_internal;
   
   public class ZipHeader
   {
      
      private static var log:ILogger = Log.getLogger("com.coltware.airxzip.ZipHeader");
      
      public static var HEADER_LOCAL_FILE:uint = 67324752;
      
      public static var HEADER_CENTRAL_DIR:uint = 33639248;
      
      public static var HEADER_END_CENTRAL_DIR:uint = 101010256;
      
      public static var WIN_DIR:int = 16;
      
      public static var WIN_FILE:int = 32;
      
      public static var UNIX_DIR:int = 16384;
      
      public static var UNIX_FILE:int = 32768;
      
      zip_internal var _compressMethod:uint;
      
      zip_internal var _version:uint;
      
      zip_internal var _lastModDate:int;
      
      zip_internal var _commentLength:uint;
      
      zip_internal var _comment:ByteArray;
      
      zip_internal var _extraFieldLength:uint;
      
      zip_internal var _signature:uint;
      
      zip_internal var _lastModTime:int;
      
      zip_internal var _crc32:uint;
      
      zip_internal var _uncompressSize:uint;
      
      zip_internal var _offsetLocalHeader:uint;
      
      zip_internal var _versionBy:uint;
      
      zip_internal var _internalFileAttrs:uint = 0;
      
      zip_internal var _bitFlag:uint;
      
      zip_internal var _compressSize:uint;
      
      zip_internal var _diskNumber:uint = 0;
      
      zip_internal var _filename:ByteArray;
      
      zip_internal var _extraField:ByteArray;
      
      zip_internal var _filenameLength:uint;
      
      zip_internal var _externalFileAttrs:uint = 0;
      
      public function ZipHeader(param1:uint = 67324752)
      {
         super();
         this.zip_internal::_signature = param1;
      }
      
      public function writeLocalHeader(param1:IDataOutput) : void
      {
         this.writeHeader(param1,false);
      }
      
      protected function getFilenameUTF8() : String
      {
         var _loc1_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(!this.zip_internal::_filename)
         {
            return "";
         }
         this.zip_internal::_filename.position = 0;
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:String = "";
         while(this.zip_internal::_filename.bytesAvailable)
         {
            _loc1_ = int(this.zip_internal::_filename.readUnsignedByte());
            if(_loc1_ >= 0 && _loc1_ <= 127)
            {
               _loc2_.writeByte(_loc1_);
            }
            else if(_loc1_ >= 192 && _loc1_ <= 223)
            {
               _loc2_.writeByte(_loc1_);
               _loc2_.writeByte(this.zip_internal::_filename.readUnsignedByte());
            }
            else if(_loc1_ >= 224 && _loc1_ <= 239)
            {
               _loc4_ = int(this.zip_internal::_filename.readUnsignedByte());
               _loc5_ = int(this.zip_internal::_filename.readUnsignedByte());
               if(_loc1_ == 227 && _loc4_ == 130 && _loc5_ == 153)
               {
                  --_loc2_.position;
                  _loc1_ = _loc2_.readUnsignedByte() + 1;
                  --_loc2_.position;
                  _loc2_.writeByte(_loc1_);
               }
               else if(_loc1_ == 227 && _loc4_ == 130 && _loc5_ == 154)
               {
                  --_loc2_.position;
                  _loc1_ = _loc2_.readUnsignedByte() + 2;
                  --_loc2_.position;
                  _loc2_.writeByte(_loc1_);
               }
               else
               {
                  _loc2_.writeByte(_loc1_);
                  _loc2_.writeByte(_loc4_);
                  _loc2_.writeByte(_loc5_);
               }
            }
            else if(_loc1_ >= 240 && _loc1_ <= 247)
            {
               _loc2_.writeByte(_loc1_);
               _loc2_.writeByte(this.zip_internal::_filename.readUnsignedByte());
               _loc2_.writeByte(this.zip_internal::_filename.readUnsignedByte());
               _loc2_.writeByte(this.zip_internal::_filename.readUnsignedByte());
            }
         }
         _loc2_.position = 0;
         return _loc2_.readMultiByte(_loc2_.bytesAvailable,"utf-8");
      }
      
      public function getUncompressSize() : uint
      {
         return this.zip_internal::_uncompressSize;
      }
      
      public function read(param1:IDataInput, param2:ByteArray) : void
      {
         if(this.zip_internal::_signature == HEADER_LOCAL_FILE)
         {
            this.readLocalHeader(param1,param2);
         }
         else if(this.zip_internal::_signature == HEADER_CENTRAL_DIR)
         {
            this.readCentralHeader(param1,param2);
         }
      }
      
      public function getVersion() : int
      {
         return this.zip_internal::_versionBy & 0xFF;
      }
      
      public function getDate() : Date
      {
         var _loc1_:* = this.zip_internal::_lastModTime & 0x1F;
         var _loc2_:* = (this.zip_internal::_lastModTime & 0x07E0) >> 5;
         var _loc3_:* = (this.zip_internal::_lastModTime & 0xF800) >> 11;
         var _loc4_:* = this.zip_internal::_lastModDate & 0x1F;
         var _loc5_:* = (this.zip_internal::_lastModDate & 0x01E0) >> 5;
         var _loc6_:int = ((this.zip_internal::_lastModDate & 0xFE00) >> 9) + 1980;
         return new Date(_loc6_,_loc5_ - 1,_loc4_,_loc3_,_loc2_,_loc1_,0);
      }
      
      public function getLocalHeaderSize() : int
      {
         return 30 + this.zip_internal::_filenameLength + this.zip_internal::_extraFieldLength;
      }
      
      public function getLocalHeaderOffset() : int
      {
         return this.zip_internal::_offsetLocalHeader;
      }
      
      public function getCompressMethod() : uint
      {
         return this.zip_internal::_compressMethod;
      }
      
      public function writeCentralHeader(param1:IDataOutput) : void
      {
         this.writeHeader(param1,true);
      }
      
      public function getCompressRate() : Number
      {
         if(this.zip_internal::_uncompressSize == 0)
         {
            return 0;
         }
         var _loc1_:Number = this.zip_internal::_compressSize / this.zip_internal::_uncompressSize;
         return 1 - _loc1_;
      }
      
      public function isDirectory() : Boolean
      {
         var _loc1_:uint = 0;
         if(this.zip_internal::_uncompressSize == 0)
         {
            if(this.zip_internal::_externalFileAttrs == 0)
            {
               return false;
            }
            if(this.zip_internal::_externalFileAttrs & 0x10)
            {
               return true;
            }
            _loc1_ = uint(this.zip_internal::_externalFileAttrs >> 16 & 0xFFFF);
            if(_loc1_ & ZipHeader.UNIX_DIR)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function writeHeader(param1:IDataOutput, param2:Boolean = false) : void
      {
         if(param2)
         {
            this.zip_internal::_signature = HEADER_CENTRAL_DIR;
            param1.writeUnsignedInt(HEADER_CENTRAL_DIR);
            param1.writeShort(this.zip_internal::_versionBy);
         }
         else
         {
            this.zip_internal::_signature = HEADER_LOCAL_FILE;
            param1.writeUnsignedInt(HEADER_LOCAL_FILE);
         }
         param1.writeShort(this.zip_internal::_version);
         param1.writeShort(this.zip_internal::_bitFlag);
         param1.writeShort(this.zip_internal::_compressMethod);
         param1.writeShort(this.zip_internal::_lastModTime);
         param1.writeShort(this.zip_internal::_lastModDate);
         param1.writeUnsignedInt(this.zip_internal::_crc32);
         param1.writeUnsignedInt(this.zip_internal::_compressSize);
         param1.writeUnsignedInt(this.zip_internal::_uncompressSize);
         param1.writeShort(this.zip_internal::_filenameLength);
         param1.writeShort(this.zip_internal::_extraFieldLength);
         if(this.zip_internal::_extraFieldLength > 0)
         {
            this.zip_internal::_extraField.position = 0;
            param1.writeBytes(this.zip_internal::_extraField);
         }
         if(param2)
         {
            param1.writeShort(this.zip_internal::_commentLength);
            param1.writeShort(this.zip_internal::_diskNumber);
            param1.writeShort(this.zip_internal::_internalFileAttrs);
            param1.writeUnsignedInt(this.zip_internal::_externalFileAttrs);
            param1.writeUnsignedInt(this.zip_internal::_offsetLocalHeader);
         }
         this.zip_internal::_filename.position = 0;
         param1.writeBytes(this.zip_internal::_filename);
         if(this.zip_internal::_extraFieldLength > 0)
         {
         }
      }
      
      public function readAuto(param1:IDataInput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.endian = Endian.LITTLE_ENDIAN;
         this.zip_internal::_signature = param1.readInt();
         this.read(param1,_loc2_);
      }
      
      protected function readLocalHeader(param1:IDataInput, param2:ByteArray) : void
      {
         param1.readBytes(param2,0,26);
         param2.position = 0;
         this.zip_internal::_version = param2.readUnsignedShort();
         param2.position = 2;
         this.zip_internal::_bitFlag = param2.readUnsignedShort();
         param2.position = 4;
         this.zip_internal::_compressMethod = param2.readUnsignedShort();
         param2.position = 6;
         this.zip_internal::_lastModTime = param2.readUnsignedShort();
         param2.position = 8;
         this.zip_internal::_lastModDate = param2.readUnsignedShort();
         param2.position = 10;
         this.zip_internal::_crc32 = param2.readUnsignedInt();
         param2.position = 14;
         this.zip_internal::_compressSize = param2.readUnsignedInt();
         param2.position = 18;
         this.zip_internal::_uncompressSize = param2.readUnsignedInt();
         param2.position = 22;
         this.zip_internal::_filenameLength = param2.readShort();
         param2.position = 24;
         this.zip_internal::_extraFieldLength = param2.readShort();
         if(this.zip_internal::_signature == HEADER_LOCAL_FILE)
         {
            param1.readBytes(param2,26,this.zip_internal::_filenameLength + this.zip_internal::_extraFieldLength);
            param2.position = 26;
            this.zip_internal::_filename = new ByteArray();
            param2.readBytes(this.zip_internal::_filename,0,this.zip_internal::_filenameLength);
            if(this.zip_internal::_extraFieldLength > 0)
            {
               this.zip_internal::_extraField = new ByteArray();
               param2.readBytes(this.zip_internal::_extraField,0,this.zip_internal::_extraFieldLength);
            }
         }
      }
      
      public function getCompressSize() : uint
      {
         return this.zip_internal::_compressSize;
      }
      
      protected function readCentralHeader(param1:IDataInput, param2:ByteArray) : void
      {
         param1.readBytes(param2,0,42);
         param2.position = 0;
         this.zip_internal::_versionBy = param2.readUnsignedShort();
         param2.position = 2;
         this.zip_internal::_version = param2.readUnsignedShort();
         param2.position = 4;
         this.zip_internal::_bitFlag = param2.readUnsignedShort();
         param2.position = 6;
         this.zip_internal::_compressMethod = param2.readUnsignedShort();
         param2.position = 8;
         this.zip_internal::_lastModTime = param2.readUnsignedShort();
         param2.position = 10;
         this.zip_internal::_lastModDate = param2.readUnsignedShort();
         param2.position = 12;
         this.zip_internal::_crc32 = param2.readUnsignedInt();
         param2.position = 16;
         this.zip_internal::_compressSize = param2.readUnsignedInt();
         param2.position = 20;
         this.zip_internal::_uncompressSize = param2.readUnsignedInt();
         param2.position = 24;
         this.zip_internal::_filenameLength = param2.readShort();
         param2.position = 26;
         this.zip_internal::_extraFieldLength = param2.readShort();
         param2.position = 28;
         this.zip_internal::_commentLength = param2.readUnsignedShort();
         param2.position = 30;
         this.zip_internal::_diskNumber = param2.readUnsignedShort();
         param2.position = 32;
         this.zip_internal::_internalFileAttrs = param2.readUnsignedShort();
         param2.position = 34;
         this.zip_internal::_externalFileAttrs = param2.readUnsignedInt();
         param2.position = 38;
         this.zip_internal::_offsetLocalHeader = param2.readUnsignedInt();
         var _loc3_:int = int(this.zip_internal::_filenameLength + this.zip_internal::_extraFieldLength + this.zip_internal::_commentLength);
         param1.readBytes(param2,42,_loc3_);
         param2.position = 42;
         if(this.zip_internal::_filenameLength > 0)
         {
            this.zip_internal::_filename = new ByteArray();
            param2.readBytes(this.zip_internal::_filename,0,this.zip_internal::_filenameLength);
         }
         if(this.zip_internal::_extraFieldLength > 0)
         {
            this.zip_internal::_extraField = new ByteArray();
            param2.readBytes(this.zip_internal::_extraField,0,this.zip_internal::_extraFieldLength);
         }
         if(this.zip_internal::_commentLength > 0)
         {
            this.zip_internal::_comment = new ByteArray();
            param2.readBytes(this.zip_internal::_comment,0,this.zip_internal::_commentLength);
         }
      }
      
      public function getFilename(param1:String = null) : String
      {
         if(this.zip_internal::_filenameLength < 1)
         {
            return "";
         }
         if(param1 == null)
         {
            if(this.zip_internal::_versionBy >> 8 == 3)
            {
               param1 = "utf-8";
            }
            else
            {
               param1 = "shift_jis";
            }
         }
         var _loc2_:String = param1.toLowerCase();
         if(_loc2_ == "utf-8")
         {
            return this.getFilenameUTF8();
         }
         this.zip_internal::_filename.position = 0;
         return this.zip_internal::_filename.readMultiByte(this.zip_internal::_filename.bytesAvailable,param1);
      }
      
      public function dumpLogInfo() : void
      {
         log.debug("[" + this.zip_internal::_signature.toString(16) + "]*************** " + this.getFilename() + " ****************");
         log.debug("signature(4) : " + this.zip_internal::_signature);
         log.debug("version(2)   : " + this.zip_internal::_version);
         log.debug("bit flag(2)  : " + this.zip_internal::_bitFlag.toString(2));
         log.debug("method(2)    : " + this.zip_internal::_compressMethod);
         log.debug("last mod time(2) : " + this.zip_internal::_lastModTime);
         log.debug("last mod date(2) : " + this.zip_internal::_lastModDate);
         log.debug("date  : " + this.getDate());
         log.debug("crc32(4)     : " + this.zip_internal::_crc32.toString(16));
         log.debug("compress size(4)        : " + this.zip_internal::_compressSize);
         log.debug("un-compress size(4)     : " + this.zip_internal::_uncompressSize);
         log.debug("filename length(2)      : " + this.zip_internal::_filenameLength);
         log.debug("extra length(2)         : " + this.zip_internal::_extraFieldLength);
         if(this.zip_internal::_extraFieldLength > 0)
         {
            this.zip_internal::_extraField.position = 0;
            log.debug("extra field : " + this.zip_internal::_extraField.toString());
         }
         if(this.zip_internal::_signature == HEADER_CENTRAL_DIR)
         {
            log.debug("version by1 " + (this.zip_internal::_versionBy >> 8));
            log.debug("version by2 " + (this.zip_internal::_versionBy & 0xFF));
            log.debug("comment size " + this.zip_internal::_commentLength);
            log.debug("disk number  " + this.zip_internal::_diskNumber);
            log.debug("internal file attrs " + this.zip_internal::_internalFileAttrs);
            log.debug("external file attrs " + this.zip_internal::_externalFileAttrs);
            log.debug("offset local header " + this.zip_internal::_offsetLocalHeader);
            if(this.isDirectory())
            {
               log.debug("is dir");
            }
            else
            {
               log.debug("is file");
            }
         }
      }
   }
}

