package com.boyaa.antwars.view.game
{
   import com.boyaa.antwars.view.screen.battlefield.BtMap;
   import com.boyaa.antwars.view.screen.battlefield.BtUILayer;
   import com.joeonmars.camerafocus.StarlingCameraFocus;
   import starling.display.Sprite;
   
   public interface IGameWorld
   {
      
      function getGameLayer() : Sprite;
      
      function get UILayer() : BtUILayer;
      
      function get mapCtrlByTouch() : Boolean;
      
      function set mapCtrlByTouch(param1:Boolean) : void;
      
      function get ctrlInfoLayer() : Sprite;
      
      function get charatersBGLayer() : Sprite;
      
      function get charatersLayer() : Sprite;
      
      function get mapBackCharatersLayer() : Sprite;
      
      function getMap() : BtMap;
      
      function get camera() : StarlingCameraFocus;
      
      function cameraFocusCtrlByTouch(param1:Boolean) : void;
      
      function addHp(param1:Array) : void;
      
      function get totalCDCount() : int;
      
      function getMoveButton() : Sprite;
   }
}

