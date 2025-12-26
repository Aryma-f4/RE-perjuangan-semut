package com.boyaa.antwars.view.screen.battlefield.ui
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.view.screen.battlefield.BtUILayer;
   import com.boyaa.antwars.view.screen.fresh.FreshGameWorld;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import com.boyaa.antwars.view.ui.layout.EasyFunctions;
   import org.osflash.signals.Signal;
   import starling.display.Button;
   import starling.display.Sprite;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class NewDirectionControl extends EasyFunctions
   {
      
      public static const UP:int = 0;
      
      public static const DOWN:int = 1;
      
      public static const LEFT:int = 2;
      
      public static const RIGHT:int = 3;
      
      private static var _keyArr:Array = [0,0,0,0];
      
      public static var controlSignal:Signal = new Signal(Array);
      
      private var _leftBtn:Button;
      
      private var _rightBtn:Button;
      
      private var _upBtn:Button;
      
      private var _downBtn:Button;
      
      private var _buttonNameArr:Array = ["upBtn","downBtn","leftBtn","rightBtn"];
      
      private var _uiLayer:BtUILayer;
      
      private var _currentGuideData:Array = [];
      
      public function NewDirectionControl(param1:Sprite)
      {
         super(param1);
      }
      
      public static function getDirectionValue(param1:int) : int
      {
         return _keyArr[param1];
      }
      
      override protected function initialization() : void
      {
         var _loc1_:int = 0;
         super.initialization();
         _loc1_ = 0;
         while(_loc1_ < _buttonNameArr.length)
         {
            this["_" + _buttonNameArr[_loc1_]] = getButtonByName(_buttonNameArr[_loc1_]);
            Button(this["_" + _buttonNameArr[_loc1_]]).addEventListener("touch",onDirectinButtonTouch);
            _loc1_++;
         }
         _displayObj.x = Assets.leftTop.x;
         SmallCodeTools.instance.setDisplayObjectInWidthScreen("left",_displayObj);
         _keyArr = [0,0,0,0];
         if(Constants.isFresh)
         {
            EventCenter.GameEvent.addEventListener("freshGame",onFreshGameHandle);
         }
      }
      
      private function onFreshGameHandle(param1:GameEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Array = param1.param as Array;
         _currentGuideData = _loc2_;
         switch(_loc2_[0])
         {
            case "getWeapon1":
               GuideTipManager.instance.showByDisplayObject(rightBtn);
               break;
            case "turnLeft":
               GuideTipManager.instance.showByDisplayObject(leftBtn);
               break;
            case "turnRight":
               GuideTipManager.instance.showByDisplayObject(rightBtn);
               break;
            case "changeAngle":
               _loc3_ = Number(FreshGameWorld(_uiLayer.getGameWorld()).selfCharacterCtrl.character.angle);
               if(_loc3_ > 90)
               {
                  if(_loc3_ > _loc2_[1])
                  {
                     GuideTipManager.instance.showByDisplayObject(upBtn);
                     break;
                  }
                  GuideTipManager.instance.showByDisplayObject(downBtn);
                  break;
               }
               if(_loc3_ > _loc2_[1])
               {
                  GuideTipManager.instance.showByDisplayObject(downBtn);
                  break;
               }
               GuideTipManager.instance.showByDisplayObject(upBtn);
         }
      }
      
      private function onDirectinButtonTouch(param1:TouchEvent) : void
      {
         var _loc3_:Button = null;
         var _loc2_:int = 0;
         if(!(param1.target is Button))
         {
            return;
         }
         var _loc4_:Touch = param1.getTouch(param1.target as Button);
         if(!_loc4_)
         {
            return;
         }
         if(param1.target is Button)
         {
            _loc3_ = param1.target as Button;
            _loc2_ = int(_buttonNameArr.indexOf(_loc3_.name));
            if(_loc2_ != -1)
            {
               if(_loc4_.phase == "began")
               {
                  _keyArr[_loc2_] = 1;
                  trace(_loc3_.name,"touching");
                  EventCenter.GameEvent.dispatchEvent(new GameEvent("moveControl",["start",_loc2_]));
                  if(_loc2_ == 2 && _currentGuideData[0] == "turnLeft" || _loc2_ == 3 && _currentGuideData[0] == "turnRight")
                  {
                     EventCenter.GameEvent.dispatchEvent(new GameEvent("freshGuideComplete"));
                  }
               }
               if(_loc4_.phase == "ended")
               {
                  _keyArr[_loc2_] = 0;
                  EventCenter.GameEvent.dispatchEvent(new GameEvent("moveControl",["end",_loc2_]));
                  trace(_loc3_.name,"stop touch");
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         NewDirectionControl.controlSignal.removeAll();
      }
      
      public function get leftBtn() : Button
      {
         return _leftBtn;
      }
      
      public function get rightBtn() : Button
      {
         return _rightBtn;
      }
      
      public function get upBtn() : Button
      {
         return _upBtn;
      }
      
      public function get downBtn() : Button
      {
         return _downBtn;
      }
      
      public function get uiLayer() : BtUILayer
      {
         return _uiLayer;
      }
      
      public function set uiLayer(param1:BtUILayer) : void
      {
         _uiLayer = param1;
      }
   }
}

