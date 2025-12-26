package com.boyaa.antwars.view.login
{
   import com.boyaa.ane.NCApiEvent;
   import com.boyaa.ane.SystemProperties;
   import com.boyaa.antwars.data.LoginData;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.ui.MCButton;
   import com.boyaa.tool.Tiptext;
   import com.freshplanet.ane.AirDeviceId;
   import com.freshplanet.ane.AirFacebook.Facebook;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.NetworkInfo;
   import flash.net.NetworkInterface;
   import swcs.screen.LoginScreen;
   
   public class LoginManager
   {
      
      public static const STATE_START:String = "STATE_START";
      
      public static const STATE_COMPLETE:String = "STATE_COMPLETE";
      
      private var appotaInitStat:Boolean = false;
      
      private var mLoginScreen:LoginScreen;
      
      private var socialLoginObj:SocialPlatformLogin = null;
      
      private var deviceLoginObj:DeviceLogin = null;
      
      private var testLoginObj:TestLogin = null;
      
      private var deviceLogin:MCButton;
      
      private var weiboLogin:MCButton;
      
      private var qqLogin:MCButton;
      
      private var faceBookLogin:MCButton;
      
      private var nonetLogin:MCButton;
      
      private var _stage:DisplayObjectContainer = null;
      
      private var mViewPort:Rectangle;
      
      public function LoginManager(param1:DisplayObjectContainer, param2:Rectangle)
      {
         super();
         _stage = param1;
         mViewPort = param2;
         mLoginScreen = new LoginScreen();
         mLoginScreen.width = mViewPort.width;
         mLoginScreen.height = mViewPort.height;
         mLoginScreen.x = mViewPort.x;
         mLoginScreen.y = mViewPort.y;
         weiboLogin = new MCButton(mLoginScreen.weibologin);
         switch(Constants.lanVersion - 1)
         {
            case 0:
               deviceLogin = new MCButton(mLoginScreen.devicelogin);
               qqLogin = new MCButton(mLoginScreen.qqlogin);
               break;
            case 2:
               deviceLogin = new MCButton(mLoginScreen.loginButtons["devicelogin"]);
               faceBookLogin = new MCButton(mLoginScreen.loginButtons["faceBooklogin"]);
               weiboLogin.btnView.visible = false;
               if(Facebook.isSupported)
               {
                  Facebook.getInstance().init("319435948181260");
                  Facebook.getInstance().logEnabled = true;
                  if(Facebook.getInstance().isSessionOpen)
                  {
                     onFaceBookLoginResult(true,false,null);
                  }
               }
         }
      }
      
      public function addToStage() : void
      {
         _stage.addChild(mLoginScreen);
         weiboLogin.click = onWeibologin;
         switch(Constants.lanVersion - 1)
         {
            case 0:
               deviceLogin.click = onDevicelogin;
               qqLogin.click = onQQlogin;
               break;
            case 2:
               deviceLogin.click = onDevicelogin;
               faceBookLogin.click = onFaceBookLogin;
         }
      }
      
      public function removeToStage() : void
      {
         if(mLoginScreen.parent)
         {
            mLoginScreen.parent.removeChild(mLoginScreen);
            weiboLogin.click = null;
            switch(Constants.lanVersion - 1)
            {
               case 0:
                  deviceLogin.click = null;
                  qqLogin.click = null;
                  break;
               case 2:
                  deviceLogin.click = null;
                  faceBookLogin.click = null;
            }
         }
      }
      
      public function login() : void
      {
         if(Constants.isPC)
         {
            if(LoginData.instance.isLogin())
            {
               switch(Constants.lanVersion - 2)
               {
                  case 0:
                     appotaInit();
                     sidToMid(LoginData.instance.sid,"",LoginData.instance.method);
                     break;
                  case 1:
                     if(LoginData.instance.assesToken != "" && LoginData.instance.assesToken != null)
                     {
                        onFaceBookLogin();
                        break;
                     }
                     sidToMid(LoginData.instance.sid,"",1,LoginData.instance.assesToken);
               }
            }
            else
            {
               addToStage();
            }
         }
         else
         {
            addToStage();
         }
      }
      
      private function onTXLogin(param1:MouseEvent) : void
      {
      }
      
      private function onDevicelogin(param1:MouseEvent = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc5_:NetworkInfo = null;
         var _loc4_:* = undefined;
         if(Constants.debug)
         {
            if(Constants.isPC)
            {
               _loc5_ = NetworkInfo.networkInfo;
               _loc4_ = _loc5_.findInterfaces();
               _loc2_ = Math.random().toString() + "debug_ip_" + _loc4_[0].addresses[0].address;
               _loc3_ = "debug";
            }
            else
            {
               _loc2_ = "20_test1111";
               _loc3_ = "test";
            }
         }
         else
         {
            if(Constants.lanVersion == 2)
            {
               _loc2_ = SystemProperties.getOpenUDID();
            }
            else if(Constants.lanVersion == 3)
            {
               _loc2_ = AirDeviceId.getInstance().getID("antwars");
            }
            _loc3_ = Constants.makeName(0);
         }
         switch(Constants.lanVersion - 1)
         {
            case 1:
               sidToMid(_loc2_,_loc3_,4);
               break;
            case 2:
               if(Constants.isLocal)
               {
                  if(LoginData.instance.sid == null)
                  {
                     LoginData.instance.sid = Math.random().toString();
                  }
                  sidToMid(LoginData.instance.sid,"",1,LoginData.instance.assesToken);
                  break;
               }
               sidToMid(_loc2_,_loc3_,1);
         }
      }
      
      private function onWeibologin(param1:MouseEvent = null) : void
      {
         var e:MouseEvent = param1;
         if(Constants.debug)
         {
            return onDevicelogin();
         }
         weiboLogin.btnView.mouseEnabled = false;
         switch(Constants.lanVersion - 2)
         {
            case 0:
               if(!appotaInitStat)
               {
                  Timepiece.instance.addDelayCall(function():void
                  {
                     weiboLogin.btnView.mouseEnabled = true;
                  },2000);
                  appotaInit();
               }
               else
               {
                  Timepiece.instance.addDelayCall(function():void
                  {
                     weiboLogin.btnView.mouseEnabled = true;
                  },500);
               }
               SystemProperties.appotaLogin();
               break;
            case 1:
               if(LoginData.instance.assesToken != "")
               {
                  onFaceBookLogin();
                  break;
               }
               onDevicelogin();
         }
      }
      
      private function appotaInit() : void
      {
         if(Constants.debug)
         {
            return;
         }
         if(appotaInitStat)
         {
            return;
         }
         if(Application.instance.iOS)
         {
            Application.instance.log("appotaInit","appotaIosInit");
            SystemProperties.appotaIosInit("9012be26944f022a13eefca52a91e7fa053a1033f","d81960d866d5d77e5eca8f29b1f06710053a1033f","3909c1ad83a4373af6b8f21727de5d71053a1033f","mid:0|ptype:1","","http://120.132.145.35/antwarsmobile/appotaConfig.json",function(param1:String, param2:String):void
            {
               var _loc3_:Object = null;
               var _loc4_:* = param1;
               if("AppotaLoginEvent" === _loc4_)
               {
                  _loc3_ = JSON.parse(param2);
                  sidToMid(_loc3_.user_id,_loc3_.username,4);
               }
               Application.instance.log("LoginManager",param1 + ":" + param2);
            });
         }
         else
         {
            SystemProperties.appotaInit("http://120.132.145.35/antwarsmobile/appotaConfig.json","","b813c82b22e635f38a5e0cdf0eb548620534bc5d3","",function(param1:String, param2:String):void
            {
               var _loc3_:Object = null;
               var _loc4_:* = param1;
               if("AppotaLoginEvent" === _loc4_)
               {
                  _loc3_ = JSON.parse(param2);
                  sidToMid(_loc3_.user_id,_loc3_.username,4);
               }
               Application.instance.log("LoginManager",param1 + ":" + param2);
            });
         }
         appotaInitStat = true;
      }
      
      private function onQQlogin(param1:MouseEvent = null) : void
      {
         var e:MouseEvent = param1;
         if(Constants.lanVersion != 1)
         {
            return;
         }
         if(Application.instance.isAndroid())
         {
            SystemProperties.boyaaLogin("1362118100","SCmj123!@#z19_8a*AoDk1!@#zB9_=BB","虫虫特攻队","http://91spat01.static.17c.cn/91antwars/icons/icon_114.png",function(param1:String):void
            {
               var _loc2_:Object = JSON.parse(param1);
               if(_loc2_.isGuest)
               {
                  onDevicelogin();
                  return;
               }
               if(_loc2_.isLogined)
               {
                  sidToMid(_loc2_.bid,Constants.makeName(0),3);
               }
               else
               {
                  new Tiptext(LangManager.t("loginFail"));
               }
            });
         }
         else
         {
            new Tiptext(LangManager.t("unpoen"));
         }
      }
      
      private function onLogging(param1:NCApiEvent) : void
      {
         Application.instance.log("LoginManager onLogging",param1.getParam());
      }
      
      private function onRequestComplete(param1:NCApiEvent) : void
      {
         var _loc2_:Object = JSON.parse(param1.getParam());
         if((_loc2_.url as String).indexOf("users/show.json") != -1)
         {
            Application.instance.weiboApi.removeEventListener("requestComplete",onRequestComplete);
            Application.instance.log("LoginManager requestComplete",param1.getParam());
            if(_loc2_.ret == 0)
            {
               sidToMid(_loc2_.data.id,_loc2_.data.screen_name,2);
            }
            else
            {
               new Tiptext(LangManager.t("loginFail"));
            }
         }
      }
      
      private function onSinaWeiboLogin(param1:NCApiEvent) : void
      {
         Application.instance.weiboApi.removeEventListener("sinaweiboDidLogIn",onSinaWeiboLogin);
         Application.instance.log("LoginManager",param1.getParam());
         var _loc3_:String = param1.getParam();
         var _loc2_:Object = JSON.parse(_loc3_);
         if(_loc2_.hasOwnProperty("ret") && _loc2_.ret == 0)
         {
            Application.instance.weiboApi.requestWithURL("users/show.json","uid=" + _loc2_.UserID,"GET");
         }
         else if(_loc2_.hasOwnProperty("uid"))
         {
            sidToMid(_loc2_.uid,Constants.makeName(0),2);
         }
         else
         {
            new Tiptext(LangManager.t("loginFail"));
         }
      }
      
      private function onFaceBookLogin(param1:MouseEvent = null) : void
      {
         if(Constants.debug)
         {
            return;
         }
         facebookConnect();
      }
      
      private function facebookConnect() : void
      {
         Facebook.getInstance().openSessionWithReadPermissions([],onFaceBookLoginResult);
      }
      
      private function onFaceBookLoginResult(param1:Boolean, param2:Boolean, param3:String) : void
      {
         var success:Boolean = param1;
         var userCancelled:Boolean = param2;
         var error:String = param3;
         Application.instance.log("onFacebookLoginResult:",success.toString() + " error:" + error);
         if(!success && error)
         {
            new Tiptext("Session opening error");
            return;
         }
         if(success)
         {
            Facebook.getInstance().requestWithGraphPath("/me",null,"GET",(function():*
            {
               var callBack:Function;
               return callBack = function(param1:Object):void
               {
                  Application.instance.log("onFaceBookLoginResult",JSON.stringify(param1));
                  sidToMid(param1.id,param1.name,5,param1.accessToken);
               };
            })());
         }
      }
      
      private function onNoNetLogin(param1:MouseEvent) : void
      {
         nonetLogin.click = null;
         testLoginObj = new TestLogin();
         testLoginObj.loginStartSignal.addOnce(loginStart);
         testLoginObj.loginCompleteSignal.addOnce(NoNetLoginHandle);
         testLoginObj.login();
      }
      
      private function NoNetLoginHandle(param1:int, param2:String) : void
      {
         LoginData.instance.login(param1,param2);
         loginComplete();
         loginComplete();
      }
      
      private function loginStart() : void
      {
         Application.instance.currentMain.loginStateChange("STATE_START");
      }
      
      private function sidToMid(param1:String, param2:String, param3:int, param4:String = "") : void
      {
         var sid:String = param1;
         var name:String = param2;
         var pid:int = param3;
         var assesToken:String = param4;
         loginStart();
         LoginData.instance.setSidAndMethod(sid,pid,assesToken);
         Remoting.login(sid,name,pid,function(param1:int, param2:String):void
         {
            Application.instance.log("Login","mid:" + param1 + " key:" + param2);
            if(param1 != 0 && param2 != "")
            {
               Remoting.instance.apkPromo(2);
               LoginData.instance.login(param1,param2);
               loginComplete();
            }
            else
            {
               Application.instance.currentMain.start();
               Application.instance.systemAlert(LangManager.t("systemTip"),LangManager.t("loginFailure"),[LangManager.t("sure"),""]);
            }
         },assesToken);
      }
      
      private function loginComplete() : void
      {
         Application.instance.currentMain.loginStateChange("STATE_COMPLETE");
      }
   }
}

