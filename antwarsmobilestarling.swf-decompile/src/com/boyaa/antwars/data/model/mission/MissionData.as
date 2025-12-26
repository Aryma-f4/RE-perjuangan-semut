package com.boyaa.antwars.data.model.mission
{
   public class MissionData
   {
      
      public static const LV_STR:Array = ["-","A","B","C","D","S"];
      
      private var _mtype:int;
      
      private var _dataBaseID:int = 0;
      
      private var _msid:int;
      
      private var _msname:String;
      
      private var _mtarget:String = "";
      
      private var _mdesc:String;
      
      private var _experience:String;
      
      private var _gxz:String;
      
      private var _exCertificate:String;
      
      private var _coin:String;
      
      private var _hot:String;
      
      private var _submissions:Array = [];
      
      private var _rewards:Array = [];
      
      private var _isFinished:Boolean;
      
      private var _isRewarded:Boolean;
      
      private var _isCurMission:Boolean;
      
      private var _isNew:Boolean = true;
      
      private var _level:int;
      
      public function MissionData()
      {
         super();
      }
      
      public function get mtype() : int
      {
         return _mtype;
      }
      
      public function set mtype(param1:int) : void
      {
         _mtype = param1;
      }
      
      public function get msid() : int
      {
         return _msid;
      }
      
      public function set msid(param1:int) : void
      {
         _msid = param1;
      }
      
      public function get msname() : String
      {
         return _msname;
      }
      
      public function set msname(param1:String) : void
      {
         _msname = param1;
      }
      
      public function get mtarget() : String
      {
         return _mtarget;
      }
      
      public function set mtarget(param1:String) : void
      {
         _mtarget = param1;
      }
      
      public function get mdesc() : String
      {
         return _mdesc;
      }
      
      public function set mdesc(param1:String) : void
      {
         _mdesc = param1;
      }
      
      public function get experience() : String
      {
         return _experience;
      }
      
      public function set experience(param1:String) : void
      {
         _experience = param1;
      }
      
      public function get exCertificate() : String
      {
         return _exCertificate;
      }
      
      public function set exCertificate(param1:String) : void
      {
         _exCertificate = param1;
      }
      
      public function get coin() : String
      {
         return _coin;
      }
      
      public function set coin(param1:String) : void
      {
         _coin = param1;
      }
      
      public function get submissions() : Array
      {
         return _submissions;
      }
      
      public function set submissions(param1:Array) : void
      {
         _submissions = param1;
      }
      
      public function get rewards() : Array
      {
         return _rewards;
      }
      
      public function set rewards(param1:Array) : void
      {
         _rewards = param1;
      }
      
      public function get isFinished() : Boolean
      {
         for each(var _loc1_ in submissions)
         {
            if(!_loc1_.isFinished)
            {
               return false;
            }
         }
         return true;
      }
      
      public function set isFinished(param1:Boolean) : void
      {
         for each(var _loc2_ in submissions)
         {
            _loc2_.isFinished = true;
         }
      }
      
      public function get isRewarded() : Boolean
      {
         return _isRewarded;
      }
      
      public function set isRewarded(param1:Boolean) : void
      {
         _isRewarded = param1;
      }
      
      public function get isCurMission() : Boolean
      {
         return _isCurMission;
      }
      
      public function set isCurMission(param1:Boolean) : void
      {
         _isCurMission = param1;
      }
      
      public function get isNew() : Boolean
      {
         return _isNew;
      }
      
      public function set isNew(param1:Boolean) : void
      {
         _isNew = param1;
      }
      
      public function get dataBaseID() : int
      {
         return _dataBaseID;
      }
      
      public function set dataBaseID(param1:int) : void
      {
         _dataBaseID = param1;
      }
      
      public function get gxz() : String
      {
         return _gxz;
      }
      
      public function set gxz(param1:String) : void
      {
         _gxz = param1;
      }
      
      public function get hot() : String
      {
         return _hot;
      }
      
      public function set hot(param1:String) : void
      {
         _hot = param1;
      }
      
      public function get level() : int
      {
         return _level;
      }
      
      public function set level(param1:int) : void
      {
         _level = param1;
      }
   }
}

