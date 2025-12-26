package com.boyaa.antwars.net
{
   import com.adobe.crypto.MD5;
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.LoginData;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.php.GameCopys;
   import com.boyaa.antwars.net.php.GameMember;
   import com.boyaa.antwars.net.php.GameTable;
   import com.boyaa.debug.Logging.LevelLogger;
   import com.boyaa.tool.Tiptext;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   
   public class Remoting
   {
      
      private static var _instance:Remoting = null;
      
      private var _geteway:String = "";
      
      private var _gameMember:GameMember = null;
      
      private var _gameTable:GameTable = null;
      
      private var _gameCopys:GameCopys = null;
      
      private var _funObject:Object = {};
      
      public function Remoting(param1:Single)
      {
         super();
         _gameMember = new GameMember();
         _gameTable = new GameTable();
         _gameCopys = new GameCopys();
      }
      
      public static function login(param1:String, param2:String, param3:int, param4:Function, param5:String) : void
      {
         var sid:String = param1;
         var name:String = param2;
         var pid:int = param3;
         var callBack:Function = param4;
         var accessToken:String = param5;
         var _loader:URLLoader = new URLLoader();
         var _request:URLRequest = new URLRequest(Constants.debug ? Constants.TestLoginURL : Constants.DeviceLoginURL);
         var _variables:URLVariables = new URLVariables();
         _request.data = _variables;
         _request.method = "POST";
         _variables.sid = sid;
         _variables.name = name;
         _variables.loginMethod = pid;
         _variables.channel = Constants.getChannelId();
         _variables.sign = MD5.hash(_variables.sid + _variables.name + "fcc2f629-817b-4955-94be-ba1da73b3164");
         if(accessToken != null)
         {
            _variables.accessToken = accessToken;
         }
         _loader.addEventListener("complete",(function():*
         {
            var loginLoaderComplete:Function;
            return loginLoaderComplete = function(param1:Event):void
            {
               _loader.removeEventListener("complete",loginLoaderComplete);
               var _loc3_:String = param1.currentTarget.data as String;
               LevelLogger.getLogger("DeviceLogin").info(_loc3_);
               var _loc2_:Object = {};
               try
               {
                  _loc2_ = JSON.parse(_loc3_);
               }
               catch(error:Error)
               {
                  LevelLogger.getLogger("Remoting").error("[login] " + error.toString());
                  _loc2_.error = 119;
                  Application.instance.currentMain.start();
                  Application.instance.systemAlert(LangManager.t("systemTip"),LangManager.t("jsonerror"),[LangManager.t("sure"),""]);
               }
               if(_loc2_.hasOwnProperty("data"))
               {
                  callBack(_loc2_.data.mid,_loc2_.data.key);
               }
            };
         })());
         _loader.addEventListener("ioError",(function():*
         {
            var login_ioError:Function;
            return login_ioError = function(param1:IOErrorEvent):void
            {
               var _loc2_:URLLoader = param1.target as URLLoader;
               _loc2_.removeEventListener("ioError",login_ioError);
               LoginData.instance.logout();
               Application.instance.currentMain.start();
               new Tiptext(LangManager.t("NetError"));
            };
         })());
         _loader.load(_request);
      }
      
      public static function get instance() : Remoting
      {
         if(_instance == null)
         {
            _instance = new Remoting(new Single());
         }
         return _instance;
      }
      
      public function load(param1:Function) : void
      {
         _gameMember.load();
         _funObject["GameMemberLoad"] = param1;
         EventCenter.PHPEvent.addEventListener("GameMemberLoad",onGetData);
      }
      
      public function bindAccount(param1:Array, param2:Function) : void
      {
         _gameMember.bindAccount(param1);
         _funObject["GameBindAccount"] = param2;
         EventCenter.PHPEvent.addEventListener("GameBindAccount",onGetData);
      }
      
      public function gameLog(param1:String) : void
      {
         var _loc2_:* = param1;
         _gameMember.gameLog(_loc2_);
      }
      
      public function create(param1:Array, param2:Function = null) : void
      {
         _gameMember.create(param1);
         _funObject["GameMemberCreate"] = param2;
         EventCenter.PHPEvent.addEventListener("GameMemberCreate",onGetData);
      }
      
      public function getCenterSever(param1:Function) : void
      {
         _gameTable.getServer();
         _funObject["GAME_TABLE_GETSERVER"] = param1;
         EventCenter.PHPEvent.addEventListener("GAME_TABLE_GETSERVER",onGetData);
      }
      
      public function openFreshPack(param1:int, param2:Function) : void
      {
         _gameMember.openFreshPack(param1);
         _funObject["openFreshPack"] = param2;
         EventCenter.PHPEvent.addEventListener("openFreshPack",onGetData);
      }
      
      public function getFirends(param1:int, param2:Function) : void
      {
         _gameMember.getFirends(param1);
         _funObject["getFirends"] = param2;
         EventCenter.PHPEvent.addEventListener("getFirends",onGetData);
      }
      
      public function addFriend(param1:int, param2:Function) : void
      {
         _gameMember.addFriend(param1);
         _funObject["addFriend"] = param2;
         EventCenter.PHPEvent.addEventListener("addFriend",onGetData);
      }
      
      public function deleteFriend(param1:int, param2:Function) : void
      {
         _gameMember.deleteFriend(param1);
         _funObject["deleteFriend"] = param2;
         EventCenter.PHPEvent.addEventListener("deleteFriend",onGetData);
      }
      
      public function resetSignRecord(param1:Function) : void
      {
         _gameMember.resetSignRecord();
         _funObject["getReSignInfo"] = param1;
         EventCenter.PHPEvent.addEventListener("getReSignInfo",onGetData);
      }
      
      public function getNSignInfo(param1:Function) : void
      {
         _gameMember.getNSignInfo();
         _funObject["getSignInfo"] = param1;
         EventCenter.PHPEvent.addEventListener("getSignInfo",onGetData);
      }
      
      public function getNSignGift(param1:Function) : void
      {
         _gameMember.getNSignGift();
         _funObject["getSignGift"] = param1;
         EventCenter.PHPEvent.addEventListener("getSignGift",onGetData);
      }
      
      public function getNSignRewards(param1:Function, param2:int = 0) : void
      {
         _gameMember.getNSignRewards(param2);
         _funObject["getSignRewards"] = param1;
         EventCenter.PHPEvent.addEventListener("getSignRewards",onGetData);
      }
      
      public function getMemStatus(param1:int, param2:Function) : void
      {
         _gameMember.getMemStatus(param1);
         _funObject["getMemStatus"] = param2;
         EventCenter.PHPEvent.addEventListener("getMemStatus",onGetData);
      }
      
      public function getMissionState(param1:Function) : void
      {
         _gameTable.getMissionState();
         _funObject["getMissionState"] = param1;
         EventCenter.PHPEvent.addEventListener("getMissionState",onGetData);
      }
      
      public function suggestion(param1:String, param2:String, param3:Function) : void
      {
         _gameMember.suggestion(param1,param2);
         _funObject["suggestion"] = param3;
         EventCenter.PHPEvent.addEventListener("suggestion",onGetData);
      }
      
      public function indulgeCheck(param1:String, param2:String, param3:Function) : void
      {
         _gameMember.indulgeCheck(param1,param2);
         _funObject["indulgeCheck"] = param3;
         EventCenter.PHPEvent.addEventListener("indulgeCheck",onGetData);
      }
      
      public function getIndulgeInfo(param1:Function) : void
      {
         _gameMember.getIndulgeInfo();
         _funObject["getIndulgeInfo"] = param1;
         EventCenter.PHPEvent.addEventListener("getIndulgeInfo",onGetData);
      }
      
      public function gainReward(param1:int, param2:Array, param3:Function) : void
      {
         _gameTable.gainReward(param1,param2);
         _funObject["gain_reward"] = param3;
         EventCenter.PHPEvent.addEventListener("gain_reward",onGetData);
      }
      
      public function getCopyGrade(param1:Function) : void
      {
         _gameCopys.getCopyGrade();
         _funObject["getCopyGrade"] = param1;
         EventCenter.PHPEvent.addEventListener("getCopyGrade",onGetData);
      }
      
      public function buyBTProp(param1:Array, param2:Function) : void
      {
         _gameCopys.buyBTProp(param1);
         _funObject["buyBTProp"] = param2;
         EventCenter.PHPEvent.addEventListener("buyBTProp",onGetData);
      }
      
      public function backBTProp(param1:Array, param2:Function) : void
      {
         _gameCopys.backBTProp(param1);
         _funObject["backBTProp"] = param2;
         EventCenter.PHPEvent.addEventListener("backBTProp",onGetData);
      }
      
      public function useBTProp(param1:Array, param2:Function) : void
      {
         _gameCopys.useBTProp(param1);
         _funObject["useBTProp"] = param2;
         EventCenter.PHPEvent.addEventListener("useBTProp",onGetData);
      }
      
      public function getWeaponState(param1:Function) : void
      {
         _gameCopys.getPlayerWeaponState();
         _funObject["playerWeaponState"] = param1;
         EventCenter.PHPEvent.addEventListener("playerWeaponState",onGetData);
      }
      
      public function changeWeaponInBox(param1:int, param2:int, param3:Function) : void
      {
         _gameCopys.changeWeaponInBox(param1,param2);
         _funObject["changeWeaponInBox"] = param3;
         EventCenter.PHPEvent.addEventListener("changeWeaponInBox",onGetData);
      }
      
      public function changeWeaponInBattle(param1:int, param2:int, param3:Function) : void
      {
         _gameCopys.changeWeaponInBattle(param1,param2);
         _funObject["changeWeaponInBattle"] = param3;
         EventCenter.PHPEvent.addEventListener("changeWeaponInBattle",onGetData);
      }
      
      public function getMobileCopyPrize(param1:int, param2:int, param3:int, param4:int, param5:int, param6:Function) : void
      {
         _gameCopys.getMobileCopyPrize(param1,param2,param3,param4,param5);
         _funObject["getMobileCopyPrize"] = param6;
         EventCenter.PHPEvent.addEventListener("getMobileCopyPrize",onGetData);
      }
      
      public function getNewWeapon(param1:Function) : void
      {
         _gameMember.getNewWeapon();
         _funObject["getNewWeapon"] = param1;
         EventCenter.PHPEvent.addEventListener("getNewWeapon",onGetData);
      }
      
      public function mobileUpdate(param1:String, param2:Function) : void
      {
         _gameMember.mobileUpdate(param1);
         _funObject["mobileUpdate"] = param2;
         EventCenter.PHPEvent.addEventListener("mobileUpdate",onGetData);
      }
      
      public function getNotice(param1:String, param2:Function) : void
      {
         _gameMember.getNotice(param1);
         _funObject["getNotice"] = param2;
         EventCenter.PHPEvent.addEventListener("getNotice",onGetData);
      }
      
      public function getAccount(param1:Function) : void
      {
         _gameMember.getAccount();
         _funObject["getAccount"] = param1;
         EventCenter.PHPEvent.addEventListener("getAccount",onGetData);
      }
      
      public function apkPromo(param1:int) : void
      {
         var _loc2_:Object = Constants.getChannelApp();
         trace(JSON.stringify(_loc2_));
         if(_loc2_.appid > 0)
         {
            _gameMember.apkPromo(_loc2_.appid,_loc2_.key,param1);
            if(Constants.debug)
            {
               EventCenter.PHPEvent.addEventListener("apkPromo",onGetData);
            }
         }
      }
      
      public function onFeedBack(param1:int, param2:String, param3:String, param4:Function) : void
      {
         _gameMember.feedBack(param1,param2,param3);
         _funObject["feedbacktophp"] = param4;
         EventCenter.PHPEvent.addEventListener("feedbacktophp",onGetData);
      }
      
      public function onFaceBookImgUrl(param1:Array, param2:Function) : void
      {
         _gameMember.getPlayerFacebookImgUrl(param1);
         _funObject["facebookImgUrl"] = param2;
         EventCenter.PHPEvent.addEventListener("facebookImgUrl",onGetData);
      }
      
      private function onGetData(param1:PHPEvent) : void
      {
         var _loc3_:Function = null;
         if(param1)
         {
            param1.currentTarget.removeEventListener(param1.type,onGetData);
         }
         var _loc2_:Object = {};
         if(param1.param == "false")
         {
            _loc2_.error = 110;
         }
         else
         {
            try
            {
               _loc2_ = JSON.parse(param1.param as String);
            }
            catch(error:Error)
            {
               LevelLogger.getLogger("Remoting").error(param1.param as String);
               _loc2_.error = 119;
            }
         }
         if(_funObject[param1.type])
         {
            _loc3_ = _funObject[param1.type] as Function;
            _loc3_(_loc2_);
            delete _funObject[param1.type];
         }
      }
      
      public function get gameTable() : GameTable
      {
         return _gameTable;
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
