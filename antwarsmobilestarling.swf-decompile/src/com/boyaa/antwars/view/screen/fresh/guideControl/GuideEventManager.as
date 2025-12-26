package com.boyaa.antwars.view.screen.fresh.guideControl
{
   import com.boyaa.antwars.data.model.mission.MissionData;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import starling.events.EventDispatcher;
   
   public class GuideEventManager
   {
      
      public static const TWEEN_DELAY:uint = 450;
      
      private static var _instance:GuideEventManager = null;
      
      private var _currentMissionData:MissionData;
      
      private var _missDataArr:Array;
      
      private var _eventDispatcher:EventDispatcher;
      
      public function GuideEventManager()
      {
         super();
         _eventDispatcher = new EventDispatcher();
         addEvent();
      }
      
      public static function get instance() : GuideEventManager
      {
         if(_instance == null)
         {
            _instance = new GuideEventManager();
         }
         return _instance;
      }
      
      public function dispactherEvent(param1:String, param2:Object, param3:int = 100) : void
      {
         var str:String = param1;
         var param:Object = param2;
         var delay:int = param3;
         if(delay != 0)
         {
            Timepiece.instance.addDelayCall((function():*
            {
               var delay:Function;
               return delay = function():void
               {
                  _eventDispatcher.dispatchEvent(new GuideEvent(str,false,param));
               };
            })(),delay);
         }
         else
         {
            _eventDispatcher.dispatchEvent(new GuideEvent(str,false,param));
         }
      }
      
      private function addEvent() : void
      {
         _eventDispatcher.addEventListener("newUI",onNewUIHandle);
      }
      
      private function removeEvent() : void
      {
         _eventDispatcher.removeEventListener("newUI",onNewUIHandle);
      }
      
      private function onNewUIHandle(param1:GuideEvent) : void
      {
         _currentMissionData = GuideTipManager.instance.currentMissionData;
         if(_currentMissionData == null)
         {
            return;
         }
         if(_currentMissionData.isFinished)
         {
            return;
         }
         var _loc2_:Array = param1.data as Array;
         var _loc3_:Array = MissionGuideValue.instance.getMissionGuideDataWithDisplayObjects(_currentMissionData,_loc2_);
         if(!_loc3_)
         {
            return;
         }
         GuideTipManager.instance.showGuideByList(_loc3_);
      }
      
      public function get currentMissionData() : MissionData
      {
         return _currentMissionData;
      }
   }
}

