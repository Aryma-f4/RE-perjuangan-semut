package com.boyaa.antwars.net.socialplatform
{
   public class TXWeibo implements ISocialPlatform
   {
      
      private static var _instance:TXWeibo = null;
      
      private var access_token:String;
      
      private var refresh_token:String;
      
      public function TXWeibo(param1:Single)
      {
         super();
      }
      
      public static function get instance() : TXWeibo
      {
         if(_instance == null)
         {
            _instance = new TXWeibo(new Single());
         }
         return _instance;
      }
      
      public function loginUrl() : String
      {
         return Constants.QQLoginURL;
      }
      
      public function getUserInfo() : Object
      {
         return {};
      }
      
      public function sendFeed() : Boolean
      {
         return true;
      }
      
      public function setAccessToken(param1:String) : void
      {
         this.access_token = param1;
      }
      
      public function setRefreshToken(param1:String) : void
      {
         this.refresh_token = param1;
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
