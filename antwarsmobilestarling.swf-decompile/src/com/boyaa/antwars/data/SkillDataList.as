package com.boyaa.antwars.data
{
   import com.boyaa.antwars.data.model.skill.SkillData;
   import com.boyaa.antwars.data.model.skill.SubSkillData;
   
   public class SkillDataList
   {
      
      private static var _instance:SkillDataList = null;
      
      private var _list:Array = null;
      
      private var _effctsArr:Array = null;
      
      public function SkillDataList(param1:Single)
      {
         super();
         _list = [];
      }
      
      public static function get instance() : SkillDataList
      {
         if(_instance == null)
         {
            _instance = new SkillDataList(new Single());
         }
         return _instance;
      }
      
      public function addSkillData(param1:XML) : void
      {
         var _loc4_:int = 0;
         var _loc2_:SkillData = null;
         var _loc3_:int = int(param1.skill.length());
         _list = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new SkillData();
            _loc2_.updateForData(param1.skill[_loc4_]);
            _list.push(_loc2_);
            _loc4_++;
         }
      }
      
      public function addEffctsData(param1:XML) : void
      {
         var _loc4_:int = 0;
         var _loc2_:SubSkillData = null;
         var _loc3_:int = int(param1.skilleffect.length());
         _effctsArr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new SubSkillData();
            _loc2_.updateForData(param1.skilleffect[_loc4_]);
            _effctsArr.push(_loc2_);
            _loc4_++;
         }
      }
      
      public function getSkillByID(param1:int) : SkillData
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _list.length)
         {
            if((_list[_loc2_] as SkillData).ID == param1)
            {
               return _list[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getEffcts(param1:int) : SubSkillData
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _effctsArr.length)
         {
            if((_effctsArr[_loc2_] as SubSkillData).type == param1)
            {
               return _effctsArr[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function trigger(param1:Array, param2:int) : int
      {
         return -1;
      }
      
      public function getSkillTimes(param1:int) : int
      {
         var _loc2_:int = getSkillSecode(param1);
         var _loc3_:SubSkillData = getEffcts(_loc2_);
         return _loc3_.lasttime;
      }
      
      public function getSkillTimesType(param1:int) : int
      {
         var _loc2_:int = getSkillSecode(param1);
         var _loc3_:SubSkillData = getEffcts(_loc2_);
         return _loc3_.lastType;
      }
      
      public function getSkillSecode(param1:int) : int
      {
         return getSkillByID(param1).secode;
      }
      
      public function getSkillValue(param1:int) : int
      {
         return getSkillByID(param1).value;
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
