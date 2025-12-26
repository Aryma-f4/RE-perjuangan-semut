package com.boyaa.antwars.data
{
   import com.boyaa.antwars.data.model.CopyMonsterRole;
   
   public class CopyMonsterRoleList
   {
      
      private static var _instance:CopyMonsterRoleList = null;
      
      private var _list:Vector.<CopyMonsterRole>;
      
      public function CopyMonsterRoleList(param1:Single)
      {
         super();
         _list = new Vector.<CopyMonsterRole>();
      }
      
      public static function get instance() : CopyMonsterRoleList
      {
         if(_instance == null)
         {
            _instance = new CopyMonsterRoleList(new Single());
         }
         return _instance;
      }
      
      public function loadData(param1:XML) : void
      {
         var _loc2_:CopyMonsterRole = null;
         for each(var _loc3_ in param1.roleinfo)
         {
            _loc2_ = new CopyMonsterRole();
            _loc2_.updateForData(_loc3_);
            _list.push(_loc2_);
         }
      }
      
      public function getRoleById(param1:int) : CopyMonsterRole
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _list.length)
         {
            if(_list[_loc2_].roleid == param1)
            {
               return _list[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getRoleBySpieceType(param1:int) : CopyMonsterRole
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _list.length)
         {
            if(_list[_loc2_].spiece_type == param1)
            {
               return _list[_loc2_];
            }
            _loc2_++;
         }
         return null;
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
