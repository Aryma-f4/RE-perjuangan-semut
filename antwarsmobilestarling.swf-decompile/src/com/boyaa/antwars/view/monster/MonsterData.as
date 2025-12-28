package com.boyaa.antwars.view.monster
{
   public dynamic class MonsterData
   {
      
      private static var _instance:MonsterData;
      
      public var DATA_TYPE:Array;
      
      public var DATA_XML:Array;
      
      // Public properties matching error log
      public var blood:int;
      public var influ_through:int;
      public var attack_type:int;
      public var attack_dist:int;
      public var max_move:int;
      public var monster_width:int;
      public var monster_height:int;
      public var spiece_type:int;
      public var attr:Array;
      public var move_speed:Number;
      public var isfly:Boolean;
      public var roleid:int;
      public var isBoss:int;

      // Fix: Constructor accepts optional parameter to match usage in SmallCodeTools
      public function MonsterData(data:Object = null)
      {
         super();
         DATA_TYPE = ["roleid","spiece_type","blood","isBoss","influ_through","attack_type","attack_dist","max_move","monster_width","monster_height","attr"];
         DATA_XML = ["roleid","spiece_type","blood","isBoss","influ_through","attack_type","attack_dist","max_move","width","height","attr"];

         if (data)
         {
             updateData(data);
         }
      }

      public function updateData(data:Object):void
      {
          // Simple mapping based on known structure
          if (data.hasOwnProperty("roleid")) this.roleid = int(data.roleid);
          if (data.hasOwnProperty("spiece_type")) this.spiece_type = int(data.spiece_type);
          if (data.hasOwnProperty("blood")) this.blood = int(data.blood);
          if (data.hasOwnProperty("isBoss")) this.isBoss = int(data.isBoss);
          if (data.hasOwnProperty("influ_through")) this.influ_through = int(data.influ_through);
          if (data.hasOwnProperty("attack_type")) this.attack_type = int(data.attack_type);
          if (data.hasOwnProperty("attack_dist")) this.attack_dist = int(data.attack_dist);
          if (data.hasOwnProperty("max_move")) this.max_move = int(data.max_move);
          if (data.hasOwnProperty("monster_width")) this.monster_width = int(data.monster_width);
          if (data.hasOwnProperty("monster_height")) this.monster_height = int(data.monster_height);
          if (data.hasOwnProperty("attr")) this.attr = data.attr as Array;
      }
      
      public static function get instance() : MonsterData
      {
         if(!_instance)
         {
            _instance = new MonsterData();
         }
         return _instance;
      }
   }
}
