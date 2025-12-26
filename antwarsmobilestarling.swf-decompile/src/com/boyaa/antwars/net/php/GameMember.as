package com.boyaa.antwars.net.php
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.LoginData;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.tool.Tiptext;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   
   public class GameMember extends PostBase
   {
      
      public function GameMember()
      {
         super();
      }
      
      public function load(param1:String = "") : void
      {
         var _loc2_:URLLoader = loaderURL(["GameMember.load",[param1]]);
         _loc2_.addEventListener("complete",onLoadHandler);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function errorHandler(param1:IOErrorEvent) : void
      {
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         new Tiptext(LangManager.t("NetError"));
         Application.instance.currentMain.logout();
      }
      
      private function onLoadHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onLoadHandler);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("GameMemberLoad",_loc2_));
      }
      
      public function gameLog(param1:String) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameMember.gameLog",param1]);
      }
      
      public function bindAccount(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameMember.bindLogin",param1]);
         _loc2_.addEventListener("complete",onBindAccount);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onBindAccount(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onBindAccount);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("GameBindAccount",_loc2_));
      }
      
      public function create(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameMember.create",param1]);
         _loc2_.addEventListener("complete",onCreateHandler);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onCreateHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onCreateHandler);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("GameMemberCreate",_loc2_));
      }
      
      public function checkRepeatRole(param1:String) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameMember.checkRepeatRole",[param1]]);
         _loc2_.addEventListener("complete",onCheckRepeatRoleHandler);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onCheckRepeatRoleHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onCheckRepeatRoleHandler);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("GAME_MEMBER_CHECKREPEATROLE",_loc2_));
      }
      
      public function getNSignInfo() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameSignin.get_v2sign_info"]);
         _loc1_.addEventListener("complete",onGetSignInfo);
         _loc1_.addEventListener("ioError",errorHandler);
      }
      
      private function onGetSignInfo(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onGetSignInfo);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getSignInfo",_loc2_));
      }
      
      public function getNSignGift() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameSignin.nSign"]);
         _loc1_.addEventListener("complete",onGetSignGift);
         _loc1_.addEventListener("ioError",errorHandler);
      }
      
      private function onGetSignGift(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onGetSignGift);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getSignGift",_loc2_));
      }
      
      public function getNSignRewards(param1:int = 0) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameSignin.v2sign"]);
         _loc2_.addEventListener("complete",onGetSignRewards);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onGetSignRewards(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onGetSignRewards);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getSignRewards",_loc2_));
      }
      
      public function resetSignRecord() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameSignin.reset_v2sign_record"]);
         _loc1_.addEventListener("complete",onGetReSign);
         _loc1_.addEventListener("ioError",errorHandler);
      }
      
      private function onGetReSign(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onGetReSign);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getReSignInfo",_loc2_));
      }
      
      public function addFirend(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameFriends.addFriends",param1]);
         _loc2_.addEventListener("complete",onFirend);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onFirend(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onFirend);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("GAME_ADDFIREND",_loc2_));
      }
      
      public function getFirends(param1:int = 1) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameFriends.getFrds",param1]);
         _loc2_.addEventListener("complete",onGetFirends);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onGetFirends(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onGetFirends);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getFirends",_loc2_));
      }
      
      public function addFriend(param1:int) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameFriends.addFriend",[param1]]);
         _loc2_.addEventListener("complete",onaddFriend);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onaddFriend(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onaddFriend);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("addFriend",_loc2_));
      }
      
      public function deleteFriend(param1:int = 1) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameFriends.deleteFriend",[param1]]);
         _loc2_.addEventListener("complete",ondeleteFriend);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function ondeleteFriend(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",ondeleteFriend);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("deleteFriend",_loc2_));
      }
      
      public function getMemStatus(param1:int = 1) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameFriends.getMemStatus",param1]);
         _loc2_.addEventListener("complete",onGetMemStatus);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onGetMemStatus(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onGetMemStatus);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getMemStatus",_loc2_));
      }
      
      public function openFreshPack(param1:int) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameMember.openFreshPack",param1]);
         _loc2_.addEventListener("complete",onOpenFreshPack);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onOpenFreshPack(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onOpenFreshPack);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("openFreshPack",_loc2_));
      }
      
      public function mobileUpdate(param1:String) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameMember.mobileUpdate",param1]);
         _loc2_.addEventListener("complete",onMobileUpdate);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onMobileUpdate(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onMobileUpdate);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("mobileUpdate",_loc2_));
      }
      
      public function getNotice(param1:String) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameMember.getNotice",param1]);
         _loc2_.addEventListener("complete",onGetNotice);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onGetNotice(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onGetNotice);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getNotice",_loc2_));
      }
      
      public function getAccount() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameMember.getAccount"]);
         _loc1_.addEventListener("complete",onGetAccount);
         _loc1_.addEventListener("ioError",errorHandler);
      }
      
      private function onGetAccount(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onGetAccount);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getAccount",_loc2_));
      }
      
      public function getNewWeapon() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameMember.getNewWeapon"]);
         _loc1_.addEventListener("complete",onGetNewWeapon);
         _loc1_.addEventListener("ioError",errorHandler);
      }
      
      private function onGetNewWeapon(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onGetNewWeapon);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getNewWeapon",_loc2_));
      }
      
      public function suggestion(param1:String, param2:String) : void
      {
         var _loc3_:URLLoader = loaderURL(["GameMember.suggestion",[param1,param2]]);
         _loc3_.addEventListener("complete",onSuggestion);
         _loc3_.addEventListener("ioError",errorHandler);
      }
      
      private function onSuggestion(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onSuggestion);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("suggestion",_loc2_));
      }
      
      private function onGetIndulgeInfo(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onGetIndulgeInfo);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getIndulgeInfo",_loc2_));
      }
      
      public function apkPromo(param1:int, param2:String, param3:int) : void
      {
         var _loc4_:URLLoader = loaderURL(["MobilePromo.apkPromo",{
            "appid":param1,
            "appkey":param2,
            "mobid":LoginData.instance.sid,
            "type":param3
         }]);
         if(Constants.debug)
         {
            _loc4_.addEventListener("complete",onApkPromo);
         }
         _loc4_.addEventListener("ioError",errorHandler);
      }
      
      public function getIndulgeInfo() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameMember.getIndulgeInfo"]);
         _loc1_.addEventListener("complete",onGetIndulgeInfo);
         _loc1_.addEventListener("ioError",errorHandler);
      }
      
      public function indulgeCheck(param1:String, param2:String) : void
      {
         var _loc3_:URLLoader = loaderURL(["GameMember.indulgeCheck",[param1,param2]]);
         _loc3_.addEventListener("complete",onIndulgeCheck);
         _loc3_.addEventListener("ioError",errorHandler);
      }
      
      private function onIndulgeCheck(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onIndulgeCheck);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("indulgeCheck",_loc2_));
      }
      
      private function onApkPromo(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onApkPromo);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("apkPromo",_loc2_));
      }
      
      public function feedBack(param1:int, param2:String, param3:String) : void
      {
         var _loc4_:URLLoader = loaderURL(["GameMember.feedback",[param1,param2,param3]]);
         _loc4_.addEventListener("complete",onFeedBackComplete);
         _loc4_.addEventListener("ioError",errorHandler);
      }
      
      private function onFeedBackComplete(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onFeedBackComplete);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("feedbacktophp",_loc2_));
      }
      
      public function getPlayerFacebookImgUrl(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameMember.get_micons",param1]);
         _loc2_.addEventListener("complete",onPlayerFacebookImgHandle);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onPlayerFacebookImgHandle(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onPlayerFacebookImgHandle);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("facebookImgUrl",_loc2_));
      }
   }
}

