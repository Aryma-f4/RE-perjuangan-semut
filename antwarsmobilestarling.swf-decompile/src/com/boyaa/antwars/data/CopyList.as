package com.boyaa.antwars.data
{
   import com.boyaa.antwars.data.model.CopyDetailData;
   
   public class CopyList
   {
      
      private static var _instance:CopyList = null;
      
      private var _list:Vector.<CopyDetailData>;
      
      private var _currentCopyData:CopyDetailData;
      
      public function CopyList(param1:Single)
      {
         super();
      }
      
      public static function get instance() : CopyList
      {
         if(_instance == null)
         {
            _instance = new CopyList(new Single());
         }
         return _instance;
      }
      
      public function get currentCopyData() : CopyDetailData
      {
         return _currentCopyData;
      }
      
      public function set currentCopyData(param1:CopyDetailData) : void
      {
         _currentCopyData = param1;
      }
      
      public function loadData(param1:XML) : void
      {
         var _loc5_:int = 0;
         var _loc4_:CopyDetailData = null;
         _list = new Vector.<CopyDetailData>();
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = int(param1.copy.length());
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            for each(var _loc3_ in param1.copy[_loc5_].details[0].detail)
            {
               _loc4_ = new CopyDetailData();
               _loc4_.cpid = param1.copy[_loc5_].@cpid;
               _loc4_.updateForData(_loc3_);
               _list.push(_loc4_);
            }
            _loc5_++;
         }
      }
      
      public function getCopyData(param1:int, param2:int, param3:int) : CopyDetailData
      {
         var _loc5_:int = 0;
         var _loc4_:CopyDetailData = null;
         _loc5_ = 0;
         while(_loc5_ < _list.length)
         {
            _loc4_ = _list[_loc5_];
            if(_loc4_.cpid == param1 && _loc4_.difficulty == param2 && _loc4_.stage == param3)
            {
               return _loc4_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public function setGradeData(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc2_:CopyDetailData = null;
         _loc3_ = 0;
         while(_loc3_ < _list.length)
         {
            _loc2_ = _list[_loc3_];
            if(param1.hasOwnProperty(_loc2_.cpdtlid))
            {
               _loc2_.owner_grade = param1[_loc2_.cpdtlid];
            }
            _loc3_++;
         }
      }
      
      public function countGradeByCpId(param1:int, param2:int = 1) : int
      {
         var _loc5_:int = 0;
         var _loc4_:CopyDetailData = null;
         var _loc3_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < _list.length)
         {
            _loc4_ = _list[_loc5_];
            if(_loc4_.cpid == param1 && _loc4_.difficulty == param2)
            {
               if(_loc4_.owner_grade != -1)
               {
                  _loc3_ += _loc4_.owner_grade;
               }
            }
            _loc5_++;
         }
         return _loc3_;
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
