package com.boyaa.antwars.data
{
   import com.adobe.crypto.MD5;
   import com.boyaa.ane.SystemProperties;
   import com.boyaa.antwars.helper.StringUtil;
   import com.freshplanet.ane.AirFacebook.Facebook;
   import flash.net.SharedObject;
   
   public class LoginData
   {
      
      private static var _instance:LoginData = null;
      
      private var so:SharedObject;
      
      public var mid:uint = 0;
      
      public var key:String = "";
      
      public var method:int;
      
      public var sid:String;
      
      public var assesToken:String;
      
      public var debug_sid:String = "bd7c7a7cd1c2498416b3ccc72686b37b";
      
      public var debug_method:int = 4;
      
      public function LoginData(param1:Single)
      {
         super();
      }
      
      public static function get instance() : LoginData
      {
         if(_instance == null)
         {
            _instance = new LoginData(new Single());
         }
         return _instance;
      }
      
      public function init() : void
      {
         so = SharedObject.getLocal("Antwars/LoginData");
         if(Constants.debug)
         {
            sid = so.data["sid"];
            method = so.data["method"];
            assesToken = so.data["assesToken"];
         }
      }
      
      public function isFirstLogin() : Boolean
      {
         if(!so.data["isfirst"])
         {
            so.data["isfirst"] = 1;
            so.flush();
            return true;
         }
         return false;
      }
      
      public function setSidAndMethod(param1:String, param2:int, param3:String) : void
      {
         this.sid = param1;
         this.method = param2;
         this.assesToken = param3;
         saveToLocal();
      }
      
      public function login(param1:uint, param2:String) : void
      {
         this.mid = param1;
         this.key = param2;
      }
      
      public function logout() : void
      {
         if(this.method == 2)
         {
            Application.instance.weiboApi.logOut();
         }
         else if(this.method == 3)
         {
            SystemProperties.boyaaLogout();
         }
         else if(this.method == 4)
         {
            if(!Constants.debug)
            {
               SystemProperties.appotaLogout();
            }
         }
         else if(this.method == 5)
         {
            if(!Constants.debug)
            {
               Facebook.getInstance().closeSessionAndClearTokenInformation();
            }
         }
         this.mid = 0;
         this.key = "";
         this.sid = "";
         this.method = 0;
         this.assesToken = "";
         clearLocal();
      }
      
      public function isLogin() : Boolean
      {
         return sid != "" && method != 0;
      }
      
      public function mkSiteMid() : String
      {
         if(method == 2)
         {
            return MD5.hash("weibo_" + StringUtil.trim(sid));
         }
         return MD5.hash(StringUtil.trim(sid));
      }
      
      private function saveToLocal() : void
      {
         so.data["sid"] = sid;
         so.data["method"] = method;
         so.data["assesToken"] = assesToken;
         so.flush();
      }
      
      private function clearLocal() : void
      {
         so.data["sid"] = null;
         so.data["method"] = null;
         so.flush();
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
