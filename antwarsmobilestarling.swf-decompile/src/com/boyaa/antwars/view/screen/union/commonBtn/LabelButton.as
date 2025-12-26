package com.boyaa.antwars.view.screen.union.commonBtn
{
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import feathers.display.Scale9Image;
   import starling.display.DisplayObjectContainer;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class LabelButton extends DisplayObjectContainer
   {
      
      public static var LAYOUT:LayoutUitl;
      
      private var _btnStyle:LabelButtonStyle;
      
      private var _bg:Scale9Image;
      
      private var _overBg:Scale9Image;
      
      private var _labelTextField:TextField;
      
      private var _label:String;
      
      private var _enabled:Boolean;
      
      private var _isDown:Boolean;
      
      public function LabelButton(param1:String, param2:int = 100, param3:int = 78, param4:String = "yellow", param5:int = 30)
      {
         super();
         _label = param1;
         switch(param4)
         {
            case LabelButtonStyle.YELLOW:
               _btnStyle = LabelButtonStyle.YELLOW_STYLE;
               break;
            case LabelButtonStyle.GREEN:
               _btnStyle = LabelButtonStyle.GREEN_STYLE;
               break;
            default:
               _btnStyle = LabelButtonStyle.YELLOW_STYLE;
         }
         _btnStyle.fontSize = param5;
         _labelTextField = new TextField(param2 - 5,param3 - 5,"temp","Verdana",param5,16777215,true);
         _labelTextField.text = param1;
         _labelTextField.autoScale = true;
         _bg = LAYOUT.createS9Image(_btnStyle.commonImg);
         _overBg = LAYOUT.createS9Image(_btnStyle.overImg);
         addChild(_bg);
         addChild(_overBg);
         _overBg.width = _bg.width = param2;
         _overBg.height = _bg.height = param3;
         addChild(_labelTextField);
         addEventListener("touch",onTouch);
         _enabled = true;
         isDown = false;
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(!_enabled || _loc2_ == null)
         {
            return;
         }
         if(_loc2_.phase == "began" && !isDown)
         {
            isDown = true;
         }
         else if(_loc2_.phase == "moved" && isDown)
         {
            isDown = false;
         }
         else if(_loc2_.phase == "ended" && isDown)
         {
            isDown = false;
            dispatchEventWith("triggered",true);
         }
      }
      
      public function get label() : String
      {
         return _label;
      }
      
      public function set label(param1:String) : void
      {
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         _enabled = param1;
      }
      
      public function get isDown() : Boolean
      {
         return _isDown;
      }
      
      public function set isDown(param1:Boolean) : void
      {
         _isDown = param1;
         if(_isDown)
         {
            _bg.visible = false;
            _overBg.visible = true;
         }
         else
         {
            _bg.visible = true;
            _overBg.visible = false;
         }
      }
   }
}

