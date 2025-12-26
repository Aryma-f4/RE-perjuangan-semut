package com.boyaa.antwars.data.model
{
   public class CopyDetailData
   {
      
      private var _cpid:int = 0;
      
      private var _cpdtlid:int = 0;
      
      private var _difficulty:int = 0;
      
      private var _stage:int = 0;
      
      private var _mapid:int = 0;
      
      private var _winCondition:String = "";
      
      private var _loseCondition:String = "";
      
      private var _powerTips:int = 0;
      
      private var _taskTips:String = "";
      
      private var _taskContent:String = "";
      
      private var _monsterList:Vector.<CopyMonster>;
      
      private var _owner_grade:int = -1;
      
      public function CopyDetailData()
      {
         super();
      }
      
      public function updateForData(param1:XML) : void
      {
         var _loc2_:CopyMonster = null;
         _cpdtlid = int(param1["cpdtlid"]);
         _difficulty = int(param1["difficulty"]);
         _stage = int(param1["stage"]);
         _mapid = int(param1["mapid"]);
         _winCondition = param1["passcondition"];
         _loseCondition = param1["failcondition"];
         _powerTips = int(param1["powertips"]);
         _taskTips = param1["tasktips"];
         _taskContent = param1["taskcontent"];
         _monsterList = new Vector.<CopyMonster>();
         for each(var _loc3_ in param1.roles[0].role)
         {
            _loc2_ = new CopyMonster();
            _loc2_.updateForData(_loc3_);
            _monsterList.push(_loc2_);
         }
      }
      
      public function get cpdtlid() : int
      {
         return _cpdtlid;
      }
      
      public function get difficulty() : int
      {
         return _difficulty;
      }
      
      public function get stage() : int
      {
         return _stage;
      }
      
      public function get mapid() : int
      {
         return _mapid;
      }
      
      public function get winCondition() : String
      {
         return _winCondition;
      }
      
      public function get loseCondition() : String
      {
         return _loseCondition;
      }
      
      public function get powerTips() : int
      {
         return _powerTips;
      }
      
      public function get taskTips() : String
      {
         return _taskTips;
      }
      
      public function get taskContent() : String
      {
         return _taskContent;
      }
      
      public function get monsterList() : Vector.<CopyMonster>
      {
         return _monsterList;
      }
      
      public function get cpid() : int
      {
         return _cpid;
      }
      
      public function set cpid(param1:int) : void
      {
         _cpid = param1;
      }
      
      public function get owner_grade() : int
      {
         return _owner_grade;
      }
      
      public function set owner_grade(param1:int) : void
      {
         _owner_grade = param1;
      }
   }
}

