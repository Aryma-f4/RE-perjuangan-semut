package com.boyaa.antwars.data
{
   public class BaseValues
   {
      
      public static const PHYSICAL:int = 240;
      
      private static var level_score:Array = [];
      
      private static var level_HP:Array = [];
      
      public function BaseValues()
      {
         super();
      }
      
      public static function getBloodVolume(param1:int) : int
      {
         return level_HP[param1 - 1];
      }
      
      public static function setmemlevelattr(param1:XML) : void
      {
         var _loc2_:int = 0;
         level_score = [];
         _loc2_ = 0;
         while(_loc2_ < param1.memattr.length())
         {
            level_score.push(int(param1.memattr[_loc2_]["experience"]));
            level_HP.push(int(param1.memattr[_loc2_]["blood"]));
            _loc2_++;
         }
      }
      
      public static function getLevel(param1:int) : int
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < level_score.length)
         {
            if(param1 < level_score[_loc2_])
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 45;
      }
      
      public static function getScoreByLevel(param1:int) : int
      {
         if(param1 == -1)
         {
            return 0;
         }
         return level_score[param1];
      }
   }
}

