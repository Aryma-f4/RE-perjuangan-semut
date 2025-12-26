package com.boyaa.antwars.view.screen.battlefield.ui.items
{
   import com.boyaa.antwars.data.GoodsList;
   
   public class UseSkillManager
   {
      
      private static var _instance:UseSkillManager = null;
      
      private var _skillDataVector:Vector.<UseSkillData>;
      
      private var _bulletType:int = 0;
      
      private var _limitSkillCount:int = 0;
      
      public function UseSkillManager(param1:Single)
      {
         super();
      }
      
      public static function get instance() : UseSkillManager
      {
         if(_instance == null)
         {
            _instance = new UseSkillManager(new Single());
         }
         return _instance;
      }
      
      public function initSkillState() : void
      {
         var _loc2_:int = 0;
         _skillDataVector = new Vector.<UseSkillData>();
         var _loc1_:Array = GoodsList.instance.getBTPropAndSkill();
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            addSkillById(int(_loc1_[_loc2_]));
            _loc2_++;
         }
         bulletType = 0;
         limitSkillCount = 0;
      }
      
      public function removeSkillByData(param1:UseSkillData) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _skillDataVector.length)
         {
            if(_skillDataVector[_loc2_] == param1)
            {
               _skillDataVector.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function addSkillById(param1:int) : void
      {
         _skillDataVector.push(new UseSkillData(param1));
      }
      
      public function get skillDataVector() : Vector.<UseSkillData>
      {
         return _skillDataVector;
      }
      
      public function get bulletType() : int
      {
         return _bulletType;
      }
      
      public function set bulletType(param1:int) : void
      {
         _bulletType = param1;
      }
      
      public function get limitSkillCount() : int
      {
         return _limitSkillCount;
      }
      
      public function set limitSkillCount(param1:int) : void
      {
         _limitSkillCount = param1;
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
