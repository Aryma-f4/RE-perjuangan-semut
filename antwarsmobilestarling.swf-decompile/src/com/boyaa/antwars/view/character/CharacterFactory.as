package com.boyaa.antwars.view.character
{
   public class CharacterFactory
   {
      
      private static var _instance:CharacterFactory = null;
      
      private var list:Vector.<Character> = new Vector.<Character>();
      
      private var length:uint = 8;
      
      private var assets:ResAssetManager;
      
      public function CharacterFactory(param1:Single)
      {
         super();
         assets = Assets.sAsset;
      }
      
      public static function get instance() : CharacterFactory
      {
         if(_instance == null)
         {
            _instance = new CharacterFactory(new Single());
         }
         return _instance;
      }
      
      public function checkOutCharacter(param1:int = 0) : Character
      {
         var _loc2_:String = "";
         if(param1)
         {
            _loc2_ = "ant_girl";
         }
         else
         {
            _loc2_ = "ant_boy";
         }
         var _loc3_:Character = new Character(assets.buildArmature(_loc2_));
         _loc3_.sex = param1;
         clean(_loc3_);
         return _loc3_;
      }
      
      public function checkInCharacter(param1:Character) : void
      {
         param1 = null;
      }
      
      private function clean(param1:Character) : void
      {
         param1.scaleX = param1.scaleY = 0.3;
         param1.charWidth = 80;
         param1.charHeight = 100;
         param1.shootSignal.removeAll();
      }
      
      public function dispose() : void
      {
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
