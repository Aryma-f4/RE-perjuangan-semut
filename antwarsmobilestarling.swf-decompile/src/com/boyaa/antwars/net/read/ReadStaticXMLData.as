package com.boyaa.antwars.net.read
{
   import com.boyaa.antwars.data.BaseValues;
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.CopyMonsterRoleList;
   import com.boyaa.antwars.data.ExchangeList;
   import com.boyaa.antwars.data.MapDataList;
   import com.boyaa.antwars.data.MissionDataList;
   import com.boyaa.antwars.data.RLGSDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.SkillDataList;
   import com.boyaa.antwars.data.SuitDataList;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.System;
   import flash.utils.ByteArray;
   
   public class ReadStaticXMLData extends EventDispatcher
   {
      
      private var _loader:URLLoader = null;
      
      private var _path:URLRequest = null;
      
      public function ReadStaticXMLData()
      {
         super();
      }
      
      public function read(param1:String) : void
      {
         _path = new URLRequest(param1);
         _loader = new URLLoader();
         _loader.dataFormat = "binary";
         _loader.addEventListener("complete",readXMLHandler);
         _loader.addEventListener("ioError",readErrorHandler);
         _loader.load(_path);
      }
      
      private function readErrorHandler(param1:IOErrorEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function readXMLHandler(param1:Event) : void
      {
         _loader.removeEventListener("complete",readXMLHandler);
         _loader.removeEventListener("ioError",readErrorHandler);
         var _loc2_:ByteArray = _loader.data as ByteArray;
         _loc2_.uncompress();
         var _loc3_:XML = new XML(_loc2_);
         BaseValues.setmemlevelattr(_loc3_.memlevelattr[0]);
         ShopDataList.instance.init();
         ShopDataList.instance.addDataFromXML(_loc3_.propsslist[0]);
         ShopDataList.instance.addUnionDataFromXML(_loc3_.cpropsslist[0]);
         RLGSDataList.instance.getCanRLGoodByXml(_loc3_.smelts[0]);
         MapDataList.instance.init();
         MapDataList.instance.addMapData(_loc3_.maps[0]);
         SuitDataList.instance.addSuitData(_loc3_.suits[0]);
         SkillDataList.instance.addEffctsData(_loc3_.skilleffects[0]);
         SkillDataList.instance.addSkillData(_loc3_.skills[0]);
         ExchangeList.instance.setPropItems(_loc3_.exchangeprop[0]);
         ExchangeList.instance.setNeedItems(_loc3_.exchangeneed[0]);
         MissionDataList.getInstance().loadData(_loc3_.missiondefine[0]);
         CopyList.instance.loadData(_loc3_.copylist[0]);
         CopyMonsterRoleList.instance.loadData(_loc3_.roleinfos[0]);
         MissionGuideValue.instance.loadXML();
         System.disposeXML(_loc3_);
         _loc3_ = null;
         dispatchEvent(new Event("complete"));
      }
   }
}

