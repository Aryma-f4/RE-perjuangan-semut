package com.boyaa.antwars.view.ui.layout
{
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.text.TextField;
   
   public class EasyFunctions extends EventDispatcher
   {
      
      protected var _displayObj:Sprite;
      
      public function EasyFunctions(param1:Sprite)
      {
         super();
         _displayObj = param1;
         _displayObj.addEventListener("removed",onRemove);
         initialization();
      }
      
      private function onRemove(param1:Event) : void
      {
         _displayObj.removeEventListener("removed",onRemove);
         dispose();
      }
      
      protected function initialization() : void
      {
      }
      
      public function dispose() : void
      {
      }
      
      public function getDisplayObjectByName(param1:String, param2:Sprite = null) : DisplayObject
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1);
         }
         return param2.getChildByName(param1);
      }
      
      public function getTextFieldByName(param1:String, param2:Sprite = null) : TextField
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1) as TextField;
         }
         return param2.getChildByName(param1) as TextField;
      }
      
      public function getButtonByName(param1:String, param2:Sprite = null) : Button
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1) as Button;
         }
         return param2.getChildByName(param1) as Button;
      }
      
      public function getSpriteByName(param1:String, param2:Sprite = null) : Sprite
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1) as Sprite;
         }
         return param2.getChildByName(param1) as Sprite;
      }
      
      public function get displayObj() : Sprite
      {
         return _displayObj;
      }
      
      public function showScale(param1:Number = 1) : void
      {
         _displayObj.scaleX = _displayObj.scaleY = param1;
      }
   }
}

