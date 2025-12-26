package com.boyaa.antwars.view.screen.battlefield.ui
{
   import com.boyaa.antwars.view.ui.layout.EasyFunctions;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   
   public class NewHpBar extends EasyFunctions
   {
      
      private var _hp:int = 0;
      
      private var _maxHp:int = 0;
      
      private var _hpBar:DisplayObject;
      
      public function NewHpBar(param1:Sprite, param2:int)
      {
         super(param1);
         _maxHp = param2;
         hp = param2;
      }
      
      override protected function initialization() : void
      {
         super.initialization();
         _hpBar = getDisplayObjectByName("hpBar");
      }
      
      public function get hp() : int
      {
         return _hp;
      }
      
      public function set hp(param1:int) : void
      {
         _hp = param1;
         _hpBar.scaleX = Math.max(0,Math.min(1,_hp / _maxHp));
      }
   }
}

