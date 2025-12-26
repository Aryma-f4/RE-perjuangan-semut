package com.boyaa.antwars.view.screen.fresh
{
   public class FreshGuideVlaue
   {
      
      public static const GET_WEAPON1:String = "getWeapon1";
      
      public static const TURN_LEFT:String = "turnLeft";
      
      public static const TURN_RIGHT:String = "turnRight";
      
      public static const GET_WEAPON2:String = "getWeapon2";
      
      public static const OPEN_SKILLBOX:String = "openSkillBox";
      
      public static const USE_PLANE:String = "usePlane";
      
      public static const CHANGE_ANGLE:String = "changeAngle";
      
      public static const SHOOT:String = "shoot";
      
      public static const CHANGE_WEAPON:String = "changeWeapon";
      
      public static const CHANGE_TAB:String = "changeTab";
      
      public static const USE_SKILL:String = "useSkill";
      
      public static const USE_POWER:String = "usePower";
      
      public static const TURN_POKER:String = "turnPoker";
      
      private static var _currentStepData:Array = null;
      
      private static var _inFreshGame:Boolean = false;
      
      public function FreshGuideVlaue()
      {
         super();
      }
      
      public static function get currentStepData() : Array
      {
         return _currentStepData;
      }
      
      public static function set currentStepData(param1:Array) : void
      {
         _currentStepData = param1;
      }
      
      public static function get inFreshGame() : Boolean
      {
         return _inFreshGame;
      }
      
      public static function set inFreshGame(param1:Boolean) : void
      {
         _inFreshGame = param1;
      }
   }
}

