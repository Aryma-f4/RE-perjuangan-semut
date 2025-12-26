package com.boyaa.antwars.net.read
{
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.LoginData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.debug.Logging.LevelLogger;
   import com.boyaa.tool.SysTime;
   import com.boyaa.tool.filter.DirtyWordFilter;
   import flash.events.Event;
   import flash.utils.getTimer;
   import org.osflash.signals.Signal;
   
   public class ReadSelfData
   {
      
      public var readCompleteSignal:Signal = null;
      
      public var createRoleSignal:Signal = null;
      
      public function ReadSelfData()
      {
         super();
         this.readCompleteSignal = new Signal(int);
         this.createRoleSignal = new Signal();
      }
      
      public function read() : void
      {
         readStaticXMLData(Application.instance.resManager.getResFile("xml.data").url);
      }
      
      private function readStaticXMLData(param1:String) : void
      {
         var _loc2_:ReadStaticXMLData = new ReadStaticXMLData();
         _loc2_.addEventListener("complete",getXMLHandler);
         _loc2_.read(param1);
      }
      
      private function getXMLHandler(param1:Event) : void
      {
         if(param1)
         {
            param1.currentTarget.removeEventListener("complete",getXMLHandler);
         }
         Remoting.instance.load(setLoadData);
         UnionManager.getInstance().isHaveUnion();
      }
      
      private function setLoadData(param1:Object) : void
      {
         var _loc3_:PlayerData = PlayerDataList.instance.selfData;
         if(param1 == null)
         {
            LevelLogger.getLogger("ReadSelfData").error("[GameMember.load] return null");
            return;
         }
         var _loc2_:Array = param1.user;
         if(_loc2_ == null)
         {
            return;
         }
         _loc3_.uid = _loc2_[0];
         _loc3_.name = _loc2_[1];
         if(_loc3_.name == null)
         {
            _loc3_.name = "";
         }
         _loc3_.sex = _loc2_[2];
         _loc3_.webSid = _loc2_[10];
         PlayerDataList.instance.firstLogTime = _loc2_[6];
         PlayerDataList.instance.loginDays = _loc2_[15];
         PlayerDataList.instance.luckTimes = param1.luckdraw;
         PlayerDataList.instance.isHaveHome = param1.hashouse;
         _loc3_.home = "";
         LoginData.instance.key = param1.sessionkey;
         PlayerDataList.instance.setTime(param1.time);
         SysTime.setDelayTime(getTimer() / 1000);
         SysTime.setSysTime(param1.time);
         if(_loc2_[13] == null)
         {
            _loc3_.reside = "保密";
         }
         else
         {
            _loc3_.reside = _loc2_[13];
         }
         if(_loc2_[8] == 0)
         {
            this.createRoleSignal.dispatch();
         }
         else
         {
            setRoleData(param1);
         }
      }
      
      public function setRoleData(param1:Object) : void
      {
         var _loc4_:PlayerData = PlayerDataList.instance.selfData;
         var _loc2_:Object = param1.role;
         _loc4_.babyName = DirtyWordFilter.getInstance().runFilter(_loc2_.mrolename);
         _loc4_.babySex = int(_loc2_.mgender);
         _loc4_.level = int(_loc2_.mlevel);
         _loc4_.win = int(_loc2_.mwinning);
         _loc4_.fail = int(_loc2_.mfailure);
         _loc4_.exp = int(_loc2_.mpoint);
         _loc4_.runaway = int(_loc2_.mflee);
         _loc4_.appearence = _loc2_.appearance;
         _loc4_.isfreshpack = _loc2_.freshpack;
         var _loc3_:Object = param1.account;
         AccountData.instance.gameGold = int(_loc3_.currency);
         AccountData.instance.boyaaCoin = int(_loc3_.boyaacurrency);
         AccountData.instance.freeCoin = int(_loc3_.excertificate);
         AccountData.instance.aucteCoin = int(_loc3_.auctecoin);
         this.readCompleteSignal.dispatch(_loc2_.freshpack);
      }
   }
}

