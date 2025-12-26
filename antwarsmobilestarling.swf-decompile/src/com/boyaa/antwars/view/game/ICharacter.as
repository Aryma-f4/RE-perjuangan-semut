package com.boyaa.antwars.view.game
{
   import com.boyaa.antwars.view.screen.battlefield.BtMap;
   import flash.geom.Rectangle;
   
   public interface ICharacter
   {
      
      function get icharacterCtrl() : ICharacterCtrl;
      
      function get x() : Number;
      
      function get y() : Number;
      
      function get bitmapRectangle() : Rectangle;
      
      function hitMap(param1:int, param2:int, param3:BtMap) : Boolean;
      
      function get canHit() : Boolean;
   }
}

