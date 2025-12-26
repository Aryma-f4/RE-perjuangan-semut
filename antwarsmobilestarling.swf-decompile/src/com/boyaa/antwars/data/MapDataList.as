package com.boyaa.antwars.data
{
   import com.boyaa.antwars.data.model.MapData;
   import com.boyaa.antwars.lang.LangManager;
   
   public class MapDataList
   {
      
      private static var _instance:MapDataList = null;
      
      private var _list:Array = null;
      
      public function MapDataList(param1:Single)
      {
         super();
      }
      
      public static function get instance() : MapDataList
      {
         if(_instance == null)
         {
            _instance = new MapDataList(new Single());
         }
         return _instance;
      }
      
      public function init() : void
      {
         _list = [];
      }
      
      public function addMapData(param1:XML) : void
      {
         var _loc4_:int = 0;
         var _loc3_:MapData = null;
         _loc4_ = 0;
         while(_loc4_ < param1.map.length())
         {
            _loc3_ = new MapData();
            _loc3_.updateForData(param1.map[_loc4_]);
            if(_loc3_.type == 1)
            {
               _list.push(_loc3_);
            }
            _loc4_++;
         }
         var _loc2_:MapData = new MapData();
         _loc2_.addData([0,LangManager.getLang.getLangByStr("randomMapName"),0,0]);
         _list.push(_loc2_);
         _list.sort(sortIndex);
         param1 = null;
      }
      
      public function sortIndex(param1:MapData, param2:MapData) : int
      {
         if(param1.level > param2.level)
         {
            return 1;
         }
         if(param1.level == param2.level)
         {
            if(param1.id > param2.id)
            {
               return 1;
            }
         }
         return -1;
      }
      
      public function getMapData(param1:int) : MapData
      {
         var _loc3_:int = 0;
         var _loc2_:MapData = null;
         _loc3_ = 0;
         while(_loc3_ < _list.length)
         {
            _loc2_ = _list[_loc3_];
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getMapDataCount(param1:int) : MapData
      {
         return _list[param1];
      }
      
      public function get mapAmount() : int
      {
         return _list.length;
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
