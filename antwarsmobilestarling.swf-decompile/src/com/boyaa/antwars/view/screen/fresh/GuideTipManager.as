package com.boyaa.antwars.view.screen.fresh
{
   import com.boyaa.antwars.data.MissionDataList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.mission.MissionData;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.fresh.guideControl.ArrowGuide;
   import com.boyaa.antwars.view.screen.fresh.guideControl.CreateGuideObject;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideSprite;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import starling.display.DisplayObject;
   import starling.display.Stage;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class GuideTipManager
   {
      
      private static var _instance:GuideTipManager = null;
      
      private var _topWindowArr:Array = [];
      
      private var _displayObjectArr:Array = [];
      
      private var _guideDataList:Array = [];
      
      private var _stage:Stage;
      
      private var _currentGuide:CreateGuideObject;
      
      private var _currentMissionData:MissionData;
      
      private var _isRunning:Boolean = false;
      
      private var _currentProcess:IGuideProcess = null;
      
      private var _arrow:ArrowGuide;
      
      private var _windowTopOnHall:Boolean = false;
      
      private var _isNoHide:Boolean = false;
      
      private var _mark:DlgMark;
      
      public function GuideTipManager(param1:Single)
      {
         super();
         initValues();
      }
      
      public static function get instance() : GuideTipManager
      {
         if(_instance == null)
         {
            _instance = new GuideTipManager(new Single());
         }
         return _instance;
      }
      
      public function start() : void
      {
         currentProcess.guideProcess();
      }
      
      public function showGuideByList(param1:Array) : void
      {
         _guideDataList = param1;
         showGuideByStep();
      }
      
      public function stopGuide() : void
      {
         _arrow.stopShow();
         _mark && _mark.removeFromParent(true);
         _isRunning = false;
         _isNoHide = false;
         removeEvent();
      }
      
      public function showGuideInPlace(... rest) : void
      {
         _displayObjectArr = rest;
         var _loc2_:String = Application.instance.currentGame.navigator.activeScreenID;
         var _loc3_:* = _loc2_;
         if("HALL" === _loc3_)
         {
            if(!Timepiece.instance.hasFunction(showGuideInHall,1))
            {
               Timepiece.instance.addTimerFun(showGuideInHall,15000);
            }
         }
      }
      
      private function addEvents() : void
      {
         _stage.addEventListener("touch",onTouchHandle);
      }
      
      private function removeEvent() : void
      {
         _stage.removeEventListener("touch",onTouchHandle);
      }
      
      private function showBlackBg(param1:Boolean = true) : void
      {
         _mark && _mark.removeFromParent(true);
         if(param1)
         {
            _mark = new DlgMark();
            Application.instance.currentGame.addChild(_mark);
         }
      }
      
      public function showByDisplayObject(param1:DisplayObject, param2:Boolean = true, param3:String = "up", param4:Boolean = true) : void
      {
         _isNoHide = param2;
         var _loc5_:CreateGuideObject = new CreateGuideObject("",param4,param3,0,param1);
         showGuideByList([_loc5_]);
      }
      
      private function showGuideByStep(param1:CreateGuideObject = null) : void
      {
         if(param1 == null)
         {
            _currentGuide = _guideDataList.shift();
         }
         if(_currentGuide == null)
         {
            stopGuide();
            trace("数组中找不到相关的引导数据------------NewPlayerGuideManager->showGuideByStep");
            return;
         }
         _isRunning = true;
         if(_currentGuide.isCompulsory)
         {
            showBlackBg();
         }
         else
         {
            showBlackBg(false);
         }
         _arrow.startShow(_currentGuide.movieClip,_currentGuide.helpMsg,_currentGuide.direction,_currentGuide.isCompulsory);
         Timepiece.instance.addDelayCall(addEvents,200);
      }
      
      private function createMarkBg() : void
      {
      }
      
      private function initValues() : void
      {
         _arrow = new ArrowGuide();
         _stage = Application.instance.currentGame.stage;
      }
      
      private function showGuideInHall() : void
      {
         var _loc2_:DisplayObject = _displayObjectArr[0] as DisplayObject;
         var _loc1_:DisplayObject = _displayObjectArr[1] as DisplayObject;
         if(Application.instance.currentGame.navigator.activeScreenID != "HALL")
         {
            return;
         }
         if(windowTopOnHall || _isRunning)
         {
            return;
         }
         if(Guide.instance.isRunning)
         {
            return;
         }
         if(PlayerDataList.instance.selfData.level < 5)
         {
            return;
         }
         if(MissionDataList.getInstance().mainMissionArr.length != 0)
         {
            _arrow.startShow(_loc2_);
         }
         else
         {
            _arrow.startShow(_loc1_);
         }
         addEvents();
      }
      
      private function onTouchHandle(param1:TouchEvent) : void
      {
         var _loc3_:Touch = param1.getTouch(_stage);
         var _loc4_:Vector.<Touch> = param1.getTouches(_stage);
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(_loc3_ && _loc3_.phase == "ended" && !_isNoHide)
         {
            if(_currentGuide && _loc3_.isTouching(_currentGuide.movieClip))
            {
               showGuideByStep();
               trace("i am touch!!!!");
            }
            else
            {
               if(_currentGuide && _currentGuide.isCompulsory)
               {
                  return;
               }
               stopGuide();
            }
         }
      }
      
      public function get isRunning() : Boolean
      {
         return _isRunning;
      }
      
      public function get currentMissionData() : MissionData
      {
         return _currentMissionData;
      }
      
      public function set currentMissionData(param1:MissionData) : void
      {
         _currentMissionData = param1;
      }
      
      public function get currentProcess() : IGuideProcess
      {
         return _currentProcess;
      }
      
      public function set currentProcess(param1:IGuideProcess) : void
      {
         _currentProcess = param1;
      }
      
      public function get windowTopOnHall() : Boolean
      {
         if(_topWindowArr.length != 0)
         {
            return true;
         }
         return false;
      }
      
      public function set windowTopOnHall(param1:Boolean) : void
      {
         _windowTopOnHall = param1;
         if(_windowTopOnHall && _topWindowArr.length == 0)
         {
            stopGuide();
         }
      }
      
      public function addWindow(param1:GuideSprite) : void
      {
         _topWindowArr.push(param1);
         windowTopOnHall = true;
      }
      
      public function removeWindow(param1:GuideSprite) : void
      {
         var _loc2_:int = int(_topWindowArr.indexOf(param1));
         if(_loc2_ != -1)
         {
            _topWindowArr.splice(_loc2_,1);
         }
         if(_topWindowArr.length == 0)
         {
            windowTopOnHall = false;
         }
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
