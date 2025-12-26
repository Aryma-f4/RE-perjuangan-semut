package com.coltware.airxzip.crypt
{
   import com.coltware.airxzip.ZipEntry;
   import com.coltware.airxzip.ZipHeader;
   import flash.utils.ByteArray;
   
   public interface ICrypto
   {
      
      function encrypt(param1:ByteArray) : ByteArray;
      
      function initEncrypt(param1:ByteArray, param2:ZipHeader) : void;
      
      function checkDecrypt(param1:ZipEntry) : Boolean;
      
      function initDecrypt(param1:ByteArray, param2:ZipHeader) : void;
      
      function decrypt(param1:ByteArray) : ByteArray;
   }
}

