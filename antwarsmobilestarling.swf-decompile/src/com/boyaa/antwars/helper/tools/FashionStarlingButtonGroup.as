package com.boyaa.antwars.helper.tools
{
   import org.osflash.signals.Signal;
   
   public class FashionStarlingButtonGroup
   {
      
      private static var _changeSignal:Signal;
      
      private static var _buttons:Object = {};
      
      public function FashionStarlingButtonGroup()
      {
         super();
      }
      
      private static function init() : void
      {
         if(_changeSignal)
         {
            return;
         }
         _changeSignal = new Signal(FashionStarlingButton);
         _changeSignal.add(signalHandle);
         _buttons = {};
      }
      
      private static function signalHandle(param1:FashionStarlingButton) : void
      {
         var _loc2_:Array = null;
         var _loc4_:int = 0;
         var _loc3_:FashionStarlingButton = null;
         if(_buttons[param1.groupTag])
         {
            _loc2_ = _buttons[param1.groupTag];
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_] as FashionStarlingButton;
               _loc3_.isSelect = false;
               _loc4_++;
            }
            param1.isSelect = true;
         }
      }
      
      public static function addButtonToGroup(param1:String, param2:FashionStarlingButton) : void
      {
         init();
         if(!_buttons.hasOwnProperty(param1))
         {
            _buttons[param1] = [];
         }
         var _loc3_:Array = _buttons[param1];
         _loc3_.push(param2);
      }
      
      public static function get changeSignal() : Signal
      {
         return _changeSignal;
      }
   }
}

