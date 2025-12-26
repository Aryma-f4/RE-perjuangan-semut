package com.boyaa.antwars.view.game
{
   public interface ICharacterCtrl
   {
      
      function get gameworld() : IGameWorld;
      
      function get siteID() : int;
      
      function playCry(param1:Number = 1) : void;
      
      function get icharacter() : ICharacter;
      
      function get downStatus() : Boolean;
      
      function set downStatus(param1:Boolean) : void;
      
      function set hp(param1:int) : void;
      
      function get hp() : int;
      
      function get roleAttr() : Array;
      
      function get hurtfactor() : int;
      
      function get hurtplus() : int;
      
      function get isUseAnger() : Boolean;
   }
}

