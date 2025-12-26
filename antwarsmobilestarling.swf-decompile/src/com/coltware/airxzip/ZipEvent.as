package com.coltware.airxzip
{
   import flash.events.Event;
   import flash.utils.ByteArray;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   use namespace zip_internal;
   
   public class ZipEvent extends Event
   {
      
      private static var log:ILogger = Log.getLogger("com.coltware.airxzip.ZipEvent");
      
      public static var ZIP_LOAD_DATA:String = "zipLoadData";
      
      public static var ZIP_DATA_UNCOMPRESS:String = "zipDataUncompress";
      
      public static var ZIP_DATA_COMPRESS:String = "zipDataCompress";
      
      public static var ZIP_FILE_CREATED:String = "zipFileCreated";
      
      zip_internal var $method:String;
      
      zip_internal var $entry:ZipEntry;
      
      zip_internal var $data:ByteArray;
      
      public function ZipEvent(param1:String)
      {
         super(param1);
      }
      
      public function get data() : ByteArray
      {
         if(this.zip_internal::$method)
         {
            this.zip_internal::$data.uncompress(this.zip_internal::$method);
         }
         return this.zip_internal::$data;
      }
      
      public function get entry() : ZipEntry
      {
         return this.zip_internal::$entry;
      }
   }
}

