package com.boyaa.antwars.helper
{
   import com.boyaa.antwars.data.PlayerDataList;
   import flash.utils.Dictionary;
   
   public class ModelOpenContrl
   {
      
      private static var _instance:ModelOpenContrl = null;
      
      private var _dic:Dictionary = new Dictionary();
      
      public function ModelOpenContrl(param1:Single)
      {
         super();
         init();
      }
      
      public static function get instance() : ModelOpenContrl
      {
         if(_instance == null)
         {
            _instance = new ModelOpenContrl(new Single());
         }
         return _instance;
      }
      
      private function init() : void
      {
         _dic["open_activity"] = [0,7];
         _dic["open_mopay"] = [0,7];
      }
      
      public function getModelValue(param1:String) : int
      {
         if(_dic[param1])
         {
            return _dic[param1][1];
         }
         return 0;
      }
      
      public function checkIsOpen(param1:String) : Boolean
      {
         var _loc2_:* = _dic[param1][0];
         if(0 === _loc2_)
         {
            if(PlayerDataList.instance.selfData.level >= _dic[param1][1])
            {
               return true;
            }
         }
         return false;
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
