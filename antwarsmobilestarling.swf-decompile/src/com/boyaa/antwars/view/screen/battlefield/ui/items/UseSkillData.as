package com.boyaa.antwars.view.screen.battlefield.ui.items
{
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.model.FightGoodsData;
   
   public class UseSkillData
   {
      
      private var _id:int = 0;
      
      private var _fightGoods:FightGoodsData;
      
      private var _isEnable:Boolean = true;
      
      public function UseSkillData(param1:int)
      {
         super();
         _id = param1;
         _fightGoods = GoodsList.instance.getFightDataByID(_id);
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function get isEnable() : Boolean
      {
         return _isEnable;
      }
      
      public function set isEnable(param1:Boolean) : void
      {
         _isEnable = param1;
      }
      
      public function get fightGoods() : FightGoodsData
      {
         return _fightGoods;
      }
   }
}

