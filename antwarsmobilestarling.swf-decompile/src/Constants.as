package
{
   import com.boyaa.antwars.helper.MathHelper;
   import flash.geom.Point;
   import starling.errors.AbstractClassError;
   
   public class Constants
   {
      
      public static const STAGE_WIDTH:int = 1365;
      
      public static const STAGE_HEIGHT:int = 768;
      
      public static const IsPrintMsgInPhone:Boolean = true;
      
      private static var _isLoginByKey:Boolean = true;
      
      public static var scaleFactor:Number;
      
      public static var isPC:Boolean;
      
      private static var _SiteVersion:String = "91I-IOS";
      
      public static const umengKey:String = "536c920d56240b0a7906fe5d";
      
      public static const debugShowScreen:Boolean = false;
      
      private static var _IpAddress:String = "http://192.168.100.170/";
      
      public static const paymentAndroidSid:int = 7;
      
      public static const paymentAndroidAppId:int = 243;
      
      public static const paymentIOSSid:int = 5;
      
      public static const paymentIOSAppid:int = 278;
      
      public static const weiboAppKey:String = "983903430";
      
      public static const weiboAppSecret:String = "1bf8c1adcaebce64468fb53cff9362b1";
      
      public static const weiboRURL:String = "http://www.sina.com";
      
      private static var _sid:int = 138;
      
      private static var _ActivityWebURL:String = "http://pclpvnat01.boyaagame.com/?m=activities&api=";
      
      public static const MapSavePathName:String = "MAP_SMALL";
      
      public static const SaveMapPath:String = "res/MAP_SMALL/";
      
      public static const Gravity:Number = 1.2;
      
      public static const starR:Number = 130;
      
      public static const fontNames:String = "Verdana,Heiti SC,Helvetica Neue,Helvetica,Roboto,Arial,_sans";
      
      public static const ENERGY_VALUE:int = 3;
      
      public static const NORMAL:String = "normal";
      
      public static const HERO:String = "hero";
      
      public static var isFresh:Boolean = false;
      
      public static const CONST_ARR:Array = [3,false,false,1];
      
      private static var _isLocal:Boolean = CONST_ARR[2];
      
      public static const versionArr:Array = ["","zh","facebookvn","facebookid"];
      
      public static const lanVersion:int = CONST_ARR[0];
      
      public static const debug:Boolean = CONST_ARR[1];
      
      public static const paywebsite:String = IpAddress + "mobile/pay.php";
      
      public static const mgid:int = CONST_ARR[3];
      
      public static const StartURL:String = IpAddress + "mobile/start.php";
      
      public static const QQLoginURL:String = IpAddress + "mobile/txlogin.php";
      
      private static var _DeviceLoginURL:String = IpAddress + "mobile/devicelogin.php";
      
      private static var _TestLoginURL:String = IpAddress + "mobile/testlogin.php" + "?clearsession=1&sid=111";
      
      private static var _WebGateway:String = IpAddress + "api/flashapi.php" + "?clearsession=1&sid=111";
      
      public static const MapUrl:String = ResUrl + "MAP_SMALL";
      
      private static var _ResUrl:String = IpAddress + "version/" + versionArr[lanVersion];
      
      public static const bornPoint:Point = new Point(500,300);
      
      public function Constants()
      {
         super();
         throw new AbstractClassError();
      }
      
      public static function getGoodsNameById(param1:uint = 0) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case 6:
               _loc2_ = "Helm";
               break;
            case 7:
               _loc2_ = "Glove";
               break;
            case 1:
               _loc2_ = "Clothes";
               break;
            case 2:
               _loc2_ = "Shoes";
               break;
            case 8:
               _loc2_ = "wing";
               break;
            case 4:
               _loc2_ = "Ring";
               break;
            case 11:
               _loc2_ = "weapon";
               break;
            case 16:
               _loc2_ = "liliang";
               break;
            case 17:
               _loc2_ = "minjie";
               break;
            case 18:
               _loc2_ = "tizhi";
               break;
            case 19:
               _loc2_ = "xingyun";
               break;
            case 20:
               _loc2_ = "jiacheng";
               break;
            case 42:
               _loc2_ = "Energy";
               break;
            case 34:
               _loc2_ = "MissionGoods";
               break;
            case 36:
               _loc2_ = "SuitCard";
               break;
            case 25:
               _loc2_ = "GiftBag";
               break;
            case 8:
               _loc2_ = "wing";
               break;
            case 26:
               _loc2_ = "TreasureChests";
               break;
            case 15:
               _loc2_ = "Stone";
               break;
            case 40:
               _loc2_ = "Crystal";
               break;
            case 5:
               _loc2_ = "Necklace";
         }
         return _loc2_;
      }
      
      public static function makeName(param1:uint) : String
      {
         var _loc4_:String = "";
         var _loc3_:String = "";
         if(param1 == 0)
         {
            _loc3_ = "姜|戚|谢|皱|喻|珀|水|云|毕|米|贝|童|娄|危|沈|路|幕";
            _loc4_ = "德|倾|乐|牛|端|成|海|天|窝|栝|明|州|金|琵|苳|炎|融";
         }
         else
         {
            _loc3_ = "李|米|丁|丘|甘|彦|闫|萧|董|武|姬|冉|劳|冯|崔|程|姚";
            _loc4_ = "瑶|丽|香|娇|花|梅|棠|燕|艳|娜|伦斯|美思|晨|妮|秀|美思|妃";
         }
         var _loc2_:Array = _loc3_.split("|");
         var _loc6_:Array = _loc4_.split("|");
         var _loc5_:int = MathHelper.randomWithinRange(0,1);
         if(_loc5_ == 0)
         {
            return _loc2_[MathHelper.randomWithinRange(0,_loc2_.length - 1)] + _loc6_[MathHelper.randomWithinRange(0,_loc6_.length - 1)];
         }
         return _loc2_[MathHelper.randomWithinRange(0,_loc2_.length - 1)] + _loc6_[MathHelper.randomWithinRange(0,_loc6_.length - 1)] + _loc6_[MathHelper.randomWithinRange(0,_loc6_.length - 1)];
      }
      
      public static function getChannelId() : int
      {
         var _loc1_:Object = getChannelApp();
         return _loc1_.id;
      }
      
      public static function getChannelApp() : Object
      {
         switch(SiteVersion)
         {
            case "slb-cc-Android":
               return {
                  "id":1,
                  "appid":101270,
                  "key":"9384ed3646284cc181a4958dfd649a71"
               };
            case "91I-IOS":
               if(Application.instance.isTable())
               {
                  return {
                     "id":2,
                     "appid":0,
                     "key":""
                  };
               }
               return {
                  "id":3,
                  "appid":0,
                  "key":""
               };
               break;
            case "KuaiYong-IOS":
               return {
                  "id":4,
                  "appid":0,
                  "key":""
               };
            case "anzhi-cc-Android":
               return {
                  "id":5,
                  "appid":101261,
                  "key":"671efd2bd68d600ffaa3f1b089c83bea"
               };
            case "appchina-cc-Android":
               return {
                  "id":6,
                  "appid":101262,
                  "key":"c2901382f7da53046b689e1102b1947f"
               };
            case "baidu-cc-Android":
               return {
                  "id":7,
                  "appid":101263,
                  "key":"038caf902d1d3d3e718fbcea223226da"
               };
            case "hiapk-cc-Android":
               return {
                  "id":8,
                  "appid":101264,
                  "key":"1e1f84fc080a7119f0d8674b8bd8e2a1"
               };
            case "jifeng-cc-Android":
               return {
                  "id":9,
                  "appid":101265,
                  "key":"3a0c5deb6fe5b4ab35544e6142d9d37e"
               };
            case "360-cc-Android":
               return {
                  "id":10,
                  "appid":101266,
                  "key":"4e950b75a736f5ea8b58c40b0faea97b"
               };
            case "wdj-cc-Android":
               return {
                  "id":11,
                  "appid":101267,
                  "key":"46016895eadb9147d2ab0081ddbafaca"
               };
            case "yingyongbao-cc-Android":
               return {
                  "id":12,
                  "appid":101268,
                  "key":"fcbf36d53b68b141293f6e6b78d2e014"
               };
            case "appota-Android":
            case "xiaomi-cc-Android":
               break;
            case "facebook-id-Android":
               return {
                  "id":4,
                  "appid":0,
                  "key":""
               };
            default:
               return {
                  "id":100,
                  "appid":0,
                  "key":""
               };
         }
         return {
            "id":13,
            "appid":101269,
            "key":"b5a4f9b4454f62661f5b7891c4adc1ca"
         };
      }
      
      public static function get TestLoginURL() : String
      {
         if(_isLocal)
         {
            _TestLoginURL = IpAddress + "mobile/testlogin.php" + "?clearsession=1&sid=" + sid.toString();
         }
         else
         {
            _TestLoginURL = IpAddress + "mobile/testlogin.php";
         }
         return _TestLoginURL;
      }
      
      public static function get WebGateway() : String
      {
         if(_isLocal)
         {
            _WebGateway = IpAddress + "api/flashapi.php" + "?clearsession=1&sid=" + sid.toString();
         }
         else
         {
            _WebGateway = IpAddress + "api/flashapi.php";
         }
         return _WebGateway;
      }
      
      public static function get IpAddress() : String
      {
         var _loc1_:String = null;
         _loc1_ = "antwarsmobile/";
         if(_isLocal)
         {
            _IpAddress = "http://192.168.100.170/antwarsmobile/";
         }
         else
         {
            switch(lanVersion - 2)
            {
               case 0:
                  _IpAddress = "http://pclpvnat02.boyaagame.com/antwarsmobile/";
                  break;
               case 1:
                  _IpAddress = "http://mvlpidat01.boyaagame.com/antwarsmobile/";
            }
         }
         return _IpAddress;
      }
      
      public static function get sid() : int
      {
         switch(lanVersion - 2)
         {
            case 0:
               _sid = 110;
               break;
            case 1:
               _sid = 111;
         }
         return _sid;
      }
      
      public static function get DeviceLoginURL() : String
      {
         if(_isLocal)
         {
            _DeviceLoginURL = IpAddress + "mobile/devicelogin.php" + "?clearsession=1&sid=" + sid.toString();
         }
         else
         {
            _DeviceLoginURL = IpAddress + "mobile/devicelogin.php";
         }
         return _DeviceLoginURL;
      }
      
      public static function get ResUrl() : String
      {
         if(_isLocal)
         {
            _ResUrl = IpAddress + "version/" + versionArr[lanVersion] + "/";
         }
         else
         {
            _ResUrl = IpAddress + "publish/" + versionArr[lanVersion] + "/";
         }
         return _ResUrl;
      }
      
      public static function get SiteVersion() : String
      {
         if(lanVersion == 3)
         {
            _SiteVersion = "facebook-id-Android";
         }
         return _SiteVersion;
      }
      
      public static function get ActivityWebURL() : String
      {
         if(lanVersion == 2)
         {
            _ActivityWebURL = "http://pclpvnat01.boyaagame.com/?m=activities&api=";
         }
         else if(lanVersion == 3)
         {
            if(_isLocal)
            {
               _ActivityWebURL = "http://192.168.204.68/operating/web/index.php?m=activities&appid=9201&api=";
            }
            else
            {
               _ActivityWebURL = "http://pclpidat01.boyaagame.com/?m=activities&appid=9201&api=";
            }
         }
         return _ActivityWebURL;
      }
      
      public static function get PaymentInfoUrl() : String
      {
         if(lanVersion == 3)
         {
            return IpAddress + "mobile/get_products.php" + "?sid=" + sid;
         }
         return "";
      }
      
      public static function get isLocal() : Boolean
      {
         return _isLocal;
      }
      
      public static function get SkelotonDataNameArr() : Array
      {
         return ["hats","prop","charcher_boy","charcher_girl","dragon","worm","spider","zhunhuang","sprite","Leien","LeienSkillEffect","hallAni","weddingOpen","firework","scorpionKind"];
      }
      
      public static function get isLoginByKey() : Boolean
      {
         if(!isLocal)
         {
            return false;
         }
         return _isLoginByKey;
      }
   }
}

