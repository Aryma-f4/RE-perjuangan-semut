package com.boyaa.antwars.lang
{
   import flash.filesystem.FileStream;
   import flash.system.System;
   import flash.utils.ByteArray;
   
   public class LangManager
   {
      
      private static var _instance:LangManager = null;
      
      private var _obj:Object = null;
      
      public function LangManager(param1:Single)
      {
         super();
      }
      
      public static function t(param1:String, param2:Array = null) : String
      {
         var _loc5_:int = 0;
         var _loc4_:RegExp = null;
         var _loc3_:String = LangManager.getLang.getLangByStr(param1);
         if(!param2)
         {
            return _loc3_;
         }
         _loc5_ = 0;
         while(_loc5_ < param2.length)
         {
            _loc4_ = new RegExp("parma" + (_loc5_ + 1),"g");
            _loc3_ = _loc3_.replace(_loc4_,param2[_loc5_]);
            _loc5_++;
         }
         return _loc3_;
      }
      
      public static function ta(param1:String) : Array
      {
         return LangManager.getLang.getLangArray(param1);
      }
      
      public static function replace(param1:String, ... rest) : String
      {
         return LangManager.getLang.getreplaceLang(param1,rest);
      }
      
      public static function get getLang() : LangManager
      {
         if(_instance == null)
         {
            _instance = new LangManager(new Single());
         }
         return _instance;
      }
      
      public function init() : void
      {
         var _loc2_:FileStream = new FileStream();
         _loc2_.open(Application.instance.resManager.getResFile("lan.xml"),"read");
         var _loc1_:ByteArray = new ByteArray();
         _loc2_.readBytes(_loc1_);
         var _loc4_:XML = new XML(_loc1_);
         var _loc3_:ResolveLan = new ResolveLan(_loc4_);
         _loc3_.resolveXML();
         _obj = _loc3_.obj;
         System.disposeXML(_loc4_);
      }
      
      public function getLangByStr(param1:String) : String
      {
         var _loc2_:RegExp = /\\n/g;
         return _obj[param1].replace(_loc2_,"\n");
      }
      
      public function getreplaceLang(param1:String, ... rest) : String
      {
         var _loc4_:int = 0;
         var _loc3_:RegExp = null;
         param1 = getLangByStr(param1);
         _loc4_ = 0;
         while(_loc4_ < rest.length)
         {
            _loc3_ = new RegExp("parma" + (_loc4_ + 1),"g");
            param1 = param1.replace(_loc3_,rest[_loc4_]);
            _loc4_++;
         }
         return param1;
      }
      
      public function getLangArray(param1:String) : Array
      {
         return getLangByStr(param1).split("|");
      }
      
      public function set obj(param1:Object) : void
      {
         _obj = param1;
      }
   }
}

class Single
{
   
   public function Single()
   {
      super();
   }
}
