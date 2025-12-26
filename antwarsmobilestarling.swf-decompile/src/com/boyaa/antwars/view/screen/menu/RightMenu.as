package com.boyaa.antwars.view.screen.menu
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.view.ui.layout.EasyFunctions;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class RightMenu extends EasyFunctions
   {
      
      public static const EXCHANGEBUTTON:String = "exchangeBtn";
      
      public static const BACKPACKBUTTON:String = "backPackBtn";
      
      public static const MISSIONBUTTON:String = "missionBtn";
      
      public static const EMAILBUTTON:String = "emailBtn";
      
      public static const FRIENDBUTTON:String = "friendBtn";
      
      public static const SETBUTTON:String = "setBtn";
      
      public static const MENUBUTTON:String = "menuBtn";
      
      private var _exchangeBtn:MenuButton;
      
      private var _backPackBtn:MenuButton;
      
      private var _missionBtn:MenuButton;
      
      private var _emailBtn:MenuButton;
      
      private var _friendBtn:MenuButton;
      
      private var _setBtn:MenuButton;
      
      private var _menuBtn:MenuButton;
      
      private var _buttons:Dictionary = new Dictionary();
      
      private var _buttonNameArr:Array = ["exchangeBtn","backPackBtn","missionBtn","emailBtn","friendBtn","setBtn","menuBtn"];
      
      public function RightMenu(param1:Sprite)
      {
         super(param1);
      }
      
      override protected function initialization() : void
      {
         super.initialization();
         initButtons();
      }
      
      private function initButtons() : void
      {
         var _loc2_:int = 0;
         var _loc1_:MenuButton = null;
         _loc2_ = 0;
         while(_loc2_ < _buttonNameArr.length)
         {
            this["_" + _buttonNameArr[_loc2_]] = new MenuButton(getButtonByName(_buttonNameArr[_loc2_]));
            _loc1_ = this["_" + _buttonNameArr[_loc2_]];
            _loc1_.triggerFunction = onButtonClick;
            _buttons[_buttonNameArr[_loc2_]] = [_loc1_,_loc1_.starlingBtn.x,_loc1_.starlingBtn.y];
            _loc2_++;
         }
         _loc1_.starlingBtn.pivotX = _loc1_.starlingBtn.width / 2;
         _loc1_.starlingBtn.x += _loc1_.starlingBtn.width / 2;
         _displayObj.addChild(_loc1_.starlingBtn);
      }
      
      private function onButtonClick(param1:Event) : void
      {
         var _loc3_:Button = param1.target as Button;
         var _loc2_:MenuButton = _buttons[_loc3_.name][0];
         var _loc4_:Object = {"menuButton":_loc2_};
         EventCenter.GameEvent.dispatchEvent(new GameEvent("menuButtonTouch",_loc4_));
      }
      
      public function showButtons(param1:Boolean, param2:Function = null) : void
      {
         var time:Number;
         var bool:Boolean = param1;
         var callBack:Function = param2;
         var isCall:* = function():void
         {
            if(callBack != null)
            {
               callBack();
            }
         };
         var i:int = 0;
         menuBtn.starlingBtn.scaleX *= -1;
         time = 0.5;
         if(bool)
         {
            i = 0;
            while(i < _buttonNameArr.length - 1)
            {
               Starling.juggler.tween(_buttons[_buttonNameArr[i]][0].starlingBtn,time,{
                  "alpha":1,
                  "x":_buttons[_buttonNameArr[i]][1],
                  "transition":"easeOut",
                  "onComplete":isCall
               });
               i = i + 1;
            }
         }
         else
         {
            i = 0;
            while(i < _buttonNameArr.length - 1)
            {
               Starling.juggler.tween(_buttons[_buttonNameArr[i]][0].starlingBtn,time,{
                  "alpha":0,
                  "x":menuBtn.starlingBtn.x,
                  "transition":"easeIn",
                  "onComplete":isCall
               });
               i = i + 1;
            }
         }
      }
      
      public function showMenuItems(param1:Array, param2:Boolean = true) : void
      {
         var _loc4_:* = null;
         var _loc3_:MenuButton = null;
         var _loc5_:int = 0;
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
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      public function get exchangeBtn() : MenuButton
      {
         return _exchangeBtn;
      }
      
      public function get backPackBtn() : MenuButton
      {
         return _backPackBtn;
      }
      
      public function get missionBtn() : MenuButton
      {
         return _missionBtn;
      }
      
      public function get emailBtn() : MenuButton
      {
         return _emailBtn;
      }
      
      public function get friendBtn() : MenuButton
      {
         return _friendBtn;
      }
      
      public function get setBtn() : MenuButton
      {
         return _setBtn;
      }
      
      public function get menuBtn() : MenuButton
      {
         return _menuBtn;
      }
   }
}

