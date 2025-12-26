package com.boyaa.antwars.view.screen.battlefield.ui.items
{
   import com.boyaa.antwars.data.model.GoodsData;
   
   public class UseWeaponData
   {
      
      private var _weaponData:GoodsData;
      
      private var _isUseful:Boolean = false;
      
      public function UseWeaponData(param1:GoodsData)
      {
         super();
         _weaponData = param1;
      }
      
      public function get weaponData() : GoodsData
      {
         return _weaponData;
      }
   }
}

