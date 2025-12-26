package com.boyaa.antwars.view.login
{
   import com.boyaa.antwars.helper.StringUtil;
   import com.boyaa.antwars.net.socialplatform.ISocialPlatform;
   import com.boyaa.antwars.net.socialplatform.TXWeibo;
   import com.boyaa.debug.Logging.LevelLogger;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.LocationChangeEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.media.StageWebView;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import org.osflash.signals.Signal;
   
   public class SocialPlatformLogin
   {
      
      public var loginStartSignal:Signal;
      
      public var loginCompleteSignal:Signal;
      
      private var loginUrl:String;
      
      private var isStart:Boolean = false;
      
      private var webView:StageWebView = null;
      
      private var _sprite:Sprite = null;
      
      private var _close:Sprite = null;
      
      private var _stage:Stage = null;
      
      private var mViewPort:Rectangle;
      
      private var sdkobj:ISocialPlatform = null;
      
      public function SocialPlatformLogin(param1:String, param2:Stage, param3:Rectangle)
      {
         super();
         var _loc4_:* = param1;
         if("QQ" !== _loc4_)
         {
            sdkobj = TXWeibo.instance;
         }
         else
         {
            sdkobj = TXWeibo.instance;
         }
         loginUrl = sdkobj.loginUrl();
         loginStartSignal = new Signal();
         loginCompleteSignal = new Signal(uint,String);
         _stage = param2;
         mViewPort = param3;
      }
      
      public function login() : void
      {
         var _loc2_:int = mViewPort.width - 100;
         var _loc1_:int = mViewPort.height - 100;
         var _loc4_:int = mViewPort.x + (mViewPort.width >> 1) - (_loc2_ >> 1);
         var _loc3_:int = mViewPort.y + (mViewPort.height >> 1) - (_loc1_ >> 1);
         addDlg(_loc4_,_loc3_,_loc2_,_loc1_);
         addWebView(_loc4_,_loc3_,_loc2_,_loc1_);
      }
      
      private function addDlg(param1:int, param2:int, param3:int, param4:int) : void
      {
         _sprite = new Sprite();
         _sprite.graphics.beginFill(0,0.5);
         _sprite.graphics.drawRoundRect(param1 - 10,param2 - 10,param3 + 20,param4 + 20,10);
         _sprite.graphics.endFill();
         _close = new Sprite();
         var _loc5_:Bitmap = new Assets.Close();
         _close.addChild(_loc5_);
         _close.width = 30;
         _close.height = 30;
         _close.x = param1 - 10 + param3 + 5;
         _close.y = param2 - 25;
         _close.addEventListener("click",onClose);
         _stage.addChild(_sprite);
         _stage.addChild(_close);
      }
      
      private function addWebView(param1:int, param2:int, param3:int, param4:int) : void
      {
         isStart = false;
         webView = new StageWebView();
         webView.stage = _stage;
         webView.viewPort = new Rectangle(param1,param2,param3,param4);
         webView.loadURL(loginUrl);
         webView.addEventListener("locationChange",onLocationChange);
         webView.addEventListener("locationChanging",onLocationChanging);
      }
      
      private function onLocationChange(param1:LocationChangeEvent) : void
      {
         var _loc5_:* = 0;
         var _loc6_:String = null;
         LevelLogger.getLogger("SocialPlatformLogin").info("url:" + param1.location);
         var _loc4_:Array = param1.location.split("?");
         var _loc3_:String = _loc4_[1];
         var _loc7_:String = _loc4_[0];
         if(isStart && _loc7_ == loginUrl)
         {
            clearObj("hidden");
            loginStartSignal.dispatch();
         }
         if(_loc7_.indexOf("qq.com") != -1)
         {
            isStart = true;
         }
         var _loc2_:String = StringUtil.getQueryStringVar(_loc3_,"status");
         if(_loc2_ == "1000")
         {
            clearObj();
            sdkobj.setRefreshToken(StringUtil.getQueryStringVar(_loc3_,"refresh_token"));
            sdkobj.setAccessToken(StringUtil.getQueryStringVar(_loc3_,"access_token"));
            _loc5_ = parseInt(StringUtil.getQueryStringVar(_loc3_,"mid"));
            _loc6_ = StringUtil.getQueryStringVar(_loc3_,"key");
            loginCompleteSignal.dispatch(_loc5_,_loc6_);
         }
      }
      
      private function onLocationChanging(param1:LocationChangeEvent) : void
      {
         if(param1.location.indexOf("12113") == -1 && param1.location.indexOf(loginUrl) == -1)
         {
            param1.preventDefault();
            navigateToURL(new URLRequest(param1.location));
         }
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         clearObj();
      }
      
      private function clearObj(param1:String = "") : void
      {
         if(_sprite)
         {
            _sprite.stage && _sprite.stage.removeChild(_sprite);
            _sprite = null;
         }
         if(_close)
         {
            _close.stage && _close.stage.removeChild(_close);
            _close.hasEventListener("click") && _close.removeEventListener("click",onClose);
            _close = null;
         }
         if(webView)
         {
            webView.hasEventListener("locationChanging") && webView.removeEventListener("locationChanging",onLocationChanging);
            if(param1 == "hidden")
            {
               webView.stage = null;
            }
            else
            {
               webView.hasEventListener("locationChange") && webView.removeEventListener("locationChange",onLocationChange);
               webView.dispose();
               webView = null;
            }
         }
      }
   }
}

