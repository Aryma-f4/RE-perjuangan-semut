package com.boyaa.antwars.view.screen.battlefield.ui
{
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import starling.display.Button;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   
   public class MultiStateButton extends EventDispatcher
   {
      
      public static const BUTTON_TOUCH:String = "buttonTouch";
      
      private var _buttonArr:Vector.<FashionStarlingButton>;
      
      private var _lastIndex:int;
      
      private var _isGray:Boolean = false;
      
      public function MultiStateButton(param1:Array)
      {
         var _loc4_:int = 0;
         var _loc2_:Button = null;
         var _loc3_:FashionStarlingButton = null;
         super();
         _buttonArr = new Vector.<FashionStarlingButton>();
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = param1[_loc4_];
            _loc3_ = new FashionStarlingButton(_loc2_);
            _buttonArr.push(_loc3_);
            _loc3_.triggerFunction = onButtonClickHandle;
            if(_loc4_ != 0)
            {
               _loc3_.starlingBtn.visible = false;
            }
            _loc4_++;
         }
         init();
      }
      
      private function onButtonClickHandle(param1:Event) : void
      {
         var _loc2_:* = 0;
         var _loc4_:int = 0;
         var _loc3_:Button = param1.target as Button;
         _loc4_ = 0;
         while(_loc4_ < _buttonArr.length)
         {
            if(_buttonArr[_loc4_].starlingBtn == _loc3_)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc4_++;
         }
         dispatchEventWith("buttonTouch",false,{
            "idx":_loc2_,
            "button":_buttonArr[_loc4_]
         });
      }
      
      private function init() : void
      {
      }
      
      public function showButtonById(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _buttonArr.length)
         {
            _buttonArr[_loc2_].starlingBtn.visible = false;
            _loc2_++;
         }
         _buttonArr[param1].starlingBtn.visible = true;
      }
      
      public function getButtonById(param1:int) : FashionStarlingButton
      {
         return _buttonArr[param1];
      }
      
      public function get isGray() : Boolean
      {
         return _isGray;
      }
      
      public function set isGray(param1:Boolean) : void
      {
         _isGray = param1;
         for each(var _loc2_ in _buttonArr)
         {
            _loc2_.isGray = _isGray;
         }
      }
   }
}

