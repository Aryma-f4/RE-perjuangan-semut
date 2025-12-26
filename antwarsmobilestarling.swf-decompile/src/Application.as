package
{
   import com.boyaa.ane.SystemProperties;
   import com.boyaa.ane.UmengApi;
   import com.boyaa.ane.WeiboApi;
   import com.boyaa.antwars.data.LoginData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.debug.Debug;
   import com.boyaa.debug.Logging.LevelLogger;
   import com.freshplanet.ane.AirAlert.AirAlert;
   import feathers.system.DeviceCapabilities;
   import flash.desktop.NativeApplication;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.InvokeEvent;
   import flash.events.StatusEvent;
   import flash.geom.Rectangle;
   import flash.net.NetworkInfo;
   import flash.net.NetworkInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import starling.core.Starling;
   
   public class Application
   {
      
      private static var _instance:Application = null;
      
      private var activateFuns:Array = null;
      
      private var exitingFuns:Array = null;
      
      public var application:NativeApplication;
      
      private var _version:String = "";
      
      public var resManager:ResManager;
      
      public var currentGame:Game;
      
      public var currentMain:Main;
      
      public var umengApi:UmengApi;
      
      public var iOS:Boolean = true;
      
      private var _weiboApi:WeiboApi;
      
      private var bBgSound:Boolean = true;
      
      private var bSound:Boolean = true;
      
      private var soundFirst:int = 0;
      
      private var _stage:Stage = null;
      
      private var _viewPort:Rectangle = null;
      
      public function Application(param1:Single)
      {
         super();
         application = NativeApplication.nativeApplication;
         application.systemIdleMode = "keepAwake";
         iOS = Capabilities.manufacturer.indexOf("iOS") != -1;
      }
      
      public static function get instance() : Application
      {
         if(_instance == null)
         {
            _instance = new Application(new Single());
         }
         return _instance;
      }
      
      public function get version() : String
      {
         if(!_version)
         {
            _version = (iOS ? "ios-" : "andorid-") + Constants.scaleFactor.toString() + "-" + resManager.packageVersion + "." + resManager.localVersion + "." + resManager.serverVersion + "-" + getAppVersionNamber();
         }
         return _version;
      }
      
      public function isTable() : Boolean
      {
         return DeviceCapabilities.isTablet(_stage);
      }
      
      public function isAndroid() : Boolean
      {
         return !iOS;
      }
      
      public function get weiboApi() : WeiboApi
      {
         if(!_weiboApi)
         {
            _weiboApi = new WeiboApi();
            _weiboApi.init("983903430","1bf8c1adcaebce64468fb53cff9362b1","http://www.sina.com");
         }
         return _weiboApi;
      }
      
      public function get viewPort() : Rectangle
      {
         return _viewPort;
      }
      
      public function init(param1:Stage, param2:Rectangle) : void
      {
         _stage = param1;
         _viewPort = param2;
         activateFuns = [];
         exitingFuns = [];
         application.addEventListener("activate",onActivateOrDeactivate);
         application.addEventListener("deactivate",onActivateOrDeactivate);
         application.addEventListener("exiting",onExiting);
         application.addEventListener("invoke",invokeHandler);
         resManager = new ResManager();
         Debug.init(param1,param2);
         if(!Constants.debug)
         {
            umengApi = new UmengApi();
         }
         if(!Constants.debug && Application.instance.iOS)
         {
            umengApi.init("536c920d56240b0a7906fe5d",0,Constants.SiteVersion);
         }
         SoundManager.init();
         if(!Constants.debug && Constants.lanVersion == 2)
         {
            SystemProperties.initExtension().addEventListener("status",onANEEvent);
         }
         Assets.initScreenPoint(param1,param2);
      }
      
      private function onANEEvent(param1:StatusEvent) : void
      {
         Application.instance.log("ANEEventLog","code:" + param1.code + " level:" + param1.level);
      }
      
      public function setCurrentGame(param1:Game) : void
      {
         currentGame = param1;
      }
      
      public function setCurrentMain(param1:Main) : void
      {
         currentMain = param1;
      }
      
      public function addActivateFun(param1:Function) : void
      {
         activateFuns.push(param1);
      }
      
      public function addExitingFun(param1:Function) : void
      {
         exitingFuns.push(param1);
      }
      
      private function invokeHandler(param1:InvokeEvent) : void
      {
         if(param1.arguments.length > 0)
         {
            if(Constants.lanVersion == 2)
            {
               SystemProperties.appotaHandleOpenUrl(param1.arguments[0]);
            }
            else
            {
               weiboApi.handleOpenUrl(param1.arguments[0]);
            }
         }
      }
      
      private function onActivateOrDeactivate(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Function = null;
         if(param1.type == "deactivate")
         {
            application.systemIdleMode = "normal";
            if(!Constants.isPC)
            {
               Starling.current && Starling.current.stop();
            }
            bBgSound = SoundManager.bgSoundSwitch;
            bSound = SoundManager.soundSwitch;
            soundFirst = 1;
            SoundManager.stopBgSoundInstantly();
            SoundManager.stopActSoundInstantly();
            if(Application.instance.isAndroid() && !Constants.debug)
            {
            }
            if(Application.instance.isAndroid() && !Constants.debug && Constants.scaleFactor == 1)
            {
            }
         }
         else
         {
            application.systemIdleMode = "keepAwake";
            Starling.current && Starling.current.start();
            if(soundFirst != 0)
            {
               SoundManager.bgSoundSwitch = bBgSound;
               SoundManager.soundSwitch = bSound;
            }
            if(Application.instance.isAndroid() && !Constants.debug)
            {
            }
         }
         _loc3_ = 0;
         while(_loc3_ < activateFuns.length)
         {
            _loc2_ = activateFuns[_loc3_];
            if(_loc2_ != null)
            {
               _loc2_(param1.type == "activate");
            }
            _loc3_++;
         }
      }
      
      public function restart() : void
      {
      }
      
      private function onExiting(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Function = null;
         _loc3_ = 0;
         while(_loc3_ < exitingFuns.length)
         {
            _loc2_ = exitingFuns[_loc3_];
            if(_loc2_ != null)
            {
               _loc2_();
            }
            _loc3_++;
         }
      }
      
      public function log(param1:String, param2:String) : void
      {
         LevelLogger.getLogger(param1).info(param2);
      }
      
      public function error(param1:String, param2:String) : void
      {
         LevelLogger.getLogger(param1).error(param2);
      }
      
      public function sendMail(param1:String) : void
      {
         var _loc2_:String = "mailto:leoluo@boyaa.com?subject=" + LangManager.t("fkxx") + "id:" + LoginData.instance.mid + ",ver:" + Application.instance.version + "&body=" + encodeURIComponent(param1);
         navigateToURL(new URLRequest(_loc2_));
      }
      
      public function systemAlert(param1:String, param2:String, param3:Array, param4:Array = null) : void
      {
         if(!Constants.debug)
         {
            if(param3.length > 1)
            {
               AirAlert.getInstance().showAlert(param1,param2,param3[0],param4[0],param3[1],param4[1]);
            }
            else
            {
               AirAlert.getInstance().showAlert(param1,param2,param3[0],param4[0]);
            }
         }
         else
         {
            SystemTip.instance.showSystemAlert(param2,param4[0] is Function ? param4[0] : null,param4[1] is Function ? param4[1] : null);
         }
      }
      
      public function getAppVersionNamber() : String
      {
         var _loc2_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc1_:Namespace = _loc2_.namespace();
         return _loc2_._loc1_::versionNumber;
      }
      
      public function getNetworkName() : String
      {
         if(NetworkInfo.isSupported)
         {
            for each(var _loc1_ in NetworkInfo.networkInfo.findInterfaces())
            {
               if(_loc1_.active)
               {
                  trace(_loc1_.displayName);
                  if(_loc1_.displayName == "WIFI")
                  {
                     return "wifi";
                  }
                  return "mobile";
               }
            }
         }
         return "inactive";
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
