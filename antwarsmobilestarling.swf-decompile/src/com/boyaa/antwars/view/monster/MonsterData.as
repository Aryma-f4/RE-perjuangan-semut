package com.boyaa.antwars.view.monster
{
   public class MonsterData
   {
      
      private static var _instance:MonsterData;
      
      public var DATA_TYPE:Array;
      
      public var DATA_XML:Array;
      
      public function MonsterData()
      {
         super();
         DATA_TYPE = ["roleid","spiece_type","blood","isBoss","influ_through","attack_type","attack_dist","max_move","monster_width","monster_height","attr"];
         DATA_XML = ["roleid","spiece_type","blood","isBoss","influ_through","attack_type","attack_dist","max_move","width","height","attr"];
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
