package com.boyaa.antwars.data.model.mission
{
   public class SubMissionData
   {
      
      private var _smsid:int;
      
      private var _actioncode:int;
      
      private var _target:String = "";
      
      private var _pcate:int;
      
      private var _pframe:int;
      
      private var _times:int;
      
      private var _completed:int;
      
      private var _isFinished:Boolean;
      
      private var _isdel:int = 0;
      
      public function SubMissionData()
      {
         super();
      }
      
      public function get smsid() : int
      {
         return _smsid;
      }
      
      public function set smsid(param1:int) : void
      {
         _smsid = param1;
      }
      
      public function get actioncode() : int
      {
         return _actioncode;
      }
      
      public function set actioncode(param1:int) : void
      {
         _actioncode = param1;
      }
      
      public function get target() : String
      {
         return _target;
      }
      
      public function set target(param1:String) : void
      {
         _target = param1;
      }
      
      public function get pcate() : int
      {
         return _pcate;
      }
      
      public function set pcate(param1:int) : void
      {
         _pcate = param1;
      }
      
      public function get pframe() : int
      {
         return _pframe;
      }
      
      public function set pframe(param1:int) : void
      {
         _pframe = param1;
      }
      
      public function get times() : int
      {
         return _times;
      }
      
      public function set times(param1:int) : void
      {
         _times = param1;
      }
      
      public function get completed() : int
      {
         return _completed;
      }
      
      public function set completed(param1:int) : void
      {
         _completed = param1;
      }
      
      public function get isFinished() : Boolean
      {
         return _isFinished;
      }
      
      public function set isFinished(param1:Boolean) : void
      {
         _isFinished = param1;
      }
      
      public function get isdel() : int
      {
         return _isdel;
      }
      
      public function set isdel(param1:int) : void
      {
         _isdel = param1;
      }
   }
}

