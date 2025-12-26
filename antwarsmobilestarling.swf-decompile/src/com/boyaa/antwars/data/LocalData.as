package com.boyaa.antwars.data
{
   import flash.net.SharedObject;
   
   public class LocalData
   {
      
      private static var _instance:LocalData = null;
      
      private var so:SharedObject;
      
      public function LocalData(param1:Single)
      {
         super();
         so = SharedObject.getLocal("Antwars/LocalData");
      }
      
      public static function get instance() : LocalData
      {
         if(_instance == null)
         {
            _instance = new LocalData(new Single());
         }
         return _instance;
      }
      
      public function setData(param1:String, param2:String) : void
      {
         so.data[param1] = param2;
         so.flush();
      }
      
      public function getData(param1:String) : String
      {
         return so.data[param1];
      }
      
      public function unsetData(param1:String) : void
      {
         setData(param1,null);
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
