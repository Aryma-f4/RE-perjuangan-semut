package com.boyaa.antwars.data.model
{
   import com.boyaa.antwars.helper.StringUtil;
   
   public class CopyMonsterRole
   {
      
      private var _roleid:int;
      
      private var _rolename:String;
      
      private var _roledesc:String;
      
      private var _blood:int;
      
      private var _isBoss:int;
      
      private var _remake:String;
      
      private var _influ_through:int;
      
      private var _attack_type:int;
      
      private var _attack_dist:int;
      
      private var _max_move:int;
      
      private var _width:int;
      
      private var _height:int;
      
      private var _spiece_type:int;
      
      private var _attr:Array = [];
      
      private const DATA_TYPE:Array = ["roleid","rolename","spiece_type","roledesc","blood","isBoss","remake","influ_through","attack_type","attack_dist","max_move","width","height"];
      
      private const DATA_XML:Array = ["roleid","rolename","spiece_type","roledesc","blood","isBoss","remake","influ_through","attack_type","attack_dist","max_move","width","height"];
      
      public function CopyMonsterRole()
      {
         super();
      }
      
      public function updateForData(param1:XML) : void
      {
         var _loc5_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < DATA_TYPE.length)
         {
            if(this["_" + DATA_TYPE[_loc5_]] is int)
            {
               this["_" + DATA_TYPE[_loc5_]] = int(param1[DATA_XML[_loc5_]]);
            }
            else if(this["_" + DATA_TYPE[_loc5_]] is String)
            {
               this["_" + DATA_TYPE[_loc5_]] = StringUtil.trim(param1[DATA_XML[_loc5_]]);
            }
            else
            {
               this["_" + DATA_TYPE[_loc5_]] = param1[DATA_XML[_loc5_]];
            }
            _loc5_++;
         }
         for each(var _loc4_ in param1.ats[0].at)
         {
            this._attr.push(int(_loc4_.@value));
         }
         var _loc3_:RegExp = /([a-zA-Z]{1,})/g;
         var _loc2_:Object = _loc3_.exec(_remake);
         _remake = _loc2_[0];
      }
      
      public function get roleid() : int
      {
         return _roleid;
      }
      
      public function get rolename() : String
      {
         return _rolename;
      }
      
      public function get roledesc() : String
      {
         return _roledesc;
      }
      
      public function get blood() : int
      {
         return _blood;
      }
      
      public function get isBoss() : int
      {
         return _isBoss;
      }
      
      public function get remake() : String
      {
         return _remake;
      }
      
      public function get influ_through() : int
      {
         return _influ_through;
      }
      
      public function get attack_type() : int
      {
         return _attack_type;
      }
      
      public function get attack_dist() : int
      {
         return _attack_dist;
      }
      
      public function get max_move() : int
      {
         return _max_move;
      }
      
      public function get width() : int
      {
         return _width;
      }
      
      public function get height() : int
      {
         return _height;
      }
      
      public function get attr() : Array
      {
         return _attr;
      }
      
      public function get spiece_type() : int
      {
         return _spiece_type;
      }
   }
}

