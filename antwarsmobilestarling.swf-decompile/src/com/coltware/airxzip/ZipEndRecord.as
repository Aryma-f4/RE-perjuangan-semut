package com.coltware.airxzip
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ZipEndRecord
   {
      
      private static var log:ILogger = Log.getLogger("com.coltware.airxzip.ZipEndRecord");
      
      public static var LENGTH:int = 22;
      
      public static var SIGNATURE:uint = 101010256;
      
      private var _comment:ByteArray;
      
      private var _offsetCentralDir:uint;
      
      private var _numberDisk:uint;
      
      private var _commentLength:uint;
      
      private var _totalEntriesDisk:uint;
      
      private var _totalEntries:uint;
      
      private var _numberDiskStartCentralDir:uint;
      
      private var _sizeCentralDir:uint;
      
      private var _signature:int;
      
      public function ZipEndRecord()
      {
         super();
      }
      
      public function getOffset() : int
      {
         return this._offsetCentralDir;
      }
      
      public function dumpLogInfo() : void
      {
         log.debug("*************** END OF RECORD DIRECTORY RECORD **************** " + this._signature.toString(16));
         log.debug("number of this disk : " + this._numberDisk);
         log.debug("Number of the disk with the start of the central directory : " + this._numberDiskStartCentralDir);
         log.debug("Total number of entries in the central dir on this disk : " + this._totalEntriesDisk);
         log.debug("Total number of entries in the central dir : " + this._totalEntries);
         log.debug("Size of the central directory : " + this._sizeCentralDir);
         log.debug("Offset of start of central directory with respect to the starting disk numbe : " + this._offsetCentralDir);
         log.debug("zipfile comment length : " + this._commentLength);
      }
      
      public function getTotalEntries() : uint
      {
         return this._totalEntries;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.endian = Endian.LITTLE_ENDIAN;
         param1.readBytes(_loc2_,0,LENGTH);
         _loc2_.position = 0;
         this._signature = _loc2_.readInt();
         _loc2_.position = 4;
         this._numberDisk = _loc2_.readUnsignedShort();
         _loc2_.position = 6;
         this._numberDiskStartCentralDir = _loc2_.readUnsignedShort();
         _loc2_.position = 8;
         this._totalEntriesDisk = _loc2_.readShort();
         _loc2_.position = 10;
         this._totalEntries = _loc2_.readShort();
         _loc2_.position = 12;
         this._sizeCentralDir = _loc2_.readInt();
         _loc2_.position = 16;
         this._offsetCentralDir = _loc2_.readInt();
         _loc2_.position = 20;
         this._commentLength = _loc2_.readUnsignedShort();
         if(this._commentLength > 0)
         {
            param1.readBytes(_loc2_,LENGTH,this._commentLength);
         }
      }
      
      public function getSize() : int
      {
         return this._sizeCentralDir;
      }
      
      public function write(param1:IDataOutput, param2:int, param3:int, param4:int) : void
      {
         this._signature = SIGNATURE;
         this._numberDisk = 0;
         this._totalEntries = param2;
         this._commentLength = 0;
         this._sizeCentralDir = param4;
         this._offsetCentralDir = param3;
         param1.writeUnsignedInt(SIGNATURE);
         param1.writeShort(this._numberDisk);
         param1.writeShort(0);
         param1.writeShort(this._totalEntries);
         param1.writeShort(this._totalEntries);
         param1.writeUnsignedInt(this._sizeCentralDir);
         param1.writeUnsignedInt(this._offsetCentralDir);
         param1.writeShort(this._commentLength);
      }
   }
}

