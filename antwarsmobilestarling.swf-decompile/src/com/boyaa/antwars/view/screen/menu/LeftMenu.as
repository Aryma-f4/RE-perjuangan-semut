package com.boyaa.antwars.view.screen.menu
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.view.ui.layout.EasyFunctions;
   import flash.utils.Dictionary;
   import starling.display.Button;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class LeftMenu extends EasyFunctions
   {
      
      public static const MESSAGEBUTTON:String = "chatBtn";
      
      public static const EMOTIONBUTTON:String = "emotionBtn";
      
      private var _chatBtn:MenuButton;
      
      private var _emotionBtn:MenuButton;
      
      private var _buttonsNameArr:Array = ["chatBtn","emotionBtn"];
      
      private var _buttons:Dictionary = new Dictionary();
      
      public function LeftMenu(param1:Sprite)
      {
         super(param1);
      }
      
      override protected function initialization() : void
      {
         super.initialization();
         initButtons();
      }
      
      private function onButtonTouchHandle(param1:Event) : void
      {
         var _loc3_:Button = param1.target as Button;
         var _loc2_:MenuButton = _buttons[_loc3_.name][0];
         var _loc4_:Object = {"menuButton":_loc2_};
         EventCenter.GameEvent.dispatchEvent(new GameEvent("menuButtonTouch",_loc4_));
      }
      
      private function initButtons() : void
      {
         var _loc2_:int = 0;
         var _loc1_:MenuButton = null;
         _loc2_ = 0;
         while(_loc2_ < _buttonsNameArr.length)
         {
            this["_" + _buttonsNameArr[_loc2_]] = new MenuButton(getButtonByName(_buttonsNameArr[_loc2_]));
            _loc1_ = this["_" + _buttonsNameArr[_loc2_]];
            _loc1_.triggerFunction = onButtonTouchHandle;
            _buttons[_buttonsNameArr[_loc2_]] = [_loc1_,_loc1_.starlingBtn.x,_loc1_.starlingBtn.y];
            _loc2_++;
         }
      }
      
      public function showMenuItems(param1:Array, param2:Boolean = true) : void
      {
         var _loc3_:MenuButton = null;
         var _loc5_:int = 0;
         var _loc4_:Array = [];
         if(param1 == null)
         {
            for each(_loc4_ in _buttons)
            {
               _loc3_ = _loc4_[0];
               _loc3_.starlingBtn.visible = param2;
            }
         }
         else
         {
            for each(_loc4_ in _buttons)
            {
               _loc3_ = _loc4_[0];
               _loc3_.starlingBtn.visible = !param2;
            }
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               MenuButton(_buttons[param1[_loc5_]][0]).starlingBtn.visible = param2;
               _loc5_++;
            }
         }
      }
      
      public function get chatBtn() : MenuButton
      {
         return _chatBtn;
      }
      
      public function get emotionBtn() : MenuButton
      {
         return _emotionBtn;
      }
   }
}

