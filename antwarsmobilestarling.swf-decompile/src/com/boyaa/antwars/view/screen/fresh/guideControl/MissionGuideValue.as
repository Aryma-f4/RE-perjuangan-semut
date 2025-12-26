package com.boyaa.antwars.view.screen.fresh.guideControl
{
   import com.boyaa.antwars.data.model.mission.MissionData;
   import com.boyaa.antwars.data.model.mission.SubMissionData;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class MissionGuideValue
   {
      
      public static const FIGHT_2V2_MISSION:String = "fight2v2Mission";
      
      public static const FIGHT_1V1_MISSION:String = "fight1v1Mission";
      
      public static const USE_FIGHT_SKILL:String = "useFightSkill";
      
      public static const COPY_MISSION:String = "copyMission";
      
      public static const ENDLESS_MISSION:String = "endlessMission";
      
      public static const FORGE_MISSION:String = "forgeMission";
      
      public static const PAY_MISSION:String = "payMission";
      
      public static const UNION_MISSION:String = "unionMission";
      
      public static const USEPROP_MISSION:String = "usePropMission";
      
      public static const MARRAY_MISSION:String = "marryMission";
      
      public static const FRIEND_MISSION:String = "friendMission";
      
      private static var _instance:MissionGuideValue = null;
      
      private var _displayObjectArr:Array = [];
      
      private var _missionGuideDic:Dictionary = new Dictionary();
      
      private var MISSION_FLAG_ARR:Array = ["fight1v1Mission","fight2v2Mission","copyMission","endlessMission","forgeMission","payMission","unionMission","usePropMission","marryMission","friendMission","useFightSkill"];
      
      private var _missionCodeGuideList:Dictionary = new Dictionary();
      
      public function MissionGuideValue(param1:Single)
      {
         super();
         initDic();
      }
      
      public static function get instance() : MissionGuideValue
      {
         if(_instance == null)
         {
            _instance = new MissionGuideValue(new Single());
         }
         return _instance;
      }
      
      public function loadXML() : void
      {
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener("complete",loadXMLComplete);
         _loc1_.load(new URLRequest(Application.instance.resManager.getResFile("guideData.xml").url));
      }
      
      public function getMissionFlag(param1:MissionData = null) : String
      {
         var _loc6_:int = 0;
         var _loc3_:Array = null;
         var _loc5_:int = 0;
         var _loc4_:SubMissionData = null;
         var _loc2_:int = 0;
         if(!param1)
         {
            param1 = GuideTipManager.instance.currentMissionData;
            if(!param1)
            {
               return null;
            }
         }
         _loc6_ = 0;
         while(_loc6_ < MISSION_FLAG_ARR.length)
         {
            _loc3_ = _missionGuideDic[MISSION_FLAG_ARR[_loc6_]];
            _loc5_ = 0;
            while(_loc5_ < param1.submissions.length)
            {
               _loc4_ = param1.submissions[_loc5_];
               _loc2_ = int(_loc3_.indexOf(_loc4_.actioncode));
               if(_loc2_ != -1 && !_loc4_.isFinished)
               {
                  return MISSION_FLAG_ARR[_loc6_];
               }
               _loc5_++;
            }
            _loc6_++;
         }
         return null;
      }
      
      public function getMissionGuideDataWithDisplayObjects(param1:MissionData, param2:Array) : Array
      {
         var _loc7_:CreateGuideObject = null;
         var _loc8_:int = 0;
         var _loc6_:Array = null;
         var _loc5_:String = getMissionFlag(param1);
         var _loc4_:Array = getMissionGuideDataInXML(param1);
         var _loc3_:Array = [];
         _loc8_ = 0;
         while(_loc8_ < param2.length)
         {
            _loc6_ = param2[_loc8_];
            _loc7_ = _loc4_[_loc6_[1]];
            _loc7_.movieClip = _loc6_[0];
            _loc3_.push(_loc7_);
            _loc8_++;
         }
         return _loc3_.concat();
      }
      
      public function getMissionGuideData(param1:MissionData) : Array
      {
         var _loc3_:String = getMissionFlag(param1);
         var _loc2_:Array = _missionCodeGuideList[_loc3_];
         return _loc2_.concat();
      }
      
      public function getUnCompleteSubMissions(param1:MissionData = null) : SubMissionData
      {
         var _loc3_:int = 0;
         var _loc2_:SubMissionData = null;
         if(!param1)
         {
            param1 = GuideTipManager.instance.currentMissionData;
            if(!param1)
            {
               return null;
            }
         }
         _loc3_ = 0;
         while(_loc3_ < param1.submissions.length)
         {
            _loc2_ = param1.submissions[_loc3_];
            if(!_loc2_.isFinished)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      private function getMissionGuideDataInXML(param1:MissionData) : Array
      {
         var _loc3_:int = 0;
         var _loc2_:SubMissionData = null;
         if(!param1)
         {
            param1 = GuideTipManager.instance.currentMissionData;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.submissions.length)
         {
            _loc2_ = getUnCompleteSubMissions(param1);
            if(_loc2_)
            {
               return _missionCodeGuideList[_loc2_.actioncode];
            }
            _loc3_++;
         }
         return null;
      }
      
      private function loadXMLComplete(param1:Event) : void
      {
         var _loc3_:XML = XML((param1.currentTarget as URLLoader).data);
         for each(var _loc2_ in _loc3_..mission)
         {
            _missionCodeGuideList[int(_loc2_.code)] = xml2Array(_loc2_..guide);
         }
         trace("");
      }
      
      private function xml2Array(param1:XMLList) : Array
      {
         var _loc4_:Boolean = false;
         var _loc2_:Array = [];
         for each(var _loc3_ in param1)
         {
            _loc4_ = _loc3_.@compulsory == "0" ? false : true;
            _loc2_[_loc3_.@step] = new CreateGuideObject(_loc3_.@lang,_loc4_,_loc3_.@direction);
         }
         return _loc2_;
      }
      
      private function initDic() : void
      {
         _missionGuideDic["fight2v2Mission"] = [102,104,119,136,137];
         _missionGuideDic["fight1v1Mission"] = [102,103,117,119,134,135];
         _missionGuideDic["useFightSkill"] = [101,178];
         _missionGuideDic["copyMission"] = [132,172,174,177];
         _missionGuideDic["endlessMission"] = [181];
         _missionGuideDic["forgeMission"] = [179];
         _missionGuideDic["payMission"] = [112];
         _missionGuideDic["unionMission"] = [122,123,126,131];
         _missionGuideDic["marryMission"] = [148,149];
         _missionGuideDic["usePropMission"] = [121,163,180];
         _missionGuideDic["friendMission"] = [170];
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
