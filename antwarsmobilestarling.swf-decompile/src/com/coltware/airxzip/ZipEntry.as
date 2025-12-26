package com.coltware.airxzip
{
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   use namespace zip_internal;
   
   public class ZipEntry extends EventDispatcher
   {
      
      public static var METHOD_NONE:int = 0;
      
      public static var METHOD_DEFLATE:int = 8;
      
      private var _content:ByteArray;
      
      zip_internal var _headerLocal:ZipHeader;
      
      private var _stream:IDataInput;
      
      zip_internal var _header:ZipHeader;
      
      public function ZipEntry(param1:IDataInput)
      {
         super();
         this._stream = param1;
      }
      
      public function getHeader() : ZipHeader
      {
         return this.zip_internal::_header;
      }
      
      public function getFilename(param1:String = null) : String
      {
         return this.zip_internal::_header.getFilename(param1);
      }
      
      public function getLocalHeaderSize() : int
      {
         return this.zip_internal::_header.getLocalHeaderSize();
      }
      
      public function isCompressed() : Boolean
      {
         var _loc1_:int = int(this.zip_internal::_header.getCompressMethod());
         if(_loc1_ == 0)
         {
            return false;
         }
         return true;
      }
      
      zip_internal function dumpLogInfo() : void
      {
         this.zip_internal::_header.dumpLogInfo();
      }
      
      public function setHeader(param1:ZipHeader) : void
      {
         this.zip_internal::_header = param1;
      }
      
      public function getUncompressSize() : int
      {
         return this.zip_internal::_header.getUncompressSize();
      }
      
      public function getLocalHeaderOffset() : int
      {
         return this.zip_internal::_header.getLocalHeaderOffset();
      }
      
      public function getCompressRate() : Number
      {
         return this.zip_internal::_header.getCompressRate();
      }
      
      public function getCompressMethod() : int
      {
         return this.zip_internal::_header.getCompressMethod();
      }
      
      public function getHostVersion() : int
      {
         return this.zip_internal::_header.getVersion();
      }
      
      public function getVersion() : int
      {
         return this.zip_internal::_header.zip_internal::_version;
      }
      
      public function isDirectory() : Boolean
      {
         return this.zip_internal::_header.isDirectory();
      }
      
      public function getDate() : Date
      {
         return this.zip_internal::_header.getDate();
      }
      
      public function getCompressSize() : int
      {
         return this.zip_internal::_header.getCompressSize();
      }
      
      public function isEncrypted() : Boolean
      {
         if(this.zip_internal::_header.zip_internal::_bitFlag & 1)
         {
            return true;
         }
         return false;
      }
      
      public function getCrc32() : String
      {
         return this.zip_internal::_header.zip_internal::_crc32.toString(16);
      }
   }
}

