package com.coltware.airxzip
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import flash.utils.IDataInput;
   
   public class ZipFileReader
   {
      
      private var _stream:IDataInput;
      
      private var _entries:Array;
      
      private var _map:Object;
      
      public function ZipFileReader()
      {
         super();
         _entries = [];
         _map = {};
      }
      
      public function open(param1:*) : void
      {
         // Stubbed: Original expected File object
         // For web, this class essentially becomes useless unless we rewrite it to take ByteArray
         // Since ResManager.as was patched to NOT use this, we just need to prevent compilation errors
      }
      
      public function close() : void
      {

      }
      
      public function getEntries() : Array
      {
         return _entries;
      }
      
      public function getEntry(param1:String) : ZipEntry
      {
         return _map[param1];
      }
      
      public function unzip(param1:ZipEntry) : ByteArray
      {
         return new ByteArray();
      }
   }
}
