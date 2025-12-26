package com.boyaa.antwars.net.php
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.events.PHPEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   
   public class GameCopys extends PostBase
   {
      
      public function GameCopys()
      {
         super();
      }
      
      private function errorHandler(param1:IOErrorEvent) : void
      {
      }
      
      public function getCopyGrade() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameCopys.getCopyGrade",[]]);
         _loc1_.addEventListener("complete",onGetCopyGrade);
         _loc1_.addEventListener("ioError",errorHandler);
      }
      
      private function onGetCopyGrade(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onGetCopyGrade);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getCopyGrade",_loc2_));
      }
      
      public function buyBTProp(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameCopys.buyProp",param1]);
         _loc2_.addEventListener("complete",onBuyBTProp);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onBuyBTProp(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onBuyBTProp);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("buyBTProp",_loc2_));
      }
      
      public function backBTProp(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameCopys.backProp",param1]);
         _loc2_.addEventListener("complete",onBackBTProp);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onBackBTProp(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onBackBTProp);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("backBTProp",_loc2_));
      }
      
      public function useBTProp(param1:Array) : void
      {
         var _loc2_:URLLoader = loaderURL(["GameCopys.useProp",param1]);
         _loc2_.addEventListener("complete",onUseBTProp);
         _loc2_.addEventListener("ioError",errorHandler);
      }
      
      private function onUseBTProp(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onUseBTProp);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("useBTProp",_loc2_));
      }
      
      public function getPlayerWeaponState() : void
      {
         var _loc1_:URLLoader = loaderURL(["GameProps.get_fight_weapons"]);
         _loc1_.addEventListener("complete",onPlayerWeaponState);
         _loc1_.addEventListener("ioError",errorHandler);
      }
      
      private function onPlayerWeaponState(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("playerWeaponState",_loc3_));
      }
      
      public function changeWeaponInBox(param1:int, param2:int) : void
      {
         var _loc3_:URLLoader = loaderURL(["GameProps.handle_fight_weapons",[param1,param2]]);
         _loc3_.addEventListener("complete",onChangeWeaponInBox);
         _loc3_.addEventListener("ioError",errorHandler);
      }
      
      private function onChangeWeaponInBox(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("changeWeaponInBox",_loc3_));
      }
      
      public function changeWeaponInBattle(param1:int, param2:int) : void
      {
         var _loc3_:URLLoader = loaderURL(["GameProps.exchange_fight_weapons",[param1,param2]]);
         _loc3_.addEventListener("complete",onChangeWeaponInBattle);
         _loc3_.addEventListener("ioError",errorHandler);
      }
      
      private function onChangeWeaponInBattle(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc3_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("changeWeaponInBattle",_loc3_));
      }
      
      public function getMobileCopyPrize(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:URLLoader = loaderURL(["GameCopys.getMobileCopyPrize",{
            "cpdtlid":param1,
            "cpid":param2,
            "stage":param3,
            "difficulty":param4,
            "grade":param5
         }]);
         _loc6_.addEventListener("complete",onGetMobileCopyPrize);
         _loc6_.addEventListener("ioError",errorHandler);
      }
      
      private function onGetMobileCopyPrize(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("complete",onGetMobileCopyPrize);
         param1.currentTarget.removeEventListener("ioError",errorHandler);
         var _loc2_:String = param1.currentTarget.data as String;
         EventCenter.PHPEvent.dispatchEvent(new PHPEvent("getMobileCopyPrize",_loc2_));
      }
   }
}

