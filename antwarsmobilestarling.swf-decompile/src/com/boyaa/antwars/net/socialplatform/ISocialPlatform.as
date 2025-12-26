package com.boyaa.antwars.net.socialplatform
{
   public interface ISocialPlatform
   {
      
      function loginUrl() : String;
      
      function setAccessToken(param1:String) : void;
      
      function setRefreshToken(param1:String) : void;
      
      function getUserInfo() : Object;
      
      function sendFeed() : Boolean;
   }
}

