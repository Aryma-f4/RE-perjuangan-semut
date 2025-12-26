package com.boyaa.antwars.net.php
{
   import com.boyaa.antwars.data.LoginData;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   
   public class PostBase
   {
      
      public function PostBase()
      {
         super();
      }
      
      protected function loaderURL(param1:Array) : URLLoader
      {
         var _loc3_:URLLoader = new URLLoader();
         var _loc4_:URLRequest = new URLRequest(gateway);
         var _loc2_:URLVariables = new URLVariables();
         _loc4_.data = _loc2_;
         _loc4_.method = "POST";
         _loc2_.sid = Constants.sid;
         _loc2_.win_param = genParam(param1);
         Application.instance.log("PostBase",JSON.stringify(_loc2_));
         _loc3_.load(_loc4_);
         return _loc3_;
      }
      
      protected function genParam(param1:Array) : String
      {
         var _loc2_:Object = {};
         _loc2_["mid"] = mid;
         _loc2_["sitekey"] = null;
         _loc2_["group"] = "";
         _loc2_["mnick"] = "";
         _loc2_["key"] = key;
         _loc2_["method"] = param1[0];
         _loc2_["param"] = param1[1];
         return JSON.stringify(_loc2_);
      }
      
      protected function Keyexpired(param1:String) : void
      {
         if(param1 == "false")
         {
            trace("Keyexpired");
         }
      }
      
      public function get gateway() : String
      {
         return Constants.WebGateway;
      }
      
      public function get mid() : int
      {
         return LoginData.instance.mid;
      }
      
      public function get key() : String
      {
         return LoginData.instance.key;
      }
   }
}

